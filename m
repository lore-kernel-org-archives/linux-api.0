From: Azael Avalos <coproscefalo-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] toshiba_acpi: Add /dev/toshiba_acpi device
Date: Thu, 16 Jul 2015 17:32:44 -0600
Message-ID: <1437089564-4242-1-git-send-email-coproscefalo@gmail.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Darren Hart <dvhart-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Jonathan Buzzard <jonathan-kE54VaY6i3ADXYZnReoRVg@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, platform-driver-x86-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Azael Avalos <coproscefalo-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

There were previous attempts to "merge" the toshiba SMM module to the
toshiba_acpi one, they were trying to imitate what the old toshiba
module does, however, some models (TOS1900 devices) come with a
"crippled" implementation and do not provide all the "features" a
"genuine" Toshiba BIOS does.

This patch adds a new device called toshiba_acpi, which aim is to
enable userspace to access the SMM on Toshiba laptops via ACPI calls.

Creating a new convenience _IOWR command to access the SCI functions
by opening/closing the SCI internally to avoid buggy BIOS, while at
the same time providing backwards compatibility.

Older programs who wish to access the SMM on newer models can do it
without much code change, as the toshiba.h header was modified to
reflect these changes as well as adds all the toshiba_acpi paths
and commands.

Signed-off-by: Azael Avalos <coproscefalo-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 Documentation/ioctl/ioctl-number.txt |  2 +-
 drivers/platform/x86/toshiba_acpi.c  | 91 ++++++++++++++++++++++++++++++++++++
 include/uapi/linux/toshiba.h         | 32 +++++++++++--
 3 files changed, 121 insertions(+), 4 deletions(-)

diff --git a/Documentation/ioctl/ioctl-number.txt b/Documentation/ioctl/ioctl-number.txt
index 51f4221..18babaf 100644
--- a/Documentation/ioctl/ioctl-number.txt
+++ b/Documentation/ioctl/ioctl-number.txt
@@ -263,7 +263,7 @@ Code  Seq#(hex)	Include File		Comments
 's'	all	linux/cdk.h
 't'	00-7F	linux/ppp-ioctl.h
 't'	80-8F	linux/isdn_ppp.h
-'t'	90	linux/toshiba.h
+'t'	90-91	linux/toshiba.h		toshiba and toshiba_acpi SMM
 'u'	00-1F	linux/smb_fs.h		gone
 'u'	20-3F	linux/uvcvideo.h	USB video class host driver
 'v'	00-1F	linux/ext2_fs.h		conflict!
diff --git a/drivers/platform/x86/toshiba_acpi.c b/drivers/platform/x86/toshiba_acpi.c
index 58d6119..dc4255b 100644
--- a/drivers/platform/x86/toshiba_acpi.c
+++ b/drivers/platform/x86/toshiba_acpi.c
@@ -50,6 +50,8 @@
 #include <linux/acpi.h>
 #include <linux/dmi.h>
 #include <linux/uaccess.h>
+#include <linux/miscdevice.h>
+#include <linux/toshiba.h>
 #include <acpi/video.h>
 
 MODULE_AUTHOR("John Belmonte");
@@ -170,6 +172,7 @@ struct toshiba_acpi_dev {
 	struct led_classdev led_dev;
 	struct led_classdev kbd_led;
 	struct led_classdev eco_led;
+	struct miscdevice miscdev;
 
 	int force_fan;
 	int last_key_event;
@@ -2262,6 +2265,81 @@ static struct attribute_group toshiba_attr_group = {
 };
 
 /*
+ * Misc device
+ */
+static int toshiba_acpi_smm_bridge(SMMRegisters *regs)
+{
+	u32 in[TCI_WORDS] = { regs->eax, regs->ebx, regs->ecx,
+			      regs->edx, regs->esi, regs->edi };
+	u32 out[TCI_WORDS];
+	acpi_status status;
+
+	status = tci_raw(toshiba_acpi, in, out);
+	if (ACPI_FAILURE(status)) {
+		pr_err("ACPI call to query TCI registers failed\n");
+		return -EIO;
+	}
+
+	/* Fillout the SMM struct with the TCI call results */
+	regs->eax = out[0];
+	regs->ebx = out[1];
+	regs->ecx = out[2];
+	regs->edx = out[3];
+	regs->esi = out[4];
+	regs->edi = out[5];
+
+	return 0;
+}
+
+static long toshiba_acpi_ioctl(struct file *fp, unsigned int cmd,
+			       unsigned long arg)
+{
+	SMMRegisters __user *argp = (SMMRegisters __user *)arg;
+	SMMRegisters regs;
+	int ret;
+
+	if (!argp)
+		return -EINVAL;
+
+	switch (cmd) {
+	case TOSH_SMM:
+		if (copy_from_user(&regs, argp, sizeof(SMMRegisters)))
+			return -EFAULT;
+		ret = toshiba_acpi_smm_bridge(&regs);
+		if (ret)
+			return ret;
+		if (copy_to_user(argp, &regs, sizeof(SMMRegisters)))
+			return -EFAULT;
+		break;
+	case TOSHIBA_ACPI_SCI:
+		if (copy_from_user(&regs, argp, sizeof(SMMRegisters)))
+			return -EFAULT;
+		/* Ensure we are being called with a SCI_{GET, SET} register */
+		if (regs.eax != SCI_GET && regs.eax != SCI_SET)
+			return -EINVAL;
+		if (!sci_open(toshiba_acpi))
+			return -EIO;
+		ret = toshiba_acpi_smm_bridge(&regs);
+		sci_close(toshiba_acpi);
+		if (ret)
+			return ret;
+		if (copy_to_user(argp, &regs, sizeof(SMMRegisters)))
+			return -EFAULT;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static const struct file_operations toshiba_acpi_fops = {
+	.owner		= THIS_MODULE,
+	.unlocked_ioctl = toshiba_acpi_ioctl,
+	.llseek		= noop_llseek,
+};
+
+/*
  * Hotkeys
  */
 static int toshiba_acpi_enable_hotkeys(struct toshiba_acpi_dev *dev)
@@ -2559,6 +2637,8 @@ static int toshiba_acpi_remove(struct acpi_device *acpi_dev)
 {
 	struct toshiba_acpi_dev *dev = acpi_driver_data(acpi_dev);
 
+	misc_deregister(&dev->miscdev);
+
 	remove_toshiba_proc_entries(dev);
 
 	if (dev->sysfs_created)
@@ -2630,6 +2710,17 @@ static int toshiba_acpi_add(struct acpi_device *acpi_dev)
 		return -ENOMEM;
 	dev->acpi_dev = acpi_dev;
 	dev->method_hci = hci_method;
+	dev->miscdev.minor = MISC_DYNAMIC_MINOR;
+	dev->miscdev.name = "toshiba_acpi";
+	dev->miscdev.fops = &toshiba_acpi_fops;
+
+	ret = misc_register(&dev->miscdev);
+	if (ret) {
+		pr_err("Failed to register miscdevice\n");
+		kfree(dev);
+		return ret;
+	}
+
 	acpi_dev->driver_data = dev;
 	dev_set_drvdata(&acpi_dev->dev, dev);
 
diff --git a/include/uapi/linux/toshiba.h b/include/uapi/linux/toshiba.h
index e9bef5b..c58bf4b 100644
--- a/include/uapi/linux/toshiba.h
+++ b/include/uapi/linux/toshiba.h
@@ -1,6 +1,7 @@
 /* toshiba.h -- Linux driver for accessing the SMM on Toshiba laptops 
  *
  * Copyright (c) 1996-2000  Jonathan A. Buzzard (jonathan-kE54VaY6i3ADXYZnReoRVg@public.gmane.org)
+ * Copyright (c) 2015  Azael Avalos <coproscefalo-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
  *
  * Thanks to Juergen Heinzl <juergen-f29ozuUdGaZwQVkoCiQKlSp2UmYkHbXO@public.gmane.org> for the pointers
  * on making sure the structure is aligned and packed.
@@ -20,9 +21,18 @@
 #ifndef _UAPI_LINUX_TOSHIBA_H
 #define _UAPI_LINUX_TOSHIBA_H
 
-#define TOSH_PROC "/proc/toshiba"
-#define TOSH_DEVICE "/dev/toshiba"
-#define TOSH_SMM _IOWR('t', 0x90, int)	/* broken: meant 24 bytes */
+/*
+ * Toshiba modules paths
+ */
+
+#define TOSH_PROC		"/proc/toshiba"
+#define TOSH_DEVICE		"/dev/toshiba"
+#define TOSHIBA_ACPI_PROC	"/proc/acpi/toshiba"
+#define TOSHIBA_ACPI_DEVICE	"/dev/toshiba_acpi"
+
+/*
+ * Toshiba SMM structure
+ */
 
 typedef struct {
 	unsigned int eax;
@@ -33,5 +43,21 @@ typedef struct {
 	unsigned int edi __attribute__ ((packed));
 } SMMRegisters;
 
+/*
+ * IOCTLs (0x90 - 0x91)
+ */
+
+#define TOSH_SMM		_IOWR('t', 0x90, SMMRegisters)
+/*
+ * Convenience toshiba_acpi command.
+ *
+ * The System Configuration Interface (SCI) is opened/closed internally
+ * to avoid userspace of buggy BIOSes.
+ *
+ * The toshiba_acpi module checks whether the eax register is set with
+ * SCI_GET (0xf300) or SCI_SET (0xf400), returning -EINVAL if not.
+ */
+#define TOSHIBA_ACPI_SCI	_IOWR('t', 0x91, SMMRegisters)
+
 
 #endif /* _UAPI_LINUX_TOSHIBA_H */
-- 
2.4.2
