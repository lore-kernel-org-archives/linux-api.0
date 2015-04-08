From: Krzysztof Opasiak <k.opasiak@samsung.com>
Subject: [PATCH v2 3/4] usb: gadget: mass_storage: Ensure that lun ids are
 contiguous
Date: Wed, 08 Apr 2015 14:06:47 +0200
Message-ID: <1428494808-12566-4-git-send-email-k.opasiak@samsung.com>
References: <1428494808-12566-1-git-send-email-k.opasiak@samsung.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <1428494808-12566-1-git-send-email-k.opasiak@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
To: balbi@ti.com, gregkh@linuxfoundation.org, jlbec@evilplan.org
Cc: andrzej.p@samsung.com, m.szyprowski@samsung.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org, Krzysztof Opasiak <k.opasiak@samsung.com>
List-Id: linux-api@vger.kernel.org

Signed-off-by: Krzysztof Opasiak <k.opasiak@samsung.com>
---
 drivers/usb/gadget/function/f_mass_storage.c |   35 +++++++++++++++++++++++---
 1 file changed, 31 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/gadget/function/f_mass_storage.c b/drivers/usb/gadget/function/f_mass_storage.c
index 095b618..9d9fafb 100644
--- a/drivers/usb/gadget/function/f_mass_storage.c
+++ b/drivers/usb/gadget/function/f_mass_storage.c
@@ -3355,6 +3355,12 @@ static struct config_group *fsg_lun_make(struct config_group *group,
 		goto out;
 	}
 
+	if (!fsg_opts->common->luns[num - 1]) {
+		ret = -EINVAL;
+		pr_err("LUN ids should be contignous\n");
+		goto out;
+	}
+
 	opts = kzalloc(sizeof(*opts), GFP_KERNEL);
 	if (!opts) {
 		ret = -ENOMEM;
@@ -3364,12 +3370,17 @@ static struct config_group *fsg_lun_make(struct config_group *group,
 	memset(&config, 0, sizeof(config));
 	config.removable = true;
 
+	/* ensure that lun ids are contiguous */
+	ret = configfs_depend_item_unlocked(&(fsg_opts->lun_opts
+					      [num - 1]->group.cg_item));
+	if (ret)
+		goto err_free_opts;
+
 	ret = fsg_common_create_lun(fsg_opts->common, &config, num, name,
 				    (const char **)&group->cg_item.ci_name);
-	if (ret) {
-		kfree(opts);
-		goto out;
-	}
+	if (ret)
+		goto err_undepend_item;
+
 	opts->lun = fsg_opts->common->luns[num];
 	opts->lun_id = num;
 	BUG_ON(fsg_opts->lun_opts[num]);
@@ -3382,6 +3393,16 @@ static struct config_group *fsg_lun_make(struct config_group *group,
 out:
 	mutex_unlock(&fsg_opts->lock);
 	return ERR_PTR(ret);
+
+err_undepend_item:
+	configfs_undepend_item_unlocked(&(fsg_opts->lun_opts
+					  [num - 1]->group.cg_item));
+err_free_opts:
+	kfree(opts);
+
+	mutex_unlock(&fsg_opts->lock);
+	return ERR_PTR(ret);
+
 }
 
 static void fsg_lun_drop(struct config_group *group, struct config_item *item)
@@ -3400,10 +3421,16 @@ static void fsg_lun_drop(struct config_group *group, struct config_item *item)
 		unregister_gadget_item(gadget);
 	}
 
+
+	/* Allow to remove next one */
+	configfs_undepend_item_unlocked(&(fsg_opts->lun_opts
+					  [lun_opts->lun_id - 1]->group.cg_item));
+
 	fsg_common_remove_lun(lun_opts->lun, fsg_opts->common->sysfs);
 	fsg_opts->common->luns[lun_opts->lun_id] = NULL;
 	fsg_opts->lun_opts[lun_opts->lun_id] = NULL;
 	lun_opts->lun_id = 0;
+
 	mutex_unlock(&fsg_opts->lock);
 
 	config_item_put(item);
-- 
1.7.9.5
