From: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
Subject: [PATCH v2 2/4] of: overlay: kobjectify overlay objects
Date: Tue,  7 Apr 2015 22:23:50 +0300
Message-ID: <1428434632-13789-3-git-send-email-pantelis.antoniou@konsulko.com>
References: <1428434632-13789-1-git-send-email-pantelis.antoniou@konsulko.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1428434632-13789-1-git-send-email-pantelis.antoniou@konsulko.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Rob Herring <robherring2@gmail.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, Andrew Morton <akpm@linux-foundation.org>, Matt Porter <mporter@konsulko.com>, Koen Kooi <koen@dominion.thruhere.net>, Guenter Roeck <linux@roeck-us.net>, devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Pantelis Antoniou <pantelis.antoniou@konsulko.com>, Pantelis Antoniou <panto@antoniou-consulting.com>
List-Id: linux-api@vger.kernel.org

We are going to need the overlays to appear on sysfs with runtime
global properties (like master enable) so turn them into kobjects.

Signed-off-by: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
---
 drivers/of/base.c       |  5 +++++
 drivers/of/of_private.h |  9 +++++++++
 drivers/of/overlay.c    | 52 +++++++++++++++++++++++++++++++++++++++++++++++--
 3 files changed, 64 insertions(+), 2 deletions(-)

diff --git a/drivers/of/base.c b/drivers/of/base.c
index 69566b6..808f351 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -192,6 +192,7 @@ int __of_attach_node_sysfs(struct device_node *np)
 static int __init of_init(void)
 {
 	struct device_node *np;
+	int ret;
 
 	/* Create the kset, and register existing nodes */
 	mutex_lock(&of_mutex);
@@ -208,6 +209,10 @@ static int __init of_init(void)
 	if (of_root)
 		proc_symlink("device-tree", NULL, "/sys/firmware/devicetree/base");
 
+	ret = of_overlay_init();
+	if (ret != 0)
+		pr_warn("of_init: of_overlay_init failed!\n");
+
 	return 0;
 }
 core_initcall(of_init);
diff --git a/drivers/of/of_private.h b/drivers/of/of_private.h
index 8e882e7..120eb44 100644
--- a/drivers/of/of_private.h
+++ b/drivers/of/of_private.h
@@ -90,4 +90,13 @@ extern void __of_detach_node_sysfs(struct device_node *np);
 #define for_each_transaction_entry_reverse(_oft, _te) \
 	list_for_each_entry_reverse(_te, &(_oft)->te_list, node)
 
+#if defined(CONFIG_OF_OVERLAY)
+extern int of_overlay_init(void);
+#else
+static inline int of_overlay_init(void)
+{
+	return 0;
+}
+#endif
+
 #endif /* _LINUX_OF_PRIVATE_H */
diff --git a/drivers/of/overlay.c b/drivers/of/overlay.c
index dee9270..f17f5ef 100644
--- a/drivers/of/overlay.c
+++ b/drivers/of/overlay.c
@@ -20,6 +20,7 @@
 #include <linux/slab.h>
 #include <linux/err.h>
 #include <linux/idr.h>
+#include <linux/sysfs.h>
 
 #include "of_private.h"
 
@@ -51,6 +52,7 @@ struct of_overlay {
 	int count;
 	struct of_overlay_info *ovinfo_tab;
 	struct of_changeset cset;
+	struct kobject kobj;
 };
 
 static int of_overlay_apply_one(struct of_overlay *ov,
@@ -325,6 +327,24 @@ static int of_free_overlay_info(struct of_overlay *ov)
 static LIST_HEAD(ov_list);
 static DEFINE_IDR(ov_idr);
 
+static inline struct of_overlay *kobj_to_overlay(struct kobject *kobj)
+{
+	return container_of(kobj, struct of_overlay, kobj);
+}
+
+void of_overlay_release(struct kobject *kobj)
+{
+	struct of_overlay *ov = kobj_to_overlay(kobj);
+
+	kfree(ov);
+}
+
+static struct kobj_type of_overlay_ktype = {
+	.release = of_overlay_release,
+};
+
+static struct kset *ov_kset;
+
 /**
  * of_overlay_create() - Create and apply an overlay
  * @tree:	Device node containing all the overlays
@@ -350,6 +370,9 @@ int of_overlay_create(struct device_node *tree)
 
 	of_changeset_init(&ov->cset);
 
+	/* initialize kobject */
+	kobject_init(&ov->kobj, &of_overlay_ktype);
+
 	mutex_lock(&of_mutex);
 
 	id = idr_alloc(&ov_idr, ov, 0, 0, GFP_KERNEL);
@@ -385,6 +408,14 @@ int of_overlay_create(struct device_node *tree)
 		goto err_revert_overlay;
 	}
 
+	ov->kobj.kset = ov_kset;
+	err = kobject_add(&ov->kobj, NULL, "%d", id);
+	if (err != 0) {
+		pr_err("%s: kobject_add() failed for tree@%s\n",
+				__func__, tree->full_name);
+		goto err_cancel_overlay;
+	}
+
 	/* add to the tail of the overlay list */
 	list_add_tail(&ov->node, &ov_list);
 
@@ -392,6 +423,8 @@ int of_overlay_create(struct device_node *tree)
 
 	return id;
 
+err_cancel_overlay:
+	of_changeset_revert(&ov->cset);
 err_revert_overlay:
 err_abort_trans:
 	of_free_overlay_info(ov);
@@ -512,7 +545,9 @@ int of_overlay_destroy(int id)
 	of_free_overlay_info(ov);
 	idr_remove(&ov_idr, id);
 	of_changeset_destroy(&ov->cset);
-	kfree(ov);
+
+	kobject_del(&ov->kobj);
+	kobject_put(&ov->kobj);
 
 	err = 0;
 
@@ -542,7 +577,8 @@ int of_overlay_destroy_all(void)
 		of_changeset_revert(&ov->cset);
 		of_free_overlay_info(ov);
 		idr_remove(&ov_idr, ov->id);
-		kfree(ov);
+		kobject_del(&ov->kobj);
+		kobject_put(&ov->kobj);
 	}
 
 	mutex_unlock(&of_mutex);
@@ -550,3 +586,15 @@ int of_overlay_destroy_all(void)
 	return 0;
 }
 EXPORT_SYMBOL_GPL(of_overlay_destroy_all);
+
+/* called from of_init() */
+int of_overlay_init(void)
+{
+	int rc;
+
+	ov_kset = kset_create_and_add("overlays", NULL, &of_kset->kobj);
+	if (!ov_kset)
+		return -ENOMEM;
+
+	return 0;
+}
-- 
1.7.12
