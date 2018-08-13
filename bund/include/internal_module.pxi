
def make_module_on_the_fly(name, **kw):
    _mod = types.ModuleType(name)
    for n in kw:
        setattr(_mod, n, kw[n])
    return _mod
