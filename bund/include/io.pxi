
class BUND_IO_ADAPTER:
    def init_io_methods(self):
        self.Debug("(Global (IO.* ...))")
        m = make_module_on_the_fly("IO")