From: Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>
Subject: [PATCH 1/4] Use bit operations for file->f_flags
Date: Mon,  2 Feb 2009 11:20:08 -0700
Message-ID: <1233598811-6871-2-git-send-email-corbet@lwn.net>
References: <1233598811-6871-1-git-send-email-corbet@lwn.net>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1233598811-6871-1-git-send-email-corbet-T1hC0tSOHrs@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Davide Libenzi <davidel-AhlLAIvw+VEjIGhXcJzhZg@public.gmane.org>, David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Mackall <mpm-VDJrAJ4Gl5ZBDgjK7y7TUQ@public.gmane.org>, Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Turn struct file->f_flags into an unsigned long and use bitops to change
its contents.  This allows the safe manipulation of these flags without the
need for locks.  BKL use is removed where possible, but manipulations of
the FASYNC bit still require it (that will be fixed in a later patch).

Signed-off-by: Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>
---
 arch/alpha/include/asm/fcntl.h    |    5 +++++
 arch/arm/include/asm/fcntl.h      |    1 +
 arch/blackfin/include/asm/fcntl.h |    1 +
 arch/h8300/include/asm/fcntl.h    |    1 +
 arch/m68k/include/asm/fcntl.h     |    1 +
 arch/mips/include/asm/fcntl.h     |    5 +++++
 arch/parisc/include/asm/fcntl.h   |    4 ++++
 arch/powerpc/include/asm/fcntl.h  |    1 +
 arch/sparc/include/asm/fcntl.h    |    6 ++++++
 drivers/char/tty_io.c             |    7 ++-----
 drivers/usb/gadget/file_storage.c |    6 ++++--
 fs/fcntl.c                        |   20 ++++++++++++++++++--
 fs/ioctl.c                        |   21 ++++++++++-----------
 fs/nfsd/vfs.c                     |    3 ++-
 include/asm-generic/fcntl.h       |    7 +++++++
 include/linux/fs.h                |    7 ++++++-
 ipc/mqueue.c                      |    5 +++--
 sound/core/oss/pcm_oss.c          |    3 ++-
 sound/oss/au1550_ac97.c           |    2 +-
 sound/oss/audio.c                 |    3 ++-
 sound/oss/sh_dac_audio.c          |    4 +++-
 sound/oss/swarm_cs4297a.c         |    2 +-
 sound/oss/vwsnd.c                 |    3 ++-
 23 files changed, 88 insertions(+), 30 deletions(-)

diff --git a/arch/alpha/include/asm/fcntl.h b/arch/alpha/include/asm/fcntl.h
index 25da001..de7172f 100644
--- a/arch/alpha/include/asm/fcntl.h
+++ b/arch/alpha/include/asm/fcntl.h
@@ -9,13 +9,18 @@
 #define O_NOCTTY	010000	/* not fcntl */
 
 #define O_NONBLOCK	 00004
+#define NR_O_NONBLOCK	 2
 #define O_APPEND	 00010
+#define NR_O_APPEND	 3
 #define O_SYNC		040000
+#define NR_O_SYNC	14
 #define O_DIRECTORY	0100000	/* must be a directory */
 #define O_NOFOLLOW	0200000 /* don't follow links */
 #define O_LARGEFILE	0400000 /* will be set by the kernel on every open */
 #define O_DIRECT	02000000 /* direct disk access - should check with OSF/1 */
+#define NR_O_DIRECT	19
 #define O_NOATIME	04000000
+#define NR_O_NOATIME	20
 #define O_CLOEXEC	010000000 /* set close_on_exec */
 
 #define F_GETLK		7
diff --git a/arch/arm/include/asm/fcntl.h b/arch/arm/include/asm/fcntl.h
index a80b660..e74b8d1 100644
--- a/arch/arm/include/asm/fcntl.h
+++ b/arch/arm/include/asm/fcntl.h
@@ -4,6 +4,7 @@
 #define O_DIRECTORY	 040000	/* must be a directory */
 #define O_NOFOLLOW	0100000	/* don't follow links */
 #define O_DIRECT	0200000	/* direct disk access hint - currently ignored */
+#define NR_O_DIRECT	16
 #define O_LARGEFILE	0400000
 
 #include <asm-generic/fcntl.h>
diff --git a/arch/blackfin/include/asm/fcntl.h b/arch/blackfin/include/asm/fcntl.h
index 9c40371..fe4c643 100644
--- a/arch/blackfin/include/asm/fcntl.h
+++ b/arch/blackfin/include/asm/fcntl.h
@@ -6,6 +6,7 @@
 #define O_DIRECTORY	 040000	/* must be a directory */
 #define O_NOFOLLOW	0100000	/* don't follow links */
 #define O_DIRECT	0200000	/* direct disk access hint - currently ignored */
+#define NR_O_DIRECT	16
 #define O_LARGEFILE	0400000
 
 #include <asm-generic/fcntl.h>
diff --git a/arch/h8300/include/asm/fcntl.h b/arch/h8300/include/asm/fcntl.h
index 1952cb2..c1cfbdd 100644
--- a/arch/h8300/include/asm/fcntl.h
+++ b/arch/h8300/include/asm/fcntl.h
@@ -4,6 +4,7 @@
 #define O_DIRECTORY	040000	/* must be a directory */
 #define O_NOFOLLOW	0100000	/* don't follow links */
 #define O_DIRECT	0200000	/* direct disk access hint - currently ignored */
+#define NR_O_DIRECT	16
 #define O_LARGEFILE	0400000
 
 #include <asm-generic/fcntl.h>
diff --git a/arch/m68k/include/asm/fcntl.h b/arch/m68k/include/asm/fcntl.h
index 1c369b2..a199f04 100644
--- a/arch/m68k/include/asm/fcntl.h
+++ b/arch/m68k/include/asm/fcntl.h
@@ -4,6 +4,7 @@
 #define O_DIRECTORY	040000	/* must be a directory */
 #define O_NOFOLLOW	0100000	/* don't follow links */
 #define O_DIRECT	0200000	/* direct disk access hint - currently ignored */
+#define NR_O_DIRECT	16
 #define O_LARGEFILE	0400000
 
 #include <asm-generic/fcntl.h>
diff --git a/arch/mips/include/asm/fcntl.h b/arch/mips/include/asm/fcntl.h
index 2a52333..6bbcbf9 100644
--- a/arch/mips/include/asm/fcntl.h
+++ b/arch/mips/include/asm/fcntl.h
@@ -10,15 +10,20 @@
 
 
 #define O_APPEND	0x0008
+#define NR_O_APPEND	3
 #define O_SYNC		0x0010
+#define NR_O_SYNC	4
 #define O_NONBLOCK	0x0080
+#define NR_O_NONBLOCK	7
 #define O_CREAT         0x0100	/* not fcntl */
 #define O_TRUNC		0x0200	/* not fcntl */
 #define O_EXCL		0x0400	/* not fcntl */
 #define O_NOCTTY	0x0800	/* not fcntl */
 #define FASYNC		0x1000	/* fcntl, for BSD compatibility */
+#define NR_FASYNC	12
 #define O_LARGEFILE	0x2000	/* allow large file opens */
 #define O_DIRECT	0x8000	/* direct disk access hint */
+#define NR_O_DIRECT	15
 
 #define F_GETLK		14
 #define F_SETLK		6
diff --git a/arch/parisc/include/asm/fcntl.h b/arch/parisc/include/asm/fcntl.h
index 1e1c824..7d33fe7 100644
--- a/arch/parisc/include/asm/fcntl.h
+++ b/arch/parisc/include/asm/fcntl.h
@@ -4,12 +4,16 @@
 /* open/fcntl - O_SYNC is only implemented on blocks devices and on files
    located on an ext2 file system */
 #define O_APPEND	000000010
+#define NR_O_APPEND	3
 #define O_BLKSEEK	000000100 /* HPUX only */
 #define O_CREAT		000000400 /* not fcntl */
 #define O_EXCL		000002000 /* not fcntl */
 #define O_LARGEFILE	000004000
 #define O_SYNC		000100000
+#define NR_O_SYNC	15
 #define O_NONBLOCK	000200004 /* HPUX has separate NDELAY & NONBLOCK */
+#define NR_O_NONBLOCK	16	  /* WTF, assign one to each... */
+#define NR_O_NDELAY	 3
 #define O_NOCTTY	000400000 /* not fcntl */
 #define O_DSYNC		001000000 /* HPUX only */
 #define O_RSYNC		002000000 /* HPUX only */
diff --git a/arch/powerpc/include/asm/fcntl.h b/arch/powerpc/include/asm/fcntl.h
index ce5c451..2453257 100644
--- a/arch/powerpc/include/asm/fcntl.h
+++ b/arch/powerpc/include/asm/fcntl.h
@@ -5,6 +5,7 @@
 #define O_NOFOLLOW      0100000	/* don't follow links */
 #define O_LARGEFILE     0200000
 #define O_DIRECT	0400000	/* direct disk access hint */
+#define NR_O_DIRECT	17
 
 #include <asm-generic/fcntl.h>
 
diff --git a/arch/sparc/include/asm/fcntl.h b/arch/sparc/include/asm/fcntl.h
index d4d9c9d..ffc0268 100644
--- a/arch/sparc/include/asm/fcntl.h
+++ b/arch/sparc/include/asm/fcntl.h
@@ -4,12 +4,16 @@
 /* open/fcntl - O_SYNC is only implemented on blocks devices and on files
    located on an ext2 file system */
 #define O_APPEND	0x0008
+#define NR_O_APPEND	3
 #define FASYNC		0x0040	/* fcntl, for BSD compatibility */
+#define NR_FASYNC	6
 #define O_CREAT		0x0200	/* not fcntl */
 #define O_TRUNC		0x0400	/* not fcntl */
 #define O_EXCL		0x0800	/* not fcntl */
 #define O_SYNC		0x2000
+#define NR_O_SYNC	13
 #define O_NONBLOCK	0x4000
+#define NR_O_NONBLOCK	14
 #if defined(__sparc__) && defined(__arch64__)
 #define O_NDELAY	0x0004
 #else
@@ -18,7 +22,9 @@
 #define O_NOCTTY	0x8000	/* not fcntl */
 #define O_LARGEFILE	0x40000
 #define O_DIRECT        0x100000 /* direct disk access hint */
+#define NR_O_DIRECT	20
 #define O_NOATIME	0x200000
+#define NR_O_NOATIME	21
 #define O_CLOEXEC	0x400000
 
 #define F_GETOWN	5	/*  for sockets. */
diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index bc84e12..ad8d884 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -2162,13 +2162,10 @@ static int fionbio(struct file *file, int __user *p)
 	if (get_user(nonblock, p))
 		return -EFAULT;
 
-	/* file->f_flags is still BKL protected in the fs layer - vomit */
-	lock_kernel();
 	if (nonblock)
-		file->f_flags |= O_NONBLOCK;
+		set_bit(NR_O_NONBLOCK, &file->f_flags);
 	else
-		file->f_flags &= ~O_NONBLOCK;
-	unlock_kernel();
+		clear_bit(NR_O_NONBLOCK, &file->f_flags);
 	return 0;
 }
 
diff --git a/drivers/usb/gadget/file_storage.c b/drivers/usb/gadget/file_storage.c
index b10fa31..ac99b58 100644
--- a/drivers/usb/gadget/file_storage.c
+++ b/drivers/usb/gadget/file_storage.c
@@ -247,6 +247,7 @@
 #include <linux/string.h>
 #include <linux/freezer.h>
 #include <linux/utsname.h>
+#include <linux/bitops.h>
 
 #include <linux/usb/ch9.h>
 #include <linux/usb/gadget.h>
@@ -1711,7 +1712,8 @@ static int do_write(struct fsg_dev *fsg)
 		curlun->sense_data = SS_WRITE_PROTECTED;
 		return -EINVAL;
 	}
-	curlun->filp->f_flags &= ~O_SYNC;	// Default is not to wait
+	/* Default is not to wait */
+	clear_bit(NR_O_SYNC, &curlun->filp->f_flags);
 
 	/* Get the starting Logical Block Address and check that it's
 	 * not too big */
@@ -1729,7 +1731,7 @@ static int do_write(struct fsg_dev *fsg)
 			return -EINVAL;
 		}
 		if (fsg->cmnd[1] & 0x08)	// FUA
-			curlun->filp->f_flags |= O_SYNC;
+			set_bit(NR_O_SYNC, &curlun->filp->f_flags);
 	}
 	if (lba >= curlun->num_sectors) {
 		curlun->sense_data = SS_LOGICAL_BLOCK_ADDRESS_OUT_OF_RANGE;
diff --git a/fs/fcntl.c b/fs/fcntl.c
index bd215cc..3affd3e 100644
--- a/fs/fcntl.c
+++ b/fs/fcntl.c
@@ -20,6 +20,7 @@
 #include <linux/rcupdate.h>
 #include <linux/pid_namespace.h>
 #include <linux/smp_lock.h>
+#include <linux/bitops.h>
 
 #include <asm/poll.h>
 #include <asm/siginfo.h>
@@ -141,7 +142,14 @@ SYSCALL_DEFINE1(dup, unsigned int, fildes)
 	return ret;
 }
 
-#define SETFL_MASK (O_APPEND | O_NONBLOCK | O_NDELAY | FASYNC | O_DIRECT | O_NOATIME)
+static void tweak_flags_bit(int nr, int on, unsigned long *flags)
+{
+	if (on)
+		set_bit(nr, flags);
+	else
+		clear_bit(nr, flags);
+}
+
 
 static int setfl(int fd, struct file * filp, unsigned long arg)
 {
@@ -187,9 +195,17 @@ static int setfl(int fd, struct file * filp, unsigned long arg)
 			if (error < 0)
 				goto out;
 		}
+		change_bit(NR_FASYNC, &filp->f_flags);
 	}
 
-	filp->f_flags = (arg & SETFL_MASK) | (filp->f_flags & ~SETFL_MASK);
+	/*
+	 * Now that we use bitops we have to tweak each bit individually.
+	 */
+	tweak_flags_bit(NR_O_APPEND, arg & O_APPEND, &filp->f_flags);
+	tweak_flags_bit(NR_O_NONBLOCK, arg & O_NONBLOCK, &filp->f_flags);
+	tweak_flags_bit(NR_O_NDELAY, arg & O_NDELAY, &filp->f_flags);
+	tweak_flags_bit(NR_O_DIRECT, arg & O_DIRECT, &filp->f_flags);
+	tweak_flags_bit(NR_O_NOATIME, arg & O_NOATIME, &filp->f_flags);
  out:
 	unlock_kernel();
 	return error;
diff --git a/fs/ioctl.c b/fs/ioctl.c
index 240ec63..fc0db36 100644
--- a/fs/ioctl.c
+++ b/fs/ioctl.c
@@ -392,22 +392,24 @@ static int file_ioctl(struct file *filp, unsigned int cmd,
 
 static int ioctl_fionbio(struct file *filp, int __user *argp)
 {
-	unsigned int flag;
 	int on, error;
 
 	error = get_user(on, argp);
 	if (error)
 		return error;
-	flag = O_NONBLOCK;
 #ifdef __sparc__
 	/* SunOS compatibility item. */
-	if (O_NONBLOCK != O_NDELAY)
-		flag |= O_NDELAY;
+	if (O_NONBLOCK != O_NDELAY) {
+		if (on)
+			set_bit(NR_O_NDELAY, &filp->f_flags);
+		else
+			clear_bit(NR_O_NDELAY, &filp->f_flags);
+	}
 #endif
 	if (on)
-		filp->f_flags |= flag;
+		set_bit(NR_O_NONBLOCK, &filp->f_flags);
 	else
-		filp->f_flags &= ~flag;
+		clear_bit(NR_O_NONBLOCK, &filp->f_flags);
 	return error;
 }
 
@@ -433,9 +435,9 @@ static int ioctl_fioasync(unsigned int fd, struct file *filp,
 		return error;
 
 	if (on)
-		filp->f_flags |= FASYNC;
+		set_bit(NR_FASYNC, &filp->f_flags);
 	else
-		filp->f_flags &= ~FASYNC;
+		clear_bit(NR_FASYNC, &filp->f_flags);
 	return error;
 }
 
@@ -499,10 +501,7 @@ int do_vfs_ioctl(struct file *filp, unsigned int fd, unsigned int cmd,
 		break;
 
 	case FIONBIO:
-		/* BKL needed to avoid races tweaking f_flags */
-		lock_kernel();
 		error = ioctl_fionbio(filp, argp);
-		unlock_kernel();
 		break;
 
 	case FIOASYNC:
diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 6e50aaa..1630a9e 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -55,6 +55,7 @@
 #include <linux/security.h>
 #endif /* CONFIG_NFSD_V4 */
 #include <linux/jhash.h>
+#include <linux/bitops.h>
 
 #include <asm/uaccess.h>
 
@@ -999,7 +1000,7 @@ nfsd_vfs_write(struct svc_rqst *rqstp, struct svc_fh *fhp, struct file *file,
 	if (!EX_ISSYNC(exp))
 		stable = 0;
 	if (stable && !EX_WGATHER(exp))
-		file->f_flags |= O_SYNC;
+		set_bit(NR_O_SYNC, &file->f_flags);
 
 	/* Write the data. */
 	oldfs = get_fs(); set_fs(KERNEL_DS);
diff --git a/include/asm-generic/fcntl.h b/include/asm-generic/fcntl.h
index b847741..41e9f88 100644
--- a/include/asm-generic/fcntl.h
+++ b/include/asm-generic/fcntl.h
@@ -23,18 +23,23 @@
 #endif
 #ifndef O_APPEND
 #define O_APPEND	00002000
+#define NR_O_APPEND	10
 #endif
 #ifndef O_NONBLOCK
 #define O_NONBLOCK	00004000
+#define NR_O_NONBLOCK	11
 #endif
 #ifndef O_SYNC
 #define O_SYNC		00010000
+#define NR_O_SYNC	12
 #endif
 #ifndef FASYNC
 #define FASYNC		00020000	/* fcntl, for BSD compatibility */
+#define NR_FASYNC	13
 #endif
 #ifndef O_DIRECT
 #define O_DIRECT	00040000	/* direct disk access hint */
+#define NR_O_DIRECT	14
 #endif
 #ifndef O_LARGEFILE
 #define O_LARGEFILE	00100000
@@ -47,12 +52,14 @@
 #endif
 #ifndef O_NOATIME
 #define O_NOATIME	01000000
+#define NR_O_NOATIME	18
 #endif
 #ifndef O_CLOEXEC
 #define O_CLOEXEC	02000000	/* set close_on_exec */
 #endif
 #ifndef O_NDELAY
 #define O_NDELAY	O_NONBLOCK
+#define NR_O_NDELAY	NR_O_NONBLOCK
 #endif
 
 #define F_DUPFD		0	/* dup */
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 6022f44..9d7cb0e 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -829,6 +829,11 @@ static inline int ra_has_index(struct file_ra_state *ra, pgoff_t index)
 #define FILE_MNT_WRITE_TAKEN	1
 #define FILE_MNT_WRITE_RELEASED	2
 
+/*
+ * Locking: f_flags needs to be manipulated with atomic bitops.  The
+ * 	    one exception is when it's known that there are no other
+ *	    references - in the open/create path, primarily.
+ */
 struct file {
 	/*
 	 * fu_list becomes invalid after file_free is called and queued via
@@ -843,7 +848,7 @@ struct file {
 #define f_vfsmnt	f_path.mnt
 	const struct file_operations	*f_op;
 	atomic_long_t		f_count;
-	unsigned int 		f_flags;
+	unsigned long 		f_flags;
 	fmode_t			f_mode;
 	loff_t			f_pos;
 	struct fown_struct	f_owner;
diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index 54b4077..1be0a62 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -31,6 +31,7 @@
 #include <linux/mutex.h>
 #include <linux/nsproxy.h>
 #include <linux/pid.h>
+#include <linux/bitops.h>
 
 #include <net/sock.h>
 #include "util.h"
@@ -1157,9 +1158,9 @@ SYSCALL_DEFINE3(mq_getsetattr, mqd_t, mqdes,
 	if (u_mqstat) {
 		audit_mq_getsetattr(mqdes, &mqstat);
 		if (mqstat.mq_flags & O_NONBLOCK)
-			filp->f_flags |= O_NONBLOCK;
+			set_bit(NR_O_NONBLOCK, &filp->f_flags);
 		else
-			filp->f_flags &= ~O_NONBLOCK;
+			clear_bit(NR_O_NONBLOCK, &filp->f_flags);
 
 		inode->i_atime = inode->i_ctime = CURRENT_TIME;
 	}
diff --git a/sound/core/oss/pcm_oss.c b/sound/core/oss/pcm_oss.c
index e178366..746e38e 100644
--- a/sound/core/oss/pcm_oss.c
+++ b/sound/core/oss/pcm_oss.c
@@ -26,6 +26,7 @@
 #define OSS_DEBUG
 #endif
 
+#include <linux/bitops.h>
 #include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/time.h>
@@ -1895,7 +1896,7 @@ static int snd_pcm_oss_set_fragment(struct snd_pcm_oss_file *pcm_oss_file, unsig
 
 static int snd_pcm_oss_nonblock(struct file * file)
 {
-	file->f_flags |= O_NONBLOCK;
+	set_bit(NR_O_NONBLOCK, &file->f_flags);
 	return 0;
 }
 
diff --git a/sound/oss/au1550_ac97.c b/sound/oss/au1550_ac97.c
index 81e1f44..87305cc 100644
--- a/sound/oss/au1550_ac97.c
+++ b/sound/oss/au1550_ac97.c
@@ -1627,7 +1627,7 @@ au1550_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 				    sizeof(abinfo)) ? -EFAULT : 0;
 
 	case SNDCTL_DSP_NONBLOCK:
-		file->f_flags |= O_NONBLOCK;
+		set_bit(NR_O_NONBLOCK, &file->f_flags);
 		return 0;
 
 	case SNDCTL_DSP_GETODELAY:
diff --git a/sound/oss/audio.c b/sound/oss/audio.c
index 89bd27a..0837b06 100644
--- a/sound/oss/audio.c
+++ b/sound/oss/audio.c
@@ -29,6 +29,7 @@
 #include <linux/stddef.h>
 #include <linux/string.h>
 #include <linux/kmod.h>
+#include <linux/bitops.h>
 
 #include "sound_config.h"
 #include "ulaw.h"
@@ -433,7 +434,7 @@ int audio_ioctl(int dev, struct file *file, unsigned int cmd, void __user *arg)
 			return dma_ioctl(dev, cmd, arg);
 		
 		case SNDCTL_DSP_NONBLOCK:
-			file->f_flags |= O_NONBLOCK;
+			set_bit(NR_O_NONBLOCK, &file->f_flags);
 			return 0;
 
 		case SNDCTL_DSP_GETCAPS:
diff --git a/sound/oss/sh_dac_audio.c b/sound/oss/sh_dac_audio.c
index e5d4239..532f4ac 100644
--- a/sound/oss/sh_dac_audio.c
+++ b/sound/oss/sh_dac_audio.c
@@ -18,6 +18,8 @@
 #include <linux/sound.h>
 #include <linux/soundcard.h>
 #include <linux/interrupt.h>
+#include <linux/bitops.h>
+
 #include <asm/io.h>
 #include <asm/uaccess.h>
 #include <asm/irq.h>
@@ -135,7 +137,7 @@ static int dac_audio_ioctl(struct inode *inode, struct file *file,
 		return put_user(AFMT_U8, (int *)arg);
 
 	case SNDCTL_DSP_NONBLOCK:
-		file->f_flags |= O_NONBLOCK;
+		set_bit(NR_O_NONBLOCK, &file->f_flags);
 		return 0;
 
 	case SNDCTL_DSP_GETCAPS:
diff --git a/sound/oss/swarm_cs4297a.c b/sound/oss/swarm_cs4297a.c
index 41562ec..fdd9715 100644
--- a/sound/oss/swarm_cs4297a.c
+++ b/sound/oss/swarm_cs4297a.c
@@ -2200,7 +2200,7 @@ static int cs4297a_ioctl(struct inode *inode, struct file *file,
 				    sizeof(abinfo)) ? -EFAULT : 0;
 
 	case SNDCTL_DSP_NONBLOCK:
-		file->f_flags |= O_NONBLOCK;
+		set_bit(NR_O_NONBLOCK, &file->f_flags);
 		return 0;
 
 	case SNDCTL_DSP_GETODELAY:
diff --git a/sound/oss/vwsnd.c b/sound/oss/vwsnd.c
index 78b8acc..72b9a65 100644
--- a/sound/oss/vwsnd.c
+++ b/sound/oss/vwsnd.c
@@ -149,6 +149,7 @@
 #include <linux/wait.h>
 #include <linux/interrupt.h>
 #include <linux/mutex.h>
+#include <linux/bitops.h>
 
 #include <asm/visws/cobalt.h>
 
@@ -2673,7 +2674,7 @@ static int vwsnd_audio_do_ioctl(struct inode *inode,
 
 	case SNDCTL_DSP_NONBLOCK:	/* _SIO  ('P',14) */
 		DBGX("SNDCTL_DSP_NONBLOCK\n");
-		file->f_flags |= O_NONBLOCK;
+		set_bit(NR_O_NONBLOCK, &file->f_flags);
 		return 0;
 
 	case SNDCTL_DSP_RESET:		/* _SIO  ('P', 0) */
-- 
1.6.1.1

--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
