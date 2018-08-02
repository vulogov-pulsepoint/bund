def shell():
    bund_app = BUND_APP()
    return bund_app.run(argv=sys.argv[1:])
