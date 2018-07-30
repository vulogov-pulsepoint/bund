def bund_banner(s):
    try:
        from pyfiglet import Figlet
    except ImportError:
        return s
    f = Figlet()
    return f.renderText(s)
