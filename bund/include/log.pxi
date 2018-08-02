from rainbow_logging_handler import RainbowLoggingHandler

# class BUND_APP_LOG(CementBaseController):
#     class Meta:
#         label = 'color_log'
#         arguments = [
#             (['--no-color'],
#              dict(help="disable colorized output", action='store_true')),
#         ]
#
# class BUND_LOG_HANDLER(LoggingLogHandler):
#     class Meta:
#         label = "color_log"
#
#         #: The logging format for the consoler logger.
#         console_format = "%(log_color)s%(levelname)s: %(message)s"
#
#         #: The logging format for both file and console if ``debug==True``.
#         debug_format = "%(log_color)s%(asctime)s (%(levelname)s) %(namespace)s : " + \
#                        "%(message)s"
#
#     def _setup_console_log(self):
#         # Otherwise
#         to_console = self.app.config.get(self._meta.config_section, 'to_console')
#         formatter = logging.Formatter("BOO [%(asctime)s] %(name)s %(funcName)s():%(lineno)d\t%(message)s")  # same as default
#         handler = RainbowLoggingHandler(sys.stderr, color_funcName=('black', 'yellow', True))
#         handler.setFormatter(formatter)
#         self.backend.addHandler(handler)
#
#
#
# # class BUND_LOG_HANDLER(ColorLogHandler):
# #     class Meta:
# #         label = 'bund_log'
# #         colors = {
# #             'DEBUG':    'cyan',
# #             'INFO':     'green',
# #             'WARNING':  'yellow',
# #             'ERROR':    'red',
# #             'CRITICAL': 'red,bg_white',
# #         }

class BUND_LOG_ADAPTER:
    def configure_logging(self):
        """Create logging handlers for any log output.
        """
        root_logger = logging.getLogger('bund')
        root_logger.setLevel(logging.DEBUG)

        # Set up logging to a file
        if self.options.log_file:
            file_handler = logging.FileHandler(
                filename=self.options.log_file,
            )
            formatter = logging.Formatter(self.LOG_FILE_MESSAGE_FORMAT)
            file_handler.setFormatter(formatter)
            root_logger.addHandler(file_handler)

        # Always send higher-level messages to the console via stderr
        console = logging.StreamHandler(self.stderr)
        console_level = {0: logging.WARNING,
                         1: logging.INFO,
                         2: logging.DEBUG,
                         }.get(self.options.verbose_level, logging.DEBUG)
        console.setLevel(console_level)
        formatter = logging.Formatter(self.CONSOLE_MESSAGE_FORMAT)
        console.setFormatter(formatter)
        root_logger.addHandler(console)
        return

class BUND_LOG:
    def debug(self, msg):
        self.app.LOG.debug(msg)