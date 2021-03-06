from hy.lex import parser, lexer
from hy.importer import hy_eval
from hy import HyList


def string_to_quoted_expr(s):
    try:
        return HyList(parser.parse(lexer.lex(s)))
    except:
        print(tbvaccine.TBVaccine().format_exc())
        sys.exit(12)

def bund_eval(_line, env=None, _shell=None):
    if not env:
        e = globals()
    else:
        e = env.Globals
    try:
        parsed = string_to_quoted_expr(_line)
    except:
        print(tbvaccine.TBVaccine().format_exc())
        sys.exit(11)
    try:
        return hy_eval(parsed, e, 'bund')[0]
    except:
        print(tbvaccine.TBVaccine().format_exc())
        sys.exit(10)

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