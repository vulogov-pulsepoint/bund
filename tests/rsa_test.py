import unittest
import bund

class TestRSAMethods(unittest.TestCase):
    def test_rsa_sign(self):
        a = bund.BUND_RSA()
        a.loadKeyring()
        d = a.signDocument("Hello world")
        self.assertTrue(a.checkDocument(d))
    def test_rsa_new(self):
        a = bund.BUND_RSA()
        a.loadKeyring()
        self.assertTrue(a.new("hello world"))
        self.assertNotIsInstance(a.keyring["hello world"], type(None))
        self.assertNotIsInstance(a.private["hello world"], type(None))


