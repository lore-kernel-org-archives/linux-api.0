From: Oleksandr Shamray <oleksandrs-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [patch v12 1/4] drivers: jtag: Add JTAG core driver
Date: Tue, 14 Nov 2017 18:11:04 +0200
Message-ID: <1510675867-24276-2-git-send-email-oleksandrs@mellanox.com>
References: <1510675867-24276-1-git-send-email-oleksandrs@mellanox.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1510675867-24276-1-git-send-email-oleksandrs-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, openbmc-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org, joel-U3u1mxZcP9KHXe+LvDLADg@public.gmane.org, jiri-rHqAuBHg3fBzbRFIqnYvSA@public.gmane.org, tklauser-93Khv+1bN0NyDzI6CaY1VQ@public.gmane.org, linux-serial-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mec-WqBc5aa1uDFeoWH0uzbU5w@public.gmane.org, vadimp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, system-sw-low-level-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, openocd-devel-owner-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, mchehab-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Oleksandr Shamray <oleksandrs-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jiri Pirko <jiri-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Initial patch for JTAG driver
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
v11->v12
Comments pointed by Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
- Change jtag.h licence type to
  SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note
  and reorder line with license in description

Chip Bilbrey <chip-Gz1Ta9Qd61ZAfugRpC6u6w@public.gmane.org>
- Remove Apeed reference from uapi jtag.h header
- Remove access mode from xfer and idle transactions
- Add new ioctl JTAG_SIOCMODE for set hw mode
- Add only one open per JTAG port blocking with mutex blocking

v10->v11
Notifications from kbuild test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
- include types.h headeri to jtag.h
- fix incompatible type of xfer callback
- remove rdundant class defination
- Fix return order in case of xfer error

V9->v10
Comments pointed by Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
- remove unnecessary alignment for pirv data
- move jtag_copy_to_user and jtag_copy_from_user code just to ioctl
- move int jtag_run_test_idle_op and jtag_xfer_op code
  just to ioctl
- change return error codes to more applicable
- add missing error checks
- fix error check order in ioctl
- remove unnecessary blank lines
- add param validation to ioctl
- remove compat_ioctl
- remove only one open per JTAG port blocking.
  User will care about this.
- Fix idr memory leak on jtag_exit
- change cdev device type to misc

V8->v9
Comments pointed by Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
- use get_user() instead of __get_user().
- change jtag->open type from int to atomic_t
- remove spinlock on jtg_open
- remove mutex on jtag_register
- add unregister_chrdev_region on jtag_init err
- add unregister_chrdev_region on jtag_exit
- remove unnecessary pointer casts
- add *data parameter to xfer function prototype

v7->v8
Comments pointed by Moritz Fischer <moritz.fischer-+aYTwkv1SeIAvxtiuMwx3w@public.gmane.org>
- Fix misspelling s/friver/driver

v6->v7
Notifications from kbuild test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
- Remove include asm/types.h from jtag.h
- Add include <linux/types.h> to jtag.c

v5->v6
v4->v5

v3->v4
Comments pointed by Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
- change transaction pointer tdio type  to __u64
- change internal status type from enum to __u32
- reorder jtag_xfer members to avoid the implied padding
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
 MAINTAINERS                          |   10 ++
 drivers/Kconfig                      |    2 +
 drivers/Makefile                     |    1 +
 drivers/jtag/Kconfig                 |   16 ++
 drivers/jtag/Makefile                |    1 +
 drivers/jtag/jtag.c                  |  292 ++++++++++++++++++++++++++++++++++
 include/linux/jtag.h                 |   46 ++++++
 include/uapi/linux/jtag.h            |  105 ++++++++++++
 9 files changed, 475 insertions(+), 0 deletions(-)
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
index 205d397..dfcf49c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7292,6 +7292,16 @@ L:	linux-serial-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
 S:	Maintained
 F:	drivers/tty/serial/jsm/
 
+JTAG SUBSYSTEM
+M:	Oleksandr Shamray <oleksandrs-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
+M:	Vadim Pasternak <vadimp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
+S:	Maintained
+F:	include/linux/jtag.h
+F:	include/uapi/linux/jtag.h
+F:	drivers/jtag/
+F:	Documentation/devicetree/bindings/jtag/
+F:	Documentation/ABI/testing/jtag-cdev
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
index 0000000..fbeba84
--- /dev/null
+++ b/drivers/jtag/jtag.c
@@ -0,0 +1,292 @@
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
+#include <linux/miscdevice.h>
+#include <linux/module.h>
+#include <linux/rtnetlink.h>
+#include <linux/spinlock.h>
+#include <linux/types.h>
+#include <uapi/linux/jtag.h>
+
+#define JTAG_NAME	"jtag0"
+#define MAX_JTAG_NAME_LEN (sizeof("jtag") + 5)
+
+struct jtag {
+	struct miscdevice miscdev;
+	struct device *dev;
+	const struct jtag_ops *ops;
+	int id;
+	bool opened;
+	struct mutex open_lock;
+	unsigned long priv[0];
+};
+
+static DEFINE_IDA(jtag_ida);
+
+void *jtag_priv(struct jtag *jtag)
+{
+	return jtag->priv;
+}
+EXPORT_SYMBOL_GPL(jtag_priv);
+
+static long jtag_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	struct jtag *jtag = file->private_data;
+	struct jtag_run_test_idle idle;
+	struct jtag_xfer xfer;
+	u8 *xfer_data;
+	u32 data_size;
+	u32 value;
+	int err;
+
+	if (!arg)
+		return -EINVAL;
+
+	switch (cmd) {
+	case JTAG_GIOCFREQ:
+
+		if (jtag->ops->freq_get)
+			err = jtag->ops->freq_get(jtag, &value);
+		else
+			err = -EOPNOTSUPP;
+		if (err)
+			break;
+
+		if (put_user(value, (__u32 *)arg))
+			err = -EFAULT;
+		break;
+
+	case JTAG_SIOCFREQ:
+		if (get_user(value, (__u32 *)arg))
+			return -EFAULT;
+		if (value == 0)
+			return -EINVAL;
+
+		if (jtag->ops->freq_set)
+			err = jtag->ops->freq_set(jtag, value);
+		else
+			err = -EOPNOTSUPP;
+		break;
+
+	case JTAG_IOCRUNTEST:
+		if (copy_from_user(&idle, (void *)arg,
+				   sizeof(struct jtag_run_test_idle)))
+			return -EFAULT;
+
+		if (idle.endstate > JTAG_STATE_PAUSEDR)
+			return -EINVAL;
+
+		if (jtag->ops->idle)
+			err = jtag->ops->idle(jtag, &idle);
+		else
+			err = -EOPNOTSUPP;
+		break;
+
+	case JTAG_IOCXFER:
+		if (copy_from_user(&xfer, (void *)arg,
+				   sizeof(struct jtag_xfer)))
+			return -EFAULT;
+
+		if (xfer.length >= JTAG_MAX_XFER_DATA_LEN)
+			return -EINVAL;
+
+		if (xfer.type > JTAG_SDR_XFER)
+			return -EINVAL;
+
+		if (xfer.direction > JTAG_WRITE_XFER)
+			return -EINVAL;
+
+		if (xfer.endstate > JTAG_STATE_PAUSEDR)
+			return -EINVAL;
+
+		data_size = DIV_ROUND_UP(xfer.length, BITS_PER_BYTE);
+		xfer_data = memdup_user(u64_to_user_ptr(xfer.tdio), data_size);
+
+		if (!xfer_data)
+			return -EFAULT;
+
+		if (jtag->ops->xfer) {
+			err = jtag->ops->xfer(jtag, &xfer, xfer_data);
+		} else {
+			kfree(xfer_data);
+			return -EOPNOTSUPP;
+		}
+
+		if (err) {
+			kfree(xfer_data);
+			return -EFAULT;
+		}
+
+		err = copy_to_user(u64_to_user_ptr(xfer.tdio),
+				   (void *)(xfer_data), data_size);
+
+		if (err) {
+			kfree(xfer_data);
+			return -EFAULT;
+		}
+
+		kfree(xfer_data);
+		if (copy_to_user((void *)arg, &xfer, sizeof(struct jtag_xfer)))
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
+		err = put_user(value, (__u32 *)arg);
+		if (err)
+			err = -EFAULT;
+		break;
+	case JTAG_SIOCMODE:
+		if (get_user(value, (__u32 *)arg))
+			return -EFAULT;
+		if (value == 0)
+			return -EINVAL;
+
+		if (jtag->ops->mode_set)
+			err = jtag->ops->mode_set(jtag, value);
+		else
+			err = -EOPNOTSUPP;
+		break;
+
+	default:
+		return -EINVAL;
+	}
+	return err;
+}
+
+static int jtag_open(struct inode *inode, struct file *file)
+{
+	struct jtag *jtag = container_of(file->private_data, struct jtag,
+					 miscdev);
+
+	if (mutex_lock_interruptible(&jtag->open_lock))
+		return -ERESTARTSYS;
+
+	if (jtag->opened) {
+		mutex_unlock(&jtag->open_lock);
+		return -EINVAL;
+	}
+
+	nonseekable_open(inode, file);
+	file->private_data = jtag;
+	jtag->opened = true;
+	mutex_unlock(&jtag->open_lock);
+	return 0;
+}
+
+static int jtag_release(struct inode *inode, struct file *file)
+{
+	struct jtag *jtag = file->private_data;
+
+	mutex_lock(&jtag->open_lock);
+	jtag->opened = false;
+	mutex_unlock(&jtag->open_lock);
+	return 0;
+}
+
+static const struct file_operations jtag_fops = {
+	.owner		= THIS_MODULE,
+	.open		= jtag_open,
+	.release	= jtag_release,
+	.llseek		= noop_llseek,
+	.unlocked_ioctl = jtag_ioctl,
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
+	char *name;
+	int err;
+	int id;
+
+	id = ida_simple_get(&jtag_ida, 0, 0, GFP_KERNEL);
+	if (id < 0)
+		return id;
+
+	jtag->id = id;
+
+	name = kzalloc(MAX_JTAG_NAME_LEN, GFP_KERNEL);
+	if (!name) {
+		err = -ENOMEM;
+		goto err_jtag_alloc;
+	}
+
+	err = snprintf(name, MAX_JTAG_NAME_LEN, "jtag%d", id);
+	if (err < 0)
+		goto err_jtag_name;
+
+	mutex_init(&jtag->open_lock);
+	jtag->miscdev.fops =  &jtag_fops;
+	jtag->miscdev.minor = MISC_DYNAMIC_MINOR;
+	jtag->miscdev.name = name;
+
+	err = misc_register(&jtag->miscdev);
+	if (err)
+		dev_err(jtag->dev, "Unable to register device\n");
+	else
+		return 0;
+	jtag->opened = false;
+
+err_jtag_name:
+	kfree(name);
+err_jtag_alloc:
+	ida_simple_remove(&jtag_ida, id);
+	return err;
+}
+EXPORT_SYMBOL_GPL(jtag_register);
+
+void jtag_unregister(struct jtag *jtag)
+{
+	misc_deregister(&jtag->miscdev);
+	kfree(jtag->miscdev.name);
+	ida_simple_remove(&jtag_ida, jtag->id);
+}
+EXPORT_SYMBOL_GPL(jtag_unregister);
+
+static void __exit jtag_exit(void)
+{
+	ida_destroy(&jtag_ida);
+}
+
+module_exit(jtag_exit);
+
+MODULE_AUTHOR("Oleksandr Shamray <oleksandrs-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>");
+MODULE_DESCRIPTION("Generic jtag support");
+MODULE_LICENSE("GPL v2");
diff --git a/include/linux/jtag.h b/include/linux/jtag.h
new file mode 100644
index 0000000..66b6389
--- /dev/null
+++ b/include/linux/jtag.h
@@ -0,0 +1,46 @@
+/* SPDX-License-Identifier: GPL-2.0
+ * include/linux/jtag.h - JTAG class driver
+ *
+ * Copyright (c) 2017 Mellanox Technologies. All rights reserved.
+ * Copyright (c) 2017 Oleksandr Shamray <oleksandrs-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
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
+	int (*freq_get)(struct jtag *jtag, u32 *freq);
+	int (*freq_set)(struct jtag *jtag, u32 freq);
+	int (*status_get)(struct jtag *jtag, u32 *state);
+	int (*idle)(struct jtag *jtag, struct jtag_run_test_idle *idle);
+	int (*xfer)(struct jtag *jtag, struct jtag_xfer *xfer, u8 *xfer_data);
+	int (*mode_set)(struct jtag *jtag, u32 mode_mask);
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
index 0000000..b6c4dde
--- /dev/null
+++ b/include/uapi/linux/jtag.h
@@ -0,0 +1,105 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note
+ * include/uapi/linux/jtag.h - JTAG class driver uapi
+ *
+ * Copyright (c) 2017 Mellanox Technologies. All rights reserved.
+ * Copyright (c) 2017 Oleksandr Shamray <oleksandrs-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
+ */
+
+#ifndef __UAPI_LINUX_JTAG_H
+#define __UAPI_LINUX_JTAG_H
+
+#include <linux/types.h>
+/*
+ * JTAG_XFER_HW_MODE: JTAG hardware mode. Used to set HW drived or bitbang
+ * mode. This is bitmask param of ioctl JTAG_SIOCMODE command
+ */
+#define  JTAG_XFER_HW_MODE 1
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
+ * @reset: 0 - run IDLE/PAUSE from current state
+ *         1 - go through TEST_LOGIC/RESET state before  IDLE/PAUSE
+ * @end: completion flag
+ * @tck: clock counter
+ *
+ * Structure represents interface to JTAG device for jtag idle
+ * execution.
+ */
+struct jtag_run_test_idle {
+	__u8	reset;
+	__u8	endstate;
+	__u8	tck;
+};
+
+/**
+ * struct jtag_xfer - jtag xfer:
+ *
+ * @type: transfer type
+ * @direction: xfer direction
+ * @length: xfer bits len
+ * @tdio : xfer data array
+ * @endir: xfer end state
+ *
+ * Structure represents interface to JTAG device for jtag sdr xfer
+ * execution.
+ */
+struct jtag_xfer {
+	__u8	type;
+	__u8	direction;
+	__u8	endstate;
+	__u32	length;
+	__u64	tdio;
+};
+
+/* ioctl interface */
+#define __JTAG_IOCTL_MAGIC	0xb2
+
+#define JTAG_IOCRUNTEST	_IOW(__JTAG_IOCTL_MAGIC, 0,\
+			     struct jtag_run_test_idle)
+#define JTAG_SIOCFREQ	_IOW(__JTAG_IOCTL_MAGIC, 1, unsigned int)
+#define JTAG_GIOCFREQ	_IOR(__JTAG_IOCTL_MAGIC, 2, unsigned int)
+#define JTAG_IOCXFER	_IOWR(__JTAG_IOCTL_MAGIC, 3, struct jtag_xfer)
+#define JTAG_GIOCSTATUS _IOWR(__JTAG_IOCTL_MAGIC, 4, enum jtag_endstate)
+#define JTAG_SIOCMODE	_IOW(__JTAG_IOCTL_MAGIC, 5, unsigned int)
+
+#define JTAG_FIRST_MINOR 0
+#define JTAG_MAX_DEVICES 32
+
+#endif /* __UAPI_LINUX_JTAG_H */
-- 
1.7.1
