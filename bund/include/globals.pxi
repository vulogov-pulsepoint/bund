class BUND_GLOBAL_ADAPTER:
    def init_globals_methods(self):
        self.Debug("(Global (Global.* ...))")
        m = make_module_on_the_fly("Global", hyx_Set_XgreaterHthan_signX=self.setGlobal)
        self.registerGlobal(Global=m)
    def setGlobal(self, name, val):
        self.Globals[name] = val
        return val
