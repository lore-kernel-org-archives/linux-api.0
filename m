From: Kazimierz Krosman <k.krosman@samsung.com>
Subject: [PATCH v6 7/8] kmsg: add ioctl for kmsg* devices operating on buffers
Date: Wed, 24 Feb 2016 12:53:20 +0100
Message-ID: <1456314801-32738-8-git-send-email-k.krosman@samsung.com>
References: <1456314801-32738-1-git-send-email-k.krosman@samsung.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <1456314801-32738-1-git-send-email-k.krosman@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
To: akpm@linux-foundation.org, peter@hurleysoftware.com, tj@kernel.org, vvs@virtuozzo.com, corbet@lwn.net, arnd@arndb.de, pmladek@suse.cz, gregkh@linuxfoundation.org, daniel@zonque.org, kay.sievers@vrfy.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-api@vger.kernel.org
Cc: k.lewandowsk@samsung.com, k.krosman@samsung.com, m.niesluchow@samsung.com, richard.weinberger@gmail.com, b.zolnierkie@samsung.com, luto@amacapital.net, knhoon.baik@samsung.com
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
Signed-off-by: Paul Osmialowski <p.osmialowsk@samsung.com>
[Rebased kmsg patch v5 on Linux 4.5-rc5]
Signed-off-by: Kazimierz Krosman <k.krosman@samsung.com>
---
 Documentation/ioctl/ioctl-number.txt |  2 +-
 include/uapi/linux/kmsg_ioctl.h      | 15 ++++++++++
 kernel/printk/kmsg.c                 | 57 ++++++++++++++++++++++++++++++++++--
 3 files changed, 71 insertions(+), 3 deletions(-)

diff --git a/Documentation/ioctl/ioctl-number.txt b/Documentation/ioctl/ioctl-number.txt
index 4949aac..c133fb2 100644
--- a/Documentation/ioctl/ioctl-number.txt
+++ b/Documentation/ioctl/ioctl-number.txt
@@ -319,7 +319,7 @@ Code  Seq#(hex)	Include File		Comments
 					<mailto:vgo@ratio.de>
 0xB1	00-1F	PPPoX			<mailto:mostrows@styx.uwaterloo.ca>
 0xB3	00	linux/mmc/ioctl.h
-0xBB	00-02	uapi/linux/kmsg_ioctl.h
+0xBB	00-83	uapi/linux/kmsg_ioctl.h
 0xC0	00-0F	linux/usb/iowarrior.h
 0xCA	00-0F	uapi/misc/cxl.h
 0xCA	80-8F	uapi/scsi/cxlflash_ioctl.h
diff --git a/include/uapi/linux/kmsg_ioctl.h b/include/uapi/linux/kmsg_ioctl.h
index 96e7930..bfd9cd3 100644
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
diff --git a/kernel/printk/kmsg.c b/kernel/printk/kmsg.c
index 4bf36cd..9ba3989 100644
--- a/kernel/printk/kmsg.c
+++ b/kernel/printk/kmsg.c
@@ -247,8 +247,9 @@ static loff_t kmsg_llseek(struct log_buffer *log_b, struct file *file,
 		}
 		/*
 		 * The first record after the last SYSLOG_ACTION_CLEAR,
-		 * like issued by 'dmesg -c'. Reading /dev/kmsg itself
-		 * changes no global state, and does not clear anything.
+		 * like issued by 'dmesg -c' or KMSG_CMD_CLEAR ioctl
+		 * command. Reading /dev/kmsg itself changes no global
+		 * state, and does not clear anything.
 		 */
 		user->idx = log_b->clear_idx;
 		user->seq = log_b->clear_seq;
@@ -391,6 +392,56 @@ static int devkmsg_open(struct inode *inode, struct file *file)
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
@@ -409,6 +460,8 @@ const struct file_operations kmsg_fops = {
 	.write_iter = devkmsg_write,
 	.llseek = devkmsg_llseek,
 	.poll = devkmsg_poll,
+	.unlocked_ioctl = devkmsg_ioctl,
+	.compat_ioctl = devkmsg_ioctl,
 	.release = devkmsg_release,
 };
 
-- 
1.9.1
