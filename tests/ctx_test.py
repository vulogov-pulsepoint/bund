import unittest
import bund

class TestCtxMethods(unittest.TestCase):
    def test_ctx1(self):
        c = bund.BUND_CTX(None)
        self.assertNotIsInstance(c.id, type(None))
    def test_ctx2(self):
        c = bund.BUND_CTX(None)
        self.assertNotIsInstance(c.rm, type(None))
    def test_ctx3(self):
        c = bund.BUND_CTX(None)
        self.assertIsInstance(c.created, float)

