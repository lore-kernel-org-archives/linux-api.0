From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v2 12/29] ipc: rename old-style shmctl/semctl/msgctl syscalls
Date: Fri, 18 Jan 2019 17:18:18 +0100
Message-ID: <20190118161835.2259170-13-arnd@arndb.de>
References: <20190118161835.2259170-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190118161835.2259170-1-arnd@arndb.de>
Sender: netdev-owner@vger.kernel.org
To: y2038@lists.linaro.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, mattst88@gmail.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, tony.luck@intel.com, fenghua.yu@intel.com, geert@linux-m68k.org, monstr@monstr.eu, paul.burton@mips.com, deller@gmx.de, benh@kernel.crashing.org, mpe@ellerman.id.au, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, dalias@libc.org, davem@davemloft.net, luto@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org, jcmvbkbc@gmail.com, akpm@linux-foundation.org, deepa.kernel@gmail.com, ebiederm@xmission.com, firoz.khan@linaro.org, linux-alpha@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-ia64@vger.kernel.org, linux-m68k@lists.linux-m68k.org, linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.or
List-Id: linux-api@vger.kernel.org

The behavior of these system calls is slightly different between
architectures, as determined by the CONFIG_ARCH_WANT_IPC_PARSE_VERSION
symbol. Most architectures that implement the split IPC syscalls don't set
that symbol and only get the modern version, but alpha, arm, microblaze,
mips-n32, mips-n64 and xtensa expect the caller to pass the IPC_64 flag.

For the architectures that so far only implement sys_ipc(), i.e. m68k,
mips-o32, powerpc, s390, sh, sparc, and x86-32, we want the new behavior
when adding the split syscalls, so we need to distinguish between the
two groups of architectures.

The method I picked for this distinction is to have a separate system call
entry point: sys_old_*ctl() now uses ipc_parse_version, while sys_*ctl()
does not. The system call tables of the five architectures are changed
accordingly.

As an additional benefit, we no longer need the configuration specific
definition for ipc_parse_version(), it always does the same thing now,
but simply won't get called on architectures with the modern interface.

A small downside is that on architectures that do set
ARCH_WANT_IPC_PARSE_VERSION, we now have an extra set of entry points
that are never called. They only add a few bytes of bloat, so it seems
better to keep them compared to adding yet another Kconfig symbol.
I considered adding new syscall numbers for the IPC_64 variants for
consistency, but decided against that for now.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/alpha/kernel/syscalls/syscall.tbl      |  6 ++--
 arch/arm/tools/syscall.tbl                  |  6 ++--
 arch/arm64/include/asm/unistd32.h           |  6 ++--
 arch/microblaze/kernel/syscalls/syscall.tbl |  6 ++--
 arch/mips/kernel/syscalls/syscall_n32.tbl   |  6 ++--
 arch/mips/kernel/syscalls/syscall_n64.tbl   |  6 ++--
 arch/xtensa/kernel/syscalls/syscall.tbl     |  6 ++--
 include/linux/syscalls.h                    |  3 ++
 ipc/msg.c                                   | 39 ++++++++++++++++----
 ipc/sem.c                                   | 39 ++++++++++++++++----
 ipc/shm.c                                   | 40 +++++++++++++++++----
 ipc/syscall.c                               | 12 +++----
 ipc/util.h                                  | 21 ++++-------
 kernel/sys_ni.c                             |  3 ++
 14 files changed, 137 insertions(+), 62 deletions(-)

diff --git a/arch/alpha/kernel/syscalls/syscall.tbl b/arch/alpha/kernel/syscalls/syscall.tbl
index f920b65e8c49..b0e247287908 100644
--- a/arch/alpha/kernel/syscalls/syscall.tbl
+++ b/arch/alpha/kernel/syscalls/syscall.tbl
@@ -174,17 +174,17 @@
 187	common	osf_alt_sigpending		sys_ni_syscall
 188	common	osf_alt_setsid			sys_ni_syscall
 199	common	osf_swapon			sys_swapon
-200	common	msgctl				sys_msgctl
+200	common	msgctl				sys_old_msgctl
 201	common	msgget				sys_msgget
 202	common	msgrcv				sys_msgrcv
 203	common	msgsnd				sys_msgsnd
-204	common	semctl				sys_semctl
+204	common	semctl				sys_old_semctl
 205	common	semget				sys_semget
 206	common	semop				sys_semop
 207	common	osf_utsname			sys_osf_utsname
 208	common	lchown				sys_lchown
 209	common	shmat				sys_shmat
-210	common	shmctl				sys_shmctl
+210	common	shmctl				sys_old_shmctl
 211	common	shmdt				sys_shmdt
 212	common	shmget				sys_shmget
 213	common	osf_mvalid			sys_ni_syscall
diff --git a/arch/arm/tools/syscall.tbl b/arch/arm/tools/syscall.tbl
index 20ed7e026723..b54b7f2bc24a 100644
--- a/arch/arm/tools/syscall.tbl
+++ b/arch/arm/tools/syscall.tbl
@@ -314,15 +314,15 @@
 297	common	recvmsg			sys_recvmsg
 298	common	semop			sys_semop		sys_oabi_semop
 299	common	semget			sys_semget
-300	common	semctl			sys_semctl
+300	common	semctl			sys_old_semctl
 301	common	msgsnd			sys_msgsnd
 302	common	msgrcv			sys_msgrcv
 303	common	msgget			sys_msgget
-304	common	msgctl			sys_msgctl
+304	common	msgctl			sys_old_msgctl
 305	common	shmat			sys_shmat
 306	common	shmdt			sys_shmdt
 307	common	shmget			sys_shmget
-308	common	shmctl			sys_shmctl
+308	common	shmctl			sys_old_shmctl
 309	common	add_key			sys_add_key
 310	common	request_key		sys_request_key
 311	common	keyctl			sys_keyctl
diff --git a/arch/arm64/include/asm/unistd32.h b/arch/arm64/include/asm/unistd32.h
index 8ca1d4c304f4..d10cce69a4b0 100644
--- a/arch/arm64/include/asm/unistd32.h
+++ b/arch/arm64/include/asm/unistd32.h
@@ -622,7 +622,7 @@ __SYSCALL(__NR_semop, sys_semop)
 #define __NR_semget 299
 __SYSCALL(__NR_semget, sys_semget)
 #define __NR_semctl 300
-__SYSCALL(__NR_semctl, compat_sys_semctl)
+__SYSCALL(__NR_semctl, compat_sys_old_semctl)
 #define __NR_msgsnd 301
 __SYSCALL(__NR_msgsnd, compat_sys_msgsnd)
 #define __NR_msgrcv 302
@@ -630,7 +630,7 @@ __SYSCALL(__NR_msgrcv, compat_sys_msgrcv)
 #define __NR_msgget 303
 __SYSCALL(__NR_msgget, sys_msgget)
 #define __NR_msgctl 304
-__SYSCALL(__NR_msgctl, compat_sys_msgctl)
+__SYSCALL(__NR_msgctl, compat_sys_old_msgctl)
 #define __NR_shmat 305
 __SYSCALL(__NR_shmat, compat_sys_shmat)
 #define __NR_shmdt 306
@@ -638,7 +638,7 @@ __SYSCALL(__NR_shmdt, sys_shmdt)
 #define __NR_shmget 307
 __SYSCALL(__NR_shmget, sys_shmget)
 #define __NR_shmctl 308
-__SYSCALL(__NR_shmctl, compat_sys_shmctl)
+__SYSCALL(__NR_shmctl, compat_sys_old_shmctl)
 #define __NR_add_key 309
 __SYSCALL(__NR_add_key, sys_add_key)
 #define __NR_request_key 310
diff --git a/arch/microblaze/kernel/syscalls/syscall.tbl b/arch/microblaze/kernel/syscalls/syscall.tbl
index a24d09e937dd..7cc0f9554da3 100644
--- a/arch/microblaze/kernel/syscalls/syscall.tbl
+++ b/arch/microblaze/kernel/syscalls/syscall.tbl
@@ -335,15 +335,15 @@
 325	common	semtimedop			sys_semtimedop
 326	common	timerfd_settime			sys_timerfd_settime
 327	common	timerfd_gettime			sys_timerfd_gettime
-328	common	semctl				sys_semctl
+328	common	semctl				sys_old_semctl
 329	common	semget				sys_semget
 330	common	semop				sys_semop
-331	common	msgctl				sys_msgctl
+331	common	msgctl				sys_old_msgctl
 332	common	msgget				sys_msgget
 333	common	msgrcv				sys_msgrcv
 334	common	msgsnd				sys_msgsnd
 335	common	shmat				sys_shmat
-336	common	shmctl				sys_shmctl
+336	common	shmctl				sys_old_shmctl
 337	common	shmdt				sys_shmdt
 338	common	shmget				sys_shmget
 339	common	signalfd4			sys_signalfd4
diff --git a/arch/mips/kernel/syscalls/syscall_n32.tbl b/arch/mips/kernel/syscalls/syscall_n32.tbl
index 53d5862649ae..cc134b1211aa 100644
--- a/arch/mips/kernel/syscalls/syscall_n32.tbl
+++ b/arch/mips/kernel/syscalls/syscall_n32.tbl
@@ -37,7 +37,7 @@
 27	n32	madvise				sys_madvise
 28	n32	shmget				sys_shmget
 29	n32	shmat				sys_shmat
-30	n32	shmctl				compat_sys_shmctl
+30	n32	shmctl				compat_sys_old_shmctl
 31	n32	dup				sys_dup
 32	n32	dup2				sys_dup2
 33	n32	pause				sys_pause
@@ -71,12 +71,12 @@
 61	n32	uname				sys_newuname
 62	n32	semget				sys_semget
 63	n32	semop				sys_semop
-64	n32	semctl				compat_sys_semctl
+64	n32	semctl				compat_sys_old_semctl
 65	n32	shmdt				sys_shmdt
 66	n32	msgget				sys_msgget
 67	n32	msgsnd				compat_sys_msgsnd
 68	n32	msgrcv				compat_sys_msgrcv
-69	n32	msgctl				compat_sys_msgctl
+69	n32	msgctl				compat_sys_old_msgctl
 70	n32	fcntl				compat_sys_fcntl
 71	n32	flock				sys_flock
 72	n32	fsync				sys_fsync
diff --git a/arch/mips/kernel/syscalls/syscall_n64.tbl b/arch/mips/kernel/syscalls/syscall_n64.tbl
index a8286ccbb66c..af0da757a7b2 100644
--- a/arch/mips/kernel/syscalls/syscall_n64.tbl
+++ b/arch/mips/kernel/syscalls/syscall_n64.tbl
@@ -37,7 +37,7 @@
 27	n64	madvise				sys_madvise
 28	n64	shmget				sys_shmget
 29	n64	shmat				sys_shmat
-30	n64	shmctl				sys_shmctl
+30	n64	shmctl				sys_old_shmctl
 31	n64	dup				sys_dup
 32	n64	dup2				sys_dup2
 33	n64	pause				sys_pause
@@ -71,12 +71,12 @@
 61	n64	uname				sys_newuname
 62	n64	semget				sys_semget
 63	n64	semop				sys_semop
-64	n64	semctl				sys_semctl
+64	n64	semctl				sys_old_semctl
 65	n64	shmdt				sys_shmdt
 66	n64	msgget				sys_msgget
 67	n64	msgsnd				sys_msgsnd
 68	n64	msgrcv				sys_msgrcv
-69	n64	msgctl				sys_msgctl
+69	n64	msgctl				sys_old_msgctl
 70	n64	fcntl				sys_fcntl
 71	n64	flock				sys_flock
 72	n64	fsync				sys_fsync
diff --git a/arch/xtensa/kernel/syscalls/syscall.tbl b/arch/xtensa/kernel/syscalls/syscall.tbl
index 69cf91b03b26..f8befa11b0c4 100644
--- a/arch/xtensa/kernel/syscalls/syscall.tbl
+++ b/arch/xtensa/kernel/syscalls/syscall.tbl
@@ -103,7 +103,7 @@
 91	common	madvise				sys_madvise
 92	common	shmget				sys_shmget
 93	common	shmat				xtensa_shmat
-94	common	shmctl				sys_shmctl
+94	common	shmctl				sys_old_shmctl
 95	common	shmdt				sys_shmdt
 # Socket Operations
 96	common	socket				sys_socket
@@ -177,12 +177,12 @@
 161	common	semtimedop			sys_semtimedop
 162	common	semget				sys_semget
 163	common	semop				sys_semop
-164	common	semctl				sys_semctl
+164	common	semctl				sys_old_semctl
 165	common	available165			sys_ni_syscall
 166	common	msgget				sys_msgget
 167	common	msgsnd				sys_msgsnd
 168	common	msgrcv				sys_msgrcv
-169	common	msgctl				sys_msgctl
+169	common	msgctl				sys_old_msgctl
 170	common	available170			sys_ni_syscall
 # File System
 171	common	umount2				sys_umount
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index fb63045a0fb6..938d8908b9e0 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -717,6 +717,7 @@ asmlinkage long sys_mq_getsetattr(mqd_t mqdes, const struct mq_attr __user *mqst
 
 /* ipc/msg.c */
 asmlinkage long sys_msgget(key_t key, int msgflg);
+asmlinkage long sys_old_msgctl(int msqid, int cmd, struct msqid_ds __user *buf);
 asmlinkage long sys_msgctl(int msqid, int cmd, struct msqid_ds __user *buf);
 asmlinkage long sys_msgrcv(int msqid, struct msgbuf __user *msgp,
 				size_t msgsz, long msgtyp, int msgflg);
@@ -726,6 +727,7 @@ asmlinkage long sys_msgsnd(int msqid, struct msgbuf __user *msgp,
 /* ipc/sem.c */
 asmlinkage long sys_semget(key_t key, int nsems, int semflg);
 asmlinkage long sys_semctl(int semid, int semnum, int cmd, unsigned long arg);
+asmlinkage long sys_old_semctl(int semid, int semnum, int cmd, unsigned long arg);
 asmlinkage long sys_semtimedop(int semid, struct sembuf __user *sops,
 				unsigned nsops,
 				const struct __kernel_timespec __user *timeout);
@@ -734,6 +736,7 @@ asmlinkage long sys_semop(int semid, struct sembuf __user *sops,
 
 /* ipc/shm.c */
 asmlinkage long sys_shmget(key_t key, size_t size, int flag);
+asmlinkage long sys_old_shmctl(int shmid, int cmd, struct shmid_ds __user *buf);
 asmlinkage long sys_shmctl(int shmid, int cmd, struct shmid_ds __user *buf);
 asmlinkage long sys_shmat(int shmid, char __user *shmaddr, int shmflg);
 asmlinkage long sys_shmdt(char __user *shmaddr);
diff --git a/ipc/msg.c b/ipc/msg.c
index 0833c6405915..8dec945fa030 100644
--- a/ipc/msg.c
+++ b/ipc/msg.c
@@ -567,9 +567,8 @@ static int msgctl_stat(struct ipc_namespace *ns, int msqid,
 	return err;
 }
 
-long ksys_msgctl(int msqid, int cmd, struct msqid_ds __user *buf)
+static long ksys_msgctl(int msqid, int cmd, struct msqid_ds __user *buf, int version)
 {
-	int version;
 	struct ipc_namespace *ns;
 	struct msqid64_ds msqid64;
 	int err;
@@ -577,7 +576,6 @@ long ksys_msgctl(int msqid, int cmd, struct msqid_ds __user *buf)
 	if (msqid < 0 || cmd < 0)
 		return -EINVAL;
 
-	version = ipc_parse_version(&cmd);
 	ns = current->nsproxy->ipc_ns;
 
 	switch (cmd) {
@@ -613,9 +611,23 @@ long ksys_msgctl(int msqid, int cmd, struct msqid_ds __user *buf)
 
 SYSCALL_DEFINE3(msgctl, int, msqid, int, cmd, struct msqid_ds __user *, buf)
 {
-	return ksys_msgctl(msqid, cmd, buf);
+	return ksys_msgctl(msqid, cmd, buf, IPC_64);
 }
 
+#ifdef CONFIG_ARCH_WANT_IPC_PARSE_VERSION
+long ksys_old_msgctl(int msqid, int cmd, struct msqid_ds __user *buf)
+{
+	int version = ipc_parse_version(&cmd);
+
+	return ksys_msgctl(msqid, cmd, buf, version);
+}
+
+SYSCALL_DEFINE3(old_msgctl, int, msqid, int, cmd, struct msqid_ds __user *, buf)
+{
+	return ksys_old_msgctl(msqid, cmd, buf);
+}
+#endif
+
 #ifdef CONFIG_COMPAT
 
 struct compat_msqid_ds {
@@ -689,12 +701,11 @@ static int copy_compat_msqid_to_user(void __user *buf, struct msqid64_ds *in,
 	}
 }
 
-long compat_ksys_msgctl(int msqid, int cmd, void __user *uptr)
+static long compat_ksys_msgctl(int msqid, int cmd, void __user *uptr, int version)
 {
 	struct ipc_namespace *ns;
 	int err;
 	struct msqid64_ds msqid64;
-	int version = compat_ipc_parse_version(&cmd);
 
 	ns = current->nsproxy->ipc_ns;
 
@@ -734,8 +745,22 @@ long compat_ksys_msgctl(int msqid, int cmd, void __user *uptr)
 
 COMPAT_SYSCALL_DEFINE3(msgctl, int, msqid, int, cmd, void __user *, uptr)
 {
-	return compat_ksys_msgctl(msqid, cmd, uptr);
+	return compat_ksys_msgctl(msqid, cmd, uptr, IPC_64);
 }
+
+#ifdef CONFIG_ARCH_WANT_COMPAT_IPC_PARSE_VERSION
+long compat_ksys_old_msgctl(int msqid, int cmd, void __user *uptr)
+{
+	int version = compat_ipc_parse_version(&cmd);
+
+	return compat_ksys_msgctl(msqid, cmd, uptr, version);
+}
+
+COMPAT_SYSCALL_DEFINE3(old_msgctl, int, msqid, int, cmd, void __user *, uptr)
+{
+	return compat_ksys_old_msgctl(msqid, cmd, uptr);
+}
+#endif
 #endif
 
 static int testmsg(struct msg_msg *msg, long type, int mode)
diff --git a/ipc/sem.c b/ipc/sem.c
index 745dc6187e84..d1efff3a81bb 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -1634,9 +1634,8 @@ static int semctl_down(struct ipc_namespace *ns, int semid,
 	return err;
 }
 
-long ksys_semctl(int semid, int semnum, int cmd, unsigned long arg)
+static long ksys_semctl(int semid, int semnum, int cmd, unsigned long arg, int version)
 {
-	int version;
 	struct ipc_namespace *ns;
 	void __user *p = (void __user *)arg;
 	struct semid64_ds semid64;
@@ -1645,7 +1644,6 @@ long ksys_semctl(int semid, int semnum, int cmd, unsigned long arg)
 	if (semid < 0)
 		return -EINVAL;
 
-	version = ipc_parse_version(&cmd);
 	ns = current->nsproxy->ipc_ns;
 
 	switch (cmd) {
@@ -1691,9 +1689,23 @@ long ksys_semctl(int semid, int semnum, int cmd, unsigned long arg)
 
 SYSCALL_DEFINE4(semctl, int, semid, int, semnum, int, cmd, unsigned long, arg)
 {
-	return ksys_semctl(semid, semnum, cmd, arg);
+	return ksys_semctl(semid, semnum, cmd, arg, IPC_64);
 }
 
+#ifdef CONFIG_ARCH_WANT_IPC_PARSE_VERSION
+long ksys_old_semctl(int semid, int semnum, int cmd, unsigned long arg)
+{
+	int version = ipc_parse_version(&cmd);
+
+	return ksys_semctl(semid, semnum, cmd, arg, version);
+}
+
+SYSCALL_DEFINE4(old_semctl, int, semid, int, semnum, int, cmd, unsigned long, arg)
+{
+	return ksys_old_semctl(semid, semnum, cmd, arg);
+}
+#endif
+
 #ifdef CONFIG_COMPAT
 
 struct compat_semid_ds {
@@ -1744,12 +1756,11 @@ static int copy_compat_semid_to_user(void __user *buf, struct semid64_ds *in,
 	}
 }
 
-long compat_ksys_semctl(int semid, int semnum, int cmd, int arg)
+static long compat_ksys_semctl(int semid, int semnum, int cmd, int arg, int version)
 {
 	void __user *p = compat_ptr(arg);
 	struct ipc_namespace *ns;
 	struct semid64_ds semid64;
-	int version = compat_ipc_parse_version(&cmd);
 	int err;
 
 	ns = current->nsproxy->ipc_ns;
@@ -1792,8 +1803,22 @@ long compat_ksys_semctl(int semid, int semnum, int cmd, int arg)
 
 COMPAT_SYSCALL_DEFINE4(semctl, int, semid, int, semnum, int, cmd, int, arg)
 {
-	return compat_ksys_semctl(semid, semnum, cmd, arg);
+	return compat_ksys_semctl(semid, semnum, cmd, arg, IPC_64);
 }
+
+#ifdef CONFIG_ARCH_WANT_COMPAT_IPC_PARSE_VERSION
+long compat_ksys_old_semctl(int semid, int semnum, int cmd, int arg)
+{
+	int version = compat_ipc_parse_version(&cmd);
+
+	return compat_ksys_semctl(semid, semnum, cmd, arg, version);
+}
+
+COMPAT_SYSCALL_DEFINE4(old_semctl, int, semid, int, semnum, int, cmd, int, arg)
+{
+	return compat_ksys_old_semctl(semid, semnum, cmd, arg);
+}
+#endif
 #endif
 
 /* If the task doesn't already have a undo_list, then allocate one
diff --git a/ipc/shm.c b/ipc/shm.c
index 0842411cb0e9..ce1ca9f7c6e9 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -1137,16 +1137,15 @@ static int shmctl_do_lock(struct ipc_namespace *ns, int shmid, int cmd)
 	return err;
 }
 
-long ksys_shmctl(int shmid, int cmd, struct shmid_ds __user *buf)
+static long ksys_shmctl(int shmid, int cmd, struct shmid_ds __user *buf, int version)
 {
-	int err, version;
+	int err;
 	struct ipc_namespace *ns;
 	struct shmid64_ds sem64;
 
 	if (cmd < 0 || shmid < 0)
 		return -EINVAL;
 
-	version = ipc_parse_version(&cmd);
 	ns = current->nsproxy->ipc_ns;
 
 	switch (cmd) {
@@ -1194,8 +1193,22 @@ long ksys_shmctl(int shmid, int cmd, struct shmid_ds __user *buf)
 
 SYSCALL_DEFINE3(shmctl, int, shmid, int, cmd, struct shmid_ds __user *, buf)
 {
-	return ksys_shmctl(shmid, cmd, buf);
+	return ksys_shmctl(shmid, cmd, buf, IPC_64);
+}
+
+#ifdef CONFIG_ARCH_WANT_IPC_PARSE_VERSION
+long ksys_old_shmctl(int shmid, int cmd, struct shmid_ds __user *buf)
+{
+	int version = ipc_parse_version(&cmd);
+
+	return ksys_shmctl(shmid, cmd, buf, version);
+}
+
+SYSCALL_DEFINE3(old_shmctl, int, shmid, int, cmd, struct shmid_ds __user *, buf)
+{
+	return ksys_old_shmctl(shmid, cmd, buf);
 }
+#endif
 
 #ifdef CONFIG_COMPAT
 
@@ -1319,11 +1332,10 @@ static int copy_compat_shmid_from_user(struct shmid64_ds *out, void __user *buf,
 	}
 }
 
-long compat_ksys_shmctl(int shmid, int cmd, void __user *uptr)
+long compat_ksys_shmctl(int shmid, int cmd, void __user *uptr, int version)
 {
 	struct ipc_namespace *ns;
 	struct shmid64_ds sem64;
-	int version = compat_ipc_parse_version(&cmd);
 	int err;
 
 	ns = current->nsproxy->ipc_ns;
@@ -1378,8 +1390,22 @@ long compat_ksys_shmctl(int shmid, int cmd, void __user *uptr)
 
 COMPAT_SYSCALL_DEFINE3(shmctl, int, shmid, int, cmd, void __user *, uptr)
 {
-	return compat_ksys_shmctl(shmid, cmd, uptr);
+	return compat_ksys_shmctl(shmid, cmd, uptr, IPC_64);
 }
+
+#ifdef CONFIG_ARCH_WANT_COMPAT_IPC_PARSE_VERSION
+long compat_ksys_old_shmctl(int shmid, int cmd, void __user *uptr)
+{
+	int version = compat_ipc_parse_version(&cmd);
+
+	return compat_ksys_shmctl(shmid, cmd, uptr, version);
+}
+
+COMPAT_SYSCALL_DEFINE3(old_shmctl, int, shmid, int, cmd, void __user *, uptr)
+{
+	return compat_ksys_old_shmctl(shmid, cmd, uptr);
+}
+#endif
 #endif
 
 /*
diff --git a/ipc/syscall.c b/ipc/syscall.c
index 3cf8ad703a4d..581bdff4e7c5 100644
--- a/ipc/syscall.c
+++ b/ipc/syscall.c
@@ -47,7 +47,7 @@ int ksys_ipc(unsigned int call, int first, unsigned long second,
 			return -EINVAL;
 		if (get_user(arg, (unsigned long __user *) ptr))
 			return -EFAULT;
-		return ksys_semctl(first, second, third, arg);
+		return ksys_old_semctl(first, second, third, arg);
 	}
 
 	case MSGSND:
@@ -75,7 +75,7 @@ int ksys_ipc(unsigned int call, int first, unsigned long second,
 	case MSGGET:
 		return ksys_msgget((key_t) first, second);
 	case MSGCTL:
-		return ksys_msgctl(first, second,
+		return ksys_old_msgctl(first, second,
 				   (struct msqid_ds __user *)ptr);
 
 	case SHMAT:
@@ -100,7 +100,7 @@ int ksys_ipc(unsigned int call, int first, unsigned long second,
 	case SHMGET:
 		return ksys_shmget(first, second, third);
 	case SHMCTL:
-		return ksys_shmctl(first, second,
+		return ksys_old_shmctl(first, second,
 				   (struct shmid_ds __user *) ptr);
 	default:
 		return -ENOSYS;
@@ -152,7 +152,7 @@ int compat_ksys_ipc(u32 call, int first, int second,
 			return -EINVAL;
 		if (get_user(pad, (u32 __user *) compat_ptr(ptr)))
 			return -EFAULT;
-		return compat_ksys_semctl(first, second, third, pad);
+		return compat_ksys_old_semctl(first, second, third, pad);
 
 	case MSGSND:
 		return compat_ksys_msgsnd(first, ptr, second, third);
@@ -177,7 +177,7 @@ int compat_ksys_ipc(u32 call, int first, int second,
 	case MSGGET:
 		return ksys_msgget(first, second);
 	case MSGCTL:
-		return compat_ksys_msgctl(first, second, compat_ptr(ptr));
+		return compat_ksys_old_msgctl(first, second, compat_ptr(ptr));
 
 	case SHMAT: {
 		int err;
@@ -196,7 +196,7 @@ int compat_ksys_ipc(u32 call, int first, int second,
 	case SHMGET:
 		return ksys_shmget(first, (unsigned int)second, third);
 	case SHMCTL:
-		return compat_ksys_shmctl(first, second, compat_ptr(ptr));
+		return compat_ksys_old_shmctl(first, second, compat_ptr(ptr));
 	}
 
 	return -ENOSYS;
diff --git a/ipc/util.h b/ipc/util.h
index d768fdbed515..e272be622ae7 100644
--- a/ipc/util.h
+++ b/ipc/util.h
@@ -160,10 +160,7 @@ static inline void ipc_update_pid(struct pid **pos, struct pid *pid)
 	}
 }
 
-#ifndef CONFIG_ARCH_WANT_IPC_PARSE_VERSION
-/* On IA-64, we always use the "64-bit version" of the IPC structures.  */
-# define ipc_parse_version(cmd)	IPC_64
-#else
+#ifdef CONFIG_ARCH_WANT_IPC_PARSE_VERSION
 int ipc_parse_version(int *cmd);
 #endif
 
@@ -246,13 +243,9 @@ int get_compat_ipc64_perm(struct ipc64_perm *,
 
 static inline int compat_ipc_parse_version(int *cmd)
 {
-#ifdef	CONFIG_ARCH_WANT_COMPAT_IPC_PARSE_VERSION
 	int version = *cmd & IPC_64;
 	*cmd &= ~IPC_64;
 	return version;
-#else
-	return IPC_64;
-#endif
 }
 #endif
 
@@ -261,29 +254,29 @@ long ksys_semtimedop(int semid, struct sembuf __user *tsops,
 		     unsigned int nsops,
 		     const struct __kernel_timespec __user *timeout);
 long ksys_semget(key_t key, int nsems, int semflg);
-long ksys_semctl(int semid, int semnum, int cmd, unsigned long arg);
+long ksys_old_semctl(int semid, int semnum, int cmd, unsigned long arg);
 long ksys_msgget(key_t key, int msgflg);
-long ksys_msgctl(int msqid, int cmd, struct msqid_ds __user *buf);
+long ksys_old_msgctl(int msqid, int cmd, struct msqid_ds __user *buf);
 long ksys_msgrcv(int msqid, struct msgbuf __user *msgp, size_t msgsz,
 		 long msgtyp, int msgflg);
 long ksys_msgsnd(int msqid, struct msgbuf __user *msgp, size_t msgsz,
 		 int msgflg);
 long ksys_shmget(key_t key, size_t size, int shmflg);
 long ksys_shmdt(char __user *shmaddr);
-long ksys_shmctl(int shmid, int cmd, struct shmid_ds __user *buf);
+long ksys_old_shmctl(int shmid, int cmd, struct shmid_ds __user *buf);
 
 /* for CONFIG_ARCH_WANT_OLD_COMPAT_IPC */
 long compat_ksys_semtimedop(int semid, struct sembuf __user *tsems,
 			    unsigned int nsops,
 			    const struct old_timespec32 __user *timeout);
 #ifdef CONFIG_COMPAT
-long compat_ksys_semctl(int semid, int semnum, int cmd, int arg);
-long compat_ksys_msgctl(int msqid, int cmd, void __user *uptr);
+long compat_ksys_old_semctl(int semid, int semnum, int cmd, int arg);
+long compat_ksys_old_msgctl(int msqid, int cmd, void __user *uptr);
 long compat_ksys_msgrcv(int msqid, compat_uptr_t msgp, compat_ssize_t msgsz,
 			compat_long_t msgtyp, int msgflg);
 long compat_ksys_msgsnd(int msqid, compat_uptr_t msgp,
 		       compat_ssize_t msgsz, int msgflg);
-long compat_ksys_shmctl(int shmid, int cmd, void __user *uptr);
+long compat_ksys_old_shmctl(int shmid, int cmd, void __user *uptr);
 #endif /* CONFIG_COMPAT */
 
 #endif
diff --git a/kernel/sys_ni.c b/kernel/sys_ni.c
index bc934f31ab10..ce04431a40d1 100644
--- a/kernel/sys_ni.c
+++ b/kernel/sys_ni.c
@@ -197,6 +197,7 @@ COND_SYSCALL_COMPAT(mq_getsetattr);
 
 /* ipc/msg.c */
 COND_SYSCALL(msgget);
+COND_SYSCALL(old_msgctl);
 COND_SYSCALL(msgctl);
 COND_SYSCALL_COMPAT(msgctl);
 COND_SYSCALL(msgrcv);
@@ -206,6 +207,7 @@ COND_SYSCALL_COMPAT(msgsnd);
 
 /* ipc/sem.c */
 COND_SYSCALL(semget);
+COND_SYSCALL(old_semctl);
 COND_SYSCALL(semctl);
 COND_SYSCALL_COMPAT(semctl);
 COND_SYSCALL(semtimedop);
@@ -214,6 +216,7 @@ COND_SYSCALL(semop);
 
 /* ipc/shm.c */
 COND_SYSCALL(shmget);
+COND_SYSCALL(old_shmctl);
 COND_SYSCALL(shmctl);
 COND_SYSCALL_COMPAT(shmctl);
 COND_SYSCALL(shmat);
-- 
2.20.0
