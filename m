From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v2 26/29] y2038: use time32 syscall names on 32-bit
Date: Fri, 18 Jan 2019 17:18:32 +0100
Message-ID: <20190118161835.2259170-27-arnd@arndb.de>
References: <20190118161835.2259170-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190118161835.2259170-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: y2038@lists.linaro.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, mattst88@gmail.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, tony.luck@intel.com, fenghua.yu@intel.com, geert@linux-m68k.org, monstr@monstr.eu, paul.burton@mips.com, deller@gmx.de, benh@kernel.crashing.org, mpe@ellerman.id.au, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, dalias@libc.org, davem@davemloft.net, luto@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org, jcmvbkbc@gmail.com, akpm@linux-foundation.org, deepa.kernel@gmail.com, ebiederm@xmission.com, firoz.khan@linaro.org, linux-alpha@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-ia64@vger.kernel.org, linux-m68k@lists.linux-m68k.org, linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.or
List-Id: linux-api@vger.kernel.org

This is the big flip, where all 32-bit architectures set COMPAT_32BIT_TIME
abd use the _time32 system calls from the former compat layer instead
of the system calls that take __kernel_timespec and similar arguments.

The temporary redirects for __kernel_timespec, __kernel_itimerspec
and __kernel_timex can get removed with this.

It would be easy to split this commit by architecture, but with the new
generated system call tables, it's easy enough to do it all at once,
which makes it a little easier to check that the changes are the same
in each table.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/Kconfig                                |  2 +-
 arch/arm/kernel/sys_oabi-compat.c           |  8 +-
 arch/arm/tools/syscall.tbl                  | 46 ++++++------
 arch/m68k/kernel/syscalls/syscall.tbl       | 42 +++++------
 arch/microblaze/kernel/syscalls/syscall.tbl | 46 ++++++------
 arch/mips/kernel/syscalls/syscall_o32.tbl   | 44 +++++------
 arch/parisc/kernel/syscalls/syscall.tbl     | 69 +++++++++++------
 arch/powerpc/kernel/syscalls/syscall.tbl    | 82 +++++++++++++++------
 arch/sh/kernel/syscalls/syscall.tbl         | 42 +++++------
 arch/sparc/kernel/syscalls/syscall.tbl      | 64 ++++++++++------
 arch/x86/entry/syscalls/syscall_32.tbl      | 44 +++++------
 arch/xtensa/kernel/syscalls/syscall.tbl     | 44 +++++------
 include/uapi/asm-generic/unistd.h           | 56 +++++++-------
 13 files changed, 335 insertions(+), 254 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index 4cfb6de48f79..46db715a7f42 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -759,7 +759,7 @@ config 64BIT_TIME
 	  handling.
 
 config COMPAT_32BIT_TIME
-	def_bool (!64BIT && 64BIT_TIME) || COMPAT
+	def_bool !64BIT || COMPAT
 	help
 	  This enables 32 bit time_t support in addition to 64 bit time_t support.
 	  This is relevant on all 32-bit architectures, and 64-bit architectures
diff --git a/arch/arm/kernel/sys_oabi-compat.c b/arch/arm/kernel/sys_oabi-compat.c
index 92ab36f38795..acd054a42ba2 100644
--- a/arch/arm/kernel/sys_oabi-compat.c
+++ b/arch/arm/kernel/sys_oabi-compat.c
@@ -317,10 +317,10 @@ struct oabi_sembuf {
 asmlinkage long sys_oabi_semtimedop(int semid,
 				    struct oabi_sembuf __user *tsops,
 				    unsigned nsops,
-				    const struct timespec __user *timeout)
+				    const struct old_timespec32 __user *timeout)
 {
 	struct sembuf *sops;
-	struct timespec local_timeout;
+	struct old_timespec32 local_timeout;
 	long err;
 	int i;
 
@@ -350,7 +350,7 @@ asmlinkage long sys_oabi_semtimedop(int semid,
 	} else {
 		mm_segment_t fs = get_fs();
 		set_fs(KERNEL_DS);
-		err = sys_semtimedop(semid, sops, nsops, timeout);
+		err = sys_semtimedop_time32(semid, sops, nsops, timeout);
 		set_fs(fs);
 	}
 	kfree(sops);
@@ -375,7 +375,7 @@ asmlinkage int sys_oabi_ipc(uint call, int first, int second, int third,
 		return  sys_oabi_semtimedop(first,
 					    (struct oabi_sembuf __user *)ptr,
 					    second,
-					    (const struct timespec __user *)fifth);
+					    (const struct old_timespec32 __user *)fifth);
 	default:
 		return sys_ipc(call, first, second, third, ptr, fifth);
 	}
diff --git a/arch/arm/tools/syscall.tbl b/arch/arm/tools/syscall.tbl
index b54b7f2bc24a..200f4b878a46 100644
--- a/arch/arm/tools/syscall.tbl
+++ b/arch/arm/tools/syscall.tbl
@@ -137,7 +137,7 @@
 121	common	setdomainname		sys_setdomainname
 122	common	uname			sys_newuname
 # 123 was sys_modify_ldt
-124	common	adjtimex		sys_adjtimex
+124	common	adjtimex		sys_adjtimex_time32
 125	common	mprotect		sys_mprotect
 126	common	sigprocmask		sys_sigprocmask
 # 127 was sys_create_module
@@ -174,8 +174,8 @@
 158	common	sched_yield		sys_sched_yield
 159	common	sched_get_priority_max	sys_sched_get_priority_max
 160	common	sched_get_priority_min	sys_sched_get_priority_min
-161	common	sched_rr_get_interval	sys_sched_rr_get_interval
-162	common	nanosleep		sys_nanosleep
+161	common	sched_rr_get_interval	sys_sched_rr_get_interval_time32
+162	common	nanosleep		sys_nanosleep_time32
 163	common	mremap			sys_mremap
 164	common	setresuid		sys_setresuid16
 165	common	getresuid		sys_getresuid16
@@ -190,7 +190,7 @@
 174	common	rt_sigaction		sys_rt_sigaction
 175	common	rt_sigprocmask		sys_rt_sigprocmask
 176	common	rt_sigpending		sys_rt_sigpending
-177	common	rt_sigtimedwait		sys_rt_sigtimedwait
+177	common	rt_sigtimedwait		sys_rt_sigtimedwait_time32
 178	common	rt_sigqueueinfo		sys_rt_sigqueueinfo
 179	common	rt_sigsuspend		sys_rt_sigsuspend
 180	common	pread64			sys_pread64		sys_oabi_pread64
@@ -254,12 +254,12 @@
 237	common	fremovexattr		sys_fremovexattr
 238	common	tkill			sys_tkill
 239	common	sendfile64		sys_sendfile64
-240	common	futex			sys_futex
+240	common	futex			sys_futex_time32
 241	common	sched_setaffinity	sys_sched_setaffinity
 242	common	sched_getaffinity	sys_sched_getaffinity
 243	common	io_setup		sys_io_setup
 244	common	io_destroy		sys_io_destroy
-245	common	io_getevents		sys_io_getevents
+245	common	io_getevents		sys_io_getevents_time32
 246	common	io_submit		sys_io_submit
 247	common	io_cancel		sys_io_cancel
 248	common	exit_group		sys_exit_group
@@ -272,14 +272,14 @@
 # 255 for get_thread_area
 256	common	set_tid_address		sys_set_tid_address
 257	common	timer_create		sys_timer_create
-258	common	timer_settime		sys_timer_settime
-259	common	timer_gettime		sys_timer_gettime
+258	common	timer_settime		sys_timer_settime32
+259	common	timer_gettime		sys_timer_gettime32
 260	common	timer_getoverrun	sys_timer_getoverrun
 261	common	timer_delete		sys_timer_delete
-262	common	clock_settime		sys_clock_settime
-263	common	clock_gettime		sys_clock_gettime
-264	common	clock_getres		sys_clock_getres
-265	common	clock_nanosleep		sys_clock_nanosleep
+262	common	clock_settime		sys_clock_settime32
+263	common	clock_gettime		sys_clock_gettime32
+264	common	clock_getres		sys_clock_getres_time32
+265	common	clock_nanosleep		sys_clock_nanosleep_time32
 266	common	statfs64		sys_statfs64_wrapper
 267	common	fstatfs64		sys_fstatfs64_wrapper
 268	common	tgkill			sys_tgkill
@@ -290,8 +290,8 @@
 273	common	pciconfig_write		sys_pciconfig_write
 274	common	mq_open			sys_mq_open
 275	common	mq_unlink		sys_mq_unlink
-276	common	mq_timedsend		sys_mq_timedsend
-277	common	mq_timedreceive		sys_mq_timedreceive
+276	common	mq_timedsend		sys_mq_timedsend_time32
+277	common	mq_timedreceive		sys_mq_timedreceive_time32
 278	common	mq_notify		sys_mq_notify
 279	common	mq_getsetattr		sys_mq_getsetattr
 280	common	waitid			sys_waitid
@@ -326,7 +326,7 @@
 309	common	add_key			sys_add_key
 310	common	request_key		sys_request_key
 311	common	keyctl			sys_keyctl
-312	common	semtimedop		sys_semtimedop		sys_oabi_semtimedop
+312	common	semtimedop		sys_semtimedop_time32	sys_oabi_semtimedop
 313	common	vserver
 314	common	ioprio_set		sys_ioprio_set
 315	common	ioprio_get		sys_ioprio_get
@@ -349,8 +349,8 @@
 332	common	readlinkat		sys_readlinkat
 333	common	fchmodat		sys_fchmodat
 334	common	faccessat		sys_faccessat
-335	common	pselect6		sys_pselect6
-336	common	ppoll			sys_ppoll
+335	common	pselect6		sys_pselect6_time32
+336	common	ppoll			sys_ppoll_time32
 337	common	unshare			sys_unshare
 338	common	set_robust_list		sys_set_robust_list
 339	common	get_robust_list		sys_get_robust_list
@@ -362,13 +362,13 @@
 345	common	getcpu			sys_getcpu
 346	common	epoll_pwait		sys_epoll_pwait
 347	common	kexec_load		sys_kexec_load
-348	common	utimensat		sys_utimensat
+348	common	utimensat		sys_utimensat_time32
 349	common	signalfd		sys_signalfd
 350	common	timerfd_create		sys_timerfd_create
 351	common	eventfd			sys_eventfd
 352	common	fallocate		sys_fallocate
-353	common	timerfd_settime		sys_timerfd_settime
-354	common	timerfd_gettime		sys_timerfd_gettime
+353	common	timerfd_settime		sys_timerfd_settime32
+354	common	timerfd_gettime		sys_timerfd_gettime32
 355	common	signalfd4		sys_signalfd4
 356	common	eventfd2		sys_eventfd2
 357	common	epoll_create1		sys_epoll_create1
@@ -379,14 +379,14 @@
 362	common	pwritev			sys_pwritev
 363	common	rt_tgsigqueueinfo	sys_rt_tgsigqueueinfo
 364	common	perf_event_open		sys_perf_event_open
-365	common	recvmmsg		sys_recvmmsg
+365	common	recvmmsg		sys_recvmmsg_time32
 366	common	accept4			sys_accept4
 367	common	fanotify_init		sys_fanotify_init
 368	common	fanotify_mark		sys_fanotify_mark
 369	common	prlimit64		sys_prlimit64
 370	common	name_to_handle_at	sys_name_to_handle_at
 371	common	open_by_handle_at	sys_open_by_handle_at
-372	common	clock_adjtime		sys_clock_adjtime
+372	common	clock_adjtime		sys_clock_adjtime32
 373	common	syncfs			sys_syncfs
 374	common	sendmmsg		sys_sendmmsg
 375	common	setns			sys_setns
@@ -413,6 +413,6 @@
 396	common	pkey_free		sys_pkey_free
 397	common	statx			sys_statx
 398	common	rseq			sys_rseq
-399	common	io_pgetevents		sys_io_pgetevents
+399	common	io_pgetevents		sys_io_pgetevents_time32
 400	common	migrate_pages		sys_migrate_pages
 401	common	kexec_file_load		sys_kexec_file_load
diff --git a/arch/m68k/kernel/syscalls/syscall.tbl b/arch/m68k/kernel/syscalls/syscall.tbl
index ae88b85d068e..fe7583987efc 100644
--- a/arch/m68k/kernel/syscalls/syscall.tbl
+++ b/arch/m68k/kernel/syscalls/syscall.tbl
@@ -131,7 +131,7 @@
 121	common	setdomainname			sys_setdomainname
 122	common	uname				sys_newuname
 123	common	cacheflush			sys_cacheflush
-124	common	adjtimex			sys_adjtimex
+124	common	adjtimex			sys_adjtimex_time32
 125	common	mprotect			sys_mprotect
 126	common	sigprocmask			sys_sigprocmask
 127	common	create_module			sys_ni_syscall
@@ -168,8 +168,8 @@
 158	common	sched_yield			sys_sched_yield
 159	common	sched_get_priority_max		sys_sched_get_priority_max
 160	common	sched_get_priority_min		sys_sched_get_priority_min
-161	common	sched_rr_get_interval		sys_sched_rr_get_interval
-162	common	nanosleep			sys_nanosleep
+161	common	sched_rr_get_interval		sys_sched_rr_get_interval_time32
+162	common	nanosleep			sys_nanosleep_time32
 163	common	mremap				sys_mremap
 164	common	setresuid			sys_setresuid16
 165	common	getresuid			sys_getresuid16
@@ -184,7 +184,7 @@
 174	common	rt_sigaction			sys_rt_sigaction
 175	common	rt_sigprocmask			sys_rt_sigprocmask
 176	common	rt_sigpending			sys_rt_sigpending
-177	common	rt_sigtimedwait			sys_rt_sigtimedwait
+177	common	rt_sigtimedwait			sys_rt_sigtimedwait_time32
 178	common	rt_sigqueueinfo			sys_rt_sigqueueinfo
 179	common	rt_sigsuspend			sys_rt_sigsuspend
 180	common	pread64				sys_pread64
@@ -242,7 +242,7 @@
 232	common	removexattr			sys_removexattr
 233	common	lremovexattr			sys_lremovexattr
 234	common	fremovexattr			sys_fremovexattr
-235	common	futex				sys_futex
+235	common	futex				sys_futex_time32
 236	common	sendfile64			sys_sendfile64
 237	common	mincore				sys_mincore
 238	common	madvise				sys_madvise
@@ -250,7 +250,7 @@
 240	common	readahead			sys_readahead
 241	common	io_setup			sys_io_setup
 242	common	io_destroy			sys_io_destroy
-243	common	io_getevents			sys_io_getevents
+243	common	io_getevents			sys_io_getevents_time32
 244	common	io_submit			sys_io_submit
 245	common	io_cancel			sys_io_cancel
 246	common	fadvise64			sys_fadvise64
@@ -262,14 +262,14 @@
 252	common	remap_file_pages		sys_remap_file_pages
 253	common	set_tid_address			sys_set_tid_address
 254	common	timer_create			sys_timer_create
-255	common	timer_settime			sys_timer_settime
-256	common	timer_gettime			sys_timer_gettime
+255	common	timer_settime			sys_timer_settime32
+256	common	timer_gettime			sys_timer_gettime32
 257	common	timer_getoverrun		sys_timer_getoverrun
 258	common	timer_delete			sys_timer_delete
-259	common	clock_settime			sys_clock_settime
-260	common	clock_gettime			sys_clock_gettime
-261	common	clock_getres			sys_clock_getres
-262	common	clock_nanosleep			sys_clock_nanosleep
+259	common	clock_settime			sys_clock_settime32
+260	common	clock_gettime			sys_clock_gettime32
+261	common	clock_getres			sys_clock_getres_time32
+262	common	clock_nanosleep			sys_clock_nanosleep_time32
 263	common	statfs64			sys_statfs64
 264	common	fstatfs64			sys_fstatfs64
 265	common	tgkill				sys_tgkill
@@ -280,8 +280,8 @@
 270	common	set_mempolicy			sys_set_mempolicy
 271	common	mq_open				sys_mq_open
 272	common	mq_unlink			sys_mq_unlink
-273	common	mq_timedsend			sys_mq_timedsend
-274	common	mq_timedreceive			sys_mq_timedreceive
+273	common	mq_timedsend			sys_mq_timedsend_time32
+274	common	mq_timedreceive			sys_mq_timedreceive_time32
 275	common	mq_notify			sys_mq_notify
 276	common	mq_getsetattr			sys_mq_getsetattr
 277	common	waitid				sys_waitid
@@ -308,8 +308,8 @@
 298	common	readlinkat			sys_readlinkat
 299	common	fchmodat			sys_fchmodat
 300	common	faccessat			sys_faccessat
-301	common	pselect6			sys_pselect6
-302	common	ppoll				sys_ppoll
+301	common	pselect6			sys_pselect6_time32
+302	common	ppoll				sys_ppoll_time32
 303	common	unshare				sys_unshare
 304	common	set_robust_list			sys_set_robust_list
 305	common	get_robust_list			sys_get_robust_list
@@ -323,13 +323,13 @@
 313	common	kexec_load			sys_kexec_load
 314	common	getcpu				sys_getcpu
 315	common	epoll_pwait			sys_epoll_pwait
-316	common	utimensat			sys_utimensat
+316	common	utimensat			sys_utimensat_time32
 317	common	signalfd			sys_signalfd
 318	common	timerfd_create			sys_timerfd_create
 319	common	eventfd				sys_eventfd
 320	common	fallocate			sys_fallocate
-321	common	timerfd_settime			sys_timerfd_settime
-322	common	timerfd_gettime			sys_timerfd_gettime
+321	common	timerfd_settime			sys_timerfd_settime32
+322	common	timerfd_gettime			sys_timerfd_gettime32
 323	common	signalfd4			sys_signalfd4
 324	common	eventfd2			sys_eventfd2
 325	common	epoll_create1			sys_epoll_create1
@@ -349,7 +349,7 @@
 339	common	prlimit64			sys_prlimit64
 340	common	name_to_handle_at		sys_name_to_handle_at
 341	common	open_by_handle_at		sys_open_by_handle_at
-342	common	clock_adjtime			sys_clock_adjtime
+342	common	clock_adjtime			sys_clock_adjtime32
 343	common	syncfs				sys_syncfs
 344	common	setns				sys_setns
 345	common	process_vm_readv		sys_process_vm_readv
@@ -378,7 +378,7 @@
 368	common	recvfrom			sys_recvfrom
 369	common	recvmsg				sys_recvmsg
 370	common	shutdown			sys_shutdown
-371	common	recvmmsg			sys_recvmmsg
+371	common	recvmmsg			sys_recvmmsg_time32
 372	common	sendmmsg			sys_sendmmsg
 373	common	userfaultfd			sys_userfaultfd
 374	common	membarrier			sys_membarrier
diff --git a/arch/microblaze/kernel/syscalls/syscall.tbl b/arch/microblaze/kernel/syscalls/syscall.tbl
index 7cc0f9554da3..492ff5c35b68 100644
--- a/arch/microblaze/kernel/syscalls/syscall.tbl
+++ b/arch/microblaze/kernel/syscalls/syscall.tbl
@@ -131,7 +131,7 @@
 121	common	setdomainname			sys_setdomainname
 122	common	uname				sys_newuname
 123	common	modify_ldt			sys_ni_syscall
-124	common	adjtimex			sys_adjtimex
+124	common	adjtimex			sys_adjtimex_time32
 125	common	mprotect			sys_mprotect
 126	common	sigprocmask			sys_sigprocmask
 127	common	create_module			sys_ni_syscall
@@ -168,8 +168,8 @@
 158	common	sched_yield			sys_sched_yield
 159	common	sched_get_priority_max		sys_sched_get_priority_max
 160	common	sched_get_priority_min		sys_sched_get_priority_min
-161	common	sched_rr_get_interval		sys_sched_rr_get_interval
-162	common	nanosleep			sys_nanosleep
+161	common	sched_rr_get_interval		sys_sched_rr_get_interval_time32
+162	common	nanosleep			sys_nanosleep_time32
 163	common	mremap				sys_mremap
 164	common	setresuid			sys_setresuid
 165	common	getresuid			sys_getresuid
@@ -184,7 +184,7 @@
 174	common	rt_sigaction			sys_rt_sigaction
 175	common	rt_sigprocmask			sys_rt_sigprocmask
 176	common	rt_sigpending			sys_rt_sigpending
-177	common	rt_sigtimedwait			sys_rt_sigtimedwait
+177	common	rt_sigtimedwait			sys_rt_sigtimedwait_time32
 178	common	rt_sigqueueinfo			sys_rt_sigqueueinfo
 179	common	rt_sigsuspend			sys_rt_sigsuspend
 180	common	pread64				sys_pread64
@@ -247,14 +247,14 @@
 237	common	fremovexattr			sys_fremovexattr
 238	common	tkill				sys_tkill
 239	common	sendfile64			sys_sendfile64
-240	common	futex				sys_futex
+240	common	futex				sys_futex_time32
 241	common	sched_setaffinity		sys_sched_setaffinity
 242	common	sched_getaffinity		sys_sched_getaffinity
 243	common	set_thread_area			sys_ni_syscall
 244	common	get_thread_area			sys_ni_syscall
 245	common	io_setup			sys_io_setup
 246	common	io_destroy			sys_io_destroy
-247	common	io_getevents			sys_io_getevents
+247	common	io_getevents			sys_io_getevents_time32
 248	common	io_submit			sys_io_submit
 249	common	io_cancel			sys_io_cancel
 250	common	fadvise64			sys_fadvise64
@@ -267,14 +267,14 @@
 257	common	remap_file_pages		sys_remap_file_pages
 258	common	set_tid_address			sys_set_tid_address
 259	common	timer_create			sys_timer_create
-260	common	timer_settime			sys_timer_settime
-261	common	timer_gettime			sys_timer_gettime
+260	common	timer_settime			sys_timer_settime32
+261	common	timer_gettime			sys_timer_gettime32
 262	common	timer_getoverrun		sys_timer_getoverrun
 263	common	timer_delete			sys_timer_delete
-264	common	clock_settime			sys_clock_settime
-265	common	clock_gettime			sys_clock_gettime
-266	common	clock_getres			sys_clock_getres
-267	common	clock_nanosleep			sys_clock_nanosleep
+264	common	clock_settime			sys_clock_settime32
+265	common	clock_gettime			sys_clock_gettime32
+266	common	clock_getres			sys_clock_getres_time32
+267	common	clock_nanosleep			sys_clock_nanosleep_time32
 268	common	statfs64			sys_statfs64
 269	common	fstatfs64			sys_fstatfs64
 270	common	tgkill				sys_tgkill
@@ -286,8 +286,8 @@
 276	common	set_mempolicy			sys_set_mempolicy
 277	common	mq_open				sys_mq_open
 278	common	mq_unlink			sys_mq_unlink
-279	common	mq_timedsend			sys_mq_timedsend
-280	common	mq_timedreceive			sys_mq_timedreceive
+279	common	mq_timedsend			sys_mq_timedsend_time32
+280	common	mq_timedreceive			sys_mq_timedreceive_time32
 281	common	mq_notify			sys_mq_notify
 282	common	mq_getsetattr			sys_mq_getsetattr
 283	common	kexec_load			sys_kexec_load
@@ -315,8 +315,8 @@
 305	common	readlinkat			sys_readlinkat
 306	common	fchmodat			sys_fchmodat
 307	common	faccessat			sys_faccessat
-308	common	pselect6			sys_pselect6
-309	common	ppoll				sys_ppoll
+308	common	pselect6			sys_pselect6_time32
+309	common	ppoll				sys_ppoll_time32
 310	common	unshare				sys_unshare
 311	common	set_robust_list			sys_set_robust_list
 312	common	get_robust_list			sys_get_robust_list
@@ -327,14 +327,14 @@
 317	common	move_pages			sys_move_pages
 318	common	getcpu				sys_getcpu
 319	common	epoll_pwait			sys_epoll_pwait
-320	common	utimensat			sys_utimensat
+320	common	utimensat			sys_utimensat_time32
 321	common	signalfd			sys_signalfd
 322	common	timerfd_create			sys_timerfd_create
 323	common	eventfd				sys_eventfd
 324	common	fallocate			sys_fallocate
-325	common	semtimedop			sys_semtimedop
-326	common	timerfd_settime			sys_timerfd_settime
-327	common	timerfd_gettime			sys_timerfd_gettime
+325	common	semtimedop			sys_semtimedop_time32
+326	common	timerfd_settime			sys_timerfd_settime32
+327	common	timerfd_gettime			sys_timerfd_gettime32
 328	common	semctl				sys_old_semctl
 329	common	semget				sys_semget
 330	common	semop				sys_semop
@@ -374,13 +374,13 @@
 364	common	pwritev				sys_pwritev
 365	common	rt_tgsigqueueinfo		sys_rt_tgsigqueueinfo
 366	common	perf_event_open			sys_perf_event_open
-367	common	recvmmsg			sys_recvmmsg
+367	common	recvmmsg			sys_recvmmsg_time32
 368	common	fanotify_init			sys_fanotify_init
 369	common	fanotify_mark			sys_fanotify_mark
 370	common	prlimit64			sys_prlimit64
 371	common	name_to_handle_at		sys_name_to_handle_at
 372	common	open_by_handle_at		sys_open_by_handle_at
-373	common	clock_adjtime			sys_clock_adjtime
+373	common	clock_adjtime			sys_clock_adjtime32
 374	common	syncfs				sys_syncfs
 375	common	setns				sys_setns
 376	common	sendmmsg			sys_sendmmsg
@@ -406,5 +406,5 @@
 396	common	pkey_alloc			sys_pkey_alloc
 397	common	pkey_free			sys_pkey_free
 398	common	statx				sys_statx
-399	common	io_pgetevents			sys_io_pgetevents
+399	common	io_pgetevents			sys_io_pgetevents_time32
 400	common	rseq				sys_rseq
diff --git a/arch/mips/kernel/syscalls/syscall_o32.tbl b/arch/mips/kernel/syscalls/syscall_o32.tbl
index e9fec7bac5a9..5642d93b64c0 100644
--- a/arch/mips/kernel/syscalls/syscall_o32.tbl
+++ b/arch/mips/kernel/syscalls/syscall_o32.tbl
@@ -135,7 +135,7 @@
 121	o32	setdomainname			sys_setdomainname
 122	o32	uname				sys_newuname
 123	o32	modify_ldt			sys_ni_syscall
-124	o32	adjtimex			sys_adjtimex			sys_adjtimex_time32
+124	o32	adjtimex			sys_adjtimex_time32
 125	o32	mprotect			sys_mprotect
 126	o32	sigprocmask			sys_sigprocmask			compat_sys_sigprocmask
 127	o32	create_module			sys_ni_syscall
@@ -176,8 +176,8 @@
 162	o32	sched_yield			sys_sched_yield
 163	o32	sched_get_priority_max		sys_sched_get_priority_max
 164	o32	sched_get_priority_min		sys_sched_get_priority_min
-165	o32	sched_rr_get_interval		sys_sched_rr_get_interval	sys_sched_rr_get_interval_time32
-166	o32	nanosleep			sys_nanosleep			sys_nanosleep_time32
+165	o32	sched_rr_get_interval		sys_sched_rr_get_interval_time32
+166	o32	nanosleep			sys_nanosleep_time32
 167	o32	mremap				sys_mremap
 168	o32	accept				sys_accept
 169	o32	bind				sys_bind
@@ -208,7 +208,7 @@
 194	o32	rt_sigaction			sys_rt_sigaction		compat_sys_rt_sigaction
 195	o32	rt_sigprocmask			sys_rt_sigprocmask		compat_sys_rt_sigprocmask
 196	o32	rt_sigpending			sys_rt_sigpending		compat_sys_rt_sigpending
-197	o32	rt_sigtimedwait			sys_rt_sigtimedwait		compat_sys_rt_sigtimedwait_time32
+197	o32	rt_sigtimedwait			sys_rt_sigtimedwait_time32	compat_sys_rt_sigtimedwait_time32
 198	o32	rt_sigqueueinfo			sys_rt_sigqueueinfo		compat_sys_rt_sigqueueinfo
 199	o32	rt_sigsuspend			sys_rt_sigsuspend		compat_sys_rt_sigsuspend
 200	o32	pread64				sys_pread64			sys_32_pread
@@ -249,12 +249,12 @@
 235	o32	fremovexattr			sys_fremovexattr
 236	o32	tkill				sys_tkill
 237	o32	sendfile64			sys_sendfile64
-238	o32	futex				sys_futex			sys_futex_time32
+238	o32	futex				sys_futex_time32
 239	o32	sched_setaffinity		sys_sched_setaffinity		compat_sys_sched_setaffinity
 240	o32	sched_getaffinity		sys_sched_getaffinity		compat_sys_sched_getaffinity
 241	o32	io_setup			sys_io_setup			compat_sys_io_setup
 242	o32	io_destroy			sys_io_destroy
-243	o32	io_getevents			sys_io_getevents		sys_io_getevents_time32
+243	o32	io_getevents			sys_io_getevents_time32
 244	o32	io_submit			sys_io_submit			compat_sys_io_submit
 245	o32	io_cancel			sys_io_cancel
 246	o32	exit_group			sys_exit_group
@@ -269,14 +269,14 @@
 255	o32	statfs64			sys_statfs64			compat_sys_statfs64
 256	o32	fstatfs64			sys_fstatfs64			compat_sys_fstatfs64
 257	o32	timer_create			sys_timer_create		compat_sys_timer_create
-258	o32	timer_settime			sys_timer_settime		sys_timer_settime32
-259	o32	timer_gettime			sys_timer_gettime		sys_timer_gettime32
+258	o32	timer_settime			sys_timer_settime32
+259	o32	timer_gettime			sys_timer_gettime32
 260	o32	timer_getoverrun		sys_timer_getoverrun
 261	o32	timer_delete			sys_timer_delete
-262	o32	clock_settime			sys_clock_settime		sys_clock_settime32
-263	o32	clock_gettime			sys_clock_gettime		sys_clock_gettime32
-264	o32	clock_getres			sys_clock_getres		sys_clock_getres_time32
-265	o32	clock_nanosleep			sys_clock_nanosleep		sys_clock_nanosleep_time32
+262	o32	clock_settime			sys_clock_settime32
+263	o32	clock_gettime			sys_clock_gettime32
+264	o32	clock_getres			sys_clock_getres_time32
+265	o32	clock_nanosleep			sys_clock_nanosleep_time32
 266	o32	tgkill				sys_tgkill
 267	o32	utimes				sys_utimes			sys_utimes_time32
 268	o32	mbind				sys_mbind			compat_sys_mbind
@@ -284,8 +284,8 @@
 270	o32	set_mempolicy			sys_set_mempolicy		compat_sys_set_mempolicy
 271	o32	mq_open				sys_mq_open			compat_sys_mq_open
 272	o32	mq_unlink			sys_mq_unlink
-273	o32	mq_timedsend			sys_mq_timedsend		sys_mq_timedsend_time32
-274	o32	mq_timedreceive			sys_mq_timedreceive		sys_mq_timedreceive_time32
+273	o32	mq_timedsend			sys_mq_timedsend_time32
+274	o32	mq_timedreceive			sys_mq_timedreceive_time32
 275	o32	mq_notify			sys_mq_notify			compat_sys_mq_notify
 276	o32	mq_getsetattr			sys_mq_getsetattr		compat_sys_mq_getsetattr
 277	o32	vserver				sys_ni_syscall
@@ -312,8 +312,8 @@
 298	o32	readlinkat			sys_readlinkat
 299	o32	fchmodat			sys_fchmodat
 300	o32	faccessat			sys_faccessat
-301	o32	pselect6			sys_pselect6			compat_sys_pselect6_time32
-302	o32	ppoll				sys_ppoll			compat_sys_ppoll_time32
+301	o32	pselect6			sys_pselect6_time32		compat_sys_pselect6_time32
+302	o32	ppoll				sys_ppoll_time32		compat_sys_ppoll_time32
 303	o32	unshare				sys_unshare
 304	o32	splice				sys_splice
 305	o32	sync_file_range			sys_sync_file_range		sys32_sync_file_range
@@ -327,14 +327,14 @@
 313	o32	epoll_pwait			sys_epoll_pwait			compat_sys_epoll_pwait
 314	o32	ioprio_set			sys_ioprio_set
 315	o32	ioprio_get			sys_ioprio_get
-316	o32	utimensat			sys_utimensat			sys_utimensat_time32
+316	o32	utimensat			sys_utimensat_time32
 317	o32	signalfd			sys_signalfd			compat_sys_signalfd
 318	o32	timerfd				sys_ni_syscall
 319	o32	eventfd				sys_eventfd
 320	o32	fallocate			sys_fallocate			sys32_fallocate
 321	o32	timerfd_create			sys_timerfd_create
-322	o32	timerfd_gettime			sys_timerfd_gettime		sys_timerfd_gettime32
-323	o32	timerfd_settime			sys_timerfd_settime		sys_timerfd_settime32
+322	o32	timerfd_gettime			sys_timerfd_gettime32
+323	o32	timerfd_settime			sys_timerfd_settime32
 324	o32	signalfd4			sys_signalfd4			compat_sys_signalfd4
 325	o32	eventfd2			sys_eventfd2
 326	o32	epoll_create1			sys_epoll_create1
@@ -346,13 +346,13 @@
 332	o32	rt_tgsigqueueinfo		sys_rt_tgsigqueueinfo		compat_sys_rt_tgsigqueueinfo
 333	o32	perf_event_open			sys_perf_event_open
 334	o32	accept4				sys_accept4
-335	o32	recvmmsg			sys_recvmmsg			compat_sys_recvmmsg_time32
+335	o32	recvmmsg			sys_recvmmsg_time32		compat_sys_recvmmsg_time32
 336	o32	fanotify_init			sys_fanotify_init
 337	o32	fanotify_mark			sys_fanotify_mark		compat_sys_fanotify_mark
 338	o32	prlimit64			sys_prlimit64
 339	o32	name_to_handle_at		sys_name_to_handle_at
 340	o32	open_by_handle_at		sys_open_by_handle_at		compat_sys_open_by_handle_at
-341	o32	clock_adjtime			sys_clock_adjtime		sys_clock_adjtime32
+341	o32	clock_adjtime			sys_clock_adjtime32
 342	o32	syncfs				sys_syncfs
 343	o32	sendmmsg			sys_sendmmsg			compat_sys_sendmmsg
 344	o32	setns				sys_setns
@@ -379,7 +379,7 @@
 365	o32	pkey_free			sys_pkey_free
 366	o32	statx				sys_statx
 367	o32	rseq				sys_rseq
-368	o32	io_pgetevents			sys_io_pgetevents		compat_sys_io_pgetevents
+368	o32	io_pgetevents			sys_io_pgetevents_time32	compat_sys_io_pgetevents
 # room for arch specific calls
 393	o32	semget				sys_semget
 394	o32	semctl				sys_semctl			compat_sys_semctl
diff --git a/arch/parisc/kernel/syscalls/syscall.tbl b/arch/parisc/kernel/syscalls/syscall.tbl
index 13434629dbf5..1b3bb683c014 100644
--- a/arch/parisc/kernel/syscalls/syscall.tbl
+++ b/arch/parisc/kernel/syscalls/syscall.tbl
@@ -133,7 +133,8 @@
 121	common	setdomainname		sys_setdomainname
 122	common	sendfile		sys_sendfile			compat_sys_sendfile
 123	common	recvfrom		sys_recvfrom
-124	common	adjtimex		sys_adjtimex			sys_adjtimex_time32
+124	32	adjtimex		sys_adjtimex_time32
+124	64	adjtimex		sys_adjtimex
 125	common	mprotect		sys_mprotect
 126	common	sigprocmask		sys_sigprocmask			compat_sys_sigprocmask
 # 127 was create_module
@@ -171,8 +172,10 @@
 158	common	sched_yield		sys_sched_yield
 159	common	sched_get_priority_max	sys_sched_get_priority_max
 160	common	sched_get_priority_min	sys_sched_get_priority_min
-161	common	sched_rr_get_interval	sys_sched_rr_get_interval	sys_sched_rr_get_interval_time32
-162	common	nanosleep		sys_nanosleep			sys_nanosleep_time32
+161	32	sched_rr_get_interval	sys_sched_rr_get_interval_time32
+161	64	sched_rr_get_interval	sys_sched_rr_get_interval
+162	32	nanosleep		sys_nanosleep_time32
+162	64	nanosleep		sys_nanosleep
 163	common	mremap			sys_mremap
 164	common	setresuid		sys_setresuid
 165	common	getresuid		sys_getresuid
@@ -187,7 +190,8 @@
 174	common	rt_sigaction		sys_rt_sigaction		compat_sys_rt_sigaction
 175	common	rt_sigprocmask		sys_rt_sigprocmask		compat_sys_rt_sigprocmask
 176	common	rt_sigpending		sys_rt_sigpending		compat_sys_rt_sigpending
-177	common	rt_sigtimedwait		sys_rt_sigtimedwait		compat_sys_rt_sigtimedwait_time32
+177	32	rt_sigtimedwait		sys_rt_sigtimedwait_time32	compat_sys_rt_sigtimedwait_time32
+177	64	rt_sigtimedwait		sys_rt_sigtimedwait
 178	common	rt_sigqueueinfo		sys_rt_sigqueueinfo		compat_sys_rt_sigqueueinfo
 179	common	rt_sigsuspend		sys_rt_sigsuspend		compat_sys_rt_sigsuspend
 180	common	chown			sys_chown
@@ -223,14 +227,16 @@
 207	64	readahead		sys_readahead
 208	common	tkill			sys_tkill
 209	common	sendfile64		sys_sendfile64			compat_sys_sendfile64
-210	common	futex			sys_futex			sys_futex_time32
+210	32	futex			sys_futex_time32
+210	64	futex			sys_futex
 211	common	sched_setaffinity	sys_sched_setaffinity		compat_sys_sched_setaffinity
 212	common	sched_getaffinity	sys_sched_getaffinity		compat_sys_sched_getaffinity
 # 213 was set_thread_area
 # 214 was get_thread_area
 215	common	io_setup		sys_io_setup			compat_sys_io_setup
 216	common	io_destroy		sys_io_destroy
-217	common	io_getevents		sys_io_getevents		sys_io_getevents_time32
+217	32	io_getevents		sys_io_getevents_time32
+217	64	io_getevents		sys_io_getevents
 218	common	io_submit		sys_io_submit			compat_sys_io_submit
 219	common	io_cancel		sys_io_cancel
 # 220 was alloc_hugepages
@@ -241,11 +247,14 @@
 225	common	epoll_ctl		sys_epoll_ctl
 226	common	epoll_wait		sys_epoll_wait
 227	common	remap_file_pages	sys_remap_file_pages
-228	common	semtimedop		sys_semtimedop			sys_semtimedop_time32
+228	32	semtimedop		sys_semtimedop_time32
+228	64	semtimedop		sys_semtimedop
 229	common	mq_open			sys_mq_open			compat_sys_mq_open
 230	common	mq_unlink		sys_mq_unlink
-231	common	mq_timedsend		sys_mq_timedsend		sys_mq_timedsend_time32
-232	common	mq_timedreceive		sys_mq_timedreceive		sys_mq_timedreceive_time32
+231	32	mq_timedsend		sys_mq_timedsend_time32
+231	64	mq_timedsend		sys_mq_timedsend
+232	32	mq_timedreceive		sys_mq_timedreceive_time32
+232	64	mq_timedreceive		sys_mq_timedreceive
 233	common	mq_notify		sys_mq_notify			compat_sys_mq_notify
 234	common	mq_getsetattr		sys_mq_getsetattr		compat_sys_mq_getsetattr
 235	common	waitid			sys_waitid			compat_sys_waitid
@@ -265,14 +274,20 @@
 248	common	lremovexattr		sys_lremovexattr
 249	common	fremovexattr		sys_fremovexattr
 250	common	timer_create		sys_timer_create		compat_sys_timer_create
-251	common	timer_settime		sys_timer_settime		sys_timer_settime32
-252	common	timer_gettime		sys_timer_gettime		sys_timer_gettime32
+251	32	timer_settime		sys_timer_settime32
+251	64	timer_settime		sys_timer_settime
+252	32	timer_gettime		sys_timer_gettime32
+252	64	timer_gettime		sys_timer_gettime
 253	common	timer_getoverrun	sys_timer_getoverrun
 254	common	timer_delete		sys_timer_delete
-255	common	clock_settime		sys_clock_settime		sys_clock_settime32
-256	common	clock_gettime		sys_clock_gettime		sys_clock_gettime32
-257	common	clock_getres		sys_clock_getres		sys_clock_getres_time32
-258	common	clock_nanosleep		sys_clock_nanosleep		sys_clock_nanosleep_time32
+255	32	clock_settime		sys_clock_settime32
+255	64	clock_settime		sys_clock_settime
+256	32	clock_gettime		sys_clock_gettime32
+256	64	clock_gettime		sys_clock_gettime
+257	32	clock_getres		sys_clock_getres_time32
+257	64	clock_getres		sys_clock_getres
+258	32	clock_nanosleep		sys_clock_nanosleep_time32
+258	64	clock_nanosleep		sys_clock_nanosleep
 259	common	tgkill			sys_tgkill
 260	common	mbind			sys_mbind			compat_sys_mbind
 261	common	get_mempolicy		sys_get_mempolicy		compat_sys_get_mempolicy
@@ -287,8 +302,10 @@
 270	common	inotify_add_watch	sys_inotify_add_watch
 271	common	inotify_rm_watch	sys_inotify_rm_watch
 272	common	migrate_pages		sys_migrate_pages
-273	common	pselect6		sys_pselect6			compat_sys_pselect6_time32
-274	common	ppoll			sys_ppoll			compat_sys_ppoll_time32
+273	32	pselect6		sys_pselect6_time32		compat_sys_pselect6_time32
+273	64	pselect6		sys_pselect6
+274	32	ppoll			sys_ppoll_time32		compat_sys_ppoll_time32
+274	64	ppoll			sys_ppoll
 275	common	openat			sys_openat			compat_sys_openat
 276	common	mkdirat			sys_mkdirat
 277	common	mknodat			sys_mknodat
@@ -316,15 +333,18 @@
 298	common	statfs64		sys_statfs64			compat_sys_statfs64
 299	common	fstatfs64		sys_fstatfs64			compat_sys_fstatfs64
 300	common	kexec_load		sys_kexec_load			compat_sys_kexec_load
-301	common	utimensat		sys_utimensat			sys_utimensat_time32
+301	32	utimensat		sys_utimensat_time32
+301	64	utimensat		sys_utimensat
 302	common	signalfd		sys_signalfd			compat_sys_signalfd
 # 303 was timerfd
 304	common	eventfd			sys_eventfd
 305	32	fallocate		parisc_fallocate
 305	64	fallocate		sys_fallocate
 306	common	timerfd_create		sys_timerfd_create
-307	common	timerfd_settime		sys_timerfd_settime		sys_timerfd_settime32
-308	common	timerfd_gettime		sys_timerfd_gettime		sys_timerfd_gettime32
+307	32	timerfd_settime		sys_timerfd_settime32
+307	64	timerfd_settime		sys_timerfd_settime
+308	32	timerfd_gettime		sys_timerfd_gettime32
+308	64	timerfd_gettime		sys_timerfd_gettime
 309	common	signalfd4		sys_signalfd4			compat_sys_signalfd4
 310	common	eventfd2		sys_eventfd2
 311	common	epoll_create1		sys_epoll_create1
@@ -335,12 +355,14 @@
 316	common	pwritev	sys_pwritev	compat_sys_pwritev
 317	common	rt_tgsigqueueinfo	sys_rt_tgsigqueueinfo		compat_sys_rt_tgsigqueueinfo
 318	common	perf_event_open		sys_perf_event_open
-319	common	recvmmsg		sys_recvmmsg			compat_sys_recvmmsg_time32
+319	32	recvmmsg		sys_recvmmsg_time32		compat_sys_recvmmsg_time32
+319	64	recvmmsg		sys_recvmmsg
 320	common	accept4			sys_accept4
 321	common	prlimit64		sys_prlimit64
 322	common	fanotify_init		sys_fanotify_init
 323	common	fanotify_mark		sys_fanotify_mark		sys32_fanotify_mark
-324	common	clock_adjtime		sys_clock_adjtime		sys_clock_adjtime32
+324	32	clock_adjtime		sys_clock_adjtime32
+324	64	clock_adjtime		sys_clock_adjtime
 325	common	name_to_handle_at	sys_name_to_handle_at
 326	common	open_by_handle_at	sys_open_by_handle_at		compat_sys_open_by_handle_at
 327	common	syncfs			sys_syncfs
@@ -366,7 +388,8 @@
 347	common	preadv2			sys_preadv2			compat_sys_preadv2
 348	common	pwritev2		sys_pwritev2			compat_sys_pwritev2
 349	common	statx			sys_statx
-350	common	io_pgetevents		sys_io_pgetevents		compat_sys_io_pgetevents
+350	32	io_pgetevents		sys_io_pgetevents_time32	compat_sys_io_pgetevents
+350	64	io_pgetevents		sys_io_pgetevents
 351	common	pkey_alloc		sys_pkey_alloc
 352	common	pkey_free		sys_pkey_free
 353	common	pkey_mprotect		sys_pkey_mprotect
diff --git a/arch/powerpc/kernel/syscalls/syscall.tbl b/arch/powerpc/kernel/syscalls/syscall.tbl
index 86650dcd2185..2a8b060f73b3 100644
--- a/arch/powerpc/kernel/syscalls/syscall.tbl
+++ b/arch/powerpc/kernel/syscalls/syscall.tbl
@@ -157,7 +157,9 @@
 121	common	setdomainname			sys_setdomainname
 122	common	uname				sys_newuname
 123	common	modify_ldt			sys_ni_syscall
-124	common	adjtimex			sys_adjtimex			sys_adjtimex_time32
+124	32	adjtimex			sys_adjtimex_time32
+124	64	adjtimex			sys_adjtimex
+124	spu	adjtimex			sys_adjtimex
 125	common	mprotect			sys_mprotect
 126	32	sigprocmask			sys_sigprocmask			compat_sys_sigprocmask
 126	64	sigprocmask			sys_ni_syscall
@@ -198,8 +200,12 @@
 158	common	sched_yield			sys_sched_yield
 159	common	sched_get_priority_max		sys_sched_get_priority_max
 160	common	sched_get_priority_min		sys_sched_get_priority_min
-161	common	sched_rr_get_interval		sys_sched_rr_get_interval	sys_sched_rr_get_interval_time32
-162	common	nanosleep			sys_nanosleep			sys_nanosleep_time32
+161	32	sched_rr_get_interval		sys_sched_rr_get_interval_time32
+161	64	sched_rr_get_interval		sys_sched_rr_get_interval
+161	spu	sched_rr_get_interval		sys_sched_rr_get_interval
+162	32	nanosleep			sys_nanosleep_time32
+162	64	nanosleep			sys_nanosleep
+162	spu	nanosleep			sys_nanosleep
 163	common	mremap				sys_mremap
 164	common	setresuid			sys_setresuid
 165	common	getresuid			sys_getresuid
@@ -213,7 +219,8 @@
 173	nospu	rt_sigaction			sys_rt_sigaction		compat_sys_rt_sigaction
 174	nospu	rt_sigprocmask			sys_rt_sigprocmask		compat_sys_rt_sigprocmask
 175	nospu	rt_sigpending			sys_rt_sigpending		compat_sys_rt_sigpending
-176	nospu	rt_sigtimedwait			sys_rt_sigtimedwait		compat_sys_rt_sigtimedwait_time32
+176	32	rt_sigtimedwait			sys_rt_sigtimedwait_time32	compat_sys_rt_sigtimedwait_time32
+176	64	rt_sigtimedwait			sys_rt_sigtimedwait
 177	nospu 	rt_sigqueueinfo			sys_rt_sigqueueinfo		compat_sys_rt_sigqueueinfo
 178	nospu 	rt_sigsuspend			sys_rt_sigsuspend		compat_sys_rt_sigsuspend
 179	common	pread64				sys_pread64			compat_sys_pread64
@@ -260,7 +267,9 @@
 218	common	removexattr			sys_removexattr
 219	common	lremovexattr			sys_lremovexattr
 220	common	fremovexattr			sys_fremovexattr
-221	common	futex				sys_futex			sys_futex_time32
+221	32	futex				sys_futex_time32
+221	64	futex				sys_futex
+221	spu	futex				sys_futex
 222	common	sched_setaffinity		sys_sched_setaffinity		compat_sys_sched_setaffinity
 223	common	sched_getaffinity		sys_sched_getaffinity		compat_sys_sched_getaffinity
 # 224 unused
@@ -268,7 +277,9 @@
 226	32	sendfile64			sys_sendfile64			compat_sys_sendfile64
 227	common	io_setup			sys_io_setup			compat_sys_io_setup
 228	common	io_destroy			sys_io_destroy
-229	common	io_getevents			sys_io_getevents		sys_io_getevents_time32
+229	32	io_getevents			sys_io_getevents_time32
+229	64	io_getevents			sys_io_getevents
+229	spu	io_getevents			sys_io_getevents
 230	common	io_submit			sys_io_submit			compat_sys_io_submit
 231	common	io_cancel			sys_io_cancel
 232	nospu	set_tid_address			sys_set_tid_address
@@ -280,14 +291,26 @@
 238	common	epoll_wait			sys_epoll_wait
 239	common	remap_file_pages		sys_remap_file_pages
 240	common	timer_create			sys_timer_create		compat_sys_timer_create
-241	common	timer_settime			sys_timer_settime		sys_timer_settime32
-242	common	timer_gettime			sys_timer_gettime		sys_timer_gettime32
+241	32	timer_settime			sys_timer_settime32
+241	64	timer_settime			sys_timer_settime
+241	spu	timer_settime			sys_timer_settime
+242	32	timer_gettime			sys_timer_gettime32
+242	64	timer_gettime			sys_timer_gettime
+242	spu	timer_gettime			sys_timer_gettime
 243	common	timer_getoverrun		sys_timer_getoverrun
 244	common	timer_delete			sys_timer_delete
-245	common	clock_settime			sys_clock_settime		sys_clock_settime32
-246	common	clock_gettime			sys_clock_gettime		sys_clock_gettime32
-247	common	clock_getres			sys_clock_getres		sys_clock_getres_time32
-248	common	clock_nanosleep			sys_clock_nanosleep		sys_clock_nanosleep_time32
+245	32	clock_settime			sys_clock_settime32
+245	64	clock_settime			sys_clock_settime
+245	spu	clock_settime			sys_clock_settime
+246	32	clock_gettime			sys_clock_gettime32
+246	64	clock_gettime			sys_clock_gettime
+246	spu	clock_gettime			sys_clock_gettime
+247	32	clock_getres			sys_clock_getres_time32
+247	64	clock_getres			sys_clock_getres
+247	spu	clock_getres			sys_clock_getres
+248	32	clock_nanosleep			sys_clock_nanosleep_time32
+248	64	clock_nanosleep			sys_clock_nanosleep
+248	spu	clock_nanosleep			sys_clock_nanosleep
 249	32	swapcontext			ppc_swapcontext			ppc32_swapcontext
 249	64	swapcontext			ppc64_swapcontext
 249	spu	swapcontext			sys_ni_syscall
@@ -308,8 +331,10 @@
 261	nospu	set_mempolicy			sys_set_mempolicy		compat_sys_set_mempolicy
 262	nospu	mq_open				sys_mq_open			compat_sys_mq_open
 263	nospu	mq_unlink			sys_mq_unlink
-264	nospu	mq_timedsend			sys_mq_timedsend		sys_mq_timedsend_time32
-265	nospu	mq_timedreceive			sys_mq_timedreceive		sys_mq_timedreceive_time32
+264	32	mq_timedsend			sys_mq_timedsend_time32
+264	64	mq_timedsend			sys_mq_timedsend
+265	32	mq_timedreceive			sys_mq_timedreceive_time32
+265	64	mq_timedreceive			sys_mq_timedreceive
 266	nospu	mq_notify			sys_mq_notify			compat_sys_mq_notify
 267	nospu	mq_getsetattr			sys_mq_getsetattr		compat_sys_mq_getsetattr
 268	nospu	kexec_load			sys_kexec_load			compat_sys_kexec_load
@@ -324,8 +349,10 @@
 277	nospu	inotify_rm_watch		sys_inotify_rm_watch
 278	nospu	spu_run				sys_spu_run
 279	nospu	spu_create			sys_spu_create
-280	nospu	pselect6			sys_pselect6			compat_sys_pselect6_time32
-281	nospu	ppoll				sys_ppoll			compat_sys_ppoll_time32
+280	32	pselect6			sys_pselect6_time32		compat_sys_pselect6_time32
+280	64	pselect6			sys_pselect6
+281	32	ppoll				sys_ppoll_time32		compat_sys_ppoll_time32
+281	64	ppoll				sys_ppoll
 282	common	unshare				sys_unshare
 283	common	splice				sys_splice
 284	common	tee				sys_tee
@@ -350,15 +377,21 @@
 301	common	move_pages			sys_move_pages			compat_sys_move_pages
 302	common	getcpu				sys_getcpu
 303	nospu	epoll_pwait			sys_epoll_pwait			compat_sys_epoll_pwait
-304	common	utimensat			sys_utimensat			sys_utimensat_time32
+304	32	utimensat			sys_utimensat_time32
+304	64	utimensat			sys_utimensat
+304	spu	utimensat			sys_utimensat
 305	common	signalfd			sys_signalfd			compat_sys_signalfd
 306	common	timerfd_create			sys_timerfd_create
 307	common	eventfd				sys_eventfd
 308	common	sync_file_range2		sys_sync_file_range2		compat_sys_sync_file_range2
 309	nospu	fallocate			sys_fallocate			compat_sys_fallocate
 310	nospu	subpage_prot			sys_subpage_prot
-311	common	timerfd_settime			sys_timerfd_settime		sys_timerfd_settime32
-312	common	timerfd_gettime			sys_timerfd_gettime		sys_timerfd_gettime32
+311	32	timerfd_settime			sys_timerfd_settime32
+311	64	timerfd_settime			sys_timerfd_settime
+311	spu	timerfd_settime			sys_timerfd_settime
+312	32	timerfd_gettime			sys_timerfd_gettime32
+312	64	timerfd_gettime			sys_timerfd_gettime
+312	spu	timerfd_gettime			sys_timerfd_gettime
 313	common	signalfd4			sys_signalfd4			compat_sys_signalfd4
 314	common	eventfd2			sys_eventfd2
 315	common	epoll_create1			sys_epoll_create1
@@ -389,11 +422,15 @@
 340	common	getsockopt			sys_getsockopt			compat_sys_getsockopt
 341	common	sendmsg				sys_sendmsg			compat_sys_sendmsg
 342	common	recvmsg				sys_recvmsg			compat_sys_recvmsg
-343	common	recvmmsg			sys_recvmmsg			compat_sys_recvmmsg_time32
+343	32	recvmmsg			sys_recvmmsg_time32		compat_sys_recvmmsg_time32
+343	64	recvmmsg			sys_recvmmsg
+343	spu	recvmmsg			sys_recvmmsg
 344	common	accept4				sys_accept4
 345	common	name_to_handle_at		sys_name_to_handle_at
 346	common	open_by_handle_at		sys_open_by_handle_at		compat_sys_open_by_handle_at
-347	common	clock_adjtime			sys_clock_adjtime		sys_clock_adjtime32
+347	32	clock_adjtime			sys_clock_adjtime32
+347	64	clock_adjtime			sys_clock_adjtime
+347	spu	clock_adjtime			sys_clock_adjtime
 348	common	syncfs				sys_syncfs
 349	common	sendmmsg			sys_sendmmsg			compat_sys_sendmmsg
 350	common	setns				sys_setns
@@ -425,7 +462,8 @@
 385	nospu	pkey_free			sys_pkey_free
 386	nospu	pkey_mprotect			sys_pkey_mprotect
 387	nospu	rseq				sys_rseq
-388	nospu	io_pgetevents			sys_io_pgetevents		compat_sys_io_pgetevents
+388	32	io_pgetevents			sys_io_pgetevents_time32	compat_sys_io_pgetevents
+388	64	io_pgetevents			sys_io_pgetevents
 # room for arch specific syscalls
 392	64	semtimedop			sys_semtimedop
 393	common	semget				sys_semget
diff --git a/arch/sh/kernel/syscalls/syscall.tbl b/arch/sh/kernel/syscalls/syscall.tbl
index 3f96ad0424e1..e6a18d3db6ac 100644
--- a/arch/sh/kernel/syscalls/syscall.tbl
+++ b/arch/sh/kernel/syscalls/syscall.tbl
@@ -131,7 +131,7 @@
 121	common	setdomainname			sys_setdomainname
 122	common	uname				sys_newuname
 123	common	cacheflush			sys_cacheflush
-124	common	adjtimex			sys_adjtimex
+124	common	adjtimex			sys_adjtimex_time32
 125	common	mprotect			sys_mprotect
 126	common	sigprocmask			sys_sigprocmask
 # 127 was create_module
@@ -168,8 +168,8 @@
 158	common	sched_yield			sys_sched_yield
 159	common	sched_get_priority_max		sys_sched_get_priority_max
 160	common	sched_get_priority_min		sys_sched_get_priority_min
-161	common	sched_rr_get_interval		sys_sched_rr_get_interval
-162	common	nanosleep			sys_nanosleep
+161	common	sched_rr_get_interval		sys_sched_rr_get_interval_time32
+162	common	nanosleep			sys_nanosleep_time32
 163	common	mremap				sys_mremap
 164	common	setresuid			sys_setresuid16
 165	common	getresuid			sys_getresuid16
@@ -184,7 +184,7 @@
 174	common	rt_sigaction			sys_rt_sigaction
 175	common	rt_sigprocmask			sys_rt_sigprocmask
 176	common	rt_sigpending			sys_rt_sigpending
-177	common	rt_sigtimedwait			sys_rt_sigtimedwait
+177	common	rt_sigtimedwait			sys_rt_sigtimedwait_time32
 178	common	rt_sigqueueinfo			sys_rt_sigqueueinfo
 179	common	rt_sigsuspend			sys_rt_sigsuspend
 180	common	pread64				sys_pread_wrapper
@@ -247,14 +247,14 @@
 237	common	fremovexattr			sys_fremovexattr
 238	common	tkill				sys_tkill
 239	common	sendfile64			sys_sendfile64
-240	common	futex				sys_futex
+240	common	futex				sys_futex_time32
 241	common	sched_setaffinity		sys_sched_setaffinity
 242	common	sched_getaffinity		sys_sched_getaffinity
 # 243 is reserved for set_thread_area
 # 244 is reserved for get_thread_area
 245	common	io_setup			sys_io_setup
 246	common	io_destroy			sys_io_destroy
-247	common	io_getevents			sys_io_getevents
+247	common	io_getevents			sys_io_getevents_time32
 248	common	io_submit			sys_io_submit
 249	common	io_cancel			sys_io_cancel
 250	common	fadvise64			sys_fadvise64
@@ -267,14 +267,14 @@
 257	common	remap_file_pages		sys_remap_file_pages
 258	common	set_tid_address			sys_set_tid_address
 259	common	timer_create			sys_timer_create
-260	common	timer_settime			sys_timer_settime
-261	common	timer_gettime			sys_timer_gettime
+260	common	timer_settime			sys_timer_settime32
+261	common	timer_gettime			sys_timer_gettime32
 262	common	timer_getoverrun		sys_timer_getoverrun
 263	common	timer_delete			sys_timer_delete
-264	common	clock_settime			sys_clock_settime
-265	common	clock_gettime			sys_clock_gettime
-266	common	clock_getres			sys_clock_getres
-267	common	clock_nanosleep			sys_clock_nanosleep
+264	common	clock_settime			sys_clock_settime32
+265	common	clock_gettime			sys_clock_gettime32
+266	common	clock_getres			sys_clock_getres_time32
+267	common	clock_nanosleep			sys_clock_nanosleep_time32
 268	common	statfs64			sys_statfs64
 269	common	fstatfs64			sys_fstatfs64
 270	common	tgkill				sys_tgkill
@@ -286,8 +286,8 @@
 276	common	set_mempolicy			sys_set_mempolicy
 277	common	mq_open				sys_mq_open
 278	common	mq_unlink			sys_mq_unlink
-279	common	mq_timedsend			sys_mq_timedsend
-280	common	mq_timedreceive			sys_mq_timedreceive
+279	common	mq_timedsend			sys_mq_timedsend_time32
+280	common	mq_timedreceive			sys_mq_timedreceive_time32
 281	common	mq_notify			sys_mq_notify
 282	common	mq_getsetattr			sys_mq_getsetattr
 283	common	kexec_load			sys_kexec_load
@@ -315,8 +315,8 @@
 305	common	readlinkat			sys_readlinkat
 306	common	fchmodat			sys_fchmodat
 307	common	faccessat			sys_faccessat
-308	common	pselect6			sys_pselect6
-309	common	ppoll				sys_ppoll
+308	common	pselect6			sys_pselect6_time32
+309	common	ppoll				sys_ppoll_time32
 310	common	unshare				sys_unshare
 311	common	set_robust_list			sys_set_robust_list
 312	common	get_robust_list			sys_get_robust_list
@@ -327,13 +327,13 @@
 317	common	move_pages			sys_move_pages
 318	common	getcpu				sys_getcpu
 319	common	epoll_pwait			sys_epoll_pwait
-320	common	utimensat			sys_utimensat
+320	common	utimensat			sys_utimensat_time32
 321	common	signalfd			sys_signalfd
 322	common	timerfd_create			sys_timerfd_create
 323	common	eventfd				sys_eventfd
 324	common	fallocate			sys_fallocate
-325	common	timerfd_settime			sys_timerfd_settime
-326	common	timerfd_gettime			sys_timerfd_gettime
+325	common	timerfd_settime			sys_timerfd_settime32
+326	common	timerfd_gettime			sys_timerfd_gettime32
 327	common	signalfd4			sys_signalfd4
 328	common	eventfd2			sys_eventfd2
 329	common	epoll_create1			sys_epoll_create1
@@ -364,11 +364,11 @@
 354	common	getsockopt			sys_getsockopt
 355	common	sendmsg				sys_sendmsg
 356	common	recvmsg				sys_recvmsg
-357	common	recvmmsg			sys_recvmmsg
+357	common	recvmmsg			sys_recvmmsg_time32
 358	common	accept4				sys_accept4
 359	common	name_to_handle_at		sys_name_to_handle_at
 360	common	open_by_handle_at		sys_open_by_handle_at
-361	common	clock_adjtime			sys_clock_adjtime
+361	common	clock_adjtime			sys_clock_adjtime32
 362	common	syncfs				sys_syncfs
 363	common	sendmmsg			sys_sendmmsg
 364	common	setns				sys_setns
diff --git a/arch/sparc/kernel/syscalls/syscall.tbl b/arch/sparc/kernel/syscalls/syscall.tbl
index 45ff53ee8e54..29b77f3bf2b7 100644
--- a/arch/sparc/kernel/syscalls/syscall.tbl
+++ b/arch/sparc/kernel/syscalls/syscall.tbl
@@ -128,7 +128,8 @@
 102	common	rt_sigaction		sys_rt_sigaction		compat_sys_rt_sigaction
 103	common	rt_sigprocmask		sys_rt_sigprocmask		compat_sys_rt_sigprocmask
 104	common	rt_sigpending		sys_rt_sigpending		compat_sys_rt_sigpending
-105	common	rt_sigtimedwait		sys_rt_sigtimedwait		compat_sys_rt_sigtimedwait_time32
+105	32	rt_sigtimedwait		sys_rt_sigtimedwait_time32	compat_sys_rt_sigtimedwait_time32
+105	64	rt_sigtimedwait		sys_rt_sigtimedwait
 106	common	rt_sigqueueinfo		sys_rt_sigqueueinfo		compat_sys_rt_sigqueueinfo
 107	common	rt_sigsuspend		sys_rt_sigsuspend		compat_sys_rt_sigsuspend
 108	32	setresuid32		sys_setresuid
@@ -172,7 +173,8 @@
 139	common	stat64			sys_stat64			compat_sys_stat64
 140	common	sendfile64		sys_sendfile64
 141	common	getpeername		sys_getpeername
-142	common	futex			sys_futex			sys_futex_time32
+142	32	futex			sys_futex_time32
+142	64	futex			sys_futex
 143	common	gettid			sys_gettid
 144	common	getrlimit		sys_getrlimit			compat_sys_getrlimit
 145	common	setrlimit		sys_setrlimit			compat_sys_setrlimit
@@ -258,7 +260,7 @@
 216	64	sigreturn		sys_nis_syscall
 217	common	clone			sys_clone
 218	common	ioprio_get		sys_ioprio_get
-219	32	adjtimex		sys_adjtimex			sys_adjtimex_time32
+219	32	adjtimex		sys_adjtimex_time32
 219	64	adjtimex		sys_sparc_adjtimex
 220	32	sigprocmask		sys_sigprocmask			compat_sys_sigprocmask
 220	64	sigprocmask		sys_nis_syscall
@@ -289,8 +291,10 @@
 245	common	sched_yield		sys_sched_yield
 246	common	sched_get_priority_max	sys_sched_get_priority_max
 247	common	sched_get_priority_min	sys_sched_get_priority_min
-248	common	sched_rr_get_interval	sys_sched_rr_get_interval	sys_sched_rr_get_interval_time32
-249	common	nanosleep		sys_nanosleep			sys_nanosleep_time32
+248	32	sched_rr_get_interval	sys_sched_rr_get_interval_time32
+248	64	sched_rr_get_interval	sys_sched_rr_get_interval
+249	32	nanosleep		sys_nanosleep_time32
+249	64	nanosleep		sys_nanosleep
 250	32	mremap			sys_mremap
 250	64	mremap			sys_64_mremap
 251	common	_sysctl			sys_sysctl			compat_sys_sysctl
@@ -299,14 +303,20 @@
 254	32	nfsservctl		sys_ni_syscall			sys_nis_syscall
 254	64	nfsservctl		sys_nis_syscall
 255	common	sync_file_range		sys_sync_file_range		compat_sys_sync_file_range
-256	common	clock_settime		sys_clock_settime		sys_clock_settime32
-257	common	clock_gettime		sys_clock_gettime		sys_clock_gettime32
-258	common	clock_getres		sys_clock_getres		sys_clock_getres_time32
-259	common	clock_nanosleep		sys_clock_nanosleep		sys_clock_nanosleep_time32
+256	32	clock_settime		sys_clock_settime32
+256	64	clock_settime		sys_clock_settime
+257	32	clock_gettime		sys_clock_gettime32
+257	64	clock_gettime		sys_clock_gettime
+258	32	clock_getres		sys_clock_getres_time32
+258	64	clock_getres		sys_clock_getres
+259	32	clock_nanosleep		sys_clock_nanosleep_time32
+259	64	clock_nanosleep		sys_clock_nanosleep
 260	common	sched_getaffinity	sys_sched_getaffinity		compat_sys_sched_getaffinity
 261	common	sched_setaffinity	sys_sched_setaffinity		compat_sys_sched_setaffinity
-262	common	timer_settime		sys_timer_settime		sys_timer_settime32
-263	common	timer_gettime		sys_timer_gettime		sys_timer_gettime32
+262	32	timer_settime		sys_timer_settime32
+262	64	timer_settime		sys_timer_settime
+263	32	timer_gettime		sys_timer_gettime32
+263	64	timer_gettime		sys_timer_gettime
 264	common	timer_getoverrun	sys_timer_getoverrun
 265	common	timer_delete		sys_timer_delete
 266	common	timer_create		sys_timer_create		compat_sys_timer_create
@@ -316,11 +326,14 @@
 269	common	io_destroy		sys_io_destroy
 270	common	io_submit		sys_io_submit			compat_sys_io_submit
 271	common	io_cancel		sys_io_cancel
-272	common	io_getevents		sys_io_getevents		sys_io_getevents_time32
+272	32	io_getevents		sys_io_getevents_time32
+272	64	io_getevents		sys_io_getevents
 273	common	mq_open			sys_mq_open			compat_sys_mq_open
 274	common	mq_unlink		sys_mq_unlink
-275	common	mq_timedsend		sys_mq_timedsend		sys_mq_timedsend_time32
-276	common	mq_timedreceive		sys_mq_timedreceive		sys_mq_timedreceive_time32
+275	32	mq_timedsend		sys_mq_timedsend_time32
+275	64	mq_timedsend		sys_mq_timedsend
+276	32	mq_timedreceive		sys_mq_timedreceive_time32
+276	64	mq_timedreceive		sys_mq_timedreceive
 277	common	mq_notify		sys_mq_notify			compat_sys_mq_notify
 278	common	mq_getsetattr		sys_mq_getsetattr		compat_sys_mq_getsetattr
 279	common	waitid			sys_waitid			compat_sys_waitid
@@ -341,8 +354,10 @@
 294	common	readlinkat		sys_readlinkat
 295	common	fchmodat		sys_fchmodat
 296	common	faccessat		sys_faccessat
-297	common	pselect6		sys_pselect6			compat_sys_pselect6_time32
-298	common	ppoll			sys_ppoll			compat_sys_ppoll_time32
+297	32	pselect6		sys_pselect6_time32		compat_sys_pselect6_time32
+297	64	pselect6		sys_pselect6
+298	32	ppoll			sys_ppoll_time32		compat_sys_ppoll_time32
+298	64	ppoll			sys_ppoll
 299	common	unshare			sys_unshare
 300	common	set_robust_list		sys_set_robust_list		compat_sys_set_robust_list
 301	common	get_robust_list		sys_get_robust_list		compat_sys_get_robust_list
@@ -354,13 +369,16 @@
 307	common	move_pages		sys_move_pages			compat_sys_move_pages
 308	common	getcpu			sys_getcpu
 309	common	epoll_pwait		sys_epoll_pwait			compat_sys_epoll_pwait
-310	common	utimensat		sys_utimensat			sys_utimensat_time32
+310	32	utimensat		sys_utimensat_time32
+310	64	utimensat		sys_utimensat
 311	common	signalfd		sys_signalfd			compat_sys_signalfd
 312	common	timerfd_create		sys_timerfd_create
 313	common	eventfd			sys_eventfd
 314	common	fallocate		sys_fallocate			compat_sys_fallocate
-315	common	timerfd_settime		sys_timerfd_settime		sys_timerfd_settime32
-316	common	timerfd_gettime		sys_timerfd_gettime		sys_timerfd_gettime32
+315	32	timerfd_settime		sys_timerfd_settime32
+315	64	timerfd_settime		sys_timerfd_settime
+316	32	timerfd_gettime		sys_timerfd_gettime32
+316	64	timerfd_gettime		sys_timerfd_gettime
 317	common	signalfd4		sys_signalfd4			compat_sys_signalfd4
 318	common	eventfd2		sys_eventfd2
 319	common	epoll_create1		sys_epoll_create1
@@ -372,13 +390,14 @@
 325	common	pwritev			sys_pwritev			compat_sys_pwritev
 326	common	rt_tgsigqueueinfo	sys_rt_tgsigqueueinfo		compat_sys_rt_tgsigqueueinfo
 327	common	perf_event_open		sys_perf_event_open
-328	common	recvmmsg		sys_recvmmsg			compat_sys_recvmmsg_time32
+328	32	recvmmsg		sys_recvmmsg_time32		compat_sys_recvmmsg_time32
+328	64	recvmmsg		sys_recvmmsg
 329	common	fanotify_init		sys_fanotify_init
 330	common	fanotify_mark		sys_fanotify_mark		compat_sys_fanotify_mark
 331	common	prlimit64		sys_prlimit64
 332	common	name_to_handle_at	sys_name_to_handle_at
 333	common	open_by_handle_at	sys_open_by_handle_at		compat_sys_open_by_handle_at
-334	32	clock_adjtime		sys_clock_adjtime		sys_clock_adjtime32
+334	32	clock_adjtime		sys_clock_adjtime32
 334	64	clock_adjtime		sys_sparc_clock_adjtime
 335	common	syncfs			sys_syncfs
 336	common	sendmmsg		sys_sendmmsg			compat_sys_sendmmsg
@@ -408,7 +427,8 @@
 358	common	preadv2			sys_preadv2			compat_sys_preadv2
 359	common	pwritev2		sys_pwritev2			compat_sys_pwritev2
 360	common	statx			sys_statx
-361	common	io_pgetevents		sys_io_pgetevents		compat_sys_io_pgetevents
+361	32	io_pgetevents		sys_io_pgetevents_time32	compat_sys_io_pgetevents
+361	64	io_pgetevents		sys_io_pgetevents
 362	common	pkey_alloc		sys_pkey_alloc
 363	common	pkey_free		sys_pkey_free
 364	common	pkey_mprotect		sys_pkey_mprotect
diff --git a/arch/x86/entry/syscalls/syscall_32.tbl b/arch/x86/entry/syscalls/syscall_32.tbl
index b2f92f75948d..35c7a1ebdf3d 100644
--- a/arch/x86/entry/syscalls/syscall_32.tbl
+++ b/arch/x86/entry/syscalls/syscall_32.tbl
@@ -135,7 +135,7 @@
 121	i386	setdomainname		sys_setdomainname		__ia32_sys_setdomainname
 122	i386	uname			sys_newuname			__ia32_sys_newuname
 123	i386	modify_ldt		sys_modify_ldt			__ia32_sys_modify_ldt
-124	i386	adjtimex		sys_adjtimex			__ia32_sys_adjtimex_time32
+124	i386	adjtimex		sys_adjtimex_time32			__ia32_sys_adjtimex_time32
 125	i386	mprotect		sys_mprotect			__ia32_sys_mprotect
 126	i386	sigprocmask		sys_sigprocmask			__ia32_compat_sys_sigprocmask
 127	i386	create_module
@@ -172,8 +172,8 @@
 158	i386	sched_yield		sys_sched_yield			__ia32_sys_sched_yield
 159	i386	sched_get_priority_max	sys_sched_get_priority_max	__ia32_sys_sched_get_priority_max
 160	i386	sched_get_priority_min	sys_sched_get_priority_min	__ia32_sys_sched_get_priority_min
-161	i386	sched_rr_get_interval	sys_sched_rr_get_interval	__ia32_sys_sched_rr_get_interval_time32
-162	i386	nanosleep		sys_nanosleep			__ia32_sys_nanosleep_time32
+161	i386	sched_rr_get_interval	sys_sched_rr_get_interval_time32	__ia32_sys_sched_rr_get_interval_time32
+162	i386	nanosleep		sys_nanosleep_time32		__ia32_sys_nanosleep_time32
 163	i386	mremap			sys_mremap			__ia32_sys_mremap
 164	i386	setresuid		sys_setresuid16			__ia32_sys_setresuid16
 165	i386	getresuid		sys_getresuid16			__ia32_sys_getresuid16
@@ -188,7 +188,7 @@
 174	i386	rt_sigaction		sys_rt_sigaction		__ia32_compat_sys_rt_sigaction
 175	i386	rt_sigprocmask		sys_rt_sigprocmask		__ia32_sys_rt_sigprocmask
 176	i386	rt_sigpending		sys_rt_sigpending		__ia32_compat_sys_rt_sigpending
-177	i386	rt_sigtimedwait		sys_rt_sigtimedwait		__ia32_compat_sys_rt_sigtimedwait_time32
+177	i386	rt_sigtimedwait		sys_rt_sigtimedwait_time32	__ia32_compat_sys_rt_sigtimedwait_time32
 178	i386	rt_sigqueueinfo		sys_rt_sigqueueinfo		__ia32_compat_sys_rt_sigqueueinfo
 179	i386	rt_sigsuspend		sys_rt_sigsuspend		__ia32_sys_rt_sigsuspend
 180	i386	pread64			sys_pread64			__ia32_compat_sys_x86_pread
@@ -251,14 +251,14 @@
 237	i386	fremovexattr		sys_fremovexattr		__ia32_sys_fremovexattr
 238	i386	tkill			sys_tkill			__ia32_sys_tkill
 239	i386	sendfile64		sys_sendfile64			__ia32_sys_sendfile64
-240	i386	futex			sys_futex			__ia32_sys_futex_time32
+240	i386	futex			sys_futex_time32		__ia32_sys_futex_time32
 241	i386	sched_setaffinity	sys_sched_setaffinity		__ia32_compat_sys_sched_setaffinity
 242	i386	sched_getaffinity	sys_sched_getaffinity		__ia32_compat_sys_sched_getaffinity
 243	i386	set_thread_area		sys_set_thread_area		__ia32_sys_set_thread_area
 244	i386	get_thread_area		sys_get_thread_area		__ia32_sys_get_thread_area
 245	i386	io_setup		sys_io_setup			__ia32_compat_sys_io_setup
 246	i386	io_destroy		sys_io_destroy			__ia32_sys_io_destroy
-247	i386	io_getevents		sys_io_getevents		__ia32_sys_io_getevents_time32
+247	i386	io_getevents		sys_io_getevents_time32		__ia32_sys_io_getevents_time32
 248	i386	io_submit		sys_io_submit			__ia32_compat_sys_io_submit
 249	i386	io_cancel		sys_io_cancel			__ia32_sys_io_cancel
 250	i386	fadvise64		sys_fadvise64			__ia32_compat_sys_x86_fadvise64
@@ -271,14 +271,14 @@
 257	i386	remap_file_pages	sys_remap_file_pages		__ia32_sys_remap_file_pages
 258	i386	set_tid_address		sys_set_tid_address		__ia32_sys_set_tid_address
 259	i386	timer_create		sys_timer_create		__ia32_compat_sys_timer_create
-260	i386	timer_settime		sys_timer_settime		__ia32_sys_timer_settime32
-261	i386	timer_gettime		sys_timer_gettime		__ia32_sys_timer_gettime32
+260	i386	timer_settime		sys_timer_settime32		__ia32_sys_timer_settime32
+261	i386	timer_gettime		sys_timer_gettime32		__ia32_sys_timer_gettime32
 262	i386	timer_getoverrun	sys_timer_getoverrun		__ia32_sys_timer_getoverrun
 263	i386	timer_delete		sys_timer_delete		__ia32_sys_timer_delete
-264	i386	clock_settime		sys_clock_settime		__ia32_sys_clock_settime32
-265	i386	clock_gettime		sys_clock_gettime		__ia32_sys_clock_gettime32
-266	i386	clock_getres		sys_clock_getres		__ia32_sys_clock_getres_time32
-267	i386	clock_nanosleep		sys_clock_nanosleep		__ia32_sys_clock_nanosleep_time32
+264	i386	clock_settime		sys_clock_settime32		__ia32_sys_clock_settime32
+265	i386	clock_gettime		sys_clock_gettime32		__ia32_sys_clock_gettime32
+266	i386	clock_getres		sys_clock_getres_time32		__ia32_sys_clock_getres_time32
+267	i386	clock_nanosleep		sys_clock_nanosleep_time32	__ia32_sys_clock_nanosleep_time32
 268	i386	statfs64		sys_statfs64			__ia32_compat_sys_statfs64
 269	i386	fstatfs64		sys_fstatfs64			__ia32_compat_sys_fstatfs64
 270	i386	tgkill			sys_tgkill			__ia32_sys_tgkill
@@ -290,8 +290,8 @@
 276	i386	set_mempolicy		sys_set_mempolicy		__ia32_sys_set_mempolicy
 277	i386	mq_open			sys_mq_open			__ia32_compat_sys_mq_open
 278	i386	mq_unlink		sys_mq_unlink			__ia32_sys_mq_unlink
-279	i386	mq_timedsend		sys_mq_timedsend		__ia32_sys_mq_timedsend_time32
-280	i386	mq_timedreceive		sys_mq_timedreceive		__ia32_sys_mq_timedreceive_time32
+279	i386	mq_timedsend		sys_mq_timedsend_time32		__ia32_sys_mq_timedsend_time32
+280	i386	mq_timedreceive		sys_mq_timedreceive_time32	__ia32_sys_mq_timedreceive_time32
 281	i386	mq_notify		sys_mq_notify			__ia32_compat_sys_mq_notify
 282	i386	mq_getsetattr		sys_mq_getsetattr		__ia32_compat_sys_mq_getsetattr
 283	i386	kexec_load		sys_kexec_load			__ia32_compat_sys_kexec_load
@@ -319,8 +319,8 @@
 305	i386	readlinkat		sys_readlinkat			__ia32_sys_readlinkat
 306	i386	fchmodat		sys_fchmodat			__ia32_sys_fchmodat
 307	i386	faccessat		sys_faccessat			__ia32_sys_faccessat
-308	i386	pselect6		sys_pselect6			__ia32_compat_sys_pselect6_time32
-309	i386	ppoll			sys_ppoll			__ia32_compat_sys_ppoll_time32
+308	i386	pselect6		sys_pselect6_time32		__ia32_compat_sys_pselect6_time32
+309	i386	ppoll			sys_ppoll_time32		__ia32_compat_sys_ppoll_time32
 310	i386	unshare			sys_unshare			__ia32_sys_unshare
 311	i386	set_robust_list		sys_set_robust_list		__ia32_compat_sys_set_robust_list
 312	i386	get_robust_list		sys_get_robust_list		__ia32_compat_sys_get_robust_list
@@ -331,13 +331,13 @@
 317	i386	move_pages		sys_move_pages			__ia32_compat_sys_move_pages
 318	i386	getcpu			sys_getcpu			__ia32_sys_getcpu
 319	i386	epoll_pwait		sys_epoll_pwait			__ia32_sys_epoll_pwait
-320	i386	utimensat		sys_utimensat			__ia32_sys_utimensat_time32
+320	i386	utimensat		sys_utimensat_time32		__ia32_sys_utimensat_time32
 321	i386	signalfd		sys_signalfd			__ia32_compat_sys_signalfd
 322	i386	timerfd_create		sys_timerfd_create		__ia32_sys_timerfd_create
 323	i386	eventfd			sys_eventfd			__ia32_sys_eventfd
 324	i386	fallocate		sys_fallocate			__ia32_compat_sys_x86_fallocate
-325	i386	timerfd_settime		sys_timerfd_settime		__ia32_sys_timerfd_settime32
-326	i386	timerfd_gettime		sys_timerfd_gettime		__ia32_sys_timerfd_gettime32
+325	i386	timerfd_settime		sys_timerfd_settime32		__ia32_sys_timerfd_settime32
+326	i386	timerfd_gettime		sys_timerfd_gettime32		__ia32_sys_timerfd_gettime32
 327	i386	signalfd4		sys_signalfd4			__ia32_compat_sys_signalfd4
 328	i386	eventfd2		sys_eventfd2			__ia32_sys_eventfd2
 329	i386	epoll_create1		sys_epoll_create1		__ia32_sys_epoll_create1
@@ -348,13 +348,13 @@
 334	i386	pwritev			sys_pwritev			__ia32_compat_sys_pwritev
 335	i386	rt_tgsigqueueinfo	sys_rt_tgsigqueueinfo		__ia32_compat_sys_rt_tgsigqueueinfo
 336	i386	perf_event_open		sys_perf_event_open		__ia32_sys_perf_event_open
-337	i386	recvmmsg		sys_recvmmsg			__ia32_compat_sys_recvmmsg_time32
+337	i386	recvmmsg		sys_recvmmsg_time32		__ia32_compat_sys_recvmmsg_time32
 338	i386	fanotify_init		sys_fanotify_init		__ia32_sys_fanotify_init
 339	i386	fanotify_mark		sys_fanotify_mark		__ia32_compat_sys_fanotify_mark
 340	i386	prlimit64		sys_prlimit64			__ia32_sys_prlimit64
 341	i386	name_to_handle_at	sys_name_to_handle_at		__ia32_sys_name_to_handle_at
 342	i386	open_by_handle_at	sys_open_by_handle_at		__ia32_compat_sys_open_by_handle_at
-343	i386	clock_adjtime		sys_clock_adjtime		__ia32_sys_clock_adjtime32
+343	i386	clock_adjtime		sys_clock_adjtime32		__ia32_sys_clock_adjtime32
 344	i386	syncfs			sys_syncfs			__ia32_sys_syncfs
 345	i386	sendmmsg		sys_sendmmsg			__ia32_compat_sys_sendmmsg
 346	i386	setns			sys_setns			__ia32_sys_setns
@@ -396,7 +396,7 @@
 382	i386	pkey_free		sys_pkey_free			__ia32_sys_pkey_free
 383	i386	statx			sys_statx			__ia32_sys_statx
 384	i386	arch_prctl		sys_arch_prctl			__ia32_compat_sys_arch_prctl
-385	i386	io_pgetevents		sys_io_pgetevents		__ia32_compat_sys_io_pgetevents
+385	i386	io_pgetevents		sys_io_pgetevents_time32	__ia32_compat_sys_io_pgetevents
 386	i386	rseq			sys_rseq			__ia32_sys_rseq
 # room for arch specific syscalls
 393	i386	semget			sys_semget    			__ia32_sys_semget
diff --git a/arch/xtensa/kernel/syscalls/syscall.tbl b/arch/xtensa/kernel/syscalls/syscall.tbl
index c699e014e0dd..6f05bc8f015a 100644
--- a/arch/xtensa/kernel/syscalls/syscall.tbl
+++ b/arch/xtensa/kernel/syscalls/syscall.tbl
@@ -174,7 +174,7 @@
 158	common	capget				sys_capget
 159	common	capset				sys_capset
 160	common	ptrace				sys_ptrace
-161	common	semtimedop			sys_semtimedop
+161	common	semtimedop			sys_semtimedop_time32
 162	common	semget				sys_semget
 163	common	semop				sys_semop
 164	common	semctl				sys_old_semctl
@@ -206,11 +206,11 @@
 188	common	setrlimit			sys_setrlimit
 189	common	getrlimit			sys_getrlimit
 190	common	getrusage			sys_getrusage
-191	common	futex				sys_futex
+191	common	futex				sys_futex_time32
 192	common	gettimeofday			sys_gettimeofday
 193	common	settimeofday			sys_settimeofday
-194	common	adjtimex			sys_adjtimex
-195	common	nanosleep			sys_nanosleep
+194	common	adjtimex			sys_adjtimex_time32
+195	common	nanosleep			sys_nanosleep_time32
 196	common	getgroups			sys_getgroups
 197	common	setgroups			sys_setgroups
 198	common	sethostname			sys_sethostname
@@ -234,7 +234,7 @@
 215	common	sched_getscheduler		sys_sched_getscheduler
 216	common	sched_get_priority_max		sys_sched_get_priority_max
 217	common	sched_get_priority_min		sys_sched_get_priority_min
-218	common	sched_rr_get_interval		sys_sched_rr_get_interval
+218	common	sched_rr_get_interval		sys_sched_rr_get_interval_time32
 219	common	sched_yield			sys_sched_yield
 222	common	available222			sys_ni_syscall
 # Signal Handling
@@ -244,14 +244,14 @@
 226	common	rt_sigaction			sys_rt_sigaction
 227	common	rt_sigprocmask			sys_rt_sigprocmask
 228	common	rt_sigpending			sys_rt_sigpending
-229	common	rt_sigtimedwait			sys_rt_sigtimedwait
+229	common	rt_sigtimedwait			sys_rt_sigtimedwait_time32
 230	common	rt_sigqueueinfo			sys_rt_sigqueueinfo
 231	common	rt_sigsuspend			sys_rt_sigsuspend
 # Message
 232	common	mq_open				sys_mq_open
 233	common	mq_unlink			sys_mq_unlink
-234	common	mq_timedsend			sys_mq_timedsend
-235	common	mq_timedreceive			sys_mq_timedreceive
+234	common	mq_timedsend			sys_mq_timedsend_time32
+235	common	mq_timedreceive			sys_mq_timedreceive_time32
 236	common	mq_notify			sys_mq_notify
 237	common	mq_getsetattr			sys_mq_getsetattr
 238	common	available238			sys_ni_syscall
@@ -259,17 +259,17 @@
 # IO
 240	common	io_destroy			sys_io_destroy
 241	common	io_submit			sys_io_submit
-242	common	io_getevents			sys_io_getevents
+242	common	io_getevents			sys_io_getevents_time32
 243	common	io_cancel			sys_io_cancel
-244	common	clock_settime			sys_clock_settime
-245	common	clock_gettime			sys_clock_gettime
-246	common	clock_getres			sys_clock_getres
-247	common	clock_nanosleep			sys_clock_nanosleep
+244	common	clock_settime			sys_clock_settime32
+245	common	clock_gettime			sys_clock_gettime32
+246	common	clock_getres			sys_clock_getres_time32
+247	common	clock_nanosleep			sys_clock_nanosleep_time32
 # Timer
 248	common	timer_create			sys_timer_create
 249	common	timer_delete			sys_timer_delete
-250	common	timer_settime			sys_timer_settime
-251	common	timer_gettime			sys_timer_gettime
+250	common	timer_settime			sys_timer_settime32
+251	common	timer_gettime			sys_timer_gettime32
 252	common	timer_getoverrun		sys_timer_getoverrun
 # System
 253	common	reserved253			sys_ni_syscall
@@ -291,8 +291,8 @@
 269	common	tee				sys_tee
 270	common	vmsplice			sys_vmsplice
 271	common	available271			sys_ni_syscall
-272	common	pselect6			sys_pselect6
-273	common	ppoll				sys_ppoll
+272	common	pselect6			sys_pselect6_time32
+273	common	ppoll				sys_ppoll_time32
 274	common	epoll_pwait			sys_epoll_pwait
 275	common	epoll_create1			sys_epoll_create1
 276	common	inotify_init			sys_inotify_init
@@ -316,7 +316,7 @@
 293	common	linkat				sys_linkat
 294	common	symlinkat			sys_symlinkat
 295	common	readlinkat			sys_readlinkat
-296	common	utimensat			sys_utimensat
+296	common	utimensat			sys_utimensat_time32
 297	common	fchownat			sys_fchownat
 298	common	futimesat			sys_futimesat
 299	common	fstatat64			sys_fstatat64
@@ -327,14 +327,14 @@
 304	common	signalfd			sys_signalfd
 # 305 was timerfd
 306	common	eventfd				sys_eventfd
-307	common	recvmmsg			sys_recvmmsg
+307	common	recvmmsg			sys_recvmmsg_time32
 308	common	setns				sys_setns
 309	common	signalfd4			sys_signalfd4
 310	common	dup3				sys_dup3
 311	common	pipe2				sys_pipe2
 312	common	timerfd_create			sys_timerfd_create
-313	common	timerfd_settime			sys_timerfd_settime
-314	common	timerfd_gettime			sys_timerfd_gettime
+313	common	timerfd_settime			sys_timerfd_settime32
+314	common	timerfd_gettime			sys_timerfd_gettime32
 315	common	available315			sys_ni_syscall
 316	common	eventfd2			sys_eventfd2
 317	common	preadv				sys_preadv
@@ -349,7 +349,7 @@
 326	common	sync_file_range2		sys_sync_file_range2
 327	common	perf_event_open			sys_perf_event_open
 328	common	rt_tgsigqueueinfo		sys_rt_tgsigqueueinfo
-329	common	clock_adjtime			sys_clock_adjtime
+329	common	clock_adjtime			sys_clock_adjtime32
 330	common	prlimit64			sys_prlimit64
 331	common	kcmp				sys_kcmp
 332	common	finit_module			sys_finit_module
diff --git a/include/uapi/asm-generic/unistd.h b/include/uapi/asm-generic/unistd.h
index d7db7ed99a7b..af38c660c857 100644
--- a/include/uapi/asm-generic/unistd.h
+++ b/include/uapi/asm-generic/unistd.h
@@ -39,7 +39,7 @@ __SC_COMP(__NR_io_submit, sys_io_submit, compat_sys_io_submit)
 #define __NR_io_cancel 3
 __SYSCALL(__NR_io_cancel, sys_io_cancel)
 #define __NR_io_getevents 4
-__SC_COMP(__NR_io_getevents, sys_io_getevents, sys_io_getevents_time32)
+__SC_3264(__NR_io_getevents, sys_io_getevents_time32, sys_io_getevents)
 
 /* fs/xattr.c */
 #define __NR_setxattr 5
@@ -223,9 +223,9 @@ __SYSCALL(__NR3264_sendfile, sys_sendfile64)
 
 /* fs/select.c */
 #define __NR_pselect6 72
-__SC_COMP(__NR_pselect6, sys_pselect6, compat_sys_pselect6_time32)
+__SC_COMP_3264(__NR_pselect6, sys_pselect6_time32, sys_pselect6, compat_sys_pselect6_time32)
 #define __NR_ppoll 73
-__SC_COMP(__NR_ppoll, sys_ppoll, compat_sys_ppoll_time32)
+__SC_COMP_3264(__NR_ppoll, sys_ppoll_time32, sys_ppoll, compat_sys_ppoll_time32)
 
 /* fs/signalfd.c */
 #define __NR_signalfd4 74
@@ -270,15 +270,15 @@ __SC_COMP(__NR_sync_file_range, sys_sync_file_range, \
 #define __NR_timerfd_create 85
 __SYSCALL(__NR_timerfd_create, sys_timerfd_create)
 #define __NR_timerfd_settime 86
-__SC_COMP(__NR_timerfd_settime, sys_timerfd_settime, \
-	  sys_timerfd_settime32)
+__SC_3264(__NR_timerfd_settime, sys_timerfd_settime32, \
+	  sys_timerfd_settime)
 #define __NR_timerfd_gettime 87
-__SC_COMP(__NR_timerfd_gettime, sys_timerfd_gettime, \
-	  sys_timerfd_gettime32)
+__SC_3264(__NR_timerfd_gettime, sys_timerfd_gettime32, \
+	  sys_timerfd_gettime)
 
 /* fs/utimes.c */
 #define __NR_utimensat 88
-__SC_COMP(__NR_utimensat, sys_utimensat, sys_utimensat_time32)
+__SC_3264(__NR_utimensat, sys_utimensat_time32, sys_utimensat)
 
 /* kernel/acct.c */
 #define __NR_acct 89
@@ -310,7 +310,7 @@ __SYSCALL(__NR_unshare, sys_unshare)
 
 /* kernel/futex.c */
 #define __NR_futex 98
-__SC_COMP(__NR_futex, sys_futex, sys_futex_time32)
+__SC_3264(__NR_futex, sys_futex_time32, sys_futex)
 #define __NR_set_robust_list 99
 __SC_COMP(__NR_set_robust_list, sys_set_robust_list, \
 	  compat_sys_set_robust_list)
@@ -320,7 +320,7 @@ __SC_COMP(__NR_get_robust_list, sys_get_robust_list, \
 
 /* kernel/hrtimer.c */
 #define __NR_nanosleep 101
-__SC_COMP(__NR_nanosleep, sys_nanosleep, sys_nanosleep_time32)
+__SC_3264(__NR_nanosleep, sys_nanosleep_time32, sys_nanosleep)
 
 /* kernel/itimer.c */
 #define __NR_getitimer 102
@@ -342,22 +342,22 @@ __SYSCALL(__NR_delete_module, sys_delete_module)
 #define __NR_timer_create 107
 __SC_COMP(__NR_timer_create, sys_timer_create, compat_sys_timer_create)
 #define __NR_timer_gettime 108
-__SC_COMP(__NR_timer_gettime, sys_timer_gettime, sys_timer_gettime32)
+__SC_3264(__NR_timer_gettime, sys_timer_gettime32, sys_timer_gettime)
 #define __NR_timer_getoverrun 109
 __SYSCALL(__NR_timer_getoverrun, sys_timer_getoverrun)
 #define __NR_timer_settime 110
-__SC_COMP(__NR_timer_settime, sys_timer_settime, sys_timer_settime32)
+__SC_3264(__NR_timer_settime, sys_timer_settime32, sys_timer_settime)
 #define __NR_timer_delete 111
 __SYSCALL(__NR_timer_delete, sys_timer_delete)
 #define __NR_clock_settime 112
-__SC_COMP(__NR_clock_settime, sys_clock_settime, sys_clock_settime32)
+__SC_3264(__NR_clock_settime, sys_clock_settime32, sys_clock_settime)
 #define __NR_clock_gettime 113
-__SC_COMP(__NR_clock_gettime, sys_clock_gettime, sys_clock_gettime32)
+__SC_3264(__NR_clock_gettime, sys_clock_gettime32, sys_clock_gettime)
 #define __NR_clock_getres 114
-__SC_COMP(__NR_clock_getres, sys_clock_getres, sys_clock_getres_time32)
+__SC_3264(__NR_clock_getres, sys_clock_getres_time32, sys_clock_getres)
 #define __NR_clock_nanosleep 115
-__SC_COMP(__NR_clock_nanosleep, sys_clock_nanosleep, \
-	  sys_clock_nanosleep_time32)
+__SC_3264(__NR_clock_nanosleep, sys_clock_nanosleep_time32, \
+	  sys_clock_nanosleep)
 
 /* kernel/printk.c */
 #define __NR_syslog 116
@@ -389,8 +389,8 @@ __SYSCALL(__NR_sched_get_priority_max, sys_sched_get_priority_max)
 #define __NR_sched_get_priority_min 126
 __SYSCALL(__NR_sched_get_priority_min, sys_sched_get_priority_min)
 #define __NR_sched_rr_get_interval 127
-__SC_COMP(__NR_sched_rr_get_interval, sys_sched_rr_get_interval, \
-	  sys_sched_rr_get_interval_time32)
+__SC_3264(__NR_sched_rr_get_interval, sys_sched_rr_get_interval_time32, \
+	  sys_sched_rr_get_interval)
 
 /* kernel/signal.c */
 #define __NR_restart_syscall 128
@@ -412,8 +412,8 @@ __SC_COMP(__NR_rt_sigprocmask, sys_rt_sigprocmask, compat_sys_rt_sigprocmask)
 #define __NR_rt_sigpending 136
 __SC_COMP(__NR_rt_sigpending, sys_rt_sigpending, compat_sys_rt_sigpending)
 #define __NR_rt_sigtimedwait 137
-__SC_COMP(__NR_rt_sigtimedwait, sys_rt_sigtimedwait, \
-	  compat_sys_rt_sigtimedwait_time32)
+__SC_COMP_3264(__NR_rt_sigtimedwait, sys_rt_sigtimedwait_time32, \
+	  sys_rt_sigtimedwait, compat_sys_rt_sigtimedwait_time32)
 #define __NR_rt_sigqueueinfo 138
 __SC_COMP(__NR_rt_sigqueueinfo, sys_rt_sigqueueinfo, \
 	  compat_sys_rt_sigqueueinfo)
@@ -486,7 +486,7 @@ __SC_COMP(__NR_gettimeofday, sys_gettimeofday, compat_sys_gettimeofday)
 #define __NR_settimeofday 170
 __SC_COMP(__NR_settimeofday, sys_settimeofday, compat_sys_settimeofday)
 #define __NR_adjtimex 171
-__SC_COMP(__NR_adjtimex, sys_adjtimex, sys_adjtimex_time32)
+__SC_3264(__NR_adjtimex, sys_adjtimex_time32, sys_adjtimex)
 
 /* kernel/timer.c */
 #define __NR_getpid 172
@@ -512,10 +512,10 @@ __SC_COMP(__NR_mq_open, sys_mq_open, compat_sys_mq_open)
 #define __NR_mq_unlink 181
 __SYSCALL(__NR_mq_unlink, sys_mq_unlink)
 #define __NR_mq_timedsend 182
-__SC_COMP(__NR_mq_timedsend, sys_mq_timedsend, sys_mq_timedsend_time32)
+__SC_3264(__NR_mq_timedsend, sys_mq_timedsend_time32, sys_mq_timedsend)
 #define __NR_mq_timedreceive 183
-__SC_COMP(__NR_mq_timedreceive, sys_mq_timedreceive, \
-	  sys_mq_timedreceive_time32)
+__SC_3264(__NR_mq_timedreceive, sys_mq_timedreceive_time32, \
+	  sys_mq_timedreceive)
 #define __NR_mq_notify 184
 __SC_COMP(__NR_mq_notify, sys_mq_notify, compat_sys_mq_notify)
 #define __NR_mq_getsetattr 185
@@ -659,7 +659,7 @@ __SYSCALL(__NR_perf_event_open, sys_perf_event_open)
 #define __NR_accept4 242
 __SYSCALL(__NR_accept4, sys_accept4)
 #define __NR_recvmmsg 243
-__SC_COMP(__NR_recvmmsg, sys_recvmmsg, compat_sys_recvmmsg_time32)
+__SC_COMP_3264(__NR_recvmmsg, sys_recvmmsg_time32, sys_recvmmsg, compat_sys_recvmmsg_time32)
 
 /*
  * Architectures may provide up to 16 syscalls of their own
@@ -681,7 +681,7 @@ __SYSCALL(__NR_name_to_handle_at, sys_name_to_handle_at)
 __SC_COMP(__NR_open_by_handle_at, sys_open_by_handle_at, \
 	  compat_sys_open_by_handle_at)
 #define __NR_clock_adjtime 266
-__SC_COMP(__NR_clock_adjtime, sys_clock_adjtime, sys_clock_adjtime32)
+__SC_3264(__NR_clock_adjtime, sys_clock_adjtime32, sys_clock_adjtime)
 #define __NR_syncfs 267
 __SYSCALL(__NR_syncfs, sys_syncfs)
 #define __NR_setns 268
@@ -735,7 +735,7 @@ __SYSCALL(__NR_pkey_free,     sys_pkey_free)
 #define __NR_statx 291
 __SYSCALL(__NR_statx,     sys_statx)
 #define __NR_io_pgetevents 292
-__SC_COMP(__NR_io_pgetevents, sys_io_pgetevents, compat_sys_io_pgetevents)
+__SC_COMP_3264(__NR_io_pgetevents, sys_io_pgetevents_time32, sys_io_pgetevents, compat_sys_io_pgetevents)
 #define __NR_rseq 293
 __SYSCALL(__NR_rseq, sys_rseq)
 #define __NR_kexec_file_load 294
-- 
2.20.0
