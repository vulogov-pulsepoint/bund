def repeat(fun, log_fun, max_attempts, msg="Attempt: "):
    """
    Repeat function X until it returned True, otherwise number of times, with logging

    1. :param fun: Function
    2. :param log_fun: Logging function
    3. :param max_attempts: Maximum number of attempts
    4. :param msg: Add to a message
    5. :return: True/False
    """
    c = 0
    while c < max_attempts:
        log_fun("info", "%s (# %d)"%(msg, c))
        c += 1
        try:
            res = fun()
        except:
            continue
        if res != False:
            return True
    return False

def banner(s):
    try:
        from pyfiglet import Figlet
    except ImportError:
        return s
    f = Figlet()
    return f.renderText(s)

def dehumanize_time(_str, _default):
    try:
        import humanfriendly
        return humanfriendly.parse_timespan(_str)
    except KeyboardInterrupt:
        return _default

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
        try:
            url = urllib.FancyURLopener()
            s = url.open(_ref).read().strip()
            url.close()
        except:
            return None
        finally:
            return s
    elif _ref[0] == '=':
        from github import Github
        _repo, _path = _ref[1:].split(':')
        g = Github()
        r = g.get_repo(_repo)
        return base64.b64decode(r.get_contents(_path).content)
    else:
        ## Return the value as is
        return _ref

def load_query_from_the_reference(_ref):
    _q = load_file_from_the_reference(_ref)
    if not _q:
        return None
    return list_2_buffer(buffer_2_list(_q))

def load_and_parse_from_the_reference(_ref, kw):
    buf = load_file_from_the_reference(_ref)
    if not buf:
        return buf
    try:
        tpl = string.Template(buf)
        res = tpl.safe_substitute(kw)
    except:
        return None
    finally:
        return res


def check_reference_read(_ref, _dir=False):
    if _ref[0] == "@":
        ## In 0.2 we do not know how to check URL references
        return True
    if _ref[0] == '=':
        ## In 0.6 we do not thoroughly check GitHub
        return True
    if _ref[0] == "+":
        _ref = _ref[1:]
    if _dir:
        return check_directory(_ref)
    else:
        return check_file_read(_ref)

def print_dict(_shell, _dict):
    if _shell == None:
        return
    for i in _dict.keys():
        _shell.ok(": %-25s : %-50s ;"%(i,repr(_dict[i])))

def extract_key_from_info(_info, main_key, search_key):
    res = []
    if not _info.has_key(main_key):
        return res
    if type(_info[main_key]) != types.ListType:
        return res
    for d in _info[main_key]:
        if type(d) == types.DictType and d.has_key(search_key):
            res.append(d[search_key])
    return res

def extract_key_from_list(_list, _key):
    out = []
    for d in _list:
        if not d.has_key(_key):
            continue
        if d[_key] not in out:
            out.append(d[_key])
    return out

def list2listofdicts(_list, key):
    out = []
    for i in _list:
        out.append({key: i})
    return out

def listofdict2list(_list, _key):
    out = []
    for i in _list:
        if i.has_key(_key):
            out.append(i[_key])
    return out

def discover_element(ctx, _type, _elem):
    if not _elem.has_key(_type):
        ctx.push(_elem)
    else:
        return _elem[_type]
    return None


def do_template(_buffer, _kw=os.environ, **kw):
    for k in kw.keys():
        _kw[k] = kw[k]
    tpl = string.Template(_buffer)
    res = tpl.safe_substitute(_kw)
    return res

def pull_elements_from_stack_by_type(ctx, *_types):
    out = {}
    _continue = True
    while True:
        if not _continue:
            break
        p = ctx.pull()
        if not p:
            break
        for k in p.keys():
            if k in _types:
                if k not in out.keys():
                    out[k] = p[k]
                else:
                    out[k] += p[k]
            else:
                ctx.push(p)
                _continue = False
                break

    return out

def push_elements_back_to_stack(ctx, _data):
    for k in _data.keys():
        Push(ctx, k, _data[k])


def rename_keys_from_aliases(_data, _aliases):
    for k in _data.keys():
        if k in _aliases.keys():
            _data[_aliases[k]] = _data[k]
            del _data[k]
    return _data

def set_dict_default(_d, _key, _default):
    if _d.has_key(_key):
        return _d
    _d[_key] = _default
    return _d

def create_module(name, _kw, desc="", **kw):
    import types
    for k in kw.keys():
        _kw[k] = kw[k]
    m = types.ModuleType(name, desc)
    m.__dict__.update(_kw)
    return m




