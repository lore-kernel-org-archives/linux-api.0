From: Wu Hao <hao.wu@intel.com>
Subject: [PATCH v5 10/28] fpga: dfl: add dfl_fpga_port_ops support.
Date: Wed,  2 May 2018 10:50:13 +0800
Message-ID: <1525229431-3087-11-git-send-email-hao.wu@intel.com>
References: <1525229431-3087-1-git-send-email-hao.wu@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1525229431-3087-1-git-send-email-hao.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: atull@kernel.org, mdf@kernel.org, linux-fpga@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, luwei.kang@intel.com, yi.z.zhang@intel.com, hao.wu@intel.com
List-Id: linux-api@vger.kernel.org

In some cases, other DFL driver modules may need to access some port
operations, e.g disable / enable port for partial reconfiguration in
FME module. In order to avoid dependency between port and FME modules,
this patch introduces the dfl_fpga_port_ops support in DFL framework.
A global dfl_fpga_port_ops list is added in the DFL framework, and
it allows other DFL modules to use these port operations registered
to this list, even in virtualization case, the port platform device
is turned into VF / guest VM and hidden in host, the registered
port_ops is still usable. It resolves the dependency issues between
modules, but once get port ops API returns a valid port ops, that
means related port driver module has been module_get to prevent from
unexpected unload, and put port ops API must be invoked after use.

These APIs introduced by this patch is listed below:
 * dfl_fpga_add_port_ops
   add one port ops to the global list.

 * dfl_fpga_del_port_ops
   del one port ops from the global list.

 * dfl_fpga_get_port_ops / dfl_fpga_put_port_ops
   get/put the port ops before/after use.

Signed-off-by: Wu Hao <hao.wu@intel.com>
---
 drivers/fpga/dfl.c | 67 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/fpga/dfl.h | 21 +++++++++++++++++
 2 files changed, 88 insertions(+)

diff --git a/drivers/fpga/dfl.c b/drivers/fpga/dfl.c
index c4c47d6..b5a14a4 100644
--- a/drivers/fpga/dfl.c
+++ b/drivers/fpga/dfl.c
@@ -14,6 +14,73 @@
 
 #include "dfl.h"
 
+static DEFINE_MUTEX(dfl_port_ops_mutex);
+static LIST_HEAD(dfl_port_ops_list);
+
+/**
+ * dfl_fpga_get_port_ops - get matched port ops from the global list
+ * @pdev: platform device to match with associated port ops.
+ * Return: matched port ops on success, NULL otherwise.
+ *
+ * Please note that must dfl_fpga_put_port_ops after use the port_ops.
+ */
+struct dfl_fpga_port_ops *dfl_fpga_get_port_ops(struct platform_device *pdev)
+{
+	struct dfl_fpga_port_ops *ops = NULL;
+
+	mutex_lock(&dfl_port_ops_mutex);
+	if (list_empty(&dfl_port_ops_list))
+		goto done;
+
+	list_for_each_entry(ops, &dfl_port_ops_list, node) {
+		/* match port_ops using the name of platform device */
+		if (!strcmp(pdev->name, ops->name)) {
+			if (!try_module_get(ops->owner))
+				ops = NULL;
+			goto done;
+		}
+	}
+done:
+	mutex_unlock(&dfl_port_ops_mutex);
+	return ops;
+}
+EXPORT_SYMBOL_GPL(dfl_fpga_get_port_ops);
+
+/**
+ * dfl_fpga_put_port_ops - put port ops
+ * @ops: port ops.
+ */
+void dfl_fpga_put_port_ops(struct dfl_fpga_port_ops *ops)
+{
+	if (ops && ops->owner)
+		module_put(ops->owner);
+}
+EXPORT_SYMBOL_GPL(dfl_fpga_put_port_ops);
+
+/**
+ * dfl_fpga_add_port_ops - add port_ops to global list
+ * @ops: port ops to add.
+ */
+void dfl_fpga_add_port_ops(struct dfl_fpga_port_ops *ops)
+{
+	mutex_lock(&dfl_port_ops_mutex);
+	list_add_tail(&ops->node, &dfl_port_ops_list);
+	mutex_unlock(&dfl_port_ops_mutex);
+}
+EXPORT_SYMBOL_GPL(dfl_fpga_add_port_ops);
+
+/**
+ * dfl_fpga_del_port_ops - remove port_ops from global list
+ * @ops: port ops to del.
+ */
+void dfl_fpga_del_port_ops(struct dfl_fpga_port_ops *ops)
+{
+	mutex_lock(&dfl_port_ops_mutex);
+	list_del(&ops->node);
+	mutex_unlock(&dfl_port_ops_mutex);
+}
+EXPORT_SYMBOL_GPL(dfl_fpga_del_port_ops);
+
 static DEFINE_MUTEX(dfl_id_mutex);
 
 enum dfl_id_type {
diff --git a/drivers/fpga/dfl.h b/drivers/fpga/dfl.h
index 27f7a74..c9d9a01 100644
--- a/drivers/fpga/dfl.h
+++ b/drivers/fpga/dfl.h
@@ -130,6 +130,27 @@
 /* Latency tolerance reporting. '1' >= 40us, '0' < 40us.*/
 #define PORT_CTRL_LATENCY	BIT_ULL(2)
 #define PORT_CTRL_SFTRST_ACK	BIT_ULL(4)		/* HW ack for reset */
+/**
+ * struct dfl_fpga_port_ops - port ops
+ *
+ * @name: name of this port ops, to match with port platform device.
+ * @owner: pointer to the module which owns this port ops.
+ * @node: node to link port ops to global list.
+ * @get_id: get port id from hardware.
+ * @enable_set: enable/disable the port.
+ */
+struct dfl_fpga_port_ops {
+	const char *name;
+	struct module *owner;
+	struct list_head node;
+	int (*get_id)(struct platform_device *pdev);
+	int (*enable_set)(struct platform_device *pdev, bool enable);
+};
+
+void dfl_fpga_add_port_ops(struct dfl_fpga_port_ops *ops);
+void dfl_fpga_del_port_ops(struct dfl_fpga_port_ops *ops);
+struct dfl_fpga_port_ops *dfl_fpga_get_port_ops(struct platform_device *pdev);
+void dfl_fpga_put_port_ops(struct dfl_fpga_port_ops *ops);
 
 /**
  * struct dfl_feature_driver - sub feature's driver
-- 
1.8.3.1
