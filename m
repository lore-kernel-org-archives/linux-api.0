From: Paul Osmialowski <p.osmialowsk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Subject: [RFC v3 4/9] kmsg: add additional buffers support to memory class
Date: Mon, 19 Oct 2015 14:58:18 +0200
Message-ID: <1445259503-18158-5-git-send-email-p.osmialowsk@samsung.com>
References: <1445259503-18158-1-git-send-email-p.osmialowsk@samsung.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <1445259503-18158-1-git-send-email-p.osmialowsk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Petr Mladek <pmladek-AlSwsSmVLrQ@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>, Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>, Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Marcin Niesluchowski <m.niesluchow-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Karol Lewandowski <k.lewandowsk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Paul Osmialowski <p.osmialowsk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Bartlomiej Zolnierkiewicz <b.zolnierkie-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

From: Marcin Niesluchowski <m.niesluchow-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>

Memory class does not support additional kmsg buffers.

Add additional kmsg buffers support to:
* devnode() callback of "mem" class
* file operations of major "mem" character device

Signed-off-by: Marcin Niesluchowski <m.niesluchow-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Signed-off-by: Paul Osmialowski <p.osmialowsk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
---
 drivers/char/mem.c     | 27 ++++++++++++++++++++-------
 include/linux/printk.h | 32 ++++++++++++++++++++++++++++++++
 kernel/printk/kmsg.c   | 42 ++++++++++++++++++++++++++++++++++++++++++
 kernel/printk/printk.c |  1 +
 kernel/printk/printk.h |  1 +
 5 files changed, 96 insertions(+), 7 deletions(-)

diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index 6b1721f..7d46234 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -799,9 +799,6 @@ static const struct memdev {
 	 [7] = { "full", 0666, &full_fops, 0 },
 	 [8] = { "random", 0666, &random_fops, 0 },
 	 [9] = { "urandom", 0666, &urandom_fops, 0 },
-#ifdef CONFIG_PRINTK
-	[11] = { "kmsg", 0644, &kmsg_fops, 0 },
-#endif
 };
 
 static int memory_open(struct inode *inode, struct file *filp)
@@ -811,7 +808,7 @@ static int memory_open(struct inode *inode, struct file *filp)
 
 	minor = iminor(inode);
 	if (minor >= ARRAY_SIZE(devlist))
-		return -ENXIO;
+		return kmsg_memory_open(inode, filp);
 
 	dev = &devlist[minor];
 	if (!dev->fops)
@@ -833,16 +830,28 @@ static const struct file_operations memory_fops = {
 
 static char *mem_devnode(struct device *dev, umode_t *mode)
 {
-	if (mode && devlist[MINOR(dev->devt)].mode)
-		*mode = devlist[MINOR(dev->devt)].mode;
+	int minor = MINOR(dev->devt);
+
+	if (!mode)
+		goto out;
+
+	if (minor >= ARRAY_SIZE(devlist)) {
+		kmsg_mode(minor, mode);
+		goto out;
+	}
+
+	if (devlist[minor].mode)
+		*mode = devlist[minor].mode;
+out:
 	return NULL;
 }
 
-static struct class *mem_class;
+struct class *mem_class;
 
 static int __init chr_dev_init(void)
 {
 	int minor;
+	struct device *kmsg;
 
 	if (register_chrdev(MEM_MAJOR, "mem", &memory_fops))
 		printk("unable to get major %d for memory devs\n", MEM_MAJOR);
@@ -866,6 +875,10 @@ static int __init chr_dev_init(void)
 			      NULL, devlist[minor].name);
 	}
 
+	kmsg = init_kmsg(KMSG_MINOR, 0644);
+	if (IS_ERR(kmsg))
+		return PTR_ERR(kmsg);
+
 	return tty_init();
 }
 
diff --git a/include/linux/printk.h b/include/linux/printk.h
index 9729565..67840e0 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -417,8 +417,40 @@ do {									\
 	no_printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
 #endif
 
+struct file;
+struct inode;
+
+#ifdef CONFIG_PRINTK
+
+extern struct class *mem_class;
+
+#define KMSG_MINOR	11
+
 extern const struct file_operations kmsg_fops;
 
+extern struct device *init_kmsg(int minor, umode_t mode);
+extern int kmsg_memory_open(struct inode *inode, struct file *filp);
+extern int kmsg_mode(int minor, umode_t *mode);
+
+#else
+
+static inline struct device *init_kmsg(int minor, umode_t mode)
+{
+	return NULL;
+}
+
+static inline int kmsg_memory_open(struct inode *inode, struct file *filp)
+{
+	return -ENXIO;
+}
+
+static inline int kmsg_mode(int minor, umode_t *mode)
+{
+	return -ENXIO;
+}
+
+#endif
+
 enum {
 	DUMP_PREFIX_NONE,
 	DUMP_PREFIX_ADDRESS,
diff --git a/kernel/printk/kmsg.c b/kernel/printk/kmsg.c
index 23d4160..7fcd628 100644
--- a/kernel/printk/kmsg.c
+++ b/kernel/printk/kmsg.c
@@ -15,6 +15,9 @@
 #include <linux/syslog.h>
 #include <linux/uio.h>
 #include <linux/wait.h>
+#include <linux/device.h>
+#include <linux/major.h>
+#include <linux/kdev_t.h>
 
 #include <asm/uaccess.h>
 
@@ -385,6 +388,45 @@ const struct file_operations kmsg_fops = {
 	.release = devkmsg_release,
 };
 
+/* Should be used for device registration */
+struct device *init_kmsg(int minor, umode_t mode)
+{
+	log_buf.minor = minor;
+	log_buf.mode = mode;
+	return device_create(mem_class, NULL, MKDEV(MEM_MAJOR, minor),
+			NULL, "kmsg");
+}
+
+int kmsg_memory_open(struct inode *inode, struct file *filp)
+{
+	filp->f_op = &kmsg_fops;
+
+	return kmsg_fops.open(inode, filp);
+}
+
+int kmsg_mode(int minor, umode_t *mode)
+{
+	int ret = -ENXIO;
+	struct log_buffer *log_b;
+
+	if (minor == log_buf.minor) {
+		*mode = log_buf.mode;
+		return 0;
+	}
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(log_b, &log_buf.list, list) {
+		if (log_b->minor == minor) {
+			*mode = log_b->mode;
+			ret = 0;
+			break;
+		}
+	}
+	rcu_read_unlock();
+
+	return ret;
+}
+
 static DEFINE_SPINLOCK(dump_list_lock);
 static LIST_HEAD(dump_list);
 
diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index e9ac4ba..beabebb 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -179,6 +179,7 @@ struct log_buffer log_buf = {
 	.next_idx	= 0,
 	.clear_seq	= 0,
 	.clear_idx	= 0,
+	.mode		= 0,
 	.minor		= 0,
 };
 
diff --git a/kernel/printk/printk.h b/kernel/printk/printk.h
index 38c9278..0755100 100644
--- a/kernel/printk/printk.h
+++ b/kernel/printk/printk.h
@@ -118,6 +118,7 @@ struct log_buffer {
 	u64 clear_seq;
 	u32 clear_idx;
 
+	int mode;		/* mode of device */
 	int minor;		/* minor representing buffer device */
 #endif
 };
-- 
1.9.1
