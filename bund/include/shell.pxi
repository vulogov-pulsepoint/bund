def shell():
    app = BUND_APP()
    app.run()
    del app
    return True
