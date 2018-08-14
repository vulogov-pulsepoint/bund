class BUND_IMPORT_ADAPTER:
    def __init__(self):
        self.mcache = FilesCache(self)
    def initialize_fscache(self):
        mcpath = os.path.join(self.Globals["BUND_HOME"], "modcache")
        self.Debug("Initializing modules cache in %s"%mcpath)
        self.mcache.fsinit(mcpath, int(self.Globals["BUND_MODCACHE_EXPIRE"]))
        if not self.mcache.update():
            self.Warning("Error during update of the modules cache")
    def init_import_methods(self) :
        self.Debug("(Global (Import.* ...))")
        m = make_module_on_the_fly("Import",
                                   hyx_Set_XgreaterHthan_signX=self.setGlobal,
                                   Path=self.Import_Add_Path,
                                   hyx_Xplus_signXXplus_signX=self.Import_Load_and_Import)
        self.registerGlobal(Import=m)
    def Import_Add_Path(self, ctx, *dirs):
        VALIDATE(ctx)
        for d in dirs:
            if not check_directory(d):
                FAIL(ctx, "(Import.Path): Directory %s not exists"%d)
                return ctx
            if d not in sys.path:
                ctx.ctx.Debug("(Import.Path): adding %s"%d)
        return ctx
    def Import_Load_and_Import(self, ctx, *refs):
        VALIDATE(ctx)
        for r in refs:
            _name, _r = r
            self.Debug("(Import.++): Loading %s"%_n)
            res = self.mcache.add(_n, _r)
            if not res:
                self.Error("(Import.++): failed from %s"%_r)
                return FAIL(ctx, "Failed import")

        return ctx
    def Import_Module(self, name):
        return True
