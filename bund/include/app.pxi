from cement.core import foundation, handler
from cement.core.foundation import CementApp

APP_NAME="bund"

class BUND_APP_MAIN(CementBaseController):
    class Meta:
        label = 'base'
        description = "(theBund) evaluator and run-time"
        arguments = [
            (['-k', '--keyring'],
            dict(action='store', help='Location of the KeyRing file')),
        ]
    @expose(hide=True)
    def default(self):
        self.app.log.info('Inside BUND_APP_MAIN.default()')
        if self.app.pargs.keyring:
            print("Recieved option: keyring => %s" % self.app.pargs.keyring)

class BUND_APP(BUND_LOG):
    class Meta:
        label = APP_NAME
        base_controller = 'base'

    def __init__(self):
        self.app = CementApp(APP_NAME)
        self.ctx = BUND_CTX(self.app)
        handler.register(BUND_APP_MAIN)
        handler.register(BUND_APP_EVAL)
        self.app.setup()
        self.debug("In the %s.__init__"%__name__)
    def run(self):
        self.debug("In the %s.run"%__name__)
        self.app.run()
    def __del__(self):
        self.debug("In the %s.__del__"%__name__)
        self.app.close()