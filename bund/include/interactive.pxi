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
        histfile = os.path.join(os.path.expanduser("~"), ".bund", "history")
        session = PromptSession(self.prompt,
                                style = style,
                                history=FileHistory(histfile),
                                lexer=PygmentsLexer(HyLexer),
                                auto_suggest=AutoSuggestFromHistory())
        self.parent_app.display_version()
        while True:
            try:
                cmd = session.prompt().strip()
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

