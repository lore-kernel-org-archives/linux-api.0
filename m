From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 6/9] y2038: sparc: extend sysvipc data structures
Date: Wed, 20 May 2015 17:07:22 +0200
Message-ID: <1432134445-804487-7-git-send-email-arnd@arndb.de>
References: <1432134445-804487-1-git-send-email-arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1432134445-804487-1-git-send-email-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: y2038@lists.linaro.org
Cc: baolin.wang@linaro.org, albert.aribaud@3adev.fr, john.stultz@linaro.org, bamvor.zhangjian@linaro.org, ruchandani.tina@gmail.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, libc-alpha@sourceware.org, linux-arch@vger.kernel.org, Manfred Spraul <manfred@colorfullife.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Arnd Bergmann <arnd@arndb.de>
List-Id: linux-api@vger.kernel.org

sparc, uses a nonstandard variation of the generic sysvipc
data structures, intended to have the padding moved around
so it can deal with big-endian 32-bit user space that has
64-bit time_t.

Unlike most architectures, sparc actually succeeded in
defining this right for big-endian CPUs, but as everyone else
got it wrong, we just use the same hack everywhere.

This takes just take the same approach here that we have for
the asm-generic headers and adds separate 32-bit fields for the
upper halves of the timestamps, to let libc deal with the mess
in user space.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/sparc/include/asm/compat.h      | 32 ++++++++++++++++----------------
 arch/sparc/include/uapi/asm/msgbuf.h | 21 +++++++++------------
 arch/sparc/include/uapi/asm/sembuf.h | 15 +++++++--------
 arch/sparc/include/uapi/asm/shmbuf.h | 20 +++++++++-----------
 4 files changed, 41 insertions(+), 47 deletions(-)

diff --git a/arch/sparc/include/asm/compat.h b/arch/sparc/include/asm/compat.h
index c7e71a6d7232..f7ce331561dd 100644
--- a/arch/sparc/include/asm/compat.h
+++ b/arch/sparc/include/asm/compat.h
@@ -249,10 +249,10 @@ struct compat_ipc64_perm {
 
 struct compat_semid64_ds {
 	struct compat_ipc64_perm sem_perm;
-	unsigned int	__pad1;
-	compat_time_t	sem_otime;
-	unsigned int	__pad2;
-	compat_time_t	sem_ctime;
+	unsigned int	sem_otime_high;
+	unsigned int	sem_otime;
+	unsigned int	sem_ctime_high;
+	unsigned int	sem_ctime;
 	u32		sem_nsems;
 	u32		__unused1;
 	u32		__unused2;
@@ -260,12 +260,12 @@ struct compat_semid64_ds {
 
 struct compat_msqid64_ds {
 	struct compat_ipc64_perm msg_perm;
-	unsigned int	__pad1;
-	compat_time_t	msg_stime;
-	unsigned int	__pad2;
-	compat_time_t	msg_rtime;
-	unsigned int	__pad3;
-	compat_time_t	msg_ctime;
+	unsigned int	msg_stime_high;
+	unsigned int	msg_stime;
+	unsigned int	msg_rtime_high;
+	unsigned int	msg_rtime;
+	unsigned int	msg_ctime_high;
+	unsigned int	msg_ctime;
 	unsigned int	msg_cbytes;
 	unsigned int	msg_qnum;
 	unsigned int	msg_qbytes;
@@ -277,12 +277,12 @@ struct compat_msqid64_ds {
 
 struct compat_shmid64_ds {
 	struct compat_ipc64_perm shm_perm;
-	unsigned int	__pad1;
-	compat_time_t	shm_atime;
-	unsigned int	__pad2;
-	compat_time_t	shm_dtime;
-	unsigned int	__pad3;
-	compat_time_t	shm_ctime;
+	unsigned int	shm_atime_high;
+	unsigned int	shm_atime;
+	unsigned int	shm_dtime_high;
+	unsigned int	shm_dtime;
+	unsigned int	shm_ctime_high;
+	unsigned int	shm_ctime;
 	compat_size_t	shm_segsz;
 	compat_pid_t	shm_cpid;
 	compat_pid_t	shm_lpid;
diff --git a/arch/sparc/include/uapi/asm/msgbuf.h b/arch/sparc/include/uapi/asm/msgbuf.h
index efc7cbe9788f..50b79ebadc99 100644
--- a/arch/sparc/include/uapi/asm/msgbuf.h
+++ b/arch/sparc/include/uapi/asm/msgbuf.h
@@ -10,22 +10,20 @@
  * - 64-bit time_t to solve y2038 problem
  * - 2 miscellaneous 32-bit values
  */
-
-#if defined(__sparc__) && defined(__arch64__)
-# define PADDING(x)
-#else
-# define PADDING(x) unsigned int x;
-#endif
-
-
 struct msqid64_ds {
 	struct ipc64_perm msg_perm;
-	PADDING(__pad1)
+#if defined(__sparc__) && defined(__arch64__)
+	__kernel_time_t msg_stime;	/* last msgsnd time */
+	__kernel_time_t msg_rtime;	/* last msgrcv time */
+	__kernel_time_t msg_ctime;	/* last change time */
+#else
+	__kernel_time_t msg_stime_high;
 	__kernel_time_t msg_stime;	/* last msgsnd time */
-	PADDING(__pad2)
+	__kernel_time_t msg_rtime_high;
 	__kernel_time_t msg_rtime;	/* last msgrcv time */
-	PADDING(__pad3)
+	__kernel_time_t msg_ctime_high;
 	__kernel_time_t msg_ctime;	/* last change time */
+#endif
 	unsigned long  msg_cbytes;	/* current number of bytes on queue */
 	unsigned long  msg_qnum;	/* number of messages in queue */
 	unsigned long  msg_qbytes;	/* max number of bytes on queue */
@@ -34,5 +32,4 @@ struct msqid64_ds {
 	unsigned long  __unused1;
 	unsigned long  __unused2;
 };
-#undef PADDING
 #endif /* _SPARC_MSGBUF_H */
diff --git a/arch/sparc/include/uapi/asm/sembuf.h b/arch/sparc/include/uapi/asm/sembuf.h
index faee1be08d67..f981e235f41f 100644
--- a/arch/sparc/include/uapi/asm/sembuf.h
+++ b/arch/sparc/include/uapi/asm/sembuf.h
@@ -10,22 +10,21 @@
  * - 64-bit time_t to solve y2038 problem
  * - 2 miscellaneous 32-bit values
  */
-#if defined(__sparc__) && defined(__arch64__)
-# define PADDING(x)
-#else
-# define PADDING(x) unsigned int x;
-#endif
 
 struct semid64_ds {
 	struct ipc64_perm sem_perm;		/* permissions .. see ipc.h */
-	PADDING(__pad1)
+#if defined(__sparc__) && defined(__arch64__)
+	unsigned long	sem_otime_high;
+	unsigned long	sem_otime;		/* last semop time */
+	unsigned long	sem_ctime_high;
+	unsigned long	sem_ctime;		/* last change time */
+#else
 	__kernel_time_t	sem_otime;		/* last semop time */
-	PADDING(__pad2)
 	__kernel_time_t	sem_ctime;		/* last change time */
+#endif
 	unsigned long	sem_nsems;		/* no. of semaphores in array */
 	unsigned long	__unused1;
 	unsigned long	__unused2;
 };
-#undef PADDING
 
 #endif /* _SPARC64_SEMBUF_H */
diff --git a/arch/sparc/include/uapi/asm/shmbuf.h b/arch/sparc/include/uapi/asm/shmbuf.h
index 83a16055363f..99ccd39225a7 100644
--- a/arch/sparc/include/uapi/asm/shmbuf.h
+++ b/arch/sparc/include/uapi/asm/shmbuf.h
@@ -11,20 +11,20 @@
  * - 2 miscellaneous 32-bit values
  */
 
-#if defined(__sparc__) && defined(__arch64__)
-# define PADDING(x)
-#else
-# define PADDING(x) unsigned int x;
-#endif
-
 struct shmid64_ds {
 	struct ipc64_perm	shm_perm;	/* operation perms */
-	PADDING(__pad1)
+#if defined(__sparc__) && defined(__arch64__)
 	__kernel_time_t		shm_atime;	/* last attach time */
-	PADDING(__pad2)
 	__kernel_time_t		shm_dtime;	/* last detach time */
-	PADDING(__pad3)
 	__kernel_time_t		shm_ctime;	/* last change time */
+#else
+	unsigned long		shm_atime_high;
+	unsigned long		shm_atime;	/* last attach time */
+	unsigned long		shm_dtime_high;
+	unsigned long		shm_dtime;	/* last detach time */
+	unsigned long		shm_ctime_high;
+	unsigned long		shm_ctime;	/* last change time */
+#endif
 	size_t			shm_segsz;	/* size of segment (bytes) */
 	__kernel_pid_t		shm_cpid;	/* pid of creator */
 	__kernel_pid_t		shm_lpid;	/* pid of last operator */
@@ -45,6 +45,4 @@ struct shminfo64 {
 	unsigned long	__unused4;
 };
 
-#undef PADDING
-
 #endif /* _SPARC_SHMBUF_H */
-- 
2.1.0.rc2
