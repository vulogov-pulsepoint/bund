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

class BUND_APP_MAIN(App, BUND_LOG_ADAPTER):
    def __init__(self):
        App.configure_logging = BUND_LOG_ADAPTER.configure_logging
        super(BUND_APP_MAIN, self).__init__(
            description='(theBund) executor and evaluator',
            version='0.1',
            command_manager=CommandManager('bundcmd'),
            deferred_help=True,
            interactive_app_factory=BUND_INTERACTIVE,
        )
        self.parser.add_argument('--keyring', action='store', default=None, help='Location of the keyring')
        self.parser.add_argument('--no-color', action='store_true', default=False, dest='no_color', help='Turn off color output')
        self.parser.add_argument('--print', action='store_true', default=False, dest='yes_print', help='Force printing of the EVAL result')
        self.command_manager.add_command("eval", BUND_APP_EVAL)
        self.LOG.debug("In __init__")

    def initialize_app(self, argv):
        self.LOG.debug('initialize_app')

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
        self.app = BUND_APP_MAIN()
        self.ctx = BUND_CTX(self.app)
        self.debug("In the %s.__init__"%__name__)
        self.init_private_home()
    def init_private_home(self):
        self.home = os.path.join(os.path.expanduser("~"), ".bund")
        if not check_directory(self.home):
            os.mkdir(self.home)
        # histfile = os.path.join(os.path.expanduser("~"), ".bund", "history")
        # try:
        #     readline.read_history_file(histfile)
        #     readline.set_history_length(1000)
        # except FileNotFoundError:
        #     open(histfile, 'wb').close()
        # atexit.register(readline.write_history_file, histfile)
    def run(self, argv):
        self.app.LOG.info("In the %s.run"%__name__)
        self.app.run(argv)
    def __del__(self):
        self.debug("In the %s.__del__"%__name__)
