REF_ERROR_LOADING = -1
REF_ERROR_EXEC = -2


def load_file_from_the_reference(_ref):
    if _ref[0] == "+":
        ## This is a file path
        _ref = _ref[1:]
        if not check_file_read(_ref):
            return None
        return open(_ref).read()
    elif _ref[0] == "@":
        ## This is URL
        _ref = _ref[1:]
        s = None
        ctx = ssl.create_default_context()
        ctx.check_hostname = False
        ctx.verify_mode = ssl.CERT_NONE
        try:
            s = request.urlopen(_ref, context=ctx).read()
        except:
            return None
        finally:
            return s
    elif _ref[0] == '=':
        from github import Github
        import warnings
        warnings.filterwarnings("ignore", category=ResourceWarning)
        _repo, _path = _ref[1:].split(':')
        g = Github()
        r = g.get_repo(_repo)
        return base64.b64decode(r.get_contents(_path).content).decode()
    else:
        ## Return the value as is
        return _ref

def execute_from_the_reference(_ref, _app=None, _shell=None):
    try:
        cmd = load_file_from_the_reference(_ref)
        if cmd == None:
            return (REF_ERROR_LOADING,"")
    except:
        return (REF_ERROR_LOADING,"")
    try:
        pipeline = """(-> %s )"""%cmd
        res = bund_eval(pipeline, _app, _shell)
    except:
        return (REF_ERROR_EXEC, "msg")
    return (0,"")
