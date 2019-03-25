From: Christian Brauner <christian@brauner.io>
Subject: [PATCH 0/4] pid: add pidctl()
Date: Mon, 25 Mar 2019 17:20:48 +0100
Message-ID: <20190325162052.28987-1-christian@brauner.io>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jannh@google.com, khlebnikov@yandex-team.ru, luto@kernel.org, dhowells@redhat.com, serge@hallyn.com, ebiederm@xmission.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, keescook@chromium.org, adobriyan@gmail.com, tglx@linutronix.de, mtk.manpages@gmail.com, bl0pbl33p@gmail.com, ldv@altlinux.org, akpm@linux-foundation.org, oleg@redhat.com, nagarathnam.muthusamy@oracle.com, cyphar@cyphar.com, viro@zeniv.linux.org.uk, joel@joelfernandes.org, dancol@google.com, Christian Brauner <christian@brauner.io>
List-Id: linux-api@vger.kernel.org

The pidctl() syscalls builds on, extends, and improves translate_pid() [4].
I quote Konstantins original patchset first that has already been acked and
picked up by Eric before and whose functionality is preserved in this
syscall. Multiple people have asked when this patchset will be sent in
for merging (cf. [1], [2]). It has recently been revived by Nagarathnam
Muthusamy from Oracle [3].

The intention of the original translate_pid() syscall was twofold:
1. Provide translation of pids between pid namespaces
2. Provide implicit pid namespace introspection

Both functionalities are preserved. The latter task has been improved
upon though. In the original version of the pachset passing pid as 1
would allow to deterimine the relationship between the pid namespaces.
This is inherhently racy. If pid 1 inside a pid namespace has died it
would report false negatives. For example, if pid 1 inside of the target
pid namespace already died, it would report that the target pid
namespace cannot be reached from the source pid namespace because it
couldn't find the pid inside of the target pid namespace and thus
falsely report to the user that the two pid namespaces are not related.
This problem is simple to avoid. In the new version we simply walk the
list of ancestors and check whether the namespace are related to each
other. By doing it this way we can reliably report what the relationship
between two pid namespace file descriptors looks like.

Additionally, this syscall has been extended to allow the retrieval of
pidfds independent of procfs. These pidfds can e.g. be used with the new
pidfd_send_signal() syscall we recently merged. The ability to retrieve
pidfds independent of procfs had already been requested in the
pidfd_send_signal patchset by e.g. Andrew [4] and later again by Alexey
[5]. A use-case where a kernel is compiled without procfs but where
pidfds are still useful has been outlined by Andy in [6]. Regular
anon-inode based file descriptors are used that stash a reference to
struct pid in file->private_data and drop that reference on close.

With this translate_pid() has three closely related but still distinct
functionalities. To clarify the semantics and to make it easier for
userspace to use the syscall it has:
- gained a command argument and three commands clearly reflecting the
  distinct functionalities (PIDCMD_QUERY_PID, PIDCMD_QUERY_PIDNS,
  PIDCMD_GET_PIDFD).
- been renamed to pidctl()

By gaining support for cleanly retrieving pidfds this syscall connects the
traditional pid-based and the newer pidfd-based process API in a natural
and clean way. Another advantage is that embedding this functionality into
pidctl() let's us avoid adding another syscall just serving the single
purpose of retrieving a pidfd.
The flag argument allows to atomically set the cloexec when retrieving
pidfds.

Note that this patchset also includes Al's and David's commit to make anon
inodes unconditional. The original intention is to make it possible to use
anon inodes in core vfs functions. pidctl() has the same requirement so
David suggested I sent this in alongside this patch. Both are informed of
this.

The syscall comes with extensive testing for all functionalities.

/* References */
[1]: https://lore.kernel.org/lkml/37b17950-b130-7933-99a1-4846c61c8555@oracle.com/
[2]: https://lore.kernel.org/lkml/20181109034919.GA21681@altlinux.org/
[3]: https://lore.kernel.org/lkml/37b17950-b130-7933-99a1-4846c61c8555@oracle.com/
[4]: 3eb39f47934f9d5a3027fe00d906a45fe3a15fad
[5]: https://lore.kernel.org/lkml/20190320203910.GA2842@avx2/
[6]: https://lore.kernel.org/lkml/CALCETrXO=V=+qEdLDVPf8eCgLZiB9bOTrUfe0V-U-tUZoeoRDA@mail.gmail.com/

Thanks!
Christian

Christian Brauner (3):
  pid: add pidctl()
  signal: support pidctl() with pidfd_send_signal()
  tests: add pidctl() tests

David Howells (1):
  Make anon_inodes unconditional

 arch/arm/kvm/Kconfig                        |   1 -
 arch/arm64/kvm/Kconfig                      |   1 -
 arch/mips/kvm/Kconfig                       |   1 -
 arch/powerpc/kvm/Kconfig                    |   1 -
 arch/s390/kvm/Kconfig                       |   1 -
 arch/x86/Kconfig                            |   1 -
 arch/x86/entry/syscalls/syscall_32.tbl      |   1 +
 arch/x86/entry/syscalls/syscall_64.tbl      |   1 +
 arch/x86/kvm/Kconfig                        |   1 -
 drivers/base/Kconfig                        |   1 -
 drivers/char/tpm/Kconfig                    |   1 -
 drivers/dma-buf/Kconfig                     |   1 -
 drivers/gpio/Kconfig                        |   1 -
 drivers/iio/Kconfig                         |   1 -
 drivers/infiniband/Kconfig                  |   1 -
 drivers/vfio/Kconfig                        |   1 -
 fs/Makefile                                 |   2 +-
 fs/notify/fanotify/Kconfig                  |   1 -
 fs/notify/inotify/Kconfig                   |   1 -
 include/linux/pid.h                         |   2 +
 include/linux/pid_namespace.h               |   8 +
 include/linux/syscalls.h                    |   2 +
 include/uapi/linux/wait.h                   |  17 +
 init/Kconfig                                |  10 -
 kernel/pid.c                                | 162 ++++++
 kernel/pid_namespace.c                      |  25 +
 kernel/signal.c                             |  20 +-
 kernel/sys_ni.c                             |   3 -
 tools/testing/selftests/pidfd/Makefile      |   2 +-
 tools/testing/selftests/pidfd/pidctl_test.c | 553 ++++++++++++++++++++
 30 files changed, 782 insertions(+), 42 deletions(-)
 create mode 100644 tools/testing/selftests/pidfd/pidctl_test.c

-- 
2.21.0
