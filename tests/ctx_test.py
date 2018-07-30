import unittest
import bund

class TestCtxMethods(unittest.TestCase):
    def test_ctx1(self):
        c = bund.CTX()
        self.assertNotIsInstance(c.id, type(None))
    def test_ctx2(self):
        c = bund.CTX()
        self.assertNotIsInstance(c.rm, type(None))
    def test_ctx3(self):
        c = bund.CTX()
        self.assertIsInstance(c.created, float)

