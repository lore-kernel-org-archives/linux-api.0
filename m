From: Paul Osmialowski <p.osmialowsk@samsung.com>
Subject: [RFC v2 8/9] kmsg: add ioctl for kmsg* devices operating on buffers
Date: Mon, 12 Oct 2015 11:29:16 +0200
Message-ID: <1444642157-32618-9-git-send-email-p.osmialowsk@samsung.com>
References: <1444642157-32618-1-git-send-email-p.osmialowsk@samsung.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <1444642157-32618-1-git-send-email-p.osmialowsk@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jonathan Corbet <corbet@lwn.net>, Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>, Petr Mladek <pmladek@suse.cz>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Daniel Mack <daniel@zonque.org>, Kay Sievers <kay.sievers@vrfy.org>, Joe Perches <joe@perches.com>, Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-api@vger.kernel.org
Cc: Marcin Niesluchowski <m.niesluchow@samsung.com>, Karol Lewandowski <k.lewandowsk@samsung.com>, Paul Osmialowski <p.osmialowsk@samsung.com>, Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>, Shuah Khan <shuahkh@osg.samsung.com>
List-Id: linux-api@vger.kernel.org

From: Marcin Niesluchowski <m.niesluchow@samsung.com>

There is no possibility to clear additional kmsg buffers,
get size of them or know what size should be passed to read
file operation (too small size causes it to retrun -EINVAL).

Add following ioctls which solve those issues:
* KMSG_CMD_GET_BUF_SIZE
* KMSG_CMD_GET_READ_SIZE_MAX
* KMSG_CMD_CLEAR

Signed-off-by: Marcin Niesluchowski <m.niesluchow@samsung.com>
---
 Documentation/ioctl/ioctl-number.txt |   2 +-
 include/uapi/linux/kmsg_ioctl.h      |  15 ++++++
 kernel/printk/printk.c               | 102 ++++++++++++++++++++++++++---------
 3 files changed, 92 insertions(+), 27 deletions(-)

diff --git a/Documentation/ioctl/ioctl-number.txt b/Documentation/ioctl/ioctl-number.txt
index a36dc46..c55e49e 100644
--- a/Documentation/ioctl/ioctl-number.txt
+++ b/Documentation/ioctl/ioctl-number.txt
@@ -316,7 +316,7 @@ Code  Seq#(hex)	Include File		Comments
 					<mailto:vgo@ratio.de>
 0xB1	00-1F	PPPoX			<mailto:mostrows@styx.uwaterloo.ca>
 0xB3	00	linux/mmc/ioctl.h
-0xBB	00-02	uapi/linux/kmsg_ioctl.h
+0xBB	00-83	uapi/linux/kmsg_ioctl.h
 0xC0	00-0F	linux/usb/iowarrior.h
 0xCA	00-0F	uapi/misc/cxl.h
 0xCA	80-8F	uapi/scsi/cxlflash_ioctl.h
diff --git a/include/uapi/linux/kmsg_ioctl.h b/include/uapi/linux/kmsg_ioctl.h
index 89c0c61..2389d9f 100644
--- a/include/uapi/linux/kmsg_ioctl.h
+++ b/include/uapi/linux/kmsg_ioctl.h
@@ -27,4 +27,19 @@ struct kmsg_cmd_buffer_add {
 					      struct kmsg_cmd_buffer_add)
 #define KMSG_CMD_BUFFER_DEL		_IOW(KMSG_IOCTL_MAGIC, 0x01, int)
 
+/*
+ * A ioctl interface for kmsg* devices.
+ *
+ * KMSG_CMD_GET_BUF_SIZE:	Retrieve cyclic log buffer size associated with
+ *				device.
+ * KMSG_CMD_GET_READ_SIZE_MAX:	Retrieve max size of data read by kmsg read
+ *				operation.
+ * KMSG_CMD_CLEAR:		Clears cyclic log buffer. After that operation
+ *				there is no data to read from buffer unless
+ *				logs are written.
+ */
+#define KMSG_CMD_GET_BUF_SIZE		_IOR(KMSG_IOCTL_MAGIC, 0x80, __u32)
+#define KMSG_CMD_GET_READ_SIZE_MAX	_IOR(KMSG_IOCTL_MAGIC, 0x81, __u32)
+#define KMSG_CMD_CLEAR			_IO(KMSG_IOCTL_MAGIC, 0x82)
+
 #endif
diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index be08aae..1bc4a31 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -262,6 +262,10 @@ struct log_buffer {
 	u64 next_seq;
 #ifdef CONFIG_PRINTK
 	u32 next_idx;		/* index of the next record to store */
+/* sequence number of the next record to read after last 'clear' command */
+	u64 clear_seq;
+/* index of the next record to read after last 'clear' command */
+	u32 clear_idx;
 	int mode;		/* mode of device */
 	int minor;		/* minor representing buffer device */
 #endif
@@ -279,10 +283,6 @@ static u64 console_seq;
 static u32 console_idx;
 static enum log_flags console_prev;
 
-/* the next printk record to read after the last 'clear' command */
-static u64 clear_seq;
-static u32 clear_idx;
-
 #define PREFIX_MAX		32
 #define LOG_LINE_MAX		(1024 - PREFIX_MAX)
 
@@ -306,6 +306,8 @@ static struct log_buffer log_buf = {
 	.first_idx	= 0,
 	.next_seq	= 0,
 	.next_idx	= 0,
+	.clear_seq	= 0,
+	.clear_idx	= 0,
 	.mode		= 0,
 	.minor		= 0,
 };
@@ -1116,18 +1118,14 @@ static loff_t kmsg_llseek(struct log_buffer *log_b, struct file *file,
 		user->seq = log_b->first_seq;
 		break;
 	case SEEK_DATA:
-		/* no clear index for kmsg_sys buffers */
-		if (log_b != &log_buf) {
-			ret = -EINVAL;
-			break;
-		}
 		/*
 		 * The first record after the last SYSLOG_ACTION_CLEAR,
-		 * like issued by 'dmesg -c'. Reading /dev/kmsg itself
-		 * changes no global state, and does not clear anything.
+		 * like issued by 'dmesg -c' or KMSG_CMD_CLEAR ioctl
+		 * command. Reading /dev/kmsg itself changes no global
+		 * state, and does not clear anything.
 		 */
-		user->idx = clear_idx;
-		user->seq = clear_seq;
+		user->idx = log_b->clear_idx;
+		user->seq = log_b->clear_seq;
 		break;
 	case SEEK_END:
 		/* after the last record */
@@ -1267,6 +1265,56 @@ static int devkmsg_open(struct inode *inode, struct file *file)
 	return ret;
 }
 
+static long kmsg_ioctl(struct log_buffer *log_b, unsigned int cmd,
+		       unsigned long arg)
+{
+	void __user *argp = (void __user *)arg;
+	static const u32 read_size_max = CONSOLE_EXT_LOG_MAX;
+
+	switch (cmd) {
+	case KMSG_CMD_GET_BUF_SIZE:
+		if (copy_to_user(argp, &log_b->len, sizeof(u32)))
+			return -EFAULT;
+		break;
+	case KMSG_CMD_GET_READ_SIZE_MAX:
+		if (copy_to_user(argp, &read_size_max, sizeof(u32)))
+			return -EFAULT;
+		break;
+	case KMSG_CMD_CLEAR:
+		if (!capable(CAP_SYSLOG))
+			return -EPERM;
+		raw_spin_lock_irq(&log_b->lock);
+		log_b->clear_seq = log_b->next_seq;
+		log_b->clear_idx = log_b->next_idx;
+		raw_spin_unlock_irq(&log_b->lock);
+		break;
+	default:
+		return -ENOTTY;
+	}
+	return 0;
+}
+
+static long devkmsg_ioctl(struct file *file, unsigned int cmd,
+			  unsigned long arg)
+{
+	long ret = -ENXIO;
+	int minor = iminor(file->f_inode);
+	struct log_buffer *log_b;
+
+	if (minor == log_buf.minor)
+		return kmsg_ioctl(&log_buf, cmd, arg);
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(log_b, &log_buf.list, list) {
+		if (log_b->minor == minor) {
+			ret = kmsg_ioctl(log_b, cmd, arg);
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
@@ -1285,6 +1333,8 @@ const struct file_operations kmsg_fops = {
 	.write_iter = devkmsg_write,
 	.llseek = devkmsg_llseek,
 	.poll = devkmsg_poll,
+	.unlocked_ioctl = devkmsg_ioctl,
+	.compat_ioctl = devkmsg_ioctl,
 	.release = devkmsg_release,
 };
 
@@ -1889,18 +1939,18 @@ static int syslog_print_all(char __user *buf, int size, bool clear)
 		u32 idx;
 		enum log_flags prev;
 
-		if (clear_seq < log_buf.first_seq) {
+		if (log_buf.clear_seq < log_buf.first_seq) {
 			/* messages are gone, move to first available one */
-			clear_seq = log_buf.first_seq;
-			clear_idx = log_buf.first_idx;
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
 		while (seq < log_buf.next_seq) {
 			struct printk_log *msg = log_from_idx(&log_buf, idx);
@@ -1912,8 +1962,8 @@ static int syslog_print_all(char __user *buf, int size, bool clear)
 		}
 
 		/* move first record forward until length fits into the buffer */
-		seq = clear_seq;
-		idx = clear_idx;
+		seq = log_buf.clear_seq;
+		idx = log_buf.clear_idx;
 		prev = 0;
 		while (len > size && seq < log_buf.next_seq) {
 			struct printk_log *msg = log_from_idx(&log_buf, idx);
@@ -1959,8 +2009,8 @@ static int syslog_print_all(char __user *buf, int size, bool clear)
 	}
 
 	if (clear) {
-		clear_seq = log_buf.next_seq;
-		clear_idx = log_buf.next_idx;
+		log_buf.clear_seq = log_buf.next_seq;
+		log_buf.clear_idx = log_buf.next_idx;
 	}
 	raw_spin_unlock_irq(&log_buf.lock);
 
@@ -3341,8 +3391,8 @@ void kmsg_dump(enum kmsg_dump_reason reason)
 		dumper->active = true;
 
 		raw_spin_lock_irqsave(&log_buf.lock, flags);
-		dumper->cur_seq = clear_seq;
-		dumper->cur_idx = clear_idx;
+		dumper->cur_seq = log_buf.clear_seq;
+		dumper->cur_idx = log_buf.clear_idx;
 		dumper->next_seq = log_buf.next_seq;
 		dumper->next_idx = log_buf.next_idx;
 		raw_spin_unlock_irqrestore(&log_buf.lock, flags);
@@ -3548,8 +3598,8 @@ EXPORT_SYMBOL_GPL(kmsg_dump_get_buffer);
  */
 void kmsg_dump_rewind_nolock(struct kmsg_dumper *dumper)
 {
-	dumper->cur_seq = clear_seq;
-	dumper->cur_idx = clear_idx;
+	dumper->cur_seq = log_buf.clear_seq;
+	dumper->cur_idx = log_buf.clear_idx;
 	dumper->next_seq = log_buf.next_seq;
 	dumper->next_idx = log_buf.next_idx;
 }
-- 
1.9.1
