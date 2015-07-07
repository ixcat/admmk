.. $Id$

============
Adm.mk Guide
============

Overview
--------

This is adm.mk, a makefile library for systems management. 

The distribution is intended to be installed into a systems managment
repository hosting the actual site-local logic needed to manage a
given site.

Setup & Prerequsites
--------------------

The adm.mk system currently requires a suitably modern version of
PMake - a copy from the NetBSD 6.0.1 sources is available within
the top level ext/ directory, as is a reference to a binary package
for RHEL systems.

Additionally, for remote management, host and target systems should
also have an installed rdist(1) utility, and functioning SSH access.

Other various unix utilities are used internally within the build
tree- a reasonably modern system should generally be compatible.
Testing is primarily performed on OpenBSD and Linux, with care taken
to use the most traditional flags and modes of operation of system
utilities.

The system itself is intended to be installed into a project
tree containing the host files. Setup is therefore roughly as follows:

  1) Create a project. Since project creation would vary by local 
     procedures, version control systems, etc, here, we 
     assume a simple unversioned directory structure with no
     tracking of the imported version of adm.mk::

       $ mkdir ~/admin

  2) Install the adm.mk system into the new project directory::

       $ ./configure --project=~/admin && make install

  3) Implement site-local policies and services within ~/admin/src .

     Specifically required is the 'src/sys.mk' configuration file,
     which defines at a top level which hosts and services should
     be considered as active in the given managed base. The 
     adm.mk installation logic will create a blank template if
     this file does not exist initially at install time.

     Currently, the system expects that common services are kept in
     the src/svc subdirectory of a project, whereas host-specific
     configurations are kept in the src/host subdirectory.

     Some toy examples of per-host and per service makefiles are 
     provided in the 'doc/example-src' directory which can be used
     as templates for implementing your services until more
     comprehensive user documentation of configuration settings
     is implemented. 

Since the system expects to write into a projects /mk and /bin
area, provision is also made for a  /mk.local directory to
store site-local macros and extensions to the base system -
this directory is included via PMake's '-m' mechanism -
so files placed here with the same name as adm.mk provided
files will completely override the adm.mk versions.

System Managment Process Overview
---------------------------------

In general, the adm.mk framework assumes that a managed system is
a system onto which a specific selection of configuration logic is
applied. Since the current assumption is that these systems are all
unix-like systems, this would typically entail ensuring that a given
selection of software is installed, and that appropriate configuration
files and initialization scripts are installed and executed on the
target.

More specifically, a system managed using the adm.mk framework
is composed of the following components:

  - host-specific configuration modules
  - common service configuration modules
  - the adm.mk build logic itself

The build process then distributes the configuration modules to the
target host. In the case of native (e.g. host-local) installations,
this is done by directly applying the files to the host system via
make(1), whereas in the case of remotely managed systems, make(1)
is used to stage a per-host build object tree which is then distributed
to the target hosts in the install phase through execution of the
rdist(1) command.

After the files have been installed, post-installation logic
can then execute any follow up actions on the target host
via the installation action framework outlined in adm.act.inc.mk,
which will run specific ~root/bin/modulename.svc scripts with
a pre-defined selection of actions. 

Build Organization & Target Structure
-------------------------------------

As mentioned in the section `System Managment Process Overview`_,
the adm.mk framework operates primarily via staging, distribution,
and the subsequent application of configured per-host and common
service configuration on the target host.

Main phases, and therefore build targets, of the build process
are:

  - stage
  - install

with the default phase being 'install'. In the case of
native-mode installations, the two are equivelant,
since there is no rdist(1) file distribution step.

This section attempts to outline, at a slightly lower level,
the actual build process in general and also as concerns 
specific build types.

Generally, there are 4 main types of builds supported by
the adm.mk framework:

  - an all-hosts build
  - a per-host build
  - an all-services build
  - a per-service build (distribution phase not implemented)

At the core, the main 'unit' of a system build is an individual
target host, with the other build types being defined in relation
to this concept. Each of the 4 main build types are documented 
in more detail below.

All-Hosts Build
~~~~~~~~~~~~~~~

The all-hosts build is a build-driver which triggers sub-builds for
all configured hosts in sequence.

From an all-hosts build directory, it is also possible to trigger
the related per-host target via <action>-<hostname> targets - 
for example, stage-host1, etc.

Per-Host Build
~~~~~~~~~~~~~~

As mentioned above, the per-host build is the primary build type
within the adm.mk framework. The per-host build will first stage
any per-host objects, subsequently triggering a per-service build
for all configured services on the host.

From a per-host build directory, it is also possible to trigger
the related per-service target via <action>-<servicename> targets -
for example, stage-svc1, etc. 

All-Services Build
~~~~~~~~~~~~~~~~~~

The all-services build, much like the all-hosts build, is a
build-driver which triggers sub-builds for all configured services
in sequence.

From an all-services build directory, it is also possible to trigger
the related per-service target via <action>-<servicename> targets - 
for example, stage-svc1, etc.

Per-Service Build
~~~~~~~~~~~~~~~~~

The per-service build builds an individual service for all of its
configured hosts. Currently, since the file distribution logic
distributes all staged host-specific files, no per-service distribution
target is available since this could result in mis-distribution of
other staged files. This limitation is not inherent to the adm.mk
system as a whole, resulting instead from incomplete development,
and is expected to be remedied in a future revision.

From a per-service build directory, it is also possible to trigger
the related per-host target via <action>-<hostname> targets -
for example, stage-host1, etc. 

Target Reference
----------------

Globally available top level 'user' targets are as follows:

# build related
- install
  - stage: bd
  - push: bd
- postinstall

# action related
- bininstall
- binupdate
- svcstart
- svcstop
- svcrestart
- svcupdate

notes:
* bd: buildtype dependant

module-level targets:

- <host>-<service>-<target>
  h1-s1-install, h1-s1-postinstall

- <host>-<target>:
  - <host>-host-<target> : for host-module defines
  - <host>-<target> : per-host-aggregator targets
     hook <host>-<service>-<target> here
     via <host>-services intermediate

- <svc>-<target>: bd
  in onehost scope == <host>-<svc>-<target>
  in svc scope == <host...>-<svc>-<target>

  in allhost scope: fixme tbd
    == ??allhost-<svc...>-<target>??
    == ??allhost-<host...>-<target>??
  in allsvc scope: fixme tbd
    == ??allsvc-<host...>-target

