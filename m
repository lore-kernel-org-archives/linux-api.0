From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v2 25/29] y2038: syscalls: rename y2038 compat syscalls
Date: Fri, 18 Jan 2019 17:18:31 +0100
Message-ID: <20190118161835.2259170-26-arnd@arndb.de>
References: <20190118161835.2259170-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190118161835.2259170-1-arnd@arndb.de>
Sender: netdev-owner@vger.kernel.org
To: y2038@lists.linaro.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, mattst88@gmail.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, tony.luck@intel.com, fenghua.yu@intel.com, geert@linux-m68k.org, monstr@monstr.eu, paul.burton@mips.com, deller@gmx.de, benh@kernel.crashing.org, mpe@ellerman.id.au, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, dalias@libc.org, davem@davemloft.net, luto@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org, jcmvbkbc@gmail.com, akpm@linux-foundation.org, deepa.kernel@gmail.com, ebiederm@xmission.com, firoz.khan@linaro.org, linux-alpha@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-ia64@vger.kernel.org, linux-m68k@lists.linux-m68k.org, linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.or
List-Id: linux-api@vger.kernel.org

A lot of system calls that pass a time_t somewhere have an implementation
using a COMPAT_SYSCALL_DEFINEx() on 64-bit architectures, and have
been reworked so that this implementation can now be used on 32-bit
architectures as well.

The missing step is to redefine them using the regular SYSCALL_DEFINEx()
to get them out of the compat namespace and make it possible to build them
on 32-bit architectures.

Any system call that ends in 'time' gets a '32' suffix on its name for
that version, while the others get a '_time32' suffix, to distinguish
them from the normal version, which takes a 64-bit time argument in the
future.

In this step, only 64-bit architectures are changed, doing this rename
first lets us avoid touching the 32-bit architectures twice.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm64/include/asm/unistd32.h         | 48 +++++++--------
 arch/mips/kernel/syscalls/syscall_n32.tbl | 50 ++++++++--------
 arch/mips/kernel/syscalls/syscall_o32.tbl | 52 ++++++++--------
 arch/parisc/kernel/syscalls/syscall.tbl   | 54 ++++++++---------
 arch/powerpc/kernel/syscalls/syscall.tbl  | 52 ++++++++--------
 arch/s390/kernel/syscalls/syscall.tbl     | 52 ++++++++--------
 arch/sparc/kernel/syscalls/syscall.tbl    | 52 ++++++++--------
 arch/x86/entry/syscalls/syscall_32.tbl    | 52 ++++++++--------
 fs/aio.c                                  | 10 ++--
 fs/select.c                               |  4 +-
 fs/timerfd.c                              |  4 +-
 fs/utimes.c                               | 10 ++--
 include/linux/compat.h                    | 73 ++---------------------
 include/linux/syscalls.h                  | 57 ++++++++++++++++++
 include/uapi/asm-generic/unistd.h         | 44 +++++++-------
 ipc/mqueue.c                              | 16 ++---
 ipc/sem.c                                 |  2 +-
 kernel/futex.c                            |  2 +-
 kernel/sched/core.c                       |  5 +-
 kernel/signal.c                           |  2 +-
 kernel/sys_ni.c                           | 18 +++---
 kernel/time/hrtimer.c                     |  2 +-
 kernel/time/posix-stubs.c                 | 25 ++++----
 kernel/time/posix-timers.c                | 32 +++++-----
 kernel/time/time.c                        |  8 +--
 net/compat.c                              |  2 +-
 26 files changed, 361 insertions(+), 367 deletions(-)

diff --git a/arch/arm64/include/asm/unistd32.h b/arch/arm64/include/asm/unistd32.h
index d10cce69a4b0..1ded82857161 100644
--- a/arch/arm64/include/asm/unistd32.h
+++ b/arch/arm64/include/asm/unistd32.h
@@ -270,7 +270,7 @@ __SYSCALL(__NR_uname, sys_newuname)
 			/* 123 was sys_modify_ldt */
 __SYSCALL(123, sys_ni_syscall)
 #define __NR_adjtimex 124
-__SYSCALL(__NR_adjtimex, compat_sys_adjtimex)
+__SYSCALL(__NR_adjtimex, sys_adjtimex_time32)
 #define __NR_mprotect 125
 __SYSCALL(__NR_mprotect, sys_mprotect)
 #define __NR_sigprocmask 126
@@ -344,9 +344,9 @@ __SYSCALL(__NR_sched_get_priority_max, sys_sched_get_priority_max)
 #define __NR_sched_get_priority_min 160
 __SYSCALL(__NR_sched_get_priority_min, sys_sched_get_priority_min)
 #define __NR_sched_rr_get_interval 161
-__SYSCALL(__NR_sched_rr_get_interval, compat_sys_sched_rr_get_interval)
+__SYSCALL(__NR_sched_rr_get_interval, sys_sched_rr_get_interval_time32)
 #define __NR_nanosleep 162
-__SYSCALL(__NR_nanosleep, compat_sys_nanosleep)
+__SYSCALL(__NR_nanosleep, sys_nanosleep_time32)
 #define __NR_mremap 163
 __SYSCALL(__NR_mremap, sys_mremap)
 #define __NR_setresuid 164
@@ -376,7 +376,7 @@ __SYSCALL(__NR_rt_sigprocmask, compat_sys_rt_sigprocmask)
 #define __NR_rt_sigpending 176
 __SYSCALL(__NR_rt_sigpending, compat_sys_rt_sigpending)
 #define __NR_rt_sigtimedwait 177
-__SYSCALL(__NR_rt_sigtimedwait, compat_sys_rt_sigtimedwait)
+__SYSCALL(__NR_rt_sigtimedwait, compat_sys_rt_sigtimedwait_time32)
 #define __NR_rt_sigqueueinfo 178
 __SYSCALL(__NR_rt_sigqueueinfo, compat_sys_rt_sigqueueinfo)
 #define __NR_rt_sigsuspend 179
@@ -502,7 +502,7 @@ __SYSCALL(__NR_tkill, sys_tkill)
 #define __NR_sendfile64 239
 __SYSCALL(__NR_sendfile64, sys_sendfile64)
 #define __NR_futex 240
-__SYSCALL(__NR_futex, compat_sys_futex)
+__SYSCALL(__NR_futex, sys_futex_time32)
 #define __NR_sched_setaffinity 241
 __SYSCALL(__NR_sched_setaffinity, compat_sys_sched_setaffinity)
 #define __NR_sched_getaffinity 242
@@ -512,7 +512,7 @@ __SYSCALL(__NR_io_setup, compat_sys_io_setup)
 #define __NR_io_destroy 244
 __SYSCALL(__NR_io_destroy, sys_io_destroy)
 #define __NR_io_getevents 245
-__SYSCALL(__NR_io_getevents, compat_sys_io_getevents)
+__SYSCALL(__NR_io_getevents, sys_io_getevents_time32)
 #define __NR_io_submit 246
 __SYSCALL(__NR_io_submit, compat_sys_io_submit)
 #define __NR_io_cancel 247
@@ -538,21 +538,21 @@ __SYSCALL(__NR_set_tid_address, sys_set_tid_address)
 #define __NR_timer_create 257
 __SYSCALL(__NR_timer_create, compat_sys_timer_create)
 #define __NR_timer_settime 258
-__SYSCALL(__NR_timer_settime, compat_sys_timer_settime)
+__SYSCALL(__NR_timer_settime, sys_timer_settime32)
 #define __NR_timer_gettime 259
-__SYSCALL(__NR_timer_gettime, compat_sys_timer_gettime)
+__SYSCALL(__NR_timer_gettime, sys_timer_gettime32)
 #define __NR_timer_getoverrun 260
 __SYSCALL(__NR_timer_getoverrun, sys_timer_getoverrun)
 #define __NR_timer_delete 261
 __SYSCALL(__NR_timer_delete, sys_timer_delete)
 #define __NR_clock_settime 262
-__SYSCALL(__NR_clock_settime, compat_sys_clock_settime)
+__SYSCALL(__NR_clock_settime, sys_clock_settime32)
 #define __NR_clock_gettime 263
-__SYSCALL(__NR_clock_gettime, compat_sys_clock_gettime)
+__SYSCALL(__NR_clock_gettime, sys_clock_gettime32)
 #define __NR_clock_getres 264
-__SYSCALL(__NR_clock_getres, compat_sys_clock_getres)
+__SYSCALL(__NR_clock_getres, sys_clock_getres_time32)
 #define __NR_clock_nanosleep 265
-__SYSCALL(__NR_clock_nanosleep, compat_sys_clock_nanosleep)
+__SYSCALL(__NR_clock_nanosleep, sys_clock_nanosleep_time32)
 #define __NR_statfs64 266
 __SYSCALL(__NR_statfs64, compat_sys_aarch32_statfs64)
 #define __NR_fstatfs64 267
@@ -560,7 +560,7 @@ __SYSCALL(__NR_fstatfs64, compat_sys_aarch32_fstatfs64)
 #define __NR_tgkill 268
 __SYSCALL(__NR_tgkill, sys_tgkill)
 #define __NR_utimes 269
-__SYSCALL(__NR_utimes, compat_sys_utimes)
+__SYSCALL(__NR_utimes, sys_utimes_time32)
 #define __NR_arm_fadvise64_64 270
 __SYSCALL(__NR_arm_fadvise64_64, compat_sys_aarch32_fadvise64_64)
 #define __NR_pciconfig_iobase 271
@@ -574,9 +574,9 @@ __SYSCALL(__NR_mq_open, compat_sys_mq_open)
 #define __NR_mq_unlink 275
 __SYSCALL(__NR_mq_unlink, sys_mq_unlink)
 #define __NR_mq_timedsend 276
-__SYSCALL(__NR_mq_timedsend, compat_sys_mq_timedsend)
+__SYSCALL(__NR_mq_timedsend, sys_mq_timedsend_time32)
 #define __NR_mq_timedreceive 277
-__SYSCALL(__NR_mq_timedreceive, compat_sys_mq_timedreceive)
+__SYSCALL(__NR_mq_timedreceive, sys_mq_timedreceive_time32)
 #define __NR_mq_notify 278
 __SYSCALL(__NR_mq_notify, compat_sys_mq_notify)
 #define __NR_mq_getsetattr 279
@@ -646,7 +646,7 @@ __SYSCALL(__NR_request_key, sys_request_key)
 #define __NR_keyctl 311
 __SYSCALL(__NR_keyctl, compat_sys_keyctl)
 #define __NR_semtimedop 312
-__SYSCALL(__NR_semtimedop, compat_sys_semtimedop)
+__SYSCALL(__NR_semtimedop, sys_semtimedop_time32)
 #define __NR_vserver 313
 __SYSCALL(__NR_vserver, sys_ni_syscall)
 #define __NR_ioprio_set 314
@@ -674,7 +674,7 @@ __SYSCALL(__NR_mknodat, sys_mknodat)
 #define __NR_fchownat 325
 __SYSCALL(__NR_fchownat, sys_fchownat)
 #define __NR_futimesat 326
-__SYSCALL(__NR_futimesat, compat_sys_futimesat)
+__SYSCALL(__NR_futimesat, sys_futimesat_time32)
 #define __NR_fstatat64 327
 __SYSCALL(__NR_fstatat64, sys_fstatat64)
 #define __NR_unlinkat 328
@@ -692,9 +692,9 @@ __SYSCALL(__NR_fchmodat, sys_fchmodat)
 #define __NR_faccessat 334
 __SYSCALL(__NR_faccessat, sys_faccessat)
 #define __NR_pselect6 335
-__SYSCALL(__NR_pselect6, compat_sys_pselect6)
+__SYSCALL(__NR_pselect6, compat_sys_pselect6_time32)
 #define __NR_ppoll 336
-__SYSCALL(__NR_ppoll, compat_sys_ppoll)
+__SYSCALL(__NR_ppoll, compat_sys_ppoll_time32)
 #define __NR_unshare 337
 __SYSCALL(__NR_unshare, sys_unshare)
 #define __NR_set_robust_list 338
@@ -718,7 +718,7 @@ __SYSCALL(__NR_epoll_pwait, compat_sys_epoll_pwait)
 #define __NR_kexec_load 347
 __SYSCALL(__NR_kexec_load, compat_sys_kexec_load)
 #define __NR_utimensat 348
-__SYSCALL(__NR_utimensat, compat_sys_utimensat)
+__SYSCALL(__NR_utimensat, sys_utimensat_time32)
 #define __NR_signalfd 349
 __SYSCALL(__NR_signalfd, compat_sys_signalfd)
 #define __NR_timerfd_create 350
@@ -728,9 +728,9 @@ __SYSCALL(__NR_eventfd, sys_eventfd)
 #define __NR_fallocate 352
 __SYSCALL(__NR_fallocate, compat_sys_aarch32_fallocate)
 #define __NR_timerfd_settime 353
-__SYSCALL(__NR_timerfd_settime, compat_sys_timerfd_settime)
+__SYSCALL(__NR_timerfd_settime, sys_timerfd_settime32)
 #define __NR_timerfd_gettime 354
-__SYSCALL(__NR_timerfd_gettime, compat_sys_timerfd_gettime)
+__SYSCALL(__NR_timerfd_gettime, sys_timerfd_gettime32)
 #define __NR_signalfd4 355
 __SYSCALL(__NR_signalfd4, compat_sys_signalfd4)
 #define __NR_eventfd2 356
@@ -752,7 +752,7 @@ __SYSCALL(__NR_rt_tgsigqueueinfo, compat_sys_rt_tgsigqueueinfo)
 #define __NR_perf_event_open 364
 __SYSCALL(__NR_perf_event_open, sys_perf_event_open)
 #define __NR_recvmmsg 365
-__SYSCALL(__NR_recvmmsg, compat_sys_recvmmsg)
+__SYSCALL(__NR_recvmmsg, compat_sys_recvmmsg_time32)
 #define __NR_accept4 366
 __SYSCALL(__NR_accept4, sys_accept4)
 #define __NR_fanotify_init 367
@@ -766,7 +766,7 @@ __SYSCALL(__NR_name_to_handle_at, sys_name_to_handle_at)
 #define __NR_open_by_handle_at 371
 __SYSCALL(__NR_open_by_handle_at, compat_sys_open_by_handle_at)
 #define __NR_clock_adjtime 372
-__SYSCALL(__NR_clock_adjtime, compat_sys_clock_adjtime)
+__SYSCALL(__NR_clock_adjtime, sys_clock_adjtime32)
 #define __NR_syncfs 373
 __SYSCALL(__NR_syncfs, sys_syncfs)
 #define __NR_sendmmsg 374
diff --git a/arch/mips/kernel/syscalls/syscall_n32.tbl b/arch/mips/kernel/syscalls/syscall_n32.tbl
index cc134b1211aa..6d1e019817c8 100644
--- a/arch/mips/kernel/syscalls/syscall_n32.tbl
+++ b/arch/mips/kernel/syscalls/syscall_n32.tbl
@@ -41,7 +41,7 @@
 31	n32	dup				sys_dup
 32	n32	dup2				sys_dup2
 33	n32	pause				sys_pause
-34	n32	nanosleep			compat_sys_nanosleep
+34	n32	nanosleep			sys_nanosleep_time32
 35	n32	getitimer			compat_sys_getitimer
 36	n32	setitimer			compat_sys_setitimer
 37	n32	alarm				sys_alarm
@@ -133,11 +133,11 @@
 123	n32	capget				sys_capget
 124	n32	capset				sys_capset
 125	n32	rt_sigpending			compat_sys_rt_sigpending
-126	n32	rt_sigtimedwait			compat_sys_rt_sigtimedwait
+126	n32	rt_sigtimedwait			compat_sys_rt_sigtimedwait_time32
 127	n32	rt_sigqueueinfo			compat_sys_rt_sigqueueinfo
 128	n32	rt_sigsuspend			compat_sys_rt_sigsuspend
 129	n32	sigaltstack			compat_sys_sigaltstack
-130	n32	utime				compat_sys_utime
+130	n32	utime				sys_utime32
 131	n32	mknod				sys_mknod
 132	n32	personality			sys_32_personality
 133	n32	ustat				compat_sys_ustat
@@ -152,7 +152,7 @@
 142	n32	sched_getscheduler		sys_sched_getscheduler
 143	n32	sched_get_priority_max		sys_sched_get_priority_max
 144	n32	sched_get_priority_min		sys_sched_get_priority_min
-145	n32	sched_rr_get_interval		compat_sys_sched_rr_get_interval
+145	n32	sched_rr_get_interval		sys_sched_rr_get_interval_time32
 146	n32	mlock				sys_mlock
 147	n32	munlock				sys_munlock
 148	n32	mlockall			sys_mlockall
@@ -161,7 +161,7 @@
 151	n32	pivot_root			sys_pivot_root
 152	n32	_sysctl				compat_sys_sysctl
 153	n32	prctl				sys_prctl
-154	n32	adjtimex			compat_sys_adjtimex
+154	n32	adjtimex			sys_adjtimex_time32
 155	n32	setrlimit			compat_sys_setrlimit
 156	n32	chroot				sys_chroot
 157	n32	sync				sys_sync
@@ -202,7 +202,7 @@
 191	n32	fremovexattr			sys_fremovexattr
 192	n32	tkill				sys_tkill
 193	n32	reserved193			sys_ni_syscall
-194	n32	futex				compat_sys_futex
+194	n32	futex				sys_futex_time32
 195	n32	sched_setaffinity		compat_sys_sched_setaffinity
 196	n32	sched_getaffinity		compat_sys_sched_getaffinity
 197	n32	cacheflush			sys_cacheflush
@@ -210,7 +210,7 @@
 199	n32	sysmips				__sys_sysmips
 200	n32	io_setup			compat_sys_io_setup
 201	n32	io_destroy			sys_io_destroy
-202	n32	io_getevents			compat_sys_io_getevents
+202	n32	io_getevents			sys_io_getevents_time32
 203	n32	io_submit			compat_sys_io_submit
 204	n32	io_cancel			sys_io_cancel
 205	n32	exit_group			sys_exit_group
@@ -223,29 +223,29 @@
 212	n32	fcntl64				compat_sys_fcntl64
 213	n32	set_tid_address			sys_set_tid_address
 214	n32	restart_syscall			sys_restart_syscall
-215	n32	semtimedop			compat_sys_semtimedop
+215	n32	semtimedop			sys_semtimedop_time32
 216	n32	fadvise64			sys_fadvise64_64
 217	n32	statfs64			compat_sys_statfs64
 218	n32	fstatfs64			compat_sys_fstatfs64
 219	n32	sendfile64			sys_sendfile64
 220	n32	timer_create			compat_sys_timer_create
-221	n32	timer_settime			compat_sys_timer_settime
-222	n32	timer_gettime			compat_sys_timer_gettime
+221	n32	timer_settime			sys_timer_settime32
+222	n32	timer_gettime			sys_timer_gettime32
 223	n32	timer_getoverrun		sys_timer_getoverrun
 224	n32	timer_delete			sys_timer_delete
-225	n32	clock_settime			compat_sys_clock_settime
-226	n32	clock_gettime			compat_sys_clock_gettime
-227	n32	clock_getres			compat_sys_clock_getres
-228	n32	clock_nanosleep			compat_sys_clock_nanosleep
+225	n32	clock_settime			sys_clock_settime32
+226	n32	clock_gettime			sys_clock_gettime32
+227	n32	clock_getres			sys_clock_getres_time32
+228	n32	clock_nanosleep			sys_clock_nanosleep_time32
 229	n32	tgkill				sys_tgkill
-230	n32	utimes				compat_sys_utimes
+230	n32	utimes				sys_utimes_time32
 231	n32	mbind				compat_sys_mbind
 232	n32	get_mempolicy			compat_sys_get_mempolicy
 233	n32	set_mempolicy			compat_sys_set_mempolicy
 234	n32	mq_open				compat_sys_mq_open
 235	n32	mq_unlink			sys_mq_unlink
-236	n32	mq_timedsend			compat_sys_mq_timedsend
-237	n32	mq_timedreceive			compat_sys_mq_timedreceive
+236	n32	mq_timedsend			sys_mq_timedsend_time32
+237	n32	mq_timedreceive			sys_mq_timedreceive_time32
 238	n32	mq_notify			compat_sys_mq_notify
 239	n32	mq_getsetattr			compat_sys_mq_getsetattr
 240	n32	vserver				sys_ni_syscall
@@ -263,7 +263,7 @@
 252	n32	mkdirat				sys_mkdirat
 253	n32	mknodat				sys_mknodat
 254	n32	fchownat			sys_fchownat
-255	n32	futimesat			compat_sys_futimesat
+255	n32	futimesat			sys_futimesat_time32
 256	n32	newfstatat			sys_newfstatat
 257	n32	unlinkat			sys_unlinkat
 258	n32	renameat			sys_renameat
@@ -272,8 +272,8 @@
 261	n32	readlinkat			sys_readlinkat
 262	n32	fchmodat			sys_fchmodat
 263	n32	faccessat			sys_faccessat
-264	n32	pselect6			compat_sys_pselect6
-265	n32	ppoll				compat_sys_ppoll
+264	n32	pselect6			compat_sys_pselect6_time32
+265	n32	ppoll				compat_sys_ppoll_time32
 266	n32	unshare				sys_unshare
 267	n32	splice				sys_splice
 268	n32	sync_file_range			sys_sync_file_range
@@ -287,14 +287,14 @@
 276	n32	epoll_pwait			compat_sys_epoll_pwait
 277	n32	ioprio_set			sys_ioprio_set
 278	n32	ioprio_get			sys_ioprio_get
-279	n32	utimensat			compat_sys_utimensat
+279	n32	utimensat			sys_utimensat_time32
 280	n32	signalfd			compat_sys_signalfd
 281	n32	timerfd				sys_ni_syscall
 282	n32	eventfd				sys_eventfd
 283	n32	fallocate			sys_fallocate
 284	n32	timerfd_create			sys_timerfd_create
-285	n32	timerfd_gettime			compat_sys_timerfd_gettime
-286	n32	timerfd_settime			compat_sys_timerfd_settime
+285	n32	timerfd_gettime			sys_timerfd_gettime32
+286	n32	timerfd_settime			sys_timerfd_settime32
 287	n32	signalfd4			compat_sys_signalfd4
 288	n32	eventfd2			sys_eventfd2
 289	n32	epoll_create1			sys_epoll_create1
@@ -306,14 +306,14 @@
 295	n32	rt_tgsigqueueinfo		compat_sys_rt_tgsigqueueinfo
 296	n32	perf_event_open			sys_perf_event_open
 297	n32	accept4				sys_accept4
-298	n32	recvmmsg			compat_sys_recvmmsg
+298	n32	recvmmsg			compat_sys_recvmmsg_time32
 299	n32	getdents64			sys_getdents64
 300	n32	fanotify_init			sys_fanotify_init
 301	n32	fanotify_mark			sys_fanotify_mark
 302	n32	prlimit64			sys_prlimit64
 303	n32	name_to_handle_at		sys_name_to_handle_at
 304	n32	open_by_handle_at		sys_open_by_handle_at
-305	n32	clock_adjtime			compat_sys_clock_adjtime
+305	n32	clock_adjtime			sys_clock_adjtime32
 306	n32	syncfs				sys_syncfs
 307	n32	sendmmsg			compat_sys_sendmmsg
 308	n32	setns				sys_setns
diff --git a/arch/mips/kernel/syscalls/syscall_o32.tbl b/arch/mips/kernel/syscalls/syscall_o32.tbl
index fa47ea8cc6ef..e9fec7bac5a9 100644
--- a/arch/mips/kernel/syscalls/syscall_o32.tbl
+++ b/arch/mips/kernel/syscalls/syscall_o32.tbl
@@ -20,7 +20,7 @@
 10	o32	unlink				sys_unlink
 11	o32	execve				sys_execve			compat_sys_execve
 12	o32	chdir				sys_chdir
-13	o32	time				sys_time			compat_sys_time
+13	o32	time				sys_time			sys_time32
 14	o32	mknod				sys_mknod
 15	o32	chmod				sys_chmod
 16	o32	lchown				sys_lchown
@@ -33,13 +33,13 @@
 22	o32	umount				sys_oldumount
 23	o32	setuid				sys_setuid
 24	o32	getuid				sys_getuid
-25	o32	stime				sys_stime			compat_sys_stime
+25	o32	stime				sys_stime			sys_stime32
 26	o32	ptrace				sys_ptrace			compat_sys_ptrace
 27	o32	alarm				sys_alarm
 # 28 was sys_fstat
 28	o32	unused28			sys_ni_syscall
 29	o32	pause				sys_pause
-30	o32	utime				sys_utime			compat_sys_utime
+30	o32	utime				sys_utime			sys_utime32
 31	o32	stty				sys_ni_syscall
 32	o32	gtty				sys_ni_syscall
 33	o32	access				sys_access
@@ -135,7 +135,7 @@
 121	o32	setdomainname			sys_setdomainname
 122	o32	uname				sys_newuname
 123	o32	modify_ldt			sys_ni_syscall
-124	o32	adjtimex			sys_adjtimex			compat_sys_adjtimex
+124	o32	adjtimex			sys_adjtimex			sys_adjtimex_time32
 125	o32	mprotect			sys_mprotect
 126	o32	sigprocmask			sys_sigprocmask			compat_sys_sigprocmask
 127	o32	create_module			sys_ni_syscall
@@ -176,8 +176,8 @@
 162	o32	sched_yield			sys_sched_yield
 163	o32	sched_get_priority_max		sys_sched_get_priority_max
 164	o32	sched_get_priority_min		sys_sched_get_priority_min
-165	o32	sched_rr_get_interval		sys_sched_rr_get_interval	compat_sys_sched_rr_get_interval
-166	o32	nanosleep			sys_nanosleep			compat_sys_nanosleep
+165	o32	sched_rr_get_interval		sys_sched_rr_get_interval	sys_sched_rr_get_interval_time32
+166	o32	nanosleep			sys_nanosleep			sys_nanosleep_time32
 167	o32	mremap				sys_mremap
 168	o32	accept				sys_accept
 169	o32	bind				sys_bind
@@ -208,7 +208,7 @@
 194	o32	rt_sigaction			sys_rt_sigaction		compat_sys_rt_sigaction
 195	o32	rt_sigprocmask			sys_rt_sigprocmask		compat_sys_rt_sigprocmask
 196	o32	rt_sigpending			sys_rt_sigpending		compat_sys_rt_sigpending
-197	o32	rt_sigtimedwait			sys_rt_sigtimedwait		compat_sys_rt_sigtimedwait
+197	o32	rt_sigtimedwait			sys_rt_sigtimedwait		compat_sys_rt_sigtimedwait_time32
 198	o32	rt_sigqueueinfo			sys_rt_sigqueueinfo		compat_sys_rt_sigqueueinfo
 199	o32	rt_sigsuspend			sys_rt_sigsuspend		compat_sys_rt_sigsuspend
 200	o32	pread64				sys_pread64			sys_32_pread
@@ -249,12 +249,12 @@
 235	o32	fremovexattr			sys_fremovexattr
 236	o32	tkill				sys_tkill
 237	o32	sendfile64			sys_sendfile64
-238	o32	futex				sys_futex			compat_sys_futex
+238	o32	futex				sys_futex			sys_futex_time32
 239	o32	sched_setaffinity		sys_sched_setaffinity		compat_sys_sched_setaffinity
 240	o32	sched_getaffinity		sys_sched_getaffinity		compat_sys_sched_getaffinity
 241	o32	io_setup			sys_io_setup			compat_sys_io_setup
 242	o32	io_destroy			sys_io_destroy
-243	o32	io_getevents			sys_io_getevents		compat_sys_io_getevents
+243	o32	io_getevents			sys_io_getevents		sys_io_getevents_time32
 244	o32	io_submit			sys_io_submit			compat_sys_io_submit
 245	o32	io_cancel			sys_io_cancel
 246	o32	exit_group			sys_exit_group
@@ -269,23 +269,23 @@
 255	o32	statfs64			sys_statfs64			compat_sys_statfs64
 256	o32	fstatfs64			sys_fstatfs64			compat_sys_fstatfs64
 257	o32	timer_create			sys_timer_create		compat_sys_timer_create
-258	o32	timer_settime			sys_timer_settime		compat_sys_timer_settime
-259	o32	timer_gettime			sys_timer_gettime		compat_sys_timer_gettime
+258	o32	timer_settime			sys_timer_settime		sys_timer_settime32
+259	o32	timer_gettime			sys_timer_gettime		sys_timer_gettime32
 260	o32	timer_getoverrun		sys_timer_getoverrun
 261	o32	timer_delete			sys_timer_delete
-262	o32	clock_settime			sys_clock_settime		compat_sys_clock_settime
-263	o32	clock_gettime			sys_clock_gettime		compat_sys_clock_gettime
-264	o32	clock_getres			sys_clock_getres		compat_sys_clock_getres
-265	o32	clock_nanosleep			sys_clock_nanosleep		compat_sys_clock_nanosleep
+262	o32	clock_settime			sys_clock_settime		sys_clock_settime32
+263	o32	clock_gettime			sys_clock_gettime		sys_clock_gettime32
+264	o32	clock_getres			sys_clock_getres		sys_clock_getres_time32
+265	o32	clock_nanosleep			sys_clock_nanosleep		sys_clock_nanosleep_time32
 266	o32	tgkill				sys_tgkill
-267	o32	utimes				sys_utimes			compat_sys_utimes
+267	o32	utimes				sys_utimes			sys_utimes_time32
 268	o32	mbind				sys_mbind			compat_sys_mbind
 269	o32	get_mempolicy			sys_get_mempolicy		compat_sys_get_mempolicy
 270	o32	set_mempolicy			sys_set_mempolicy		compat_sys_set_mempolicy
 271	o32	mq_open				sys_mq_open			compat_sys_mq_open
 272	o32	mq_unlink			sys_mq_unlink
-273	o32	mq_timedsend			sys_mq_timedsend		compat_sys_mq_timedsend
-274	o32	mq_timedreceive			sys_mq_timedreceive		compat_sys_mq_timedreceive
+273	o32	mq_timedsend			sys_mq_timedsend		sys_mq_timedsend_time32
+274	o32	mq_timedreceive			sys_mq_timedreceive		sys_mq_timedreceive_time32
 275	o32	mq_notify			sys_mq_notify			compat_sys_mq_notify
 276	o32	mq_getsetattr			sys_mq_getsetattr		compat_sys_mq_getsetattr
 277	o32	vserver				sys_ni_syscall
@@ -303,7 +303,7 @@
 289	o32	mkdirat				sys_mkdirat
 290	o32	mknodat				sys_mknodat
 291	o32	fchownat			sys_fchownat
-292	o32	futimesat			sys_futimesat			compat_sys_futimesat
+292	o32	futimesat			sys_futimesat			sys_futimesat_time32
 293	o32	fstatat64			sys_fstatat64			sys_newfstatat
 294	o32	unlinkat			sys_unlinkat
 295	o32	renameat			sys_renameat
@@ -312,8 +312,8 @@
 298	o32	readlinkat			sys_readlinkat
 299	o32	fchmodat			sys_fchmodat
 300	o32	faccessat			sys_faccessat
-301	o32	pselect6			sys_pselect6			compat_sys_pselect6
-302	o32	ppoll				sys_ppoll			compat_sys_ppoll
+301	o32	pselect6			sys_pselect6			compat_sys_pselect6_time32
+302	o32	ppoll				sys_ppoll			compat_sys_ppoll_time32
 303	o32	unshare				sys_unshare
 304	o32	splice				sys_splice
 305	o32	sync_file_range			sys_sync_file_range		sys32_sync_file_range
@@ -327,14 +327,14 @@
 313	o32	epoll_pwait			sys_epoll_pwait			compat_sys_epoll_pwait
 314	o32	ioprio_set			sys_ioprio_set
 315	o32	ioprio_get			sys_ioprio_get
-316	o32	utimensat			sys_utimensat			compat_sys_utimensat
+316	o32	utimensat			sys_utimensat			sys_utimensat_time32
 317	o32	signalfd			sys_signalfd			compat_sys_signalfd
 318	o32	timerfd				sys_ni_syscall
 319	o32	eventfd				sys_eventfd
 320	o32	fallocate			sys_fallocate			sys32_fallocate
 321	o32	timerfd_create			sys_timerfd_create
-322	o32	timerfd_gettime			sys_timerfd_gettime		compat_sys_timerfd_gettime
-323	o32	timerfd_settime			sys_timerfd_settime		compat_sys_timerfd_settime
+322	o32	timerfd_gettime			sys_timerfd_gettime		sys_timerfd_gettime32
+323	o32	timerfd_settime			sys_timerfd_settime		sys_timerfd_settime32
 324	o32	signalfd4			sys_signalfd4			compat_sys_signalfd4
 325	o32	eventfd2			sys_eventfd2
 326	o32	epoll_create1			sys_epoll_create1
@@ -346,13 +346,13 @@
 332	o32	rt_tgsigqueueinfo		sys_rt_tgsigqueueinfo		compat_sys_rt_tgsigqueueinfo
 333	o32	perf_event_open			sys_perf_event_open
 334	o32	accept4				sys_accept4
-335	o32	recvmmsg			sys_recvmmsg			compat_sys_recvmmsg
+335	o32	recvmmsg			sys_recvmmsg			compat_sys_recvmmsg_time32
 336	o32	fanotify_init			sys_fanotify_init
 337	o32	fanotify_mark			sys_fanotify_mark		compat_sys_fanotify_mark
 338	o32	prlimit64			sys_prlimit64
 339	o32	name_to_handle_at		sys_name_to_handle_at
 340	o32	open_by_handle_at		sys_open_by_handle_at		compat_sys_open_by_handle_at
-341	o32	clock_adjtime			sys_clock_adjtime		compat_sys_clock_adjtime
+341	o32	clock_adjtime			sys_clock_adjtime		sys_clock_adjtime32
 342	o32	syncfs				sys_syncfs
 343	o32	sendmmsg			sys_sendmmsg			compat_sys_sendmmsg
 344	o32	setns				sys_setns
diff --git a/arch/parisc/kernel/syscalls/syscall.tbl b/arch/parisc/kernel/syscalls/syscall.tbl
index e07231de3597..13434629dbf5 100644
--- a/arch/parisc/kernel/syscalls/syscall.tbl
+++ b/arch/parisc/kernel/syscalls/syscall.tbl
@@ -20,7 +20,7 @@
 10	common	unlink			sys_unlink
 11	common	execve			sys_execve			compat_sys_execve
 12	common	chdir			sys_chdir
-13	common	time			sys_time			compat_sys_time
+13	common	time			sys_time			sys_time32
 14	common	mknod			sys_mknod
 15	common	chmod			sys_chmod
 16	common	lchown			sys_lchown
@@ -32,12 +32,12 @@
 22	common	bind			sys_bind
 23	common	setuid			sys_setuid
 24	common	getuid			sys_getuid
-25	common	stime			sys_stime			compat_sys_stime
+25	common	stime			sys_stime			sys_stime32
 26	common	ptrace			sys_ptrace			compat_sys_ptrace
 27	common	alarm			sys_alarm
 28	common	fstat			sys_newfstat			compat_sys_newfstat
 29	common	pause			sys_pause
-30	common	utime			sys_utime			compat_sys_utime
+30	common	utime			sys_utime			sys_utime32
 31	common	connect			sys_connect
 32	common	listen			sys_listen
 33	common	access			sys_access
@@ -133,7 +133,7 @@
 121	common	setdomainname		sys_setdomainname
 122	common	sendfile		sys_sendfile			compat_sys_sendfile
 123	common	recvfrom		sys_recvfrom
-124	common	adjtimex		sys_adjtimex			compat_sys_adjtimex
+124	common	adjtimex		sys_adjtimex			sys_adjtimex_time32
 125	common	mprotect		sys_mprotect
 126	common	sigprocmask		sys_sigprocmask			compat_sys_sigprocmask
 # 127 was create_module
@@ -171,8 +171,8 @@
 158	common	sched_yield		sys_sched_yield
 159	common	sched_get_priority_max	sys_sched_get_priority_max
 160	common	sched_get_priority_min	sys_sched_get_priority_min
-161	common	sched_rr_get_interval	sys_sched_rr_get_interval	compat_sys_sched_rr_get_interval
-162	common	nanosleep		sys_nanosleep			compat_sys_nanosleep
+161	common	sched_rr_get_interval	sys_sched_rr_get_interval	sys_sched_rr_get_interval_time32
+162	common	nanosleep		sys_nanosleep			sys_nanosleep_time32
 163	common	mremap			sys_mremap
 164	common	setresuid		sys_setresuid
 165	common	getresuid		sys_getresuid
@@ -187,7 +187,7 @@
 174	common	rt_sigaction		sys_rt_sigaction		compat_sys_rt_sigaction
 175	common	rt_sigprocmask		sys_rt_sigprocmask		compat_sys_rt_sigprocmask
 176	common	rt_sigpending		sys_rt_sigpending		compat_sys_rt_sigpending
-177	common	rt_sigtimedwait		sys_rt_sigtimedwait		compat_sys_rt_sigtimedwait
+177	common	rt_sigtimedwait		sys_rt_sigtimedwait		compat_sys_rt_sigtimedwait_time32
 178	common	rt_sigqueueinfo		sys_rt_sigqueueinfo		compat_sys_rt_sigqueueinfo
 179	common	rt_sigsuspend		sys_rt_sigsuspend		compat_sys_rt_sigsuspend
 180	common	chown			sys_chown
@@ -223,14 +223,14 @@
 207	64	readahead		sys_readahead
 208	common	tkill			sys_tkill
 209	common	sendfile64		sys_sendfile64			compat_sys_sendfile64
-210	common	futex			sys_futex			compat_sys_futex
+210	common	futex			sys_futex			sys_futex_time32
 211	common	sched_setaffinity	sys_sched_setaffinity		compat_sys_sched_setaffinity
 212	common	sched_getaffinity	sys_sched_getaffinity		compat_sys_sched_getaffinity
 # 213 was set_thread_area
 # 214 was get_thread_area
 215	common	io_setup		sys_io_setup			compat_sys_io_setup
 216	common	io_destroy		sys_io_destroy
-217	common	io_getevents		sys_io_getevents		compat_sys_io_getevents
+217	common	io_getevents		sys_io_getevents		sys_io_getevents_time32
 218	common	io_submit		sys_io_submit			compat_sys_io_submit
 219	common	io_cancel		sys_io_cancel
 # 220 was alloc_hugepages
@@ -241,11 +241,11 @@
 225	common	epoll_ctl		sys_epoll_ctl
 226	common	epoll_wait		sys_epoll_wait
 227	common	remap_file_pages	sys_remap_file_pages
-228	common	semtimedop		sys_semtimedop			compat_sys_semtimedop
+228	common	semtimedop		sys_semtimedop			sys_semtimedop_time32
 229	common	mq_open			sys_mq_open			compat_sys_mq_open
 230	common	mq_unlink		sys_mq_unlink
-231	common	mq_timedsend		sys_mq_timedsend		compat_sys_mq_timedsend
-232	common	mq_timedreceive		sys_mq_timedreceive		compat_sys_mq_timedreceive
+231	common	mq_timedsend		sys_mq_timedsend		sys_mq_timedsend_time32
+232	common	mq_timedreceive		sys_mq_timedreceive		sys_mq_timedreceive_time32
 233	common	mq_notify		sys_mq_notify			compat_sys_mq_notify
 234	common	mq_getsetattr		sys_mq_getsetattr		compat_sys_mq_getsetattr
 235	common	waitid			sys_waitid			compat_sys_waitid
@@ -265,14 +265,14 @@
 248	common	lremovexattr		sys_lremovexattr
 249	common	fremovexattr		sys_fremovexattr
 250	common	timer_create		sys_timer_create		compat_sys_timer_create
-251	common	timer_settime		sys_timer_settime		compat_sys_timer_settime
-252	common	timer_gettime		sys_timer_gettime		compat_sys_timer_gettime
+251	common	timer_settime		sys_timer_settime		sys_timer_settime32
+252	common	timer_gettime		sys_timer_gettime		sys_timer_gettime32
 253	common	timer_getoverrun	sys_timer_getoverrun
 254	common	timer_delete		sys_timer_delete
-255	common	clock_settime		sys_clock_settime		compat_sys_clock_settime
-256	common	clock_gettime		sys_clock_gettime		compat_sys_clock_gettime
-257	common	clock_getres		sys_clock_getres		compat_sys_clock_getres
-258	common	clock_nanosleep		sys_clock_nanosleep		compat_sys_clock_nanosleep
+255	common	clock_settime		sys_clock_settime		sys_clock_settime32
+256	common	clock_gettime		sys_clock_gettime		sys_clock_gettime32
+257	common	clock_getres		sys_clock_getres		sys_clock_getres_time32
+258	common	clock_nanosleep		sys_clock_nanosleep		sys_clock_nanosleep_time32
 259	common	tgkill			sys_tgkill
 260	common	mbind			sys_mbind			compat_sys_mbind
 261	common	get_mempolicy		sys_get_mempolicy		compat_sys_get_mempolicy
@@ -287,13 +287,13 @@
 270	common	inotify_add_watch	sys_inotify_add_watch
 271	common	inotify_rm_watch	sys_inotify_rm_watch
 272	common	migrate_pages		sys_migrate_pages
-273	common	pselect6		sys_pselect6			compat_sys_pselect6
-274	common	ppoll			sys_ppoll			compat_sys_ppoll
+273	common	pselect6		sys_pselect6			compat_sys_pselect6_time32
+274	common	ppoll			sys_ppoll			compat_sys_ppoll_time32
 275	common	openat			sys_openat			compat_sys_openat
 276	common	mkdirat			sys_mkdirat
 277	common	mknodat			sys_mknodat
 278	common	fchownat		sys_fchownat
-279	common	futimesat		sys_futimesat			compat_sys_futimesat
+279	common	futimesat		sys_futimesat			sys_futimesat_time32
 280	common	fstatat64		sys_fstatat64
 281	common	unlinkat		sys_unlinkat
 282	common	renameat		sys_renameat
@@ -316,15 +316,15 @@
 298	common	statfs64		sys_statfs64			compat_sys_statfs64
 299	common	fstatfs64		sys_fstatfs64			compat_sys_fstatfs64
 300	common	kexec_load		sys_kexec_load			compat_sys_kexec_load
-301	common	utimensat		sys_utimensat			compat_sys_utimensat
+301	common	utimensat		sys_utimensat			sys_utimensat_time32
 302	common	signalfd		sys_signalfd			compat_sys_signalfd
 # 303 was timerfd
 304	common	eventfd			sys_eventfd
 305	32	fallocate		parisc_fallocate
 305	64	fallocate		sys_fallocate
 306	common	timerfd_create		sys_timerfd_create
-307	common	timerfd_settime		sys_timerfd_settime		compat_sys_timerfd_settime
-308	common	timerfd_gettime		sys_timerfd_gettime		compat_sys_timerfd_gettime
+307	common	timerfd_settime		sys_timerfd_settime		sys_timerfd_settime32
+308	common	timerfd_gettime		sys_timerfd_gettime		sys_timerfd_gettime32
 309	common	signalfd4		sys_signalfd4			compat_sys_signalfd4
 310	common	eventfd2		sys_eventfd2
 311	common	epoll_create1		sys_epoll_create1
@@ -335,12 +335,12 @@
 316	common	pwritev	sys_pwritev	compat_sys_pwritev
 317	common	rt_tgsigqueueinfo	sys_rt_tgsigqueueinfo		compat_sys_rt_tgsigqueueinfo
 318	common	perf_event_open		sys_perf_event_open
-319	common	recvmmsg		sys_recvmmsg			compat_sys_recvmmsg
+319	common	recvmmsg		sys_recvmmsg			compat_sys_recvmmsg_time32
 320	common	accept4			sys_accept4
 321	common	prlimit64		sys_prlimit64
 322	common	fanotify_init		sys_fanotify_init
 323	common	fanotify_mark		sys_fanotify_mark		sys32_fanotify_mark
-324	common	clock_adjtime		sys_clock_adjtime		compat_sys_clock_adjtime
+324	common	clock_adjtime		sys_clock_adjtime		sys_clock_adjtime32
 325	common	name_to_handle_at	sys_name_to_handle_at
 326	common	open_by_handle_at	sys_open_by_handle_at		compat_sys_open_by_handle_at
 327	common	syncfs			sys_syncfs
@@ -352,7 +352,7 @@
 333	common	finit_module		sys_finit_module
 334	common	sched_setattr		sys_sched_setattr
 335	common	sched_getattr		sys_sched_getattr
-336	common	utimes			sys_utimes			compat_sys_utimes
+336	common	utimes			sys_utimes			sys_utimes_time32
 337	common	renameat2		sys_renameat2
 338	common	seccomp			sys_seccomp
 339	common	getrandom		sys_getrandom
diff --git a/arch/powerpc/kernel/syscalls/syscall.tbl b/arch/powerpc/kernel/syscalls/syscall.tbl
index 7555874ce39c..86650dcd2185 100644
--- a/arch/powerpc/kernel/syscalls/syscall.tbl
+++ b/arch/powerpc/kernel/syscalls/syscall.tbl
@@ -20,7 +20,7 @@
 10	common	unlink				sys_unlink
 11	nospu	execve				sys_execve			compat_sys_execve
 12	common	chdir				sys_chdir
-13	common	time				sys_time			compat_sys_time
+13	common	time				sys_time			sys_time32
 14	common	mknod				sys_mknod
 15	common	chmod				sys_chmod
 16	common	lchown				sys_lchown
@@ -36,14 +36,14 @@
 22	spu	umount				sys_ni_syscall
 23	common	setuid				sys_setuid
 24	common	getuid				sys_getuid
-25	common	stime				sys_stime			compat_sys_stime
+25	common	stime				sys_stime			sys_stime32
 26	nospu	ptrace				sys_ptrace			compat_sys_ptrace
 27	common	alarm				sys_alarm
 28	32	oldfstat			sys_fstat			sys_ni_syscall
 28	64	oldfstat			sys_ni_syscall
 28	spu	oldfstat			sys_ni_syscall
 29	nospu	pause				sys_pause
-30	nospu	utime				sys_utime			compat_sys_utime
+30	nospu	utime				sys_utime			sys_utime32
 31	common	stty				sys_ni_syscall
 32	common	gtty				sys_ni_syscall
 33	common	access				sys_access
@@ -157,7 +157,7 @@
 121	common	setdomainname			sys_setdomainname
 122	common	uname				sys_newuname
 123	common	modify_ldt			sys_ni_syscall
-124	common	adjtimex			sys_adjtimex			compat_sys_adjtimex
+124	common	adjtimex			sys_adjtimex			sys_adjtimex_time32
 125	common	mprotect			sys_mprotect
 126	32	sigprocmask			sys_sigprocmask			compat_sys_sigprocmask
 126	64	sigprocmask			sys_ni_syscall
@@ -198,8 +198,8 @@
 158	common	sched_yield			sys_sched_yield
 159	common	sched_get_priority_max		sys_sched_get_priority_max
 160	common	sched_get_priority_min		sys_sched_get_priority_min
-161	common	sched_rr_get_interval		sys_sched_rr_get_interval	compat_sys_sched_rr_get_interval
-162	common	nanosleep			sys_nanosleep			compat_sys_nanosleep
+161	common	sched_rr_get_interval		sys_sched_rr_get_interval	sys_sched_rr_get_interval_time32
+162	common	nanosleep			sys_nanosleep			sys_nanosleep_time32
 163	common	mremap				sys_mremap
 164	common	setresuid			sys_setresuid
 165	common	getresuid			sys_getresuid
@@ -213,7 +213,7 @@
 173	nospu	rt_sigaction			sys_rt_sigaction		compat_sys_rt_sigaction
 174	nospu	rt_sigprocmask			sys_rt_sigprocmask		compat_sys_rt_sigprocmask
 175	nospu	rt_sigpending			sys_rt_sigpending		compat_sys_rt_sigpending
-176	nospu	rt_sigtimedwait			sys_rt_sigtimedwait		compat_sys_rt_sigtimedwait
+176	nospu	rt_sigtimedwait			sys_rt_sigtimedwait		compat_sys_rt_sigtimedwait_time32
 177	nospu 	rt_sigqueueinfo			sys_rt_sigqueueinfo		compat_sys_rt_sigqueueinfo
 178	nospu 	rt_sigsuspend			sys_rt_sigsuspend		compat_sys_rt_sigsuspend
 179	common	pread64				sys_pread64			compat_sys_pread64
@@ -260,7 +260,7 @@
 218	common	removexattr			sys_removexattr
 219	common	lremovexattr			sys_lremovexattr
 220	common	fremovexattr			sys_fremovexattr
-221	common	futex				sys_futex			compat_sys_futex
+221	common	futex				sys_futex			sys_futex_time32
 222	common	sched_setaffinity		sys_sched_setaffinity		compat_sys_sched_setaffinity
 223	common	sched_getaffinity		sys_sched_getaffinity		compat_sys_sched_getaffinity
 # 224 unused
@@ -268,7 +268,7 @@
 226	32	sendfile64			sys_sendfile64			compat_sys_sendfile64
 227	common	io_setup			sys_io_setup			compat_sys_io_setup
 228	common	io_destroy			sys_io_destroy
-229	common	io_getevents			sys_io_getevents		compat_sys_io_getevents
+229	common	io_getevents			sys_io_getevents		sys_io_getevents_time32
 230	common	io_submit			sys_io_submit			compat_sys_io_submit
 231	common	io_cancel			sys_io_cancel
 232	nospu	set_tid_address			sys_set_tid_address
@@ -280,19 +280,19 @@
 238	common	epoll_wait			sys_epoll_wait
 239	common	remap_file_pages		sys_remap_file_pages
 240	common	timer_create			sys_timer_create		compat_sys_timer_create
-241	common	timer_settime			sys_timer_settime		compat_sys_timer_settime
-242	common	timer_gettime			sys_timer_gettime		compat_sys_timer_gettime
+241	common	timer_settime			sys_timer_settime		sys_timer_settime32
+242	common	timer_gettime			sys_timer_gettime		sys_timer_gettime32
 243	common	timer_getoverrun		sys_timer_getoverrun
 244	common	timer_delete			sys_timer_delete
-245	common	clock_settime			sys_clock_settime		compat_sys_clock_settime
-246	common	clock_gettime			sys_clock_gettime		compat_sys_clock_gettime
-247	common	clock_getres			sys_clock_getres		compat_sys_clock_getres
-248	common	clock_nanosleep			sys_clock_nanosleep		compat_sys_clock_nanosleep
+245	common	clock_settime			sys_clock_settime		sys_clock_settime32
+246	common	clock_gettime			sys_clock_gettime		sys_clock_gettime32
+247	common	clock_getres			sys_clock_getres		sys_clock_getres_time32
+248	common	clock_nanosleep			sys_clock_nanosleep		sys_clock_nanosleep_time32
 249	32	swapcontext			ppc_swapcontext			ppc32_swapcontext
 249	64	swapcontext			ppc64_swapcontext
 249	spu	swapcontext			sys_ni_syscall
 250	common	tgkill				sys_tgkill
-251	common	utimes				sys_utimes			compat_sys_utimes
+251	common	utimes				sys_utimes			sys_utimes_time32
 252	common	statfs64			sys_statfs64			compat_sys_statfs64
 253	common	fstatfs64			sys_fstatfs64			compat_sys_fstatfs64
 254	32	fadvise64_64			ppc_fadvise64_64
@@ -308,8 +308,8 @@
 261	nospu	set_mempolicy			sys_set_mempolicy		compat_sys_set_mempolicy
 262	nospu	mq_open				sys_mq_open			compat_sys_mq_open
 263	nospu	mq_unlink			sys_mq_unlink
-264	nospu	mq_timedsend			sys_mq_timedsend		compat_sys_mq_timedsend
-265	nospu	mq_timedreceive			sys_mq_timedreceive		compat_sys_mq_timedreceive
+264	nospu	mq_timedsend			sys_mq_timedsend		sys_mq_timedsend_time32
+265	nospu	mq_timedreceive			sys_mq_timedreceive		sys_mq_timedreceive_time32
 266	nospu	mq_notify			sys_mq_notify			compat_sys_mq_notify
 267	nospu	mq_getsetattr			sys_mq_getsetattr		compat_sys_mq_getsetattr
 268	nospu	kexec_load			sys_kexec_load			compat_sys_kexec_load
@@ -324,8 +324,8 @@
 277	nospu	inotify_rm_watch		sys_inotify_rm_watch
 278	nospu	spu_run				sys_spu_run
 279	nospu	spu_create			sys_spu_create
-280	nospu	pselect6			sys_pselect6			compat_sys_pselect6
-281	nospu	ppoll				sys_ppoll			compat_sys_ppoll
+280	nospu	pselect6			sys_pselect6			compat_sys_pselect6_time32
+281	nospu	ppoll				sys_ppoll			compat_sys_ppoll_time32
 282	common	unshare				sys_unshare
 283	common	splice				sys_splice
 284	common	tee				sys_tee
@@ -334,7 +334,7 @@
 287	common	mkdirat				sys_mkdirat
 288	common	mknodat				sys_mknodat
 289	common	fchownat			sys_fchownat
-290	common	futimesat			sys_futimesat			compat_sys_futimesat
+290	common	futimesat			sys_futimesat			sys_futimesat_time32
 291	32	fstatat64			sys_fstatat64
 291	64	newfstatat			sys_newfstatat
 291	spu	newfstatat			sys_newfstatat
@@ -350,15 +350,15 @@
 301	common	move_pages			sys_move_pages			compat_sys_move_pages
 302	common	getcpu				sys_getcpu
 303	nospu	epoll_pwait			sys_epoll_pwait			compat_sys_epoll_pwait
-304	common	utimensat			sys_utimensat			compat_sys_utimensat
+304	common	utimensat			sys_utimensat			sys_utimensat_time32
 305	common	signalfd			sys_signalfd			compat_sys_signalfd
 306	common	timerfd_create			sys_timerfd_create
 307	common	eventfd				sys_eventfd
 308	common	sync_file_range2		sys_sync_file_range2		compat_sys_sync_file_range2
 309	nospu	fallocate			sys_fallocate			compat_sys_fallocate
 310	nospu	subpage_prot			sys_subpage_prot
-311	common	timerfd_settime			sys_timerfd_settime		compat_sys_timerfd_settime
-312	common	timerfd_gettime			sys_timerfd_gettime		compat_sys_timerfd_gettime
+311	common	timerfd_settime			sys_timerfd_settime		sys_timerfd_settime32
+312	common	timerfd_gettime			sys_timerfd_gettime		sys_timerfd_gettime32
 313	common	signalfd4			sys_signalfd4			compat_sys_signalfd4
 314	common	eventfd2			sys_eventfd2
 315	common	epoll_create1			sys_epoll_create1
@@ -389,11 +389,11 @@
 340	common	getsockopt			sys_getsockopt			compat_sys_getsockopt
 341	common	sendmsg				sys_sendmsg			compat_sys_sendmsg
 342	common	recvmsg				sys_recvmsg			compat_sys_recvmsg
-343	common	recvmmsg			sys_recvmmsg			compat_sys_recvmmsg
+343	common	recvmmsg			sys_recvmmsg			compat_sys_recvmmsg_time32
 344	common	accept4				sys_accept4
 345	common	name_to_handle_at		sys_name_to_handle_at
 346	common	open_by_handle_at		sys_open_by_handle_at		compat_sys_open_by_handle_at
-347	common	clock_adjtime			sys_clock_adjtime		compat_sys_clock_adjtime
+347	common	clock_adjtime			sys_clock_adjtime		sys_clock_adjtime32
 348	common	syncfs				sys_syncfs
 349	common	sendmmsg			sys_sendmmsg			compat_sys_sendmmsg
 350	common	setns				sys_setns
diff --git a/arch/s390/kernel/syscalls/syscall.tbl b/arch/s390/kernel/syscalls/syscall.tbl
index 14142eb21f8f..deeffeb740db 100644
--- a/arch/s390/kernel/syscalls/syscall.tbl
+++ b/arch/s390/kernel/syscalls/syscall.tbl
@@ -20,7 +20,7 @@
 10   common	unlink			sys_unlink			sys_unlink
 11   common	execve			sys_execve			compat_sys_execve
 12   common	chdir			sys_chdir			sys_chdir
-13   32		time			-				compat_sys_time
+13   32		time			-				sys_time32
 14   common	mknod			sys_mknod			sys_mknod
 15   common	chmod			sys_chmod			sys_chmod
 16   32		lchown			-				sys_lchown16
@@ -30,11 +30,11 @@
 22   common	umount			sys_oldumount			sys_oldumount
 23   32		setuid			-				sys_setuid16
 24   32		getuid			-				sys_getuid16
-25   32		stime			-				compat_sys_stime
+25   32		stime			-				sys_stime32
 26   common	ptrace			sys_ptrace			compat_sys_ptrace
 27   common	alarm			sys_alarm			sys_alarm
 29   common	pause			sys_pause			sys_pause
-30   common	utime			sys_utime			compat_sys_utime
+30   common	utime			sys_utime			sys_utime32
 33   common	access			sys_access			sys_access
 34   common	nice			sys_nice			sys_nice
 36   common	sync			sys_sync			sys_sync
@@ -112,7 +112,7 @@
 120  common	clone			sys_clone			sys_clone
 121  common	setdomainname		sys_setdomainname		sys_setdomainname
 122  common	uname			sys_newuname			sys_newuname
-124  common	adjtimex		sys_adjtimex			compat_sys_adjtimex
+124  common	adjtimex		sys_adjtimex			sys_adjtimex_time32
 125  common	mprotect		sys_mprotect			sys_mprotect
 126  common	sigprocmask		sys_sigprocmask			compat_sys_sigprocmask
 127  common	create_module		-				-
@@ -150,8 +150,8 @@
 158  common	sched_yield		sys_sched_yield			sys_sched_yield
 159  common	sched_get_priority_max	sys_sched_get_priority_max	sys_sched_get_priority_max
 160  common	sched_get_priority_min	sys_sched_get_priority_min	sys_sched_get_priority_min
-161  common	sched_rr_get_interval	sys_sched_rr_get_interval	compat_sys_sched_rr_get_interval
-162  common	nanosleep		sys_nanosleep			compat_sys_nanosleep
+161  common	sched_rr_get_interval	sys_sched_rr_get_interval	sys_sched_rr_get_interval_time32
+162  common	nanosleep		sys_nanosleep			sys_nanosleep_time32
 163  common	mremap			sys_mremap			sys_mremap
 164  32		setresuid		-				sys_setresuid16
 165  32		getresuid		-				sys_getresuid16
@@ -165,7 +165,7 @@
 174  common	rt_sigaction		sys_rt_sigaction		compat_sys_rt_sigaction
 175  common	rt_sigprocmask		sys_rt_sigprocmask		compat_sys_rt_sigprocmask
 176  common	rt_sigpending		sys_rt_sigpending		compat_sys_rt_sigpending
-177  common	rt_sigtimedwait		sys_rt_sigtimedwait		compat_sys_rt_sigtimedwait
+177  common	rt_sigtimedwait		sys_rt_sigtimedwait		compat_sys_rt_sigtimedwait_time32
 178  common	rt_sigqueueinfo		sys_rt_sigqueueinfo		compat_sys_rt_sigqueueinfo
 179  common	rt_sigsuspend		sys_rt_sigsuspend		compat_sys_rt_sigsuspend
 180  common	pread64			sys_pread64			compat_sys_s390_pread64
@@ -246,13 +246,13 @@
 235  common	fremovexattr		sys_fremovexattr		sys_fremovexattr
 236  common	gettid			sys_gettid			sys_gettid
 237  common	tkill			sys_tkill			sys_tkill
-238  common	futex			sys_futex			compat_sys_futex
+238  common	futex			sys_futex			sys_futex_time32
 239  common	sched_setaffinity	sys_sched_setaffinity		compat_sys_sched_setaffinity
 240  common	sched_getaffinity	sys_sched_getaffinity		compat_sys_sched_getaffinity
 241  common	tgkill			sys_tgkill			sys_tgkill
 243  common	io_setup		sys_io_setup			compat_sys_io_setup
 244  common	io_destroy		sys_io_destroy			sys_io_destroy
-245  common	io_getevents		sys_io_getevents		compat_sys_io_getevents
+245  common	io_getevents		sys_io_getevents		sys_io_getevents_time32
 246  common	io_submit		sys_io_submit			compat_sys_io_submit
 247  common	io_cancel		sys_io_cancel			sys_io_cancel
 248  common	exit_group		sys_exit_group			sys_exit_group
@@ -262,14 +262,14 @@
 252  common	set_tid_address		sys_set_tid_address		sys_set_tid_address
 253  common	fadvise64		sys_fadvise64_64		compat_sys_s390_fadvise64
 254  common	timer_create		sys_timer_create		compat_sys_timer_create
-255  common	timer_settime		sys_timer_settime		compat_sys_timer_settime
-256  common	timer_gettime		sys_timer_gettime		compat_sys_timer_gettime
+255  common	timer_settime		sys_timer_settime		sys_timer_settime32
+256  common	timer_gettime		sys_timer_gettime		sys_timer_gettime32
 257  common	timer_getoverrun	sys_timer_getoverrun		sys_timer_getoverrun
 258  common	timer_delete		sys_timer_delete		sys_timer_delete
-259  common	clock_settime		sys_clock_settime		compat_sys_clock_settime
-260  common	clock_gettime		sys_clock_gettime		compat_sys_clock_gettime
-261  common	clock_getres		sys_clock_getres		compat_sys_clock_getres
-262  common	clock_nanosleep		sys_clock_nanosleep		compat_sys_clock_nanosleep
+259  common	clock_settime		sys_clock_settime		sys_clock_settime32
+260  common	clock_gettime		sys_clock_gettime		sys_clock_gettime32
+261  common	clock_getres		sys_clock_getres		sys_clock_getres_time32
+262  common	clock_nanosleep		sys_clock_nanosleep		sys_clock_nanosleep_time32
 264  32		fadvise64_64		-				compat_sys_s390_fadvise64_64
 265  common	statfs64		sys_statfs64			compat_sys_statfs64
 266  common	fstatfs64		sys_fstatfs64			compat_sys_fstatfs64
@@ -279,8 +279,8 @@
 270  common	set_mempolicy		sys_set_mempolicy		compat_sys_set_mempolicy
 271  common	mq_open			sys_mq_open			compat_sys_mq_open
 272  common	mq_unlink		sys_mq_unlink			sys_mq_unlink
-273  common	mq_timedsend		sys_mq_timedsend		compat_sys_mq_timedsend
-274  common	mq_timedreceive		sys_mq_timedreceive		compat_sys_mq_timedreceive
+273  common	mq_timedsend		sys_mq_timedsend		sys_mq_timedsend_time32
+274  common	mq_timedreceive		sys_mq_timedreceive		sys_mq_timedreceive_time32
 275  common	mq_notify		sys_mq_notify			compat_sys_mq_notify
 276  common	mq_getsetattr		sys_mq_getsetattr		compat_sys_mq_getsetattr
 277  common	kexec_load		sys_kexec_load			compat_sys_kexec_load
@@ -298,7 +298,7 @@
 289  common	mkdirat			sys_mkdirat			sys_mkdirat
 290  common	mknodat			sys_mknodat			sys_mknodat
 291  common	fchownat		sys_fchownat			sys_fchownat
-292  common	futimesat		sys_futimesat			compat_sys_futimesat
+292  common	futimesat		sys_futimesat			sys_futimesat_time32
 293  32		fstatat64		-				compat_sys_s390_fstatat64
 293  64		newfstatat		sys_newfstatat			-
 294  common	unlinkat		sys_unlinkat			sys_unlinkat
@@ -308,8 +308,8 @@
 298  common	readlinkat		sys_readlinkat			sys_readlinkat
 299  common	fchmodat		sys_fchmodat			sys_fchmodat
 300  common	faccessat		sys_faccessat			sys_faccessat
-301  common	pselect6		sys_pselect6			compat_sys_pselect6
-302  common	ppoll			sys_ppoll			compat_sys_ppoll
+301  common	pselect6		sys_pselect6			compat_sys_pselect6_time32
+302  common	ppoll			sys_ppoll			compat_sys_ppoll_time32
 303  common	unshare			sys_unshare			sys_unshare
 304  common	set_robust_list		sys_set_robust_list		compat_sys_set_robust_list
 305  common	get_robust_list		sys_get_robust_list		compat_sys_get_robust_list
@@ -320,15 +320,15 @@
 310  common	move_pages		sys_move_pages			compat_sys_move_pages
 311  common	getcpu			sys_getcpu			sys_getcpu
 312  common	epoll_pwait		sys_epoll_pwait			compat_sys_epoll_pwait
-313  common	utimes			sys_utimes			compat_sys_utimes
+313  common	utimes			sys_utimes			sys_utimes_time32
 314  common	fallocate		sys_fallocate			compat_sys_s390_fallocate
-315  common	utimensat		sys_utimensat			compat_sys_utimensat
+315  common	utimensat		sys_utimensat			sys_utimensat_time32
 316  common	signalfd		sys_signalfd			compat_sys_signalfd
 317  common	timerfd			-				-
 318  common	eventfd			sys_eventfd			sys_eventfd
 319  common	timerfd_create		sys_timerfd_create		sys_timerfd_create
-320  common	timerfd_settime		sys_timerfd_settime		compat_sys_timerfd_settime
-321  common	timerfd_gettime		sys_timerfd_gettime		compat_sys_timerfd_gettime
+320  common	timerfd_settime		sys_timerfd_settime		sys_timerfd_settime32
+321  common	timerfd_gettime		sys_timerfd_gettime		sys_timerfd_gettime32
 322  common	signalfd4		sys_signalfd4			compat_sys_signalfd4
 323  common	eventfd2		sys_eventfd2			sys_eventfd2
 324  common	inotify_init1		sys_inotify_init1		sys_inotify_init1
@@ -344,7 +344,7 @@
 334  common	prlimit64		sys_prlimit64			sys_prlimit64
 335  common	name_to_handle_at	sys_name_to_handle_at		sys_name_to_handle_at
 336  common	open_by_handle_at	sys_open_by_handle_at		compat_sys_open_by_handle_at
-337  common	clock_adjtime		sys_clock_adjtime		compat_sys_clock_adjtime
+337  common	clock_adjtime		sys_clock_adjtime		sys_clock_adjtime32
 338  common	syncfs			sys_syncfs			sys_syncfs
 339  common	setns			sys_setns			sys_setns
 340  common	process_vm_readv	sys_process_vm_readv		compat_sys_process_vm_readv
@@ -364,7 +364,7 @@
 354  common	execveat		sys_execveat			compat_sys_execveat
 355  common	userfaultfd		sys_userfaultfd			sys_userfaultfd
 356  common	membarrier		sys_membarrier			sys_membarrier
-357  common	recvmmsg		sys_recvmmsg			compat_sys_recvmmsg
+357  common	recvmmsg		sys_recvmmsg			compat_sys_recvmmsg_time32
 358  common	sendmmsg		sys_sendmmsg			compat_sys_sendmmsg
 359  common	socket			sys_socket			sys_socket
 360  common	socketpair		sys_socketpair			sys_socketpair
diff --git a/arch/sparc/kernel/syscalls/syscall.tbl b/arch/sparc/kernel/syscalls/syscall.tbl
index e70110375399..45ff53ee8e54 100644
--- a/arch/sparc/kernel/syscalls/syscall.tbl
+++ b/arch/sparc/kernel/syscalls/syscall.tbl
@@ -44,7 +44,7 @@
 28	common	sigaltstack		sys_sigaltstack			compat_sys_sigaltstack
 29	32    	pause			sys_pause
 29	64    	pause			sys_nis_syscall
-30	common	utime			sys_utime			compat_sys_utime
+30	common	utime			sys_utime			sys_utime32
 31	32    	lchown32		sys_lchown
 32	32    	fchown32		sys_fchown
 33	common	access			sys_access
@@ -128,7 +128,7 @@
 102	common	rt_sigaction		sys_rt_sigaction		compat_sys_rt_sigaction
 103	common	rt_sigprocmask		sys_rt_sigprocmask		compat_sys_rt_sigprocmask
 104	common	rt_sigpending		sys_rt_sigpending		compat_sys_rt_sigpending
-105	common	rt_sigtimedwait		sys_rt_sigtimedwait		compat_sys_rt_sigtimedwait
+105	common	rt_sigtimedwait		sys_rt_sigtimedwait		compat_sys_rt_sigtimedwait_time32
 106	common	rt_sigqueueinfo		sys_rt_sigqueueinfo		compat_sys_rt_sigqueueinfo
 107	common	rt_sigsuspend		sys_rt_sigsuspend		compat_sys_rt_sigsuspend
 108	32	setresuid32		sys_setresuid
@@ -168,11 +168,11 @@
 135	common	socketpair		sys_socketpair
 136	common	mkdir			sys_mkdir
 137	common	rmdir			sys_rmdir
-138	common	utimes			sys_utimes			compat_sys_utimes
+138	common	utimes			sys_utimes			sys_utimes_time32
 139	common	stat64			sys_stat64			compat_sys_stat64
 140	common	sendfile64		sys_sendfile64
 141	common	getpeername		sys_getpeername
-142	common	futex			sys_futex			compat_sys_futex
+142	common	futex			sys_futex			sys_futex_time32
 143	common	gettid			sys_gettid
 144	common	getrlimit		sys_getrlimit			compat_sys_getrlimit
 145	common	setrlimit		sys_setrlimit			compat_sys_setrlimit
@@ -258,7 +258,7 @@
 216	64	sigreturn		sys_nis_syscall
 217	common	clone			sys_clone
 218	common	ioprio_get		sys_ioprio_get
-219	32	adjtimex		sys_adjtimex			compat_sys_adjtimex
+219	32	adjtimex		sys_adjtimex			sys_adjtimex_time32
 219	64	adjtimex		sys_sparc_adjtimex
 220	32	sigprocmask		sys_sigprocmask			compat_sys_sigprocmask
 220	64	sigprocmask		sys_nis_syscall
@@ -272,9 +272,9 @@
 228	common	setfsuid		sys_setfsuid16
 229	common	setfsgid		sys_setfsgid16
 230	common	_newselect		sys_select			compat_sys_select
-231	32	time			sys_time			compat_sys_time
+231	32	time			sys_time			sys_time32
 232	common	splice			sys_splice
-233	common	stime			sys_stime			compat_sys_stime
+233	common	stime			sys_stime			sys_stime32
 234	common	statfs64		sys_statfs64			compat_sys_statfs64
 235	common	fstatfs64		sys_fstatfs64			compat_sys_fstatfs64
 236	common	_llseek			sys_llseek
@@ -289,8 +289,8 @@
 245	common	sched_yield		sys_sched_yield
 246	common	sched_get_priority_max	sys_sched_get_priority_max
 247	common	sched_get_priority_min	sys_sched_get_priority_min
-248	common	sched_rr_get_interval	sys_sched_rr_get_interval	compat_sys_sched_rr_get_interval
-249	common	nanosleep		sys_nanosleep			compat_sys_nanosleep
+248	common	sched_rr_get_interval	sys_sched_rr_get_interval	sys_sched_rr_get_interval_time32
+249	common	nanosleep		sys_nanosleep			sys_nanosleep_time32
 250	32	mremap			sys_mremap
 250	64	mremap			sys_64_mremap
 251	common	_sysctl			sys_sysctl			compat_sys_sysctl
@@ -299,14 +299,14 @@
 254	32	nfsservctl		sys_ni_syscall			sys_nis_syscall
 254	64	nfsservctl		sys_nis_syscall
 255	common	sync_file_range		sys_sync_file_range		compat_sys_sync_file_range
-256	common	clock_settime		sys_clock_settime		compat_sys_clock_settime
-257	common	clock_gettime		sys_clock_gettime		compat_sys_clock_gettime
-258	common	clock_getres		sys_clock_getres		compat_sys_clock_getres
-259	common	clock_nanosleep		sys_clock_nanosleep		compat_sys_clock_nanosleep
+256	common	clock_settime		sys_clock_settime		sys_clock_settime32
+257	common	clock_gettime		sys_clock_gettime		sys_clock_gettime32
+258	common	clock_getres		sys_clock_getres		sys_clock_getres_time32
+259	common	clock_nanosleep		sys_clock_nanosleep		sys_clock_nanosleep_time32
 260	common	sched_getaffinity	sys_sched_getaffinity		compat_sys_sched_getaffinity
 261	common	sched_setaffinity	sys_sched_setaffinity		compat_sys_sched_setaffinity
-262	common	timer_settime		sys_timer_settime		compat_sys_timer_settime
-263	common	timer_gettime		sys_timer_gettime		compat_sys_timer_gettime
+262	common	timer_settime		sys_timer_settime		sys_timer_settime32
+263	common	timer_gettime		sys_timer_gettime		sys_timer_gettime32
 264	common	timer_getoverrun	sys_timer_getoverrun
 265	common	timer_delete		sys_timer_delete
 266	common	timer_create		sys_timer_create		compat_sys_timer_create
@@ -316,11 +316,11 @@
 269	common	io_destroy		sys_io_destroy
 270	common	io_submit		sys_io_submit			compat_sys_io_submit
 271	common	io_cancel		sys_io_cancel
-272	common	io_getevents		sys_io_getevents		compat_sys_io_getevents
+272	common	io_getevents		sys_io_getevents		sys_io_getevents_time32
 273	common	mq_open			sys_mq_open			compat_sys_mq_open
 274	common	mq_unlink		sys_mq_unlink
-275	common	mq_timedsend		sys_mq_timedsend		compat_sys_mq_timedsend
-276	common	mq_timedreceive		sys_mq_timedreceive		compat_sys_mq_timedreceive
+275	common	mq_timedsend		sys_mq_timedsend		sys_mq_timedsend_time32
+276	common	mq_timedreceive		sys_mq_timedreceive		sys_mq_timedreceive_time32
 277	common	mq_notify		sys_mq_notify			compat_sys_mq_notify
 278	common	mq_getsetattr		sys_mq_getsetattr		compat_sys_mq_getsetattr
 279	common	waitid			sys_waitid			compat_sys_waitid
@@ -332,7 +332,7 @@
 285	common	mkdirat			sys_mkdirat
 286	common	mknodat			sys_mknodat
 287	common	fchownat		sys_fchownat
-288	common	futimesat		sys_futimesat			compat_sys_futimesat
+288	common	futimesat		sys_futimesat			sys_futimesat_time32
 289	common	fstatat64		sys_fstatat64			compat_sys_fstatat64
 290	common	unlinkat		sys_unlinkat
 291	common	renameat		sys_renameat
@@ -341,8 +341,8 @@
 294	common	readlinkat		sys_readlinkat
 295	common	fchmodat		sys_fchmodat
 296	common	faccessat		sys_faccessat
-297	common	pselect6		sys_pselect6			compat_sys_pselect6
-298	common	ppoll			sys_ppoll			compat_sys_ppoll
+297	common	pselect6		sys_pselect6			compat_sys_pselect6_time32
+298	common	ppoll			sys_ppoll			compat_sys_ppoll_time32
 299	common	unshare			sys_unshare
 300	common	set_robust_list		sys_set_robust_list		compat_sys_set_robust_list
 301	common	get_robust_list		sys_get_robust_list		compat_sys_get_robust_list
@@ -354,13 +354,13 @@
 307	common	move_pages		sys_move_pages			compat_sys_move_pages
 308	common	getcpu			sys_getcpu
 309	common	epoll_pwait		sys_epoll_pwait			compat_sys_epoll_pwait
-310	common	utimensat		sys_utimensat			compat_sys_utimensat
+310	common	utimensat		sys_utimensat			sys_utimensat_time32
 311	common	signalfd		sys_signalfd			compat_sys_signalfd
 312	common	timerfd_create		sys_timerfd_create
 313	common	eventfd			sys_eventfd
 314	common	fallocate		sys_fallocate			compat_sys_fallocate
-315	common	timerfd_settime		sys_timerfd_settime		compat_sys_timerfd_settime
-316	common	timerfd_gettime		sys_timerfd_gettime		compat_sys_timerfd_gettime
+315	common	timerfd_settime		sys_timerfd_settime		sys_timerfd_settime32
+316	common	timerfd_gettime		sys_timerfd_gettime		sys_timerfd_gettime32
 317	common	signalfd4		sys_signalfd4			compat_sys_signalfd4
 318	common	eventfd2		sys_eventfd2
 319	common	epoll_create1		sys_epoll_create1
@@ -372,13 +372,13 @@
 325	common	pwritev			sys_pwritev			compat_sys_pwritev
 326	common	rt_tgsigqueueinfo	sys_rt_tgsigqueueinfo		compat_sys_rt_tgsigqueueinfo
 327	common	perf_event_open		sys_perf_event_open
-328	common	recvmmsg		sys_recvmmsg			compat_sys_recvmmsg
+328	common	recvmmsg		sys_recvmmsg			compat_sys_recvmmsg_time32
 329	common	fanotify_init		sys_fanotify_init
 330	common	fanotify_mark		sys_fanotify_mark		compat_sys_fanotify_mark
 331	common	prlimit64		sys_prlimit64
 332	common	name_to_handle_at	sys_name_to_handle_at
 333	common	open_by_handle_at	sys_open_by_handle_at		compat_sys_open_by_handle_at
-334	32	clock_adjtime		sys_clock_adjtime		compat_sys_clock_adjtime
+334	32	clock_adjtime		sys_clock_adjtime		sys_clock_adjtime32
 334	64	clock_adjtime		sys_sparc_clock_adjtime
 335	common	syncfs			sys_syncfs
 336	common	sendmmsg		sys_sendmmsg			compat_sys_sendmmsg
diff --git a/arch/x86/entry/syscalls/syscall_32.tbl b/arch/x86/entry/syscalls/syscall_32.tbl
index fef80b92eb7e..b2f92f75948d 100644
--- a/arch/x86/entry/syscalls/syscall_32.tbl
+++ b/arch/x86/entry/syscalls/syscall_32.tbl
@@ -24,7 +24,7 @@
 10	i386	unlink			sys_unlink			__ia32_sys_unlink
 11	i386	execve			sys_execve			__ia32_compat_sys_execve
 12	i386	chdir			sys_chdir			__ia32_sys_chdir
-13	i386	time			sys_time			__ia32_compat_sys_time
+13	i386	time			sys_time			__ia32_sys_time32
 14	i386	mknod			sys_mknod			__ia32_sys_mknod
 15	i386	chmod			sys_chmod			__ia32_sys_chmod
 16	i386	lchown			sys_lchown16			__ia32_sys_lchown16
@@ -36,12 +36,12 @@
 22	i386	umount			sys_oldumount			__ia32_sys_oldumount
 23	i386	setuid			sys_setuid16			__ia32_sys_setuid16
 24	i386	getuid			sys_getuid16			__ia32_sys_getuid16
-25	i386	stime			sys_stime			__ia32_compat_sys_stime
+25	i386	stime			sys_stime			__ia32_sys_stime32
 26	i386	ptrace			sys_ptrace			__ia32_compat_sys_ptrace
 27	i386	alarm			sys_alarm			__ia32_sys_alarm
 28	i386	oldfstat		sys_fstat			__ia32_sys_fstat
 29	i386	pause			sys_pause			__ia32_sys_pause
-30	i386	utime			sys_utime			__ia32_compat_sys_utime
+30	i386	utime			sys_utime			__ia32_sys_utime32
 31	i386	stty
 32	i386	gtty
 33	i386	access			sys_access			__ia32_sys_access
@@ -135,7 +135,7 @@
 121	i386	setdomainname		sys_setdomainname		__ia32_sys_setdomainname
 122	i386	uname			sys_newuname			__ia32_sys_newuname
 123	i386	modify_ldt		sys_modify_ldt			__ia32_sys_modify_ldt
-124	i386	adjtimex		sys_adjtimex			__ia32_compat_sys_adjtimex
+124	i386	adjtimex		sys_adjtimex			__ia32_sys_adjtimex_time32
 125	i386	mprotect		sys_mprotect			__ia32_sys_mprotect
 126	i386	sigprocmask		sys_sigprocmask			__ia32_compat_sys_sigprocmask
 127	i386	create_module
@@ -172,8 +172,8 @@
 158	i386	sched_yield		sys_sched_yield			__ia32_sys_sched_yield
 159	i386	sched_get_priority_max	sys_sched_get_priority_max	__ia32_sys_sched_get_priority_max
 160	i386	sched_get_priority_min	sys_sched_get_priority_min	__ia32_sys_sched_get_priority_min
-161	i386	sched_rr_get_interval	sys_sched_rr_get_interval	__ia32_compat_sys_sched_rr_get_interval
-162	i386	nanosleep		sys_nanosleep			__ia32_compat_sys_nanosleep
+161	i386	sched_rr_get_interval	sys_sched_rr_get_interval	__ia32_sys_sched_rr_get_interval_time32
+162	i386	nanosleep		sys_nanosleep			__ia32_sys_nanosleep_time32
 163	i386	mremap			sys_mremap			__ia32_sys_mremap
 164	i386	setresuid		sys_setresuid16			__ia32_sys_setresuid16
 165	i386	getresuid		sys_getresuid16			__ia32_sys_getresuid16
@@ -188,7 +188,7 @@
 174	i386	rt_sigaction		sys_rt_sigaction		__ia32_compat_sys_rt_sigaction
 175	i386	rt_sigprocmask		sys_rt_sigprocmask		__ia32_sys_rt_sigprocmask
 176	i386	rt_sigpending		sys_rt_sigpending		__ia32_compat_sys_rt_sigpending
-177	i386	rt_sigtimedwait		sys_rt_sigtimedwait		__ia32_compat_sys_rt_sigtimedwait
+177	i386	rt_sigtimedwait		sys_rt_sigtimedwait		__ia32_compat_sys_rt_sigtimedwait_time32
 178	i386	rt_sigqueueinfo		sys_rt_sigqueueinfo		__ia32_compat_sys_rt_sigqueueinfo
 179	i386	rt_sigsuspend		sys_rt_sigsuspend		__ia32_sys_rt_sigsuspend
 180	i386	pread64			sys_pread64			__ia32_compat_sys_x86_pread
@@ -251,14 +251,14 @@
 237	i386	fremovexattr		sys_fremovexattr		__ia32_sys_fremovexattr
 238	i386	tkill			sys_tkill			__ia32_sys_tkill
 239	i386	sendfile64		sys_sendfile64			__ia32_sys_sendfile64
-240	i386	futex			sys_futex			__ia32_compat_sys_futex
+240	i386	futex			sys_futex			__ia32_sys_futex_time32
 241	i386	sched_setaffinity	sys_sched_setaffinity		__ia32_compat_sys_sched_setaffinity
 242	i386	sched_getaffinity	sys_sched_getaffinity		__ia32_compat_sys_sched_getaffinity
 243	i386	set_thread_area		sys_set_thread_area		__ia32_sys_set_thread_area
 244	i386	get_thread_area		sys_get_thread_area		__ia32_sys_get_thread_area
 245	i386	io_setup		sys_io_setup			__ia32_compat_sys_io_setup
 246	i386	io_destroy		sys_io_destroy			__ia32_sys_io_destroy
-247	i386	io_getevents		sys_io_getevents		__ia32_compat_sys_io_getevents
+247	i386	io_getevents		sys_io_getevents		__ia32_sys_io_getevents_time32
 248	i386	io_submit		sys_io_submit			__ia32_compat_sys_io_submit
 249	i386	io_cancel		sys_io_cancel			__ia32_sys_io_cancel
 250	i386	fadvise64		sys_fadvise64			__ia32_compat_sys_x86_fadvise64
@@ -271,18 +271,18 @@
 257	i386	remap_file_pages	sys_remap_file_pages		__ia32_sys_remap_file_pages
 258	i386	set_tid_address		sys_set_tid_address		__ia32_sys_set_tid_address
 259	i386	timer_create		sys_timer_create		__ia32_compat_sys_timer_create
-260	i386	timer_settime		sys_timer_settime		__ia32_compat_sys_timer_settime
-261	i386	timer_gettime		sys_timer_gettime		__ia32_compat_sys_timer_gettime
+260	i386	timer_settime		sys_timer_settime		__ia32_sys_timer_settime32
+261	i386	timer_gettime		sys_timer_gettime		__ia32_sys_timer_gettime32
 262	i386	timer_getoverrun	sys_timer_getoverrun		__ia32_sys_timer_getoverrun
 263	i386	timer_delete		sys_timer_delete		__ia32_sys_timer_delete
-264	i386	clock_settime		sys_clock_settime		__ia32_compat_sys_clock_settime
-265	i386	clock_gettime		sys_clock_gettime		__ia32_compat_sys_clock_gettime
-266	i386	clock_getres		sys_clock_getres		__ia32_compat_sys_clock_getres
-267	i386	clock_nanosleep		sys_clock_nanosleep		__ia32_compat_sys_clock_nanosleep
+264	i386	clock_settime		sys_clock_settime		__ia32_sys_clock_settime32
+265	i386	clock_gettime		sys_clock_gettime		__ia32_sys_clock_gettime32
+266	i386	clock_getres		sys_clock_getres		__ia32_sys_clock_getres_time32
+267	i386	clock_nanosleep		sys_clock_nanosleep		__ia32_sys_clock_nanosleep_time32
 268	i386	statfs64		sys_statfs64			__ia32_compat_sys_statfs64
 269	i386	fstatfs64		sys_fstatfs64			__ia32_compat_sys_fstatfs64
 270	i386	tgkill			sys_tgkill			__ia32_sys_tgkill
-271	i386	utimes			sys_utimes			__ia32_compat_sys_utimes
+271	i386	utimes			sys_utimes			__ia32_sys_utimes_time32
 272	i386	fadvise64_64		sys_fadvise64_64		__ia32_compat_sys_x86_fadvise64_64
 273	i386	vserver
 274	i386	mbind			sys_mbind			__ia32_sys_mbind
@@ -290,8 +290,8 @@
 276	i386	set_mempolicy		sys_set_mempolicy		__ia32_sys_set_mempolicy
 277	i386	mq_open			sys_mq_open			__ia32_compat_sys_mq_open
 278	i386	mq_unlink		sys_mq_unlink			__ia32_sys_mq_unlink
-279	i386	mq_timedsend		sys_mq_timedsend		__ia32_compat_sys_mq_timedsend
-280	i386	mq_timedreceive		sys_mq_timedreceive		__ia32_compat_sys_mq_timedreceive
+279	i386	mq_timedsend		sys_mq_timedsend		__ia32_sys_mq_timedsend_time32
+280	i386	mq_timedreceive		sys_mq_timedreceive		__ia32_sys_mq_timedreceive_time32
 281	i386	mq_notify		sys_mq_notify			__ia32_compat_sys_mq_notify
 282	i386	mq_getsetattr		sys_mq_getsetattr		__ia32_compat_sys_mq_getsetattr
 283	i386	kexec_load		sys_kexec_load			__ia32_compat_sys_kexec_load
@@ -310,7 +310,7 @@
 296	i386	mkdirat			sys_mkdirat			__ia32_sys_mkdirat
 297	i386	mknodat			sys_mknodat			__ia32_sys_mknodat
 298	i386	fchownat		sys_fchownat			__ia32_sys_fchownat
-299	i386	futimesat		sys_futimesat			__ia32_compat_sys_futimesat
+299	i386	futimesat		sys_futimesat			__ia32_sys_futimesat_time32
 300	i386	fstatat64		sys_fstatat64			__ia32_compat_sys_x86_fstatat
 301	i386	unlinkat		sys_unlinkat			__ia32_sys_unlinkat
 302	i386	renameat		sys_renameat			__ia32_sys_renameat
@@ -319,8 +319,8 @@
 305	i386	readlinkat		sys_readlinkat			__ia32_sys_readlinkat
 306	i386	fchmodat		sys_fchmodat			__ia32_sys_fchmodat
 307	i386	faccessat		sys_faccessat			__ia32_sys_faccessat
-308	i386	pselect6		sys_pselect6			__ia32_compat_sys_pselect6
-309	i386	ppoll			sys_ppoll			__ia32_compat_sys_ppoll
+308	i386	pselect6		sys_pselect6			__ia32_compat_sys_pselect6_time32
+309	i386	ppoll			sys_ppoll			__ia32_compat_sys_ppoll_time32
 310	i386	unshare			sys_unshare			__ia32_sys_unshare
 311	i386	set_robust_list		sys_set_robust_list		__ia32_compat_sys_set_robust_list
 312	i386	get_robust_list		sys_get_robust_list		__ia32_compat_sys_get_robust_list
@@ -331,13 +331,13 @@
 317	i386	move_pages		sys_move_pages			__ia32_compat_sys_move_pages
 318	i386	getcpu			sys_getcpu			__ia32_sys_getcpu
 319	i386	epoll_pwait		sys_epoll_pwait			__ia32_sys_epoll_pwait
-320	i386	utimensat		sys_utimensat			__ia32_compat_sys_utimensat
+320	i386	utimensat		sys_utimensat			__ia32_sys_utimensat_time32
 321	i386	signalfd		sys_signalfd			__ia32_compat_sys_signalfd
 322	i386	timerfd_create		sys_timerfd_create		__ia32_sys_timerfd_create
 323	i386	eventfd			sys_eventfd			__ia32_sys_eventfd
 324	i386	fallocate		sys_fallocate			__ia32_compat_sys_x86_fallocate
-325	i386	timerfd_settime		sys_timerfd_settime		__ia32_compat_sys_timerfd_settime
-326	i386	timerfd_gettime		sys_timerfd_gettime		__ia32_compat_sys_timerfd_gettime
+325	i386	timerfd_settime		sys_timerfd_settime		__ia32_sys_timerfd_settime32
+326	i386	timerfd_gettime		sys_timerfd_gettime		__ia32_sys_timerfd_gettime32
 327	i386	signalfd4		sys_signalfd4			__ia32_compat_sys_signalfd4
 328	i386	eventfd2		sys_eventfd2			__ia32_sys_eventfd2
 329	i386	epoll_create1		sys_epoll_create1		__ia32_sys_epoll_create1
@@ -348,13 +348,13 @@
 334	i386	pwritev			sys_pwritev			__ia32_compat_sys_pwritev
 335	i386	rt_tgsigqueueinfo	sys_rt_tgsigqueueinfo		__ia32_compat_sys_rt_tgsigqueueinfo
 336	i386	perf_event_open		sys_perf_event_open		__ia32_sys_perf_event_open
-337	i386	recvmmsg		sys_recvmmsg			__ia32_compat_sys_recvmmsg
+337	i386	recvmmsg		sys_recvmmsg			__ia32_compat_sys_recvmmsg_time32
 338	i386	fanotify_init		sys_fanotify_init		__ia32_sys_fanotify_init
 339	i386	fanotify_mark		sys_fanotify_mark		__ia32_compat_sys_fanotify_mark
 340	i386	prlimit64		sys_prlimit64			__ia32_sys_prlimit64
 341	i386	name_to_handle_at	sys_name_to_handle_at		__ia32_sys_name_to_handle_at
 342	i386	open_by_handle_at	sys_open_by_handle_at		__ia32_compat_sys_open_by_handle_at
-343	i386	clock_adjtime		sys_clock_adjtime		__ia32_compat_sys_clock_adjtime
+343	i386	clock_adjtime		sys_clock_adjtime		__ia32_sys_clock_adjtime32
 344	i386	syncfs			sys_syncfs			__ia32_sys_syncfs
 345	i386	sendmmsg		sys_sendmmsg			__ia32_compat_sys_sendmmsg
 346	i386	setns			sys_setns			__ia32_sys_setns
diff --git a/fs/aio.c b/fs/aio.c
index b906ff70c90f..4394d3fe116a 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -2198,11 +2198,11 @@ SYSCALL_DEFINE6(io_pgetevents_time32,
 
 #if defined(CONFIG_COMPAT_32BIT_TIME)
 
-COMPAT_SYSCALL_DEFINE5(io_getevents, compat_aio_context_t, ctx_id,
-		       compat_long_t, min_nr,
-		       compat_long_t, nr,
-		       struct io_event __user *, events,
-		       struct old_timespec32 __user *, timeout)
+SYSCALL_DEFINE5(io_getevents_time32, __u32, ctx_id,
+		__s32, min_nr,
+		__s32, nr,
+		struct io_event __user *, events,
+		struct old_timespec32 __user *, timeout)
 {
 	struct timespec64 t;
 	int ret;
diff --git a/fs/select.c b/fs/select.c
index d0f35dbc0e8f..6cbc9ff56ba0 100644
--- a/fs/select.c
+++ b/fs/select.c
@@ -1379,7 +1379,7 @@ COMPAT_SYSCALL_DEFINE6(pselect6_time64, int, n, compat_ulong_t __user *, inp,
 
 #if defined(CONFIG_COMPAT_32BIT_TIME)
 
-COMPAT_SYSCALL_DEFINE6(pselect6, int, n, compat_ulong_t __user *, inp,
+COMPAT_SYSCALL_DEFINE6(pselect6_time32, int, n, compat_ulong_t __user *, inp,
 	compat_ulong_t __user *, outp, compat_ulong_t __user *, exp,
 	struct old_timespec32 __user *, tsp, void __user *, sig)
 {
@@ -1402,7 +1402,7 @@ COMPAT_SYSCALL_DEFINE6(pselect6, int, n, compat_ulong_t __user *, inp,
 #endif
 
 #if defined(CONFIG_COMPAT_32BIT_TIME)
-COMPAT_SYSCALL_DEFINE5(ppoll, struct pollfd __user *, ufds,
+COMPAT_SYSCALL_DEFINE5(ppoll_time32, struct pollfd __user *, ufds,
 	unsigned int,  nfds, struct old_timespec32 __user *, tsp,
 	const compat_sigset_t __user *, sigmask, compat_size_t, sigsetsize)
 {
diff --git a/fs/timerfd.c b/fs/timerfd.c
index 803ca070d42e..6a6fc8aa1de7 100644
--- a/fs/timerfd.c
+++ b/fs/timerfd.c
@@ -560,7 +560,7 @@ SYSCALL_DEFINE2(timerfd_gettime, int, ufd, struct __kernel_itimerspec __user *,
 }
 
 #ifdef CONFIG_COMPAT_32BIT_TIME
-COMPAT_SYSCALL_DEFINE4(timerfd_settime, int, ufd, int, flags,
+SYSCALL_DEFINE4(timerfd_settime32, int, ufd, int, flags,
 		const struct old_itimerspec32 __user *, utmr,
 		struct old_itimerspec32 __user *, otmr)
 {
@@ -577,7 +577,7 @@ COMPAT_SYSCALL_DEFINE4(timerfd_settime, int, ufd, int, flags,
 	return ret;
 }
 
-COMPAT_SYSCALL_DEFINE2(timerfd_gettime, int, ufd,
+SYSCALL_DEFINE2(timerfd_gettime32, int, ufd,
 		struct old_itimerspec32 __user *, otmr)
 {
 	struct itimerspec64 kotmr;
diff --git a/fs/utimes.c b/fs/utimes.c
index bdcf2daf39c1..350c9c16ace1 100644
--- a/fs/utimes.c
+++ b/fs/utimes.c
@@ -224,8 +224,8 @@ SYSCALL_DEFINE2(utime, char __user *, filename, struct utimbuf __user *, times)
  * of sys_utimes.
  */
 #ifdef __ARCH_WANT_SYS_UTIME32
-COMPAT_SYSCALL_DEFINE2(utime, const char __user *, filename,
-		       struct old_utimbuf32 __user *, t)
+SYSCALL_DEFINE2(utime32, const char __user *, filename,
+		struct old_utimbuf32 __user *, t)
 {
 	struct timespec64 tv[2];
 
@@ -240,7 +240,7 @@ COMPAT_SYSCALL_DEFINE2(utime, const char __user *, filename,
 }
 #endif
 
-COMPAT_SYSCALL_DEFINE4(utimensat, unsigned int, dfd, const char __user *, filename, struct old_timespec32 __user *, t, int, flags)
+SYSCALL_DEFINE4(utimensat_time32, unsigned int, dfd, const char __user *, filename, struct old_timespec32 __user *, t, int, flags)
 {
 	struct timespec64 tv[2];
 
@@ -276,14 +276,14 @@ static long do_compat_futimesat(unsigned int dfd, const char __user *filename,
 	return do_utimes(dfd, filename, t ? tv : NULL, 0);
 }
 
-COMPAT_SYSCALL_DEFINE3(futimesat, unsigned int, dfd,
+SYSCALL_DEFINE3(futimesat_time32, unsigned int, dfd,
 		       const char __user *, filename,
 		       struct old_timeval32 __user *, t)
 {
 	return do_compat_futimesat(dfd, filename, t);
 }
 
-COMPAT_SYSCALL_DEFINE2(utimes, const char __user *, filename, struct old_timeval32 __user *, t)
+SYSCALL_DEFINE2(utimes_time32, const char __user *, filename, struct old_timeval32 __user *, t)
 {
 	return do_compat_futimesat(AT_FDCWD, filename, t);
 }
diff --git a/include/linux/compat.h b/include/linux/compat.h
index 657ca6abd855..ebddcb6cfcf8 100644
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -520,11 +520,6 @@ int __compat_save_altstack(compat_stack_t __user *, unsigned long);
 asmlinkage long compat_sys_io_setup(unsigned nr_reqs, u32 __user *ctx32p);
 asmlinkage long compat_sys_io_submit(compat_aio_context_t ctx_id, int nr,
 				     u32 __user *iocb);
-asmlinkage long compat_sys_io_getevents(compat_aio_context_t ctx_id,
-					compat_long_t min_nr,
-					compat_long_t nr,
-					struct io_event __user *events,
-					struct old_timespec32 __user *timeout);
 asmlinkage long compat_sys_io_pgetevents(compat_aio_context_t ctx_id,
 					compat_long_t min_nr,
 					compat_long_t nr,
@@ -617,7 +612,7 @@ asmlinkage long compat_sys_sendfile64(int out_fd, int in_fd,
 				    compat_loff_t __user *offset, compat_size_t count);
 
 /* fs/select.c */
-asmlinkage long compat_sys_pselect6(int n, compat_ulong_t __user *inp,
+asmlinkage long compat_sys_pselect6_time32(int n, compat_ulong_t __user *inp,
 				    compat_ulong_t __user *outp,
 				    compat_ulong_t __user *exp,
 				    struct old_timespec32 __user *tsp,
@@ -627,7 +622,7 @@ asmlinkage long compat_sys_pselect6_time64(int n, compat_ulong_t __user *inp,
 				    compat_ulong_t __user *exp,
 				    struct __kernel_timespec __user *tsp,
 				    void __user *sig);
-asmlinkage long compat_sys_ppoll(struct pollfd __user *ufds,
+asmlinkage long compat_sys_ppoll_time32(struct pollfd __user *ufds,
 				 unsigned int nfds,
 				 struct old_timespec32 __user *tsp,
 				 const compat_sigset_t __user *sigmask,
@@ -657,19 +652,6 @@ asmlinkage long compat_sys_newfstat(unsigned int fd,
 
 /* fs/sync.c: No generic prototype for sync_file_range and sync_file_range2 */
 
-/* fs/timerfd.c */
-asmlinkage long compat_sys_timerfd_gettime(int ufd,
-				   struct old_itimerspec32 __user *otmr);
-asmlinkage long compat_sys_timerfd_settime(int ufd, int flags,
-				   const struct old_itimerspec32 __user *utmr,
-				   struct old_itimerspec32 __user *otmr);
-
-/* fs/utimes.c */
-asmlinkage long compat_sys_utimensat(unsigned int dfd,
-				     const char __user *filename,
-				     struct old_timespec32 __user *t,
-				     int flags);
-
 /* kernel/exit.c */
 asmlinkage long compat_sys_waitid(int, compat_pid_t,
 		struct compat_siginfo __user *, int,
@@ -678,9 +660,6 @@ asmlinkage long compat_sys_waitid(int, compat_pid_t,
 
 
 /* kernel/futex.c */
-asmlinkage long compat_sys_futex(u32 __user *uaddr, int op, u32 val,
-		struct old_timespec32 __user *utime, u32 __user *uaddr2,
-		u32 val3);
 asmlinkage long
 compat_sys_set_robust_list(struct compat_robust_list_head __user *head,
 			   compat_size_t len);
@@ -688,10 +667,6 @@ asmlinkage long
 compat_sys_get_robust_list(int pid, compat_uptr_t __user *head_ptr,
 			   compat_size_t __user *len_ptr);
 
-/* kernel/hrtimer.c */
-asmlinkage long compat_sys_nanosleep(struct old_timespec32 __user *rqtp,
-				     struct old_timespec32 __user *rmtp);
-
 /* kernel/itimer.c */
 asmlinkage long compat_sys_getitimer(int which,
 				     struct compat_itimerval __user *it);
@@ -709,20 +684,6 @@ asmlinkage long compat_sys_kexec_load(compat_ulong_t entry,
 asmlinkage long compat_sys_timer_create(clockid_t which_clock,
 			struct compat_sigevent __user *timer_event_spec,
 			timer_t __user *created_timer_id);
-asmlinkage long compat_sys_timer_gettime(timer_t timer_id,
-				 struct old_itimerspec32 __user *setting);
-asmlinkage long compat_sys_timer_settime(timer_t timer_id, int flags,
-					 struct old_itimerspec32 __user *new,
-					 struct old_itimerspec32 __user *old);
-asmlinkage long compat_sys_clock_settime(clockid_t which_clock,
-					 struct old_timespec32 __user *tp);
-asmlinkage long compat_sys_clock_gettime(clockid_t which_clock,
-					 struct old_timespec32 __user *tp);
-asmlinkage long compat_sys_clock_getres(clockid_t which_clock,
-					struct old_timespec32 __user *tp);
-asmlinkage long compat_sys_clock_nanosleep(clockid_t which_clock, int flags,
-					   struct old_timespec32 __user *rqtp,
-					   struct old_timespec32 __user *rmtp);
 
 /* kernel/ptrace.c */
 asmlinkage long compat_sys_ptrace(compat_long_t request, compat_long_t pid,
@@ -735,8 +696,6 @@ asmlinkage long compat_sys_sched_setaffinity(compat_pid_t pid,
 asmlinkage long compat_sys_sched_getaffinity(compat_pid_t pid,
 				     unsigned int len,
 				     compat_ulong_t __user *user_mask_ptr);
-asmlinkage long compat_sys_sched_rr_get_interval(compat_pid_t pid,
-						 struct old_timespec32 __user *interval);
 
 /* kernel/signal.c */
 asmlinkage long compat_sys_sigaltstack(const compat_stack_t __user *uss_ptr,
@@ -754,7 +713,7 @@ asmlinkage long compat_sys_rt_sigprocmask(int how, compat_sigset_t __user *set,
 					  compat_size_t sigsetsize);
 asmlinkage long compat_sys_rt_sigpending(compat_sigset_t __user *uset,
 					 compat_size_t sigsetsize);
-asmlinkage long compat_sys_rt_sigtimedwait(compat_sigset_t __user *uthese,
+asmlinkage long compat_sys_rt_sigtimedwait_time32(compat_sigset_t __user *uthese,
 		struct compat_siginfo __user *uinfo,
 		struct old_timespec32 __user *uts, compat_size_t sigsetsize);
 asmlinkage long compat_sys_rt_sigtimedwait_time64(compat_sigset_t __user *uthese,
@@ -777,7 +736,6 @@ asmlinkage long compat_sys_gettimeofday(struct old_timeval32 __user *tv,
 		struct timezone __user *tz);
 asmlinkage long compat_sys_settimeofday(struct old_timeval32 __user *tv,
 		struct timezone __user *tz);
-asmlinkage long compat_sys_adjtimex(struct old_timex32 __user *utp);
 
 /* kernel/timer.c */
 asmlinkage long compat_sys_sysinfo(struct compat_sysinfo __user *info);
@@ -786,14 +744,6 @@ asmlinkage long compat_sys_sysinfo(struct compat_sysinfo __user *info);
 asmlinkage long compat_sys_mq_open(const char __user *u_name,
 			int oflag, compat_mode_t mode,
 			struct compat_mq_attr __user *u_attr);
-asmlinkage long compat_sys_mq_timedsend(mqd_t mqdes,
-			const char __user *u_msg_ptr,
-			compat_size_t msg_len, unsigned int msg_prio,
-			const struct old_timespec32 __user *u_abs_timeout);
-asmlinkage ssize_t compat_sys_mq_timedreceive(mqd_t mqdes,
-			char __user *u_msg_ptr,
-			compat_size_t msg_len, unsigned int __user *u_msg_prio,
-			const struct old_timespec32 __user *u_abs_timeout);
 asmlinkage long compat_sys_mq_notify(mqd_t mqdes,
 			const struct compat_sigevent __user *u_notification);
 asmlinkage long compat_sys_mq_getsetattr(mqd_t mqdes,
@@ -809,8 +759,6 @@ asmlinkage long compat_sys_msgsnd(int msqid, compat_uptr_t msgp,
 
 /* ipc/sem.c */
 asmlinkage long compat_sys_semctl(int semid, int semnum, int cmd, int arg);
-asmlinkage long compat_sys_semtimedop(int semid, struct sembuf __user *tsems,
-		unsigned nsems, const struct old_timespec32 __user *timeout);
 
 /* ipc/shm.c */
 asmlinkage long compat_sys_shmctl(int first, int second, void __user *uptr);
@@ -868,7 +816,7 @@ asmlinkage long compat_sys_rt_tgsigqueueinfo(compat_pid_t tgid,
 asmlinkage long compat_sys_recvmmsg_time64(int fd, struct compat_mmsghdr __user *mmsg,
 				    unsigned vlen, unsigned int flags,
 				    struct __kernel_timespec __user *timeout);
-asmlinkage long compat_sys_recvmmsg(int fd, struct compat_mmsghdr __user *mmsg,
+asmlinkage long compat_sys_recvmmsg_time32(int fd, struct compat_mmsghdr __user *mmsg,
 				    unsigned vlen, unsigned int flags,
 				    struct old_timespec32 __user *timeout);
 asmlinkage long compat_sys_wait4(compat_pid_t pid,
@@ -879,8 +827,6 @@ asmlinkage long compat_sys_fanotify_mark(int, unsigned int, __u32, __u32,
 asmlinkage long compat_sys_open_by_handle_at(int mountdirfd,
 					     struct file_handle __user *handle,
 					     int flags);
-asmlinkage long compat_sys_clock_adjtime(clockid_t which_clock,
-					 struct old_timex32 __user *tp);
 asmlinkage long compat_sys_sendmmsg(int fd, struct compat_mmsghdr __user *mmsg,
 				    unsigned vlen, unsigned int flags);
 asmlinkage ssize_t compat_sys_process_vm_readv(compat_pid_t pid,
@@ -921,8 +867,6 @@ asmlinkage long compat_sys_pwritev64v2(unsigned long fd,
 /* __ARCH_WANT_SYSCALL_NO_AT */
 asmlinkage long compat_sys_open(const char __user *filename, int flags,
 				umode_t mode);
-asmlinkage long compat_sys_utimes(const char __user *filename,
-				  struct old_timeval32 __user *t);
 
 /* __ARCH_WANT_SYSCALL_NO_FLAGS */
 asmlinkage long compat_sys_signalfd(int ufd,
@@ -936,12 +880,6 @@ asmlinkage long compat_sys_newlstat(const char __user *filename,
 				    struct compat_stat __user *statbuf);
 
 /* __ARCH_WANT_SYSCALL_DEPRECATED */
-asmlinkage long compat_sys_time(old_time32_t __user *tloc);
-asmlinkage long compat_sys_utime(const char __user *filename,
-				 struct old_utimbuf32 __user *t);
-asmlinkage long compat_sys_futimesat(unsigned int dfd,
-				     const char __user *filename,
-				     struct old_timeval32 __user *t);
 asmlinkage long compat_sys_select(int n, compat_ulong_t __user *inp,
 		compat_ulong_t __user *outp, compat_ulong_t __user *exp,
 		struct old_timeval32 __user *tvp);
@@ -976,9 +914,6 @@ asmlinkage long compat_sys_sigaction(int sig,
                                    struct compat_old_sigaction __user *oact);
 #endif
 
-/* obsolete: kernel/time/time.c */
-asmlinkage long compat_sys_stime(old_time32_t __user *tptr);
-
 /* obsolete: net/socket.c */
 asmlinkage long compat_sys_socketcall(int call, u32 __user *args);
 
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 09330d5bda0c..94369f5bd8e5 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -297,6 +297,11 @@ asmlinkage long sys_io_getevents(aio_context_t ctx_id,
 				long nr,
 				struct io_event __user *events,
 				struct __kernel_timespec __user *timeout);
+asmlinkage long sys_io_getevents_time32(__u32 ctx_id,
+				__s32 min_nr,
+				__s32 nr,
+				struct io_event __user *events,
+				struct old_timespec32 __user *timeout);
 asmlinkage long sys_io_pgetevents(aio_context_t ctx_id,
 				long min_nr,
 				long nr,
@@ -522,11 +527,19 @@ asmlinkage long sys_timerfd_settime(int ufd, int flags,
 				    const struct __kernel_itimerspec __user *utmr,
 				    struct __kernel_itimerspec __user *otmr);
 asmlinkage long sys_timerfd_gettime(int ufd, struct __kernel_itimerspec __user *otmr);
+asmlinkage long sys_timerfd_gettime32(int ufd,
+				   struct old_itimerspec32 __user *otmr);
+asmlinkage long sys_timerfd_settime32(int ufd, int flags,
+				   const struct old_itimerspec32 __user *utmr,
+				   struct old_itimerspec32 __user *otmr);
 
 /* fs/utimes.c */
 asmlinkage long sys_utimensat(int dfd, const char __user *filename,
 				struct __kernel_timespec __user *utimes,
 				int flags);
+asmlinkage long sys_utimensat_time32(unsigned int dfd,
+				const char __user *filename,
+				struct old_timespec32 __user *t, int flags);
 
 /* kernel/acct.c */
 asmlinkage long sys_acct(const char __user *name);
@@ -555,6 +568,9 @@ asmlinkage long sys_unshare(unsigned long unshare_flags);
 asmlinkage long sys_futex(u32 __user *uaddr, int op, u32 val,
 			struct __kernel_timespec __user *utime, u32 __user *uaddr2,
 			u32 val3);
+asmlinkage long sys_futex_time32(u32 __user *uaddr, int op, u32 val,
+			struct old_timespec32 __user *utime, u32 __user *uaddr2,
+			u32 val3);
 asmlinkage long sys_get_robust_list(int pid,
 				    struct robust_list_head __user * __user *head_ptr,
 				    size_t __user *len_ptr);
@@ -564,6 +580,8 @@ asmlinkage long sys_set_robust_list(struct robust_list_head __user *head,
 /* kernel/hrtimer.c */
 asmlinkage long sys_nanosleep(struct __kernel_timespec __user *rqtp,
 			      struct __kernel_timespec __user *rmtp);
+asmlinkage long sys_nanosleep_time32(struct old_timespec32 __user *rqtp,
+				     struct old_timespec32 __user *rmtp);
 
 /* kernel/itimer.c */
 asmlinkage long sys_getitimer(int which, struct itimerval __user *value);
@@ -602,6 +620,20 @@ asmlinkage long sys_clock_getres(clockid_t which_clock,
 asmlinkage long sys_clock_nanosleep(clockid_t which_clock, int flags,
 				const struct __kernel_timespec __user *rqtp,
 				struct __kernel_timespec __user *rmtp);
+asmlinkage long sys_timer_gettime32(timer_t timer_id,
+				 struct old_itimerspec32 __user *setting);
+asmlinkage long sys_timer_settime32(timer_t timer_id, int flags,
+					 struct old_itimerspec32 __user *new,
+					 struct old_itimerspec32 __user *old);
+asmlinkage long sys_clock_settime32(clockid_t which_clock,
+				struct old_timespec32 __user *tp);
+asmlinkage long sys_clock_gettime32(clockid_t which_clock,
+				struct old_timespec32 __user *tp);
+asmlinkage long sys_clock_getres_time32(clockid_t which_clock,
+				struct old_timespec32 __user *tp);
+asmlinkage long sys_clock_nanosleep_time32(clockid_t which_clock, int flags,
+				struct old_timespec32 __user *rqtp,
+				struct old_timespec32 __user *rmtp);
 
 /* kernel/printk.c */
 asmlinkage long sys_syslog(int type, char __user *buf, int len);
@@ -627,6 +659,8 @@ asmlinkage long sys_sched_get_priority_max(int policy);
 asmlinkage long sys_sched_get_priority_min(int policy);
 asmlinkage long sys_sched_rr_get_interval(pid_t pid,
 				struct __kernel_timespec __user *interval);
+asmlinkage long sys_sched_rr_get_interval_time32(pid_t pid,
+						 struct old_timespec32 __user *interval);
 
 /* kernel/signal.c */
 asmlinkage long sys_restart_syscall(void);
@@ -696,6 +730,7 @@ asmlinkage long sys_gettimeofday(struct timeval __user *tv,
 asmlinkage long sys_settimeofday(struct timeval __user *tv,
 				struct timezone __user *tz);
 asmlinkage long sys_adjtimex(struct __kernel_timex __user *txc_p);
+asmlinkage long sys_adjtimex_time32(struct old_timex32 __user *txc_p);
 
 /* kernel/timer.c */
 asmlinkage long sys_getpid(void);
@@ -714,6 +749,14 @@ asmlinkage long sys_mq_timedsend(mqd_t mqdes, const char __user *msg_ptr, size_t
 asmlinkage long sys_mq_timedreceive(mqd_t mqdes, char __user *msg_ptr, size_t msg_len, unsigned int __user *msg_prio, const struct __kernel_timespec __user *abs_timeout);
 asmlinkage long sys_mq_notify(mqd_t mqdes, const struct sigevent __user *notification);
 asmlinkage long sys_mq_getsetattr(mqd_t mqdes, const struct mq_attr __user *mqstat, struct mq_attr __user *omqstat);
+asmlinkage long sys_mq_timedreceive_time32(mqd_t mqdes,
+			char __user *u_msg_ptr,
+			unsigned int msg_len, unsigned int __user *u_msg_prio,
+			const struct old_timespec32 __user *u_abs_timeout);
+asmlinkage long sys_mq_timedsend_time32(mqd_t mqdes,
+			const char __user *u_msg_ptr,
+			unsigned int msg_len, unsigned int msg_prio,
+			const struct old_timespec32 __user *u_abs_timeout);
 
 /* ipc/msg.c */
 asmlinkage long sys_msgget(key_t key, int msgflg);
@@ -731,6 +774,9 @@ asmlinkage long sys_old_semctl(int semid, int semnum, int cmd, unsigned long arg
 asmlinkage long sys_semtimedop(int semid, struct sembuf __user *sops,
 				unsigned nsops,
 				const struct __kernel_timespec __user *timeout);
+asmlinkage long sys_semtimedop_time32(int semid, struct sembuf __user *sops,
+				unsigned nsops,
+				const struct old_timespec32 __user *timeout);
 asmlinkage long sys_semop(int semid, struct sembuf __user *sops,
 				unsigned nsops);
 
@@ -871,6 +917,8 @@ asmlinkage long sys_open_by_handle_at(int mountdirfd,
 				      int flags);
 asmlinkage long sys_clock_adjtime(clockid_t which_clock,
 				struct __kernel_timex __user *tx);
+asmlinkage long sys_clock_adjtime32(clockid_t which_clock,
+				struct old_timex32 __user *tx);
 asmlinkage long sys_syncfs(int fd);
 asmlinkage long sys_setns(int fd, int nstype);
 asmlinkage long sys_sendmmsg(int fd, struct mmsghdr __user *msg,
@@ -1006,6 +1054,7 @@ asmlinkage long sys_alarm(unsigned int seconds);
 asmlinkage long sys_getpgrp(void);
 asmlinkage long sys_pause(void);
 asmlinkage long sys_time(time_t __user *tloc);
+asmlinkage long sys_time32(old_time32_t __user *tloc);
 #ifdef __ARCH_WANT_SYS_UTIME
 asmlinkage long sys_utime(char __user *filename,
 				struct utimbuf __user *times);
@@ -1014,6 +1063,13 @@ asmlinkage long sys_utimes(char __user *filename,
 asmlinkage long sys_futimesat(int dfd, const char __user *filename,
 			      struct timeval __user *utimes);
 #endif
+asmlinkage long sys_futimesat_time32(unsigned int dfd,
+				     const char __user *filename,
+				     struct old_timeval32 __user *t);
+asmlinkage long sys_utime32(const char __user *filename,
+				 struct old_utimbuf32 __user *t);
+asmlinkage long sys_utimes_time32(const char __user *filename,
+				  struct old_timeval32 __user *t);
 asmlinkage long sys_creat(const char __user *pathname, umode_t mode);
 asmlinkage long sys_getdents(unsigned int fd,
 				struct linux_dirent __user *dirent,
@@ -1038,6 +1094,7 @@ asmlinkage long sys_fork(void);
 
 /* obsolete: kernel/time/time.c */
 asmlinkage long sys_stime(time_t __user *tptr);
+asmlinkage long sys_stime32(old_time32_t __user *tptr);
 
 /* obsolete: kernel/signal.c */
 asmlinkage long sys_sigpending(old_sigset_t __user *uset);
diff --git a/include/uapi/asm-generic/unistd.h b/include/uapi/asm-generic/unistd.h
index d90127298f12..d7db7ed99a7b 100644
--- a/include/uapi/asm-generic/unistd.h
+++ b/include/uapi/asm-generic/unistd.h
@@ -39,7 +39,7 @@ __SC_COMP(__NR_io_submit, sys_io_submit, compat_sys_io_submit)
 #define __NR_io_cancel 3
 __SYSCALL(__NR_io_cancel, sys_io_cancel)
 #define __NR_io_getevents 4
-__SC_COMP(__NR_io_getevents, sys_io_getevents, compat_sys_io_getevents)
+__SC_COMP(__NR_io_getevents, sys_io_getevents, sys_io_getevents_time32)
 
 /* fs/xattr.c */
 #define __NR_setxattr 5
@@ -223,9 +223,9 @@ __SYSCALL(__NR3264_sendfile, sys_sendfile64)
 
 /* fs/select.c */
 #define __NR_pselect6 72
-__SC_COMP(__NR_pselect6, sys_pselect6, compat_sys_pselect6)
+__SC_COMP(__NR_pselect6, sys_pselect6, compat_sys_pselect6_time32)
 #define __NR_ppoll 73
-__SC_COMP(__NR_ppoll, sys_ppoll, compat_sys_ppoll)
+__SC_COMP(__NR_ppoll, sys_ppoll, compat_sys_ppoll_time32)
 
 /* fs/signalfd.c */
 #define __NR_signalfd4 74
@@ -271,14 +271,14 @@ __SC_COMP(__NR_sync_file_range, sys_sync_file_range, \
 __SYSCALL(__NR_timerfd_create, sys_timerfd_create)
 #define __NR_timerfd_settime 86
 __SC_COMP(__NR_timerfd_settime, sys_timerfd_settime, \
-	  compat_sys_timerfd_settime)
+	  sys_timerfd_settime32)
 #define __NR_timerfd_gettime 87
 __SC_COMP(__NR_timerfd_gettime, sys_timerfd_gettime, \
-	  compat_sys_timerfd_gettime)
+	  sys_timerfd_gettime32)
 
 /* fs/utimes.c */
 #define __NR_utimensat 88
-__SC_COMP(__NR_utimensat, sys_utimensat, compat_sys_utimensat)
+__SC_COMP(__NR_utimensat, sys_utimensat, sys_utimensat_time32)
 
 /* kernel/acct.c */
 #define __NR_acct 89
@@ -310,7 +310,7 @@ __SYSCALL(__NR_unshare, sys_unshare)
 
 /* kernel/futex.c */
 #define __NR_futex 98
-__SC_COMP(__NR_futex, sys_futex, compat_sys_futex)
+__SC_COMP(__NR_futex, sys_futex, sys_futex_time32)
 #define __NR_set_robust_list 99
 __SC_COMP(__NR_set_robust_list, sys_set_robust_list, \
 	  compat_sys_set_robust_list)
@@ -320,7 +320,7 @@ __SC_COMP(__NR_get_robust_list, sys_get_robust_list, \
 
 /* kernel/hrtimer.c */
 #define __NR_nanosleep 101
-__SC_COMP(__NR_nanosleep, sys_nanosleep, compat_sys_nanosleep)
+__SC_COMP(__NR_nanosleep, sys_nanosleep, sys_nanosleep_time32)
 
 /* kernel/itimer.c */
 #define __NR_getitimer 102
@@ -342,22 +342,22 @@ __SYSCALL(__NR_delete_module, sys_delete_module)
 #define __NR_timer_create 107
 __SC_COMP(__NR_timer_create, sys_timer_create, compat_sys_timer_create)
 #define __NR_timer_gettime 108
-__SC_COMP(__NR_timer_gettime, sys_timer_gettime, compat_sys_timer_gettime)
+__SC_COMP(__NR_timer_gettime, sys_timer_gettime, sys_timer_gettime32)
 #define __NR_timer_getoverrun 109
 __SYSCALL(__NR_timer_getoverrun, sys_timer_getoverrun)
 #define __NR_timer_settime 110
-__SC_COMP(__NR_timer_settime, sys_timer_settime, compat_sys_timer_settime)
+__SC_COMP(__NR_timer_settime, sys_timer_settime, sys_timer_settime32)
 #define __NR_timer_delete 111
 __SYSCALL(__NR_timer_delete, sys_timer_delete)
 #define __NR_clock_settime 112
-__SC_COMP(__NR_clock_settime, sys_clock_settime, compat_sys_clock_settime)
+__SC_COMP(__NR_clock_settime, sys_clock_settime, sys_clock_settime32)
 #define __NR_clock_gettime 113
-__SC_COMP(__NR_clock_gettime, sys_clock_gettime, compat_sys_clock_gettime)
+__SC_COMP(__NR_clock_gettime, sys_clock_gettime, sys_clock_gettime32)
 #define __NR_clock_getres 114
-__SC_COMP(__NR_clock_getres, sys_clock_getres, compat_sys_clock_getres)
+__SC_COMP(__NR_clock_getres, sys_clock_getres, sys_clock_getres_time32)
 #define __NR_clock_nanosleep 115
 __SC_COMP(__NR_clock_nanosleep, sys_clock_nanosleep, \
-	  compat_sys_clock_nanosleep)
+	  sys_clock_nanosleep_time32)
 
 /* kernel/printk.c */
 #define __NR_syslog 116
@@ -390,7 +390,7 @@ __SYSCALL(__NR_sched_get_priority_max, sys_sched_get_priority_max)
 __SYSCALL(__NR_sched_get_priority_min, sys_sched_get_priority_min)
 #define __NR_sched_rr_get_interval 127
 __SC_COMP(__NR_sched_rr_get_interval, sys_sched_rr_get_interval, \
-	  compat_sys_sched_rr_get_interval)
+	  sys_sched_rr_get_interval_time32)
 
 /* kernel/signal.c */
 #define __NR_restart_syscall 128
@@ -413,7 +413,7 @@ __SC_COMP(__NR_rt_sigprocmask, sys_rt_sigprocmask, compat_sys_rt_sigprocmask)
 __SC_COMP(__NR_rt_sigpending, sys_rt_sigpending, compat_sys_rt_sigpending)
 #define __NR_rt_sigtimedwait 137
 __SC_COMP(__NR_rt_sigtimedwait, sys_rt_sigtimedwait, \
-	  compat_sys_rt_sigtimedwait)
+	  compat_sys_rt_sigtimedwait_time32)
 #define __NR_rt_sigqueueinfo 138
 __SC_COMP(__NR_rt_sigqueueinfo, sys_rt_sigqueueinfo, \
 	  compat_sys_rt_sigqueueinfo)
@@ -486,7 +486,7 @@ __SC_COMP(__NR_gettimeofday, sys_gettimeofday, compat_sys_gettimeofday)
 #define __NR_settimeofday 170
 __SC_COMP(__NR_settimeofday, sys_settimeofday, compat_sys_settimeofday)
 #define __NR_adjtimex 171
-__SC_COMP(__NR_adjtimex, sys_adjtimex, compat_sys_adjtimex)
+__SC_COMP(__NR_adjtimex, sys_adjtimex, sys_adjtimex_time32)
 
 /* kernel/timer.c */
 #define __NR_getpid 172
@@ -512,10 +512,10 @@ __SC_COMP(__NR_mq_open, sys_mq_open, compat_sys_mq_open)
 #define __NR_mq_unlink 181
 __SYSCALL(__NR_mq_unlink, sys_mq_unlink)
 #define __NR_mq_timedsend 182
-__SC_COMP(__NR_mq_timedsend, sys_mq_timedsend, compat_sys_mq_timedsend)
+__SC_COMP(__NR_mq_timedsend, sys_mq_timedsend, sys_mq_timedsend_time32)
 #define __NR_mq_timedreceive 183
 __SC_COMP(__NR_mq_timedreceive, sys_mq_timedreceive, \
-	  compat_sys_mq_timedreceive)
+	  sys_mq_timedreceive_time32)
 #define __NR_mq_notify 184
 __SC_COMP(__NR_mq_notify, sys_mq_notify, compat_sys_mq_notify)
 #define __NR_mq_getsetattr 185
@@ -537,7 +537,7 @@ __SYSCALL(__NR_semget, sys_semget)
 #define __NR_semctl 191
 __SC_COMP(__NR_semctl, sys_semctl, compat_sys_semctl)
 #define __NR_semtimedop 192
-__SC_COMP(__NR_semtimedop, sys_semtimedop, compat_sys_semtimedop)
+__SC_COMP(__NR_semtimedop, sys_semtimedop, sys_semtimedop_time32)
 #define __NR_semop 193
 __SYSCALL(__NR_semop, sys_semop)
 
@@ -659,7 +659,7 @@ __SYSCALL(__NR_perf_event_open, sys_perf_event_open)
 #define __NR_accept4 242
 __SYSCALL(__NR_accept4, sys_accept4)
 #define __NR_recvmmsg 243
-__SC_COMP(__NR_recvmmsg, sys_recvmmsg, compat_sys_recvmmsg)
+__SC_COMP(__NR_recvmmsg, sys_recvmmsg, compat_sys_recvmmsg_time32)
 
 /*
  * Architectures may provide up to 16 syscalls of their own
@@ -681,7 +681,7 @@ __SYSCALL(__NR_name_to_handle_at, sys_name_to_handle_at)
 __SC_COMP(__NR_open_by_handle_at, sys_open_by_handle_at, \
 	  compat_sys_open_by_handle_at)
 #define __NR_clock_adjtime 266
-__SC_COMP(__NR_clock_adjtime, sys_clock_adjtime, compat_sys_clock_adjtime)
+__SC_COMP(__NR_clock_adjtime, sys_clock_adjtime, sys_clock_adjtime32)
 #define __NR_syncfs 267
 __SYSCALL(__NR_syncfs, sys_syncfs)
 #define __NR_setns 268
diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index c595bed7bfcb..c839bf83231d 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -1471,10 +1471,10 @@ static int compat_prepare_timeout(const struct old_timespec32 __user *p,
 	return 0;
 }
 
-COMPAT_SYSCALL_DEFINE5(mq_timedsend, mqd_t, mqdes,
-		       const char __user *, u_msg_ptr,
-		       compat_size_t, msg_len, unsigned int, msg_prio,
-		       const struct old_timespec32 __user *, u_abs_timeout)
+SYSCALL_DEFINE5(mq_timedsend_time32, mqd_t, mqdes,
+		const char __user *, u_msg_ptr,
+		unsigned int, msg_len, unsigned int, msg_prio,
+		const struct old_timespec32 __user *, u_abs_timeout)
 {
 	struct timespec64 ts, *p = NULL;
 	if (u_abs_timeout) {
@@ -1486,10 +1486,10 @@ COMPAT_SYSCALL_DEFINE5(mq_timedsend, mqd_t, mqdes,
 	return do_mq_timedsend(mqdes, u_msg_ptr, msg_len, msg_prio, p);
 }
 
-COMPAT_SYSCALL_DEFINE5(mq_timedreceive, mqd_t, mqdes,
-		       char __user *, u_msg_ptr,
-		       compat_size_t, msg_len, unsigned int __user *, u_msg_prio,
-		       const struct old_timespec32 __user *, u_abs_timeout)
+SYSCALL_DEFINE5(mq_timedreceive_time32, mqd_t, mqdes,
+		char __user *, u_msg_ptr,
+		unsigned int, msg_len, unsigned int __user *, u_msg_prio,
+		const struct old_timespec32 __user *, u_abs_timeout)
 {
 	struct timespec64 ts, *p = NULL;
 	if (u_abs_timeout) {
diff --git a/ipc/sem.c b/ipc/sem.c
index d1efff3a81bb..80909464acff 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -2250,7 +2250,7 @@ long compat_ksys_semtimedop(int semid, struct sembuf __user *tsems,
 	return do_semtimedop(semid, tsems, nsops, NULL);
 }
 
-COMPAT_SYSCALL_DEFINE4(semtimedop, int, semid, struct sembuf __user *, tsems,
+SYSCALL_DEFINE4(semtimedop_time32, int, semid, struct sembuf __user *, tsems,
 		       unsigned int, nsops,
 		       const struct old_timespec32 __user *, timeout)
 {
diff --git a/kernel/futex.c b/kernel/futex.c
index be3bff2315ff..caead6c113d4 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -3812,7 +3812,7 @@ COMPAT_SYSCALL_DEFINE3(get_robust_list, int, pid,
 #endif /* CONFIG_COMPAT */
 
 #ifdef CONFIG_COMPAT_32BIT_TIME
-COMPAT_SYSCALL_DEFINE6(futex, u32 __user *, uaddr, int, op, u32, val,
+SYSCALL_DEFINE6(futex_time32, u32 __user *, uaddr, int, op, u32, val,
 		struct old_timespec32 __user *, utime, u32 __user *, uaddr2,
 		u32, val3)
 {
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index a674c7db2f29..62862419cd05 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5252,9 +5252,8 @@ SYSCALL_DEFINE2(sched_rr_get_interval, pid_t, pid,
 }
 
 #ifdef CONFIG_COMPAT_32BIT_TIME
-COMPAT_SYSCALL_DEFINE2(sched_rr_get_interval,
-		       compat_pid_t, pid,
-		       struct old_timespec32 __user *, interval)
+SYSCALL_DEFINE2(sched_rr_get_interval_time32, pid_t, pid,
+		struct old_timespec32 __user *, interval)
 {
 	struct timespec64 t;
 	int retval = sched_rr_get_interval(pid, &t);
diff --git a/kernel/signal.c b/kernel/signal.c
index e1d7ad8e6ab1..af27629918cf 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -3397,7 +3397,7 @@ COMPAT_SYSCALL_DEFINE4(rt_sigtimedwait_time64, compat_sigset_t __user *, uthese,
 }
 
 #ifdef CONFIG_COMPAT_32BIT_TIME
-COMPAT_SYSCALL_DEFINE4(rt_sigtimedwait, compat_sigset_t __user *, uthese,
+COMPAT_SYSCALL_DEFINE4(rt_sigtimedwait_time32, compat_sigset_t __user *, uthese,
 		struct compat_siginfo __user *, uinfo,
 		struct old_timespec32 __user *, uts, compat_size_t, sigsetsize)
 {
diff --git a/kernel/sys_ni.c b/kernel/sys_ni.c
index ce04431a40d1..85e5ccec0955 100644
--- a/kernel/sys_ni.c
+++ b/kernel/sys_ni.c
@@ -42,9 +42,11 @@ COND_SYSCALL(io_destroy);
 COND_SYSCALL(io_submit);
 COND_SYSCALL_COMPAT(io_submit);
 COND_SYSCALL(io_cancel);
+COND_SYSCALL(io_getevents_time32);
 COND_SYSCALL(io_getevents);
+COND_SYSCALL(io_pgetevents_time32);
 COND_SYSCALL(io_pgetevents);
-COND_SYSCALL_COMPAT(io_getevents);
+COND_SYSCALL_COMPAT(io_pgetevents_time32);
 COND_SYSCALL_COMPAT(io_pgetevents);
 
 /* fs/xattr.c */
@@ -114,9 +116,9 @@ COND_SYSCALL_COMPAT(signalfd4);
 /* fs/timerfd.c */
 COND_SYSCALL(timerfd_create);
 COND_SYSCALL(timerfd_settime);
-COND_SYSCALL_COMPAT(timerfd_settime);
+COND_SYSCALL(timerfd_settime32);
 COND_SYSCALL(timerfd_gettime);
-COND_SYSCALL_COMPAT(timerfd_gettime);
+COND_SYSCALL(timerfd_gettime32);
 
 /* fs/utimes.c */
 
@@ -135,7 +137,7 @@ COND_SYSCALL(capset);
 
 /* kernel/futex.c */
 COND_SYSCALL(futex);
-COND_SYSCALL_COMPAT(futex);
+COND_SYSCALL(futex_time32);
 COND_SYSCALL(set_robust_list);
 COND_SYSCALL_COMPAT(set_robust_list);
 COND_SYSCALL(get_robust_list);
@@ -187,9 +189,9 @@ COND_SYSCALL(mq_open);
 COND_SYSCALL_COMPAT(mq_open);
 COND_SYSCALL(mq_unlink);
 COND_SYSCALL(mq_timedsend);
-COND_SYSCALL_COMPAT(mq_timedsend);
+COND_SYSCALL(mq_timedsend_time32);
 COND_SYSCALL(mq_timedreceive);
-COND_SYSCALL_COMPAT(mq_timedreceive);
+COND_SYSCALL(mq_timedreceive_time32);
 COND_SYSCALL(mq_notify);
 COND_SYSCALL_COMPAT(mq_notify);
 COND_SYSCALL(mq_getsetattr);
@@ -211,7 +213,7 @@ COND_SYSCALL(old_semctl);
 COND_SYSCALL(semctl);
 COND_SYSCALL_COMPAT(semctl);
 COND_SYSCALL(semtimedop);
-COND_SYSCALL_COMPAT(semtimedop);
+COND_SYSCALL(semtimedop_time32);
 COND_SYSCALL(semop);
 
 /* ipc/shm.c */
@@ -288,7 +290,7 @@ COND_SYSCALL(perf_event_open);
 COND_SYSCALL(accept4);
 COND_SYSCALL(recvmmsg);
 COND_SYSCALL(recvmmsg_time32);
-COND_SYSCALL_COMPAT(recvmmsg);
+COND_SYSCALL_COMPAT(recvmmsg_time32);
 COND_SYSCALL_COMPAT(recvmmsg_time64);
 
 /*
diff --git a/kernel/time/hrtimer.c b/kernel/time/hrtimer.c
index f5cfa1b73d6f..0f5f96075110 100644
--- a/kernel/time/hrtimer.c
+++ b/kernel/time/hrtimer.c
@@ -1771,7 +1771,7 @@ SYSCALL_DEFINE2(nanosleep, struct __kernel_timespec __user *, rqtp,
 
 #ifdef CONFIG_COMPAT_32BIT_TIME
 
-COMPAT_SYSCALL_DEFINE2(nanosleep, struct old_timespec32 __user *, rqtp,
+SYSCALL_DEFINE2(nanosleep_time32, struct old_timespec32 __user *, rqtp,
 		       struct old_timespec32 __user *, rmtp)
 {
 	struct timespec64 tu;
diff --git a/kernel/time/posix-stubs.c b/kernel/time/posix-stubs.c
index a51895486e5e..67df65f887ac 100644
--- a/kernel/time/posix-stubs.c
+++ b/kernel/time/posix-stubs.c
@@ -45,6 +45,7 @@ SYS_NI(timer_delete);
 SYS_NI(clock_adjtime);
 SYS_NI(getitimer);
 SYS_NI(setitimer);
+SYS_NI(clock_adjtime32);
 #ifdef __ARCH_WANT_SYS_ALARM
 SYS_NI(alarm);
 #endif
@@ -150,16 +151,16 @@ SYSCALL_DEFINE4(clock_nanosleep, const clockid_t, which_clock, int, flags,
 
 #ifdef CONFIG_COMPAT
 COMPAT_SYS_NI(timer_create);
-COMPAT_SYS_NI(clock_adjtime);
-COMPAT_SYS_NI(timer_settime);
-COMPAT_SYS_NI(timer_gettime);
 COMPAT_SYS_NI(getitimer);
 COMPAT_SYS_NI(setitimer);
 #endif
 
 #ifdef CONFIG_COMPAT_32BIT_TIME
-COMPAT_SYSCALL_DEFINE2(clock_settime, const clockid_t, which_clock,
-		       struct old_timespec32 __user *, tp)
+SYS_NI(timer_settime32);
+SYS_NI(timer_gettime32);
+
+SYSCALL_DEFINE2(clock_settime32, const clockid_t, which_clock,
+		struct old_timespec32 __user *, tp)
 {
 	struct timespec64 new_tp;
 
@@ -171,8 +172,8 @@ COMPAT_SYSCALL_DEFINE2(clock_settime, const clockid_t, which_clock,
 	return do_sys_settimeofday64(&new_tp, NULL);
 }
 
-COMPAT_SYSCALL_DEFINE2(clock_gettime, clockid_t, which_clock,
-		       struct old_timespec32 __user *, tp)
+SYSCALL_DEFINE2(clock_gettime32, clockid_t, which_clock,
+		struct old_timespec32 __user *, tp)
 {
 	int ret;
 	struct timespec64 kernel_tp;
@@ -186,8 +187,8 @@ COMPAT_SYSCALL_DEFINE2(clock_gettime, clockid_t, which_clock,
 	return 0;
 }
 
-COMPAT_SYSCALL_DEFINE2(clock_getres, clockid_t, which_clock,
-		       struct old_timespec32 __user *, tp)
+SYSCALL_DEFINE2(clock_getres_time32, clockid_t, which_clock,
+		struct old_timespec32 __user *, tp)
 {
 	struct timespec64 rtn_tp = {
 		.tv_sec = 0,
@@ -206,9 +207,9 @@ COMPAT_SYSCALL_DEFINE2(clock_getres, clockid_t, which_clock,
 	}
 }
 
-COMPAT_SYSCALL_DEFINE4(clock_nanosleep, clockid_t, which_clock, int, flags,
-		       struct old_timespec32 __user *, rqtp,
-		       struct old_timespec32 __user *, rmtp)
+SYSCALL_DEFINE4(clock_nanosleep_time32, clockid_t, which_clock, int, flags,
+		struct old_timespec32 __user *, rqtp,
+		struct old_timespec32 __user *, rmtp)
 {
 	struct timespec64 t;
 
diff --git a/kernel/time/posix-timers.c b/kernel/time/posix-timers.c
index de79f85ae14f..29176635991f 100644
--- a/kernel/time/posix-timers.c
+++ b/kernel/time/posix-timers.c
@@ -730,8 +730,8 @@ SYSCALL_DEFINE2(timer_gettime, timer_t, timer_id,
 
 #ifdef CONFIG_COMPAT_32BIT_TIME
 
-COMPAT_SYSCALL_DEFINE2(timer_gettime, timer_t, timer_id,
-		       struct old_itimerspec32 __user *, setting)
+SYSCALL_DEFINE2(timer_gettime32, timer_t, timer_id,
+		struct old_itimerspec32 __user *, setting)
 {
 	struct itimerspec64 cur_setting;
 
@@ -903,9 +903,9 @@ SYSCALL_DEFINE4(timer_settime, timer_t, timer_id, int, flags,
 }
 
 #ifdef CONFIG_COMPAT_32BIT_TIME
-COMPAT_SYSCALL_DEFINE4(timer_settime, timer_t, timer_id, int, flags,
-		       struct old_itimerspec32 __user *, new,
-		       struct old_itimerspec32 __user *, old)
+SYSCALL_DEFINE4(timer_settime32, timer_t, timer_id, int, flags,
+		struct old_itimerspec32 __user *, new,
+		struct old_itimerspec32 __user *, old)
 {
 	struct itimerspec64 new_spec, old_spec;
 	struct itimerspec64 *rtn = old ? &old_spec : NULL;
@@ -1096,8 +1096,8 @@ SYSCALL_DEFINE2(clock_getres, const clockid_t, which_clock,
 
 #ifdef CONFIG_COMPAT_32BIT_TIME
 
-COMPAT_SYSCALL_DEFINE2(clock_settime, clockid_t, which_clock,
-		       struct old_timespec32 __user *, tp)
+SYSCALL_DEFINE2(clock_settime32, clockid_t, which_clock,
+		struct old_timespec32 __user *, tp)
 {
 	const struct k_clock *kc = clockid_to_kclock(which_clock);
 	struct timespec64 ts;
@@ -1111,8 +1111,8 @@ COMPAT_SYSCALL_DEFINE2(clock_settime, clockid_t, which_clock,
 	return kc->clock_set(which_clock, &ts);
 }
 
-COMPAT_SYSCALL_DEFINE2(clock_gettime, clockid_t, which_clock,
-		       struct old_timespec32 __user *, tp)
+SYSCALL_DEFINE2(clock_gettime32, clockid_t, which_clock,
+		struct old_timespec32 __user *, tp)
 {
 	const struct k_clock *kc = clockid_to_kclock(which_clock);
 	struct timespec64 ts;
@@ -1129,8 +1129,8 @@ COMPAT_SYSCALL_DEFINE2(clock_gettime, clockid_t, which_clock,
 	return err;
 }
 
-COMPAT_SYSCALL_DEFINE2(clock_adjtime, clockid_t, which_clock,
-		       struct old_timex32 __user *, utp)
+SYSCALL_DEFINE2(clock_adjtime32, clockid_t, which_clock,
+		struct old_timex32 __user *, utp)
 {
 	struct __kernel_timex ktx;
 	int err;
@@ -1147,8 +1147,8 @@ COMPAT_SYSCALL_DEFINE2(clock_adjtime, clockid_t, which_clock,
 	return err;
 }
 
-COMPAT_SYSCALL_DEFINE2(clock_getres, clockid_t, which_clock,
-		       struct old_timespec32 __user *, tp)
+SYSCALL_DEFINE2(clock_getres_time32, clockid_t, which_clock,
+		struct old_timespec32 __user *, tp)
 {
 	const struct k_clock *kc = clockid_to_kclock(which_clock);
 	struct timespec64 ts;
@@ -1204,9 +1204,9 @@ SYSCALL_DEFINE4(clock_nanosleep, const clockid_t, which_clock, int, flags,
 
 #ifdef CONFIG_COMPAT_32BIT_TIME
 
-COMPAT_SYSCALL_DEFINE4(clock_nanosleep, clockid_t, which_clock, int, flags,
-		       struct old_timespec32 __user *, rqtp,
-		       struct old_timespec32 __user *, rmtp)
+SYSCALL_DEFINE4(clock_nanosleep_time32, clockid_t, which_clock, int, flags,
+		struct old_timespec32 __user *, rqtp,
+		struct old_timespec32 __user *, rmtp)
 {
 	const struct k_clock *kc = clockid_to_kclock(which_clock);
 	struct timespec64 t;
diff --git a/kernel/time/time.c b/kernel/time/time.c
index 78b5c8f1495a..6261f969dcb7 100644
--- a/kernel/time/time.c
+++ b/kernel/time/time.c
@@ -98,11 +98,11 @@ SYSCALL_DEFINE1(stime, time_t __user *, tptr)
 
 #endif /* __ARCH_WANT_SYS_TIME */
 
-#ifdef CONFIG_COMPAT
+#ifdef CONFIG_COMPAT_32BIT_TIME
 #ifdef __ARCH_WANT_COMPAT_SYS_TIME
 
 /* old_time32_t is a 32 bit "long" and needs to get converted. */
-COMPAT_SYSCALL_DEFINE1(time, old_time32_t __user *, tloc)
+SYSCALL_DEFINE1(time32, old_time32_t __user *, tloc)
 {
 	old_time32_t i;
 
@@ -116,7 +116,7 @@ COMPAT_SYSCALL_DEFINE1(time, old_time32_t __user *, tloc)
 	return i;
 }
 
-COMPAT_SYSCALL_DEFINE1(stime, old_time32_t __user *, tptr)
+SYSCALL_DEFINE1(stime32, old_time32_t __user *, tptr)
 {
 	struct timespec64 tv;
 	int err;
@@ -344,7 +344,7 @@ int put_old_timex32(struct old_timex32 __user *utp, const struct __kernel_timex
 	return 0;
 }
 
-COMPAT_SYSCALL_DEFINE1(adjtimex, struct old_timex32 __user *, utp)
+SYSCALL_DEFINE1(adjtimex_time32, struct old_timex32 __user *, utp)
 {
 	struct __kernel_timex txc;
 	int err, ret;
diff --git a/net/compat.c b/net/compat.c
index 959d1c51826d..2fef7b9db434 100644
--- a/net/compat.c
+++ b/net/compat.c
@@ -822,7 +822,7 @@ COMPAT_SYSCALL_DEFINE5(recvmmsg_time64, int, fd, struct compat_mmsghdr __user *,
 }
 
 #ifdef CONFIG_COMPAT_32BIT_TIME
-COMPAT_SYSCALL_DEFINE5(recvmmsg, int, fd, struct compat_mmsghdr __user *, mmsg,
+COMPAT_SYSCALL_DEFINE5(recvmmsg_time32, int, fd, struct compat_mmsghdr __user *, mmsg,
 		       unsigned int, vlen, unsigned int, flags,
 		       struct old_timespec32 __user *, timeout)
 {
-- 
2.20.0
