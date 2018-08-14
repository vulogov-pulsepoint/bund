class BUND_VALUE:
    def __init__(self, ctx, data=None, **kw):
        self.ctx = ctx
        self.stamp = time.time()
        self.id = str(uuid.uuid4())
        self.data = None
        self.name = None
        self.type = "unknown"
        self.r    = True
        self.msg  = ""
        self.init_object(kw)
    def init_object(self, kw):
        for k, v in kw.items():
            setattr(self, k, v)
    def set(self, data, typeCallable=None):
        self.data = data
        self.type = typeCallable()
    def isOK(self):
        return self.r
    def setOK(self, msg="", **kw):
        self.r = True
        self.msg = msg%kw
    def setFAIL(self, msg="", **kw):
        self.r = False
        self.msg = msg%kw
    def json(self):
        out = {'id': self.id, 'stamp': self.stamp, 'name': self.name, 'type': self.type}
        try:
            d = json.dumps(self.data)
            out['data'] = d
        except:
            pass
        return json.dumps(out)

def FAIL(ctx, msg, **kw):
    ctx.r = False
    ctx.msg = msg%kw
    return ctx

def OK(ctx, msg, **kw):
    ctx.r = True
    ctx.msg = msg%kw
    return ctx

def VALIDATE(ctx):
    if not ctx.r:
        ctx.ctx.Error("Context is not valid. Exiting.")
        ctx.ctx.Error(ctx.msg)
        sys.exit(11)
    return ctx

class BUND_VALUE_ADAPTER:
    def init_value_methods(self):
        self.Debug("(Global (Value.* ...))")
        self.registerGlobal(FAIL=FAIL,
                            OK=OK,
                            VALIDATE=VALIDATE)
