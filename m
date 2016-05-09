From: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
Subject: [PATCH v8 1/6] of: overlay: kobjectify overlay objects
Date: Mon,  9 May 2016 16:09:58 +0300
Message-ID: <1462799403-10083-2-git-send-email-pantelis.antoniou@konsulko.com>
References: <1462799403-10083-1-git-send-email-pantelis.antoniou@konsulko.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1462799403-10083-1-git-send-email-pantelis.antoniou@konsulko.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Rob Herring <robherring2@gmail.com>
Cc: Frank Rowand <frowand.list@gmail.com>, Matt Porter <mporter@konsulko.com>, Koen Kooi <koen@dominion.thruhere.net>, Guenter Roeck <linux@roeck-us.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Pantelis Antoniou <pantelis.antoniou@konsulko.com>, Pantelis Antoniou <panto@antoniou-consulting.com>
List-Id: linux-api@vger.kernel.org

We are going to need the overlays to appear on sysfs with runtime
global properties (like master enable) so turn them into kobjects.

They have to be in sysfs so that people can have information about the
overlays applied in the system, i.e. where their targets are and whether
removal is possible. In a future more attributes can be added
in a backwards compatible manner.

Signed-off-by: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/of/base.c       |  5 +++++
 drivers/of/of_private.h |  9 +++++++++
 drivers/of/overlay.c    | 50 +++++++++++++++++++++++++++++++++++++++++++++++--
 3 files changed, 62 insertions(+), 2 deletions(-)

diff --git a/drivers/of/base.c b/drivers/of/base.c
index b299de2..9bbca56 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -192,6 +192,7 @@ int __of_attach_node_sysfs(struct device_node *np)
 void __init of_core_init(void)
 {
 	struct device_node *np;
+	int ret;
 
 	/* Create the kset, and register existing nodes */
 	mutex_lock(&of_mutex);
@@ -208,6 +209,10 @@ void __init of_core_init(void)
 	/* Symlink in /proc as required by userspace ABI */
 	if (of_root)
 		proc_symlink("device-tree", NULL, "/sys/firmware/devicetree/base");
+
+	ret = of_overlay_init();
+	if (ret != 0)
+		pr_warn("of_init: of_overlay_init failed!\n");
 }
 
 static struct property *__of_find_property(const struct device_node *np,
diff --git a/drivers/of/of_private.h b/drivers/of/of_private.h
index 829469f..092cba7 100644
--- a/drivers/of/of_private.h
+++ b/drivers/of/of_private.h
@@ -92,4 +92,13 @@ extern void __of_detach_node_sysfs(struct device_node *np);
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
index 8225081..4e06c34 100644
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
@@ -326,6 +328,24 @@ static int of_free_overlay_info(struct of_overlay *ov)
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
@@ -351,6 +371,9 @@ int of_overlay_create(struct device_node *tree)
 
 	of_changeset_init(&ov->cset);
 
+	/* initialize kobject */
+	kobject_init(&ov->kobj, &of_overlay_ktype);
+
 	mutex_lock(&of_mutex);
 
 	id = idr_alloc(&ov_idr, ov, 0, 0, GFP_KERNEL);
@@ -386,6 +409,14 @@ int of_overlay_create(struct device_node *tree)
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
 
@@ -393,6 +424,8 @@ int of_overlay_create(struct device_node *tree)
 
 	return id;
 
+err_cancel_overlay:
+	of_changeset_revert(&ov->cset);
 err_revert_overlay:
 err_abort_trans:
 	of_free_overlay_info(ov);
@@ -515,7 +548,8 @@ int of_overlay_destroy(int id)
 	of_free_overlay_info(ov);
 	idr_remove(&ov_idr, id);
 	of_changeset_destroy(&ov->cset);
-	kfree(ov);
+
+	kobject_put(&ov->kobj);
 
 	err = 0;
 
@@ -545,7 +579,7 @@ int of_overlay_destroy_all(void)
 		__of_changeset_revert(&ov->cset);
 		of_free_overlay_info(ov);
 		idr_remove(&ov_idr, ov->id);
-		kfree(ov);
+		kobject_put(&ov->kobj);
 	}
 
 	mutex_unlock(&of_mutex);
@@ -553,3 +587,15 @@ int of_overlay_destroy_all(void)
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
