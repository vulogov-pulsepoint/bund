##
##
##

class BUND_CTX(object):
    def __init__(self, app, **kw):
        self.rm         = ResourceManager()
        self.id         = str(uuid.uuid4())
        self.created    = time.time()
        for k, v in kw.items():
            setattr(self, k, v)
    def __del__(self):
        pass

