from prompt_toolkit import PromptSession
from prompt_toolkit.styles import Style
from prompt_toolkit.history import FileHistory
from prompt_toolkit.auto_suggest import AutoSuggestFromHistory
from pygments.lexers.lisp import HyLexer
from prompt_toolkit.lexers import PygmentsLexer
from cliff.interactive import InteractiveApp

class BUND_INTERACTIVE(InteractiveApp):
    def cmdloop(self):
        style = Style.from_dict({
            '':          '#e0f8ff',
            'rightr': 'green',
            'leftr': 'yellow',
            'word': 'cyan',
        })
        if self.parent_app.options.no_color:
            self.prompt = "( theBund ) "
        else:
            self.prompt =  [
                ('class:leftr', '( '),
                ('class:word',       'theBund'),
                ('class:rightr',     ' ) '),
            ]
        histfile = os.path.join(self.parent_app.Globals["BUND_HOME"], "history")
        session = PromptSession(self.prompt,
                                style = style,
                                history=FileHistory(histfile),
                                lexer=PygmentsLexer(HyLexer),
                                auto_suggest=AutoSuggestFromHistory())
        self.parent_app.display_version()
        if not self.parent_app.options.yes_lisp:
            self.parent_app.LOG.debug("Using pipelining syntax")
        else:
            self.parent_app.LOG.debug("Using Lisp syntax")
        while True:
            try:
                cmd = session.prompt().strip()
            except KeyboardInterrupt:
                break
            except EOFError:
                break
            if cmd.lower() in ['(exit)', '(quit)']:
                break
            if not self.parent_app.options.yes_lisp:
                pipeline = """(-> %s )"""%cmd
            else:
                pipeline = cmd
            self.parent_app.LOG.debug("""Evaluating: %s"""%pipeline)
            res = bund_eval(pipeline, self.parent_app, self.parent_app.shell)
            if self.parent_app.options.yes_print:
                if self.parent_app.options.no_color:
                    print(res)
                else:
                    print(colored(str(res), "magenta"))

