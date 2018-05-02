From: Wu Hao <hao.wu@intel.com>
Subject: [PATCH v5 19/28] fpga: dfl: fme-mgr: add compat_id support
Date: Wed,  2 May 2018 10:50:22 +0800
Message-ID: <1525229431-3087-20-git-send-email-hao.wu@intel.com>
References: <1525229431-3087-1-git-send-email-hao.wu@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1525229431-3087-1-git-send-email-hao.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: atull@kernel.org, mdf@kernel.org, linux-fpga@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, luwei.kang@intel.com, yi.z.zhang@intel.com, hao.wu@intel.com
List-Id: linux-api@vger.kernel.org

This patch adds compat_id support to fme manager driver, it
reads the ID from the hardware register. And it could be used
for compatibility check before partial reconfiguration.

Signed-off-by: Wu Hao <hao.wu@intel.com>
---
 drivers/fpga/dfl-fme-mgr.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/fpga/dfl-fme-mgr.c b/drivers/fpga/dfl-fme-mgr.c
index 1c5bc5a..afcdb39 100644
--- a/drivers/fpga/dfl-fme-mgr.c
+++ b/drivers/fpga/dfl-fme-mgr.c
@@ -272,9 +272,17 @@ static u64 fme_mgr_status(struct fpga_manager *mgr)
 	.status = fme_mgr_status,
 };
 
+static void fme_mgr_get_compat_id(void __iomem *fme_pr,
+				  struct fpga_compat_id *id)
+{
+	id->id_l = readq(fme_pr + FME_PR_INTFC_ID_L);
+	id->id_h = readq(fme_pr + FME_PR_INTFC_ID_H);
+}
+
 static int fme_mgr_probe(struct platform_device *pdev)
 {
 	struct dfl_fme_mgr_pdata *pdata = dev_get_platdata(&pdev->dev);
+	struct fpga_compat_id *compat_id;
 	struct device *dev = &pdev->dev;
 	struct fme_mgr_priv *priv;
 	struct fpga_manager *mgr;
@@ -295,11 +303,18 @@ static int fme_mgr_probe(struct platform_device *pdev)
 			return PTR_ERR(priv->ioaddr);
 	}
 
+	compat_id = devm_kzalloc(dev, sizeof(*compat_id), GFP_KERNEL);
+	if (!compat_id)
+		return -ENOMEM;
+
+	fme_mgr_get_compat_id(priv->ioaddr, compat_id);
+
 	mgr = fpga_mgr_create(dev, "DFL FME FPGA Manager",
 			      &fme_mgr_ops, priv);
 	if (!mgr)
 		return -ENOMEM;
 
+	mgr->compat_id = compat_id;
 	platform_set_drvdata(pdev, mgr);
 
 	ret = fpga_mgr_register(mgr);
-- 
1.8.3.1
