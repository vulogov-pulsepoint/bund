import readline
from cliff.interactive import InteractiveApp

class BUND_INTERACTIVE(InteractiveApp):
    def cmdloop(self):
        readline.parse_and_bind("tab: complete")
        if self.parent_app.options.no_color:
            self.prompt = "( theBund ) "
        else:
            self.prompt = "%s%s%s"%(colored("( ", "yellow"), colored("theBund", "cyan"), colored(" ) ", "green"))
        self.parent_app.display_version()
        while True:
            self.stdout.write(self.prompt)
            self.stdout.flush()
            try:
                cmd = input().strip()
            except KeyboardInterrupt:
                break
            except EOFError:
                break
            if cmd.lower() in ['(exit)', '(quit)']:
                break
            pipeline = """(-> %s )"""%cmd
            res = bund_eval(pipeline, None, None)
            if self.parent_app.options.yes_print:
                if self.parent_app.options.no_color:
                    print(res)
                else:
                    print(colored(str(res), "magenta"))

