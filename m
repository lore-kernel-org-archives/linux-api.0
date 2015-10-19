From: Paul Osmialowski <p.osmialowsk@samsung.com>
Subject: [RFC v4 6/9] kmsg: add ioctl for adding and deleting kmsg* devices
Date: Mon, 19 Oct 2015 18:50:01 +0200
Message-ID: <1445273404-24562-7-git-send-email-p.osmialowsk@samsung.com>
References: <1445273404-24562-1-git-send-email-p.osmialowsk@samsung.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <1445273404-24562-1-git-send-email-p.osmialowsk@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jonathan Corbet <corbet@lwn.net>, Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>, Petr Mladek <pmladek@suse.cz>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Daniel Mack <daniel@zonque.org>, Kay Sievers <kay.sievers@vrfy.org>, Joe Perches <joe@perches.com>, Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-api@vger.kernel.org
Cc: Richard Weinberger <richard.weinberger@gmail.com>, Marcin Niesluchowski <m.niesluchow@samsung.com>, Karol Lewandowski <k.lewandowsk@samsung.com>, Paul Osmialowski <p.osmialowsk@samsung.com>, Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>, Shuah Khan <shuahkh@osg.samsung.com>
List-Id: linux-api@vger.kernel.org

From: Marcin Niesluchowski <m.niesluchow@samsung.com>

There is no possibility to add/delete kmsg* buffers from userspace.

Adds following ioctl for main kmsg device adding and deleting
additional kmsg devices:
* KMSG_CMD_BUFFER_ADD
* KMSG_CMD_BUFFER_DEL

Signed-off-by: Marcin Niesluchowski <m.niesluchow@samsung.com>
Signed-off-by: Paul Osmialowski <p.osmialowsk@samsung.com>
---
 Documentation/ioctl/ioctl-number.txt |   1 +
 drivers/char/mem.c                   |   2 +-
 include/linux/printk.h               |   7 ++
 include/uapi/linux/Kbuild            |   1 +
 include/uapi/linux/kmsg_ioctl.h      |  30 +++++++++
 kernel/printk/kmsg.c                 | 122 +++++++++++++++++++++++++++++++++++
 6 files changed, 162 insertions(+), 1 deletion(-)
 create mode 100644 include/uapi/linux/kmsg_ioctl.h

diff --git a/Documentation/ioctl/ioctl-number.txt b/Documentation/ioctl/ioctl-number.txt
index 43e6923..76dec8b 100644
--- a/Documentation/ioctl/ioctl-number.txt
+++ b/Documentation/ioctl/ioctl-number.txt
@@ -319,6 +319,7 @@ Code  Seq#(hex)	Include File		Comments
 					<mailto:vgo@ratio.de>
 0xB1	00-1F	PPPoX			<mailto:mostrows@styx.uwaterloo.ca>
 0xB3	00	linux/mmc/ioctl.h
+0xBB	00-02	uapi/linux/kmsg_ioctl.h
 0xC0	00-0F	linux/usb/iowarrior.h
 0xCA	00-0F	uapi/misc/cxl.h
 0xCA	80-8F	uapi/scsi/cxlflash_ioctl.h
diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index 7d46234..ac824de 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -808,7 +808,7 @@ static int memory_open(struct inode *inode, struct file *filp)
 
 	minor = iminor(inode);
 	if (minor >= ARRAY_SIZE(devlist))
-		return kmsg_memory_open(inode, filp);
+		return kmsg_memory_open_ext(inode, filp);
 
 	dev = &devlist[minor];
 	if (!dev->fops)
diff --git a/include/linux/printk.h b/include/linux/printk.h
index 513fa6f..ebacfa6 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -427,9 +427,11 @@ struct inode;
 extern struct class *mem_class;
 
 extern const struct file_operations kmsg_fops;
+extern const struct file_operations kmsg_fops_ext;
 
 extern struct device *init_kmsg(int minor, umode_t mode);
 extern int kmsg_memory_open(struct inode *inode, struct file *filp);
+extern int kmsg_memory_open_ext(struct inode *inode, struct file *filp);
 extern int kmsg_mode(int minor, umode_t *mode);
 extern int kmsg_sys_buffer_add(size_t size, umode_t mode);
 extern void kmsg_sys_buffer_del(int minor);
@@ -446,6 +448,11 @@ static inline int kmsg_memory_open(struct inode *inode, struct file *filp)
 	return -ENXIO;
 }
 
+static inline int kmsg_memory_open_ext(struct inode *inode, struct file *filp)
+{
+	return -ENXIO;
+}
+
 static inline int kmsg_mode(int minor, umode_t *mode)
 {
 	return -ENXIO;
diff --git a/include/uapi/linux/Kbuild b/include/uapi/linux/Kbuild
index e777078..d998999 100644
--- a/include/uapi/linux/Kbuild
+++ b/include/uapi/linux/Kbuild
@@ -225,6 +225,7 @@ header-y += kernel-page-flags.h
 header-y += kexec.h
 header-y += keyboard.h
 header-y += keyctl.h
+header-y += kmsg_ioctl.h
 
 ifneq ($(wildcard $(srctree)/arch/$(SRCARCH)/include/uapi/asm/kvm.h \
 		  $(srctree)/arch/$(SRCARCH)/include/asm/kvm.h),)
diff --git a/include/uapi/linux/kmsg_ioctl.h b/include/uapi/linux/kmsg_ioctl.h
new file mode 100644
index 0000000..96e7930
--- /dev/null
+++ b/include/uapi/linux/kmsg_ioctl.h
@@ -0,0 +1,30 @@
+/*
+ * This is ioctl include for kmsg* devices
+ */
+
+#ifndef _KMSG_IOCTL_H_
+#define _KMSG_IOCTL_H_
+
+#include <linux/ioctl.h>
+#include <linux/types.h>
+
+struct kmsg_cmd_buffer_add {
+	__u64 size;
+	__u32 mode;
+	__u32 minor;
+};
+
+#define KMSG_IOCTL_MAGIC	0xBB
+
+/*
+ * A ioctl interface for kmsg device.
+ *
+ * KMSG_CMD_BUFFER_ADD:	Creates additional kmsg device based on its size
+ *			and mode. Minor of created device is put.
+ * KMSG_CMD_BUFFER_DEL:	Removes additional kmsg device based on its minor
+ */
+#define KMSG_CMD_BUFFER_ADD		_IOWR(KMSG_IOCTL_MAGIC, 0x00, \
+					      struct kmsg_cmd_buffer_add)
+#define KMSG_CMD_BUFFER_DEL		_IOW(KMSG_IOCTL_MAGIC, 0x01, int)
+
+#endif
diff --git a/kernel/printk/kmsg.c b/kernel/printk/kmsg.c
index 9222fdc..62bb4d5 100644
--- a/kernel/printk/kmsg.c
+++ b/kernel/printk/kmsg.c
@@ -23,8 +23,12 @@
 
 #include <asm/uaccess.h>
 
+#include <uapi/linux/kmsg_ioctl.h>
+
 #include "printk.h"
 
+#define KMSG_MAX_MINOR_LEN	20
+
 /* /dev/kmsg - userspace message inject/listen interface */
 struct devkmsg_user {
 	u64 seq;
@@ -408,6 +412,117 @@ const struct file_operations kmsg_fops = {
 	.release = devkmsg_release,
 };
 
+static int kmsg_open_ext(struct inode *inode, struct file *file)
+{
+	return kmsg_fops.open(inode, file);
+}
+
+static ssize_t kmsg_write_iter_ext(struct kiocb *iocb, struct iov_iter *from)
+{
+	return kmsg_fops.write_iter(iocb, from);
+}
+
+static ssize_t kmsg_read_ext(struct file *file, char __user *buf,
+			     size_t count, loff_t *ppos)
+{
+	return kmsg_fops.read(file, buf, count, ppos);
+}
+
+static loff_t kmsg_llseek_ext(struct file *file, loff_t offset, int whence)
+{
+	return kmsg_fops.llseek(file, offset, whence);
+}
+
+static unsigned int kmsg_poll_ext(struct file *file,
+				  struct poll_table_struct *wait)
+{
+	return kmsg_fops.poll(file, wait);
+}
+
+static long kmsg_ioctl_buffers(struct file *file, unsigned int cmd,
+			       unsigned long arg)
+{
+	void __user *argp = (void __user *)arg;
+	struct kmsg_cmd_buffer_add cmd_buffer_add;
+	char name[4 + KMSG_MAX_MINOR_LEN + 1];
+	struct device *dev;
+	int minor;
+
+	if (iminor(file->f_inode) != log_buf.minor)
+		return -ENOTTY;
+
+	switch (cmd) {
+	case KMSG_CMD_BUFFER_ADD:
+		if (copy_from_user(&cmd_buffer_add, argp,
+					sizeof(struct kmsg_cmd_buffer_add)))
+			return -EFAULT;
+		minor = kmsg_sys_buffer_add(cmd_buffer_add.size,
+						cmd_buffer_add.mode);
+		if (minor < 0)
+			return minor;
+		sprintf(name, "kmsg%d", minor);
+		dev = device_create(mem_class, NULL, MKDEV(MEM_MAJOR, minor),
+				    NULL, name);
+		if (IS_ERR(dev)) {
+			kmsg_sys_buffer_del(minor);
+			return PTR_ERR(dev);
+		}
+		cmd_buffer_add.minor = minor;
+		if (copy_to_user(argp, &cmd_buffer_add,
+					sizeof(struct kmsg_cmd_buffer_add))) {
+			device_destroy(mem_class, MKDEV(MEM_MAJOR, minor));
+			kmsg_sys_buffer_del(minor);
+			return -EFAULT;
+		}
+		return 0;
+	case KMSG_CMD_BUFFER_DEL:
+		if (copy_from_user(&minor, argp, sizeof(minor)))
+			return -EFAULT;
+		if (minor <= log_buf.minor)
+			return -EINVAL;
+		device_destroy(mem_class, MKDEV(MEM_MAJOR, minor));
+		kmsg_sys_buffer_del(minor);
+		return 0;
+	}
+	return -ENOTTY;
+}
+
+static long kmsg_unlocked_ioctl_ext(struct file *file, unsigned int cmd,
+				    unsigned long arg)
+{
+	long ret = kmsg_ioctl_buffers(file, cmd, arg);
+
+	if (ret == -ENOTTY)
+		return kmsg_fops.unlocked_ioctl(file, cmd, arg);
+	return ret;
+}
+
+static long kmsg_compat_ioctl_ext(struct file *file, unsigned int cmd,
+				  unsigned long arg)
+{
+	long ret = kmsg_ioctl_buffers(file, cmd, arg);
+
+	if (ret == -ENOTTY)
+		return kmsg_fops.compat_ioctl(file, cmd, arg);
+	return ret;
+}
+
+static int kmsg_release_ext(struct inode *inode, struct file *file)
+{
+	return kmsg_fops.release(inode, file);
+}
+
+const struct file_operations kmsg_fops_ext = {
+	.open		= kmsg_open_ext,
+	.read		= kmsg_read_ext,
+	.write_iter	= kmsg_write_iter_ext,
+	.llseek		= kmsg_llseek_ext,
+	.poll		= kmsg_poll_ext,
+	.unlocked_ioctl	= kmsg_unlocked_ioctl_ext,
+	.compat_ioctl	= kmsg_compat_ioctl_ext,
+	.release	= kmsg_release_ext,
+};
+
 /* Should be used for device registration */
 struct device *init_kmsg(int minor, umode_t mode)
 {
@@ -424,6 +539,13 @@ int kmsg_memory_open(struct inode *inode, struct file *filp)
 	return kmsg_fops.open(inode, filp);
 }
 
+int kmsg_memory_open_ext(struct inode *inode, struct file *filp)
+{
+	filp->f_op = &kmsg_fops_ext;
+
+	return kmsg_fops_ext.open(inode, filp);
+}
+
 int kmsg_mode(int minor, umode_t *mode)
 {
 	int ret = -ENXIO;
-- 
1.9.1
