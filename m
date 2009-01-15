From: Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>
Subject: [PATCH, RFC] Remove fasync() BKL usage, take 3325
Date: Thu, 15 Jan 2009 15:32:11 -0700
Message-ID: <20090115153211.663df310@bike.lwn.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>
List-Id: linux-api@vger.kernel.org

One of these years I've got to get this right.  I've fixed the problem
pointed out by Oleg where f_flags would get changed even if fasync()
fails.  

I have also taken out the ABI change.  CCing the linux-api list because
I still think it's not quite right; fcntl() should not silently let
applications set the FASYNC flag if the underlying driver/filesystem
does not support it.  But that's How We've Always Done It, and one
messes with such things at great risk.  If we want fcntl() to return an
error in this case, it's an easy change.

This one's against 2.6.29-rc1.  If I don't hear screaming, I'll drop
this one into linux-next.

Thanks,

jon

--

Accesses to the f_flags member of struct file involve read-modify-write
cycles; they have traditionally been done in a racy way.  This patch
introduces a global spinlock to protect f_flags against concurrent
modifications.

Additionally, changes to the FASYNC flag and resulting calls to
f_op->fasync() need to be done in an atomic manner.  Here, the BKL is
removed and FASYNC modifications are protected with a mutex.

Signed-off-by: Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>
---
 drivers/char/tty_io.c |    5 +--
 fs/fcntl.c            |   65 +++++++++++++++++++++++++++++++++++++++----------
 fs/ioctl.c            |   25 ++++---------------
 fs/nfsd/vfs.c         |    5 +++-
 include/linux/fs.h    |   17 +++++++++++++
 5 files changed, 80 insertions(+), 37 deletions(-)

diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index d33e5ab..8450316 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -2160,13 +2160,12 @@ static int fionbio(struct file *file, int __user *p)
 	if (get_user(nonblock, p))
 		return -EFAULT;
 
-	/* file->f_flags is still BKL protected in the fs layer - vomit */
-	lock_kernel();
+	lock_file_flags();
 	if (nonblock)
 		file->f_flags |= O_NONBLOCK;
 	else
 		file->f_flags &= ~O_NONBLOCK;
-	unlock_kernel();
+	unlock_file_flags();
 	return 0;
 }
 
diff --git a/fs/fcntl.c b/fs/fcntl.c
index cdc1419..ddd497d 100644
--- a/fs/fcntl.c
+++ b/fs/fcntl.c
@@ -19,12 +19,16 @@
 #include <linux/signal.h>
 #include <linux/rcupdate.h>
 #include <linux/pid_namespace.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 
 #include <asm/poll.h>
 #include <asm/siginfo.h>
 #include <asm/uaccess.h>
 
+/* Serialize access to file->f_flags */
+DEFINE_SPINLOCK(file_flags_lock);
+EXPORT_SYMBOL(file_flags_lock);
+
 void set_close_on_exec(unsigned int fd, int flag)
 {
 	struct files_struct *files = current->files;
@@ -141,7 +145,7 @@ asmlinkage long sys_dup(unsigned int fildes)
 	return ret;
 }
 
-#define SETFL_MASK (O_APPEND | O_NONBLOCK | O_NDELAY | FASYNC | O_DIRECT | O_NOATIME)
+#define SETFL_MASK (O_APPEND | O_NONBLOCK | O_NDELAY | O_DIRECT | O_NOATIME)
 
 static int setfl(int fd, struct file * filp, unsigned long arg)
 {
@@ -176,25 +180,60 @@ static int setfl(int fd, struct file * filp, unsigned long arg)
 	if (error)
 		return error;
 
-	/*
-	 * We still need a lock here for now to keep multiple FASYNC calls
-	 * from racing with each other.
-	 */
-	lock_kernel();
 	if ((arg ^ filp->f_flags) & FASYNC) {
-		if (filp->f_op && filp->f_op->fasync) {
-			error = filp->f_op->fasync(fd, filp, (arg & FASYNC) != 0);
-			if (error < 0)
-				goto out;
-		}
+		error = fasync_change(fd, filp, (arg & FASYNC) != 0);
+		if (error == -ENOTTY)
+			/*
+			 * ABI compatibility: fcntl() has traditionally returned
+			 * zero in this case (but ioctl() does not).
+			 */
+			error = 0;
+		else if (error < 0)
+			goto out;
 	}
 
+	lock_file_flags();
 	filp->f_flags = (arg & SETFL_MASK) | (filp->f_flags & ~SETFL_MASK);
+	unlock_file_flags();
  out:
-	unlock_kernel();
 	return error;
 }
 
+
+
+/*
+ * Change the setting of fasync, let the driver know.
+ * Not static because ioctl_fioasync() uses it too.
+ */
+int fasync_change(int fd, struct file *filp, int on)
+{
+	int ret = 0;
+	static DEFINE_MUTEX(fasync_mutex);
+
+	if (filp->f_op->fasync == NULL)
+		return -ENOTTY;
+
+	mutex_lock(&fasync_mutex);
+	/* Can test without flags lock, nobody else will change it */
+	if (((filp->f_flags & FASYNC) == 0) == (on == 0))
+		goto out;
+	ret = filp->f_op->fasync(fd, filp, on);
+	if (ret >= 0) {
+		lock_file_flags();
+		if (on)
+			filp->f_flags |= FASYNC;
+		else
+			filp->f_flags &= ~FASYNC;
+		unlock_file_flags();
+	}
+  out:
+	mutex_unlock(&fasync_mutex);
+	return ret;
+}
+
+
+
+
 static void f_modown(struct file *filp, struct pid *pid, enum pid_type type,
                      uid_t uid, uid_t euid, int force)
 {
diff --git a/fs/ioctl.c b/fs/ioctl.c
index 20b0a8a..e5f85fb 100644
--- a/fs/ioctl.c
+++ b/fs/ioctl.c
@@ -404,10 +404,12 @@ static int ioctl_fionbio(struct file *filp, int __user *argp)
 	if (O_NONBLOCK != O_NDELAY)
 		flag |= O_NDELAY;
 #endif
+	lock_file_flags();
 	if (on)
 		filp->f_flags |= flag;
 	else
 		filp->f_flags &= ~flag;
+	unlock_file_flags();
 	return error;
 }
 
@@ -423,20 +425,9 @@ static int ioctl_fioasync(unsigned int fd, struct file *filp,
 	flag = on ? FASYNC : 0;
 
 	/* Did FASYNC state change ? */
-	if ((flag ^ filp->f_flags) & FASYNC) {
-		if (filp->f_op && filp->f_op->fasync)
-			error = filp->f_op->fasync(fd, filp, on);
-		else
-			error = -ENOTTY;
-	}
-	if (error)
-		return error;
-
-	if (on)
-		filp->f_flags |= FASYNC;
-	else
-		filp->f_flags &= ~FASYNC;
-	return error;
+	if ((flag ^ filp->f_flags) & FASYNC)
+		return fasync_change(fd, filp, on);
+	return 0;
 }
 
 static int ioctl_fsfreeze(struct file *filp)
@@ -499,17 +490,11 @@ int do_vfs_ioctl(struct file *filp, unsigned int fd, unsigned int cmd,
 		break;
 
 	case FIONBIO:
-		/* BKL needed to avoid races tweaking f_flags */
-		lock_kernel();
 		error = ioctl_fionbio(filp, argp);
-		unlock_kernel();
 		break;
 
 	case FIOASYNC:
-		/* BKL needed to avoid races tweaking f_flags */
-		lock_kernel();
 		error = ioctl_fioasync(fd, filp, argp);
-		unlock_kernel();
 		break;
 
 	case FIOQSIZE:
diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 6e50aaa..4965a5a 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -998,8 +998,11 @@ nfsd_vfs_write(struct svc_rqst *rqstp, struct svc_fh *fhp, struct file *file,
 
 	if (!EX_ISSYNC(exp))
 		stable = 0;
-	if (stable && !EX_WGATHER(exp))
+	if (stable && !EX_WGATHER(exp)) {
+		lock_file_flags();
 		file->f_flags |= O_SYNC;
+		unlock_file_flags();
+	}
 
 	/* Write the data. */
 	oldfs = get_fs(); set_fs(KERNEL_DS);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 6022f44..ccba351 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -874,6 +874,23 @@ extern spinlock_t files_lock;
 #define get_file(x)	atomic_long_inc(&(x)->f_count)
 #define file_count(x)	atomic_long_read(&(x)->f_count)
 
+/*
+ * Serialize changes to file->f_flags.  These should not be called
+ * from interrupt context.
+ */
+extern spinlock_t file_flags_lock;
+
+static inline void lock_file_flags(void)
+{
+	spin_lock(&file_flags_lock);
+}
+
+static inline void unlock_file_flags(void)
+{
+	spin_unlock(&file_flags_lock);
+}
+extern int fasync_change(int fd, struct file *filp, int on);
+
 #ifdef CONFIG_DEBUG_WRITECOUNT
 static inline void file_take_write(struct file *f)
 {
-- 
1.6.1

--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
