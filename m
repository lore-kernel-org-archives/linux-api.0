From: Wu Hao <hao.wu@intel.com>
Subject: [PATCH v3 06/21] fpga: dfl: adds fpga_cdev_find_port
Date: Mon, 27 Nov 2017 14:42:13 +0800
Message-ID: <1511764948-20972-7-git-send-email-hao.wu@intel.com>
References: <1511764948-20972-1-git-send-email-hao.wu@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1511764948-20972-1-git-send-email-hao.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: atull@kernel.org, mdf@kernel.org, linux-fpga@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, luwei.kang@intel.com, yi.z.zhang@intel.com, hao.wu@intel.com, Tim Whisonant <tim.whisonant@intel.com>, Enno Luebbers <enno.luebbers@intel.com>, Shiva Rao <shiva.rao@intel.com>, Christopher Rauer <christopher.rauer@intel.com>, Xiao Guangrong <guangrong.xiao@linux.intel.com>
List-Id: linux-api@vger.kernel.org

For feature devices, e.g FPGA Management Engine (FME), it may
require fpga_cdev_find_port function to find dedicate port for
further actions, so export this function from feature device
driver module.

Signed-off-by: Tim Whisonant <tim.whisonant@intel.com>
Signed-off-by: Enno Luebbers <enno.luebbers@intel.com>
Signed-off-by: Shiva Rao <shiva.rao@intel.com>
Signed-off-by: Christopher Rauer <christopher.rauer@intel.com>
Signed-off-by: Xiao Guangrong <guangrong.xiao@linux.intel.com>
Signed-off-by: Wu Hao <hao.wu@intel.com>
----
v3: s/fpga_for_each_port/fpga_cdev_find_port/
    move fpga_cdev_find_port to fpga-dfl module.
---
 drivers/fpga/fpga-dfl.c | 27 +++++++++++++++++++++++++++
 drivers/fpga/fpga-dfl.h | 16 ++++++++++++++++
 2 files changed, 43 insertions(+)

diff --git a/drivers/fpga/fpga-dfl.c b/drivers/fpga/fpga-dfl.c
index 9294c0a..ce03b17 100644
--- a/drivers/fpga/fpga-dfl.c
+++ b/drivers/fpga/fpga-dfl.c
@@ -873,6 +873,33 @@ void fpga_remove_feature_devs(struct fpga_cdev *cdev)
 }
 EXPORT_SYMBOL_GPL(fpga_remove_feature_devs);
 
+/**
+ * __fpga_cdev_find_port - find a port under given container device
+ * @cdev: container device
+ * @data: data passed to match function
+ * @match: match function used to find specific port from the port device list
+ *
+ * Find a port device under container device. This function needs to be
+ * invoked with lock held.
+ */
+struct platform_device *
+__fpga_cdev_find_port(struct fpga_cdev *cdev, void *data,
+		      int (*match)(struct platform_device *, void *))
+{
+	struct feature_platform_data *pdata;
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
+EXPORT_SYMBOL_GPL(__fpga_cdev_find_port);
+
 int fpga_port_id(struct platform_device *pdev)
 {
 	void __iomem *base;
diff --git a/drivers/fpga/fpga-dfl.h b/drivers/fpga/fpga-dfl.h
index e569a13..36e2394 100644
--- a/drivers/fpga/fpga-dfl.h
+++ b/drivers/fpga/fpga-dfl.h
@@ -375,4 +375,20 @@ struct fpga_cdev {
 struct fpga_cdev *fpga_enumerate_feature_devs(struct fpga_enum_info *info);
 void fpga_remove_feature_devs(struct fpga_cdev *cdev);
 
+struct platform_device *
+__fpga_cdev_find_port(struct fpga_cdev *cdev, void *data,
+		      int (*match)(struct platform_device *, void *));
+
+static inline struct platform_device *
+fpga_cdev_find_port(struct fpga_cdev *cdev, void *data,
+		    int (*match)(struct platform_device *, void *))
+{
+	struct platform_device *pdev;
+
+	mutex_lock(&cdev->lock);
+	pdev = __fpga_cdev_find_port(cdev, data, match);
+	mutex_unlock(&cdev->lock);
+
+	return pdev;
+}
 #endif /* __DFL_FPGA_H */
-- 
1.8.3.1
