APP = None

def shell():
    global APP
    APP = BUND_APP()
    bund_app = APP
    return bund_app.run(argv=sys.argv[1:])
