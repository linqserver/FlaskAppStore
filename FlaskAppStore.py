from flask import Flask, render_template, flash, redirect, json, url_for, session, request, logging

''' *******************************************************************
    *   IF ERROR on IMPORT MySQL ext flask mysql 
    *   THEN in terminal:
    *   virtualenv yournewvirtualenv --python=/usr/bin/python3.4
    *   then
    *   pip install flask-mysql
'''
from flaskext.mysql import MySQL
from wtforms import Form, StringField, TextAreaField, PasswordField, validators
from passlib.hash import sha256_crypt
from functools import wraps

mysql = MySQL()
app = Flask(__name__)

# MySQL configurations
app.config['MYSQL_DATABASE_USER'] = 'root'
app.config['MYSQL_DATABASE_PASSWORD'] = 'root'
app.config['MYSQL_DATABASE_DB'] = 'RafalStoreDb'
app.config['MYSQL_DATABASE_HOST'] = 'localhost'
mysql.init_app(app)


basketVariable = 'images/basket_icon.png'


# this holds current number of items for a given user


# returns true if current user have items in the basket
def check_basket_status():
    # Create cursor
    conn = mysql.connect()
    cur = conn.cursor()
    user = session['username']
    cur.callproc('sp_basketCheckForContent', [user])
    bskt = cur.fetchone()
    global basketVariable
    if bskt[0] == 1:

        basketVariable = 'images/basket_icon_full2.png'
        msg = 'check_basket_status returns one'
        print(msg, bskt[0])
        conn.close()
        return [bskt]
    else:

        basketVariable = 'images/basket_icon.png'
        msg = 'check_basket_status returns zero'
        print(msg, bskt[0])
        conn.close()
        return [bskt]


# add_to_basket
def add_to_basket(id):
    # Create cursor
    conn = mysql.connect()
    cur = conn.cursor()

    # result = cur.execute("SELECT * FROM basket_table where user_name = %s", session['username'])

    # Get basket information
    # getProductsFromBasket returns: [0]prod_id ,[1]prod_name, [2]qty, [3]prod_price
    # result =
    user = session['username']

    cur.callproc('sp_basketAddProduct', [id][user])
    bskt = cur.fetchall()
    conn.close()
    if bskt > 0:
        return render_template('basket.html', products=bskt)
    else:
        msg = 'No products Found'
        return render_template('basket.html', msg=msg)


# Basket
@app.route('/basket.html', methods=['GET', 'POST'])
def basket():
    check_basket_status()
    # Create cursor
    conn = mysql.connect()
    cur = conn.cursor()

    # result = cur.execute("SELECT * FROM basket_table where user_name = %s", session['username'])

    # Get basket information
    # getProductsFromBasket returns: [0]prod_id ,[1]prod_name, [2]qty, [3]prod_price
    # result =
    user = session['username']

    cur.callproc('sp_basketGetProducts', [user])
    bskt = cur.fetchall()

    conn.close()
    if bskt.__len__() > 0:
        return render_template('basket.html', products=bskt, basketStatus=basketVariable)
    else:
        msg = 'No products Found'
        return render_template('basket.html', msg=msg, basketStatus=basketVariable)


# Index
@app.route('/')
def index():
    return render_template('home.html', basketStatus=basketVariable)


# About
@app.route('/about')
def about():
    return render_template('about.html', basketStatus=basketVariable)


# products
@app.route('/products')
def products():
    check_basket_status()
    # Create cursor
    conn = mysql.connect()
    cur = conn.cursor()

    result = cur.execute("SELECT * FROM products")
    articles = cur.fetchall()
    conn.close()
    if result > 0:
        return render_template('products.html', products=articles, basketStatus=basketVariable)
    else:
        msg = 'No products Found'
        return render_template('products.html', msg=msg, basketStatus=basketVariable)


# Single product
@app.route('/product/<string:id>/')
def product(id):
    check_basket_status()
    # Create cursor
    conn = mysql.connect()
    cur = conn.cursor()
    # Get product
    cur.execute("SELECT * FROM products WHERE prod_id = %s", [id])
    result = cur.fetchone()
    conn.close()
    return render_template('product.html', product=result, basketStatus=basketVariable)


# Register Form Class
class RegisterForm(Form):
    name = StringField('Name', [validators.Length(min=1, max=50)])
    username = StringField('Username', [validators.Length(min=4, max=25)])
    email = StringField('Email', [validators.Length(min=6, max=50)])
    password = PasswordField('Password', [
        validators.DataRequired(),
        validators.EqualTo('confirm', message='Passwords do not match')
    ])
    confirm = PasswordField('Confirm Password')


# User Register
@app.route('/register', methods=['GET', 'POST'])
def register():
    form = RegisterForm(request.form)
    if request.method == 'POST' and form.validate():
        name = form.name.data
        email = form.email.data
        username = form.username.data
        password = sha256_crypt.encrypt(str(form.password.data))

        # Create cursor
        conn = mysql.connect()
        cur = conn.cursor()

        cur.callproc('sp_createUser', (name, username, email, password))

        # Commit to DB
        conn.commit()

        # Close connection
        conn.close()

        flash('You are now registered and can log in', 'success')

        return redirect(url_for('login'))

    return render_template('register.html', form=form)


# User login
@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        # Get Form Fields
        username = request.form['username']
        password_candidate = request.form['password']

        # Create cursor
        conn = mysql.connect()
        cur = conn.cursor()

        # Get user by username
        result = cur.execute("SELECT * FROM users WHERE username = %s", [username])

        if result > 0:
            # Get stored hash
            data = cur.fetchone()
            password = data[4]
            conn.close()
            # Compare Passwords
            if sha256_crypt.verify(password_candidate, password):
                # Passed
                session['logged_in'] = True
                session['username'] = username

                flash('You are now logged in', 'success')
                if username == 'admin':
                    return redirect(url_for('dashboard'))
                else:
                    check_basket_status()
                    return redirect(url_for('products'))
            else:
                error = 'Invalid login'
                return render_template('login.html', error=error)
                # Close connection

        else:
            error = 'Username not found'
            return render_template('login.html', error=error)

    return render_template('login.html')


# Check if user logged in
def is_logged_in(f):
    @wraps(f)
    def wrap(*args, **kwargs):
        if 'logged_in' in session:
            return f(*args, **kwargs)
        else:
            flash('Unauthorized, Please login', 'danger')
            return redirect(url_for('login'))

    return wrap


# Logout
@app.route('/logout')
@is_logged_in
def logout():
    session.clear()
    basketVariable = 0
    flash('You are now logged out', 'success')
    return redirect(url_for('login'))


# product Form Class
class ProductForm(Form):
    name = StringField('Name')
    price = StringField('Price')
    stock = StringField('Stock')


# Dashboard
@app.route('/dashboard')
@is_logged_in
def dashboard():
    if session['username'] != 'admin':
        return redirect(url_for('products'))

    # Create cursor
    conn = mysql.connect()
    cur = conn.cursor()

    # Get products
    # result = cur.callproc('sp_getAllProducts')
    # products = cur.fetchall()
    result = cur.execute("SELECT * FROM products")
    articles = cur.fetchall()
    conn.close()
    if result > 0:
        return render_template('dashboard.html', products=articles, basketStatus=basketVariable)
    else:
        msg = 'No products Found'
        return render_template('dashboard.html', msg=msg, basketStatus=basketVariable)


# Add product
@app.route('/add_product', methods=['GET', 'POST'])
@is_logged_in
def add_product():
    form = ProductForm(request.form)
    if request.method == 'POST':
        _name = form.name.data
        _price = form.price.data
        _stock = form.stock.data

        # Create Cursor
        conn = mysql.connect()
        cur = conn.cursor()

        # Execute
        cur.execute("INSERT INTO products(prod_name, prod_price, prod_stock) VALUES(%s, %s, %s)",
                    (_name, _price, _stock))

        # Commit to DB
        conn.commit()

        # Close connection
        conn.close()

        flash('product Created', 'success')

        return redirect(url_for('dashboard'))

    return render_template('add_product.html', form=form, basketStatus=basketVariable)


# Edit product
@app.route('/edit_product/<string:id>', methods=['GET', 'POST'])
@is_logged_in
def edit_product(id):
    # Create cursor
    conn = mysql.connect()
    cur = conn.cursor()

    # Get product by id
    result = cur.execute("SELECT * FROM products WHERE prod_id = %s", [id])

    product = cur.fetchone()
    cur.close()
    # Get form
    form = ProductForm(request.form)

    # Populate product form fields
    form.title.data = product['title']
    form.body.data = product['body']

    if request.method == 'POST' and form.validate():
        title = request.form['title']
        body = request.form['body']

        # Create Cursor
        cur = conn.cursor()
        app.logger.info(title)
        # Execute
        cur.execute("UPDATE products SET title=%s, body=%s WHERE prod_id=%s", (title, body, id))
        # Commit to DB
        conn.commit()

        # Close connection
        conn.close()

        flash('product Updated', 'success')

        return redirect(url_for('dashboard'))
    conn.close()
    return render_template('edit_product.html', form=form, basketStatus=basketVariable)


# Delete product
@app.route('/delete_product/<string:id>', methods=['POST'])
@is_logged_in
def delete_product(id):
    # Create cursor
    conn = mysql.connect()
    cur = conn.cursor()

    # Execute
    cur.execute("DELETE FROM products WHERE prod_id = %s", [id])

    # Commit to DB
    conn.commit()

    # Close connection
    conn.close()

    flash('product Deleted', 'success')

    return redirect(url_for('dashboard'), basketStatus=basketVariable)


if __name__ == '__main__':
    app.secret_key = 'secret123'
    app.run(debug=True)
