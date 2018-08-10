from rainbow_logging_handler import RainbowLoggingHandler



class BUND_LOG_ADAPTER:
    def configure_logging(self):
        root_logger = logging.getLogger('bund')
        root_logger.setLevel(logging.DEBUG)

        # Set up logging to a file
        self.LOG_FILE_MESSAGE_FORMAT = '%(asctime)s - %(name)s - %(levelname)s - %(message)s'
        self.CONSOLE_MESSAGE_FORMAT = "[%(asctime)s] %(levelname)-8s\t%(message)s"
        if self.options.log_file:
            file_handler = logging.FileHandler(
                filename=self.options.log_file,
            )
            formatter = logging.Formatter(self.LOG_FILE_MESSAGE_FORMAT)
            file_handler.setFormatter(formatter)
            root_logger.addHandler(file_handler)

        # Always send higher-level messages to the console via stderr
        if self.options.no_color:
            console = logging.StreamHandler(self.stderr)
        else:
            console = RainbowLoggingHandler(sys.stderr,
                                            color_funcName=('black', 'yellow', True),
                                            color_asctime=('magenta', 'black', True))
        console_level = {1: logging.CRITICAL,
                         2: logging.ERROR,
                         3: logging.WARNING,
                         4: logging.INFO,
                         5: logging.DEBUG
                         }.get(self.options.verbose_level, logging.CRITICAL)
        console.setLevel(console_level)
        formatter = logging.Formatter(self.CONSOLE_MESSAGE_FORMAT)
        console.setFormatter(formatter)
        root_logger.addHandler(console)
        self.LOG = root_logger
        return

class BUND_LOG:
    def debug(self, msg):
        self.app.LOG.debug(msg)
    def warning(self, msg):
        self.app.LOG.warning(msg)
    def error(self, msg):
        self.app.LOG.error(msg)