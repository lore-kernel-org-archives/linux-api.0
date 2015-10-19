From: Paul Osmialowski <p.osmialowsk@samsung.com>
Subject: [RFC v3 3/9] kmsg: introduce additional kmsg devices support
Date: Mon, 19 Oct 2015 14:58:17 +0200
Message-ID: <1445259503-18158-4-git-send-email-p.osmialowsk@samsung.com>
References: <1445259503-18158-1-git-send-email-p.osmialowsk@samsung.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <1445259503-18158-1-git-send-email-p.osmialowsk@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jonathan Corbet <corbet@lwn.net>, Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>, Petr Mladek <pmladek@suse.cz>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Daniel Mack <daniel@zonque.org>, Kay Sievers <kay.sievers@vrfy.org>, Joe Perches <joe@perches.com>, Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-api@vger.kernel.org
Cc: Marcin Niesluchowski <m.niesluchow@samsung.com>, Karol Lewandowski <k.lewandowsk@samsung.com>, Paul Osmialowski <p.osmialowsk@samsung.com>, Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>, Shuah Khan <shuahkh@osg.samsung.com>
List-Id: linux-api@vger.kernel.org

From: Marcin Niesluchowski <m.niesluchow@samsung.com>

kmsg device provides operations on cyclic logging buffer used mainly
by kernel but also in userspace by privileged processes.

Additional kmsg devices keep the same log format but may be added
dynamically with custom size.

Signed-off-by: Marcin Niesluchowski <m.niesluchow@samsung.com>
Signed-off-by: Paul Osmialowski <p.osmialowsk@samsung.com>
---
 fs/proc/kmsg.c         |   4 +-
 kernel/printk/kmsg.c   | 301 ++++++++++++++++++++++++++++++++--------------
 kernel/printk/printk.c | 317 ++++++++++++++++++++++++++-----------------------
 kernel/printk/printk.h |  69 +++++++----
 4 files changed, 431 insertions(+), 260 deletions(-)

diff --git a/fs/proc/kmsg.c b/fs/proc/kmsg.c
index 05f8dcd..0d354e4 100644
--- a/fs/proc/kmsg.c
+++ b/fs/proc/kmsg.c
@@ -17,7 +17,7 @@
 #include <asm/uaccess.h>
 #include <asm/io.h>
 
-extern wait_queue_head_t log_wait;
+extern wait_queue_head_t *log_wait;
 
 static int kmsg_open(struct inode * inode, struct file * file)
 {
@@ -41,7 +41,7 @@ static ssize_t kmsg_read(struct file *file, char __user *buf,
 
 static unsigned int kmsg_poll(struct file *file, poll_table *wait)
 {
-	poll_wait(file, &log_wait, wait);
+	poll_wait(file, log_wait, wait);
 	if (do_syslog(SYSLOG_ACTION_SIZE_UNREAD, NULL, 0, SYSLOG_FROM_PROC))
 		return POLLIN | POLLRDNORM;
 	return 0;
diff --git a/kernel/printk/kmsg.c b/kernel/printk/kmsg.c
index 260b2ee..23d4160 100644
--- a/kernel/printk/kmsg.c
+++ b/kernel/printk/kmsg.c
@@ -29,6 +29,34 @@ struct devkmsg_user {
 	char buf[CONSOLE_EXT_LOG_MAX];
 };
 
+static int kmsg_sys_write(int minor, int level, const char *fmt, ...)
+{
+	va_list args;
+	int ret = -ENXIO;
+	struct log_buffer *log_b;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(log_b, &log_buf.list, list) {
+		if (log_b->minor != minor)
+			continue;
+
+		raw_spin_lock(&log_b->lock);
+
+		va_start(args, fmt);
+		log_format_and_store(log_b, 1 /* LOG_USER */, level,
+				     NULL, 0, fmt, args);
+		va_end(args);
+		wake_up_interruptible(&log_b->wait);
+
+		raw_spin_unlock(&log_b->lock);
+
+		ret = 0;
+		break;
+	}
+	rcu_read_unlock();
+	return ret;
+}
+
 static ssize_t devkmsg_write(struct kiocb *iocb, struct iov_iter *from)
 {
 	char *buf, *line;
@@ -37,6 +65,7 @@ static ssize_t devkmsg_write(struct kiocb *iocb, struct iov_iter *from)
 	int facility = 1;	/* LOG_USER */
 	size_t len = iov_iter_count(from);
 	ssize_t ret = len;
+	int minor = iminor(iocb->ki_filp->f_inode);
 
 	if (len > LOG_LINE_MAX)
 		return -EINVAL;
@@ -74,51 +103,57 @@ static ssize_t devkmsg_write(struct kiocb *iocb, struct iov_iter *from)
 		}
 	}
 
-	printk_emit(facility, level, NULL, 0, "%s", line);
+	if (minor == log_buf.minor) {
+		printk_emit(facility, level, NULL, 0, "%s", line);
+	} else {
+		int error = kmsg_sys_write(minor, level, "%s", line);
+
+		if (error)
+			ret = error;
+	}
+
 	kfree(buf);
 	return ret;
 }
 
-static ssize_t devkmsg_read(struct file *file, char __user *buf,
-			    size_t count, loff_t *ppos)
+static ssize_t kmsg_read(struct log_buffer *log_b, struct file *file,
+			 char __user *buf, size_t count, loff_t *ppos)
 {
 	struct devkmsg_user *user = file->private_data;
 	struct printk_log *msg;
 	size_t len;
 	ssize_t ret;
 
-	if (!user)
-		return -EBADF;
-
 	ret = mutex_lock_interruptible(&user->lock);
 	if (ret)
 		return ret;
-	raw_spin_lock_irq(&logbuf_lock);
-	while (user->seq == log_next_seq) {
+
+	raw_spin_lock_irq(&log_b->lock);
+	while (user->seq == log_b->next_seq) {
 		if (file->f_flags & O_NONBLOCK) {
 			ret = -EAGAIN;
-			raw_spin_unlock_irq(&logbuf_lock);
+			raw_spin_unlock_irq(&log_b->lock);
 			goto out;
 		}
 
-		raw_spin_unlock_irq(&logbuf_lock);
-		ret = wait_event_interruptible(log_wait,
-					       user->seq != log_next_seq);
+		raw_spin_unlock_irq(&log_b->lock);
+		ret = wait_event_interruptible(log_b->wait,
+					       user->seq != log_b->next_seq);
 		if (ret)
 			goto out;
-		raw_spin_lock_irq(&logbuf_lock);
+		raw_spin_lock_irq(&log_b->lock);
 	}
 
-	if (user->seq < log_first_seq) {
+	if (user->seq < log_b->first_seq) {
 		/* our last seen message is gone, return error and reset */
-		user->idx = log_first_idx;
-		user->seq = log_first_seq;
+		user->idx = log_b->first_idx;
+		user->seq = log_b->first_seq;
 		ret = -EPIPE;
-		raw_spin_unlock_irq(&logbuf_lock);
+		raw_spin_unlock_irq(&log_b->lock);
 		goto out;
 	}
 
-	msg = log_from_idx(user->idx);
+	msg = log_from_idx(log_b, user->idx);
 	len = msg_print_ext_header(user->buf, sizeof(user->buf),
 				   msg, user->seq, user->prev);
 	len += msg_print_ext_body(user->buf + len, sizeof(user->buf) - len,
@@ -126,9 +161,9 @@ static ssize_t devkmsg_read(struct file *file, char __user *buf,
 				  log_text(msg), msg->text_len);
 
 	user->prev = msg->flags;
-	user->idx = log_next(user->idx);
+	user->idx = log_next(log_b, user->idx);
 	user->seq++;
-	raw_spin_unlock_irq(&logbuf_lock);
+	raw_spin_unlock_irq(&log_b->lock);
 
 	if (len > count) {
 		ret = -EINVAL;
@@ -145,80 +180,144 @@ out:
 	return ret;
 }
 
-static loff_t devkmsg_llseek(struct file *file, loff_t offset, int whence)
+static ssize_t devkmsg_read(struct file *file, char __user *buf,
+			    size_t count, loff_t *ppos)
 {
 	struct devkmsg_user *user = file->private_data;
-	loff_t ret = 0;
+	ssize_t ret = -ENXIO;
+	int minor = iminor(file->f_inode);
+	struct log_buffer *log_b;
 
 	if (!user)
 		return -EBADF;
-	if (offset)
-		return -ESPIPE;
 
-	raw_spin_lock_irq(&logbuf_lock);
+	if (minor == log_buf.minor)
+		return kmsg_read(&log_buf, file, buf, count, ppos);
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(log_b, &log_buf.list, list) {
+		if (log_b->minor == minor) {
+			ret = kmsg_read(log_b, file, buf, count, ppos);
+			break;
+		}
+	}
+	rcu_read_unlock();
+	return ret;
+}
+
+static loff_t kmsg_llseek(struct log_buffer *log_b, struct file *file,
+			  int whence)
+{
+	struct devkmsg_user *user = file->private_data;
+	loff_t ret = 0;
+
+	raw_spin_lock_irq(&log_b->lock);
 	switch (whence) {
 	case SEEK_SET:
 		/* the first record */
-		user->idx = log_first_idx;
-		user->seq = log_first_seq;
+		user->idx = log_b->first_idx;
+		user->seq = log_b->first_seq;
 		break;
 	case SEEK_DATA:
+		/* no clear index for kmsg_sys buffers */
+		if (log_b != &log_buf) {
+			ret = -EINVAL;
+			break;
+		}
 		/*
 		 * The first record after the last SYSLOG_ACTION_CLEAR,
 		 * like issued by 'dmesg -c'. Reading /dev/kmsg itself
 		 * changes no global state, and does not clear anything.
 		 */
-		user->idx = clear_idx;
-		user->seq = clear_seq;
+		user->idx = log_b->clear_idx;
+		user->seq = log_b->clear_seq;
 		break;
 	case SEEK_END:
 		/* after the last record */
-		user->idx = log_next_idx;
-		user->seq = log_next_seq;
+		user->idx = log_b->next_idx;
+		user->seq = log_b->next_seq;
 		break;
 	default:
 		ret = -EINVAL;
 	}
-	raw_spin_unlock_irq(&logbuf_lock);
+	raw_spin_unlock_irq(&log_b->lock);
 	return ret;
 }
 
-static unsigned int devkmsg_poll(struct file *file, poll_table *wait)
+static loff_t devkmsg_llseek(struct file *file, loff_t offset, int whence)
 {
 	struct devkmsg_user *user = file->private_data;
-	int ret = 0;
+	loff_t ret = -ENXIO;
+	int minor = iminor(file->f_inode);
+	struct log_buffer *log_b;
 
 	if (!user)
-		return POLLERR|POLLNVAL;
+		return -EBADF;
+	if (offset)
+		return -ESPIPE;
 
-	poll_wait(file, &log_wait, wait);
+	if (minor == log_buf.minor)
+		return kmsg_llseek(&log_buf, file, whence);
 
-	raw_spin_lock_irq(&logbuf_lock);
-	if (user->seq < log_next_seq) {
+	rcu_read_lock();
+	list_for_each_entry_rcu(log_b, &log_buf.list, list) {
+		if (log_b->minor == minor) {
+			ret = kmsg_llseek(log_b, file, whence);
+			break;
+		}
+	}
+	rcu_read_unlock();
+	return ret;
+}
+
+static unsigned int kmsg_poll(struct log_buffer *log_b,
+			      struct file *file, poll_table *wait)
+{
+	struct devkmsg_user *user = file->private_data;
+	int ret = 0;
+
+	poll_wait(file, &log_b->wait, wait);
+
+	raw_spin_lock_irq(&log_b->lock);
+	if (user->seq < log_b->next_seq) {
 		/* return error when data has vanished underneath us */
-		if (user->seq < log_first_seq)
+		if (user->seq < log_b->first_seq)
 			ret = POLLIN|POLLRDNORM|POLLERR|POLLPRI;
 		else
 			ret = POLLIN|POLLRDNORM;
 	}
-	raw_spin_unlock_irq(&logbuf_lock);
+	raw_spin_unlock_irq(&log_b->lock);
 
 	return ret;
 }
 
-static int devkmsg_open(struct inode *inode, struct file *file)
+static unsigned int devkmsg_poll(struct file *file, poll_table *wait)
 {
-	struct devkmsg_user *user;
-	int err;
+	struct devkmsg_user *user = file->private_data;
+	int ret = POLLERR|POLLNVAL;
+	int minor = iminor(file->f_inode);
+	struct log_buffer *log_b;
 
-	/* write-only does not need any file context */
-	if ((file->f_flags & O_ACCMODE) == O_WRONLY)
-		return 0;
+	if (!user)
+		return POLLERR|POLLNVAL;
 
-	err = check_syslog_permissions(SYSLOG_ACTION_READ_ALL,
-				       SYSLOG_FROM_READER);
-	if (err)
-		return err;
+	if (minor == log_buf.minor)
+		return kmsg_poll(&log_buf, file, wait);
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(log_b, &log_buf.list, list) {
+		if (log_b->minor == minor) {
+			ret = kmsg_poll(log_b, file, wait);
+			break;
+		}
+	}
+	rcu_read_unlock();
+	return ret;
+}
+
+static int kmsg_open(struct log_buffer *log_b, struct file *file)
+{
+	struct devkmsg_user *user;
 
 	user = kmalloc(sizeof(struct devkmsg_user), GFP_KERNEL);
 	if (!user)
@@ -226,15 +325,45 @@ static int devkmsg_open(struct inode *inode, struct file *file)
 
 	mutex_init(&user->lock);
 
-	raw_spin_lock_irq(&logbuf_lock);
-	user->idx = log_first_idx;
-	user->seq = log_first_seq;
-	raw_spin_unlock_irq(&logbuf_lock);
+	raw_spin_lock_irq(&log_b->lock);
+	user->idx = log_b->first_idx;
+	user->seq = log_b->first_seq;
+	raw_spin_unlock_irq(&log_b->lock);
 
 	file->private_data = user;
 	return 0;
 }
 
+static int devkmsg_open(struct inode *inode, struct file *file)
+{
+	int ret = -ENXIO;
+	int minor = iminor(file->f_inode);
+	struct log_buffer *log_b;
+
+	/* write-only does not need any file context */
+	if ((file->f_flags & O_ACCMODE) == O_WRONLY)
+		return 0;
+
+	if (minor == log_buf.minor) {
+		ret = check_syslog_permissions(SYSLOG_ACTION_READ_ALL,
+					       SYSLOG_FROM_READER);
+		if (ret)
+			return ret;
+
+		return kmsg_open(&log_buf, file);
+	}
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(log_b, &log_buf.list, list) {
+		if (log_b->minor == minor) {
+			ret = kmsg_open(log_b, file);
+			break;
+		}
+	}
+	rcu_read_unlock();
+	return ret;
+}
+
 static int devkmsg_release(struct inode *inode, struct file *file)
 {
 	struct devkmsg_user *user = file->private_data;
@@ -341,12 +470,12 @@ void kmsg_dump(enum kmsg_dump_reason reason)
 		/* initialize iterator with data about the stored records */
 		dumper->active = true;
 
-		raw_spin_lock_irqsave(&logbuf_lock, flags);
-		dumper->cur_seq = clear_seq;
-		dumper->cur_idx = clear_idx;
-		dumper->next_seq = log_next_seq;
-		dumper->next_idx = log_next_idx;
-		raw_spin_unlock_irqrestore(&logbuf_lock, flags);
+		raw_spin_lock_irqsave(&log_buf.lock, flags);
+		dumper->cur_seq = log_buf.clear_seq;
+		dumper->cur_idx = log_buf.clear_idx;
+		dumper->next_seq = log_buf.next_seq;
+		dumper->next_idx = log_buf.next_idx;
+		raw_spin_unlock_irqrestore(&log_buf.lock, flags);
 
 		/* invoke dumper which will iterate over records */
 		dumper->dump(dumper, reason);
@@ -386,20 +515,20 @@ bool kmsg_dump_get_line_nolock(struct kmsg_dumper *dumper, bool syslog,
 	if (!dumper->active)
 		goto out;
 
-	if (dumper->cur_seq < log_first_seq) {
+	if (dumper->cur_seq < log_buf.first_seq) {
 		/* messages are gone, move to first available one */
-		dumper->cur_seq = log_first_seq;
-		dumper->cur_idx = log_first_idx;
+		dumper->cur_seq = log_buf.first_seq;
+		dumper->cur_idx = log_buf.first_idx;
 	}
 
 	/* last entry */
-	if (dumper->cur_seq >= log_next_seq)
+	if (dumper->cur_seq >= log_buf.next_seq)
 		goto out;
 
-	msg = log_from_idx(dumper->cur_idx);
+	msg = log_from_idx(&log_buf, dumper->cur_idx);
 	l = msg_print_text(msg, 0, syslog, line, size);
 
-	dumper->cur_idx = log_next(dumper->cur_idx);
+	dumper->cur_idx = log_next(&log_buf, dumper->cur_idx);
 	dumper->cur_seq++;
 	ret = true;
 out:
@@ -431,9 +560,9 @@ bool kmsg_dump_get_line(struct kmsg_dumper *dumper, bool syslog,
 	unsigned long flags;
 	bool ret;
 
-	raw_spin_lock_irqsave(&logbuf_lock, flags);
+	raw_spin_lock_irqsave(&log_buf.lock, flags);
 	ret = kmsg_dump_get_line_nolock(dumper, syslog, line, size, len);
-	raw_spin_unlock_irqrestore(&logbuf_lock, flags);
+	raw_spin_unlock_irqrestore(&log_buf.lock, flags);
 
 	return ret;
 }
@@ -473,16 +602,16 @@ bool kmsg_dump_get_buffer(struct kmsg_dumper *dumper, bool syslog,
 	if (!dumper->active)
 		goto out;
 
-	raw_spin_lock_irqsave(&logbuf_lock, flags);
-	if (dumper->cur_seq < log_first_seq) {
+	raw_spin_lock_irqsave(&log_buf.lock, flags);
+	if (dumper->cur_seq < log_buf.first_seq) {
 		/* messages are gone, move to first available one */
-		dumper->cur_seq = log_first_seq;
-		dumper->cur_idx = log_first_idx;
+		dumper->cur_seq = log_buf.first_seq;
+		dumper->cur_idx = log_buf.first_idx;
 	}
 
 	/* last entry */
 	if (dumper->cur_seq >= dumper->next_seq) {
-		raw_spin_unlock_irqrestore(&logbuf_lock, flags);
+		raw_spin_unlock_irqrestore(&log_buf.lock, flags);
 		goto out;
 	}
 
@@ -491,10 +620,10 @@ bool kmsg_dump_get_buffer(struct kmsg_dumper *dumper, bool syslog,
 	idx = dumper->cur_idx;
 	prev = 0;
 	while (seq < dumper->next_seq) {
-		struct printk_log *msg = log_from_idx(idx);
+		struct printk_log *msg = log_from_idx(&log_buf, idx);
 
 		l += msg_print_text(msg, prev, true, NULL, 0);
-		idx = log_next(idx);
+		idx = log_next(&log_buf, idx);
 		seq++;
 		prev = msg->flags;
 	}
@@ -504,10 +633,10 @@ bool kmsg_dump_get_buffer(struct kmsg_dumper *dumper, bool syslog,
 	idx = dumper->cur_idx;
 	prev = 0;
 	while (l > size && seq < dumper->next_seq) {
-		struct printk_log *msg = log_from_idx(idx);
+		struct printk_log *msg = log_from_idx(&log_buf, idx);
 
 		l -= msg_print_text(msg, prev, true, NULL, 0);
-		idx = log_next(idx);
+		idx = log_next(&log_buf, idx);
 		seq++;
 		prev = msg->flags;
 	}
@@ -518,10 +647,10 @@ bool kmsg_dump_get_buffer(struct kmsg_dumper *dumper, bool syslog,
 
 	l = 0;
 	while (seq < dumper->next_seq) {
-		struct printk_log *msg = log_from_idx(idx);
+		struct printk_log *msg = log_from_idx(&log_buf, idx);
 
 		l += msg_print_text(msg, prev, syslog, buf + l, size - l);
-		idx = log_next(idx);
+		idx = log_next(&log_buf, idx);
 		seq++;
 		prev = msg->flags;
 	}
@@ -529,7 +658,7 @@ bool kmsg_dump_get_buffer(struct kmsg_dumper *dumper, bool syslog,
 	dumper->next_seq = next_seq;
 	dumper->next_idx = next_idx;
 	ret = true;
-	raw_spin_unlock_irqrestore(&logbuf_lock, flags);
+	raw_spin_unlock_irqrestore(&log_buf.lock, flags);
 out:
 	if (len)
 		*len = l;
@@ -549,10 +678,10 @@ EXPORT_SYMBOL_GPL(kmsg_dump_get_buffer);
  */
 void kmsg_dump_rewind_nolock(struct kmsg_dumper *dumper)
 {
-	dumper->cur_seq = clear_seq;
-	dumper->cur_idx = clear_idx;
-	dumper->next_seq = log_next_seq;
-	dumper->next_idx = log_next_idx;
+	dumper->cur_seq = log_buf.clear_seq;
+	dumper->cur_idx = log_buf.clear_idx;
+	dumper->next_seq = log_buf.next_seq;
+	dumper->next_idx = log_buf.next_idx;
 }
 
 /**
@@ -567,8 +696,8 @@ void kmsg_dump_rewind(struct kmsg_dumper *dumper)
 {
 	unsigned long flags;
 
-	raw_spin_lock_irqsave(&logbuf_lock, flags);
+	raw_spin_lock_irqsave(&log_buf.lock, flags);
 	kmsg_dump_rewind_nolock(dumper);
-	raw_spin_unlock_irqrestore(&logbuf_lock, flags);
+	raw_spin_unlock_irqrestore(&log_buf.lock, flags);
 }
 EXPORT_SYMBOL_GPL(kmsg_dump_rewind);
diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index ee80655..e9ac4ba 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -146,10 +146,7 @@ EXPORT_SYMBOL(console_set_on_cmdline);
 /* Flag: console code may call schedule() */
 static int console_may_schedule;
 
-DEFINE_RAW_SPINLOCK(logbuf_lock);
-
 #ifdef CONFIG_PRINTK
-DECLARE_WAIT_QUEUE_HEAD(log_wait);
 /* the next printk record to read by syslog(READ) or /proc/kmsg */
 static u64 syslog_seq;
 static u32 syslog_idx;
@@ -161,25 +158,31 @@ static u64 console_seq;
 static u32 console_idx;
 static enum log_flags console_prev;
 
-u64 log_first_seq;
-u32 log_first_idx;
-
-u64 log_next_seq;
-u32 log_next_idx;
-
-u64 clear_seq;
-u32 clear_idx;
-
 /* record buffer */
 #if defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS)
 #define LOG_ALIGN 4
 #else
 #define LOG_ALIGN __alignof__(struct printk_log)
 #endif
-#define __LOG_BUF_LEN (1 << CONFIG_LOG_BUF_SHIFT)
-static char __log_buf[__LOG_BUF_LEN] __aligned(LOG_ALIGN);
-static char *log_buf = __log_buf;
-static u32 log_buf_len = __LOG_BUF_LEN;
+#define __LOG_BUF_K_LEN (1 << CONFIG_LOG_BUF_SHIFT)
+static char __log_buf_k[__LOG_BUF_K_LEN] __aligned(LOG_ALIGN);
+
+struct log_buffer log_buf = {
+	.list		= LIST_HEAD_INIT(log_buf.list),
+	.buf		= __log_buf_k,
+	.len		= __LOG_BUF_K_LEN,
+	.lock		= __RAW_SPIN_LOCK_UNLOCKED(log_buf.lock),
+	.wait		= __WAIT_QUEUE_HEAD_INITIALIZER(log_buf.wait),
+	.first_seq	= 0,
+	.first_idx	= 0,
+	.next_seq	= 0,
+	.next_idx	= 0,
+	.clear_seq	= 0,
+	.clear_idx	= 0,
+	.minor		= 0,
+};
+
+wait_queue_head_t *log_wait = &log_buf.wait;
 
 /*
  * Continuation lines are buffered, and not committed to the record buffer
@@ -205,13 +208,13 @@ static bool cont_add(int facility, int level, const char *text, size_t len);
 /* Return log buffer address */
 char *log_buf_addr_get(void)
 {
-	return log_buf;
+	return log_buf.buf;
 }
 
 /* Return log buffer size */
 u32 log_buf_len_get(void)
 {
-	return log_buf_len;
+	return log_buf.len;
 }
 
 /*
@@ -223,14 +226,14 @@ u32 log_buf_len_get(void)
  * If the buffer is empty, we must respect the position of the indexes.
  * They cannot be reset to the beginning of the buffer.
  */
-static int logbuf_has_space(u32 msg_size, bool empty)
+static int logbuf_has_space(struct log_buffer *log_b, u32 msg_size, bool empty)
 {
 	u32 free;
 
-	if (log_next_idx > log_first_idx || empty)
-		free = max(log_buf_len - log_next_idx, log_first_idx);
+	if (log_b->next_idx > log_b->first_idx || empty)
+		free = max(log_b->len - log_b->next_idx, log_b->first_idx);
 	else
-		free = log_first_idx - log_next_idx;
+		free = log_b->first_idx - log_b->next_idx;
 
 	/*
 	 * We need space also for an empty header that signalizes wrapping
@@ -239,18 +242,18 @@ static int logbuf_has_space(u32 msg_size, bool empty)
 	return free >= msg_size + sizeof(struct printk_log);
 }
 
-static int log_make_free_space(u32 msg_size)
+static int log_make_free_space(struct log_buffer *log_b, u32 msg_size)
 {
-	while (log_first_seq < log_next_seq) {
-		if (logbuf_has_space(msg_size, false))
+	while (log_b->first_seq < log_b->next_seq) {
+		if (logbuf_has_space(log_b, msg_size, false))
 			return 0;
 		/* drop old messages until we have enough contiguous space */
-		log_first_idx = log_next(log_first_idx);
-		log_first_seq++;
+		log_b->first_idx = log_next(log_b, log_b->first_idx);
+		log_b->first_seq++;
 	}
 
 	/* sequence numbers are equal, so the log buffer is empty */
-	if (logbuf_has_space(msg_size, true))
+	if (logbuf_has_space(log_b, msg_size, true))
 		return 0;
 
 	return -ENOMEM;
@@ -276,14 +279,15 @@ static u32 msg_used_size(u16 text_len, u16 dict_len, u32 *pad_len)
 #define MAX_LOG_TAKE_PART 4
 static const char trunc_msg[] = "<truncated>";
 
-static u32 truncate_msg(u16 *text_len, u16 *trunc_msg_len,
+static u32 truncate_msg(struct log_buffer *log_b,
+			u16 *text_len, u16 *trunc_msg_len,
 			u16 *dict_len, u32 *pad_len)
 {
 	/*
 	 * The message should not take the whole buffer. Otherwise, it might
 	 * get removed too soon.
 	 */
-	u32 max_text_len = log_buf_len / MAX_LOG_TAKE_PART;
+	u32 max_text_len = log_b->len / MAX_LOG_TAKE_PART;
 	if (*text_len > max_text_len)
 		*text_len = max_text_len;
 	/* enable the warning message */
@@ -295,7 +299,8 @@ static u32 truncate_msg(u16 *text_len, u16 *trunc_msg_len,
 }
 
 /* insert record into the buffer, discard old ones, update heads */
-static int log_store(int facility, int level,
+static int log_store(struct log_buffer *log_b,
+		     int facility, int level,
 		     enum log_flags flags, u64 ts_nsec,
 		     const char *dict, u16 dict_len,
 		     const char *text, u16 text_len)
@@ -307,27 +312,28 @@ static int log_store(int facility, int level,
 	/* number of '\0' padding bytes to next message */
 	size = msg_used_size(text_len, dict_len, &pad_len);
 
-	if (log_make_free_space(size)) {
+	if (log_make_free_space(log_b, size)) {
 		/* truncate the message if it is too long for empty buffer */
-		size = truncate_msg(&text_len, &trunc_msg_len,
+		size = truncate_msg(log_b, &text_len, &trunc_msg_len,
 				    &dict_len, &pad_len);
 		/* survive when the log buffer is too small for trunc_msg */
-		if (log_make_free_space(size))
+		if (log_make_free_space(log_b, size))
 			return 0;
 	}
 
-	if (log_next_idx + size + sizeof(struct printk_log) > log_buf_len) {
+	if (log_b->next_idx + size + sizeof(struct printk_log) > log_b->len) {
 		/*
 		 * This message + an additional empty header does not fit
 		 * at the end of the buffer. Add an empty header with len == 0
 		 * to signify a wrap around.
 		 */
-		memset(log_buf + log_next_idx, 0, sizeof(struct printk_log));
-		log_next_idx = 0;
+		memset(log_b->buf + log_b->next_idx, 0,
+			sizeof(struct printk_log));
+		log_b->next_idx = 0;
 	}
 
 	/* fill message */
-	msg = (struct printk_log *)(log_buf + log_next_idx);
+	msg = (struct printk_log *)(log_b->buf + log_b->next_idx);
 	memcpy(log_text(msg), text, text_len);
 	msg->text_len = text_len;
 	if (trunc_msg_len) {
@@ -347,15 +353,16 @@ static int log_store(int facility, int level,
 	msg->len = size;
 
 	/* insert message */
-	log_next_idx += msg->len;
-	log_next_seq++;
+	log_b->next_idx += msg->len;
+	log_b->next_seq++;
 
 	return msg->text_len;
 }
 
-static int log_format_and_store(int facility, int level,
-				const char *dict, size_t dictlen,
-				const char *fmt, va_list args)
+int log_format_and_store(struct log_buffer *log_b,
+			 int facility, int level,
+			 const char *dict, size_t dictlen,
+			 const char *fmt, va_list args)
 {
 	static char textbuf[LOG_LINE_MAX];
 	char *text = textbuf;
@@ -406,6 +413,10 @@ static int log_format_and_store(int facility, int level,
 	if (dict)
 		lflags |= LOG_PREFIX|LOG_NEWLINE;
 
+	if (log_b != &log_buf)
+		return log_store(log_b, facility, level, lflags, 0,
+				 dict, dictlen, text, text_len);
+
 	if (!(lflags & LOG_NEWLINE)) {
 		/*
 		 * Flush the conflicting buffer. An earlier newline was missing,
@@ -418,7 +429,7 @@ static int log_format_and_store(int facility, int level,
 		if (cont_add(facility, level, text, text_len))
 			printed_len += text_len;
 		else
-			printed_len += log_store(facility, level,
+			printed_len += log_store(log_b, facility, level,
 						 lflags | LOG_CONT, 0,
 						 dict, dictlen, text, text_len);
 	} else {
@@ -442,7 +453,7 @@ static int log_format_and_store(int facility, int level,
 		if (stored)
 			printed_len += text_len;
 		else
-			printed_len += log_store(facility, level,
+			printed_len += log_store(log_b, facility, level,
 						 lflags, 0, dict, dictlen,
 						 text, text_len);
 	}
@@ -585,9 +596,11 @@ ssize_t msg_print_ext_body(char *buf, size_t size,
 void log_buf_kexec_setup(void)
 {
 	VMCOREINFO_SYMBOL(log_buf);
-	VMCOREINFO_SYMBOL(log_buf_len);
-	VMCOREINFO_SYMBOL(log_first_idx);
-	VMCOREINFO_SYMBOL(log_next_idx);
+	VMCOREINFO_STRUCT_SIZE(log_buffer);
+	VMCOREINFO_OFFSET(log_buffer, buf);
+	VMCOREINFO_OFFSET(log_buffer, len);
+	VMCOREINFO_OFFSET(log_buffer, first_idx);
+	VMCOREINFO_OFFSET(log_buffer, next_idx);
 	/*
 	 * Export struct printk_log size and field offsets. User space tools can
 	 * parse it and detect any changes to structure down the line.
@@ -608,7 +621,7 @@ static void __init log_buf_len_update(unsigned size)
 {
 	if (size)
 		size = roundup_pow_of_two(size);
-	if (size > log_buf_len)
+	if (size > log_buf.len)
 		new_log_buf_len = size;
 }
 
@@ -641,16 +654,16 @@ static void __init log_buf_add_cpu(void)
 	cpu_extra = (num_possible_cpus() - 1) * __LOG_CPU_MAX_BUF_LEN;
 
 	/* by default this will only continue through for large > 64 CPUs */
-	if (cpu_extra <= __LOG_BUF_LEN / 2)
+	if (cpu_extra <= __LOG_BUF_K_LEN / 2)
 		return;
 
-	pr_info("log_buf_len individual max cpu contribution: %d bytes\n",
+	pr_info("log_buf.len individual max cpu contribution: %d bytes\n",
 		__LOG_CPU_MAX_BUF_LEN);
-	pr_info("log_buf_len total cpu_extra contributions: %d bytes\n",
+	pr_info("log_buf.len total cpu_extra contributions: %d bytes\n",
 		cpu_extra);
-	pr_info("log_buf_len min size: %d bytes\n", __LOG_BUF_LEN);
+	pr_info("log_buf.len min size: %d bytes\n", __LOG_BUF_K_LEN);
 
-	log_buf_len_update(cpu_extra + __LOG_BUF_LEN);
+	log_buf_len_update(cpu_extra + __LOG_BUF_K_LEN);
 }
 #else /* !CONFIG_SMP */
 static inline void log_buf_add_cpu(void) {}
@@ -662,7 +675,7 @@ void __init setup_log_buf(int early)
 	char *new_log_buf;
 	int free;
 
-	if (log_buf != __log_buf)
+	if (log_buf.buf != __log_buf_k)
 		return;
 
 	if (!early && !new_log_buf_len)
@@ -680,22 +693,22 @@ void __init setup_log_buf(int early)
 	}
 
 	if (unlikely(!new_log_buf)) {
-		pr_err("log_buf_len: %ld bytes not available\n",
+		pr_err("log_buf.len: %ld bytes not available\n",
 			new_log_buf_len);
 		return;
 	}
 
-	raw_spin_lock_irqsave(&logbuf_lock, flags);
-	log_buf_len = new_log_buf_len;
-	log_buf = new_log_buf;
+	raw_spin_lock_irqsave(&log_buf.lock, flags);
+	log_buf.len = new_log_buf_len;
+	log_buf.buf = new_log_buf;
 	new_log_buf_len = 0;
-	free = __LOG_BUF_LEN - log_next_idx;
-	memcpy(log_buf, __log_buf, __LOG_BUF_LEN);
-	raw_spin_unlock_irqrestore(&logbuf_lock, flags);
+	free = __LOG_BUF_K_LEN - log_buf.next_idx;
+	memcpy(log_buf.buf, __log_buf_k, __LOG_BUF_K_LEN);
+	raw_spin_unlock_irqrestore(&log_buf.lock, flags);
 
-	pr_info("log_buf_len: %d bytes\n", log_buf_len);
+	pr_info("log_buf.len: %d bytes\n", log_buf.len);
 	pr_info("early log buf free: %d(%d%%)\n",
-		free, (free * 100) / __LOG_BUF_LEN);
+		free, (free * 100) / __LOG_BUF_K_LEN);
 }
 
 static bool __read_mostly ignore_loglevel;
@@ -883,26 +896,26 @@ static int syslog_print(char __user *buf, int size)
 		size_t n;
 		size_t skip;
 
-		raw_spin_lock_irq(&logbuf_lock);
-		if (syslog_seq < log_first_seq) {
+		raw_spin_lock_irq(&log_buf.lock);
+		if (syslog_seq < log_buf.first_seq) {
 			/* messages are gone, move to first one */
-			syslog_seq = log_first_seq;
-			syslog_idx = log_first_idx;
+			syslog_seq = log_buf.first_seq;
+			syslog_idx = log_buf.first_idx;
 			syslog_prev = 0;
 			syslog_partial = 0;
 		}
-		if (syslog_seq == log_next_seq) {
-			raw_spin_unlock_irq(&logbuf_lock);
+		if (syslog_seq == log_buf.next_seq) {
+			raw_spin_unlock_irq(&log_buf.lock);
 			break;
 		}
 
 		skip = syslog_partial;
-		msg = log_from_idx(syslog_idx);
+		msg = log_from_idx(&log_buf, syslog_idx);
 		n = msg_print_text(msg, syslog_prev, true, text,
 				   LOG_LINE_MAX + PREFIX_MAX);
 		if (n - syslog_partial <= size) {
 			/* message fits into buffer, move forward */
-			syslog_idx = log_next(syslog_idx);
+			syslog_idx = log_next(&log_buf, syslog_idx);
 			syslog_seq++;
 			syslog_prev = msg->flags;
 			n -= syslog_partial;
@@ -913,7 +926,7 @@ static int syslog_print(char __user *buf, int size)
 			syslog_partial += n;
 		} else
 			n = 0;
-		raw_spin_unlock_irq(&logbuf_lock);
+		raw_spin_unlock_irq(&log_buf.lock);
 
 		if (!n)
 			break;
@@ -942,54 +955,54 @@ static int syslog_print_all(char __user *buf, int size, bool clear)
 	if (!text)
 		return -ENOMEM;
 
-	raw_spin_lock_irq(&logbuf_lock);
+	raw_spin_lock_irq(&log_buf.lock);
 	if (buf) {
 		u64 next_seq;
 		u64 seq;
 		u32 idx;
 		enum log_flags prev;
 
-		if (clear_seq < log_first_seq) {
+		if (log_buf.clear_seq < log_buf.first_seq) {
 			/* messages are gone, move to first available one */
-			clear_seq = log_first_seq;
-			clear_idx = log_first_idx;
+			log_buf.clear_seq = log_buf.first_seq;
+			log_buf.clear_idx = log_buf.first_idx;
 		}
 
 		/*
 		 * Find first record that fits, including all following records,
 		 * into the user-provided buffer for this dump.
 		 */
-		seq = clear_seq;
-		idx = clear_idx;
+		seq = log_buf.clear_seq;
+		idx = log_buf.clear_idx;
 		prev = 0;
-		while (seq < log_next_seq) {
-			struct printk_log *msg = log_from_idx(idx);
+		while (seq < log_buf.next_seq) {
+			struct printk_log *msg = log_from_idx(&log_buf, idx);
 
 			len += msg_print_text(msg, prev, true, NULL, 0);
 			prev = msg->flags;
-			idx = log_next(idx);
+			idx = log_next(&log_buf, idx);
 			seq++;
 		}
 
 		/* move first record forward until length fits into the buffer */
-		seq = clear_seq;
-		idx = clear_idx;
+		seq = log_buf.clear_seq;
+		idx = log_buf.clear_idx;
 		prev = 0;
-		while (len > size && seq < log_next_seq) {
-			struct printk_log *msg = log_from_idx(idx);
+		while (len > size && seq < log_buf.next_seq) {
+			struct printk_log *msg = log_from_idx(&log_buf, idx);
 
 			len -= msg_print_text(msg, prev, true, NULL, 0);
 			prev = msg->flags;
-			idx = log_next(idx);
+			idx = log_next(&log_buf, idx);
 			seq++;
 		}
 
 		/* last message fitting into this dump */
-		next_seq = log_next_seq;
+		next_seq = log_buf.next_seq;
 
 		len = 0;
 		while (len >= 0 && seq < next_seq) {
-			struct printk_log *msg = log_from_idx(idx);
+			struct printk_log *msg = log_from_idx(&log_buf, idx);
 			int textlen;
 
 			textlen = msg_print_text(msg, prev, true, text,
@@ -998,31 +1011,31 @@ static int syslog_print_all(char __user *buf, int size, bool clear)
 				len = textlen;
 				break;
 			}
-			idx = log_next(idx);
+			idx = log_next(&log_buf, idx);
 			seq++;
 			prev = msg->flags;
 
-			raw_spin_unlock_irq(&logbuf_lock);
+			raw_spin_unlock_irq(&log_buf.lock);
 			if (copy_to_user(buf + len, text, textlen))
 				len = -EFAULT;
 			else
 				len += textlen;
-			raw_spin_lock_irq(&logbuf_lock);
+			raw_spin_lock_irq(&log_buf.lock);
 
-			if (seq < log_first_seq) {
+			if (seq < log_buf.first_seq) {
 				/* messages are gone, move to next one */
-				seq = log_first_seq;
-				idx = log_first_idx;
+				seq = log_buf.first_seq;
+				idx = log_buf.first_idx;
 				prev = 0;
 			}
 		}
 	}
 
 	if (clear) {
-		clear_seq = log_next_seq;
-		clear_idx = log_next_idx;
+		log_buf.clear_seq = log_buf.next_seq;
+		log_buf.clear_idx = log_buf.next_idx;
 	}
-	raw_spin_unlock_irq(&logbuf_lock);
+	raw_spin_unlock_irq(&log_buf.lock);
 
 	kfree(text);
 	return len;
@@ -1054,8 +1067,8 @@ int do_syslog(int type, char __user *buf, int len, int source)
 			error = -EFAULT;
 			goto out;
 		}
-		error = wait_event_interruptible(log_wait,
-						 syslog_seq != log_next_seq);
+		error = wait_event_interruptible(log_buf.wait,
+						syslog_seq != log_buf.next_seq);
 		if (error)
 			goto out;
 		error = syslog_print(buf, len);
@@ -1109,11 +1122,11 @@ int do_syslog(int type, char __user *buf, int len, int source)
 		break;
 	/* Number of chars in the log buffer */
 	case SYSLOG_ACTION_SIZE_UNREAD:
-		raw_spin_lock_irq(&logbuf_lock);
-		if (syslog_seq < log_first_seq) {
+		raw_spin_lock_irq(&log_buf.lock);
+		if (syslog_seq < log_buf.first_seq) {
 			/* messages are gone, move to first one */
-			syslog_seq = log_first_seq;
-			syslog_idx = log_first_idx;
+			syslog_seq = log_buf.first_seq;
+			syslog_idx = log_buf.first_idx;
 			syslog_prev = 0;
 			syslog_partial = 0;
 		}
@@ -1123,28 +1136,30 @@ int do_syslog(int type, char __user *buf, int len, int source)
 			 * for pending data, not the size; return the count of
 			 * records, not the length.
 			 */
-			error = log_next_seq - syslog_seq;
+			error = log_buf.next_seq - syslog_seq;
 		} else {
 			u64 seq = syslog_seq;
 			u32 idx = syslog_idx;
 			enum log_flags prev = syslog_prev;
 
 			error = 0;
-			while (seq < log_next_seq) {
-				struct printk_log *msg = log_from_idx(idx);
+			while (seq < log_buf.next_seq) {
+				struct printk_log *msg = log_from_idx(&log_buf,
+								      idx);
 
-				error += msg_print_text(msg, prev, true, NULL, 0);
-				idx = log_next(idx);
+				error += msg_print_text(msg, prev, true,
+							NULL, 0);
+				idx = log_next(&log_buf, idx);
 				seq++;
 				prev = msg->flags;
 			}
 			error -= syslog_partial;
 		}
-		raw_spin_unlock_irq(&logbuf_lock);
+		raw_spin_unlock_irq(&log_buf.lock);
 		break;
 	/* Size of the log buffer */
 	case SYSLOG_ACTION_SIZE_BUFFER:
-		error = log_buf_len;
+		error = log_buf.len;
 		break;
 	default:
 		error = -EINVAL;
@@ -1211,7 +1226,7 @@ static void zap_locks(void)
 
 	debug_locks_off();
 	/* If a crash is occurring, make sure we can't deadlock */
-	raw_spin_lock_init(&logbuf_lock);
+	raw_spin_lock_init(&log_buf.lock);
 	/* And make sure that we print immediately */
 	sema_init(&console_sem, 1);
 }
@@ -1295,8 +1310,9 @@ static void cont_flush(enum log_flags flags)
 		 * console; wait for the console to pick up the rest of the
 		 * line. LOG_NOCONS suppresses a duplicated output.
 		 */
-		log_store(cont.facility, cont.level, flags | LOG_NOCONS,
-			  cont.ts_nsec, NULL, 0, cont.buf, cont.len);
+		log_store(&log_buf, cont.facility, cont.level,
+			  flags | LOG_NOCONS, cont.ts_nsec, NULL, 0,
+			  cont.buf, cont.len);
 		cont.flags = flags;
 		cont.flushed = true;
 	} else {
@@ -1304,7 +1320,7 @@ static void cont_flush(enum log_flags flags)
 		 * If no fragment of this line ever reached the console,
 		 * just submit it to the store and free the buffer.
 		 */
-		log_store(cont.facility, cont.level, flags, 0,
+		log_store(&log_buf, cont.facility, cont.level, flags, 0,
 			  NULL, 0, cont.buf, cont.len);
 		cont.len = 0;
 	}
@@ -1381,7 +1397,7 @@ asmlinkage int vprintk_emit(int facility, int level,
 	int this_cpu;
 	int printed_len = 0;
 	bool in_sched = false;
-	/* cpu currently holding logbuf_lock in this function */
+	/* cpu currently holding log_buf.lock in this function */
 	static unsigned int logbuf_cpu = UINT_MAX;
 
 	if (level == LOGLEVEL_SCHED) {
@@ -1416,7 +1432,7 @@ asmlinkage int vprintk_emit(int facility, int level,
 	}
 
 	lockdep_off();
-	raw_spin_lock(&logbuf_lock);
+	raw_spin_lock(&log_buf.lock);
 	logbuf_cpu = this_cpu;
 
 	if (unlikely(recursion_bug)) {
@@ -1425,16 +1441,17 @@ asmlinkage int vprintk_emit(int facility, int level,
 
 		recursion_bug = 0;
 		/* emit KERN_CRIT message */
-		printed_len += log_store(0, 2, LOG_PREFIX|LOG_NEWLINE, 0,
+		printed_len += log_store(&log_buf, 0, 2,
+					 LOG_PREFIX|LOG_NEWLINE, 0,
 					 NULL, 0, recursion_msg,
 					 strlen(recursion_msg));
 	}
 
-	printed_len += log_format_and_store(facility, level, dict, dictlen,
-					    fmt, args);
+	printed_len += log_format_and_store(&log_buf, facility, level,
+					    dict, dictlen, fmt, args);
 
 	logbuf_cpu = UINT_MAX;
-	raw_spin_unlock(&logbuf_lock);
+	raw_spin_unlock(&log_buf.lock);
 	lockdep_on();
 	local_irq_restore(flags);
 
@@ -1557,14 +1574,18 @@ EXPORT_SYMBOL(printk);
 #define LOG_LINE_MAX		0
 #define PREFIX_MAX		0
 
+static struct log_buffer log_buf = {
+	.lock		= __RAW_SPIN_LOCK_UNLOCKED(log_buf.lock),
+	.first_seq	= 0,
+	.first_idx	= 0,
+	.next_seq	= 0,
+};
+
 static u64 syslog_seq;
 static u32 syslog_idx;
 static u64 console_seq;
 static u32 console_idx;
 static enum log_flags syslog_prev;
-static u64 log_first_seq;
-static u32 log_first_idx;
-static u64 log_next_seq;
 static enum log_flags console_prev;
 static struct cont {
 	size_t len;
@@ -1809,7 +1830,7 @@ static void console_cont_flush(char *text, size_t size)
 	unsigned long flags;
 	size_t len;
 
-	raw_spin_lock_irqsave(&logbuf_lock, flags);
+	raw_spin_lock_irqsave(&log_buf.lock, flags);
 
 	if (!cont.len)
 		goto out;
@@ -1819,18 +1840,18 @@ static void console_cont_flush(char *text, size_t size)
 	 * busy. The earlier ones need to be printed before this one, we
 	 * did not flush any fragment so far, so just let it queue up.
 	 */
-	if (console_seq < log_next_seq && !cont.cons)
+	if (console_seq < log_buf.next_seq && !cont.cons)
 		goto out;
 
 	len = cont_print_text(text, size);
-	raw_spin_unlock(&logbuf_lock);
+	raw_spin_unlock(&log_buf.lock);
 	stop_critical_timings();
 	call_console_drivers(cont.level, NULL, 0, text, len);
 	start_critical_timings();
 	local_irq_restore(flags);
 	return;
 out:
-	raw_spin_unlock_irqrestore(&logbuf_lock, flags);
+	raw_spin_unlock_irqrestore(&log_buf.lock, flags);
 }
 
 /**
@@ -1872,34 +1893,34 @@ again:
 		size_t len;
 		int level;
 
-		raw_spin_lock_irqsave(&logbuf_lock, flags);
-		if (seen_seq != log_next_seq) {
+		raw_spin_lock_irqsave(&log_buf.lock, flags);
+		if (seen_seq != log_buf.next_seq) {
 			wake_klogd = true;
-			seen_seq = log_next_seq;
+			seen_seq = log_buf.next_seq;
 		}
 
-		if (console_seq < log_first_seq) {
+		if (console_seq < log_buf.first_seq) {
 			len = sprintf(text, "** %u printk messages dropped ** ",
-				      (unsigned)(log_first_seq - console_seq));
+				  (unsigned)(log_buf.first_seq - console_seq));
 
 			/* messages are gone, move to first one */
-			console_seq = log_first_seq;
-			console_idx = log_first_idx;
+			console_seq = log_buf.first_seq;
+			console_idx = log_buf.first_idx;
 			console_prev = 0;
 		} else {
 			len = 0;
 		}
 skip:
-		if (console_seq == log_next_seq)
+		if (console_seq == log_buf.next_seq)
 			break;
 
-		msg = log_from_idx(console_idx);
+		msg = log_from_idx(&log_buf, console_idx);
 		if (msg->flags & LOG_NOCONS) {
 			/*
 			 * Skip record we have buffered and already printed
 			 * directly to the console when we received it.
 			 */
-			console_idx = log_next(console_idx);
+			console_idx = log_next(&log_buf, console_idx);
 			console_seq++;
 			/*
 			 * We will get here again when we register a new
@@ -1923,10 +1944,10 @@ skip:
 						log_dict(msg), msg->dict_len,
 						log_text(msg), msg->text_len);
 		}
-		console_idx = log_next(console_idx);
+		console_idx = log_next(&log_buf, console_idx);
 		console_seq++;
 		console_prev = msg->flags;
-		raw_spin_unlock(&logbuf_lock);
+		raw_spin_unlock(&log_buf.lock);
 
 		stop_critical_timings();	/* don't trace print latency */
 		call_console_drivers(level, ext_text, ext_len, text, len);
@@ -1939,7 +1960,7 @@ skip:
 	if (unlikely(exclusive_console))
 		exclusive_console = NULL;
 
-	raw_spin_unlock(&logbuf_lock);
+	raw_spin_unlock(&log_buf.lock);
 
 	up_console_sem();
 
@@ -1949,9 +1970,9 @@ skip:
 	 * there's a new owner and the console_unlock() from them will do the
 	 * flush, no worries.
 	 */
-	raw_spin_lock(&logbuf_lock);
-	retry = console_seq != log_next_seq;
-	raw_spin_unlock_irqrestore(&logbuf_lock, flags);
+	raw_spin_lock(&log_buf.lock);
+	retry = console_seq != log_buf.next_seq;
+	raw_spin_unlock_irqrestore(&log_buf.lock, flags);
 
 	if (retry && console_trylock())
 		goto again;
@@ -2195,11 +2216,11 @@ void register_console(struct console *newcon)
 		 * console_unlock(); will print out the buffered messages
 		 * for us.
 		 */
-		raw_spin_lock_irqsave(&logbuf_lock, flags);
+		raw_spin_lock_irqsave(&log_buf.lock, flags);
 		console_seq = syslog_seq;
 		console_idx = syslog_idx;
 		console_prev = syslog_prev;
-		raw_spin_unlock_irqrestore(&logbuf_lock, flags);
+		raw_spin_unlock_irqrestore(&log_buf.lock, flags);
 		/*
 		 * We're about to replay the log buffer.  Only do this to the
 		 * just-registered console to avoid excessive message spam to
@@ -2313,7 +2334,7 @@ static void wake_up_klogd_work_func(struct irq_work *irq_work)
 	}
 
 	if (pending & PRINTK_PENDING_WAKEUP)
-		wake_up_interruptible(&log_wait);
+		wake_up_interruptible(&log_buf.wait);
 }
 
 static DEFINE_PER_CPU(struct irq_work, wake_up_klogd_work) = {
@@ -2324,7 +2345,7 @@ static DEFINE_PER_CPU(struct irq_work, wake_up_klogd_work) = {
 void wake_up_klogd(void)
 {
 	preempt_disable();
-	if (waitqueue_active(&log_wait)) {
+	if (waitqueue_active(&log_buf.wait)) {
 		this_cpu_or(printk_pending, PRINTK_PENDING_WAKEUP);
 		irq_work_queue(this_cpu_ptr(&wake_up_klogd_work));
 	}
diff --git a/kernel/printk/printk.h b/kernel/printk/printk.h
index 0416793..38c9278 100644
--- a/kernel/printk/printk.h
+++ b/kernel/printk/printk.h
@@ -93,28 +93,38 @@ struct printk_log {
 	u8 level:3;		/* syslog level */
 };
 
+struct log_buffer {
+#ifdef CONFIG_PRINTK
+	struct list_head list;	/* kmsg as head of the list */
+	char *buf;		/* cyclic log buffer */
+	u32 len;		/* buffer length */
+	wait_queue_head_t wait;	/* wait queue for kmsg buffer */
+#endif
 /*
- * The logbuf_lock protects kmsg buffer, indices, counters.  This can be taken
- * within the scheduler's rq lock. It must be released before calling
- * console_unlock() or anything else that might wake up a process.
+ * The lock protects kmsg buffer, indices, counters. This can be taken within
+ * the scheduler's rq lock. It must be released before calling console_unlock()
+ * or anything else that might wake up a process.
  */
-extern raw_spinlock_t logbuf_lock;
+	raw_spinlock_t lock;
+
+	u64 first_seq;		/* sequence number of the first record stored */
+	u32 first_idx;		/* index of the first record stored */
 
+	u64 next_seq;		/* sequence number of next record to store */
 #ifdef CONFIG_PRINTK
+	u32 next_idx;		/* index of the next record to store */
 
-extern wait_queue_head_t log_wait;
+	/* the next printk record to read after the last 'clear' command */
+	u64 clear_seq;
+	u32 clear_idx;
 
-/* index and sequence number of the first record stored in the buffer */
-extern u64 log_first_seq;
-extern u32 log_first_idx;
+	int minor;		/* minor representing buffer device */
+#endif
+};
 
-/* index and sequence number of the next record to store in the buffer */
-extern u64 log_next_seq;
-extern u32 log_next_idx;
+#ifdef CONFIG_PRINTK
 
-/* the next printk record to read after the last 'clear' command */
-extern u64 clear_seq;
-extern u32 clear_idx;
+extern struct log_buffer log_buf;
 
 ssize_t msg_print_ext_header(char *buf, size_t size,
 				    struct printk_log *msg, u64 seq,
@@ -128,10 +138,9 @@ size_t msg_print_text(const struct printk_log *msg, enum log_flags prev,
 			bool syslog, char *buf, size_t size);
 
 /* get next record; idx must point to valid msg */
-static inline u32 log_next(u32 idx)
+static inline u32 log_next(struct log_buffer *log_b, u32 idx)
 {
-	char *log_buf = log_buf_addr_get();
-	struct printk_log *msg = (struct printk_log *)(log_buf + idx);
+	struct printk_log *msg = (struct printk_log *)(log_b->buf + idx);
 
 	/* length == 0 indicates the end of the buffer; wrap */
 	/*
@@ -140,24 +149,23 @@ static inline u32 log_next(u32 idx)
 	 * return the one after that.
 	 */
 	if (!msg->len) {
-		msg = (struct printk_log *)log_buf;
+		msg = (struct printk_log *)log_b->buf;
 		return msg->len;
 	}
 	return idx + msg->len;
 }
 
 /* get record by index; idx must point to valid msg */
-static inline struct printk_log *log_from_idx(u32 idx)
+static inline struct printk_log *log_from_idx(struct log_buffer *log_b, u32 idx)
 {
-	char *log_buf = log_buf_addr_get();
-	struct printk_log *msg = (struct printk_log *)(log_buf + idx);
+	struct printk_log *msg = (struct printk_log *)(log_b->buf + idx);
 
 	/*
 	 * A length == 0 record is the end of buffer marker. Wrap around and
 	 * read the message at the start of the buffer.
 	 */
 	if (!msg->len)
-		return (struct printk_log *)log_buf;
+		return (struct printk_log *)log_b->buf;
 	return msg;
 }
 
@@ -173,6 +181,11 @@ static inline char *log_dict(const struct printk_log *msg)
 	return (char *)msg + sizeof(struct printk_log) + msg->text_len;
 }
 
+int log_format_and_store(struct log_buffer *log_b,
+			 int facility, int level,
+			 const char *dict, size_t dictlen,
+			 const char *fmt, va_list args);
+
 #else
 
 static inline ssize_t msg_print_ext_header(char *buf, size_t size,
@@ -196,12 +209,12 @@ static inline size_t msg_print_text(const struct printk_log *msg,
 	return 0;
 }
 
-static inline u32 log_next(u32 idx)
+static inline u32 log_next(struct log_buffer *log_b, u32 idx)
 {
 	return 0;
 }
 
-static inline struct printk_log *log_from_idx(u32 idx)
+static inline struct printk_log *log_from_idx(struct log_buffer *log_b, u32 idx)
 {
 	return NULL;
 }
@@ -216,6 +229,14 @@ static inline char *log_dict(const struct printk_log *msg)
 	return NULL;
 }
 
+static inline int log_format_and_store(struct log_buffer *log_b,
+					int facility, int level,
+					const char *dict, size_t dictlen,
+					const char *fmt, va_list args)
+{
+	return 0;
+}
+
 #endif
 
 #endif /* _PRINTK_PRINTK_H */
-- 
1.9.1
