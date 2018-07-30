import unittest
import bund

class TestLibMethods(unittest.TestCase):
    def test_lib_rchop(self):
        self.assertEqual(bund.rchop("abcd", "d"), 'abc')
    def test_lib_check_file(self):
        self.assertTrue(bund.check_file('/etc/passwd', 0o664))
    def test_lib_check_directory(self):
        self.assertTrue(bund.check_directory('/etc'))
    def test_lib_check_directory_write(self):
        self.assertTrue(bund.check_directory('/tmp'))
    def test_lib_check_file_read(self):
        self.assertTrue(bund.check_file_read('/etc/passwd'))
    def test_lib_check_file_exec(self):
        self.assertTrue(bund.check_file_read('/bin/sh'))
    def test_bund_eval1(self):
        self.assertEqual(bund.bund_eval("(* 2 2)", None, None), 4)
    def test_bund_eval2(self):
        self.assertEqual(bund.bund_eval("(-> 2 (* 2))", None, None), 4)

