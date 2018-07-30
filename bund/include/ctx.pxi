##
##
##

class CTX:
    def __init__(self, **kw):
        self.rm         = ResourceManager()
        self.id         = uuid.uuid4()
        self.created    = time.time()
        for k, v in kw.items():
            setattr(self, k, v)

