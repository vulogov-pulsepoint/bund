import rsa
import msgpack

KEY_SIZE=1024

class BUND_RSA:
    def __init__(self, id='BundAdmin@Bund'):
        self.keyring = {}
        self.private = {}
        self.id = id
    def _loadKeyring(self, data, ktype):
        _keyring = msgpack.loads(data, raw=False)
        _keys = {}
        for k,v in _keyring[ktype]:
            if ktype == 'pri':
                _keys[k] = rsa.PrivateKey.load_pkcs1(v)
            else:
                _keys[k] = rsa.PublicKey.load_pkcs1_openssl_pem(v)
        return _keys
    def loadKeyring(self, data=None):
        if data:
            self.keyring = self._loadKeyRing(data, 'pub')
            self.private = self._loadKeyRing(data, 'pri')
            if self.id not in self.private.keys():
                self.keyring[self.id], self.private[self.id] = rsa.newkeys(KEY_SIZE)
        else:
            self.keyring[self.id], self.private[self.id] = rsa.newkeys(KEY_SIZE)
    def dumpKeyring(self):
        _keyring = {'pri':{}, 'pub':{}}
        for k, v in self.keyring.items():
            _keyring['pub'][k] = v.save_pkcs1('PEM')
        for k, v in self.private.items():
            _keyring['pri'][k] = v.save_pkcs1('PEM')
        return msgpack.dumps(_keyring, use_bin_type=True)
    def signDocument(self, doc, id=None):
        if not id:
            id = self.id
        d = {u'id':id, u'data':doc.encode(), u'pub':self.keyring[id].save_pkcs1('PEM'), u'sign': rsa.sign(doc.encode(), self.private[id], 'SHA-1')}
        return msgpack.dumps(d, use_bin_type=True)
    def checkDocument(self, doc):
        d = msgpack.loads(doc, raw=False)
        try:
            return rsa.verify(d['data'], d['sign'], self.keyring[d['id']])
        except KeyboardInterrupt:
            return False



