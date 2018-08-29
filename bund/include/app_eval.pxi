from cliff.command import Command


class BUND_APP_EVAL(Command):
    log = logging.getLogger("bund")
    def get_parser(self, parser):
        self.app.Debug("Building parser for %s"%parser)
        _parser = super(BUND_APP_EVAL, self).get_parser(parser)
        _parser.add_argument('reference', default=None)
        _parser.add_argument('args', nargs='*', default=None)
        return _parser
    def parse_script_args(self, args):
        d = {'files': []}
        a = None
        for i in args:
            if i[0] == "/":
                a = i[1:].lower()
                if a not in d.keys():
                    d[a] = []
            elif a != None and i != ":":
                d[a].append(i)
            elif i == ":":
                a = None
            elif a == None and i != ":":
                d['files'].append(i)
            else:
                pass
        self.app.Debug("Passed args to the script: %s"%str(d))
        self.app.registerGlobal(ARGS=d)

    def take_action(self, parsed_args):
        if not parsed_args.reference:
            self.app.Error("You must provide a reference to your theBund script")
            return False
        self.parse_script_args(parsed_args.args)
        res, msg = execute_from_the_reference(parsed_args.reference, self.app, self.app.shell)
        self.app.Debug("eval() returns %d %s"%(res, msg))
        if res == 0:
            return True
        elif res == REF_ERROR_LOADING:
            self.app.Error("Error loading %s"%parsed_args.reference)
        elif res == REF_ERROR_EXEC:
            self.app.Error("Error executing %s"%parsed_args.reference)
            print(tbvaccine.TBVaccine().format_exc())
        return True



