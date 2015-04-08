From: Krzysztof Opasiak <k.opasiak-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 4/5] usb: gadget: mass_storage: Ensure that lun ids are
 contiguous
Date: Wed, 08 Apr 2015 13:28:47 +0200
Message-ID: <1428492528-11993-5-git-send-email-k.opasiak@samsung.com>
References: <1428492528-11993-1-git-send-email-k.opasiak@samsung.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <1428492528-11993-1-git-send-email-k.opasiak-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: balbi-l0cyMroinI0@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, jlbec-aKy9MeLSZ9dg9hUCZPvPmw@public.gmane.org
Cc: andrzej.p-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, m.szyprowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Krzysztof Opasiak <k.opasiak-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Signed-off-by: Krzysztof Opasiak <k.opasiak-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
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
