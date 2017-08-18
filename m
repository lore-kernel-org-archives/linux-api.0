From: Oleksandr Shamray <oleksandrs-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [patch v4 1/3] drivers: jtag: Add JTAG core driver
Date: Fri, 18 Aug 2017 12:49:15 +0300
Message-ID: <1503049757-17243-2-git-send-email-oleksandrs@mellanox.com>
References: <1503049757-17243-1-git-send-email-oleksandrs@mellanox.com>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1503049757-17243-1-git-send-email-oleksandrs-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, openbmc-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org, joel-U3u1mxZcP9KHXe+LvDLADg@public.gmane.org, jiri-rHqAuBHg3fBzbRFIqnYvSA@public.gmane.org, tklauser-93Khv+1bN0NyDzI6CaY1VQ@public.gmane.org, linux-serial-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mec-WqBc5aa1uDFeoWH0uzbU5w@public.gmane.org, vadimp-45czdsxZ+A5DPfheJLI6IQ@public.gmane.org, system-sw-low-level-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, openocd-devel-owner-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Oleksandr Shamray <oleksandrs-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jiri Pirko <jiri-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Initial patch for JTAG friver
JTAG class driver provide infrastructure to support hardware/software
JTAG platform drivers. It provide user layer API interface for flashing
and debugging external devices which equipped with JTAG interface
using standard transactions.

Driver exposes set of IOCTL to user space for:
- XFER:
- SIR (Scan Instruction Register, IEEE 1149.1 Data Register scan);
- SDR (Scan Data Register, IEEE 1149.1 Instruction Register scan);
- RUNTEST (Forces the IEEE 1149.1 bus to a run state for a specified
  number of clocks).
- SIOCFREQ/GIOCFREQ for setting and reading JTAG frequency.

Driver core provides set of internal APIs for allocation and
registration:
- jtag_register;
- jtag_unregister;
- jtag_alloc;
- jtag_free;

Platform driver on registration with jtag-core creates the next
entry in dev folder:
/dev/jtagX

Signed-off-by: Oleksandr Shamray <oleksandrs-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Jiri Pirko <jiri-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
v3->v4
Comments pointed by Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
- change transaction pointer tdio type  to __u64
- change internal status type from enum to __u32
- reorder jtag_xfer members to aviod the implied padding
- add __packed attribute to jtag_xfer and jtag_run_test_idle

v2->v3
Notifications from kbuild test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
- Change include path to <linux/types.h> in jtag.h

v1->v2
Comments pointed by Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
- Change license type from GPLv2/BSD to GPLv2
- Change type of variables which crossed user/kernel to __type
- Remove "default n" from Kconfig

Comments pointed by Andrew Lunn <andrew-g2DYL2Zd6BY@public.gmane.org>
- Change list_add_tail in jtag_unregister to list_del

Comments pointed by Neil Armstrong <narmstrong-rdvid1DuHRBWk0Htik3J/w@public.gmane.org>
- Add SPDX-License-Identifier instead of license text

Comments pointed by Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
- Change __copy_to_user to memdup_user
- Change __put_user to put_user
- Change type of variables to __type for compatible 32 and 64-bit systems
- Add check for maximum xfer data size
- Change lookup data mechanism to get jtag data from inode
- Add .compat_ioctl to file ops
- Add mem alignment for jtag priv data

Comments pointed by Tobias Klauser <tklauser-93Khv+1bN0NyDzI6CaY1VQ@public.gmane.org>
- Change function names to avoid match with variable types
- Fix description for jtag_ru_test_idle in uapi jtag.h
- Fix misprints IDEL/IDLE, trough/through
---
 Documentation/ioctl/ioctl-number.txt |    2 +
 MAINTAINERS                          |    8 +
 drivers/Kconfig                      |    2 +
 drivers/Makefile                     |    1 +
 drivers/jtag/Kconfig                 |   16 ++
 drivers/jtag/Makefile                |    1 +
 drivers/jtag/jtag.c                  |  311 ++++++++++++++++++++++++++++++++++
 include/linux/jtag.h                 |   48 ++++++
 include/uapi/linux/jtag.h            |  113 ++++++++++++
 9 files changed, 502 insertions(+), 0 deletions(-)
 create mode 100644 drivers/jtag/Kconfig
 create mode 100644 drivers/jtag/Makefile
 create mode 100644 drivers/jtag/jtag.c
 create mode 100644 include/linux/jtag.h
 create mode 100644 include/uapi/linux/jtag.h

diff --git a/Documentation/ioctl/ioctl-number.txt b/Documentation/ioctl/ioctl-number.txt
index 3e3fdae..1af2508 100644
--- a/Documentation/ioctl/ioctl-number.txt
+++ b/Documentation/ioctl/ioctl-number.txt
@@ -321,6 +321,8 @@ Code  Seq#(hex)	Include File		Comments
 0xB0	all	RATIO devices		in development:
 					<mailto:vgo-/IYFIZglx74@public.gmane.org>
 0xB1	00-1F	PPPoX			<mailto:mostrows-TTukF6hB3AoKZpuMuFhwt/d9D2ou9A/h@public.gmane.org>
+0xB2	00-0f	linux/jtag.h		JTAG driver
+					<mailto:oleksandrs-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
 0xB3	00	linux/mmc/ioctl.h
 0xB4	00-0F	linux/gpio.h		<mailto:linux-gpio-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
 0xB5	00-0F	uapi/linux/rpmsg.h	<mailto:linux-remoteproc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
diff --git a/MAINTAINERS b/MAINTAINERS
index 205d397..141aeaf 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7292,6 +7292,14 @@ L:	linux-serial-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
 S:	Maintained
 F:	drivers/tty/serial/jsm/
 
+JTAG SUBSYSTEM
+M:	Oleksandr Shamray <oleksandrs-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
+M:	Vadim Pasternak <vadimp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
+S:	Maintained
+F:	include/linux/jtag.h
+F:	include/uapi/linux/jtag.h
+F:	drivers/jtag/
+
 K10TEMP HARDWARE MONITORING DRIVER
 M:	Clemens Ladisch <clemens-P6GI/4k7KOmELgA04lAiVw@public.gmane.org>
 L:	linux-hwmon-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
diff --git a/drivers/Kconfig b/drivers/Kconfig
index 505c676..2214678 100644
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@ -208,4 +208,6 @@ source "drivers/tee/Kconfig"
 
 source "drivers/mux/Kconfig"
 
+source "drivers/jtag/Kconfig"
+
 endmenu
diff --git a/drivers/Makefile b/drivers/Makefile
index dfdcda0..6a2059b 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -182,3 +182,4 @@ obj-$(CONFIG_FPGA)		+= fpga/
 obj-$(CONFIG_FSI)		+= fsi/
 obj-$(CONFIG_TEE)		+= tee/
 obj-$(CONFIG_MULTIPLEXER)	+= mux/
+obj-$(CONFIG_JTAG)		+= jtag/
diff --git a/drivers/jtag/Kconfig b/drivers/jtag/Kconfig
new file mode 100644
index 0000000..0fad1a3
--- /dev/null
+++ b/drivers/jtag/Kconfig
@@ -0,0 +1,16 @@
+menuconfig JTAG
+	tristate "JTAG support"
+	---help---
+	  This provides basic core functionality support for jtag class devices
+	  Hardware equipped with JTAG microcontroller which can be built
+	  on top of this drivers. Driver exposes the set of IOCTL to the
+	  user space for:
+	  SIR (Scan Instruction Register, IEEE 1149.1 Data Register scan);
+	  SDR (Scan Data Register, IEEE 1149.1 Instruction Register scan);
+	  RUNTEST (Forces IEEE 1149.1 bus to a run state for specified
+	  number of clocks).
+
+	  If you want this support, you should say Y here.
+
+	  To compile this driver as a module, choose M here: the module will
+	  be called jtag.
diff --git a/drivers/jtag/Makefile b/drivers/jtag/Makefile
new file mode 100644
index 0000000..af37493
--- /dev/null
+++ b/drivers/jtag/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_JTAG)		+= jtag.o
diff --git a/drivers/jtag/jtag.c b/drivers/jtag/jtag.c
new file mode 100644
index 0000000..97b351a
--- /dev/null
+++ b/drivers/jtag/jtag.c
@@ -0,0 +1,311 @@
+/*
+ * drivers/jtag/jtag.c
+ *
+ * Copyright (c) 2017 Mellanox Technologies. All rights reserved.
+ * Copyright (c) 2017 Oleksandr Shamray <oleksandrs-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
+ *
+ * Released under the GPLv2 only.
+ * SPDX-License-Identifier: GPL-2.0
+ */
+
+#include <linux/cdev.h>
+#include <linux/device.h>
+#include <linux/jtag.h>
+#include <linux/kernel.h>
+#include <linux/list.h>
+#include <linux/module.h>
+#include <linux/rtnetlink.h>
+#include <linux/spinlock.h>
+#include <uapi/linux/jtag.h>
+
+struct jtag {
+	struct list_head list;
+	struct device *dev;
+	struct cdev cdev;
+	int id;
+	spinlock_t lock;
+	int open;
+	const struct jtag_ops *ops;
+	unsigned long priv[0] __aligned(ARCH_DMA_MINALIGN);
+};
+
+static dev_t jtag_devt;
+static LIST_HEAD(jtag_list);
+static DEFINE_MUTEX(jtag_mutex);
+static DEFINE_IDA(jtag_ida);
+
+void *jtag_priv(struct jtag *jtag)
+{
+	return jtag->priv;
+}
+EXPORT_SYMBOL_GPL(jtag_priv);
+
+static __u64 jtag_copy_from_user(__u64 udata, unsigned long bit_size)
+{
+	unsigned long size;
+	void *kdata;
+
+	size = DIV_ROUND_UP(bit_size, BITS_PER_BYTE);
+	kdata = memdup_user(u64_to_user_ptr(udata), size);
+
+	return (__u64)(uintptr_t)kdata;
+}
+
+static unsigned long jtag_copy_to_user(__u64 udata, __u64 kdata,
+				       unsigned long bit_size)
+{
+	unsigned long size;
+
+	size = DIV_ROUND_UP(bit_size, BITS_PER_BYTE);
+
+	return copy_to_user(u64_to_user_ptr(udata), jtag_u64_to_ptr(kdata),
+			    size);
+}
+
+static struct class jtag_class = {
+	.name = "jtag",
+	.owner = THIS_MODULE,
+};
+
+static int jtag_run_test_idle_op(struct jtag *jtag,
+				 struct jtag_run_test_idle *idle)
+{
+	if (jtag->ops->idle)
+		return jtag->ops->idle(jtag, idle);
+	else
+		return -EOPNOTSUPP;
+}
+
+static int jtag_xfer_op(struct jtag *jtag, struct jtag_xfer *xfer)
+{
+	if (jtag->ops->xfer)
+		return jtag->ops->xfer(jtag, xfer);
+	else
+		return -EOPNOTSUPP;
+}
+
+static long jtag_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	struct jtag *jtag = file->private_data;
+	__u32 *uarg = (__u32 __user *)arg;
+	void  *varg = (void __user *)arg;
+	struct jtag_run_test_idle idle;
+	struct jtag_xfer xfer;
+	__u64 tdio_user;
+	__u32 value;
+	int err;
+
+	switch (cmd) {
+	case JTAG_GIOCFREQ:
+		if (jtag->ops->freq_get)
+			err = jtag->ops->freq_get(jtag, &value);
+		else
+			err = -EOPNOTSUPP;
+		if (err)
+			break;
+
+		err = put_user(value, uarg);
+		break;
+
+	case JTAG_SIOCFREQ:
+		err = __get_user(value, uarg);
+
+		if (value == 0)
+			err = -EINVAL;
+		if (err)
+			break;
+
+		if (jtag->ops->freq_set)
+			err = jtag->ops->freq_set(jtag, value);
+		else
+			err = -EOPNOTSUPP;
+		break;
+
+	case JTAG_IOCRUNTEST:
+		if (copy_from_user(&idle, varg,
+				   sizeof(struct jtag_run_test_idle)))
+			return -ENOMEM;
+		err = jtag_run_test_idle_op(jtag, &idle);
+		break;
+
+	case JTAG_IOCXFER:
+		if (copy_from_user(&xfer, varg, sizeof(struct jtag_xfer)))
+			return -EFAULT;
+
+		if (xfer.length >= JTAG_MAX_XFER_DATA_LEN)
+			return -EFAULT;
+
+		tdio_user = xfer.tdio;
+		xfer.tdio = jtag_copy_from_user(xfer.tdio, xfer.length);
+		if (!xfer.tdio)
+			return -ENOMEM;
+
+		err = jtag_xfer_op(jtag, &xfer);
+		if (jtag_copy_to_user(tdio_user, xfer.tdio, xfer.length)) {
+			kfree(jtag_u64_to_ptr(xfer.tdio));
+			return -EFAULT;
+		}
+
+		kfree(jtag_u64_to_ptr(xfer.tdio));
+		xfer.tdio = tdio_user;
+		if (copy_to_user(varg, &xfer, sizeof(struct jtag_xfer)))
+			return -EFAULT;
+		break;
+
+	case JTAG_GIOCSTATUS:
+		if (jtag->ops->status_get)
+			err = jtag->ops->status_get(jtag, &value);
+		else
+			err = -EOPNOTSUPP;
+		if (err)
+			break;
+
+		err = put_user(value, uarg);
+		break;
+
+	default:
+		return -EINVAL;
+	}
+	return err;
+}
+
+#ifdef CONFIG_COMPAT
+static long jtag_ioctl_compat(struct file *file, unsigned int cmd,
+			      unsigned long arg)
+{
+	return jtag_ioctl(file, cmd, (unsigned long)compat_ptr(arg));
+}
+#endif
+
+static int jtag_open(struct inode *inode, struct file *file)
+{
+	struct jtag *jtag = container_of(inode->i_cdev, struct jtag, cdev);
+
+	spin_lock(&jtag->lock);
+
+	if (jtag->open) {
+		dev_info(NULL, "jtag already opened\n");
+		spin_unlock(&jtag->lock);
+		return -EBUSY;
+	}
+
+	jtag->open++;
+	file->private_data = jtag;
+	spin_unlock(&jtag->lock);
+	return 0;
+}
+
+static int jtag_release(struct inode *inode, struct file *file)
+{
+	struct jtag *jtag = file->private_data;
+
+	spin_lock(&jtag->lock);
+	jtag->open--;
+	spin_unlock(&jtag->lock);
+	return 0;
+}
+
+static const struct file_operations jtag_fops = {
+	.owner		= THIS_MODULE,
+	.open		= jtag_open,
+	.release	= jtag_release,
+	.llseek		= noop_llseek,
+	.unlocked_ioctl = jtag_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl	= jtag_ioctl_compat,
+#endif
+};
+
+struct jtag *jtag_alloc(size_t priv_size, const struct jtag_ops *ops)
+{
+	struct jtag *jtag;
+
+	jtag = kzalloc(sizeof(*jtag) + round_up(priv_size, ARCH_DMA_MINALIGN),
+		       GFP_KERNEL);
+	if (!jtag)
+		return NULL;
+
+	jtag->ops = ops;
+	return jtag;
+}
+EXPORT_SYMBOL_GPL(jtag_alloc);
+
+void jtag_free(struct jtag *jtag)
+{
+	kfree(jtag);
+}
+EXPORT_SYMBOL_GPL(jtag_free);
+
+int jtag_register(struct jtag *jtag)
+{
+	int id;
+	int err;
+
+	id = ida_simple_get(&jtag_ida, 0, 0, GFP_KERNEL);
+	if (id < 0)
+		return id;
+
+	jtag->id = id;
+	cdev_init(&jtag->cdev, &jtag_fops);
+	jtag->cdev.owner = THIS_MODULE;
+	err = cdev_add(&jtag->cdev, MKDEV(MAJOR(jtag_devt), jtag->id), 1);
+	if (err)
+		goto err_cdev;
+
+	/* Register this jtag device with the driver core */
+	jtag->dev = device_create(&jtag_class, NULL, MKDEV(MAJOR(jtag_devt),
+							   jtag->id),
+				  NULL, "jtag%d", jtag->id);
+	if (!jtag->dev)
+		goto err_device_create;
+
+	jtag->open = 0;
+	dev_set_drvdata(jtag->dev, jtag);
+	spin_lock_init(&jtag->lock);
+	mutex_lock(&jtag_mutex);
+	list_add_tail(&jtag->list, &jtag_list);
+	mutex_unlock(&jtag_mutex);
+	return err;
+
+err_device_create:
+	cdev_del(&jtag->cdev);
+err_cdev:
+	ida_simple_remove(&jtag_ida, id);
+	return err;
+}
+EXPORT_SYMBOL_GPL(jtag_register);
+
+void jtag_unregister(struct jtag *jtag)
+{
+	struct device *dev = jtag->dev;
+
+	mutex_lock(&jtag_mutex);
+	list_del(&jtag->list);
+	mutex_unlock(&jtag_mutex);
+	cdev_del(&jtag->cdev);
+	device_unregister(dev);
+	ida_simple_remove(&jtag_ida, jtag->id);
+}
+EXPORT_SYMBOL_GPL(jtag_unregister);
+
+static int __init jtag_init(void)
+{
+	int err;
+
+	err = alloc_chrdev_region(&jtag_devt, 0, 1, "jtag");
+	if (err)
+		return err;
+	return class_register(&jtag_class);
+}
+
+static void __exit jtag_exit(void)
+{
+	class_unregister(&jtag_class);
+}
+
+module_init(jtag_init);
+module_exit(jtag_exit);
+
+MODULE_AUTHOR("Oleksandr Shamray <oleksandrs-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>");
+MODULE_DESCRIPTION("Generic jtag support");
+MODULE_LICENSE("GPL v2");
diff --git a/include/linux/jtag.h b/include/linux/jtag.h
new file mode 100644
index 0000000..f48ae9d
--- /dev/null
+++ b/include/linux/jtag.h
@@ -0,0 +1,48 @@
+/*
+ * drivers/jtag/jtag.c
+ *
+ * Copyright (c) 2017 Mellanox Technologies. All rights reserved.
+ * Copyright (c) 2017 Oleksandr Shamray <oleksandrs-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
+ *
+ * Released under the GPLv2 only.
+ * SPDX-License-Identifier: GPL-2.0
+ */
+
+#ifndef __JTAG_H
+#define __JTAG_H
+
+#include <uapi/linux/jtag.h>
+
+#ifndef ARCH_DMA_MINALIGN
+#define ARCH_DMA_MINALIGN 1
+#endif
+
+#define jtag_u64_to_ptr(arg) ((void *)(uintptr_t)arg)
+
+#define JTAG_MAX_XFER_DATA_LEN 65535
+
+struct jtag;
+/**
+ * struct jtag_ops - callbacks for jtag control functions:
+ *
+ * @freq_get: get frequency function. Filled by device driver
+ * @freq_set: set frequency function. Filled by device driver
+ * @status_get: set status function. Filled by device driver
+ * @idle: set JTAG to idle state function. Filled by device driver
+ * @xfer: send JTAG xfer function. Filled by device driver
+ */
+struct jtag_ops {
+	int (*freq_get)(struct jtag *jtag, __u32 *freq);
+	int (*freq_set)(struct jtag *jtag, __u32 freq);
+	int (*status_get)(struct jtag *jtag, __u32 *state);
+	int (*idle)(struct jtag *jtag, struct jtag_run_test_idle *idle);
+	int (*xfer)(struct jtag *jtag, struct jtag_xfer *xfer);
+};
+
+void *jtag_priv(struct jtag *jtag);
+int jtag_register(struct jtag *jtag);
+void jtag_unregister(struct jtag *jtag);
+struct jtag *jtag_alloc(size_t priv_size, const struct jtag_ops *ops);
+void jtag_free(struct jtag *jtag);
+
+#endif /* __JTAG_H */
diff --git a/include/uapi/linux/jtag.h b/include/uapi/linux/jtag.h
new file mode 100644
index 0000000..78309c3
--- /dev/null
+++ b/include/uapi/linux/jtag.h
@@ -0,0 +1,113 @@
+/*
+ * JTAG class driver
+ *
+ * Copyright (c) 2017 Mellanox Technologies. All rights reserved.
+ * Copyright (c) 2017 Oleksandr Shamray <oleksandrs-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
+ *
+ * Released under the GPLv2/BSD.
+ * SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
+ */
+
+#ifndef __UAPI_LINUX_JTAG_H
+#define __UAPI_LINUX_JTAG_H
+
+#include <asm/types.h>
+
+/**
+ * enum jtag_xfer_mode:
+ *
+ * @JTAG_XFER_HW_MODE: hardware mode transfer
+ * @JTAG_XFER_SW_MODE: software mode transfer
+ */
+enum jtag_xfer_mode {
+	JTAG_XFER_HW_MODE,
+	JTAG_XFER_SW_MODE,
+};
+
+/**
+ * enum jtag_endstate:
+ *
+ * @JTAG_STATE_IDLE: JTAG state machine IDLE state
+ * @JTAG_STATE_PAUSEIR: JTAG state machine PAUSE_IR state
+ * @JTAG_STATE_PAUSEDR: JTAG state machine PAUSE_DR state
+ */
+enum jtag_endstate {
+	JTAG_STATE_IDLE,
+	JTAG_STATE_PAUSEIR,
+	JTAG_STATE_PAUSEDR,
+};
+
+/**
+ * enum jtag_xfer_type:
+ *
+ * @JTAG_SIR_XFER: SIR transfer
+ * @JTAG_SDR_XFER: SDR transfer
+ */
+enum jtag_xfer_type {
+	JTAG_SIR_XFER,
+	JTAG_SDR_XFER,
+};
+
+/**
+ * enum jtag_xfer_direction:
+ *
+ * @JTAG_READ_XFER: read transfer
+ * @JTAG_WRITE_XFER: write transfer
+ */
+enum jtag_xfer_direction {
+	JTAG_READ_XFER,
+	JTAG_WRITE_XFER,
+};
+
+/**
+ * struct jtag_run_test_idle - forces JTAG state machine to
+ * RUN_TEST/IDLE state
+ *
+ * @mode: access mode
+ * @reset: 0 - run IDLE/PAUSE from current state
+ *         1 - go through TEST_LOGIC/RESET state before  IDLE/PAUSE
+ * @end: completion flag
+ * @tck: clock counter
+ *
+ * Structure represents interface to JTAG device for jtag idle
+ * execution.
+ */
+struct jtag_run_test_idle {
+	__u8	mode;
+	__u8	reset;
+	__u8	endstate;
+	__u8	tck;
+};
+
+/**
+ * struct jtag_xfer - jtag xfer:
+ *
+ * @mode: access mode
+ * @type: transfer type
+ * @direction: xfer direction
+ * @length: xfer bits len
+ * @tdio : xfer data array
+ * @endir: xfer end state
+ *
+ * Structure represents interface to Aspeed JTAG device for jtag sdr xfer
+ * execution.
+ */
+struct jtag_xfer {
+	__u8	mode;
+	__u8	type;
+	__u8	direction;
+	__u8	endstate;
+	__u32	length;
+	__u64	tdio;
+};
+
+#define __JTAG_IOCTL_MAGIC	0xb2
+
+#define JTAG_IOCRUNTEST	_IOW(__JTAG_IOCTL_MAGIC, 0,\
+			     struct jtag_run_test_idle)
+#define JTAG_SIOCFREQ	_IOW(__JTAG_IOCTL_MAGIC, 1, unsigned int)
+#define JTAG_GIOCFREQ	_IOR(__JTAG_IOCTL_MAGIC, 2, unsigned int)
+#define JTAG_IOCXFER	_IOWR(__JTAG_IOCTL_MAGIC, 3, struct jtag_xfer)
+#define JTAG_GIOCSTATUS _IOWR(__JTAG_IOCTL_MAGIC, 4, enum jtag_endstate)
+
+#endif /* __UAPI_LINUX_JTAG_H */
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
