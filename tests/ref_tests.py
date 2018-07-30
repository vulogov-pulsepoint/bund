import unittest
import bund

class TestRefMethods(unittest.TestCase):
    def test_ref_string(self):
        self.assertEqual(bund.load_file_from_the_reference("Hello world"), 'Hello world')
    def test_ref_url1(self):
        self.assertNotIsInstance(bund.load_file_from_the_reference("@https://raw.githubusercontent.com/vulogov-pulsepoint/bund/master/setup.py"), type(None))
    def test_ref_url2(self):
        self.assertNotIsInstance(bund.load_file_from_the_reference("@file:///etc/passwd"), type(None))
    def test_ref_url3(self):
        self.assertNotIsInstance(bund.load_file_from_the_reference("@ftp://ftp.lip6.fr/pub/linux/sunsite/kernel/!INDEX.html"), type(None))
    def test_ref_url4(self):
        self.assertNotIsInstance(bund.load_file_from_the_reference("=vulogov-pulsepoint/bund:/setup.py"), type(None))
