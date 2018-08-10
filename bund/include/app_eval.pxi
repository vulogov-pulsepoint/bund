from cliff.command import Command


class BUND_APP_EVAL(Command):
    log = logging.getLogger("bund")

    def take_action(self, parsed_args):
        self.log.info('sending greeting')
        self.log.debug('debugging')
        self.log.error('error')
        self.log.warning('warning')
        self.log.critical('critical '+__name__)



