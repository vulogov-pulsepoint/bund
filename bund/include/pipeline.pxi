
class BUND_PIPELINE_ADAPTER:
    def init_pipeline_methods(self):
        self.Debug("(Global (Pipe.* ...))")
        m = make_module_on_the_fly("Pa")