From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 7/9] y2038: powerpc: extend sysvipc data structures
Date: Wed, 20 May 2015 17:07:23 +0200
Message-ID: <1432134445-804487-8-git-send-email-arnd@arndb.de>
References: <1432134445-804487-1-git-send-email-arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1432134445-804487-1-git-send-email-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: y2038@lists.linaro.org
Cc: baolin.wang@linaro.org, albert.aribaud@3adev.fr, john.stultz@linaro.org, bamvor.zhangjian@linaro.org, ruchandani.tina@gmail.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, libc-alpha@sourceware.org, linux-arch@vger.kernel.org, Manfred Spraul <manfred@colorfullife.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Arnd Bergmann <arnd@arndb.de>
List-Id: linux-api@vger.kernel.org

powerpc, uses a nonstandard variation of the generic sysvipc
data structures, intended to have the padding moved around
so it can deal with big-endian 32-bit user space that has
64-bit time_t.

powerpc has the same definition as parisc and sparc, but now also
supports little-endian mode, which is now wrong because the
padding is made for big-endian user space.

This takes just take the same approach here that we have for
the asm-generic headers and adds separate 32-bit fields for the
upper halves of the timestamps, to let libc deal with the mess
in user space.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/powerpc/include/asm/compat.h      | 32 ++++++++++++++++----------------
 arch/powerpc/include/uapi/asm/msgbuf.h | 18 +++++++++---------
 arch/powerpc/include/uapi/asm/sembuf.h | 14 +++++++-------
 arch/powerpc/include/uapi/asm/shmbuf.h | 18 ++++++++----------
 4 files changed, 40 insertions(+), 42 deletions(-)

diff --git a/arch/powerpc/include/asm/compat.h b/arch/powerpc/include/asm/compat.h
index 4f8901448eba..2bdcb95ca0ec 100644
--- a/arch/powerpc/include/asm/compat.h
+++ b/arch/powerpc/include/asm/compat.h
@@ -221,10 +221,10 @@ struct compat_ipc64_perm {
 
 struct compat_semid64_ds {
 	struct compat_ipc64_perm sem_perm;
-	unsigned int __unused1;
-	compat_time_t sem_otime;
-	unsigned int __unused2;
-	compat_time_t sem_ctime;
+	unsigned int sem_otime_high;
+	unsigned int sem_otime;
+	unsigned int sem_ctime_high;
+	unsigned int sem_ctime;
 	compat_ulong_t sem_nsems;
 	compat_ulong_t __unused3;
 	compat_ulong_t __unused4;
@@ -232,12 +232,12 @@ struct compat_semid64_ds {
 
 struct compat_msqid64_ds {
 	struct compat_ipc64_perm msg_perm;
-	unsigned int __unused1;
-	compat_time_t msg_stime;
-	unsigned int __unused2;
-	compat_time_t msg_rtime;
-	unsigned int __unused3;
-	compat_time_t msg_ctime;
+	unsigned int msg_stime_high;
+	unsigned int msg_stime;
+	unsigned int msg_rtime_high;
+	unsigned int msg_rtime;
+	unsigned int msg_ctime_high;
+	unsigned int msg_ctime;
 	compat_ulong_t msg_cbytes;
 	compat_ulong_t msg_qnum;
 	compat_ulong_t msg_qbytes;
@@ -249,12 +249,12 @@ struct compat_msqid64_ds {
 
 struct compat_shmid64_ds {
 	struct compat_ipc64_perm shm_perm;
-	unsigned int __unused1;
-	compat_time_t shm_atime;
-	unsigned int __unused2;
-	compat_time_t shm_dtime;
-	unsigned int __unused3;
-	compat_time_t shm_ctime;
+	unsigned int shm_atime_high;
+	unsigned int shm_atime;
+	unsigned int shm_dtime_high;
+	unsigned int shm_dtime;
+	unsigned int shm_ctime_high;
+	unsigned int shm_ctime;
 	unsigned int __unused4;
 	compat_size_t shm_segsz;
 	compat_pid_t shm_cpid;
diff --git a/arch/powerpc/include/uapi/asm/msgbuf.h b/arch/powerpc/include/uapi/asm/msgbuf.h
index dd76743c7537..c5534fd3df40 100644
--- a/arch/powerpc/include/uapi/asm/msgbuf.h
+++ b/arch/powerpc/include/uapi/asm/msgbuf.h
@@ -9,18 +9,18 @@
 
 struct msqid64_ds {
 	struct ipc64_perm msg_perm;
-#ifndef __powerpc64__
-	unsigned int	__unused1;
-#endif
+#ifdef __powerpc64__
 	__kernel_time_t msg_stime;	/* last msgsnd time */
-#ifndef __powerpc64__
-	unsigned int	__unused2;
-#endif
 	__kernel_time_t msg_rtime;	/* last msgrcv time */
-#ifndef __powerpc64__
-	unsigned int	__unused3;
-#endif
 	__kernel_time_t msg_ctime;	/* last change time */
+#else
+	unsigned long  msg_stime_high;
+	unsigned long  msg_stime;	/* last msgsnd time */
+	unsigned long  msg_rtime_high;
+	unsigned long  msg_rtime;	/* last msgrcv time */
+	unsigned long  msg_ctime_high;
+	unsigned long  msg_ctime;	/* last change time */
+#endif
 	unsigned long  msg_cbytes;	/* current number of bytes on queue */
 	unsigned long  msg_qnum;	/* number of messages in queue */
 	unsigned long  msg_qbytes;	/* max number of bytes on queue */
diff --git a/arch/powerpc/include/uapi/asm/sembuf.h b/arch/powerpc/include/uapi/asm/sembuf.h
index 99a41938ae3d..f78b129fd68e 100644
--- a/arch/powerpc/include/uapi/asm/sembuf.h
+++ b/arch/powerpc/include/uapi/asm/sembuf.h
@@ -14,20 +14,20 @@
  * between kernel and user space.
  *
  * Pad space is left for:
- * - 64-bit time_t to solve y2038 problem
- * - 2 miscellaneous 32-bit values
+ * - 2 miscellaneous 32/64-bit values
  */
 
 struct semid64_ds {
 	struct ipc64_perm sem_perm;	/* permissions .. see ipc.h */
 #ifndef __powerpc64__
-	unsigned long	__unused1;
-#endif
+	unsigned long	sem_otime_high;
+	unsigned long	sem_otime;	/* last semop time */
+	unsigned long	sem_ctime_high;
+	unsigned long	sem_ctime;	/* last change time */
+#else
 	__kernel_time_t	sem_otime;	/* last semop time */
-#ifndef __powerpc64__
-	unsigned long	__unused2;
-#endif
 	__kernel_time_t	sem_ctime;	/* last change time */
+#endif
 	unsigned long	sem_nsems;	/* no. of semaphores in array */
 	unsigned long	__unused3;
 	unsigned long	__unused4;
diff --git a/arch/powerpc/include/uapi/asm/shmbuf.h b/arch/powerpc/include/uapi/asm/shmbuf.h
index 8efa39698b6c..c57bfec7317c 100644
--- a/arch/powerpc/include/uapi/asm/shmbuf.h
+++ b/arch/powerpc/include/uapi/asm/shmbuf.h
@@ -21,19 +21,17 @@
 
 struct shmid64_ds {
 	struct ipc64_perm	shm_perm;	/* operation perms */
-#ifndef __powerpc64__
-	unsigned long		__unused1;
-#endif
+#ifdef __powerpc64__
 	__kernel_time_t		shm_atime;	/* last attach time */
-#ifndef __powerpc64__
-	unsigned long		__unused2;
-#endif
 	__kernel_time_t		shm_dtime;	/* last detach time */
-#ifndef __powerpc64__
-	unsigned long		__unused3;
-#endif
 	__kernel_time_t		shm_ctime;	/* last change time */
-#ifndef __powerpc64__
+#else
+	unsigned long		shm_atime_high;
+	unsigned long		shm_atime;	/* last attach time */
+	unsigned long		shm_dtime_high;
+	unsigned long		shm_dtime;	/* last detach time */
+	unsigned long		shm_ctime_high;
+	unsigned long		shm_ctime;	/* last change time */
 	unsigned long		__unused4;
 #endif
 	size_t			shm_segsz;	/* size of segment (bytes) */
-- 
2.1.0.rc2
