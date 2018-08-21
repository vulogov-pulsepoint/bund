

class Resource(object):
    def __init__(self, ctx, name):
        self.ctx = ctx
        self.name = name
        self.data = []
        self.isLocal = True
        self.type = 'unknown'
        self.location = 0
    def init_resource(self):
        pass
    def sizeOf(self):
        return len(self.data)
    def close(self):
        pass

class Stack(Resource):
    def __init__(self, ctx, name):
        Resource.__init__(self, ctx, name)
        self.type = 'stack'
    def push(self, data):
        if data:
            self.data.append(data)
        return data
    def pop(self):
        if self.data:
            v = self.data[-1]
            del self.data[-1]
            return v
        return VALUE(self.ctx, None, type="undefined")

class Queue(Resource):
    def __init__(self, ctx, name):
        Resource.__init__(self, ctx, name)
        self.type = 'queue'
    def push(self, data):
        if data:
            self.data = [data,] + self.data
        return data
    def pop(self):
        if self.data:
            v = self.data[0]
            del self.data[0]
            return v
        return VALUE(self.ctx, None, type="undefined")

class Storage(Resource):
    def __init__(self, ctx, name):
        Resource.__init__(self, ctx, name)
        self.data = {}
        self.type = 'storage'
    def push(self, name, data):
        if name not in self.data.keys():
            self.data[name] = data
        return data
    def pop(self, name):
        if name in self.data.keys():
            v = self.data[name]
            del self.data[name]
            return v
        return VALUE(self.ctx, None, type="undefined")



def Add_Stack(ctx, name):
    ctx.ctx.rm.allocateStack(name)
    ctx.ctx.rm[name].init_resource()
    return VALUE(ctx, ctx.ctx.rm[name], type=ctx.ctx.rm[name].type, isLocal=ctx.ctx.rm[name].isLocal, name=name)
def Add_Queue(ctx, name):
    ctx.ctx.rm.allocateQueue(name)
    ctx.ctx.rm[name].init_resource()
    return VALUE(ctx, ctx.ctx.rm[name], type=ctx.ctx.rm[name].type, isLocal=ctx.ctx.rm[name].isLocal, name=name)
def Add_Storage(ctx, name):
    ctx.ctx.rm.allocateStorage(name)
    ctx.ctx.rm[name].init_resource()
    return VALUE(ctx, ctx.ctx.rm[name], type=ctx.ctx.rm[name].type, isLocal=ctx.ctx.rm[name].isLocal, name=name)
def Register_Resource(ctx, name, type, _class):
    if name in ctx.ctx.Globals.keys():
        ctx.ctx.Error("Resource %s already in the (Global ...) scope"%name)
        return FAIL(ctx, "Error allocating resource")
    if name not in ctx.ctx.rm.keys():
        ctx.ctx.rm[name] = _class(ctx, name)
        ctx.ctx.rm[name].type = type
        ctx.ctx.Globals[name] = name
    ctx.ctx.rm[name].init_resource()
    return VALUE(ctx, ctx.ctx.rm[name], type=ctx.ctx.rm[name].type, isLocal=ctx.ctx.rm[name].isLocal, name=name)
def Push_to_Resource(ctx, v, **kw):
    if not hasattr(v, "data"):
        ctx.ctx.Error("You must Push a BUND_VALUE")
        return FAIL(ctx, "Invalid value for (Resource.<-)")
    if 'r' in kw.keys():
        r = kw['r']
    else:
        r = ctx.ctx.Globals['BUND_DEFAULT_STACK']
    ctx.ctx.Debug("Resource.<- [%s] %s "%(r, str(v.data)))
    ctx.ctx.rm[r].push(v)
    return v
def Pull_from_Resource(ctx, **kw):
    if 'r' in kw.keys():
        r = kw['r']
    else:
        r = ctx.ctx.Globals['BUND_DEFAULT_STACK']
    res = ctx.ctx.rm[r].pop()
    ctx.ctx.Debug("Resource.-> [%s] %s:%s"%(r, res.type, str(res.data)))
    if res:
        return res
    else:
        return ctx
def Resource_SizeOf(ctx, **kw):
    if 'r' in kw.keys():
        r = kw['r']
    else:
        r = ctx.ctx.Globals['BUND_DEFAULT_STACK']
    res = ctx.ctx.rm[r].sizeOf()
    ctx.ctx.Debug("Resource.sizeOf [%s] %d"%(r, res))
    return VALUE(ctx, res, type='int', isLocal=ctx.ctx.rm[r].isLocal, name=r)


class ResourceManager(dict):
    def __init__(self, ctx):
        self.ctx = ctx
    def allocateStack(self, resource):
        if resource in self.ctx.Globals.keys():
            self.ctx.Error("Resource %s already in the (Global ...) scope"%resource)
            return
        if resource not in self.keys():
            self.ctx.Debug("(Stack+ ...) %s"%resource)
            self.ctx.Globals[resource] = resource
            self[resource] = Stack(self.ctx, resource)
    def allocateQueue(self, resource):
        if resource in self.ctx.Globals.keys():
            self.ctx.Error("Resource %s already in the (Global ...) scope"%resource)
            return
        if resource not in self.keys():
            self.ctx.Debug("(Queuek+ ...) %s"%resource)
            self.ctx.Globals[resource] = resource
            self[resource] = Queue(self.ctx, resource)
    def allocateStorage(self, resource):
        if resource in self.ctx.Globals.keys():
            self.ctx.Error("Resource %s already in the (Global ...) scope"%resource)
            return
        if resource not in self.keys():
            self.ctx.Debug("(Storage+ ...) %s"%resource)
            self.ctx.Globals[resource] = resource
            self[resource] = Storage(self.ctx, resource)
    def close(self):
        for i in self.keys():
            self[i].close()

class BUND_RESOURCE_ADAPTER:
    def init_resource_methods(self):
        self.Debug("(Global (Resource.* ...))")
        m = make_module_on_the_fly("Resource",
                                   hyx_Xplus_signX=Register_Resource,
                                   hyx_XlessHthan_signX_=Push_to_Resource,
                                   _hyx_XgreaterHthan_signX=Pull_from_Resource,
                                   sizeOf=Resource_SizeOf,
        )
        self.registerGlobal(hyx_StackXplus_signX=Add_Stack,
                            hyx_QueueXplus_signX=Add_Queue,
                            hyx_StorageXplus_signX=Add_Storage,

                            Resource=m)
        Add_Stack(self.getContext(), "DEFAULT_STACK")
        Add_Storage(self.getContext(), "GLOBAL_STORAGE")
        self.registerGlobal(BUND_DEFAULT_STACK="DEFAULT_STACK")
        self.registerGlobal(BUND_DEFAULT_STORAGE="GLOBAL_STORAGE")


