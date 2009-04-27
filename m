From: arnd-r2nGTMty4D4@public.gmane.org
Subject: [RFC 08/17] asm-generic: provide generic sysv ipc headers
Date: Mon, 27 Apr 2009 17:01:22 +0200
Message-ID: <20090427150318.542245635@arndb.de>
References: <20090427142010.587518220@arndb.de>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline; filename=0004-asm-generic-provide-generic-sysv-ipc-headers.patch
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: john.williams-g5w7nrANp4BDPfheJLI6IQ@public.gmane.org, monstr-pSz03upnqPeHXe+LvDLADg@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, liqin.chen-+XGAvkf1AAHby3iVrkZq2A@public.gmane.org, Sam Ravnborg <sam-uyr5N9Q2VtJg9hUCZPvPmw@public.gmane.org>, Remis Lima Baima <remis.developer-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
List-Id: linux-api@vger.kernel.org

The ipc64 data structures were originally meant to
be architecture specific so that each architecture
could add their own optimizations for padding.

In the end, most of them just copied the x86 version,
and most got that wrong. UClibc expects the x86 anyway,
so we might just declare that the default and get
rid of the extra copies.

Signed-off-by: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Signed-off-by: Remis Lima Baima <remis.developer-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
---
 include/asm-generic/Kbuild     |    5 	5 +	0 -	0 !
 include/asm-generic/ipcbuf.h   |   33 	33 +	0 -	0 !
 include/asm-generic/msgbuf.h   |   47 	47 +	0 -	0 !
 include/asm-generic/sembuf.h   |   38 	38 +	0 -	0 !
 include/asm-generic/shmbuf.h   |   59 	59 +	0 -	0 !
 include/asm-generic/shmparam.h |    6 	6 +	0 -	0 !
 6 files changed, 188 insertions(+)
 create mode 100644 include/asm-generic/ipcbuf.h
 create mode 100644 include/asm-generic/msgbuf.h
 create mode 100644 include/asm-generic/sembuf.h
 create mode 100644 include/asm-generic/shmbuf.h
 create mode 100644 include/asm-generic/shmparam.h

Index: linux-2.6/include/asm-generic/Kbuild
===================================================================
--- linux-2.6.orig/include/asm-generic/Kbuild
+++ linux-2.6/include/asm-generic/Kbuild
@@ -2,9 +2,14 @@ header-y += errno-base.h
 header-y += errno.h
 header-y += fcntl.h
 header-y += ioctl.h
+header-y += ipcbuf.h
 header-y += mman-common.h
 header-y += mman.h
+header-y += msgbuf.h
 header-y += poll.h
+header-y += sembuf.h
+header-y += shmbuf.h
+header-y += shmparam.h
 header-y += signal-defs.h
 header-y += signal.h
 header-y += statfs.h
Index: linux-2.6/include/asm-generic/ipcbuf.h
===================================================================
--- /dev/null
+++ linux-2.6/include/asm-generic/ipcbuf.h
@@ -0,0 +1,33 @@
+#ifndef __ASM_GENERIC_IPCBUF_H
+#define __ASM_GENERIC_IPCBUF_H
+
+/*
+ * The generic ipc64_perm structure:
+ * Note extra padding because this structure is passed back and forth
+ * between kernel and user space.
+ *
+ * ipc64_perm was originally meant to be architecture specific, but
+ * everyone just ended up making identical copies without specific
+ * optimizations, so we may just as well all use the same one.
+ *
+ * Pad space is left for:
+ * - 32-bit mode_t on architectures that only had 16 bit
+ * - 32-bit seq
+ * - 2 miscellaneous 32-bit values
+ */
+
+struct ipc64_perm {
+	__kernel_key_t		key;
+	__kernel_uid32_t	uid;
+	__kernel_gid32_t	gid;
+	__kernel_uid32_t	cuid;
+	__kernel_gid32_t	cgid;
+	__kernel_mode_t		mode;
+	unsigned short		__pad1;
+	unsigned short		seq;
+	unsigned short		__pad2;
+	unsigned long		__unused1;
+	unsigned long		__unused2;
+};
+
+#endif /* __ASM_GENERIC_IPCBUF_H */
Index: linux-2.6/include/asm-generic/msgbuf.h
===================================================================
--- /dev/null
+++ linux-2.6/include/asm-generic/msgbuf.h
@@ -0,0 +1,47 @@
+#ifndef __ASM_GENERIC_MSGBUF_H
+#define __ASM_GENERIC_MSGBUF_H
+
+#include <asm/bitsperlong.h>
+/*
+ * generic msqid64_ds structure.
+ *
+ * Note extra padding because this structure is passed back and forth
+ * between kernel and user space.
+ *
+ * msqid64_ds was originally meant to be architecture specific, but
+ * everyone just ended up making identical copies without specific
+ * optimizations, so we may just as well all use the same one.
+ *
+ * 64 bit architectures typically define a 64 bit __kernel_time_t,
+ * so they do not need the first three padding words.
+ * On big-endian systems, the padding is in the wrong place.
+ *
+ * Pad space is left for:
+ * - 64-bit time_t to solve y2038 problem
+ * - 2 miscellaneous 32-bit values
+ */
+
+struct msqid64_ds {
+	struct ipc64_perm msg_perm;
+	__kernel_time_t msg_stime;	/* last msgsnd time */
+#if __BITS_PER_LONG != 64
+	unsigned long	__unused1;
+#endif
+	__kernel_time_t msg_rtime;	/* last msgrcv time */
+#if __BITS_PER_LONG != 64
+	unsigned long	__unused2;
+#endif
+	__kernel_time_t msg_ctime;	/* last change time */
+#if __BITS_PER_LONG != 64
+	unsigned long	__unused3;
+#endif
+	unsigned long  msg_cbytes;	/* current number of bytes on queue */
+	unsigned long  msg_qnum;	/* number of messages in queue */
+	unsigned long  msg_qbytes;	/* max number of bytes on queue */
+	__kernel_pid_t msg_lspid;	/* pid of last msgsnd */
+	__kernel_pid_t msg_lrpid;	/* last receive pid */
+	unsigned long  __unused4;
+	unsigned long  __unused5;
+};
+
+#endif /* __ASM_GENERIC_MSGBUF_H */
Index: linux-2.6/include/asm-generic/sembuf.h
===================================================================
--- /dev/null
+++ linux-2.6/include/asm-generic/sembuf.h
@@ -0,0 +1,38 @@
+#ifndef __ASM_GENERIC_SEMBUF_H
+#define __ASM_GENERIC_SEMBUF_H
+
+#include <asm/bitsperlong.h>
+
+/*
+ * The semid64_ds structure for x86 architecture.
+ * Note extra padding because this structure is passed back and forth
+ * between kernel and user space.
+ *
+ * semid64_ds was originally meant to be architecture specific, but
+ * everyone just ended up making identical copies without specific
+ * optimizations, so we may just as well all use the same one.
+ *
+ * 64 bit architectures typically define a 64 bit __kernel_time_t,
+ * so they do not need the first two padding words.
+ * On big-endian systems, the padding is in the wrong place.
+ *
+ * Pad space is left for:
+ * - 64-bit time_t to solve y2038 problem
+ * - 2 miscellaneous 32-bit values
+ */
+struct semid64_ds {
+	struct ipc64_perm sem_perm;	/* permissions .. see ipc.h */
+	__kernel_time_t	sem_otime;	/* last semop time */
+#if __BITS_PER_LONG != 64
+	unsigned long	__unused1;
+#endif
+	__kernel_time_t	sem_ctime;	/* last change time */
+#if __BITS_PER_LONG != 64
+	unsigned long	__unused2;
+#endif
+	unsigned long	sem_nsems;	/* no. of semaphores in array */
+	unsigned long	__unused3;
+	unsigned long	__unused4;
+};
+
+#endif /* __ASM_GENERIC_SEMBUF_H */
Index: linux-2.6/include/asm-generic/shmbuf.h
===================================================================
--- /dev/null
+++ linux-2.6/include/asm-generic/shmbuf.h
@@ -0,0 +1,59 @@
+#ifndef __ASM_GENERIC_SHMBUF_H
+#define __ASM_GENERIC_SHMBUF_H
+
+#include <asm/bitsperlong.h>
+
+/*
+ * The shmid64_ds structure for x86 architecture.
+ * Note extra padding because this structure is passed back and forth
+ * between kernel and user space.
+ *
+ * shmid64_ds was originally meant to be architecture specific, but
+ * everyone just ended up making identical copies without specific
+ * optimizations, so we may just as well all use the same one.
+ *
+ * 64 bit architectures typically define a 64 bit __kernel_time_t,
+ * so they do not need the first two padding words.
+ * On big-endian systems, the padding is in the wrong place.
+ *
+ *
+ * Pad space is left for:
+ * - 64-bit time_t to solve y2038 problem
+ * - 2 miscellaneous 32-bit values
+ */
+
+struct shmid64_ds {
+	struct ipc64_perm	shm_perm;	/* operation perms */
+	size_t			shm_segsz;	/* size of segment (bytes) */
+	__kernel_time_t		shm_atime;	/* last attach time */
+#if __BITS_PER_LONG != 64
+	unsigned long		__unused1;
+#endif
+	__kernel_time_t		shm_dtime;	/* last detach time */
+#if __BITS_PER_LONG != 64
+	unsigned long		__unused2;
+#endif
+	__kernel_time_t		shm_ctime;	/* last change time */
+#if __BITS_PER_LONG != 64
+	unsigned long		__unused3;
+#endif
+	__kernel_pid_t		shm_cpid;	/* pid of creator */
+	__kernel_pid_t		shm_lpid;	/* pid of last operator */
+	unsigned long		shm_nattch;	/* no. of current attaches */
+	unsigned long		__unused4;
+	unsigned long		__unused5;
+};
+
+struct shminfo64 {
+	unsigned long	shmmax;
+	unsigned long	shmmin;
+	unsigned long	shmmni;
+	unsigned long	shmseg;
+	unsigned long	shmall;
+	unsigned long	__unused1;
+	unsigned long	__unused2;
+	unsigned long	__unused3;
+	unsigned long	__unused4;
+};
+
+#endif /* __ASM_GENERIC_SHMBUF_H */
Index: linux-2.6/include/asm-generic/shmparam.h
===================================================================
--- /dev/null
+++ linux-2.6/include/asm-generic/shmparam.h
@@ -0,0 +1,6 @@
+#ifndef __ASM_GENERIC_SHMPARAM_H
+#define __ASM_GENERIC_SHMPARAM_H
+
+#define SHMLBA PAGE_SIZE	 /* attach addr a multiple of this */
+
+#endif /* _ASM_GENERIC_SHMPARAM_H */

-- 

--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
