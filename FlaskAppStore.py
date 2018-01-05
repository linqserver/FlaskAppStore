from flask import Flask, render_template, flash, redirect, json, url_for, session, request, logging
from basket import Basket
from Product import Product

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

# basket temp
the_basket_rows = list()

# products temp
the_product_rows = list()

the_basket = Basket()
the_basket.icon = 'images/basket_icon.png'
the_basket.totalValue = 0.00


# Index
@app.route('/')
def index():
    check_basket_status()
    return render_template('home.html', basketStatus=the_basket)


# About
@app.route('/about')
def about():
    return render_template('about.html', basketStatus=the_basket)


# products
@app.route('/products')
def products():
    check_basket_status()
    products_list_refresh()
    global the_product_rows

    if len(the_product_rows) > 0:
        return render_template('products.html', products=the_product_rows)
    else:
        msg = 'No products Found'
        return render_template('products.html', msg=msg)


# products_list_refresh
def products_list_refresh():
    # Create cursor
    conn = mysql.connect()
    cur = conn.cursor()
    global the_product_rows
    cur.execute("SELECT * FROM products")
    the_product_rows = cur.fetchall()
    conn.close()


# Single product
@app.route('/product/<prodid>/')
def product(prodid):
    # Create cursor
    conn = mysql.connect()
    cur = conn.cursor()
    # Get product
    cur.execute("SELECT * FROM products WHERE prod_id = %s", [prodid])
    result = cur.fetchone()
    conn.close()
    check_basket_status()
    return render_template('product.html', product=result)




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
            flash('Please Register or Login ', 'info')
            return redirect(url_for('login'))

    return wrap


# Logout
@app.route('/logout')
@is_logged_in
def logout():
    session.clear()
    global the_basket
    the_basket.reset()
    flash('You are now logged out', 'success')
    return redirect(url_for('login'))


# product Form Class
class ProductForm(Form):
    name = StringField('Name')
    price = StringField('Price')
    stock = StringField('Stock')
    image = StringField('Image', default="images/products/product_1.jpg")
    description = StringField('Description', default="This is a description of the product")


# returns true if current user have items in the basket
@is_logged_in
def check_basket_status():
    global the_basket
    global the_basket_rows
    the_basket.calcTotVal(the_basket_rows)
    # Create cursor
    conn = mysql.connect()
    cur = conn.cursor()
    user = session['username']
    cur.callproc('sp_basketCheckForContent', [user])
    bskt = cur.fetchone()
    products_list_refresh()
    if bskt[0] >= 1:
        the_basket.calcTotVal(the_basket_rows)
        the_basket.icon = 'images/basket_icon_full2.png'
        msg = 'check_basket_status returns one'
        print(msg, bskt[0])
        conn.close()
        return [bskt]
    else:

        the_basket.icon = 'images/basket_icon.png'
        msg = 'check_basket_status returns zero'
        print(msg, bskt[0])
        conn.close()
        return [bskt]


# app.jinja_env.globals.update(add_to_basket=add_to_basket)
# add_to_basket
@app.route("/add_to_basket/<int:id>/<int:qtyy>")
def add_to_basket(id, qtyy):
    # {{ add_to_basket(product[0])}}
    # Create cursor
    conn = mysql.connect()
    cur = conn.cursor()
    user = session['username']
    if qtyy > 0:
        cur.callproc('sp_basketAddProduct', [id, user])
        flash("Product Added to Basket", 'success')
    else:
        flash("Product Stock Insufficient", 'danger')

    conn.close()
    check_basket_status()
    return redirect(url_for('products'))


# increase_item_quantity in cart
@app.route("/increase_item_quantity/<int:id>/<int:di>/<int:qttyi>")
def increase_item_quantity(id, di, qttyi):
    conn = mysql.connect()
    cur = conn.cursor()
    user = session['username']

    if qttyi < 1:
        flash("Product Stock Insufficient", 'danger')
    else:
        cur.callproc('sp_basketAddProduct', [id, user])
        check_basket_status()
        if di == 10:
            flash("Maximum quantity is 10. Contact us for bulk orders.", 'info')
        else:
            flash("Product Added to Basket", 'success')

    conn.close()
    return basket()


# remove_from_basket
@app.route("/delete_from_basket/<int:id>")
def delete_from_basket(id):
    conn = mysql.connect()
    cur = conn.cursor()
    user = session['username']
    cur.callproc('sp_basketDeleteProduct', [id, user])
    conn.close()
    check_basket_status()
    return redirect(url_for('basket'))


# empty_the_basket
@app.route("/empty_the_basket")
def empty_the_basket():
    conn = mysql.connect()
    cur = conn.cursor()
    user = session['username']
    cur.callproc('sp_basketEmpty', [user])
    conn.close()
    check_basket_status()
    return redirect(url_for('basket'))


# decrease_from_basket
@app.route("/decrease_from_basket/<int:id>/<int:di>")
def decrease_from_basket(id, di):
    conn = mysql.connect()
    cur = conn.cursor()
    user = session['username']
    cur.callproc('sp_basketDecrease', [id, user])
    conn.close()
    check_basket_status()
    if di == 1:
        flash("Minimum quantity is 1. Please, use Delete to remove item from cart", 'info')

    return redirect(url_for('basket'))


# Basket
@app.route('/basket.html', methods=['GET', 'POST'])
@is_logged_in
def basket():
    global the_basket_rows
    # Create cursor
    conn = mysql.connect()
    cur = conn.cursor()
    user = session['username']
    cur.callproc('sp_basketGetProducts', [user])
    bskt = cur.fetchall()
    conn.close()
    the_basket_rows = bskt
    check_basket_status()
    if bskt.__len__() > 0:
        return render_template('basket.html', products=bskt, prod=the_product_rows)
    else:
        msg = 'No products Found'
        return render_template('emptybasket.html', msg=msg)


# Checkout.html
@app.route('/checkout', methods=['GET', 'POST'])
@is_logged_in
def checkout():
    global the_basket_rows
    # Create cursor
    conn = mysql.connect()
    cur = conn.cursor()
    user = session['username']
    cur.callproc('sp_basketGetProducts', [user])
    bskt = cur.fetchall()
    conn.close()
    the_basket_rows = bskt
    check_basket_status()
    if bskt.__len__() > 0:
        return render_template('checkout.html', products=bskt)
    else:
        msg = 'No products Found'
        return render_template('emptybasket.html', msg=msg)


# Confirm Order.html
@app.route('/confirm_order', methods=['GET', 'POST'])
@is_logged_in
def create_order():
    global the_basket_rows
    # Create cursor
    conn = mysql.connect()
    cur = conn.cursor()
    user = session['username']
    cur.callproc('sp_createOrder', [user])
    bskt = cur.fetchall()
    conn.close()
    the_basket_rows = bskt
    check_basket_status()
    if bskt.__len__() == 0:
        msg = 'Order Created Successfully!'
        return render_template('home.html', products=bskt, msg=msg)
    else:
        msg = 'Something is wrong with the order'
    return render_template('checkout.html', products=bskt, msg=msg)


# Dashboard
@app.route('/dashboard')
@is_logged_in
def dashboard():
    if session['username'] != 'admin':
        return redirect(url_for('products'))

    # Create cursor
    conn = mysql.connect()
    cur = conn.cursor()
    result = cur.execute("SELECT * FROM products")
    articles = cur.fetchall()
    conn.close()
    check_basket_status()
    if result > 0:
        return render_template('dashboard.html', products=articles, basketStatus=the_basket)
    else:
        msg = 'No products Found'
        return render_template('dashboard.html', msg=msg, basketStatus=the_basket)


# Add product
@app.route('/add_product', methods=['GET', 'POST'])
@is_logged_in
def add_product():
    form = ProductForm(request.form)
    if request.method == 'POST':
        _name = form.name.data
        _price = form.price.data
        _stock = form.stock.data
        _image = form.stock.data
        _descrip = form.stock.data

        # Create Cursor
        conn = mysql.connect()
        cur = conn.cursor()
        # Execute
        cur.callproc('p_addNewProduct', [_name, _price, _stock, _image, _descrip])
        # Commit to DB
        conn.commit()
        # Close connection
        conn.close()
        flash('product Created', 'success')
        return redirect(url_for('dashboard'))
    return render_template('add_product.html', form=form, basketStatus=the_basket)


# Edit product
@app.route('/edit_product/<string:id>', methods=['GET', 'POST'])
@is_logged_in
def edit_product(id):
    # Create cursor
    conn = mysql.connect()
    cur = conn.cursor()

    # Get product by id
    result = cur.execute("SELECT * FROM products WHERE prod_id = %s", [id])

    single_product = cur.fetchone()
    cur.close()
    # Get form
    form = ProductForm(request.form)

    # Populate product form fields
    form.title.data = single_product['title']
    form.body.data = single_product['body']

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
    return render_template('edit_product.html', form=form, basketStatus=the_basket)


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

    return redirect(url_for('dashboard'), basketStatus=the_basket)


app.jinja_env.globals.update(basketStatus=the_basket)

if __name__ == '__main__':
    app.secret_key = 'secret123'
    app.run(debug=True)
