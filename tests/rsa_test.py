import unittest
import bund

class TestLibMethods(unittest.TestCase):
    def test_rsa_sign(self):
        a = bund.BUND_RSA()
        a.loadKeyring()
        d = a.signDocument("Hello world")
        self.assertTrue(a.checkDocument(d))
