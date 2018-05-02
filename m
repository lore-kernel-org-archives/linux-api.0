From: Wu Hao <hao.wu@intel.com>
Subject: [PATCH v5 16/28] fpga: dfl: fme: add DFL_FPGA_GET_API_VERSION/CHECK_EXTENSION ioctls support
Date: Wed,  2 May 2018 10:50:19 +0800
Message-ID: <1525229431-3087-17-git-send-email-hao.wu@intel.com>
References: <1525229431-3087-1-git-send-email-hao.wu@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1525229431-3087-1-git-send-email-hao.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: atull@kernel.org, mdf@kernel.org, linux-fpga@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, luwei.kang@intel.com, yi.z.zhang@intel.com, hao.wu@intel.com, Tim Whisonant <tim.whisonant@intel.com>, Enno Luebbers <enno.luebbers@intel.com>, Shiva Rao <shiva.rao@intel.com>, Christopher Rauer <christopher.rauer@intel.com>, Xiao Guangrong <guangrong.xiao@linux.intel.com>
List-Id: linux-api@vger.kernel.org

DFL_FPGA_GET_API_VERSION and DFL_FPGA_CHECK_EXTENSION ioctls are common
ones which need to be supported by all feature devices drivers including
FME and AFU. Userspace application can use these ioctl interfaces to get
the API info and check if specific extension is supported or not in
current driver.

This patch implements above 2 ioctls in FPGA Management Engine (FME)
driver.

Signed-off-by: Tim Whisonant <tim.whisonant@intel.com>
Signed-off-by: Enno Luebbers <enno.luebbers@intel.com>
Signed-off-by: Shiva Rao <shiva.rao@intel.com>
Signed-off-by: Christopher Rauer <christopher.rauer@intel.com>
Signed-off-by: Xiao Guangrong <guangrong.xiao@linux.intel.com>
Signed-off-by: Wu Hao <hao.wu@intel.com>
Acked-by: Alan Tull <atull@kernel.org>
Acked-by: Moritz Fischer <mdf@kernel.org>
---
v2: switched to GPLv2 license.
v3: rename intel-fpga.h to fpga-dfl.h and rebased.
v4: fix SPDX license issue.
    add Acked-by from Alan and Moritz.
v5: rebase due to DFL framework API naming changes.
    add DFL_ prefix to IOCTL APIs.
---
 Documentation/ioctl/ioctl-number.txt |  1 +
 drivers/fpga/dfl-fme-main.c          | 12 +++++++++
 include/uapi/linux/fpga-dfl.h        | 48 ++++++++++++++++++++++++++++++++++++
 3 files changed, 61 insertions(+)
 create mode 100644 include/uapi/linux/fpga-dfl.h

diff --git a/Documentation/ioctl/ioctl-number.txt b/Documentation/ioctl/ioctl-number.txt
index 84bb74d..9105755 100644
--- a/Documentation/ioctl/ioctl-number.txt
+++ b/Documentation/ioctl/ioctl-number.txt
@@ -323,6 +323,7 @@ Code  Seq#(hex)	Include File		Comments
 0xB3	00	linux/mmc/ioctl.h
 0xB4	00-0F	linux/gpio.h		<mailto:linux-gpio@vger.kernel.org>
 0xB5	00-0F	uapi/linux/rpmsg.h	<mailto:linux-remoteproc@vger.kernel.org>
+0xB6	all	linux/fpga-dfl.h
 0xC0	00-0F	linux/usb/iowarrior.h
 0xCA	00-0F	uapi/misc/cxl.h
 0xCA	10-2F	uapi/misc/ocxl.h
diff --git a/drivers/fpga/dfl-fme-main.c b/drivers/fpga/dfl-fme-main.c
index 368f1fc..6a59c07 100644
--- a/drivers/fpga/dfl-fme-main.c
+++ b/drivers/fpga/dfl-fme-main.c
@@ -16,6 +16,7 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/fpga-dfl.h>
 
 #include "dfl.h"
 
@@ -116,6 +117,13 @@ static ssize_t bitstream_metadata_show(struct device *dev,
 	},
 };
 
+static long fme_ioctl_check_extension(struct dfl_feature_platform_data *pdata,
+				      unsigned long arg)
+{
+	/* No extension support for now */
+	return 0;
+}
+
 static int fme_open(struct inode *inode, struct file *filp)
 {
 	struct platform_device *fdev = dfl_fpga_inode_to_feature_dev(inode);
@@ -156,6 +164,10 @@ static long fme_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 	dev_dbg(&pdev->dev, "%s cmd 0x%x\n", __func__, cmd);
 
 	switch (cmd) {
+	case DFL_FPGA_GET_API_VERSION:
+		return DFL_FPGA_API_VERSION;
+	case DFL_FPGA_CHECK_EXTENSION:
+		return fme_ioctl_check_extension(pdata, arg);
 	default:
 		/*
 		 * Let sub-feature's ioctl function to handle the cmd
diff --git a/include/uapi/linux/fpga-dfl.h b/include/uapi/linux/fpga-dfl.h
new file mode 100644
index 0000000..7585de0
--- /dev/null
+++ b/include/uapi/linux/fpga-dfl.h
@@ -0,0 +1,48 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
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
+ */
+
+#ifndef _UAPI_LINUX_FPGA_DFL_H
+#define _UAPI_LINUX_FPGA_DFL_H
+
+#define DFL_FPGA_API_VERSION 0
+
+/*
+ * The IOCTL interface for DFL based FPGA is designed for extensibility by
+ * embedding the structure length (argsz) and flags into structures passed
+ * between kernel and userspace. This design referenced the VFIO IOCTL
+ * interface (include/uapi/linux/vfio.h).
+ */
+
+#define DFL_FPGA_MAGIC 0xB6
+
+#define DFL_FPGA_BASE 0
+
+/**
+ * DFL_FPGA_GET_API_VERSION - _IO(DFL_FPGA_MAGIC, DFL_FPGA_BASE + 0)
+ *
+ * Report the version of the driver API.
+ * Return: Driver API Version.
+ */
+
+#define DFL_FPGA_GET_API_VERSION	_IO(DFL_FPGA_MAGIC, DFL_FPGA_BASE + 0)
+
+/**
+ * DFL_FPGA_CHECK_EXTENSION - _IO(DFL_FPGA_MAGIC, DFL_FPGA_BASE + 1)
+ *
+ * Check whether an extension is supported.
+ * Return: 0 if not supported, otherwise the extension is supported.
+ */
+
+#define DFL_FPGA_CHECK_EXTENSION	_IO(DFL_FPGA_MAGIC, DFL_FPGA_BASE + 1)
+
+#endif /* _UAPI_LINUX_FPGA_DFL_H */
-- 
1.8.3.1
