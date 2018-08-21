class BUND_ENCODERS_ADAPTER:
    def init_encoders_methods(self):
        self.Debug("(Global (ENCODER.* ...))")
        m = make_module_on_the_fly("ENCODER")