from hy.lex import parser, lexer
from hy.importer import hy_eval
from hy import HyList


def string_to_quoted_expr(s):
    return HyList(parser.parse(lexer.lex(s)))

def bund_eval(_line, env=None, _shell=None):
    if env != None and not env.cfg["ZQ_UNSAFE_GLOBALS"]:
        if _shell != None:
            _shell.ok("Using safe globals")
        e = env.Globals
    else:
        if _shell != None:
            _shell.warning("Using unsafe globals")
        e = globals()
    return hy_eval(string_to_quoted_expr(_line), e, 'zq')[0]
