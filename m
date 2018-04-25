From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v4 05/16] y2038: s390: Remove unneeded ipc uapi header files
Date: Wed, 25 Apr 2018 17:05:55 +0200
Message-ID: <20180425150606.954771-5-arnd@arndb.de>
References: <20180425132242.1500539-1-arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180425132242.1500539-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: y2038@lists.linaro.org, linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, linux-arch@vger.kernel.org, libc-alpha@sourceware.org, tglx@linutronix.de, deepa.kernel@gmail.com, viro@zeniv.linux.org.uk, ebiederm@xmission.com, albert.aribaud@3adev.fr, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, x86@kernel.org, catalin.marinas@arm.com, will.deacon@arm.com, linux-mips@linux-mips.org, jhogan@kernel.org, ralf@linux-mips.org, linuxppc-dev@lists.ozlabs.org, sparclinux@vger.kernel.org, zackw@panix.com, noloader@gmail.com, Arnd Bergmann <arnd@arndb.de>
List-Id: linux-api@vger.kernel.org

The s390 msgbuf/sembuf/shmbuf header files are all identical to the
version from asm-generic.

This patch removes the files and replaces them with 'generic-y'
statements, to avoid having to modify each copy when we extend sysvipc
to deal with 64-bit time_t in 32-bit user space.

Note that unlike alpha and ia64, the ipcbuf.h header file is slightly
different here, so I'm leaving the private copy.

To deal with 32-bit compat tasks, we also have to adapt the definitions
of compat_{shm,sem,msg}id_ds to match the changes to the respective
asm-generic files.

Acked-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/s390/include/asm/compat.h      | 32 ++++++++++++------------
 arch/s390/include/uapi/asm/Kbuild   |  3 +++
 arch/s390/include/uapi/asm/msgbuf.h | 38 ----------------------------
 arch/s390/include/uapi/asm/sembuf.h | 30 -----------------------
 arch/s390/include/uapi/asm/shmbuf.h | 49 -------------------------------------
 5 files changed, 19 insertions(+), 133 deletions(-)
 delete mode 100644 arch/s390/include/uapi/asm/msgbuf.h
 delete mode 100644 arch/s390/include/uapi/asm/sembuf.h
 delete mode 100644 arch/s390/include/uapi/asm/shmbuf.h

diff --git a/arch/s390/include/asm/compat.h b/arch/s390/include/asm/compat.h
index 501aaff85304..97db2fba546a 100644
--- a/arch/s390/include/asm/compat.h
+++ b/arch/s390/include/asm/compat.h
@@ -232,10 +232,10 @@ struct compat_ipc64_perm {
 
 struct compat_semid64_ds {
 	struct compat_ipc64_perm sem_perm;
-	compat_time_t  sem_otime;
-	compat_ulong_t __pad1;
-	compat_time_t  sem_ctime;
-	compat_ulong_t __pad2;
+	compat_ulong_t sem_otime;
+	compat_ulong_t sem_otime_high;
+	compat_ulong_t sem_ctime;
+	compat_ulong_t sem_ctime_high;
 	compat_ulong_t sem_nsems;
 	compat_ulong_t __unused1;
 	compat_ulong_t __unused2;
@@ -243,12 +243,12 @@ struct compat_semid64_ds {
 
 struct compat_msqid64_ds {
 	struct compat_ipc64_perm msg_perm;
-	compat_time_t   msg_stime;
-	compat_ulong_t __pad1;
-	compat_time_t   msg_rtime;
-	compat_ulong_t __pad2;
-	compat_time_t   msg_ctime;
-	compat_ulong_t __pad3;
+	compat_ulong_t msg_stime;
+	compat_ulong_t msg_stime_high;
+	compat_ulong_t msg_rtime;
+	compat_ulong_t msg_rtime_high;
+	compat_ulong_t msg_ctime;
+	compat_ulong_t msg_ctime_high;
 	compat_ulong_t msg_cbytes;
 	compat_ulong_t msg_qnum;
 	compat_ulong_t msg_qbytes;
@@ -261,12 +261,12 @@ struct compat_msqid64_ds {
 struct compat_shmid64_ds {
 	struct compat_ipc64_perm shm_perm;
 	compat_size_t  shm_segsz;
-	compat_time_t  shm_atime;
-	compat_ulong_t __pad1;
-	compat_time_t  shm_dtime;
-	compat_ulong_t __pad2;
-	compat_time_t  shm_ctime;
-	compat_ulong_t __pad3;
+	compat_ulong_t shm_atime;
+	compat_ulong_t shm_atime_high;
+	compat_ulong_t shm_dtime;
+	compat_ulong_t shm_dtime_high;
+	compat_ulong_t shm_ctime;
+	compat_ulong_t shm_ctime_high;
 	compat_pid_t   shm_cpid;
 	compat_pid_t   shm_lpid;
 	compat_ulong_t shm_nattch;
diff --git a/arch/s390/include/uapi/asm/Kbuild b/arch/s390/include/uapi/asm/Kbuild
index faef3f7e8353..e364873e0d10 100644
--- a/arch/s390/include/uapi/asm/Kbuild
+++ b/arch/s390/include/uapi/asm/Kbuild
@@ -9,9 +9,12 @@ generic-y += errno.h
 generic-y += fcntl.h
 generic-y += ioctl.h
 generic-y += mman.h
+generic-y += msgbuf.h
 generic-y += param.h
 generic-y += poll.h
 generic-y += resource.h
+generic-y += sembuf.h
+generic-y += shmbuf.h
 generic-y += sockios.h
 generic-y += swab.h
 generic-y += termbits.h
diff --git a/arch/s390/include/uapi/asm/msgbuf.h b/arch/s390/include/uapi/asm/msgbuf.h
deleted file mode 100644
index 604f847cd68c..000000000000
--- a/arch/s390/include/uapi/asm/msgbuf.h
+++ /dev/null
@@ -1,38 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
-#ifndef _S390_MSGBUF_H
-#define _S390_MSGBUF_H
-
-/* 
- * The msqid64_ds structure for S/390 architecture.
- * Note extra padding because this structure is passed back and forth
- * between kernel and user space.
- *
- * Pad space is left for:
- * - 64-bit time_t to solve y2038 problem
- * - 2 miscellaneous 32-bit values
- */
-
-struct msqid64_ds {
-	struct ipc64_perm msg_perm;
-	__kernel_time_t msg_stime;	/* last msgsnd time */
-#ifndef __s390x__
-	unsigned long	__unused1;
-#endif /* ! __s390x__ */
-	__kernel_time_t msg_rtime;	/* last msgrcv time */
-#ifndef __s390x__
-	unsigned long	__unused2;
-#endif /* ! __s390x__ */
-	__kernel_time_t msg_ctime;	/* last change time */
-#ifndef __s390x__
-	unsigned long	__unused3;
-#endif /* ! __s390x__ */
-	unsigned long  msg_cbytes;	/* current number of bytes on queue */
-	unsigned long  msg_qnum;	/* number of messages in queue */
-	unsigned long  msg_qbytes;	/* max number of bytes on queue */
-	__kernel_pid_t msg_lspid;	/* pid of last msgsnd */
-	__kernel_pid_t msg_lrpid;	/* last receive pid */
-	unsigned long  __unused4;
-	unsigned long  __unused5;
-};
-
-#endif /* _S390_MSGBUF_H */
diff --git a/arch/s390/include/uapi/asm/sembuf.h b/arch/s390/include/uapi/asm/sembuf.h
deleted file mode 100644
index 3e917697b668..000000000000
--- a/arch/s390/include/uapi/asm/sembuf.h
+++ /dev/null
@@ -1,30 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
-#ifndef _S390_SEMBUF_H
-#define _S390_SEMBUF_H
-
-/* 
- * The semid64_ds structure for S/390 architecture.
- * Note extra padding because this structure is passed back and forth
- * between kernel and user space.
- *
- * Pad space is left for:
- * - 64-bit time_t to solve y2038 problem (for !__s390x__)
- * - 2 miscellaneous 32-bit values
- */
-
-struct semid64_ds {
-	struct ipc64_perm sem_perm;		/* permissions .. see ipc.h */
-	__kernel_time_t	sem_otime;		/* last semop time */
-#ifndef __s390x__
-	unsigned long	__unused1;
-#endif /* ! __s390x__ */
-	__kernel_time_t	sem_ctime;		/* last change time */
-#ifndef __s390x__
-	unsigned long	__unused2;
-#endif /* ! __s390x__ */
-	unsigned long	sem_nsems;		/* no. of semaphores in array */
-	unsigned long	__unused3;
-	unsigned long	__unused4;
-};
-
-#endif /* _S390_SEMBUF_H */
diff --git a/arch/s390/include/uapi/asm/shmbuf.h b/arch/s390/include/uapi/asm/shmbuf.h
deleted file mode 100644
index 9cdce8d7ce60..000000000000
--- a/arch/s390/include/uapi/asm/shmbuf.h
+++ /dev/null
@@ -1,49 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
-#ifndef _S390_SHMBUF_H
-#define _S390_SHMBUF_H
-
-/* 
- * The shmid64_ds structure for S/390 architecture.
- * Note extra padding because this structure is passed back and forth
- * between kernel and user space.
- *
- * Pad space is left for:
- * - 64-bit time_t to solve y2038 problem (for !__s390x__)
- * - 2 miscellaneous 32-bit values
- */
-
-struct shmid64_ds {
-	struct ipc64_perm	shm_perm;	/* operation perms */
-	size_t			shm_segsz;	/* size of segment (bytes) */
-	__kernel_time_t		shm_atime;	/* last attach time */
-#ifndef __s390x__
-	unsigned long		__unused1;
-#endif /* ! __s390x__ */
-	__kernel_time_t		shm_dtime;	/* last detach time */
-#ifndef __s390x__
-	unsigned long		__unused2;
-#endif /* ! __s390x__ */
-	__kernel_time_t		shm_ctime;	/* last change time */
-#ifndef __s390x__
-	unsigned long		__unused3;
-#endif /* ! __s390x__ */
-	__kernel_pid_t		shm_cpid;	/* pid of creator */
-	__kernel_pid_t		shm_lpid;	/* pid of last operator */
-	unsigned long		shm_nattch;	/* no. of current attaches */
-	unsigned long		__unused4;
-	unsigned long		__unused5;
-};
-
-struct shminfo64 {
-	unsigned long	shmmax;
-	unsigned long	shmmin;
-	unsigned long	shmmni;
-	unsigned long	shmseg;
-	unsigned long	shmall;
-	unsigned long	__unused1;
-	unsigned long	__unused2;
-	unsigned long	__unused3;
-	unsigned long	__unused4;
-};
-
-#endif /* _S390_SHMBUF_H */
-- 
2.9.0
