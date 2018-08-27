from cliff.command import Command


class BUND_APP_EVAL(Command):
    log = logging.getLogger("bund")
    def get_parser(self, parser):
        self.app.Debug("Building parser fpr %s"%parser)
        _parser = super(BUND_APP_EVAL, self).get_parser(parser)
        _parser.add_argument('reference', default=None)
        _parser.add_argument('args', nargs='*', default=None)
        return _parser
    def take_action(self, parsed_args):
        if not parsed_args.reference:
            self.app.Error("You must provide a reference to your theBund script")
            return False
        res, msg = execute_from_the_reference(parsed_args.reference, self.app, self.app.shell)
        self.app.Debug("eval() returns %d %s"%(res, msg))
        if res == 0:
            return True
        elif res == REF_ERROR_LOADING:
            self.app.Error("Error loading %s"%parsed_args.reference)
        elif res == REF_ERROR_EXEC:
            self.app.Error("Error executing %s"%parsed_args.reference)
            self.app.LOG.exception("Boo")
        return True



