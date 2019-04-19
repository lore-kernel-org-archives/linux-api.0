From: Christian Brauner <christian@brauner.io>
Subject: [PATCH v3 0/4] clone: add CLONE_PIDFD
Date: Fri, 19 Apr 2019 14:09:00 +0200
Message-ID: <20190419120904.27502-1-christian@brauner.io>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: torvalds@linux-foundation.org, viro@zeniv.linux.org.uk, jannh@google.com, dhowells@redhat.com, oleg@redhat.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: serge@hallyn.com, luto@kernel.org, arnd@arndb.de, ebiederm@xmission.com, keescook@chromium.org, tglx@linutronix.de, mtk.manpages@gmail.com, akpm@linux-foundation.org, cyphar@cyphar.com, joel@joelfernandes.org, dancol@google.com, Christian Brauner <christian@brauner.io>, Jann Horn <jann@thejh.net>
List-Id: linux-api@vger.kernel.org

Hey,

/* v3 summary */
After a brief discussion we decided to block CLONE_PIDFD with
CLONE_THREAD for now.  Not because it is not possible but because we
don't have a use-case yet and blocking it makes the initial work for
pidfd polling easier.  However, it is possible to simply flick the
switch later.

Additionally, Oleg has suggested that we verify the parent_tidptr
argument userspace gave us for returning pidfds with CLONE_PIDFD is
pristine so that we can potentially reuse it for additional argument
passing later.  Even if we don't extend it it makes sense to verify we
don't get garbage from userspace.

Linus has applied the s/fdget_raw()/fdget()/ patch from v2 directly (cf. [3])
so it has been dropped from v3.

Oleg's {Reviewed,Acked}-bys have been added.

Jann and I have discussed how the h*ll to properly DCO all of this and
discovered that apparently we've been doing it wrong and we shouldn't do
a simple double-SOB but rather some form of SOB+CDB+SOB in some random
order.  So we went with:
Signed-off-by: Christian Brauner <christian@brauner.io>
Co-developed-by: Jann Horn <jann@thejh.net>
Signed-off-by: Jann Horn <jann@thejh.net>

/* v2 summary */
Move put_user() into copy process before clone's point of no return so
that we can handle put_user() errors as suggested by Oleg.  The good
news is that this again allows us to make the patch smaller.

/* v1 summary */
As suggested by Oleg, have pidfds returned in the parent_tidptr argument
of clone allowing us to return a pidfd and its pid to the caller at the
same time.  This has various advantages:
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

/* abstract */
The patchset makes it possible to retrieve pid file descriptors at
process creation time by introducing the new flag CLONE_PIDFD to the
clone() system call as previously discussed.

As decided last week [1] Jann and I have refined the implementation of
pidfds as anonymous inodes.  Based on last weeks RFC we have only
tweaked documentation and naming, as well as making the sample program
how to get easy metadata access from a pidfd a little cleaner and more
paranoid when checking for errors.
The sample program can also serve as a test for the patchset.

When clone is called with CLONE_PIDFD a pidfd will be returned in the
parent_tidptr argument of clone.  This is based on an idea from
Oleg.  It allows us to return a pidfd and the associated pid to the
caller at the same time.

We have taken care that pidfds are created *after* the fd table has
been unshared to not leak pidfds into child processes.

The actual code for CLONE_PIDFD in patch 2 is completely confined to
fork.c (apart from the CLONE_PIDFD definition of course) and is rather
small and hopefully good to review.

The additional changes listed under David's name in the diffstat below
are here to make anon_inodes available unconditionally.  They are needed
for the new mount api and thus for core vfs code in addition to pidfds.
David knows this and he has informed Al that this patch is sent out
here.  The changes themselves are rather automatic.

As promised I have also contacted Joel who has sent a patchset to make
pidfds pollable.  He has been informed and is happy to port his patchset
once we have moved forward [2].
Jann and I currently plan to target this patchset for inclusion in the 5.2
merge window.

Thanks!
Jann & Christian

[1]: https://lore.kernel.org/lkml/CAHk-=wifyY+XGNW=ZC4MyTHD14w81F8JjQNH-GaGAm2RxZ_S8Q@mail.gmail.com/
[2]: https://lore.kernel.org/lkml/20190411200059.GA75190@google.com/
[3]: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=738a7832d21e3d911fcddab98ce260b79010b461

Christian Brauner (3):
  clone: add CLONE_PIDFD
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
 kernel/fork.c                  | 108 +++++++++++++++++++++++++++++--
 kernel/signal.c                |  12 +++-
 kernel/sys_ni.c                |   3 -
 samples/Makefile               |   2 +-
 samples/pidfd/Makefile         |   6 ++
 samples/pidfd/pidfd-metadata.c | 112 +++++++++++++++++++++++++++++++++
 26 files changed, 236 insertions(+), 38 deletions(-)
 create mode 100644 samples/pidfd/Makefile
 create mode 100644 samples/pidfd/pidfd-metadata.c

-- 
2.21.0
