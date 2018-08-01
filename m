From: David Howells <dhowells@redhat.com>
Subject: [PATCH 00/33] VFS: Introduce filesystem context [ver #11]
Date: Wed, 01 Aug 2018 16:23:56 +0100
Message-ID: <153313703562.13253.5766498657900728120.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: viro@zeniv.linux.org.uk
Cc: John Johansen <john.johansen@canonical.com>, Tejun Heo <tj@kernel.org>, "Eric W. Biederman" <ebiederm@redhat.com>, selinux@tycho.nsa.gov, Paul Moore <paul@paul-moore.com>, Li Zefan <lizefan@huawei.com>, linux-api@vger.kernel.org, apparmor@lists.ubuntu.com, Casey Schaufler <casey@schaufler-ca.com>, fenghua.yu@intel.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Eric Biggers <ebiggers@google.com>, linux-security-module@vger.kernel.org, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, Johannes Weiner <hannes@cmpxchg.org>, Stephen Smalley <sds@tycho.nsa.gov>, tomoyo-dev-en@lists.sourceforge.jp, cgroups@vger.kernel.org, torvalds@linux-foundation.org, dhowells@redhat.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org


Hi Al,

Here are a set of patches to create a filesystem context prior to setting
up a new mount, populating it with the parsed options/binary data, creating
the superblock and then effecting the mount.  This is also used for remount
since much of the parsing stuff is common in many filesystems.

This allows namespaces and other information to be conveyed through the
mount procedure.

This also allows Miklós Szeredi's idea of doing:

	fd = fsopen("nfs");
	fsconfig(fd, FSCONFIG_SET_STRING, "option", "val", 0);
	fsconfig(fd, FSCONFIG_CMD_CREATE, NULL, NULL, 0);
	mfd = fsmount(fd, MS_NODEV);
	move_mount(mfd, "", AT_FDCWD, "/mnt", MOVE_MOUNT_F_EMPTY_PATH);

that he presented at LSF-2017 to be implemented (see the relevant patches
in the series).

I didn't use netlink as that would make the core kernel depend on
CONFIG_NET and CONFIG_NETLINK and would introduce network namespacing
issues.

I've implemented filesystem context handling for procfs, nfs, mqueue,
cpuset, kernfs, sysfs, cgroup and afs filesystems.

Unconverted filesystems are handled by a legacy filesystem wrapper.


====================
WHY DO WE WANT THIS?
====================

Firstly, there's a bunch of problems with the mount(2) syscall:

 (1) It's actually six or seven different interfaces rolled into one and
     weird combinations of flags make it do different things beyond the
     original specification of the syscall.

 (2) It produces a particularly large and diverse set of errors, which have
     to be mapped back to a small error code.  Yes, there's dmesg - if you
     have it configured - but you can't necessarily see that if you're
     doing a mount inside of a container.

 (3) It copies a PAGE_SIZE block of data for each of the type, device name
     and options.

 (4) The size of the buffers is PAGE_SIZE - and this is arch dependent.

 (5) You can't mount into another mount namespace.  I could, for example,
     build a container without having to be in that container's namespace
     if I can do it from outside.

 (6) It's not really geared for the specification of multiple sources, but
     some filesystems really want that - overlayfs, for example.

and some problems in the internal kernel api:

 (1) There's no defined way to supply namespace configuration for the
     superblock - so, for instance, I can't say that I want to create a
     superblock in a particular network namespace (on automount, say).

     NFS hacks around this by creating multiple shadow file_system_types
     with different ->mount() ops.

 (2) When calling mount internally, unless you have NFS-like hacks, you
     have to generate or otherwise provide text config data which then gets
     parsed, when some of the time you could bypass the parsing stage
     entirely.

 (3) The amount of data in the data buffer is not known, but the data
     buffer might be on a kernel stack somewhere, leading to the
     possibility of tripping the stack underrun guard.

and other issues too:

 (1) Superblock remount in some filesystems applies options on an as-parsed
     basis, so if there's a parse failure, a partial alteration with no
     rollback is effected.

 (2) Under some circumstances, the mount data may get copied multiple times
     so that it can have multiple parsers applied to it or because it has
     to be parsed multiple times - for instance, once to get the
     preliminary info required to access the on-disk superblock and then
     again to update the superblock record in the kernel.

I want to be able to add support for a bunch of things:

 (1) UID, GID and Project ID mapping/translation.  I want to be able to
     install a translation table of some sort on the superblock to
     translate source identifiers (which may be foreign numeric UIDs/GIDs,
     text names, GUIDs) into system identifiers.  This needs to be done
     before the superblock is published[*].

     Note that this may, for example, involve using the context and the
     superblock held therein to issue an RPC to a server to look up
     translations.

     [*] By "published" I mean made available through mount so that other
     	 userspace processes can access it by path.

     Maybe specifying a translation range element with something like:

	fsconfig(fd, fsconfig_translate_uid, "<srcuid> <nsuid> <count>", 0, 0);

     The translation information also needs to propagate over an automount
     in some circumstances.

 (2) Namespace configuration.  I want to be able to tell the superblock
     creation process what namespaces should be applied when it created (in
     particular the userns and netns) for containerisation purposes, e.g.:

	fsconfig(fd, FSCONFIG_SET_NAMESPACE, "user", 0, userns_fd);
	fsconfig(fd, FSCONFIG_SET_NAMESPACE, "net", 0, netns_fd);

 (3) Namespace propagation.  I want to have a properly defined mechanism
     for propagating namespace configuration over automounts within the
     kernel.  This will be particularly useful for network filesystems.

 (4) Pre-mount attribute query.  A chunk of the changes is actually the
     fsinfo() syscall to query attributes of the filesystem beyond what's
     available in statx() and statfs().  This will allow a created
     superblock to be queried before it is published.

 (5) Upcall for configuration.  I would like to be able to query
     configuration that's stored in userspace when an automount is made.
     For instance, to look up network parameters for NFS or to find a cache
     selector for fscache.

     The internal fs_context could be passed to the upcall process or the
     kernel could read a config file directly if named appropriately for the
     superblock, perhaps:

	[/etc/fscontext.d/afs/example.com/cell.cfg]
	realm = EXAMPLE.COM
	translation = uid,3000,4000,100
	fscache = tag=fred

 (6) Event notifications.  I want to be able to install a watch on a
     superblock before it is published to catch things like quota events
     and EIO.

 (7) Large and binary parameters.  There might be at some point a need to
     pass large/binary objects like Microsoft PACs around.  If I understand
     PACs correctly, you can obtain these from the Kerberos server and then
     pass them to the file server when you connect.

     Having it possible to pass large or binary objects as individual
     fsconfig calls make parsing these trivial.  OTOH, some or all of this
     can potentially be handled with the use of the keyrings interface - as
     the afs filesystem does for passing kerberos tokens around; it's just
     that that seems overkill for a parameter you may only need once.


===================
SIGNIFICANT CHANGES
===================

 ver #11:

 (*) Fixed AppArmor.

 (*) Capitalised all the UAPI constants.

 (*) Explicitly numbered the FSCONFIG_* UAPI constants.

 (*) Removed all the places ANON_INODES is selected.

 (*) Fixed a bug whereby the context gets freed twice (which broke mounts of
     procfs).

 (*) Split fsinfo() off into its own patch series.

 ver #10:

 (*) Renamed "option" to "parameter" in a number of places.

 (*) Replaced the use of write() to drive the configuration with an fsconfig()
     syscall.  This also allows at-style paths and fds to be presented as typed
     object.

 (*) Routed the key=value parameter concept all the way through from the
     fsconfig() system call to the LSM and filesystem.

 (*) Added a parameter-description concept and helper functions to help
     interpret a parameter and possibly convert the value.

 (*) Made it possible to query the parameter description using the fsinfo()
     syscall.  Added a test-fs-query sample to dump the parameters used by a
     filesystem.

 ver #9:

 (*) Dropped the fd cookie stuff and the FMODE_*/O_* split stuff.

 (*) Al added an open_tree() system call to allow a mount tree to be picked
     referenced or cloned into an O_PATH-style fd.  This can then be used
     with sys_move_mount().  Dropped the O_CLONE_MOUNT and O_NON_RECURSIVE
     open() flags.

 (*) Brought error logging back in, though only in the fs_context and not
     in the task_struct.

 (*) Separated MS_REMOUNT|MS_BIND handling from MS_REMOUNT handling.

 (*) Used anon_inodes for the fd returned by fsopen() and fspick().  This
     requires making it unconditional.

 (*) Fixed lots of bugs.  Especial thanks to Al and Eric Biggers for
     finding them and providing patches.

 (*) Wrote manual pages, which I'll post separately.

 ver #8:

 (*) Changed the way fsmount() mounts into the namespace according to some
     of Al's ideas.

 (*) Put better typing on the fd cookie obtained from __fdget() & co..

 (*) Stored the fd cookie in struct nameidata rather than the dfd number.

 (*) Changed sys_fsmount() to return an O_PATH-style fd rather than
     actually mounting into the mount namespace.

 (*) Separated internal FMODE_* handling from O_* handling to free up
     certain O_* flag numbers.

 (*) Added two new open flags (O_CLONE_MOUNT and O_NON_RECURSIVE) for use
     with open(O_PATH) to copy a mount or mount-subtree to an O_PATH fd.

 (*) Added a new syscall, sys_move_mount(), to move a mount from an
     dfd+path source to a dfd+path destination.

 (*) Added a file->f_mode flag (FMODE_NEED_UNMOUNT) that indicates that the
     vfsmount attached to file->f_path needs 'unmounting' if set.

 (*) Made sys_move_mount() clear FMODE_NEED_UNMOUNT if successful.

	[!] This doesn't work quite right.

 (*) Added a new syscall, fsinfo(), to query information about a
     filesystem.  The idea being that this will, in future, work with the
     fd from fsopen() too and permit querying of the parameters and
     metadata before fsmount() is called.

 ver #7:

 (*) Undo an incorrect MS_* -> SB_* conversion.

 (*) Pass the mount data buffer size to all the mount-related functions that
     take the data pointer.  This fixes a problem where someone (say SELinux)
     tries to copy the mount data, assuming it to be a page in size, and
     overruns the buffer - thereby incurring an oops by hitting a guard page.

 (*) Made the AFS filesystem use them as an example.  This is a much easier to
     deal with than with NFS or Ext4 as there are very few mount options.

 ver #6:

 (*) Dropped the supplementary error string facility for the moment.

 (*) Dropped the NFS patches for the moment.

 (*) Dropped the reserved file descriptor argument from fsopen() and
     replaced it with three reserved pointers that must be NULL.

 ver #5:

 (*) Renamed sb_config -> fs_context and adjusted variable names.

 (*) Differentiated the flags in sb->s_flags (now named SB_*) from those
     passed to mount(2) (named MS_*).

 (*) Renamed __vfs_new_fs_context() to vfs_new_fs_context() and made the
     caller always provide a struct file_system_type pointer and the
     parameters required.

 (*) Got rid of vfs_submount_fc() in favour of passing
     FS_CONTEXT_FOR_SUBMOUNT to vfs_new_fs_context().  The purpose is now
     used more.

 (*) Call ->validate() on the remount path.

 (*) Got rid of the inode locking in sys_fsmount().

 (*) Call security_sb_mountpoint() in the mount(2) path.

 ver #4:

 (*) Split the sb_config patch up somewhat.

 (*) Made the supplementary error string facility something attached to the
     task_struct rather than the sb_config so that error messages can be
     obtained from NFS doing a mount-root-and-pathwalk inside the
     nfs_get_tree() operation.

     Further, made this managed and read by prctl rather than through the
     mount fd so that it's more generally available.

 ver #3:

 (*) Rebased on 4.12-rc1.

 (*) Split the NFS patch up somewhat.

 ver #2:

 (*) Removed the ->fill_super() from sb_config_operations and passed it in
     directly to functions that want to call it.  NFS now calls
     nfs_fill_super() directly rather than jumping through a pointer to it
     since there's only the one option at the moment.

 (*) Removed ->mnt_ns and ->sb from sb_config and moved ->pid_ns into
     proc_sb_config.

 (*) Renamed create_super -> get_tree.

 (*) Renamed struct mount_context to struct sb_config and amended various
     variable names.

 (*) sys_fsmount() acquired AT_* flags and MS_* flags (for MNT_* flags)
     arguments.

 ver #1:

 (*) Split the sb_config stuff out into its own header.

 (*) Support non-context aware filesystems through a special set of
     sb_config operations.

 (*) Stored the created superblock and root dentry into the sb_config after
     creation rather than directly into a vfsmount.  This allows some
     arguments to be removed to various NFS functions.

 (*) Added an explicit superblock-creation step.  This allows a created
     superblock to then be mounted multiple times.

 (*) Added a flag to say that the sb_config is degraded and cannot have
     another go at having a superblock creation whilst getting rid of the
     one that says it's already mounted.

Possible further developments:

 (*) Implement sb reconfiguration (for now it returns ENOANO).

 (*) Implement mount context support in more filesystems, ext4 being next
     on my list.

 (*) Move the walk-from-root stuff that nfs has to generic code so that you
     can do something akin to:

	mount /dev/sda1:/foo/bar /mnt

     See nfs_follow_remote_path() and mount_subtree().  This is slightly
     tricky in NFS as we have to prevent referral loops.

 (*) Work out how to get at the error message incurred by submounts
     encountered during nfs_follow_remote_path().

     Should the error message be moved to task_struct and made more
     general, perhaps retrieved with a prctl() function?

 (*) Clean up/consolidate the security functions.  Possibly add a
     validation hook to be called at the same time as the mount context
     validate op.

The patches can be found here also:

	https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git

tagged as:

	mount-api-20180801

on branch:

	mount-api

David
---
Al Viro (2):
      vfs: syscall: Add open_tree(2) to reference or clone a mount
      teach move_mount(2) to work with OPEN_TREE_CLONE

David Howells (31):
      vfs: syscall: Add move_mount(2) to move mounts around
      vfs: Suppress MS_* flag defs within the kernel unless explicitly enabled
      vfs: Introduce the basic header for the new mount API's filesystem context
      vfs: Introduce logging functions
      vfs: Add configuration parser helpers
      vfs: Add LSM hooks for the new mount API
      selinux: Implement the new mount API LSM hooks
      smack: Implement filesystem context security hooks
      apparmor: Implement security hooks for the new mount API
      tomoyo: Implement security hooks for the new mount API
      vfs: Separate changing mount flags full remount
      vfs: Implement a filesystem superblock creation/configuration context
      vfs: Remove unused code after filesystem context changes
      procfs: Move proc_fill_super() to fs/proc/root.c
      proc: Add fs_context support to procfs
      ipc: Convert mqueue fs to fs_context
      cpuset: Use fs_context
      kernfs, sysfs, cgroup, intel_rdt: Support fs_context
      hugetlbfs: Convert to fs_context
      vfs: Remove kern_mount_data()
      vfs: Provide documentation for new mount API
      Make anon_inodes unconditional
      vfs: syscall: Add fsopen() to prepare for superblock creation
      vfs: Implement logging through fs_context
      vfs: Add some logging to the core users of the fs_context log
      vfs: syscall: Add fsconfig() for configuring and managing a context
      vfs: syscall: Add fsmount() to create a mount for a superblock
      vfs: syscall: Add fspick() to select a superblock for reconfiguration
      afs: Add fs_context support
      afs: Use fs_context to pass parameters over automount
      vfs: Add a sample program for the new mount API


 Documentation/filesystems/mount_api.txt  |  706 ++++++++++++++++++++++++
 arch/arc/kernel/setup.c                  |    1 
 arch/arm/kernel/atags_parse.c            |    1 
 arch/arm/kvm/Kconfig                     |    1 
 arch/arm64/kvm/Kconfig                   |    1 
 arch/mips/kvm/Kconfig                    |    1 
 arch/powerpc/kvm/Kconfig                 |    1 
 arch/s390/kvm/Kconfig                    |    1 
 arch/sh/kernel/setup.c                   |    1 
 arch/sparc/kernel/setup_32.c             |    1 
 arch/sparc/kernel/setup_64.c             |    1 
 arch/x86/Kconfig                         |    1 
 arch/x86/entry/syscalls/syscall_32.tbl   |    6 
 arch/x86/entry/syscalls/syscall_64.tbl   |    6 
 arch/x86/kernel/cpu/intel_rdt.h          |   15 +
 arch/x86/kernel/cpu/intel_rdt_rdtgroup.c |  184 ++++--
 arch/x86/kernel/setup.c                  |    1 
 arch/x86/kvm/Kconfig                     |    1 
 drivers/base/Kconfig                     |    1 
 drivers/base/devtmpfs.c                  |    1 
 drivers/char/tpm/Kconfig                 |    1 
 drivers/dma-buf/Kconfig                  |    1 
 drivers/gpio/Kconfig                     |    1 
 drivers/iio/Kconfig                      |    1 
 drivers/infiniband/Kconfig               |    1 
 drivers/vfio/Kconfig                     |    1 
 fs/Kconfig                               |    7 
 fs/Makefile                              |    5 
 fs/afs/internal.h                        |    9 
 fs/afs/mntpt.c                           |  148 +++--
 fs/afs/super.c                           |  470 +++++++++-------
 fs/afs/volume.c                          |    4 
 fs/f2fs/super.c                          |    2 
 fs/file_table.c                          |    9 
 fs/filesystems.c                         |    4 
 fs/fs_context.c                          |  779 +++++++++++++++++++++++++++
 fs/fs_parser.c                           |  476 ++++++++++++++++
 fs/fsopen.c                              |  491 +++++++++++++++++
 fs/hugetlbfs/inode.c                     |  392 ++++++++------
 fs/internal.h                            |   13 
 fs/kernfs/mount.c                        |   87 +--
 fs/libfs.c                               |   19 +
 fs/namei.c                               |    4 
 fs/namespace.c                           |  867 +++++++++++++++++++++++-------
 fs/notify/fanotify/Kconfig               |    1 
 fs/notify/inotify/Kconfig                |    1 
 fs/pnode.c                               |    1 
 fs/proc/inode.c                          |   51 --
 fs/proc/internal.h                       |    6 
 fs/proc/root.c                           |  245 ++++++--
 fs/super.c                               |  368 ++++++++++---
 fs/sysfs/mount.c                         |   67 ++
 include/linux/cgroup.h                   |    3 
 include/linux/fs.h                       |   21 +
 include/linux/fs_context.h               |  208 +++++++
 include/linux/fs_parser.h                |  116 ++++
 include/linux/kernfs.h                   |   39 +
 include/linux/lsm_hooks.h                |   70 ++
 include/linux/module.h                   |    6 
 include/linux/mount.h                    |    5 
 include/linux/security.h                 |   61 ++
 include/linux/syscalls.h                 |    9 
 include/uapi/linux/fcntl.h               |    2 
 include/uapi/linux/fs.h                  |   82 +--
 include/uapi/linux/mount.h               |   75 +++
 init/Kconfig                             |   10 
 init/do_mounts.c                         |    1 
 init/do_mounts_initrd.c                  |    1 
 ipc/mqueue.c                             |  121 +++-
 kernel/cgroup/cgroup-internal.h          |   50 +-
 kernel/cgroup/cgroup-v1.c                |  347 +++++++-----
 kernel/cgroup/cgroup.c                   |  256 ++++++---
 kernel/cgroup/cpuset.c                   |   68 ++
 samples/Kconfig                          |    6 
 samples/Makefile                         |    2 
 samples/mount_api/Makefile               |    7 
 samples/mount_api/test-fsmount.c         |  118 ++++
 security/apparmor/include/mount.h        |   11 
 security/apparmor/lsm.c                  |  108 ++++
 security/apparmor/mount.c                |   47 ++
 security/security.c                      |   51 ++
 security/selinux/hooks.c                 |  311 ++++++++++-
 security/smack/smack.h                   |   11 
 security/smack/smack_lsm.c               |  370 ++++++++++++-
 security/tomoyo/common.h                 |    3 
 security/tomoyo/mount.c                  |   46 ++
 security/tomoyo/tomoyo.c                 |   15 +
 87 files changed, 6637 insertions(+), 1484 deletions(-)
 create mode 100644 Documentation/filesystems/mount_api.txt
 create mode 100644 fs/fs_context.c
 create mode 100644 fs/fs_parser.c
 create mode 100644 fs/fsopen.c
 create mode 100644 include/linux/fs_context.h
 create mode 100644 include/linux/fs_parser.h
 create mode 100644 include/uapi/linux/mount.h
 create mode 100644 samples/mount_api/Makefile
 create mode 100644 samples/mount_api/test-fsmount.c
