From: Wu Hao <hao.wu@intel.com>
Subject: [PATCH v5 7/9] fpga: dfl: afu: add STP (SignalTap) support
Date: Mon, 12 Aug 2019 10:50:02 +0800
Message-ID: <1565578204-13969-8-git-send-email-hao.wu@intel.com>
References: <1565578204-13969-1-git-send-email-hao.wu@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1565578204-13969-1-git-send-email-hao.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: gregkh@linuxfoundation.org, mdf@kernel.org, linux-fpga@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, linux-doc@vger.kernel.org, atull@kernel.org, Wu Hao <hao.wu@intel.com>, Xu Yilun <yilun.xu@intel.com>
List-Id: linux-api@vger.kernel.org

STP (SignalTap) is one of the private features under the port for
debugging. This patch adds private feature driver support for it
to allow userspace applications to mmap related mmio region and
provide STP service.

Signed-off-by: Xu Yilun <yilun.xu@intel.com>
Signed-off-by: Wu Hao <hao.wu@intel.com>
Acked-by: Moritz Fischer <mdf@kernel.org>
Acked-by: Alan Tull <atull@kernel.org>
Signed-off-by: Moritz Fischer <mdf@kernel.org>
---
v4: remove uinit callback which does nothing.
    remove dev_dbg in init callback function.
---
 drivers/fpga/dfl-afu-main.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/drivers/fpga/dfl-afu-main.c b/drivers/fpga/dfl-afu-main.c
index e11352a..e4a34dc 100644
--- a/drivers/fpga/dfl-afu-main.c
+++ b/drivers/fpga/dfl-afu-main.c
@@ -508,6 +508,27 @@ static int port_afu_init(struct platform_device *pdev,
 	.init = port_afu_init,
 };
 
+static int port_stp_init(struct platform_device *pdev,
+			 struct dfl_feature *feature)
+{
+	struct resource *res = &pdev->resource[feature->resource_index];
+
+	return afu_mmio_region_add(dev_get_platdata(&pdev->dev),
+				   DFL_PORT_REGION_INDEX_STP,
+				   resource_size(res), res->start,
+				   DFL_PORT_REGION_MMAP | DFL_PORT_REGION_READ |
+				   DFL_PORT_REGION_WRITE);
+}
+
+static const struct dfl_feature_id port_stp_id_table[] = {
+	{.id = PORT_FEATURE_ID_STP,},
+	{0,}
+};
+
+static const struct dfl_feature_ops port_stp_ops = {
+	.init = port_stp_init,
+};
+
 static struct dfl_feature_driver port_feature_drvs[] = {
 	{
 		.id_table = port_hdr_id_table,
@@ -522,6 +543,10 @@ static int port_afu_init(struct platform_device *pdev,
 		.ops = &port_err_ops,
 	},
 	{
+		.id_table = port_stp_id_table,
+		.ops = &port_stp_ops,
+	},
+	{
 		.ops = NULL,
 	}
 };
-- 
1.8.3.1
