From: Wu Hao <hao.wu@intel.com>
Subject: [PATCH v4 15/24] fpga: dfl-fme-pr: add compat_id support for dfl-fme-region platform device.
Date: Tue, 13 Feb 2018 17:24:44 +0800
Message-ID: <1518513893-4719-16-git-send-email-hao.wu@intel.com>
References: <1518513893-4719-1-git-send-email-hao.wu@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1518513893-4719-1-git-send-email-hao.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: atull@kernel.org, mdf@kernel.org, linux-fpga@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, luwei.kang@intel.com, yi.z.zhang@intel.com, hao.wu@intel.com
List-Id: linux-api@vger.kernel.org

This patch adds compat_id support when driver creates the platform
device for dfl-fme-region. It allows dfl-fme-region platform driver
to create fpga-region with correct compat_id.

Signed-off-by: Wu Hao <hao.wu@intel.com>
---
 drivers/fpga/dfl-fme-pr.c | 20 ++++++++++++++++++++
 drivers/fpga/dfl-fme-pr.h |  3 +++
 2 files changed, 23 insertions(+)

diff --git a/drivers/fpga/dfl-fme-pr.c b/drivers/fpga/dfl-fme-pr.c
index 526e90b..c17170b 100644
--- a/drivers/fpga/dfl-fme-pr.c
+++ b/drivers/fpga/dfl-fme-pr.c
@@ -314,6 +314,25 @@ static void fpga_fme_destroy_bridges(struct feature_platform_data *pdata)
 }
 
 /**
+ * fpga_fme_get_region_compat_id - read region compat_id from hardware
+ *
+ * @dev: fme device.
+ */
+static struct fpga_region_compat_id
+fpga_fme_get_region_compat_id(struct device *dev)
+{
+	struct fpga_region_compat_id compat_id;
+	void __iomem *fme_pr;
+
+	fme_pr = get_feature_ioaddr_by_id(dev, FME_FEATURE_ID_PR_MGMT);
+
+	compat_id.id_l = readq(fme_pr + FME_PR_INTFC_ID_L);
+	compat_id.id_h = readq(fme_pr + FME_PR_INTFC_ID_H);
+
+	return compat_id;
+}
+
+/**
  * fpga_fme_create_region - create fpga region platform device as child
  *
  * @pdata: fme platform device's pdata
@@ -339,6 +358,7 @@ fpga_fme_create_region(struct feature_platform_data *pdata,
 
 	region_pdata.mgr = mgr;
 	region_pdata.br = br;
+	region_pdata.compat_id = fpga_fme_get_region_compat_id(dev);
 
 	/*
 	 * Each FPGA device may have more than one port, so allocate platform
diff --git a/drivers/fpga/dfl-fme-pr.h b/drivers/fpga/dfl-fme-pr.h
index 11bd001..ef6c95a 100644
--- a/drivers/fpga/dfl-fme-pr.h
+++ b/drivers/fpga/dfl-fme-pr.h
@@ -19,6 +19,7 @@
 #define __DFL_FME_PR_H
 
 #include <linux/platform_device.h>
+#include <linux/fpga/fpga-region.h>
 
 /**
  * struct fme_region - FME fpga region data structure
@@ -39,11 +40,13 @@ struct fme_region {
  * @mgr: platform device of the FPGA manager.
  * @br: platform device of the FPGA bridge.
  * @region_id: region id (same as port_id).
+ * @compat_id: compat id of the FPGA region.
  */
 struct fme_region_pdata {
 	struct platform_device *mgr;
 	struct platform_device *br;
 	int region_id;
+	struct fpga_region_compat_id compat_id;
 };
 
 /**
-- 
2.7.4
