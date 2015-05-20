From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 8/9] y2038: xtensa: extend sysvipc data structures
Date: Wed, 20 May 2015 17:07:24 +0200
Message-ID: <1432134445-804487-9-git-send-email-arnd@arndb.de>
References: <1432134445-804487-1-git-send-email-arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1432134445-804487-1-git-send-email-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: y2038@lists.linaro.org
Cc: baolin.wang@linaro.org, albert.aribaud@3adev.fr, john.stultz@linaro.org, bamvor.zhangjian@linaro.org, ruchandani.tina@gmail.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, libc-alpha@sourceware.org, linux-arch@vger.kernel.org, Manfred Spraul <manfred@colorfullife.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Arnd Bergmann <arnd@arndb.de>
List-Id: linux-api@vger.kernel.org

xtensa, uses a nonstandard variation of the generic sysvipc
data structures, intended to have the padding moved around
so it can deal with big-endian 32-bit user space that has
64-bit time_t.

xtensa tries hard to define the structures so they work
in both big-endian and little-endian systems with padding
on the right side.
However, they only succeeded for for two of the three structures,
and their struct shmid64_ds ended up being defined in two
identical copies, and the big-endian one is wrong.

This takes just take the same approach here that we have for
the asm-generic headers and adds separate 32-bit fields for the
upper halves of the timestamps, to let libc deal with the mess
in user space.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/xtensa/include/uapi/asm/msgbuf.h | 24 +++++++++++------------
 arch/xtensa/include/uapi/asm/sembuf.h | 16 ++++++++--------
 arch/xtensa/include/uapi/asm/shmbuf.h | 36 ++++++++---------------------------
 3 files changed, 28 insertions(+), 48 deletions(-)

diff --git a/arch/xtensa/include/uapi/asm/msgbuf.h b/arch/xtensa/include/uapi/asm/msgbuf.h
index 693c96755280..5805072c6257 100644
--- a/arch/xtensa/include/uapi/asm/msgbuf.h
+++ b/arch/xtensa/include/uapi/asm/msgbuf.h
@@ -20,19 +20,19 @@
 struct msqid64_ds {
 	struct ipc64_perm msg_perm;
 #ifdef __XTENSA_EB__
-	unsigned int	__unused1;
-	__kernel_time_t msg_stime;	/* last msgsnd time */
-	unsigned int	__unused2;
-	__kernel_time_t msg_rtime;	/* last msgrcv time */
-	unsigned int	__unused3;
-	__kernel_time_t msg_ctime;	/* last change time */
+	unsigned long  msg_stime_high;
+	unsigned long  msg_stime;	/* last msgsnd time */
+	unsigned long  msg_rtime_high;
+	unsigned long  msg_rtime;	/* last msgrcv time */
+	unsigned long  msg_ctime_high;
+	unsigned long  msg_ctime;	/* last change time */
 #elif defined(__XTENSA_EL__)
-	__kernel_time_t msg_stime;	/* last msgsnd time */
-	unsigned int	__unused1;
-	__kernel_time_t msg_rtime;	/* last msgrcv time */
-	unsigned int	__unused2;
-	__kernel_time_t msg_ctime;	/* last change time */
-	unsigned int	__unused3;
+	unsigned long  msg_stime;	/* last msgsnd time */
+	unsigned long  msg_stime_high;
+	unsigned long  msg_rtime;	/* last msgrcv time */
+	unsigned long  msg_rtime_high;
+	unsigned long  msg_ctime;	/* last change time */
+	unsigned long  msg_ctime_high;
 #else
 # error processor byte order undefined!
 #endif
diff --git a/arch/xtensa/include/uapi/asm/sembuf.h b/arch/xtensa/include/uapi/asm/sembuf.h
index c15870493b33..4b9b0580ca45 100644
--- a/arch/xtensa/include/uapi/asm/sembuf.h
+++ b/arch/xtensa/include/uapi/asm/sembuf.h
@@ -26,15 +26,15 @@
 struct semid64_ds {
 	struct ipc64_perm sem_perm;		/* permissions .. see ipc.h */
 #ifdef __XTENSA_EL__
-	__kernel_time_t	sem_otime;		/* last semop time */
-	unsigned long	__unused1;
-	__kernel_time_t	sem_ctime;		/* last change time */
-	unsigned long	__unused2;
+	unsigned long	sem_otime;		/* last semop time */
+	unsigned long	sem_otime_high;
+	unsigned long	sem_ctime;		/* last change time */
+	unsigned long	sem_ctime_high;
 #else
-	unsigned long	__unused1;
-	__kernel_time_t	sem_otime;		/* last semop time */
-	unsigned long	__unused2;
-	__kernel_time_t	sem_ctime;		/* last change time */
+	unsigned long	sem_otime_high;
+	unsigned long	sem_otime;		/* last semop time */
+	unsigned long	sem_ctime_high;
+	unsigned long	sem_ctime;		/* last change time */
 #endif
 	unsigned long	sem_nsems;		/* no. of semaphores in array */
 	unsigned long	__unused3;
diff --git a/arch/xtensa/include/uapi/asm/shmbuf.h b/arch/xtensa/include/uapi/asm/shmbuf.h
index ad4b0121782c..baf34a0bffe5 100644
--- a/arch/xtensa/include/uapi/asm/shmbuf.h
+++ b/arch/xtensa/include/uapi/asm/shmbuf.h
@@ -3,7 +3,8 @@
  *
  * The shmid64_ds structure for Xtensa architecture.
  * Note extra padding because this structure is passed back and forth
- * between kernel and user space.
+ * between kernel and user space, but the padding is on the wrong
+ * side for big-endian xtensa, for historic reasons.
  *
  * Pad space is left for:
  * - 64-bit time_t to solve y2038 problem
@@ -19,42 +20,21 @@
 #ifndef _XTENSA_SHMBUF_H
 #define _XTENSA_SHMBUF_H
 
-#if defined (__XTENSA_EL__)
 struct shmid64_ds {
 	struct ipc64_perm	shm_perm;	/* operation perms */
 	size_t			shm_segsz;	/* size of segment (bytes) */
-	__kernel_time_t		shm_atime;	/* last attach time */
-	unsigned long		__unused1;
-	__kernel_time_t		shm_dtime;	/* last detach time */
-	unsigned long		__unused2;
-	__kernel_time_t		shm_ctime;	/* last change time */
-	unsigned long		__unused3;
+	unsigned long		shm_atime;	/* last attach time */
+	unsigned long		shm_atime_high;
+	unsigned long		shm_dtime;	/* last detach time */
+	unsigned long		shm_dtime_high;
+	unsigned long		shm_ctime;	/* last change time */
+	unsigned long		shm_ctime_high;
 	__kernel_pid_t		shm_cpid;	/* pid of creator */
 	__kernel_pid_t		shm_lpid;	/* pid of last operator */
 	unsigned long		shm_nattch;	/* no. of current attaches */
 	unsigned long		__unused4;
 	unsigned long		__unused5;
 };
-#elif defined (__XTENSA_EB__)
-struct shmid64_ds {
-	struct ipc64_perm	shm_perm;	/* operation perms */
-	size_t			shm_segsz;	/* size of segment (bytes) */
-	__kernel_time_t		shm_atime;	/* last attach time */
-	unsigned long		__unused1;
-	__kernel_time_t		shm_dtime;	/* last detach time */
-	unsigned long		__unused2;
-	__kernel_time_t		shm_ctime;	/* last change time */
-	unsigned long		__unused3;
-	__kernel_pid_t		shm_cpid;	/* pid of creator */
-	__kernel_pid_t		shm_lpid;	/* pid of last operator */
-	unsigned long		shm_nattch;	/* no. of current attaches */
-	unsigned long		__unused4;
-	unsigned long		__unused5;
-};
-#else
-# error endian order not defined
-#endif
-
 
 struct shminfo64 {
 	unsigned long	shmmax;
-- 
2.1.0.rc2
