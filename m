From: Wu Hao <hao.wu@intel.com>
Subject: [PATCH v2 15/22] fpga: intel: add fpga manager platform driver for FME
Date: Mon, 26 Jun 2017 09:52:11 +0800
Message-ID: <1498441938-14046-16-git-send-email-hao.wu@intel.com>
References: <1498441938-14046-1-git-send-email-hao.wu@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1498441938-14046-1-git-send-email-hao.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: atull@kernel.org, mdf@kernel.org, linux-fpga@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, luwei.kang@intel.com, yi.z.zhang@intel.com, hao.wu@intel.com, Tim Whisonant <tim.whisonant@intel.com>, Enno Luebbers <enno.luebbers@intel.com>, Shiva Rao <shiva.rao@intel.com>, Christopher Rauer <christopher.rauer@intel.com>, Xiao Guangrong <guangrong.xiao@linux.intel.com>
List-Id: linux-api@vger.kernel.org

This patch adds fpga manager driver for Intel FPGA Management
Engine(FME). It implements fpga_manager_ops for FPGA Partial
Reconfiguration function.

Signed-off-by: Tim Whisonant <tim.whisonant@intel.com>
Signed-off-by: Enno Luebbers <enno.luebbers@intel.com>
Signed-off-by: Shiva Rao <shiva.rao@intel.com>
Signed-off-by: Christopher Rauer <christopher.rauer@intel.com>
Signed-off-by: Kang Luwei <luwei.kang@intel.com>
Signed-off-by: Xiao Guangrong <guangrong.xiao@linux.intel.com>
Signed-off-by: Wu Hao <hao.wu@intel.com>
---
 .../ABI/testing/sysfs-platform-intel-fpga-fme-mgr  |   8 +
 drivers/fpga/Kconfig                               |   7 +
 drivers/fpga/Makefile                              |   1 +
 drivers/fpga/intel-feature-dev.h                   |  75 +++++
 drivers/fpga/intel-fpga-fme-mgr.c                  | 307 +++++++++++++++++++++
 5 files changed, 398 insertions(+)
 create mode 100644 Documentation/ABI/testing/sysfs-platform-intel-fpga-fme-mgr
 create mode 100644 drivers/fpga/intel-fpga-fme-mgr.c

diff --git a/Documentation/ABI/testing/sysfs-platform-intel-fpga-fme-mgr b/Documentation/ABI/testing/sysfs-platform-intel-fpga-fme-mgr
new file mode 100644
index 0000000..40771fb
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-platform-intel-fpga-fme-mgr
@@ -0,0 +1,8 @@
+What:		/sys/bus/platform/devices/intel-fpga-fme-mgr.0/interface_id
+Date:		June 2017
+KernelVersion:  4.12
+Contact:	Wu Hao <hao.wu@intel.com>
+Description:	Read-only. It returns interface id of partial reconfiguration
+		hardware. Userspace could use this information to check if
+		current hardware is compatible with given image before FPGA
+		programming.
diff --git a/drivers/fpga/Kconfig b/drivers/fpga/Kconfig
index b91458f..6f2f623 100644
--- a/drivers/fpga/Kconfig
+++ b/drivers/fpga/Kconfig
@@ -151,6 +151,13 @@ config INTEL_FPGA_FME
 	  all FPGA platform level management features. There shall be 1
 	  FME per Intel FPGA.
 
+config INTEL_FPGA_FME_MGR
+	tristate "Intel FPGA FME Manager Driver"
+	depends on INTEL_FPGA_FME
+	help
+	  Say Y to enable FPGA Manager driver for Intel FPGA Management
+	  Engine.
+
 endif
 
 endif # FPGA
diff --git a/drivers/fpga/Makefile b/drivers/fpga/Makefile
index acda5ca..d1d588b 100644
--- a/drivers/fpga/Makefile
+++ b/drivers/fpga/Makefile
@@ -31,6 +31,7 @@ obj-$(CONFIG_OF_FPGA_REGION)		+= of-fpga-region.o
 # Intel FPGA Support
 obj-$(CONFIG_INTEL_FPGA_PCI)		+= intel-fpga-pci.o
 obj-$(CONFIG_INTEL_FPGA_FME)		+= intel-fpga-fme.o
+obj-$(CONFIG_INTEL_FPGA_FME_MGR)	+= intel-fpga-fme-mgr.o
 
 intel-fpga-pci-objs := intel-pcie.o intel-feature-dev.o
 intel-fpga-fme-objs := intel-fme-main.o intel-fme-pr.o
diff --git a/drivers/fpga/intel-feature-dev.h b/drivers/fpga/intel-feature-dev.h
index 3f97b75..f33923b 100644
--- a/drivers/fpga/intel-feature-dev.h
+++ b/drivers/fpga/intel-feature-dev.h
@@ -164,8 +164,83 @@ struct feature_fme_err {
 };
 
 /* FME Partial Reconfiguration Sub Feature Register Set */
+/* FME PR Control Register */
+struct feature_fme_pr_ctl {
+	union {
+		u64 csr;
+		struct {
+			u64 pr_reset:1;		/* Reset PR Engine */
+			u64 rsvdz1:3;
+			u64 pr_reset_ack:1;	/* Reset PR Engine Ack */
+			u64 rsvdz2:3;
+			u64 pr_regionid:2;	/* PR Region ID */
+			u64 rsvdz3:2;
+			u64 pr_start_req:1;	/* PR Start Request */
+			u64 pr_push_complete:1;	/* PR Data push complete */
+			u64 pr_kind:1;		/* Load Customer or Intel GBS */
+			u64 rsvdz4:17;
+			u64 config_data:32;
+		};
+	};
+};
+
+/* FME PR Status Register */
+struct feature_fme_pr_status {
+	union {
+		u64 csr;
+		struct {
+			u64 pr_credit:9;	/* Number of PR Credits */
+			u64 rsvdz1:7;
+			u64 pr_status:1;	/* PR Operation status */
+			u64 rsvdz2:3;
+			u64 pr_ctrlr_status:3;	/* Controller status */
+			u64 rsvdz3:1;
+			u64 pr_host_status:4;	/* PR Host status */
+			u64 rsvdz4:36;
+		};
+	};
+};
+
+/* FME PR Data Register */
+struct feature_fme_pr_data {
+	union {
+		u64 csr;
+		struct {
+			/* PR data from the raw-binary file */
+			u64 pr_data_raw:32;
+			u64 rsvd:32;
+		};
+	};
+};
+
+/* FME PR Error Register */
+struct feature_fme_pr_error {
+	union {
+		u64 csr;
+		struct {
+			u64 operation_err:1;	/* Previous PR error detected */
+			u64 crc_err:1;		/* CRC error detected */
+			u64 incompatiable_bs:1; /* Incompatiable Bitstream */
+			u64 protocol_err:1;	/* Data push protocol error */
+			u64 fifo_overflow:1;	/* Data fifo overflow */
+			u64 rsvdz1:1;
+			u64 secure_load_err:1;	/* Secure PR load error */
+			u64 rsvdz2:57;
+		};
+	};
+};
+
 struct feature_fme_pr {
 	struct feature_header header;
+	struct feature_fme_pr_ctl control;
+	struct feature_fme_pr_status status;
+	struct feature_fme_pr_data data;
+	struct feature_fme_pr_error error;
+
+	u64 rsvd[16];
+
+	u64 intfc_id_l;		/* PR interface Id Low */
+	u64 intfc_id_h;		/* PR interface Id High */
 };
 
 /* PORT Header Register Set */
diff --git a/drivers/fpga/intel-fpga-fme-mgr.c b/drivers/fpga/intel-fpga-fme-mgr.c
new file mode 100644
index 0000000..5f93dfb
--- /dev/null
+++ b/drivers/fpga/intel-fpga-fme-mgr.c
@@ -0,0 +1,307 @@
+/*
+ * FPGA Manager Driver for Intel FPGA Management Engine (FME)
+ *
+ * Copyright (C) 2017 Intel Corporation, Inc.
+ *
+ * Authors:
+ *   Kang Luwei <luwei.kang@intel.com>
+ *   Xiao Guangrong <guangrong.xiao@linux.intel.com>
+ *   Wu Hao <hao.wu@intel.com>
+ *   Joseph Grecco <joe.grecco@intel.com>
+ *   Enno Luebbers <enno.luebbers@intel.com>
+ *   Tim Whisonant <tim.whisonant@intel.com>
+ *   Ananda Ravuri <ananda.ravuri@intel.com>
+ *   Christopher Rauer <christopher.rauer@intel.com>
+ *   Henry Mitchel <henry.mitchel@intel.com>
+ *
+ * This work is licensed under the terms of the GNU GPL version 2. See
+ * the COPYING file in the top-level directory.
+ */
+
+#include <linux/module.h>
+#include <linux/iopoll.h>
+#include <linux/fpga/fpga-mgr.h>
+
+#include "intel-feature-dev.h"
+#include "intel-fme.h"
+
+#define PR_WAIT_TIMEOUT   8000000
+#define PR_HOST_STATUS_IDLE	0
+
+struct fme_mgr_priv {
+	void __iomem *ioaddr;
+};
+
+static ssize_t interface_id_show(struct device *dev,
+				 struct device_attribute *attr, char *buf)
+{
+	struct fpga_manager *mgr = dev_get_drvdata(dev);
+	struct fme_mgr_priv *priv = mgr->priv;
+	struct feature_fme_pr *fme_pr;
+	u64 intfc_id_l, intfc_id_h;
+
+	fme_pr = priv->ioaddr;
+
+	intfc_id_l = readq(&fme_pr->intfc_id_l);
+	intfc_id_h = readq(&fme_pr->intfc_id_h);
+
+	return scnprintf(buf, PAGE_SIZE, "%016llx%016llx\n",
+			(unsigned long long)intfc_id_h,
+			(unsigned long long)intfc_id_l);
+}
+static DEVICE_ATTR_RO(interface_id);
+
+static const struct attribute *fme_mgr_attrs[] = {
+	&dev_attr_interface_id.attr,
+	NULL,
+};
+
+static void fme_mgr_pr_update_status(struct fpga_manager *mgr,
+				     struct feature_fme_pr_error err)
+{
+	mgr->status = 0;
+
+	if (err.operation_err)
+		mgr->status |= FPGA_MGR_STATUS_OPERATION_ERR;
+	if (err.crc_err)
+		mgr->status |= FPGA_MGR_STATUS_CRC_ERR;
+	if (err.incompatiable_bs)
+		mgr->status |= FPGA_MGR_STATUS_INCOMPATIBLE_BS_ERR;
+	if (err.protocol_err)
+		mgr->status |= FPGA_MGR_STATUS_IP_PROTOCOL_ERR;
+	if (err.fifo_overflow)
+		mgr->status |= FPGA_MGR_STATUS_FIFO_OVERFLOW_ERR;
+	if (err.secure_load_err)
+		mgr->status |= FPGA_MGR_STATUS_SECURE_LOAD_ERR;
+}
+
+static u64 fme_mgr_pr_err_handle(struct feature_fme_pr *fme_pr)
+{
+	struct feature_fme_pr_status fme_pr_status;
+	struct feature_fme_pr_error fme_pr_error;
+
+	fme_pr_status.csr = readq(&fme_pr->status);
+	if (!fme_pr_status.pr_status)
+		return 0;
+
+	fme_pr_error.csr = readq(&fme_pr->error);
+	writeq(fme_pr_error.csr, &fme_pr->error);
+
+	return fme_pr_error.csr;
+}
+
+static int fme_mgr_write_init(struct fpga_manager *mgr,
+			      struct fpga_image_info *info,
+			      const char *buf, size_t count)
+{
+	struct device *dev = &mgr->dev;
+	struct fme_mgr_priv *priv = mgr->priv;
+	struct feature_fme_pr *fme_pr = priv->ioaddr;
+	struct feature_fme_pr_ctl fme_pr_ctl;
+	struct feature_fme_pr_status fme_pr_status;
+	struct feature_fme_pr_error fme_pr_err;
+
+	if (!(info->flags & FPGA_MGR_PARTIAL_RECONFIG)) {
+		dev_err(dev, "only support partial reconfiguration.\n");
+		return -EINVAL;
+	}
+
+	dev_dbg(dev, "resetting PR before initiated PR\n");
+
+	fme_pr_ctl.csr = readq(&fme_pr->control);
+	fme_pr_ctl.pr_reset = 1;
+	writeq(fme_pr_ctl.csr, &fme_pr->control);
+
+	if (readq_poll_timeout(&fme_pr->control, fme_pr_ctl.csr,
+			       (fme_pr_ctl.pr_reset_ack == 1),
+			       1, PR_WAIT_TIMEOUT)) {
+		dev_err(dev, "maximum PR timeout\n");
+		return -ETIMEDOUT;
+	}
+
+	fme_pr_ctl.csr = readq(&fme_pr->control);
+	fme_pr_ctl.pr_reset = 0;
+	writeq(fme_pr_ctl.csr, &fme_pr->control);
+
+	dev_dbg(dev,
+		"waiting for PR resource in HW to be initialized and ready\n");
+
+	fme_pr_status.pr_host_status = PR_HOST_STATUS_IDLE;
+
+	if (readq_poll_timeout(&fme_pr->status, fme_pr_status.csr,
+			(fme_pr_status.pr_host_status == PR_HOST_STATUS_IDLE),
+			1, PR_WAIT_TIMEOUT)) {
+		dev_err(dev, "maximum PR timeout\n");
+		return -ETIMEDOUT;
+	}
+
+	dev_dbg(dev, "check and clear previous PR error\n");
+	fme_pr_err.csr = fme_mgr_pr_err_handle(fme_pr);
+	if (fme_pr_err.csr)
+		dev_dbg(dev, "previous PR error detected %llx\n",
+			     (unsigned long long)fme_pr_err.csr);
+
+	/* Clear all PR errors */
+	fme_pr_err.csr = 0;
+	fme_mgr_pr_update_status(mgr, fme_pr_err);
+
+	dev_dbg(dev, "set PR port ID\n");
+
+	fme_pr_ctl.csr = readq(&fme_pr->control);
+	fme_pr_ctl.pr_regionid = info->region_id;
+	writeq(fme_pr_ctl.csr, &fme_pr->control);
+
+	return 0;
+}
+
+static int fme_mgr_write(struct fpga_manager *mgr,
+			 const char *buf, size_t count)
+{
+	struct device *dev = &mgr->dev;
+	struct fme_mgr_priv *priv = mgr->priv;
+	struct feature_fme_pr *fme_pr = priv->ioaddr;
+	struct feature_fme_pr_ctl fme_pr_ctl;
+	struct feature_fme_pr_status fme_pr_status;
+	struct feature_fme_pr_data fme_pr_data;
+	int delay, pr_credit, i = 0;
+
+	dev_dbg(dev, "start request\n");
+
+	fme_pr_ctl.csr = readq(&fme_pr->control);
+	fme_pr_ctl.pr_start_req = 1;
+	writeq(fme_pr_ctl.csr, &fme_pr->control);
+
+	dev_dbg(dev, "pushing data from bitstream to HW\n");
+
+	fme_pr_status.csr = readq(&fme_pr->status);
+	pr_credit = fme_pr_status.pr_credit;
+
+	while (count > 0) {
+		delay = 0;
+		while (pr_credit <= 1) {
+			if (delay++ > PR_WAIT_TIMEOUT) {
+				dev_err(dev, "maximum try\n");
+				return -ETIMEDOUT;
+			}
+			udelay(1);
+
+			fme_pr_status.csr = readq(&fme_pr->status);
+			pr_credit = fme_pr_status.pr_credit;
+		};
+
+		if (count >= 4) {
+			fme_pr_data.rsvd = 0;
+			fme_pr_data.pr_data_raw = *(((u32 *)buf) + i);
+			writeq(fme_pr_data.csr, &fme_pr->data);
+			count -= 4;
+			pr_credit--;
+			i++;
+		} else {
+			WARN_ON(1);
+			return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+
+static int fme_mgr_write_complete(struct fpga_manager *mgr,
+				  struct fpga_image_info *info)
+{
+	struct device *dev = &mgr->dev;
+	struct fme_mgr_priv *priv = mgr->priv;
+	struct feature_fme_pr *fme_pr = priv->ioaddr;
+	struct feature_fme_pr_ctl fme_pr_ctl;
+	struct feature_fme_pr_error fme_pr_err;
+
+	fme_pr_ctl.csr = readq(&fme_pr->control);
+	fme_pr_ctl.pr_push_complete = 1;
+	writeq(fme_pr_ctl.csr, &fme_pr->control);
+
+	dev_dbg(dev, "green bitstream push complete\n");
+	dev_dbg(dev, "waiting for HW to release PR resource\n");
+
+	fme_pr_ctl.pr_start_req = 0;
+
+	if (readq_poll_timeout(&fme_pr->control, fme_pr_ctl.csr,
+			       (fme_pr_ctl.pr_start_req == 0),
+			       1, PR_WAIT_TIMEOUT)) {
+		dev_err(dev, "maximum try.\n");
+		return -ETIMEDOUT;
+	}
+
+	dev_dbg(dev, "PR operation complete, checking status\n");
+	fme_pr_err.csr = fme_mgr_pr_err_handle(fme_pr);
+	if (fme_pr_err.csr) {
+		fme_mgr_pr_update_status(mgr, fme_pr_err);
+		return -EIO;
+	}
+
+	dev_dbg(dev, "PR done successfully\n");
+	return 0;
+}
+
+static enum fpga_mgr_states fme_mgr_state(struct fpga_manager *mgr)
+{
+	return FPGA_MGR_STATE_UNKNOWN;
+}
+
+static const struct fpga_manager_ops fme_mgr_ops = {
+	.write_init = fme_mgr_write_init,
+	.write = fme_mgr_write,
+	.write_complete = fme_mgr_write_complete,
+	.state = fme_mgr_state,
+};
+
+static int fme_mgr_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct fme_mgr_priv *priv;
+	struct resource *res;
+	int ret;
+
+	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	priv->ioaddr = devm_ioremap(dev, res->start, resource_size(res));
+	if (IS_ERR(priv->ioaddr))
+		return PTR_ERR(priv->ioaddr);
+
+	ret = sysfs_create_files(&pdev->dev.kobj, fme_mgr_attrs);
+	if (ret)
+		return ret;
+
+	ret = fpga_mgr_register(dev, "Intel FPGA Manager", &fme_mgr_ops, priv);
+	if (ret) {
+		dev_err(dev, "unable to register FPGA manager\n");
+		sysfs_remove_files(&pdev->dev.kobj, fme_mgr_attrs);
+		return ret;
+	}
+
+	return 0;
+}
+
+static int fme_mgr_remove(struct platform_device *pdev)
+{
+	fpga_mgr_unregister(&pdev->dev);
+	sysfs_remove_files(&pdev->dev.kobj, fme_mgr_attrs);
+
+	return 0;
+}
+
+static struct platform_driver fme_mgr_driver = {
+	.driver	= {
+		.name    = INTEL_FPGA_FME_MGR,
+	},
+	.probe   = fme_mgr_probe,
+	.remove  = fme_mgr_remove,
+};
+
+module_platform_driver(fme_mgr_driver);
+
+MODULE_DESCRIPTION("FPGA Manager for Intel FPGA Management Engine");
+MODULE_AUTHOR("Intel Corporation");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:intel-fpga-fme-mgr");
-- 
1.8.3.1
