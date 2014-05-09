From: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
Subject: [PATCH] drivers/char/mem.c: Add /dev/ioports, supporting 16-bit and
 32-bit ports
Date: Fri, 9 May 2014 12:19:16 -0700
Message-ID: <20140509191914.GA7286@jtriplet-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

/dev/port only supports reading and writing 8-bit ports; multi-byte
operations on /dev/port will just operate on multiple successive 8-bit
ports.

Add a new device, /dev/ioports, which supports reading and writing
16-bit and 32-bit ports.  This makes it possible to perform arbitrary
I/O port operations cleanly from privileged userspace processes, without
using iopl or ioperm.

Signed-off-by: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
---

Written after encountering yet another out-of-tree omnibus "do arbitrary
I/O for test purposes" driver; this one's main reason for existence was
the inability to operate on 16-bit and 32-bit I/O ports.  Let's get a
proper interface into the kernel, to make such drivers obsolete.

I've also written a corresponding manpage patch, which I'll submit as a
reply to this one.

 drivers/char/mem.c | 79 ++++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 77 insertions(+), 2 deletions(-)

diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index 917403f..84e0526 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -35,6 +35,7 @@
 #endif
 
 #define DEVPORT_MINOR	4
+#define DEVIOPORTS_MINOR	12
 
 static inline unsigned long size_inside_page(unsigned long start,
 					     unsigned long size)
@@ -584,6 +585,69 @@ static ssize_t write_port(struct file *file, const char __user *buf,
 	*ppos = i;
 	return tmp-buf;
 }
+
+static ssize_t read_ioports(struct file *file, char __user *buf,
+			    size_t count, loff_t *ppos)
+{
+	unsigned long port = *ppos;
+
+	if (!access_ok(VERIFY_WRITE, buf, count))
+		return -EFAULT;
+	if (port > 65535)
+		return 0;
+	switch (count) {
+	case 1:
+		if (__put_user(inb(port), buf) < 0)
+			return -EFAULT;
+		return 1;
+	case 2:
+		if (__put_user(inw(port), buf) < 0)
+			return -EFAULT;
+		return 2;
+	case 4:
+		if (__put_user(inl(port), buf) < 0)
+			return -EFAULT;
+		return 4;
+	default:
+		return -EINVAL;
+	}
+}
+
+static ssize_t write_ioports(struct file *file, const char __user *buf,
+			     size_t count, loff_t *ppos)
+{
+	unsigned long port = *ppos;
+
+	if (!access_ok(VERIFY_READ, buf, count))
+		return -EFAULT;
+	if (port > 65535)
+		return 0;
+	switch (count) {
+	case 1: {
+		u8 b;
+		if (__get_user(b, buf))
+			return -EFAULT;
+		outb(b, port);
+		return 1;
+	}
+	case 2: {
+		u16 w;
+		if (__get_user(w, buf))
+			return -EFAULT;
+		outw(w, port);
+		return 2;
+	}
+	case 4: {
+		u32 l;
+		if (__get_user(l, buf))
+			return -EFAULT;
+		outl(l, port);
+		return 4;
+	}
+	default:
+		return -EINVAL;
+	}
+}
 #endif
 
 static ssize_t read_null(struct file *file, char __user *buf,
@@ -779,6 +843,13 @@ static const struct file_operations port_fops = {
 	.write		= write_port,
 	.open		= open_port,
 };
+
+static const struct file_operations ioports_fops = {
+	.llseek		= memory_lseek,
+	.read		= read_ioports,
+	.write		= write_ioports,
+	.open		= open_port,
+};
 #endif
 
 static const struct file_operations zero_fops = {
@@ -827,6 +898,9 @@ static const struct memdev {
 #ifdef CONFIG_PRINTK
 	[11] = { "kmsg", 0644, &kmsg_fops, NULL },
 #endif
+#ifdef CONFIG_DEVPORT
+	 [12] = { "ioports", 0, &ioports_fops, NULL },
+#endif
 };
 
 static int memory_open(struct inode *inode, struct file *filp)
@@ -892,9 +966,10 @@ static int __init chr_dev_init(void)
 			continue;
 
 		/*
-		 * Create /dev/port?
+		 * Create /dev/port and /dev/ioports?
 		 */
-		if ((minor == DEVPORT_MINOR) && !arch_has_dev_port())
+		if ((minor == DEVPORT_MINOR || minor == DEVIOPORTS_MINOR)
+		    && !arch_has_dev_port())
 			continue;
 
 		device_create(mem_class, NULL, MKDEV(MEM_MAJOR, minor),
-- 
2.0.0.rc2
