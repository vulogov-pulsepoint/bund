from distutils.core import setup
from distutils.extension import Extension
from Cython.Build import cythonize

ext_modules=[
    Extension("bund",
              sources=["bund/bund.pyx"],
              include_dirs=['bund/include'],
              language='c',
              extra_objects=[],
              extra_link_args=[],
              )
]


setup(
    name = "bund",
    ext_modules = cythonize(ext_modules),
    version='0.1',
    packages=[],
    url='',
    license='',
    author='Vladimir Ulogov',
    author_email='',
    description=''
)
