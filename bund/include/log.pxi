from rainbow_logging_handler import RainbowLoggingHandler

def Debug(ctx, msg, **kw):
    ctx.ctx.Debug(msg%kw)
    return ctx
def Info(ctx, msg, **kw):
    ctx.ctx.Info(msg%kw)
    return ctx
def Error(ctx, msg, **kw):
    ctx.ctx.Error(msg%kw)
    return ctx
def Warning(ctx, msg, **kw):
    ctx.ctx.Warning(msg%kw)
    return ctx
def Critical(ctx, msg, **kw):
    ctx.ctx.Critical(msg%kw)
    return ctx

class BUND_LOG_ADAPTER:
    def init_log_methods(self):
        self.Debug("(Global (Log.* ...))")
        m = make_module_on_the_fly("Log",
                                   Debug=Debug,
                                   Info=Info,
                                   Error=Error,
                                   Warning=Warning,
                                   Critical=Critical)
        self.registerGlobal(Log=m)
        self.registerGlobal(Debug=self.Debug,
                            Info=self.Info,
                            Warning=self.Warning,
                            Error=self.Error,
                            Critical=self.Critical)
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
    def Debug(self, msg, **kw):
        self.LOG.debug(msg%kw)
    def Info(self, msg, **kw):
        self.LOG.info(msg%kw)
    def Warning(self, msg, **kw):
        self.LOG.warning(msg%kw)
    def Error(self, msg, **kw):
        self.LOG.error(msg%kw)
    def Critical(self, msg, **kw):
        self.LOG.critical(msg%kw)




class BUND_LOG:
    def debug(self, msg):
        self.app.LOG.debug(msg)
    def warning(self, msg):
        self.app.LOG.warning(msg)
    def error(self, msg):
        self.app.LOG.error(msg)