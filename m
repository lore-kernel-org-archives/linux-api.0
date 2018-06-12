From: Wu Hao <hao.wu@intel.com>
Subject: [PATCH v6 08/29] fpga: dfl: add dfl_fpga_cdev_find_port
Date: Tue, 12 Jun 2018 18:10:22 +0800
Message-ID: <1528798243-2029-9-git-send-email-hao.wu@intel.com>
References: <1528798243-2029-1-git-send-email-hao.wu@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1528798243-2029-1-git-send-email-hao.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: atull@kernel.org, mdf@kernel.org, linux-fpga@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, luwei.kang@intel.com, yi.z.zhang@intel.com, hao.wu@intel.com, Tim Whisonant <tim.whisonant@intel.com>, Enno Luebbers <enno.luebbers@intel.com>, Shiva Rao <shiva.rao@intel.com>, Christopher Rauer <christopher.rauer@intel.com>, Xiao Guangrong <guangrong.xiao@linux.intel.com>
List-Id: linux-api@vger.kernel.org

For feature devices, we need a method to find the port dedicated
to the device. This patch adds a function dfl_fpga_cdev_find_port
for this purpose. e.g FPGA Management Engine (FME) Partial
Reconfiguration sub feature, it uses this function to find
dedicated port on the device for PR function implementation.

Signed-off-by: Tim Whisonant <tim.whisonant@intel.com>
Signed-off-by: Enno Luebbers <enno.luebbers@intel.com>
Signed-off-by: Shiva Rao <shiva.rao@intel.com>
Signed-off-by: Christopher Rauer <christopher.rauer@intel.com>
Signed-off-by: Xiao Guangrong <guangrong.xiao@linux.intel.com>
Signed-off-by: Wu Hao <hao.wu@intel.com>
Acked-by: Alan Tull <atull@kernel.org>
Acked-by: Moritz Fischer <mdf@kernel.org>
---
v3: s/fpga_for_each_port/fpga_cdev_find_port/
    move fpga_cdev_find_port to fpga-dfl module.
v4: improve description in commit message.
    add comments to remind user to put_device after use this function.
v5: add "dfl_" prefix to functions.
    improve function comments per suggestion from Alan Tull.
    add Acked-by from Alan and Moritz.
v6: reabse.
---
 drivers/fpga/dfl.c | 32 ++++++++++++++++++++++++++++++++
 drivers/fpga/dfl.h | 21 +++++++++++++++++++++
 2 files changed, 53 insertions(+)

diff --git a/drivers/fpga/dfl.c b/drivers/fpga/dfl.c
index 702b3ce..5db4d11 100644
--- a/drivers/fpga/dfl.c
+++ b/drivers/fpga/dfl.c
@@ -813,6 +813,38 @@ void dfl_fpga_feature_devs_remove(struct dfl_fpga_cdev *cdev)
 }
 EXPORT_SYMBOL_GPL(dfl_fpga_feature_devs_remove);
 
+/**
+ * __dfl_fpga_cdev_find_port - find a port under given container device
+ *
+ * @cdev: container device
+ * @data: data passed to match function
+ * @match: match function used to find specific port from the port device list
+ *
+ * Find a port device under container device. This function needs to be
+ * invoked with lock held.
+ *
+ * Return: pointer to port's platform device if successful, NULL otherwise.
+ *
+ * NOTE: you will need to drop the device reference with put_device() after use.
+ */
+struct platform_device *
+__dfl_fpga_cdev_find_port(struct dfl_fpga_cdev *cdev, void *data,
+			  int (*match)(struct platform_device *, void *))
+{
+	struct dfl_feature_platform_data *pdata;
+	struct platform_device *port_dev;
+
+	list_for_each_entry(pdata, &cdev->port_dev_list, node) {
+		port_dev = pdata->dev;
+
+		if (match(port_dev, data) && get_device(&port_dev->dev))
+			return port_dev;
+	}
+
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(__dfl_fpga_cdev_find_port);
+
 static int __init dfl_fpga_init(void)
 {
 	int ret;
diff --git a/drivers/fpga/dfl.h b/drivers/fpga/dfl.h
index 66c2ade..b4f6525 100644
--- a/drivers/fpga/dfl.h
+++ b/drivers/fpga/dfl.h
@@ -284,4 +284,25 @@ struct dfl_fpga_cdev *
 dfl_fpga_feature_devs_enumerate(struct dfl_fpga_enum_info *info);
 void dfl_fpga_feature_devs_remove(struct dfl_fpga_cdev *cdev);
 
+/*
+ * need to drop the device reference with put_device() after use port platform
+ * device returned by __dfl_fpga_cdev_find_port and dfl_fpga_cdev_find_port
+ * functions.
+ */
+struct platform_device *
+__dfl_fpga_cdev_find_port(struct dfl_fpga_cdev *cdev, void *data,
+			  int (*match)(struct platform_device *, void *));
+
+static inline struct platform_device *
+dfl_fpga_cdev_find_port(struct dfl_fpga_cdev *cdev, void *data,
+			int (*match)(struct platform_device *, void *))
+{
+	struct platform_device *pdev;
+
+	mutex_lock(&cdev->lock);
+	pdev = __dfl_fpga_cdev_find_port(cdev, data, match);
+	mutex_unlock(&cdev->lock);
+
+	return pdev;
+}
 #endif /* __FPGA_DFL_H */
-- 
1.8.3.1
