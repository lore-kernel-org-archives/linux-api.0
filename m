From: Christian Brauner <christian@brauner.io>
Subject: [PATCH v2 0/5]  clone: add CLONE_PIDFD
Date: Thu, 18 Apr 2019 12:18:36 +0200
Message-ID: <20190418101841.4476-1-christian@brauner.io>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: torvalds@linux-foundation.org, viro@zeniv.linux.org.uk, jannh@google.com, dhowells@redhat.com, oleg@redhat.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: serge@hallyn.com, luto@kernel.org, arnd@arndb.de, ebiederm@xmission.com, keescook@chromium.org, tglx@linutronix.de, mtk.manpages@gmail.com, akpm@linux-foundation.org, cyphar@cyphar.com, joel@joelfernandes.org, dancol@google.com, Christian Brauner <christian@brauner.io>
List-Id: linux-api@vger.kernel.org

Hey,

/* v2 summary */
Move put_user() into copy process before clone's point of no return so
that we can handle put_user() errors as suggested by Oleg. The good news
is that this again allows us to make the patch smaller.

/* v1 summary */
As suggested by Oleg, have pidfds returned in the fourth argument of
clone allowing us to return a pidfd and its pid to the caller at the
same time. This has various advantages:
- callers get the associated pid for the pidfd without additional
  parsing 
  This makes it easier for userspce to get metadata access through
  procfs.
- the type of the return value for clone() remains unchanged
  (was changed to return an fd in the previous iteration)
- pid file descriptor numbering can start at 0 as is customary for
  file descriptors
  (was changed to start at 1 in the previous patchset to not break
   fork()-like error checking when returning pidfds)
- finally, the patchset has gotten smaller

The patchset makes it possible to retrieve pid file descriptors at
process creation time by introducing the new flag CLONE_PIDFD to the
clone() system call as previously discussed.

As decided last week [1] Jann and I have refined the implementation of
pidfds as anonymous inodes. Based on last weeks RFC we have only tweaked
documentation and naming, as well as making the sample program how to
get easy metadata access from a pidfd a little cleaner and more paranoid
when checking for errors.
The sample program can also serve as a test for the patchset.

When clone is called with CLONE_PIDFD a pidfd will be returned in the
fourth argument of clone. This is based on an idea from Oleg. It allows
us to return a pidfd and the associated pid to the caller at the same
time.

We have taken care that pidfds are created *after* the fd table has
been unshared to not leak pidfds into child processes.

The actual code for CLONE_PIDFD in patch 2 is completely confined to
fork.c (apart from the CLONE_PIDFD definition of course) and is rather
small and hopefully good to review.

The additional changes listed under David's name in the diffstat below
are here to make anon_inodes available unconditionally. They are needed
for the new mount api and thus for core vfs code in addition to pidfds.
David knows this and he has informed Al that this patch is sent out
here. The changes themselves are rather automatic.

As promised I have also contacted Joel who has sent a patchset to make
pidfds pollable. He has been informed and is happy to port his patchset
once we have moved forward [2].
Jann and I currently plan to target this patchset for inclusion in the 5.2
merge window.

Thanks!
Jann & Christian

[1]: https://lore.kernel.org/lkml/CAHk-=wifyY+XGNW=ZC4MyTHD14w81F8JjQNH-GaGAm2RxZ_S8Q@mail.gmail.com/
[2]: https://lore.kernel.org/lkml/20190411200059.GA75190@google.com/

Christian Brauner (4):
  clone: add CLONE_PIDFD
  signal: use fdget() since we don't allow O_PATH
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
 init/Kconfig                   |  10 ---
 kernel/fork.c                  |  96 ++++++++++++++++++++++++++--
 kernel/signal.c                |  14 +++--
 kernel/sys_ni.c                |   3 -
 samples/Makefile               |   2 +-
 samples/pidfd/Makefile         |   6 ++
 samples/pidfd/pidfd-metadata.c | 112 +++++++++++++++++++++++++++++++++
 26 files changed, 225 insertions(+), 39 deletions(-)
 create mode 100644 samples/pidfd/Makefile
 create mode 100644 samples/pidfd/pidfd-metadata.c

-- 
2.21.0
