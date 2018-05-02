From: Wu Hao <hao.wu@intel.com>
Subject: [PATCH v5 11/28] fpga: dfl: add dfl_fpga_check_port_id function.
Date: Wed,  2 May 2018 10:50:14 +0800
Message-ID: <1525229431-3087-12-git-send-email-hao.wu@intel.com>
References: <1525229431-3087-1-git-send-email-hao.wu@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1525229431-3087-1-git-send-email-hao.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: atull@kernel.org, mdf@kernel.org, linux-fpga@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, luwei.kang@intel.com, yi.z.zhang@intel.com, hao.wu@intel.com
List-Id: linux-api@vger.kernel.org

This patch adds one common function in DFL framework. It uses
port_ops get_id callback to get port id and compare it with given
value. This function could be used as match function of the
dfl_fpga_cdev_find_port function.

Signed-off-by: Wu Hao <hao.wu@intel.com>
---
 drivers/fpga/dfl.c | 22 ++++++++++++++++++++++
 drivers/fpga/dfl.h |  1 +
 2 files changed, 23 insertions(+)

diff --git a/drivers/fpga/dfl.c b/drivers/fpga/dfl.c
index b5a14a4..d47613c 100644
--- a/drivers/fpga/dfl.c
+++ b/drivers/fpga/dfl.c
@@ -81,6 +81,28 @@ void dfl_fpga_del_port_ops(struct dfl_fpga_port_ops *ops)
 }
 EXPORT_SYMBOL_GPL(dfl_fpga_del_port_ops);
 
+/**
+ * dfl_fpga_check_port_id - check the port id
+ * @pdev: port platform device.
+ * @pport_id: port id to compare.
+ *
+ * Return: 1 if port device matches with given port id, otherwise 0.
+ */
+int dfl_fpga_check_port_id(struct platform_device *pdev, void *pport_id)
+{
+	struct dfl_fpga_port_ops *port_ops = dfl_fpga_get_port_ops(pdev);
+	int port_id;
+
+	if (!port_ops || !port_ops->get_id)
+		return 0;
+
+	port_id = port_ops->get_id(pdev);
+	dfl_fpga_put_port_ops(port_ops);
+
+	return port_id == *(int *)pport_id;
+}
+EXPORT_SYMBOL_GPL(dfl_fpga_check_port_id);
+
 static DEFINE_MUTEX(dfl_id_mutex);
 
 enum dfl_id_type {
diff --git a/drivers/fpga/dfl.h b/drivers/fpga/dfl.h
index c9d9a01..b0d9b2f 100644
--- a/drivers/fpga/dfl.h
+++ b/drivers/fpga/dfl.h
@@ -151,6 +151,7 @@ struct dfl_fpga_port_ops {
 void dfl_fpga_del_port_ops(struct dfl_fpga_port_ops *ops);
 struct dfl_fpga_port_ops *dfl_fpga_get_port_ops(struct platform_device *pdev);
 void dfl_fpga_put_port_ops(struct dfl_fpga_port_ops *ops);
+int dfl_fpga_check_port_id(struct platform_device *pdev, void *pport_id);
 
 /**
  * struct dfl_feature_driver - sub feature's driver
-- 
1.8.3.1
