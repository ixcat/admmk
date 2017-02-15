
Adm.mk Development Guide
========================
.. todo: actually pin down to specific targets / makefiles

Overview
--------

This document is intended to document more deeply the adm.mk
makefile internals. Currently it is a collection of rough and 
unaudited notes - the best reference is still the makefiles 
themselves.

Bmake Notes w/r/t adm.mk
------------------------

fully-dynamic targets:

  - define list-variable of common targets somewhere
  - += optionally module-specific set
  - iterate over this list and set modname-tgtname-varname vars
  - these dynamic, target-local variables can then be used from within
    .USE targets to construct targets which contain references to
    the dynamic variables (e.g. a 'closure' of sorts around the variables)
    via the use of the .TARGET variable (.TARGET becomes a 'this pointer')
    which can be used to access the 'symbol table' of .{TARGET}-varname
    since .TARGET will be set as 'modname-tgtname'

more on variable expansion:

  - targets are 'definitions' (e.g. as in scheme (define) )
  - variables are 'global state' 
    (since they fluctuate, leaving the last-set value as the active one)
  - target-actions are 'curries'-ish - e.g. deferred computations
    which will use the last-set global variable values
  - therefore include sequence / target definition and variable setting 
    sequence is important as concerns execution of targets

Adm.mk Build Phase Internals
----------------------------

generic/abstract build phase / sequence process from a host module

pregeninclude:

  - preset/override top-level vars/targets (not usually)

geninclude: #includefile

  - set top level vars
  - set top level targets
  - define host:service matrix for use by svc include logic, bulk targets

postgeninclude:
presvcinclude:

  - set host-specific variables
  - define host-specific targets
  - prepend host-specific targets to build

svcinclude: #includefile

   - set build type (perhost,allhost,persvc,allsvc) via moduletype include
   - include service makefiles to define per-service vars/targs
   - done manually, or ***via some mechanism? (e.g. moduletype?)

postsvcinclude:

  - override service-specific variables

prebuildinclude:

  - append host-specific targets to build

buildinclude:

  - include build-driver to chain remaining build logic

postbuildinclude:

  - shouldn't really be used..

Library Makefile Include Sequence
---------------------------------

Note: both of the subsections outlined here were extracted from
rough development notes and have not been audited for correctness.

Generically at Top Level
~~~~~~~~~~~~~~~~~~~~~~~~

  - host build is the main build.
    other targets just aggregate / inject into certain parts of this..
  - so, get a clean host build, and other build types should follow.


# _preinit 
sys.mk
			service configuration
			define hosts, services. map services to hosts.
	sys.inc.mk
			reverse map hosts to services? (if needed)

# _init
adm.init.mk
			top-level definitions
			tool definitions, 'final' top level variables,
			create global/generic targets,
			determine build type, etc.

# _moddefs
adm.modtype.mk
	adm.mod.mk
			per-module definitions, targets, etc
			including actions, specific targets, etc.

# _globaldefs
adm.prog.mk
	adm.buildtype.mk
			build-type chaining of per-module targets into
			global targets

<run>

Specifically
~~~~~~~~~~~~

  - sys.mk
  - adm.init.mk
    - adm.own.mk

  - adm.obj.mk : BLANK 
  - adm.subdir.mk
    - adm.init.mk

  - adm.prog.mk
    - adm.init.mk
    - adm.build.mk
      - adm.hosts.build.mk
      - adm.host.build.mk
      - adm.svcs.build.mk
      - adm.svc.build.mk
        - adm.act.mk
    - adm.dirs.mk : objdir
      - adm.init.mk
    - adm.files.mk
      - adm.init.mk

  - adm.mod.mk
    - adm.mod.dirs.mk
    - adm.mod.files.mk

  - adm.host.mk
    - adm.mod.mk
  - adm.svc.mk
    - adm.mod.mk

  - adm.own.mk
  - adm.files.mk

Library Makefile Type Notes
---------------------------

   - adm.mod.*:
     - module logic - defines 'module component targets'
       e.g: onefile, thefiles, ${MODNAME}-<aggregate>

   - adm.build.*:
     - global build logic - defines top-level target

Caveats
-------

- bulk host and bulk svc targets currently assume a specific flat 
  directory structure ($SYS/src/{svc,host}/{svcname,hostname}

  proper usage/functionality of overriding related variables has not 
  been tested, and still won't work due to assumptions in make-driver
  targets for these (e.g. cd $SYS/src/host/$HOSTNAME kind of things)

  this could probably simply be set via variable lists in sys.mk e.g.:

    SVCS+= wwws3
    wwws3_path= src/svc/www/s3

  so that the driver targets could use variable substitution/expansion 
  on these assumed variable names to drive builds ... however, 
  this has not yet been implemented.

