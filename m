From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 2/2] ipc: fix sparc64 ipc() wrapper
Date: Thu,  5 Sep 2019 17:21:25 +0200
Message-ID: <20190905152155.1392871-2-arnd@arndb.de>
References: <20190905152155.1392871-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190905152155.1392871-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Arnd Bergmann <arnd@arndb.de>, "Eric W. Biederman" <ebiederm@xmission.com>, Deepa Dinamani <deepa.kernel@gmail.com>, Christian Brauner <christian@brauner.io>, Manfred Spraul <manfred@colorfullife.com>, Davidlohr Bueso <dave@stgolabs.net>
Cc: linux-arch@vger.kernel.org, y2038@lists.linaro.org, Dominik Brodowski <linux@dominikbrodowski.net>, Matt Turner <mattst88@gmail.com>, stable@vger.kernel.org, sparclinux@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Matt bisected a sparc64 specific issue with semctl, shmctl and msgctl
to a commit from my y2038 series in linux-5.1, as I missed the custom
sys_ipc() wrapper that sparc64 uses in place of the generic version that
I patched.

The problem is that the sys_{sem,shm,msg}ctl() functions in the kernel
now do not allow being called with the IPC_64 flag any more, resulting
in a -EINVAL error when they don't recognize the command.

Instead, the correct way to do this now is to call the internal
ksys_old_{sem,shm,msg}ctl() functions to select the API version.

As we generally move towards these functions anyway, change all of
sparc_ipc() to consistently use those in place of the sys_*() versions,
and move the required ksys_*() declarations into linux/syscalls.h

Reported-by: Matt Turner <mattst88@gmail.com>
Fixes: 275f22148e87 ("ipc: rename old-style shmctl/semctl/msgctl syscalls")
Cc: stable@vger.kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
Hi Matt,

Can you check that this solves your problem?
---
 arch/sparc/kernel/sys_sparc_64.c | 30 +++++++++++++++---------------
 include/linux/syscalls.h         | 19 +++++++++++++++++++
 ipc/util.h                       | 25 ++-----------------------
 3 files changed, 36 insertions(+), 38 deletions(-)

diff --git a/arch/sparc/kernel/sys_sparc_64.c b/arch/sparc/kernel/sys_sparc_64.c
index ccc88926bc00..5ad0494df367 100644
--- a/arch/sparc/kernel/sys_sparc_64.c
+++ b/arch/sparc/kernel/sys_sparc_64.c
@@ -340,21 +340,21 @@ SYSCALL_DEFINE6(sparc_ipc, unsigned int, call, int, first, unsigned long, second
 	if (call <= SEMTIMEDOP) {
 		switch (call) {
 		case SEMOP:
-			err = sys_semtimedop(first, ptr,
-					     (unsigned int)second, NULL);
+			err = ksys_semtimedop(first, ptr,
+					      (unsigned int)second, NULL);
 			goto out;
 		case SEMTIMEDOP:
-			err = sys_semtimedop(first, ptr, (unsigned int)second,
+			err = ksys_semtimedop(first, ptr, (unsigned int)second,
 				(const struct __kernel_timespec __user *)
-					     (unsigned long) fifth);
+					      (unsigned long) fifth);
 			goto out;
 		case SEMGET:
-			err = sys_semget(first, (int)second, (int)third);
+			err = ksys_semget(first, (int)second, (int)third);
 			goto out;
 		case SEMCTL: {
-			err = sys_semctl(first, second,
-					 (int)third | IPC_64,
-					 (unsigned long) ptr);
+			err = ksys_old_semctl(first, second,
+					      (int)third | IPC_64,
+					      (unsigned long) ptr);
 			goto out;
 		}
 		default:
@@ -365,18 +365,18 @@ SYSCALL_DEFINE6(sparc_ipc, unsigned int, call, int, first, unsigned long, second
 	if (call <= MSGCTL) {
 		switch (call) {
 		case MSGSND:
-			err = sys_msgsnd(first, ptr, (size_t)second,
+			err = ksys_msgsnd(first, ptr, (size_t)second,
 					 (int)third);
 			goto out;
 		case MSGRCV:
-			err = sys_msgrcv(first, ptr, (size_t)second, fifth,
+			err = ksys_msgrcv(first, ptr, (size_t)second, fifth,
 					 (int)third);
 			goto out;
 		case MSGGET:
-			err = sys_msgget((key_t)first, (int)second);
+			err = ksys_msgget((key_t)first, (int)second);
 			goto out;
 		case MSGCTL:
-			err = sys_msgctl(first, (int)second | IPC_64, ptr);
+			err = ksys_old_msgctl(first, (int)second | IPC_64, ptr);
 			goto out;
 		default:
 			err = -ENOSYS;
@@ -396,13 +396,13 @@ SYSCALL_DEFINE6(sparc_ipc, unsigned int, call, int, first, unsigned long, second
 			goto out;
 		}
 		case SHMDT:
-			err = sys_shmdt(ptr);
+			err = ksys_shmdt(ptr);
 			goto out;
 		case SHMGET:
-			err = sys_shmget(first, (size_t)second, (int)third);
+			err = ksys_shmget(first, (size_t)second, (int)third);
 			goto out;
 		case SHMCTL:
-			err = sys_shmctl(first, (int)second | IPC_64, ptr);
+			err = ksys_old_shmctl(first, (int)second | IPC_64, ptr);
 			goto out;
 		default:
 			err = -ENOSYS;
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 88145da7d140..f7c561c4dcdd 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -1402,4 +1402,23 @@ static inline unsigned int ksys_personality(unsigned int personality)
 	return old;
 }
 
+/* for __ARCH_WANT_SYS_IPC */
+long ksys_semtimedop(int semid, struct sembuf __user *tsops,
+		     unsigned int nsops,
+		     const struct __kernel_timespec __user *timeout);
+long ksys_semget(key_t key, int nsems, int semflg);
+long ksys_old_semctl(int semid, int semnum, int cmd, unsigned long arg);
+long ksys_msgget(key_t key, int msgflg);
+long ksys_old_msgctl(int msqid, int cmd, struct msqid_ds __user *buf);
+long ksys_msgrcv(int msqid, struct msgbuf __user *msgp, size_t msgsz,
+		 long msgtyp, int msgflg);
+long ksys_msgsnd(int msqid, struct msgbuf __user *msgp, size_t msgsz,
+		 int msgflg);
+long ksys_shmget(key_t key, size_t size, int shmflg);
+long ksys_shmdt(char __user *shmaddr);
+long ksys_old_shmctl(int shmid, int cmd, struct shmid_ds __user *buf);
+long compat_ksys_semtimedop(int semid, struct sembuf __user *tsems,
+			    unsigned int nsops,
+			    const struct old_timespec32 __user *timeout);
+
 #endif
diff --git a/ipc/util.h b/ipc/util.h
index 0fcf8e719b76..5766c61aed0e 100644
--- a/ipc/util.h
+++ b/ipc/util.h
@@ -276,29 +276,7 @@ static inline int compat_ipc_parse_version(int *cmd)
 	*cmd &= ~IPC_64;
 	return version;
 }
-#endif
 
-/* for __ARCH_WANT_SYS_IPC */
-long ksys_semtimedop(int semid, struct sembuf __user *tsops,
-		     unsigned int nsops,
-		     const struct __kernel_timespec __user *timeout);
-long ksys_semget(key_t key, int nsems, int semflg);
-long ksys_old_semctl(int semid, int semnum, int cmd, unsigned long arg);
-long ksys_msgget(key_t key, int msgflg);
-long ksys_old_msgctl(int msqid, int cmd, struct msqid_ds __user *buf);
-long ksys_msgrcv(int msqid, struct msgbuf __user *msgp, size_t msgsz,
-		 long msgtyp, int msgflg);
-long ksys_msgsnd(int msqid, struct msgbuf __user *msgp, size_t msgsz,
-		 int msgflg);
-long ksys_shmget(key_t key, size_t size, int shmflg);
-long ksys_shmdt(char __user *shmaddr);
-long ksys_old_shmctl(int shmid, int cmd, struct shmid_ds __user *buf);
-
-/* for CONFIG_ARCH_WANT_OLD_COMPAT_IPC */
-long compat_ksys_semtimedop(int semid, struct sembuf __user *tsems,
-			    unsigned int nsops,
-			    const struct old_timespec32 __user *timeout);
-#ifdef CONFIG_COMPAT
 long compat_ksys_old_semctl(int semid, int semnum, int cmd, int arg);
 long compat_ksys_old_msgctl(int msqid, int cmd, void __user *uptr);
 long compat_ksys_msgrcv(int msqid, compat_uptr_t msgp, compat_ssize_t msgsz,
@@ -306,6 +284,7 @@ long compat_ksys_msgrcv(int msqid, compat_uptr_t msgp, compat_ssize_t msgsz,
 long compat_ksys_msgsnd(int msqid, compat_uptr_t msgp,
 		       compat_ssize_t msgsz, int msgflg);
 long compat_ksys_old_shmctl(int shmid, int cmd, void __user *uptr);
-#endif /* CONFIG_COMPAT */
+
+#endif
 
 #endif
-- 
2.20.0
