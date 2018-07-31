from cement.core.controller import CementBaseController, expose

class BUND_APP_EVAL(CementBaseController):
    class Meta:
        label = 'app_eval'
        stacked_on = 'base'
        stacked_type = 'embedded'
    @expose(help="Evaluate a raw Bund code")
    def eval(self):
        self.app.log.debug("Inside BUND_APP_EVAL.eval()")
    @expose(help="Run the packaged Bund application")
    def run(self):
        self.app.log.debug("Inside BUND_APP_EVAL.run()")


