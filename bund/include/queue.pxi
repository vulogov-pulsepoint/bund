class BUND_QUEUE_ADAPTER:
    def init_import_methods(self):
        self.Debug("(Global (Queue.* ...))")
        m = make_module_on_the_fly("Global", hyx_Set_XgreaterHthan_signX=self.setGlobal)
        self.registerGlobal(Global=m)

