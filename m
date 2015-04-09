From: Krzysztof Opasiak <k.opasiak@samsung.com>
Subject: [PATCH v3 3/4] usb: gadget: mass_storage: Ensure that lun ids are
 contiguous
Date: Thu, 09 Apr 2015 18:18:09 +0200
Message-ID: <1428596290-23637-4-git-send-email-k.opasiak@samsung.com>
References: <1428596290-23637-1-git-send-email-k.opasiak@samsung.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <1428596290-23637-1-git-send-email-k.opasiak@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
To: balbi@ti.com, gregkh@linuxfoundation.org, jlbec@evilplan.org
Cc: andrzej.p@samsung.com, m.szyprowski@samsung.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org, Krzysztof Opasiak <k.opasiak@samsung.com>
List-Id: linux-api@vger.kernel.org

According to mass storage specification:

"Logical Unit Numbers on the device shall be numbered
 contiguously starting from LUN 0 to a maximum LUN of 15 (Fh)."

This commit fix configfs interface adding this restriction.
Now user can create luns only with contignous ids and
cannot remove lun from the middle of id space.

Example:

as is:
$ mkdir mass_storage.name
$ mkdir lun.3
$ mkdir lun.5
$ rmdir lun.3

After this commit:
$ mkdir mass_storage.name
$ mkdir lun.3
mkdir: cannot create directory 'lun.3': Invalid argument
$ mkdir lun.1
$ mkdir lun.2
$ rmdir lun.1
rmdir: failed to remove 'lun.1': Device or resource busy
$ rmdir lun.2
$ rmdir lun.1

Signed-off-by: Krzysztof Opasiak <k.opasiak@samsung.com>
---
 drivers/usb/gadget/function/f_mass_storage.c |   29 ++++++++++++++++++++++----
 1 file changed, 25 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/gadget/function/f_mass_storage.c b/drivers/usb/gadget/function/f_mass_storage.c
index 67a67b5..f4b2de4 100644
--- a/drivers/usb/gadget/function/f_mass_storage.c
+++ b/drivers/usb/gadget/function/f_mass_storage.c
@@ -3355,6 +3355,12 @@ static struct config_group *fsg_lun_make(struct config_group *group,
 		goto out;
 	}
 
+	if (!fsg_opts->common->luns[num - 1]) {
+		ret = -EINVAL;
+		pr_err("LUN ids should be contiguous\n");
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
 	WARN_ON(fsg_opts->lun_opts[num]);
@@ -3379,6 +3390,12 @@ static struct config_group *fsg_lun_make(struct config_group *group,
 	config_group_init_type_name(&opts->group, name, &fsg_lun_type);
 
 	return &opts->group;
+
+err_undepend_item:
+	configfs_undepend_item_unlocked(&(fsg_opts->lun_opts
+					  [num - 1]->group.cg_item));
+err_free_opts:
+	kfree(opts);
 out:
 	mutex_unlock(&fsg_opts->lock);
 	return ERR_PTR(ret);
@@ -3400,6 +3417,10 @@ static void fsg_lun_drop(struct config_group *group, struct config_item *item)
 		unregister_gadget_item(gadget);
 	}
 
+	/* Allow to remove next one */
+	configfs_undepend_item_unlocked(&(fsg_opts->lun_opts
+					  [lun_opts->lun_id - 1]->group.cg_item));
+
 	fsg_common_remove_lun(lun_opts->lun, fsg_opts->common->sysfs);
 	fsg_opts->common->luns[lun_opts->lun_id] = NULL;
 	fsg_opts->lun_opts[lun_opts->lun_id] = NULL;
-- 
1.7.9.5
