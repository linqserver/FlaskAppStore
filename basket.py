from flaskext.mysql import MySQL

from Product import Product


class Basket:

    icon = 'images/basket_icon.png'
    totalValue = 0.00
    products_list = []

    def calc_tot_val(self):
        self.totalValue = 0

        for val in self.products_list:
            assert isinstance(val, Product())
            self.totalValue += val.Product().prod_price

        return self.totalValue

    def add_product_to_list(self, prod):
        self.products_list.append(prod)
        self.totalValue = self.calc_tot_val()

    def check_qty_by_id(self, id):
        for prod in self.products_list:
            if prod.prod_id == id:
                return prod.prod_stock
            else:
                return 0

    def reset(self):
        self.products_list = []
        self.totalValue = 0.00
        self.icon = 'images/basket_icon.png'

    def calcTotVal(self, rows):
        self.totalValue = 0.00
        for p in rows:
            self.totalValue += float(p[2]) * float(p[3])


# TODO: get rerurn products for basket window