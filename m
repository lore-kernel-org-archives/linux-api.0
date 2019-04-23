From: Arnd Bergmann <arnd@arndb.de>
Subject: [GIT PULL] arch: add pidfd and io_uring syscalls everywhere
Date: Tue, 23 Apr 2019 21:28:48 +0200
Message-ID: <CAK8P3a3bT=HO=YQ7PY7wOEsJTzf0jS4PkqNHSqYX4JjwmbhY+g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>, linux-arch <linux-arch@vger.kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

The following changes since commit 9e98c678c2d6ae3a17cb2de55d17f69dddaa231b:

  Linux 5.1-rc1 (2019-03-17 14:22:26 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arnd/asm-generic.git
syscalls-5.1

for you to fetch changes up to 39036cd2727395c3369b1051005da74059a85317:

  arch: add pidfd and io_uring syscalls everywhere (2019-04-15 16:31:17 +0200)

----------------------------------------------------------------
arch: add pidfd and io_uring syscalls everywhere

This comes a bit late, but should be in 5.1 anyway: we want the newly
added system calls to be synchronized across all architectures in
the release.

I hope that in the future, any newly added system calls can be added
to all architectures at the same time, and tested there while they
are in linux-next, avoiding dependencies between the architecture
maintainer trees and the tree that contains the new system call.

----------------------------------------------------------------
Arnd Bergmann (1):
      arch: add pidfd and io_uring syscalls everywhere

 arch/alpha/kernel/syscalls/syscall.tbl      | 4 ++++
 arch/arm/tools/syscall.tbl                  | 4 ++++
 arch/arm64/include/asm/unistd.h             | 2 +-
 arch/arm64/include/asm/unistd32.h           | 8 ++++++++
 arch/ia64/kernel/syscalls/syscall.tbl       | 4 ++++
 arch/m68k/kernel/syscalls/syscall.tbl       | 4 ++++
 arch/microblaze/kernel/syscalls/syscall.tbl | 4 ++++
 arch/mips/kernel/syscalls/syscall_n32.tbl   | 4 ++++
 arch/mips/kernel/syscalls/syscall_n64.tbl   | 4 ++++
 arch/mips/kernel/syscalls/syscall_o32.tbl   | 4 ++++
 arch/parisc/kernel/syscalls/syscall.tbl     | 4 ++++
 arch/powerpc/kernel/syscalls/syscall.tbl    | 4 ++++
 arch/s390/kernel/syscalls/syscall.tbl       | 4 ++++
 arch/sh/kernel/syscalls/syscall.tbl         | 4 ++++
 arch/sparc/kernel/syscalls/syscall.tbl      | 4 ++++
 arch/xtensa/kernel/syscalls/syscall.tbl     | 4 ++++
 16 files changed, 65 insertions(+), 1 deletion(-)

commit 39036cd2727395c3369b1051005da74059a85317
Author: Arnd Bergmann <arnd@arndb.de>
Date:   Thu Feb 28 13:59:19 2019 +0100

    arch: add pidfd and io_uring syscalls everywhere

    Add the io_uring and pidfd_send_signal system calls to all architectures.

    These system calls are designed to handle both native and compat tasks,
    so all entries are the same across architectures, only arm-compat and
    the generic tale still use an old format.

    Acked-by: Michael Ellerman <mpe@ellerman.id.au> (powerpc)
    Acked-by: Heiko Carstens <heiko.carstens@de.ibm.com> (s390)
    Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
    Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/arch/alpha/kernel/syscalls/syscall.tbl
b/arch/alpha/kernel/syscalls/syscall.tbl
index 63ed39cbd3bd..165f268beafc 100644
--- a/arch/alpha/kernel/syscalls/syscall.tbl
+++ b/arch/alpha/kernel/syscalls/syscall.tbl
@@ -463,3 +463,7 @@
 532 common getppid sys_getppid
 # all other architectures have common numbers for new syscall, alpha
 # is the exception.
+534 common pidfd_send_signal sys_pidfd_send_signal
+535 common io_uring_setup sys_io_uring_setup
+536 common io_uring_enter sys_io_uring_enter
+537 common io_uring_register sys_io_uring_register
diff --git a/arch/arm/tools/syscall.tbl b/arch/arm/tools/syscall.tbl
index 9016f4081bb9..0393917eaa57 100644
--- a/arch/arm/tools/syscall.tbl
+++ b/arch/arm/tools/syscall.tbl
@@ -437,3 +437,7 @@
 421 common rt_sigtimedwait_time64 sys_rt_sigtimedwait
 422 common futex_time64 sys_futex
 423 common sched_rr_get_interval_time64 sys_sched_rr_get_interval
+424 common pidfd_send_signal sys_pidfd_send_signal
+425 common io_uring_setup sys_io_uring_setup
+426 common io_uring_enter sys_io_uring_enter
+427 common io_uring_register sys_io_uring_register
diff --git a/arch/arm64/include/asm/unistd.h b/arch/arm64/include/asm/unistd.h
index d1dd93436e1e..f2a83ff6b73c 100644
--- a/arch/arm64/include/asm/unistd.h
+++ b/arch/arm64/include/asm/unistd.h
@@ -44,7 +44,7 @@
 #define __ARM_NR_compat_set_tls (__ARM_NR_COMPAT_BASE + 5)
 #define __ARM_NR_COMPAT_END (__ARM_NR_COMPAT_BASE + 0x800)

-#define __NR_compat_syscalls 424
+#define __NR_compat_syscalls 428
 #endif

 #define __ARCH_WANT_SYS_CLONE
diff --git a/arch/arm64/include/asm/unistd32.h
b/arch/arm64/include/asm/unistd32.h
index 5590f2623690..23f1a44acada 100644
--- a/arch/arm64/include/asm/unistd32.h
+++ b/arch/arm64/include/asm/unistd32.h
@@ -866,6 +866,14 @@ __SYSCALL(__NR_rt_sigtimedwait_time64,
compat_sys_rt_sigtimedwait_time64)
 __SYSCALL(__NR_futex_time64, sys_futex)
 #define __NR_sched_rr_get_interval_time64 423
 __SYSCALL(__NR_sched_rr_get_interval_time64, sys_sched_rr_get_interval)
+#define __NR_pidfd_send_signal 424
+__SYSCALL(__NR_pidfd_send_signal, sys_pidfd_send_signal)
+#define __NR_io_uring_setup 425
+__SYSCALL(__NR_io_uring_setup, sys_io_uring_setup)
+#define __NR_io_uring_enter 426
+__SYSCALL(__NR_io_uring_enter, sys_io_uring_enter)
+#define __NR_io_uring_register 427
+__SYSCALL(__NR_io_uring_register, sys_io_uring_register)

 /*
  * Please add new compat syscalls above this comment and update
diff --git a/arch/ia64/kernel/syscalls/syscall.tbl
b/arch/ia64/kernel/syscalls/syscall.tbl
index ab9cda5f6136..56e3d0b685e1 100644
--- a/arch/ia64/kernel/syscalls/syscall.tbl
+++ b/arch/ia64/kernel/syscalls/syscall.tbl
@@ -344,3 +344,7 @@
 332 common pkey_free sys_pkey_free
 333 common rseq sys_rseq
 # 334 through 423 are reserved to sync up with other architectures
+424 common pidfd_send_signal sys_pidfd_send_signal
+425 common io_uring_setup sys_io_uring_setup
+426 common io_uring_enter sys_io_uring_enter
+427 common io_uring_register sys_io_uring_register
diff --git a/arch/m68k/kernel/syscalls/syscall.tbl
b/arch/m68k/kernel/syscalls/syscall.tbl
index 125c14178979..df4ec3ec71d1 100644
--- a/arch/m68k/kernel/syscalls/syscall.tbl
+++ b/arch/m68k/kernel/syscalls/syscall.tbl
@@ -423,3 +423,7 @@
 421 common rt_sigtimedwait_time64 sys_rt_sigtimedwait
 422 common futex_time64 sys_futex
 423 common sched_rr_get_interval_time64 sys_sched_rr_get_interval
+424 common pidfd_send_signal sys_pidfd_send_signal
+425 common io_uring_setup sys_io_uring_setup
+426 common io_uring_enter sys_io_uring_enter
+427 common io_uring_register sys_io_uring_register
diff --git a/arch/microblaze/kernel/syscalls/syscall.tbl
b/arch/microblaze/kernel/syscalls/syscall.tbl
index 8ee3a8c18498..4964947732af 100644
--- a/arch/microblaze/kernel/syscalls/syscall.tbl
+++ b/arch/microblaze/kernel/syscalls/syscall.tbl
@@ -429,3 +429,7 @@
 421 common rt_sigtimedwait_time64 sys_rt_sigtimedwait
 422 common futex_time64 sys_futex
 423 common sched_rr_get_interval_time64 sys_sched_rr_get_interval
+424 common pidfd_send_signal sys_pidfd_send_signal
+425 common io_uring_setup sys_io_uring_setup
+426 common io_uring_enter sys_io_uring_enter
+427 common io_uring_register sys_io_uring_register
diff --git a/arch/mips/kernel/syscalls/syscall_n32.tbl
b/arch/mips/kernel/syscalls/syscall_n32.tbl
index 15f4117900ee..9392dfe33f97 100644
--- a/arch/mips/kernel/syscalls/syscall_n32.tbl
+++ b/arch/mips/kernel/syscalls/syscall_n32.tbl
@@ -362,3 +362,7 @@
 421 n32 rt_sigtimedwait_time64 compat_sys_rt_sigtimedwait_time64
 422 n32 futex_time64 sys_futex
 423 n32 sched_rr_get_interval_time64 sys_sched_rr_get_interval
+424 n32 pidfd_send_signal sys_pidfd_send_signal
+425 n32 io_uring_setup sys_io_uring_setup
+426 n32 io_uring_enter sys_io_uring_enter
+427 n32 io_uring_register sys_io_uring_register
diff --git a/arch/mips/kernel/syscalls/syscall_n64.tbl
b/arch/mips/kernel/syscalls/syscall_n64.tbl
index c85502e67b44..cd0c8aa21fba 100644
--- a/arch/mips/kernel/syscalls/syscall_n64.tbl
+++ b/arch/mips/kernel/syscalls/syscall_n64.tbl
@@ -338,3 +338,7 @@
 327 n64 rseq sys_rseq
 328 n64 io_pgetevents sys_io_pgetevents
 # 329 through 423 are reserved to sync up with other architectures
+424 n64 pidfd_send_signal sys_pidfd_send_signal
+425 n64 io_uring_setup sys_io_uring_setup
+426 n64 io_uring_enter sys_io_uring_enter
+427 n64 io_uring_register sys_io_uring_register
diff --git a/arch/mips/kernel/syscalls/syscall_o32.tbl
b/arch/mips/kernel/syscalls/syscall_o32.tbl
index 2e063d0f837e..e849e8ffe4a2 100644
--- a/arch/mips/kernel/syscalls/syscall_o32.tbl
+++ b/arch/mips/kernel/syscalls/syscall_o32.tbl
@@ -411,3 +411,7 @@
 421 o32 rt_sigtimedwait_time64 sys_rt_sigtimedwait
compat_sys_rt_sigtimedwait_time64
 422 o32 futex_time64 sys_futex sys_futex
 423 o32 sched_rr_get_interval_time64 sys_sched_rr_get_interval
sys_sched_rr_get_interval
+424 o32 pidfd_send_signal sys_pidfd_send_signal
+425 o32 io_uring_setup sys_io_uring_setup
+426 o32 io_uring_enter sys_io_uring_enter
+427 o32 io_uring_register sys_io_uring_register
diff --git a/arch/parisc/kernel/syscalls/syscall.tbl
b/arch/parisc/kernel/syscalls/syscall.tbl
index b26766c6647d..fe8ca623add8 100644
--- a/arch/parisc/kernel/syscalls/syscall.tbl
+++ b/arch/parisc/kernel/syscalls/syscall.tbl
@@ -420,3 +420,7 @@
 421 32 rt_sigtimedwait_time64 sys_rt_sigtimedwait
compat_sys_rt_sigtimedwait_time64
 422 32 futex_time64 sys_futex sys_futex
 423 32 sched_rr_get_interval_time64 sys_sched_rr_get_interval
sys_sched_rr_get_interval
+424 common pidfd_send_signal sys_pidfd_send_signal
+425 common io_uring_setup sys_io_uring_setup
+426 common io_uring_enter sys_io_uring_enter
+427 common io_uring_register sys_io_uring_register
diff --git a/arch/powerpc/kernel/syscalls/syscall.tbl
b/arch/powerpc/kernel/syscalls/syscall.tbl
index b18abb0c3dae..00f5a63c8d9a 100644
--- a/arch/powerpc/kernel/syscalls/syscall.tbl
+++ b/arch/powerpc/kernel/syscalls/syscall.tbl
@@ -505,3 +505,7 @@
 421 32 rt_sigtimedwait_time64 sys_rt_sigtimedwait
compat_sys_rt_sigtimedwait_time64
 422 32 futex_time64 sys_futex sys_futex
 423 32 sched_rr_get_interval_time64 sys_sched_rr_get_interval
sys_sched_rr_get_interval
+424 common pidfd_send_signal sys_pidfd_send_signal
+425 common io_uring_setup sys_io_uring_setup
+426 common io_uring_enter sys_io_uring_enter
+427 common io_uring_register sys_io_uring_register
diff --git a/arch/s390/kernel/syscalls/syscall.tbl
b/arch/s390/kernel/syscalls/syscall.tbl
index 02579f95f391..061418f787c3 100644
--- a/arch/s390/kernel/syscalls/syscall.tbl
+++ b/arch/s390/kernel/syscalls/syscall.tbl
@@ -426,3 +426,7 @@
 421 32 rt_sigtimedwait_time64 - compat_sys_rt_sigtimedwait_time64
 422 32 futex_time64 - sys_futex
 423 32 sched_rr_get_interval_time64 - sys_sched_rr_get_interval
+424  common pidfd_send_signal sys_pidfd_send_signal sys_pidfd_send_signal
+425  common io_uring_setup sys_io_uring_setup              sys_io_uring_setup
+426  common io_uring_enter sys_io_uring_enter              sys_io_uring_enter
+427  common io_uring_register sys_io_uring_register
sys_io_uring_register
diff --git a/arch/sh/kernel/syscalls/syscall.tbl
b/arch/sh/kernel/syscalls/syscall.tbl
index bfda678576e4..480b057556ee 100644
--- a/arch/sh/kernel/syscalls/syscall.tbl
+++ b/arch/sh/kernel/syscalls/syscall.tbl
@@ -426,3 +426,7 @@
 421 common rt_sigtimedwait_time64 sys_rt_sigtimedwait
 422 common futex_time64 sys_futex
 423 common sched_rr_get_interval_time64 sys_sched_rr_get_interval
+424 common pidfd_send_signal sys_pidfd_send_signal
+425 common io_uring_setup sys_io_uring_setup
+426 common io_uring_enter sys_io_uring_enter
+427 common io_uring_register sys_io_uring_register
diff --git a/arch/sparc/kernel/syscalls/syscall.tbl
b/arch/sparc/kernel/syscalls/syscall.tbl
index b9a5a04b2d2c..a1dd24307b00 100644
--- a/arch/sparc/kernel/syscalls/syscall.tbl
+++ b/arch/sparc/kernel/syscalls/syscall.tbl
@@ -469,3 +469,7 @@
 421 32 rt_sigtimedwait_time64 sys_rt_sigtimedwait
compat_sys_rt_sigtimedwait_time64
 422 32 futex_time64 sys_futex sys_futex
 423 32 sched_rr_get_interval_time64 sys_sched_rr_get_interval
sys_sched_rr_get_interval
+424 common pidfd_send_signal sys_pidfd_send_signal
+425 common io_uring_setup sys_io_uring_setup
+426 common io_uring_enter sys_io_uring_enter
+427 common io_uring_register sys_io_uring_register
diff --git a/arch/xtensa/kernel/syscalls/syscall.tbl
b/arch/xtensa/kernel/syscalls/syscall.tbl
index 6af49929de85..30084eaf8422 100644
--- a/arch/xtensa/kernel/syscalls/syscall.tbl
+++ b/arch/xtensa/kernel/syscalls/syscall.tbl
@@ -394,3 +394,7 @@
 421 common rt_sigtimedwait_time64 sys_rt_sigtimedwait
 422 common futex_time64 sys_futex
 423 common sched_rr_get_interval_time64 sys_sched_rr_get_interval
+424 common pidfd_send_signal sys_pidfd_send_signal
+425 common io_uring_setup sys_io_uring_setup
+426 common io_uring_enter sys_io_uring_enter
+427 common io_uring_register sys_io_uring_register
