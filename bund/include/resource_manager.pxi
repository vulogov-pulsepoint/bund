

class Resource(dict):
    pass

class ResourceManager(dict):
    def allocate(self, resource):
        if resource not in self.keys():
            self[resource] = Resource()