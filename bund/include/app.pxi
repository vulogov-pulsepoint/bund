from cliff.app import App
from cliff.commandmanager import CommandManager


def banner(s):
    try:
        from pyfiglet import Figlet
    except ImportError:
        return s
    f = Figlet(font="stop")
    return f.renderText(s)

VERSION="0.1"
APP_NAME="bund"
COLOR_BANNER="""%s

%s %s
"""%(colored(banner("(theBund)"), "cyan"), colored("Version: ", "yellow"), colored(VERSION, "cyan"))

BW_BANNER="""
%s

Version: %s
"""%(banner("( theBund )"), VERSION)

N_SUCC_CHECKS = 1

class BUND_APP_EXCEPTION(Exception):
    pass

class BUND_APP_MAIN(App, BUND_LOG_ADAPTER,
                    BUND_CONFIG_ADAPTER,
                    BUND_GLOBAL_ADAPTER,
                    BUND_EVAL_ADAPTER,
                    BUND_SYMBOLS_ADAPTER,
                    BUND_IMPORT_ADAPTER,
                    BUND_QUEUE_ADAPTER,
                    BUND_VALUE_ADAPTER):
    def __init__(self, shell):
        self.ready = 0
        self.shell = shell
        self.Globals = {}
        self.isReady = False
        self.id = str(uuid.uuid4())
        App.configure_logging = BUND_LOG_ADAPTER.configure_logging
        super(BUND_APP_MAIN, self).__init__(
            description='(theBund) executor and evaluator',
            version='0.1',
            command_manager=CommandManager('bundcmd'),
            deferred_help=True,
            interactive_app_factory=BUND_INTERACTIVE,
        )
        super(BUND_CONFIG_ADAPTER, self).__init__()
        super(BUND_IMPORT_ADAPTER, self).__init__()
        self.parser.add_argument('--keyring', action='store', default=None, help='Location of the keyring')
        self.parser.add_argument('--no-color', action='store_true', default=False, dest='no_color', help='Turn off color output')
        self.parser.add_argument('--print', action='store_true', default=False, dest='yes_print', help='Force printing of the EVAL result')
        self.parser.add_argument('--home', action='store', default="~/.bund/", dest='bund_home', help='Home directory for all things')
        self.parser.add_argument('--unsafe', action='store_true', default=False, dest='unsafe_globals', help='Force using global interpreter Globals')
        self.parser.add_argument('--lisp', action='store_true', default=False, dest='yes_lisp', help='Use classic Lisp syntax instead of pipelines')
        self.parser.add_argument('-c', action='store', default=False, dest='config_reference', help='Reference to the configuration')
        self.command_manager.add_command("eval", BUND_APP_EVAL)
        self.LOG.debug("In __init__")

    def initialize_globals(self):
        if not self.options.unsafe_globals:
            self.Debug("Initialize safe Globals")
        else:
            self.Warning("Initialize UNSAFE Globals")
            self.Globals = globals()
        self.Globals = get_from_env("BUND_UNSAFE_GLOBALS", default=self.Globals, BUND_UNSAFE_GLOBALS=self.options.unsafe_globals)
        self.Globals = get_from_env("BUND_HOME", default=self.Globals, BUND_HOME=self.options.bund_home)
        self.Globals = get_from_env("BUND_MODCACHE_EXPIRE", default=self.Globals, BUND_MODCACHE_EXPIRE="900")
        self.registerGlobal(Time=time)
        self.registerGlobal(UUID=uuid)

    def registerGlobal(self, **kw):
        for k in kw.keys():
            self.Debug("(Global %(name)s ... )", name=k)
            self.Globals[k] = kw[k]


    def initialize_app(self, argv):
        self.LOG.debug('theBund is initializing')
        self.initialize_globals()
        self.init_private_home()
        self.load_configuration()
        self.init_log_methods()
        self.init_globals_methods()
        self.init_eval_methods()
        self.init_symbols_methods()
        self.init_import_methods()
        self.init_value_methods()

        self.initialize_fscache()

        if self.ready != N_SUCC_CHECKS:
            self.LOG.critical("theBund experienced an error during initialization and can not continue")
            self.isReady = False
            raise BUND_APP_EXCEPTION
        else:
            self.LOG.debug("theBund initialized succesfully")
            self.isReady = True
    def prepare_to_run_command(self, cmd):
        self.LOG.debug('prepare_to_run_command %s', cmd.__class__.__name__)

    def clean_up(self, cmd, result, err):
        self.LOG.debug('clean_up %s', cmd.__class__.__name__)
        if err:
            self.LOG.debug('got an error: %s', err)
    def display_version(self):
        if self.options.no_color:
            print(BW_BANNER)
        else:
            print(COLOR_BANNER)


class BUND_APP(BUND_LOG):
    def __init__(self):
        self.app = BUND_APP_MAIN(self)
        self.ctx = BUND_CTX(self.app)
        self.debug("In the %s.__init__"%__name__)
    def run(self, argv):
        self.app.LOG.info("In the %s.run"%__name__)
        self.app.run(argv)
    def __del__(self):
        self.debug("In the %s.__del__"%__name__)
