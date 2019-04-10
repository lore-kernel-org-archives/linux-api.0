From: Christian Brauner <christian@brauner.io>
Subject: [RFC PATCH] fork: add CLONE_PIDFD
Date: Thu, 11 Apr 2019 01:40:40 +0200
Message-ID: <20190410234045.29846-1-christian@brauner.io>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: torvalds@linux-foundation.org, viro@zeniv.linux.org.uk, jannh@google.com, dhowells@redhat.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: serge@hallyn.com, luto@kernel.org, arnd@arndb.de, ebiederm@xmission.com, keescook@chromium.org, adobriyan@gmail.com, tglx@linutronix.de, mtk.manpages@gmail.com, bl0pbl33p@gmail.com, ldv@altlinux.org, akpm@linux-foundation.org, oleg@redhat.com, cyphar@cyphar.com, joel@joelfernandes.org, dancol@google.com, Christian Brauner <christian@brauner.io>
List-Id: linux-api@vger.kernel.org

Hey Linus,

This is an RFC for adding a new CLONE_PIDFD flag to clone() as
previously discussed.
While implementing this Jann and I ran into additional complexity that
prompted us to send out an initial RFC patchset to make sure we still
think going forward with the current implementation is a good idea and
also provide an alternative approach:

RFC-1:
This is an RFC for the implementation of pidfds as /proc/<pid> file
descriptors.
The tricky part here is that we need to retrieve a file descriptor for
/proc/<pid> before clone's point of no return. Otherwise, we need to fail
the creation of a process that has already passed all barriers and is
visible in userspace. Getting that file descriptor then becomes a rather
intricate dance including allocating a detached dentry that we need to
commit once attach_pid() has been called.
Note that this RFC only includes the logic we think is needed to return
/proc/<pid> file descriptors from clone. It does *not* yet include the even
more complex logic needed to restrict procfs itself. And the additional
logic needed to prevent attacks such as openat(pidfd, "..", ...) and access
to /proc/<pid>/net/ on top of the procfs restriction.

There are a couple of reasons why we stopped short of this and decided to
sent out an RFC first:
- Even the initial part of getting file descriptors from /proc/<pid> out
  of clone() required rather complex code that struck us as very
  inelegant and heavy (which granted, might partially caused by not seeing
  a cleaner way to implement this). Thus, it felt like we needed to see
  whether this is even remotely considered acceptable.
- While discussing further aspects of this approach with Al we received
  rather substantiated opposition to exposing even more codepaths to
  procfs.
- Restricting access to procfs properly requires a lot of invasive work
  even touching core vfs functions such as
  follow_dotdot()/follow_dotdot_rcu() which also caused 2.

RFC-2:
This alternative patchset uses anonymous file descriptors instead of
file descriptors from /proc/<pid>.
A pidfd in this style comes with additional information in fdinfo: the pid
of the process it refers to in the current pid namespace (Pid: %d).

We have chosen to implement this alternative to illustrate how
strikingly simple this patchset is in comparision to the original
approach.
To remove worries about missing metadata access we have written a POC
that illustrates how a combination of CLONE_PIDFD, fdinfo, and
pidfd_send_signal() can be used to gain race-free access to process
metadata through /proc/<pid>. The sample program can easily be
translated into a helper that would be suitable for inclusion in libc so
that users don't have to worry about writing it themselves.

Thanks!
Jann & Christian

RFC-1:
Christian Brauner (1):
  fork: add CLONE_PIDFD via /proc/<pid>

 fs/proc/base.c             | 130 ++++++++++++++++++++++++++++++++++---
 fs/proc/fd.c               |   4 +-
 fs/proc/internal.h         |   2 +-
 fs/proc/namespaces.c       |   2 +-
 include/linux/proc_fs.h    |  19 ++++++
 include/uapi/linux/sched.h |   1 +
 kernel/fork.c              |  40 ++++++++++--
 7 files changed, 180 insertions(+), 18 deletions(-)

RFC-2:
Christian Brauner (3):
  fork: add CLONE_PIDFD via anonymous inode
  signal: support CLONE_PIDFD with pidfd_send_signal
  samples: show race-free pidfd metadata access

David Howells (1):
  Make anon_inodes unconditional

 arch/arm/kvm/Kconfig           |   1 -
 arch/arm64/kvm/Kconfig         |   1 -
 arch/mips/kvm/Kconfig          |   1 -
 arch/powerpc/kvm/Kconfig       |   1 -
 arch/s390/kvm/Kconfig          |   1 -
 arch/x86/Kconfig               |   1 -
 arch/x86/kvm/Kconfig           |   1 -
 drivers/base/Kconfig           |   1 -
 drivers/char/tpm/Kconfig       |   1 -
 drivers/dma-buf/Kconfig        |   1 -
 drivers/gpio/Kconfig           |   1 -
 drivers/iio/Kconfig            |   1 -
 drivers/infiniband/Kconfig     |   1 -
 drivers/vfio/Kconfig           |   1 -
 fs/Makefile                    |   2 +-
 fs/notify/fanotify/Kconfig     |   1 -
 fs/notify/inotify/Kconfig      |   1 -
 include/linux/pid.h            |   2 +
 include/uapi/linux/sched.h     |   1 +
 init/Kconfig                   |  10 --
 kernel/fork.c                  |  94 +++++++++++++++++-
 kernel/signal.c                |  14 ++-
 kernel/sys_ni.c                |   3 -
 samples/Makefile               |   2 +-
 samples/pidfd/Makefile         |   6 ++
 samples/pidfd/pidfd-metadata.c | 169 +++++++++++++++++++++++++++++++++
 26 files changed, 279 insertions(+), 40 deletions(-)
 create mode 100644 samples/pidfd/Makefile
 create mode 100644 samples/pidfd/pidfd-metadata.c

-- 
2.21.0
