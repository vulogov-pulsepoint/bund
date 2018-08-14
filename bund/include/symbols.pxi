Eq = lambda x,y: x == y
Ne = lambda x,y: x != y
Gt = lambda x,y: x > y
Gte = lambda x,y: x >= y
Lg = lambda x,y: x < y
Lge = lambda x,y: x <= y

TRUE = lambda x,y: True
FALSE = lambda x,y: False
T = 1
F = 0
NONE = None
NEW = "NEW"
PULL = "PULL"
DEFAULT = "DEFAULT"
Default = "default"
CR = "\n"

def Match(x,y):
    import re,fnmatch
    if fnmatch.fnmatch(x,y) == True:
        return True
    else:
        return False


class BUND_SYMBOLS_ADAPTER:
    def init_symbols_methods(self):
        self.Debug("(Global Symbols ...)")
        self.registerGlobal(Eq=Eq,
                            Ne=Ne,
                            Gt=Gt,
                            Gte=Gte,
                            Lg=Lg,
                            Lge=Lge,
                            TRUE=TRUE,
                            FALSE=FALSE,
                            T=1,
                            F=0,
                            NONE=None,
                            NEW=NEW,
                            PULL=PULL,
                            DEFAULT=DEFAULT,
                            Default=Default,
                            CR=CR)