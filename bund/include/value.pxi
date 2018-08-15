class BUND_VALUE:
    def __init__(self, ctx, data=None, **kw):
        self.ctx = ctx
        self.stamp = time.time()
        self.id = str(uuid.uuid4())
        self.data = data
        self.name = None
        self.type = "unknown"
        self.r    = True
        self.msg  = ""
        self.init_object(kw)
        if self.type == "unknown":
            self.type = str(type(self.data).__name__)
    def init_object(self, kw):
        for k, v in kw.items():
            setattr(self, k, v)
    def isOK(self):
        return self.r
    def setOK(self, msg="", **kw):
        self.r = True
        self.msg = msg%kw
    def setFAIL(self, msg="", **kw):
        self.r = False
        self.msg = msg%kw
    def json(self):
        out = {'id': self.id, 'stamp': self.stamp,
               'name': self.name, 'type': self.type,
               'ctx': self.ctx.id, 'ctx_stamp':self.ctx.stamp}
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
    ctx.ctx.alst_validation = time.time()
    if not ctx.r:
        ctx.ctx.Error("Context is not valid. Exiting.")
        ctx.ctx.Error(ctx.msg)
        sys.exit(11)
    return ctx

def VALUE(ctx, data, **kw):
    v = BUND_VALUE(ctx, data, **kw)
    return v

class BUND_VALUE_ADAPTER:
    def init_value_methods(self):
        self.Debug("(Global (Value.* ...))")
        self.registerGlobal(FAIL=FAIL,
                            OK=OK,
                            VALIDATE=VALIDATE,
                            VALUE=VALUE,
                            V=self.V)
    def V(self, data, **kw):
        return VALUE(self, data, **kw)
