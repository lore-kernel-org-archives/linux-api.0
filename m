From: Marcin Niesluchowski <m.niesluchow-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Subject: [RFC 7/8] kmsg: add ioctl for adding and deleting kmsg* devices
Date: Fri, 03 Jul 2015 12:49:54 +0200
Message-ID: <1435920595-30879-8-git-send-email-m.niesluchow@samsung.com>
References: <1435920595-30879-1-git-send-email-m.niesluchow@samsung.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <1435920595-30879-1-git-send-email-m.niesluchow-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Petr Mladek <pmladek-AlSwsSmVLrQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kay Sievers <kay-tD+1rO4QERM@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>, Karol Lewandowski <k.lewandowsk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Bartlomiej Zolnierkiewicz <b.zolnierkie-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Marcin Niesluchowski <m.niesluchow-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

There is no possibility to add/delete kmsg* buffers from userspace.

Adds following ioctl for main kmsg device adding and deleting
additional kmsg devices:
* KMSG_CMD_BUFFER_ADD
* KMSG_CMD_BUFFER_DEL

Signed-off-by: Marcin Niesluchowski <m.niesluchow-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
---
 Documentation/ioctl/ioctl-number.txt |   1 +
 drivers/char/mem.c                   | 134 +++++++++++++++++++++++++++++++++--
 include/uapi/linux/Kbuild            |   1 +
 include/uapi/linux/kmsg_ioctl.h      |  30 ++++++++
 4 files changed, 159 insertions(+), 7 deletions(-)
 create mode 100644 include/uapi/linux/kmsg_ioctl.h

diff --git a/Documentation/ioctl/ioctl-number.txt b/Documentation/ioctl/ioctl-number.txt
index 611c522..26c0e53 100644
--- a/Documentation/ioctl/ioctl-number.txt
+++ b/Documentation/ioctl/ioctl-number.txt
@@ -312,6 +312,7 @@ Code  Seq#(hex)	Include File		Comments
 					<mailto:vgo-/IYFIZglx74@public.gmane.org>
 0xB1	00-1F	PPPoX			<mailto:mostrows-TTukF6hB3AoKZpuMuFhwt/d9D2ou9A/h@public.gmane.org>
 0xB3	00	linux/mmc/ioctl.h
+0xBB	00-02	uapi/linux/kmsg_ioctl.h
 0xC0	00-0F	linux/usb/iowarrior.h
 0xCA	00-0F	uapi/misc/cxl.h
 0xCB	00-1F	CBM serial IEC bus	in development:
diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index 8d5ba0d..2893d8e 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -34,8 +34,14 @@
 # include <linux/efi.h>
 #endif
 
+#ifdef CONFIG_PRINTK
+#include <linux/kmsg_ioctl.h>
+#endif
+
 #define DEVPORT_MINOR	4
 
+static struct class *mem_class;
+
 static inline unsigned long size_inside_page(unsigned long start,
 					     unsigned long size)
 {
@@ -715,6 +721,113 @@ static int open_port(struct inode *inode, struct file *filp)
 	return capable(CAP_SYS_RAWIO) ? 0 : -EPERM;
 }
 
+#ifdef CONFIG_PRINTK
+#define KMSG_MINOR	11
+
+#define MAX_MINOR_LEN	20
+
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
+	size_t size;
+	umode_t mode;
+	char name[4 + MAX_MINOR_LEN + 1];
+	struct device *dev;
+	int minor;
+
+	if (iminor(file->f_inode) != KMSG_MINOR)
+		return -ENOTTY;
+
+	switch (cmd) {
+	case KMSG_CMD_BUFFER_ADD:
+		if (copy_from_user(&size, argp, sizeof(size)))
+			return -EFAULT;
+		argp += sizeof(size);
+		if (copy_from_user(&mode, argp, sizeof(mode)))
+			return -EFAULT;
+		argp += sizeof(mode);
+		minor = kmsg_sys_buffer_add(size, mode);
+		if (minor < 0)
+			return minor;
+		sprintf(name, "kmsg%d", minor);
+		dev = device_create(mem_class, NULL, MKDEV(MEM_MAJOR, minor),
+				    NULL, name);
+		if (IS_ERR(dev)) {
+			kmsg_sys_buffer_del(minor);
+			return PTR_ERR(dev);
+		}
+		if (copy_to_user(argp, &minor, sizeof(minor))) {
+			device_destroy(mem_class, MKDEV(MEM_MAJOR, minor));
+			kmsg_sys_buffer_del(minor);
+			return -EFAULT;
+		}
+		return 0;
+	case KMSG_CMD_BUFFER_DEL:
+		if (copy_from_user(&minor, argp, sizeof(minor)))
+			return -EFAULT;
+		if (minor <= KMSG_MINOR)
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
+#endif
+
 #define zero_lseek	null_lseek
 #define full_lseek      null_lseek
 #define write_zero	write_null
@@ -779,6 +892,19 @@ static const struct file_operations full_fops = {
 	.write		= write_full,
 };
 
+#ifdef CONFIG_PRINTK
+static const struct file_operations kmsg_fops_ext = {
+	.open		= kmsg_open_ext,
+	.read		= kmsg_read_ext,
+	.write_iter	= kmsg_write_iter_ext,
+	.llseek		= kmsg_llseek_ext,
+	.poll		= kmsg_poll_ext,
+	.unlocked_ioctl	= kmsg_unlocked_ioctl_ext,
+	.compat_ioctl	= kmsg_compat_ioctl_ext,
+	.release	= kmsg_release_ext,
+};
+#endif
+
 static const struct memdev {
 	const char *name;
 	umode_t mode;
@@ -800,14 +926,10 @@ static const struct memdev {
 	 [8] = { "random", 0666, &random_fops, 0 },
 	 [9] = { "urandom", 0666, &urandom_fops, 0 },
 #ifdef CONFIG_PRINTK
-	[11] = { "kmsg", 0644, &kmsg_fops, 0 },
+	[11] = { "kmsg", 0644, &kmsg_fops_ext, 0 },
 #endif
 };
 
-#ifdef CONFIG_PRINTK
-#define KMSG_MINOR	11
-#endif
-
 static int memory_open(struct inode *inode, struct file *filp)
 {
 	int minor;
@@ -858,8 +980,6 @@ static char *mem_devnode(struct device *dev, umode_t *mode)
 	return NULL;
 }
 
-static struct class *mem_class;
-
 static int __init chr_dev_init(void)
 {
 	int minor;
diff --git a/include/uapi/linux/Kbuild b/include/uapi/linux/Kbuild
index 1ff9942..faf13a8 100644
--- a/include/uapi/linux/Kbuild
+++ b/include/uapi/linux/Kbuild
@@ -224,6 +224,7 @@ header-y += kernel-page-flags.h
 header-y += kexec.h
 header-y += keyboard.h
 header-y += keyctl.h
+header-y += kmsg_ioctl.h
 
 ifneq ($(wildcard $(srctree)/arch/$(SRCARCH)/include/uapi/asm/kvm.h \
 		  $(srctree)/arch/$(SRCARCH)/include/asm/kvm.h),)
diff --git a/include/uapi/linux/kmsg_ioctl.h b/include/uapi/linux/kmsg_ioctl.h
new file mode 100644
index 0000000..89c0c61
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
+	size_t size;
+	unsigned short mode;
+	int minor;
+} __attribute__((packed));
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
-- 
1.9.1
