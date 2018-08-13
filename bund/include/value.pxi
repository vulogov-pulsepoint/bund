class BUND_VALUE:
    def __init__(self, ctx, data=None, **kw):
        self.ctx = ctx
        self.stamp = time.time()
        self.id = str(uuid.uuid4())
        self.data = None
        self.name = None
        self.type = "unknown"
        self.init_object(kw)
    def init_object(self, kw):
        for k, v in kw.items():
            setattr(self, k, v)
    def set(self, data, typeCallable=None):
        self.data = data
        self.type = typeCallable()
    def json(self):
        out = {'id': self.id, 'stamp': self.stamp, 'name': self.name, 'type': self.type}
        try:
            d = json.dumps(self.data)
            out['data'] = d
        except:
            pass
        return json.dumps(out)
