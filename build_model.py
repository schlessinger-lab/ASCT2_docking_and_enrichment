
# Homology modeling with multiple templates
from modeller import *              # Load standard Modeller classes
from modeller.automodel import *    # Load the automodel class

log.verbose()    # request verbose output
env = environ()  # create a new MODELLER environment to build this model in

# directories for input atom files
env.io.atom_files_directory = ['.', '../atom_files']
# Read in HETATM records from template PDBs
env.io.hetatm = True
env.io.water = True


a = automodel(env,
              alnfile  = '5MJU-RAT_SLC1A5.pir', # alignment filename
              knowns   = ('5MJU'),     # codes of the templates
              sequence = 'RAT_SLC1A5')     # code of the target
a.starting_model= 1                 # index of the first model
a.ending_model  = 100               # index of the last model
                                    # (determines how many models to calculate)


a.assess_methods = (assess.GA341, 
                    assess.DOPE,
                    assess.DOPEHR,
                    assess.normalized_dope)


a.make()                            # do the actual homology modeling


