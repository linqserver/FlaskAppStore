class Product:

    def __init__(self, index, name, price, stock, path, desc):
        self.prod_id = index
        self.prod_name = name
        self.prod_price = price
        self.prod_stock = stock
        self.prod_image_ref = path
        self.prod_description = desc
