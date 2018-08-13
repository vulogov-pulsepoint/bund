from hy.lex import parser, lexer
from hy.importer import hy_eval
from hy import HyList


def string_to_quoted_expr(s):
    return HyList(parser.parse(lexer.lex(s)))

def bund_eval(_line, env=None, _shell=None):
    if not env:
        e = globals()
    else:
        e = env.Globals
    return hy_eval(string_to_quoted_expr(_line), e, 'bund')[0]

class BUND_EVAL_ADAPTER:
    def init_eval_methods(self):
        self.Debug("(Global (Eval.* ...))")
        self.registerGlobal(hyx_Xequals_signXXequals_signXXgreaterHthan_signX=self.getContext)
    def contextType(self):
        return "context"
    def getContext(self, **kw):
        self.Debug("Returning current context")
        ctx = merge_two_dicts({'data': self, 'type': 'context', 'name': self.id}, kw)
        o = BUND_VALUE(self)
        o.init_object(ctx)
        return o