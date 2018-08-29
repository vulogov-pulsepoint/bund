class BUND_CONFIG_ADAPTER:
    def load_configuration(self):
        if self.options.config_reference:
            self.LOG.debug("Loading configuration from %s ..."%self.options.config_reference)
            res, msg = execute_from_the_reference(self.options.config_reference, self, self.shell)
            if res == REF_ERROR_LOADING:
                self.LOG.critical("Error loading configuration from %s"%self.options.config_reference)
            elif res == REF_ERROR_EXEC:
                self.LOG.exception("Error executing %s"%self.options.config_reference)
            else:
                self.ready += 1
        else:
            self.LOG.warning("You did not specified reference to the configuration")
            self.ready += 1
    def load_bootstrap(self):
        if self.options.bund_bootstrap:
            self.LOG.debug("Bootstrapping from %s ..."%self.options.bund_bootstrap)
            res, msg = execute_from_the_reference(self.options.bund_bootstrap, self, self.shell)
            if res == REF_ERROR_LOADING:
                self.LOG.critical("Error bootstrapping from %s"%self.options.config_reference)
            elif res == REF_ERROR_EXEC:
                self.LOG.exception("Error bootstrapping %s"%self.options.config_reference)
            else:
                self.ready += 1
        else:
            self.LOG.info("You did not specified reference to the bootstrap")
            self.ready += 1
    def init_private_home(self):
        self.Globals["BUND_HOME"] = os.path.expanduser(self.Globals["BUND_HOME"])
        if not check_directory(self.Globals["BUND_HOME"]):
            os.mkdir(self.Globals["BUND_HOME"])


