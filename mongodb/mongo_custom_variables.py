import os, os.path, sys, shutil
import git
import hashlib
from distutils.spawn import find_executable

# Figure out a few git related values 
repo = git.Repo()
gitdescribe = repo.git.describe(abbrev=0)
working_tree_dir = os.path.realpath(repo.working_tree_dir)
root_dir = os.path.realpath(repo.git.rev_parse("--show-toplevel"))
short_working_dir = working_tree_dir.split('/')[-1]

# Build a hash that loosely describes how we've mutated this build environemnt
args = list(filter(lambda token: token[0:2] == '--', sys.argv[1:]))
args.append(working_tree_dir)
arghash = hashlib.md5(' '.join(args).encode()).hexdigest()

# The BUILD_ROOT is resolved before this script sadly...
#BUILD_ROOT = "{}/build".format(root_dir)

# Set out version and hash
MONGO_GIT_HASH = "unknown"
MONGO_VERSION = gitdescribe.lstrip('r')

# Set up the variant dir complete with nice symlink
VARIANT_DIR = "variants/{}-{}".format(gitdescribe, arghash)
real_variant_dir = "build/{}".format(VARIANT_DIR)
nice_variant_dir = "build/variants/{}".format(short_working_dir)
try:
    os.remove(nice_variant_dir)
except:
    pass

os.makedirs(real_variant_dir, exist_ok=True)
os.symlink("{}-{}".format(gitdescribe,arghash), nice_variant_dir)

# Set a variety of nice to have variables
CXXFLAGS = ' '.join(['-fPIC', '-fno-var-tracking', '-fstack-check'])
if os.environ.get("USE_ICECC", "yes") != "no":
    ICECC = '/opt/icecream/bin/icecc'
    ICECC_CREATE_ENV = '/opt/icecream/bin/icecc-create-env'
    #ICECC = '/usr/lib/icecream/bin/icecc'
    #ICECC_CREATE_ENV = '/usr/lib/icecream/bin/icecc-create-env'
CACHE_SIZE = 10

# Add the enterprise module if it exists
enterprise_dir = "{}/src/mongo/db/modules/enterprise".format(root_dir)
if os.path.isdir(enterprise_dir):
    MONGO_MODULES = "enterprise"

DESTDIR = "{}/install".format(root_dir)
