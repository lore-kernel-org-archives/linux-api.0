From: Kazimierz Krosman <k.krosman-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v6 1/8] printk: extract kmsg-related routines from printk.c to
 kmsg.c
Date: Wed, 24 Feb 2016 12:53:14 +0100
Message-ID: <1456314801-32738-2-git-send-email-k.krosman@samsung.com>
References: <1456314801-32738-1-git-send-email-k.krosman@samsung.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <1456314801-32738-1-git-send-email-k.krosman-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, peter-WaGBZJeGNqdsbIuE7sb01tBPR1lH4CV8@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, pmladek-AlSwsSmVLrQ@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org, kay.sievers-tD+1rO4QERM@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: k.lewandowsk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, k.krosman-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, m.niesluchow-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, richard.weinberger-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, b.zolnierkie-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, knhoon.baik-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org
List-Id: linux-api@vger.kernel.org

From: Paul Osmialowski <p.osmialowsk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>

Following suggestions regarding printk.c code bloat, I prepared this
patch which moves kmsg-related routines to new file, kmsg.c

This is premilinary step needed for an attempt to extent kmsg interface
with ability to dynamically create (and destroy) kmsg-like devices.

Signed-off-by: Paul Osmialowski <p.osmialowsk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
[Rebased kmsg patch v5 on Linux 4.5-rc5]
Signed-off-by: Kazimierz Krosman <k.krosman-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
---
 kernel/printk/Makefile |   1 +
 kernel/printk/kmsg.c   | 575 ++++++++++++++++++++++++++++++++++++++
 kernel/printk/printk.c | 743 +------------------------------------------------
 kernel/printk/printk.h | 233 ++++++++++++++++
 4 files changed, 822 insertions(+), 730 deletions(-)
 create mode 100644 kernel/printk/kmsg.c
 create mode 100644 kernel/printk/printk.h

diff --git a/kernel/printk/Makefile b/kernel/printk/Makefile
index 85405bd..bd6a4ec 100644
--- a/kernel/printk/Makefile
+++ b/kernel/printk/Makefile
@@ -1,2 +1,3 @@
 obj-y	= printk.o
+obj-$(CONFIG_PRINTK)			+= kmsg.o
 obj-$(CONFIG_A11Y_BRAILLE_CONSOLE)	+= braille.o
diff --git a/kernel/printk/kmsg.c b/kernel/printk/kmsg.c
new file mode 100644
index 0000000..4ee66f3
--- /dev/null
+++ b/kernel/printk/kmsg.c
@@ -0,0 +1,575 @@
+#include <linux/printk.h>
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/sched.h>
+#include <linux/fcntl.h>
+#include <linux/fs.h>
+#include <linux/kmsg_dump.h>
+#include <linux/moduleparam.h>
+#include <linux/mutex.h>
+#include <linux/spinlock.h>
+#include <linux/slab.h>
+#include <linux/poll.h>
+#include <linux/rculist.h>
+#include <linux/rcupdate.h>
+#include <linux/stat.h>
+#include <linux/syslog.h>
+#include <linux/uio.h>
+#include <linux/wait.h>
+
+#include <asm/uaccess.h>
+
+#include "printk.h"
+
+/* /dev/kmsg - userspace message inject/listen interface */
+struct devkmsg_user {
+	u64 seq;
+	u32 idx;
+	enum log_flags prev;
+	struct mutex lock;
+	char buf[CONSOLE_EXT_LOG_MAX];
+};
+
+static ssize_t devkmsg_write(struct kiocb *iocb, struct iov_iter *from)
+{
+	char *buf, *line;
+	int level = default_message_loglevel;
+	int facility = 1;	/* LOG_USER */
+	size_t len = iov_iter_count(from);
+	ssize_t ret = len;
+
+	if (len > LOG_LINE_MAX)
+		return -EINVAL;
+	buf = kmalloc(len+1, GFP_KERNEL);
+	if (buf == NULL)
+		return -ENOMEM;
+
+	buf[len] = '\0';
+	if (copy_from_iter(buf, len, from) != len) {
+		kfree(buf);
+		return -EFAULT;
+	}
+
+	/*
+	 * Extract and skip the syslog prefix <[0-9]*>. Coming from userspace
+	 * the decimal value represents 32bit, the lower 3 bit are the log
+	 * level, the rest are the log facility.
+	 *
+	 * If no prefix or no userspace facility is specified, we
+	 * enforce LOG_USER, to be able to reliably distinguish
+	 * kernel-generated messages from userspace-injected ones.
+	 */
+	line = buf;
+	if (line[0] == '<') {
+		char *endp = NULL;
+                unsigned int u;
+
+		u = simple_strtoul(line + 1, &endp, 10);
+		if (endp && endp[0] == '>') {
+			level = LOG_LEVEL(u);
+			if (LOG_FACILITY(u) != 0)
+				facility = LOG_FACILITY(u);
+			endp++;
+			len -= endp - line;
+			line = endp;
+		}
+	}
+
+	printk_emit(facility, level, NULL, 0, "%s", line);
+	kfree(buf);
+	return ret;
+}
+
+static ssize_t devkmsg_read(struct file *file, char __user *buf,
+			    size_t count, loff_t *ppos)
+{
+	struct devkmsg_user *user = file->private_data;
+	struct printk_log *msg;
+	size_t len;
+	ssize_t ret;
+
+	if (!user)
+		return -EBADF;
+
+	ret = mutex_lock_interruptible(&user->lock);
+	if (ret)
+		return ret;
+	raw_spin_lock_irq(&logbuf_lock);
+	while (user->seq == log_next_seq) {
+		if (file->f_flags & O_NONBLOCK) {
+			ret = -EAGAIN;
+			raw_spin_unlock_irq(&logbuf_lock);
+			goto out;
+		}
+
+		raw_spin_unlock_irq(&logbuf_lock);
+		ret = wait_event_interruptible(log_wait,
+					       user->seq != log_next_seq);
+		if (ret)
+			goto out;
+		raw_spin_lock_irq(&logbuf_lock);
+	}
+
+	if (user->seq < log_first_seq) {
+		/* our last seen message is gone, return error and reset */
+		user->idx = log_first_idx;
+		user->seq = log_first_seq;
+		ret = -EPIPE;
+		raw_spin_unlock_irq(&logbuf_lock);
+		goto out;
+	}
+
+	msg = log_from_idx(user->idx);
+	len = msg_print_ext_header(user->buf, sizeof(user->buf),
+				   msg, user->seq, user->prev);
+	len += msg_print_ext_body(user->buf + len, sizeof(user->buf) - len,
+				  log_dict(msg), msg->dict_len,
+				  log_text(msg), msg->text_len);
+
+	user->prev = msg->flags;
+	user->idx = log_next(user->idx);
+	user->seq++;
+	raw_spin_unlock_irq(&logbuf_lock);
+
+	if (len > count) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	if (copy_to_user(buf, user->buf, len)) {
+		ret = -EFAULT;
+		goto out;
+	}
+	ret = len;
+out:
+	mutex_unlock(&user->lock);
+	return ret;
+}
+
+static loff_t devkmsg_llseek(struct file *file, loff_t offset, int whence)
+{
+	struct devkmsg_user *user = file->private_data;
+	loff_t ret = 0;
+
+	if (!user)
+		return -EBADF;
+	if (offset)
+		return -ESPIPE;
+
+	raw_spin_lock_irq(&logbuf_lock);
+	switch (whence) {
+	case SEEK_SET:
+		/* the first record */
+		user->idx = log_first_idx;
+		user->seq = log_first_seq;
+		break;
+	case SEEK_DATA:
+		/*
+		 * The first record after the last SYSLOG_ACTION_CLEAR,
+		 * like issued by 'dmesg -c'. Reading /dev/kmsg itself
+		 * changes no global state, and does not clear anything.
+		 */
+		user->idx = clear_idx;
+		user->seq = clear_seq;
+		break;
+	case SEEK_END:
+		/* after the last record */
+		user->idx = log_next_idx;
+		user->seq = log_next_seq;
+		break;
+	default:
+		ret = -EINVAL;
+	}
+	raw_spin_unlock_irq(&logbuf_lock);
+	return ret;
+}
+
+static unsigned int devkmsg_poll(struct file *file, poll_table *wait)
+{
+	struct devkmsg_user *user = file->private_data;
+	int ret = 0;
+
+	if (!user)
+		return POLLERR|POLLNVAL;
+
+	poll_wait(file, &log_wait, wait);
+
+	raw_spin_lock_irq(&logbuf_lock);
+	if (user->seq < log_next_seq) {
+		/* return error when data has vanished underneath us */
+		if (user->seq < log_first_seq)
+			ret = POLLIN|POLLRDNORM|POLLERR|POLLPRI;
+		else
+			ret = POLLIN|POLLRDNORM;
+	}
+	raw_spin_unlock_irq(&logbuf_lock);
+
+	return ret;
+}
+
+static int devkmsg_open(struct inode *inode, struct file *file)
+{
+	struct devkmsg_user *user;
+	int err;
+
+	/* write-only does not need any file context */
+	if ((file->f_flags & O_ACCMODE) == O_WRONLY)
+		return 0;
+
+	err = check_syslog_permissions(SYSLOG_ACTION_READ_ALL,
+				       SYSLOG_FROM_READER);
+	if (err)
+		return err;
+
+	user = kmalloc(sizeof(struct devkmsg_user), GFP_KERNEL);
+	if (!user)
+		return -ENOMEM;
+
+	mutex_init(&user->lock);
+
+	raw_spin_lock_irq(&logbuf_lock);
+	user->idx = log_first_idx;
+	user->seq = log_first_seq;
+	raw_spin_unlock_irq(&logbuf_lock);
+
+	file->private_data = user;
+	return 0;
+}
+
+static int devkmsg_release(struct inode *inode, struct file *file)
+{
+	struct devkmsg_user *user = file->private_data;
+
+	if (!user)
+		return 0;
+
+	mutex_destroy(&user->lock);
+	kfree(user);
+	return 0;
+}
+
+const struct file_operations kmsg_fops = {
+	.open = devkmsg_open,
+	.read = devkmsg_read,
+	.write_iter = devkmsg_write,
+	.llseek = devkmsg_llseek,
+	.poll = devkmsg_poll,
+	.release = devkmsg_release,
+};
+
+static DEFINE_SPINLOCK(dump_list_lock);
+static LIST_HEAD(dump_list);
+
+/**
+ * kmsg_dump_register - register a kernel log dumper.
+ * @dumper: pointer to the kmsg_dumper structure
+ *
+ * Adds a kernel log dumper to the system. The dump callback in the
+ * structure will be called when the kernel oopses or panics and must be
+ * set. Returns zero on success and %-EINVAL or %-EBUSY otherwise.
+ */
+int kmsg_dump_register(struct kmsg_dumper *dumper)
+{
+	unsigned long flags;
+	int err = -EBUSY;
+
+	/* The dump callback needs to be set */
+	if (!dumper->dump)
+		return -EINVAL;
+
+	spin_lock_irqsave(&dump_list_lock, flags);
+	/* Don't allow registering multiple times */
+	if (!dumper->registered) {
+		dumper->registered = 1;
+		list_add_tail_rcu(&dumper->list, &dump_list);
+		err = 0;
+	}
+	spin_unlock_irqrestore(&dump_list_lock, flags);
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(kmsg_dump_register);
+
+/**
+ * kmsg_dump_unregister - unregister a kmsg dumper.
+ * @dumper: pointer to the kmsg_dumper structure
+ *
+ * Removes a dump device from the system. Returns zero on success and
+ * %-EINVAL otherwise.
+ */
+int kmsg_dump_unregister(struct kmsg_dumper *dumper)
+{
+	unsigned long flags;
+	int err = -EINVAL;
+
+	spin_lock_irqsave(&dump_list_lock, flags);
+	if (dumper->registered) {
+		dumper->registered = 0;
+		list_del_rcu(&dumper->list);
+		err = 0;
+	}
+	spin_unlock_irqrestore(&dump_list_lock, flags);
+	synchronize_rcu();
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(kmsg_dump_unregister);
+
+static bool always_kmsg_dump;
+module_param_named(always_kmsg_dump, always_kmsg_dump, bool, S_IRUGO | S_IWUSR);
+
+/**
+ * kmsg_dump - dump kernel log to kernel message dumpers.
+ * @reason: the reason (oops, panic etc) for dumping
+ *
+ * Call each of the registered dumper's dump() callback, which can
+ * retrieve the kmsg records with kmsg_dump_get_line() or
+ * kmsg_dump_get_buffer().
+ */
+void kmsg_dump(enum kmsg_dump_reason reason)
+{
+	struct kmsg_dumper *dumper;
+	unsigned long flags;
+
+	if ((reason > KMSG_DUMP_OOPS) && !always_kmsg_dump)
+		return;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(dumper, &dump_list, list) {
+		if (dumper->max_reason && reason > dumper->max_reason)
+			continue;
+
+		/* initialize iterator with data about the stored records */
+		dumper->active = true;
+
+		raw_spin_lock_irqsave(&logbuf_lock, flags);
+		dumper->cur_seq = clear_seq;
+		dumper->cur_idx = clear_idx;
+		dumper->next_seq = log_next_seq;
+		dumper->next_idx = log_next_idx;
+		raw_spin_unlock_irqrestore(&logbuf_lock, flags);
+
+		/* invoke dumper which will iterate over records */
+		dumper->dump(dumper, reason);
+
+		/* reset iterator */
+		dumper->active = false;
+	}
+	rcu_read_unlock();
+}
+
+/**
+ * kmsg_dump_get_line_nolock - retrieve one kmsg log line (unlocked version)
+ * @dumper: registered kmsg dumper
+ * @syslog: include the "<4>" prefixes
+ * @line: buffer to copy the line to
+ * @size: maximum size of the buffer
+ * @len: length of line placed into buffer
+ *
+ * Start at the beginning of the kmsg buffer, with the oldest kmsg
+ * record, and copy one record into the provided buffer.
+ *
+ * Consecutive calls will return the next available record moving
+ * towards the end of the buffer with the youngest messages.
+ *
+ * A return value of FALSE indicates that there are no more records to
+ * read.
+ *
+ * The function is similar to kmsg_dump_get_line(), but grabs no locks.
+ */
+bool kmsg_dump_get_line_nolock(struct kmsg_dumper *dumper, bool syslog,
+			       char *line, size_t size, size_t *len)
+{
+	struct printk_log *msg;
+	size_t l = 0;
+	bool ret = false;
+
+	if (!dumper->active)
+		goto out;
+
+	if (dumper->cur_seq < log_first_seq) {
+		/* messages are gone, move to first available one */
+		dumper->cur_seq = log_first_seq;
+		dumper->cur_idx = log_first_idx;
+	}
+
+	/* last entry */
+	if (dumper->cur_seq >= log_next_seq)
+		goto out;
+
+	msg = log_from_idx(dumper->cur_idx);
+	l = msg_print_text(msg, 0, syslog, line, size);
+
+	dumper->cur_idx = log_next(dumper->cur_idx);
+	dumper->cur_seq++;
+	ret = true;
+out:
+	if (len)
+		*len = l;
+	return ret;
+}
+
+/**
+ * kmsg_dump_get_line - retrieve one kmsg log line
+ * @dumper: registered kmsg dumper
+ * @syslog: include the "<4>" prefixes
+ * @line: buffer to copy the line to
+ * @size: maximum size of the buffer
+ * @len: length of line placed into buffer
+ *
+ * Start at the beginning of the kmsg buffer, with the oldest kmsg
+ * record, and copy one record into the provided buffer.
+ *
+ * Consecutive calls will return the next available record moving
+ * towards the end of the buffer with the youngest messages.
+ *
+ * A return value of FALSE indicates that there are no more records to
+ * read.
+ */
+bool kmsg_dump_get_line(struct kmsg_dumper *dumper, bool syslog,
+			char *line, size_t size, size_t *len)
+{
+	unsigned long flags;
+	bool ret;
+
+	raw_spin_lock_irqsave(&logbuf_lock, flags);
+	ret = kmsg_dump_get_line_nolock(dumper, syslog, line, size, len);
+	raw_spin_unlock_irqrestore(&logbuf_lock, flags);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(kmsg_dump_get_line);
+
+/**
+ * kmsg_dump_get_buffer - copy kmsg log lines
+ * @dumper: registered kmsg dumper
+ * @syslog: include the "<4>" prefixes
+ * @buf: buffer to copy the line to
+ * @size: maximum size of the buffer
+ * @len: length of line placed into buffer
+ *
+ * Start at the end of the kmsg buffer and fill the provided buffer
+ * with as many of the the *youngest* kmsg records that fit into it.
+ * If the buffer is large enough, all available kmsg records will be
+ * copied with a single call.
+ *
+ * Consecutive calls will fill the buffer with the next block of
+ * available older records, not including the earlier retrieved ones.
+ *
+ * A return value of FALSE indicates that there are no more records to
+ * read.
+ */
+bool kmsg_dump_get_buffer(struct kmsg_dumper *dumper, bool syslog,
+			  char *buf, size_t size, size_t *len)
+{
+	unsigned long flags;
+	u64 seq;
+	u32 idx;
+	u64 next_seq;
+	u32 next_idx;
+	enum log_flags prev;
+	size_t l = 0;
+	bool ret = false;
+
+	if (!dumper->active)
+		goto out;
+
+	raw_spin_lock_irqsave(&logbuf_lock, flags);
+	if (dumper->cur_seq < log_first_seq) {
+		/* messages are gone, move to first available one */
+		dumper->cur_seq = log_first_seq;
+		dumper->cur_idx = log_first_idx;
+	}
+
+	/* last entry */
+	if (dumper->cur_seq >= dumper->next_seq) {
+		raw_spin_unlock_irqrestore(&logbuf_lock, flags);
+		goto out;
+	}
+
+	/* calculate length of entire buffer */
+	seq = dumper->cur_seq;
+	idx = dumper->cur_idx;
+	prev = 0;
+	while (seq < dumper->next_seq) {
+		struct printk_log *msg = log_from_idx(idx);
+
+		l += msg_print_text(msg, prev, true, NULL, 0);
+		idx = log_next(idx);
+		seq++;
+		prev = msg->flags;
+	}
+
+	/* move first record forward until length fits into the buffer */
+	seq = dumper->cur_seq;
+	idx = dumper->cur_idx;
+	prev = 0;
+	while (l > size && seq < dumper->next_seq) {
+		struct printk_log *msg = log_from_idx(idx);
+
+		l -= msg_print_text(msg, prev, true, NULL, 0);
+		idx = log_next(idx);
+		seq++;
+		prev = msg->flags;
+	}
+
+	/* last message in next interation */
+	next_seq = seq;
+	next_idx = idx;
+
+	l = 0;
+	while (seq < dumper->next_seq) {
+		struct printk_log *msg = log_from_idx(idx);
+
+		l += msg_print_text(msg, prev, syslog, buf + l, size - l);
+		idx = log_next(idx);
+		seq++;
+		prev = msg->flags;
+	}
+
+	dumper->next_seq = next_seq;
+	dumper->next_idx = next_idx;
+	ret = true;
+	raw_spin_unlock_irqrestore(&logbuf_lock, flags);
+out:
+	if (len)
+		*len = l;
+	return ret;
+}
+EXPORT_SYMBOL_GPL(kmsg_dump_get_buffer);
+
+/**
+ * kmsg_dump_rewind_nolock - reset the interator (unlocked version)
+ * @dumper: registered kmsg dumper
+ *
+ * Reset the dumper's iterator so that kmsg_dump_get_line() and
+ * kmsg_dump_get_buffer() can be called again and used multiple
+ * times within the same dumper.dump() callback.
+ *
+ * The function is similar to kmsg_dump_rewind(), but grabs no locks.
+ */
+void kmsg_dump_rewind_nolock(struct kmsg_dumper *dumper)
+{
+	dumper->cur_seq = clear_seq;
+	dumper->cur_idx = clear_idx;
+	dumper->next_seq = log_next_seq;
+	dumper->next_idx = log_next_idx;
+}
+
+/**
+ * kmsg_dump_rewind - reset the interator
+ * @dumper: registered kmsg dumper
+ *
+ * Reset the dumper's iterator so that kmsg_dump_get_line() and
+ * kmsg_dump_get_buffer() can be called again and used multiple
+ * times within the same dumper.dump() callback.
+ */
+void kmsg_dump_rewind(struct kmsg_dumper *dumper)
+{
+	unsigned long flags;
+
+	raw_spin_lock_irqsave(&logbuf_lock, flags);
+	kmsg_dump_rewind_nolock(dumper);
+	raw_spin_unlock_irqrestore(&logbuf_lock, flags);
+}
+EXPORT_SYMBOL_GPL(kmsg_dump_rewind);
diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index c963ba5..2787bc7 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -25,7 +25,6 @@
 #include <linux/jiffies.h>
 #include <linux/nmi.h>
 #include <linux/module.h>
-#include <linux/moduleparam.h>
 #include <linux/interrupt.h>			/* For in_interrupt() */
 #include <linux/delay.h>
 #include <linux/smp.h>
@@ -40,12 +39,9 @@
 #include <linux/syslog.h>
 #include <linux/cpu.h>
 #include <linux/notifier.h>
-#include <linux/rculist.h>
-#include <linux/poll.h>
 #include <linux/irq_work.h>
 #include <linux/utsname.h>
 #include <linux/ctype.h>
-#include <linux/uio.h>
 
 #include <asm/uaccess.h>
 #include <asm-generic/sections.h>
@@ -53,6 +49,7 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/printk.h>
 
+#include "printk.h"
 #include "console_cmdline.h"
 #include "braille.h"
 
@@ -151,100 +148,7 @@ EXPORT_SYMBOL(console_set_on_cmdline);
 /* Flag: console code may call schedule() */
 static int console_may_schedule;
 
-/*
- * The printk log buffer consists of a chain of concatenated variable
- * length records. Every record starts with a record header, containing
- * the overall length of the record.
- *
- * The heads to the first and last entry in the buffer, as well as the
- * sequence numbers of these entries are maintained when messages are
- * stored.
- *
- * If the heads indicate available messages, the length in the header
- * tells the start next message. A length == 0 for the next message
- * indicates a wrap-around to the beginning of the buffer.
- *
- * Every record carries the monotonic timestamp in microseconds, as well as
- * the standard userspace syslog level and syslog facility. The usual
- * kernel messages use LOG_KERN; userspace-injected messages always carry
- * a matching syslog facility, by default LOG_USER. The origin of every
- * message can be reliably determined that way.
- *
- * The human readable log message directly follows the message header. The
- * length of the message text is stored in the header, the stored message
- * is not terminated.
- *
- * Optionally, a message can carry a dictionary of properties (key/value pairs),
- * to provide userspace with a machine-readable message context.
- *
- * Examples for well-defined, commonly used property names are:
- *   DEVICE=b12:8               device identifier
- *                                b12:8         block dev_t
- *                                c127:3        char dev_t
- *                                n8            netdev ifindex
- *                                +sound:card0  subsystem:devname
- *   SUBSYSTEM=pci              driver-core subsystem name
- *
- * Valid characters in property names are [a-zA-Z0-9.-_]. The plain text value
- * follows directly after a '=' character. Every property is terminated by
- * a '\0' character. The last property is not terminated.
- *
- * Example of a message structure:
- *   0000  ff 8f 00 00 00 00 00 00      monotonic time in nsec
- *   0008  34 00                        record is 52 bytes long
- *   000a        0b 00                  text is 11 bytes long
- *   000c              1f 00            dictionary is 23 bytes long
- *   000e                    03 00      LOG_KERN (facility) LOG_ERR (level)
- *   0010  69 74 27 73 20 61 20 6c      "it's a l"
- *         69 6e 65                     "ine"
- *   001b           44 45 56 49 43      "DEVIC"
- *         45 3d 62 38 3a 32 00 44      "E=b8:2\0D"
- *         52 49 56 45 52 3d 62 75      "RIVER=bu"
- *         67                           "g"
- *   0032     00 00 00                  padding to next message header
- *
- * The 'struct printk_log' buffer header must never be directly exported to
- * userspace, it is a kernel-private implementation detail that might
- * need to be changed in the future, when the requirements change.
- *
- * /dev/kmsg exports the structured data in the following line format:
- *   "<level>,<sequnum>,<timestamp>,<contflag>[,additional_values, ... ];<message text>\n"
- *
- * Users of the export format should ignore possible additional values
- * separated by ',', and find the message after the ';' character.
- *
- * The optional key/value pairs are attached as continuation lines starting
- * with a space character and terminated by a newline. All possible
- * non-prinatable characters are escaped in the "\xff" notation.
- */
-
-enum log_flags {
-	LOG_NOCONS	= 1,	/* already flushed, do not print to console */
-	LOG_NEWLINE	= 2,	/* text ended with a newline */
-	LOG_PREFIX	= 4,	/* text started with a prefix */
-	LOG_CONT	= 8,	/* text is a fragment of a continuation line */
-};
-
-struct printk_log {
-	u64 ts_nsec;		/* timestamp in nanoseconds */
-	u16 len;		/* length of entire record */
-	u16 text_len;		/* length of text buffer */
-	u16 dict_len;		/* length of dictionary buffer */
-	u8 facility;		/* syslog facility */
-	u8 flags:5;		/* internal record flags */
-	u8 level:3;		/* syslog level */
-}
-#ifdef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
-__packed __aligned(4)
-#endif
-;
-
-/*
- * The logbuf_lock protects kmsg buffer, indices, counters.  This can be taken
- * within the scheduler's rq lock. It must be released before calling
- * console_unlock() or anything else that might wake up a process.
- */
-static DEFINE_RAW_SPINLOCK(logbuf_lock);
+DEFINE_RAW_SPINLOCK(logbuf_lock);
 
 #ifdef CONFIG_PRINTK
 DECLARE_WAIT_QUEUE_HEAD(log_wait);
@@ -254,28 +158,19 @@ static u32 syslog_idx;
 static enum log_flags syslog_prev;
 static size_t syslog_partial;
 
-/* index and sequence number of the first record stored in the buffer */
-static u64 log_first_seq;
-static u32 log_first_idx;
-
-/* index and sequence number of the next record to store in the buffer */
-static u64 log_next_seq;
-static u32 log_next_idx;
-
 /* the next printk record to write to the console */
 static u64 console_seq;
 static u32 console_idx;
 static enum log_flags console_prev;
 
-/* the next printk record to read after the last 'clear' command */
-static u64 clear_seq;
-static u32 clear_idx;
+u64 log_first_seq;
+u32 log_first_idx;
 
-#define PREFIX_MAX		32
-#define LOG_LINE_MAX		(1024 - PREFIX_MAX)
+u64 log_next_seq;
+u32 log_next_idx;
 
-#define LOG_LEVEL(v)		((v) & 0x07)
-#define LOG_FACILITY(v)		((v) >> 3 & 0xff)
+u64 clear_seq;
+u32 clear_idx;
 
 /* record buffer */
 #define LOG_ALIGN __alignof__(struct printk_log)
@@ -296,50 +191,6 @@ u32 log_buf_len_get(void)
 	return log_buf_len;
 }
 
-/* human readable text of the record */
-static char *log_text(const struct printk_log *msg)
-{
-	return (char *)msg + sizeof(struct printk_log);
-}
-
-/* optional key/value pair dictionary attached to the record */
-static char *log_dict(const struct printk_log *msg)
-{
-	return (char *)msg + sizeof(struct printk_log) + msg->text_len;
-}
-
-/* get record by index; idx must point to valid msg */
-static struct printk_log *log_from_idx(u32 idx)
-{
-	struct printk_log *msg = (struct printk_log *)(log_buf + idx);
-
-	/*
-	 * A length == 0 record is the end of buffer marker. Wrap around and
-	 * read the message at the start of the buffer.
-	 */
-	if (!msg->len)
-		return (struct printk_log *)log_buf;
-	return msg;
-}
-
-/* get next record; idx must point to valid msg */
-static u32 log_next(u32 idx)
-{
-	struct printk_log *msg = (struct printk_log *)(log_buf + idx);
-
-	/* length == 0 indicates the end of the buffer; wrap */
-	/*
-	 * A length == 0 record is the end of buffer marker. Wrap around and
-	 * read the message at the start of the buffer as *this* one, and
-	 * return the one after that.
-	 */
-	if (!msg->len) {
-		msg = (struct printk_log *)log_buf;
-		return msg->len;
-	}
-	return idx + msg->len;
-}
-
 /*
  * Check whether there is enough free space for the given message.
  *
@@ -529,8 +380,8 @@ static void append_char(char **pp, char *e, char c)
 		*(*pp)++ = c;
 }
 
-static ssize_t msg_print_ext_header(char *buf, size_t size,
-				    struct printk_log *msg, u64 seq,
+ssize_t msg_print_ext_header(char *buf, size_t size,
+			    struct printk_log *msg, u64 seq,
 				    enum log_flags prev_flags)
 {
 	u64 ts_usec = msg->ts_nsec;
@@ -556,7 +407,7 @@ static ssize_t msg_print_ext_header(char *buf, size_t size,
 		       (msg->facility << 3) | msg->level, seq, ts_usec, cont);
 }
 
-static ssize_t msg_print_ext_body(char *buf, size_t size,
+ssize_t msg_print_ext_body(char *buf, size_t size,
 				  char *dict, size_t dict_len,
 				  char *text, size_t text_len)
 {
@@ -604,242 +455,6 @@ static ssize_t msg_print_ext_body(char *buf, size_t size,
 	return p - buf;
 }
 
-/* /dev/kmsg - userspace message inject/listen interface */
-struct devkmsg_user {
-	u64 seq;
-	u32 idx;
-	enum log_flags prev;
-	struct mutex lock;
-	char buf[CONSOLE_EXT_LOG_MAX];
-};
-
-static ssize_t devkmsg_write(struct kiocb *iocb, struct iov_iter *from)
-{
-	char *buf, *line;
-	int level = default_message_loglevel;
-	int facility = 1;	/* LOG_USER */
-	size_t len = iov_iter_count(from);
-	ssize_t ret = len;
-
-	if (len > LOG_LINE_MAX)
-		return -EINVAL;
-	buf = kmalloc(len+1, GFP_KERNEL);
-	if (buf == NULL)
-		return -ENOMEM;
-
-	buf[len] = '\0';
-	if (copy_from_iter(buf, len, from) != len) {
-		kfree(buf);
-		return -EFAULT;
-	}
-
-	/*
-	 * Extract and skip the syslog prefix <[0-9]*>. Coming from userspace
-	 * the decimal value represents 32bit, the lower 3 bit are the log
-	 * level, the rest are the log facility.
-	 *
-	 * If no prefix or no userspace facility is specified, we
-	 * enforce LOG_USER, to be able to reliably distinguish
-	 * kernel-generated messages from userspace-injected ones.
-	 */
-	line = buf;
-	if (line[0] == '<') {
-		char *endp = NULL;
-		unsigned int u;
-
-		u = simple_strtoul(line + 1, &endp, 10);
-		if (endp && endp[0] == '>') {
-			level = LOG_LEVEL(u);
-			if (LOG_FACILITY(u) != 0)
-				facility = LOG_FACILITY(u);
-			endp++;
-			len -= endp - line;
-			line = endp;
-		}
-	}
-
-	printk_emit(facility, level, NULL, 0, "%s", line);
-	kfree(buf);
-	return ret;
-}
-
-static ssize_t devkmsg_read(struct file *file, char __user *buf,
-			    size_t count, loff_t *ppos)
-{
-	struct devkmsg_user *user = file->private_data;
-	struct printk_log *msg;
-	size_t len;
-	ssize_t ret;
-
-	if (!user)
-		return -EBADF;
-
-	ret = mutex_lock_interruptible(&user->lock);
-	if (ret)
-		return ret;
-	raw_spin_lock_irq(&logbuf_lock);
-	while (user->seq == log_next_seq) {
-		if (file->f_flags & O_NONBLOCK) {
-			ret = -EAGAIN;
-			raw_spin_unlock_irq(&logbuf_lock);
-			goto out;
-		}
-
-		raw_spin_unlock_irq(&logbuf_lock);
-		ret = wait_event_interruptible(log_wait,
-					       user->seq != log_next_seq);
-		if (ret)
-			goto out;
-		raw_spin_lock_irq(&logbuf_lock);
-	}
-
-	if (user->seq < log_first_seq) {
-		/* our last seen message is gone, return error and reset */
-		user->idx = log_first_idx;
-		user->seq = log_first_seq;
-		ret = -EPIPE;
-		raw_spin_unlock_irq(&logbuf_lock);
-		goto out;
-	}
-
-	msg = log_from_idx(user->idx);
-	len = msg_print_ext_header(user->buf, sizeof(user->buf),
-				   msg, user->seq, user->prev);
-	len += msg_print_ext_body(user->buf + len, sizeof(user->buf) - len,
-				  log_dict(msg), msg->dict_len,
-				  log_text(msg), msg->text_len);
-
-	user->prev = msg->flags;
-	user->idx = log_next(user->idx);
-	user->seq++;
-	raw_spin_unlock_irq(&logbuf_lock);
-
-	if (len > count) {
-		ret = -EINVAL;
-		goto out;
-	}
-
-	if (copy_to_user(buf, user->buf, len)) {
-		ret = -EFAULT;
-		goto out;
-	}
-	ret = len;
-out:
-	mutex_unlock(&user->lock);
-	return ret;
-}
-
-static loff_t devkmsg_llseek(struct file *file, loff_t offset, int whence)
-{
-	struct devkmsg_user *user = file->private_data;
-	loff_t ret = 0;
-
-	if (!user)
-		return -EBADF;
-	if (offset)
-		return -ESPIPE;
-
-	raw_spin_lock_irq(&logbuf_lock);
-	switch (whence) {
-	case SEEK_SET:
-		/* the first record */
-		user->idx = log_first_idx;
-		user->seq = log_first_seq;
-		break;
-	case SEEK_DATA:
-		/*
-		 * The first record after the last SYSLOG_ACTION_CLEAR,
-		 * like issued by 'dmesg -c'. Reading /dev/kmsg itself
-		 * changes no global state, and does not clear anything.
-		 */
-		user->idx = clear_idx;
-		user->seq = clear_seq;
-		break;
-	case SEEK_END:
-		/* after the last record */
-		user->idx = log_next_idx;
-		user->seq = log_next_seq;
-		break;
-	default:
-		ret = -EINVAL;
-	}
-	raw_spin_unlock_irq(&logbuf_lock);
-	return ret;
-}
-
-static unsigned int devkmsg_poll(struct file *file, poll_table *wait)
-{
-	struct devkmsg_user *user = file->private_data;
-	int ret = 0;
-
-	if (!user)
-		return POLLERR|POLLNVAL;
-
-	poll_wait(file, &log_wait, wait);
-
-	raw_spin_lock_irq(&logbuf_lock);
-	if (user->seq < log_next_seq) {
-		/* return error when data has vanished underneath us */
-		if (user->seq < log_first_seq)
-			ret = POLLIN|POLLRDNORM|POLLERR|POLLPRI;
-		else
-			ret = POLLIN|POLLRDNORM;
-	}
-	raw_spin_unlock_irq(&logbuf_lock);
-
-	return ret;
-}
-
-static int devkmsg_open(struct inode *inode, struct file *file)
-{
-	struct devkmsg_user *user;
-	int err;
-
-	/* write-only does not need any file context */
-	if ((file->f_flags & O_ACCMODE) == O_WRONLY)
-		return 0;
-
-	err = check_syslog_permissions(SYSLOG_ACTION_READ_ALL,
-				       SYSLOG_FROM_READER);
-	if (err)
-		return err;
-
-	user = kmalloc(sizeof(struct devkmsg_user), GFP_KERNEL);
-	if (!user)
-		return -ENOMEM;
-
-	mutex_init(&user->lock);
-
-	raw_spin_lock_irq(&logbuf_lock);
-	user->idx = log_first_idx;
-	user->seq = log_first_seq;
-	raw_spin_unlock_irq(&logbuf_lock);
-
-	file->private_data = user;
-	return 0;
-}
-
-static int devkmsg_release(struct inode *inode, struct file *file)
-{
-	struct devkmsg_user *user = file->private_data;
-
-	if (!user)
-		return 0;
-
-	mutex_destroy(&user->lock);
-	kfree(user);
-	return 0;
-}
-
-const struct file_operations kmsg_fops = {
-	.open = devkmsg_open,
-	.read = devkmsg_read,
-	.write_iter = devkmsg_write,
-	.llseek = devkmsg_llseek,
-	.poll = devkmsg_poll,
-	.release = devkmsg_release,
-};
-
 #ifdef CONFIG_KEXEC_CORE
 /*
  * This appends the listed symbols to /proc/vmcore
@@ -1077,8 +692,8 @@ static size_t print_prefix(const struct printk_log *msg, bool syslog, char *buf)
 	return len;
 }
 
-static size_t msg_print_text(const struct printk_log *msg, enum log_flags prev,
-			     bool syslog, char *buf, size_t size)
+size_t msg_print_text(const struct printk_log *msg, enum log_flags prev,
+		      bool syslog, char *buf, size_t size)
 {
 	const char *text = log_text(msg);
 	size_t text_size = msg->text_len;
@@ -1922,9 +1537,6 @@ EXPORT_SYMBOL(printk);
 
 #else /* CONFIG_PRINTK */
 
-#define LOG_LINE_MAX		0
-#define PREFIX_MAX		0
-
 static u64 syslog_seq;
 static u32 syslog_idx;
 static u64 console_seq;
@@ -1940,21 +1552,9 @@ static struct cont {
 	u8 level;
 	bool flushed:1;
 } cont;
-static char *log_text(const struct printk_log *msg) { return NULL; }
-static char *log_dict(const struct printk_log *msg) { return NULL; }
-static struct printk_log *log_from_idx(u32 idx) { return NULL; }
-static u32 log_next(u32 idx) { return 0; }
-static ssize_t msg_print_ext_header(char *buf, size_t size,
-				    struct printk_log *msg, u64 seq,
-				    enum log_flags prev_flags) { return 0; }
-static ssize_t msg_print_ext_body(char *buf, size_t size,
-				  char *dict, size_t dict_len,
-				  char *text, size_t text_len) { return 0; }
 static void call_console_drivers(int level,
 				 const char *ext_text, size_t ext_len,
 				 const char *text, size_t len) {}
-static size_t msg_print_text(const struct printk_log *msg, enum log_flags prev,
-			     bool syslog, char *buf, size_t size) { return 0; }
 static size_t cont_print_text(char *text, size_t size) { return 0; }
 
 /* Still needs to be defined for users */
@@ -2820,323 +2420,6 @@ bool printk_timed_ratelimit(unsigned long *caller_jiffies,
 }
 EXPORT_SYMBOL(printk_timed_ratelimit);
 
-static DEFINE_SPINLOCK(dump_list_lock);
-static LIST_HEAD(dump_list);
-
-/**
- * kmsg_dump_register - register a kernel log dumper.
- * @dumper: pointer to the kmsg_dumper structure
- *
- * Adds a kernel log dumper to the system. The dump callback in the
- * structure will be called when the kernel oopses or panics and must be
- * set. Returns zero on success and %-EINVAL or %-EBUSY otherwise.
- */
-int kmsg_dump_register(struct kmsg_dumper *dumper)
-{
-	unsigned long flags;
-	int err = -EBUSY;
-
-	/* The dump callback needs to be set */
-	if (!dumper->dump)
-		return -EINVAL;
-
-	spin_lock_irqsave(&dump_list_lock, flags);
-	/* Don't allow registering multiple times */
-	if (!dumper->registered) {
-		dumper->registered = 1;
-		list_add_tail_rcu(&dumper->list, &dump_list);
-		err = 0;
-	}
-	spin_unlock_irqrestore(&dump_list_lock, flags);
-
-	return err;
-}
-EXPORT_SYMBOL_GPL(kmsg_dump_register);
-
-/**
- * kmsg_dump_unregister - unregister a kmsg dumper.
- * @dumper: pointer to the kmsg_dumper structure
- *
- * Removes a dump device from the system. Returns zero on success and
- * %-EINVAL otherwise.
- */
-int kmsg_dump_unregister(struct kmsg_dumper *dumper)
-{
-	unsigned long flags;
-	int err = -EINVAL;
-
-	spin_lock_irqsave(&dump_list_lock, flags);
-	if (dumper->registered) {
-		dumper->registered = 0;
-		list_del_rcu(&dumper->list);
-		err = 0;
-	}
-	spin_unlock_irqrestore(&dump_list_lock, flags);
-	synchronize_rcu();
-
-	return err;
-}
-EXPORT_SYMBOL_GPL(kmsg_dump_unregister);
-
-static bool always_kmsg_dump;
-module_param_named(always_kmsg_dump, always_kmsg_dump, bool, S_IRUGO | S_IWUSR);
-
-/**
- * kmsg_dump - dump kernel log to kernel message dumpers.
- * @reason: the reason (oops, panic etc) for dumping
- *
- * Call each of the registered dumper's dump() callback, which can
- * retrieve the kmsg records with kmsg_dump_get_line() or
- * kmsg_dump_get_buffer().
- */
-void kmsg_dump(enum kmsg_dump_reason reason)
-{
-	struct kmsg_dumper *dumper;
-	unsigned long flags;
-
-	if ((reason > KMSG_DUMP_OOPS) && !always_kmsg_dump)
-		return;
-
-	rcu_read_lock();
-	list_for_each_entry_rcu(dumper, &dump_list, list) {
-		if (dumper->max_reason && reason > dumper->max_reason)
-			continue;
-
-		/* initialize iterator with data about the stored records */
-		dumper->active = true;
-
-		raw_spin_lock_irqsave(&logbuf_lock, flags);
-		dumper->cur_seq = clear_seq;
-		dumper->cur_idx = clear_idx;
-		dumper->next_seq = log_next_seq;
-		dumper->next_idx = log_next_idx;
-		raw_spin_unlock_irqrestore(&logbuf_lock, flags);
-
-		/* invoke dumper which will iterate over records */
-		dumper->dump(dumper, reason);
-
-		/* reset iterator */
-		dumper->active = false;
-	}
-	rcu_read_unlock();
-}
-
-/**
- * kmsg_dump_get_line_nolock - retrieve one kmsg log line (unlocked version)
- * @dumper: registered kmsg dumper
- * @syslog: include the "<4>" prefixes
- * @line: buffer to copy the line to
- * @size: maximum size of the buffer
- * @len: length of line placed into buffer
- *
- * Start at the beginning of the kmsg buffer, with the oldest kmsg
- * record, and copy one record into the provided buffer.
- *
- * Consecutive calls will return the next available record moving
- * towards the end of the buffer with the youngest messages.
- *
- * A return value of FALSE indicates that there are no more records to
- * read.
- *
- * The function is similar to kmsg_dump_get_line(), but grabs no locks.
- */
-bool kmsg_dump_get_line_nolock(struct kmsg_dumper *dumper, bool syslog,
-			       char *line, size_t size, size_t *len)
-{
-	struct printk_log *msg;
-	size_t l = 0;
-	bool ret = false;
-
-	if (!dumper->active)
-		goto out;
-
-	if (dumper->cur_seq < log_first_seq) {
-		/* messages are gone, move to first available one */
-		dumper->cur_seq = log_first_seq;
-		dumper->cur_idx = log_first_idx;
-	}
-
-	/* last entry */
-	if (dumper->cur_seq >= log_next_seq)
-		goto out;
-
-	msg = log_from_idx(dumper->cur_idx);
-	l = msg_print_text(msg, 0, syslog, line, size);
-
-	dumper->cur_idx = log_next(dumper->cur_idx);
-	dumper->cur_seq++;
-	ret = true;
-out:
-	if (len)
-		*len = l;
-	return ret;
-}
-
-/**
- * kmsg_dump_get_line - retrieve one kmsg log line
- * @dumper: registered kmsg dumper
- * @syslog: include the "<4>" prefixes
- * @line: buffer to copy the line to
- * @size: maximum size of the buffer
- * @len: length of line placed into buffer
- *
- * Start at the beginning of the kmsg buffer, with the oldest kmsg
- * record, and copy one record into the provided buffer.
- *
- * Consecutive calls will return the next available record moving
- * towards the end of the buffer with the youngest messages.
- *
- * A return value of FALSE indicates that there are no more records to
- * read.
- */
-bool kmsg_dump_get_line(struct kmsg_dumper *dumper, bool syslog,
-			char *line, size_t size, size_t *len)
-{
-	unsigned long flags;
-	bool ret;
-
-	raw_spin_lock_irqsave(&logbuf_lock, flags);
-	ret = kmsg_dump_get_line_nolock(dumper, syslog, line, size, len);
-	raw_spin_unlock_irqrestore(&logbuf_lock, flags);
-
-	return ret;
-}
-EXPORT_SYMBOL_GPL(kmsg_dump_get_line);
-
-/**
- * kmsg_dump_get_buffer - copy kmsg log lines
- * @dumper: registered kmsg dumper
- * @syslog: include the "<4>" prefixes
- * @buf: buffer to copy the line to
- * @size: maximum size of the buffer
- * @len: length of line placed into buffer
- *
- * Start at the end of the kmsg buffer and fill the provided buffer
- * with as many of the the *youngest* kmsg records that fit into it.
- * If the buffer is large enough, all available kmsg records will be
- * copied with a single call.
- *
- * Consecutive calls will fill the buffer with the next block of
- * available older records, not including the earlier retrieved ones.
- *
- * A return value of FALSE indicates that there are no more records to
- * read.
- */
-bool kmsg_dump_get_buffer(struct kmsg_dumper *dumper, bool syslog,
-			  char *buf, size_t size, size_t *len)
-{
-	unsigned long flags;
-	u64 seq;
-	u32 idx;
-	u64 next_seq;
-	u32 next_idx;
-	enum log_flags prev;
-	size_t l = 0;
-	bool ret = false;
-
-	if (!dumper->active)
-		goto out;
-
-	raw_spin_lock_irqsave(&logbuf_lock, flags);
-	if (dumper->cur_seq < log_first_seq) {
-		/* messages are gone, move to first available one */
-		dumper->cur_seq = log_first_seq;
-		dumper->cur_idx = log_first_idx;
-	}
-
-	/* last entry */
-	if (dumper->cur_seq >= dumper->next_seq) {
-		raw_spin_unlock_irqrestore(&logbuf_lock, flags);
-		goto out;
-	}
-
-	/* calculate length of entire buffer */
-	seq = dumper->cur_seq;
-	idx = dumper->cur_idx;
-	prev = 0;
-	while (seq < dumper->next_seq) {
-		struct printk_log *msg = log_from_idx(idx);
-
-		l += msg_print_text(msg, prev, true, NULL, 0);
-		idx = log_next(idx);
-		seq++;
-		prev = msg->flags;
-	}
-
-	/* move first record forward until length fits into the buffer */
-	seq = dumper->cur_seq;
-	idx = dumper->cur_idx;
-	prev = 0;
-	while (l > size && seq < dumper->next_seq) {
-		struct printk_log *msg = log_from_idx(idx);
-
-		l -= msg_print_text(msg, prev, true, NULL, 0);
-		idx = log_next(idx);
-		seq++;
-		prev = msg->flags;
-	}
-
-	/* last message in next interation */
-	next_seq = seq;
-	next_idx = idx;
-
-	l = 0;
-	while (seq < dumper->next_seq) {
-		struct printk_log *msg = log_from_idx(idx);
-
-		l += msg_print_text(msg, prev, syslog, buf + l, size - l);
-		idx = log_next(idx);
-		seq++;
-		prev = msg->flags;
-	}
-
-	dumper->next_seq = next_seq;
-	dumper->next_idx = next_idx;
-	ret = true;
-	raw_spin_unlock_irqrestore(&logbuf_lock, flags);
-out:
-	if (len)
-		*len = l;
-	return ret;
-}
-EXPORT_SYMBOL_GPL(kmsg_dump_get_buffer);
-
-/**
- * kmsg_dump_rewind_nolock - reset the interator (unlocked version)
- * @dumper: registered kmsg dumper
- *
- * Reset the dumper's iterator so that kmsg_dump_get_line() and
- * kmsg_dump_get_buffer() can be called again and used multiple
- * times within the same dumper.dump() callback.
- *
- * The function is similar to kmsg_dump_rewind(), but grabs no locks.
- */
-void kmsg_dump_rewind_nolock(struct kmsg_dumper *dumper)
-{
-	dumper->cur_seq = clear_seq;
-	dumper->cur_idx = clear_idx;
-	dumper->next_seq = log_next_seq;
-	dumper->next_idx = log_next_idx;
-}
-
-/**
- * kmsg_dump_rewind - reset the interator
- * @dumper: registered kmsg dumper
- *
- * Reset the dumper's iterator so that kmsg_dump_get_line() and
- * kmsg_dump_get_buffer() can be called again and used multiple
- * times within the same dumper.dump() callback.
- */
-void kmsg_dump_rewind(struct kmsg_dumper *dumper)
-{
-	unsigned long flags;
-
-	raw_spin_lock_irqsave(&logbuf_lock, flags);
-	kmsg_dump_rewind_nolock(dumper);
-	raw_spin_unlock_irqrestore(&logbuf_lock, flags);
-}
-EXPORT_SYMBOL_GPL(kmsg_dump_rewind);
-
 static char dump_stack_arch_desc_str[128];
 
 /**
diff --git a/kernel/printk/printk.h b/kernel/printk/printk.h
new file mode 100644
index 0000000..7bc12e7
--- /dev/null
+++ b/kernel/printk/printk.h
@@ -0,0 +1,233 @@
+#ifndef _PRINTK_PRINTK_H
+#define _PRINTK_PRINTK_H
+
+#include <linux/printk.h>
+#include <linux/spinlock_types.h>
+#include <linux/types.h>
+#include <linux/wait.h>
+
+#ifdef CONFIG_PRINTK
+
+#define PREFIX_MAX		32
+#define LOG_LINE_MAX		(1024 - PREFIX_MAX)
+
+#define LOG_LEVEL(v)		((v) & 0x07)
+#define LOG_FACILITY(v)		((v) >> 3 & 0xff)
+
+#else
+
+#define LOG_LINE_MAX		0
+#define PREFIX_MAX		0
+
+#endif
+
+/*
+ * The printk log buffer consists of a chain of concatenated variable
+ * length records. Every record starts with a record header, containing
+ * the overall length of the record.
+ *
+ * The heads to the first and last entry in the buffer, as well as the
+ * sequence numbers of these entries are maintained when messages are
+ * stored.
+ *
+ * If the heads indicate available messages, the length in the header
+ * tells the start next message. A length == 0 for the next message
+ * indicates a wrap-around to the beginning of the buffer.
+ *
+ * Every record carries the monotonic timestamp in microseconds, as well as
+ * the standard userspace syslog level and syslog facility. The usual
+ * kernel messages use LOG_KERN; userspace-injected messages always carry
+ * a matching syslog facility, by default LOG_USER. The origin of every
+ * message can be reliably determined that way.
+ *
+ * The human readable log message directly follows the message header. The
+ * length of the message text is stored in the header, the stored message
+ * is not terminated.
+ *
+ * Optionally, a message can carry a dictionary of properties (key/value pairs),
+ * to provide userspace with a machine-readable message context.
+ *
+ * Examples for well-defined, commonly used property names are:
+ *   DEVICE=b12:8               device identifier
+ *                                b12:8         block dev_t
+ *                                c127:3        char dev_t
+ *                                n8            netdev ifindex
+ *                                +sound:card0  subsystem:devname
+ *   SUBSYSTEM=pci              driver-core subsystem name
+ *
+ * Valid characters in property names are [a-zA-Z0-9.-_]. The plain text value
+ * follows directly after a '=' character. Every property is terminated by
+ * a '\0' character. The last property is not terminated.
+ *
+ * Example of a message structure:
+ *   0000  ff 8f 00 00 00 00 00 00      monotonic time in nsec
+ *   0008  34 00                        record is 52 bytes long
+ *   000a        0b 00                  text is 11 bytes long
+ *   000c              1f 00            dictionary is 23 bytes long
+ *   000e                    03 00      LOG_KERN (facility) LOG_ERR (level)
+ *   0010  69 74 27 73 20 61 20 6c      "it's a l"
+ *         69 6e 65                     "ine"
+ *   001b           44 45 56 49 43      "DEVIC"
+ *         45 3d 62 38 3a 32 00 44      "E=b8:2\0D"
+ *         52 49 56 45 52 3d 62 75      "RIVER=bu"
+ *         67                           "g"
+ *   0032     00 00 00                  padding to next message header
+ *
+ * The 'struct printk_log' buffer header must never be directly exported to
+ * userspace, it is a kernel-private implementation detail that might
+ * need to be changed in the future, when the requirements change.
+ *
+ * /dev/kmsg exports the structured data in the following line format:
+ *   "<level>,<sequnum>,<tstamp>,<contflag>[,additional_vals, ... ];<msg txt>\n"
+ *
+ * Users of the export format should ignore possible additional values
+ * separated by ',', and find the message after the ';' character.
+ *
+ * The optional key/value pairs are attached as continuation lines starting
+ * with a space character and terminated by a newline. All possible
+ * non-prinatable characters are escaped in the "\xff" notation.
+ */
+
+enum log_flags {
+	LOG_NOCONS	= 1,	/* already flushed, do not print to console */
+	LOG_NEWLINE	= 2,	/* text ended with a newline */
+	LOG_PREFIX	= 4,	/* text started with a prefix */
+	LOG_CONT	= 8,	/* text is a fragment of a continuation line */
+};
+
+struct printk_log {
+	u64 ts_nsec;		/* timestamp in nanoseconds */
+	u16 len;		/* length of entire record */
+	u16 text_len;		/* length of text buffer */
+	u16 dict_len;		/* length of dictionary buffer */
+	u8 facility;		/* syslog facility */
+	u8 flags:5;		/* internal record flags */
+	u8 level:3;		/* syslog level */
+};
+
+/*
+ * The logbuf_lock protects kmsg buffer, indices, counters.  This can be taken
+ * within the scheduler's rq lock. It must be released before calling
+ * console_unlock() or anything else that might wake up a process.
+ */
+extern raw_spinlock_t logbuf_lock;
+
+#ifdef CONFIG_PRINTK
+
+extern wait_queue_head_t log_wait;
+
+/* index and sequence number of the first record stored in the buffer */
+extern u64 log_first_seq;
+extern u32 log_first_idx;
+
+/* index and sequence number of the next record to store in the buffer */
+extern u64 log_next_seq;
+extern u32 log_next_idx;
+
+/* the next printk record to read after the last 'clear' command */
+extern u64 clear_seq;
+extern u32 clear_idx;
+
+ssize_t msg_print_ext_header(char *buf, size_t size,
+				    struct printk_log *msg, u64 seq,
+				    enum log_flags prev_flags);
+
+ssize_t msg_print_ext_body(char *buf, size_t size,
+				  char *dict, size_t dict_len,
+				  char *text, size_t text_len);
+
+size_t msg_print_text(const struct printk_log *msg, enum log_flags prev,
+			bool syslog, char *buf, size_t size);
+
+/* get next record; idx must point to valid msg */
+static inline u32 log_next(u32 idx)
+{
+	char *log_buf = log_buf_addr_get();
+	struct printk_log *msg = (struct printk_log *)(log_buf + idx);
+
+	/* length == 0 indicates the end of the buffer; wrap */
+	/*
+	 * A length == 0 record is the end of buffer marker. Wrap around and
+	 * read the message at the start of the buffer as *this* one, and
+	 * return the one after that.
+	 */
+	if (!msg->len) {
+		msg = (struct printk_log *)log_buf;
+		return msg->len;
+	}
+	return idx + msg->len;
+}
+
+/* get record by index; idx must point to valid msg */
+static inline struct printk_log *log_from_idx(u32 idx)
+{
+	char *log_buf = log_buf_addr_get();
+	struct printk_log *msg = (struct printk_log *)(log_buf + idx);
+
+	/*
+	 * A length == 0 record is the end of buffer marker. Wrap around and
+	 * read the message at the start of the buffer.
+	 */
+	if (!msg->len)
+		return (struct printk_log *)log_buf;
+	return msg;
+}
+
+/* human readable text of the record */
+static inline char *log_text(const struct printk_log *msg)
+{
+	return (char *)msg + sizeof(struct printk_log);
+}
+
+/* optional key/value pair dictionary attached to the record */
+static inline char *log_dict(const struct printk_log *msg)
+{
+	return (char *)msg + sizeof(struct printk_log) + msg->text_len;
+}
+
+#else
+
+static inline ssize_t msg_print_ext_header(char *buf, size_t size,
+					    struct printk_log *msg, u64 seq,
+					    enum log_flags prev_flags)
+{
+	return 0;
+}
+
+static inline ssize_t msg_print_ext_body(char *buf, size_t size,
+					  char *dict, size_t dict_len,
+					  char *text, size_t text_len)
+{
+	return 0;
+}
+
+static inline size_t msg_print_text(const struct printk_log *msg,
+				    enum log_flags prev, bool syslog, char *buf,
+				    size_t size)
+{
+	return 0;
+}
+
+static inline u32 log_next(u32 idx)
+{
+	return 0;
+}
+
+static inline struct printk_log *log_from_idx(u32 idx)
+{
+	return NULL;
+}
+
+static inline char *log_text(const struct printk_log *msg)
+{
+	return NULL;
+}
+
+static inline char *log_dict(const struct printk_log *msg)
+{
+	return NULL;
+}
+
+#endif
+
+#endif /* _PRINTK_PRINTK_H */
-- 
1.9.1
