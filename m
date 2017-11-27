From: Wu Hao <hao.wu@intel.com>
Subject: [PATCH v3 12/21] fpga: dfl: fme: add FPGA_GET_API_VERSION/CHECK_EXTENSION ioctls support
Date: Mon, 27 Nov 2017 14:42:19 +0800
Message-ID: <1511764948-20972-13-git-send-email-hao.wu@intel.com>
References: <1511764948-20972-1-git-send-email-hao.wu@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1511764948-20972-1-git-send-email-hao.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: atull@kernel.org, mdf@kernel.org, linux-fpga@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, luwei.kang@intel.com, yi.z.zhang@intel.com, hao.wu@intel.com, Tim Whisonant <tim.whisonant@intel.com>, Enno Luebbers <enno.luebbers@intel.com>, Shiva Rao <shiva.rao@intel.com>, Christopher Rauer <christopher.rauer@intel.com>, Xiao Guangrong <guangrong.xiao@linux.intel.com>
List-Id: linux-api@vger.kernel.org

FPGA_GET_API_VERSION and FPGA_CHECK_EXTENSION ioctls are common ones which
need to be supported by all feature devices drivers including FME and AFU.
Userspace application can use these ioctl interfaces to get the API info
and check if specific extension is supported or not in current driver.

This patch implements above 2 ioctls in FPGA Management Engine (FME)
driver.

Signed-off-by: Tim Whisonant <tim.whisonant@intel.com>
Signed-off-by: Enno Luebbers <enno.luebbers@intel.com>
Signed-off-by: Shiva Rao <shiva.rao@intel.com>
Signed-off-by: Christopher Rauer <christopher.rauer@intel.com>
Signed-off-by: Xiao Guangrong <guangrong.xiao@linux.intel.com>
Signed-off-by: Wu Hao <hao.wu@intel.com>
----
v2: switched to GPLv2 license.
v3: rename intel-fpga.h to fpga-dfl.h and rebased.
---
 Documentation/ioctl/ioctl-number.txt |  1 +
 drivers/fpga/dfl-fme-main.c          | 12 +++++++++
 include/uapi/linux/fpga-dfl.h        | 50 ++++++++++++++++++++++++++++++++++++
 3 files changed, 63 insertions(+)
 create mode 100644 include/uapi/linux/fpga-dfl.h

diff --git a/Documentation/ioctl/ioctl-number.txt b/Documentation/ioctl/ioctl-number.txt
index 3e3fdae..91ad573 100644
--- a/Documentation/ioctl/ioctl-number.txt
+++ b/Documentation/ioctl/ioctl-number.txt
@@ -324,6 +324,7 @@ Code  Seq#(hex)	Include File		Comments
 0xB3	00	linux/mmc/ioctl.h
 0xB4	00-0F	linux/gpio.h		<mailto:linux-gpio@vger.kernel.org>
 0xB5	00-0F	uapi/linux/rpmsg.h	<mailto:linux-remoteproc@vger.kernel.org>
+0xB6	all	linux/fpga-dfl.h
 0xC0	00-0F	linux/usb/iowarrior.h
 0xCA	00-0F	uapi/misc/cxl.h
 0xCA	80-BF	uapi/scsi/cxlflash_ioctl.h
diff --git a/drivers/fpga/dfl-fme-main.c b/drivers/fpga/dfl-fme-main.c
index d17c66a..b4e0b54 100644
--- a/drivers/fpga/dfl-fme-main.c
+++ b/drivers/fpga/dfl-fme-main.c
@@ -18,6 +18,7 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/fpga-dfl.h>
 
 #include "fpga-dfl.h"
 
@@ -108,6 +109,13 @@ static void fme_hdr_uinit(struct platform_device *pdev, struct feature *feature)
 	},
 };
 
+static long fme_ioctl_check_extension(struct feature_platform_data *pdata,
+				      unsigned long arg)
+{
+	/* No extension support for now */
+	return 0;
+}
+
 static int fme_open(struct inode *inode, struct file *filp)
 {
 	struct platform_device *fdev = fpga_inode_to_feature_dev(inode);
@@ -148,6 +156,10 @@ static long fme_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 	dev_dbg(&pdev->dev, "%s cmd 0x%x\n", __func__, cmd);
 
 	switch (cmd) {
+	case FPGA_GET_API_VERSION:
+		return FPGA_API_VERSION;
+	case FPGA_CHECK_EXTENSION:
+		return fme_ioctl_check_extension(pdata, arg);
 	default:
 		/*
 		 * Let sub-feature's ioctl function to handle the cmd
diff --git a/include/uapi/linux/fpga-dfl.h b/include/uapi/linux/fpga-dfl.h
new file mode 100644
index 0000000..b46d124
--- /dev/null
+++ b/include/uapi/linux/fpga-dfl.h
@@ -0,0 +1,50 @@
+/*
+ * Header File for FPGA DFL User API
+ *
+ * Copyright (C) 2017 Intel Corporation, Inc.
+ *
+ * Authors:
+ *   Kang Luwei <luwei.kang@intel.com>
+ *   Zhang Yi <yi.z.zhang@intel.com>
+ *   Wu Hao <hao.wu@intel.com>
+ *   Xiao Guangrong <guangrong.xiao@linux.intel.com>
+ *
+ * This work is licensed under the terms of the GNU GPL version 2.
+ * SPDX-License-Identifier: GPL-2.0
+ */
+
+#ifndef _UAPI_LINUX_FPGA_DFL_H
+#define _UAPI_LINUX_FPGA_DFL_H
+
+#define FPGA_API_VERSION 0
+
+/*
+ * The IOCTL interface for DFL based FPGA is designed for extensibility by
+ * embedding the structure length (argsz) and flags into structures passed
+ * between kernel and userspace. This design referenced the VFIO IOCTL
+ * interface (include/uapi/linux/vfio.h).
+ */
+
+#define FPGA_MAGIC 0xB6
+
+#define FPGA_BASE 0
+
+/**
+ * FPGA_GET_API_VERSION - _IO(FPGA_MAGIC, FPGA_BASE + 0)
+ *
+ * Report the version of the driver API.
+ * Return: Driver API Version.
+ */
+
+#define FPGA_GET_API_VERSION	_IO(FPGA_MAGIC, FPGA_BASE + 0)
+
+/**
+ * FPGA_CHECK_EXTENSION - _IO(FPGA_MAGIC, FPGA_BASE + 1)
+ *
+ * Check whether an extension is supported.
+ * Return: 0 if not supported, otherwise the extension is supported.
+ */
+
+#define FPGA_CHECK_EXTENSION	_IO(FPGA_MAGIC, FPGA_BASE + 1)
+
+#endif /* _UAPI_LINUX_FPGA_DFL_H */
-- 
1.8.3.1
