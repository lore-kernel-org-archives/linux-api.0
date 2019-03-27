From: Christian Brauner <christian@brauner.io>
Subject: [PATCH 0/4] pidfd_open()
Date: Wed, 27 Mar 2019 17:21:43 +0100
Message-ID: <20190327162147.23198-1-christian@brauner.io>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jannh@google.com, khlebnikov@yandex-team.ru, luto@kernel.org, dhowells@redhat.com, serge@hallyn.com, ebiederm@xmission.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, keescook@chromium.org, adobriyan@gmail.com, tglx@linutronix.de, mtk.manpages@gmail.com, bl0pbl33p@gmail.com, ldv@altlinux.org, akpm@linux-foundation.org, oleg@redhat.com, nagarathnam.muthusamy@oracle.com, cyphar@cyphar.com, viro@zeniv.linux.org.uk, joel@joelfernandes.org, dancol@google.com, Christian Brauner <christian@brauner.io>
List-Id: linux-api@vger.kernel.org

Hey,

After the discussion over the last days, this is a fresh approach to
getting pidfds independent of the translate_pid() patchset.

pidfd_open() allows to retrieve pidfds for processes and removes the
dependency of pidfd on procfs.
These pidfds are allocated using anon_inode_getfd(), are O_CLOEXEC by
default and can be used with the pidfd_send_signal() syscall. They are not
dirfds and as such have the advantage that we can make them pollable or
readable in the future if we see a need to do so. Currently they do not
support any advanced operations. The pidfds are not associated with a
specific pid namespaces but rather only reference struct pid of a given
process in their private_data member.

One of the oustanding issues has been how to get information about a given
process if pidfds are regular file descriptors and do not provide access to
the process /proc/<pid> directory.
Various solutions have been proposed. The one that most people prefer is to
be able to retrieve a file descriptor to /proc/<pid> based on a pidfd (and
the other way around).
IF PROCFD_TO_PIDFD is passed as a flag together with a file descriptor to a
/proc mount in a given pid namespace and a pidfd pidfd_open() will return a
file descriptor to the corresponding /proc/<pid> directory in procfs
mounts' pid namespace. pidfd_open() is very careful to verify that the pid
hasn't been recycled in between.
IF PIDFD_TO_PROCFD is passed as a flag together with a file descriptor
referencing a /proc/<pid> directory a pidfd referencing the struct pid
stashed in /proc/<pid> of the process will be returned.
The pidfd_open() syscalls in that manner resembles openat() as it uses a
flag argument to modify what type of file descriptor will be returned.

The pidfd_open() implementation together with the flags argument strikes me
as an elegant compromise between splitting this into multiple syscalls and
avoiding ioctls().

Note that this patchset also includes Al's and David's commit to make anon
inodes unconditional. The original intention is to make it possible to use
anon inodes in core vfs functions. pidctl() has the same requirement so
David suggested I sent this in alongside this patch. Both are informed of
this.

The syscall comes with appropriate basic testing.

/* Examples */
// Retrieve pidfd
int pidfd = pidfd_open(1234, -1, -1, 0);

// Retrieve /proc/<pid> handle for pidfd
int procfd = open("/proc", O_DIRECTORY | O_RDONLY | O_CLOEXEC);
int procpidfd = pidfd_open(-1, procfd, pidfd, PIDFD_TO_PROCFD);

// Retrieve pidfd for /proc/<pid>
int procpidfd = open("/proc/1234", O_DIRECTORY | O_RDONLY | O_CLOEXEC);
int pidfd = pidfd_open(-1, procpidfd, -1, PROCFD_TO_PIDFD);

Thanks!
Christian

Christian Brauner (3):
  pid: add pidfd_open()
  signal: support pidfd_open() with pidfd_send_signal()
  tests: add pidfd_open() tests

David Howells (1):
  Make anon_inodes unconditional

 arch/arm/kvm/Kconfig                          |   1 -
 arch/arm64/kvm/Kconfig                        |   1 -
 arch/mips/kvm/Kconfig                         |   1 -
 arch/powerpc/kvm/Kconfig                      |   1 -
 arch/s390/kvm/Kconfig                         |   1 -
 arch/x86/Kconfig                              |   1 -
 arch/x86/entry/syscalls/syscall_32.tbl        |   1 +
 arch/x86/entry/syscalls/syscall_64.tbl        |   1 +
 arch/x86/kvm/Kconfig                          |   1 -
 drivers/base/Kconfig                          |   1 -
 drivers/char/tpm/Kconfig                      |   1 -
 drivers/dma-buf/Kconfig                       |   1 -
 drivers/gpio/Kconfig                          |   1 -
 drivers/iio/Kconfig                           |   1 -
 drivers/infiniband/Kconfig                    |   1 -
 drivers/vfio/Kconfig                          |   1 -
 fs/Makefile                                   |   2 +-
 fs/notify/fanotify/Kconfig                    |   1 -
 fs/notify/inotify/Kconfig                     |   1 -
 include/linux/pid.h                           |   2 +
 include/linux/syscalls.h                      |   2 +
 include/uapi/linux/wait.h                     |   3 +
 init/Kconfig                                  |  10 -
 kernel/pid.c                                  | 247 ++++++++++++++++++
 kernel/signal.c                               |  14 +-
 kernel/sys_ni.c                               |   3 -
 tools/testing/selftests/pidfd/Makefile        |   2 +-
 .../testing/selftests/pidfd/pidfd_open_test.c | 201 ++++++++++++++
 28 files changed, 469 insertions(+), 35 deletions(-)
 create mode 100644 tools/testing/selftests/pidfd/pidfd_open_test.c

-- 
2.21.0
