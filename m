From: Krzysztof Opasiak <k.opasiak@samsung.com>
Subject: [PATCH 3/5] usb: gadget: mass_storage: Store lun_opts in fsg_opts
Date: Wed, 08 Apr 2015 13:28:46 +0200
Message-ID: <1428492528-11993-4-git-send-email-k.opasiak@samsung.com>
References: <1428492528-11993-1-git-send-email-k.opasiak@samsung.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <1428492528-11993-1-git-send-email-k.opasiak@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
To: balbi@ti.com, gregkh@linuxfoundation.org, jlbec@evilplan.org
Cc: andrzej.p@samsung.com, m.szyprowski@samsung.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org, Krzysztof Opasiak <k.opasiak@samsung.com>
List-Id: linux-api@vger.kernel.org

Signed-off-by: Krzysztof Opasiak <k.opasiak@samsung.com>
---
 drivers/usb/gadget/function/f_mass_storage.c |    5 +++++
 drivers/usb/gadget/function/f_mass_storage.h |    1 +
 2 files changed, 6 insertions(+)

diff --git a/drivers/usb/gadget/function/f_mass_storage.c b/drivers/usb/gadget/function/f_mass_storage.c
index 811929c..095b618 100644
--- a/drivers/usb/gadget/function/f_mass_storage.c
+++ b/drivers/usb/gadget/function/f_mass_storage.c
@@ -3372,6 +3372,8 @@ static struct config_group *fsg_lun_make(struct config_group *group,
 	}
 	opts->lun = fsg_opts->common->luns[num];
 	opts->lun_id = num;
+	BUG_ON(fsg_opts->lun_opts[num]);
+	fsg_opts->lun_opts[num] = opts;
 	mutex_unlock(&fsg_opts->lock);
 
 	config_group_init_type_name(&opts->group, name, &fsg_lun_type);
@@ -3400,6 +3402,7 @@ static void fsg_lun_drop(struct config_group *group, struct config_item *item)
 
 	fsg_common_remove_lun(lun_opts->lun, fsg_opts->common->sysfs);
 	fsg_opts->common->luns[lun_opts->lun_id] = NULL;
+	fsg_opts->lun_opts[lun_opts->lun_id] = NULL;
 	lun_opts->lun_id = 0;
 	mutex_unlock(&fsg_opts->lock);
 
@@ -3546,6 +3549,7 @@ static struct usb_function_instance *fsg_alloc_inst(void)
 	if (!opts)
 		return ERR_PTR(-ENOMEM);
 	mutex_init(&opts->lock);
+	memset(opts->lun_opts, 0, sizeof(opts->lun_opts));
 	opts->func_inst.free_func_inst = fsg_free_inst;
 	opts->common = fsg_common_setup(opts->common);
 	if (IS_ERR(opts->common)) {
@@ -3569,6 +3573,7 @@ static struct usb_function_instance *fsg_alloc_inst(void)
 			(const char **)&opts->func_inst.group.cg_item.ci_name);
 	opts->lun0.lun = opts->common->luns[0];
 	opts->lun0.lun_id = 0;
+	opts->lun_opts[0] = &opts->lun0;
 	config_group_init_type_name(&opts->lun0.group, "lun.0", &fsg_lun_type);
 	opts->default_groups[0] = &opts->lun0.group;
 	opts->func_inst.group.default_groups = opts->default_groups;
diff --git a/drivers/usb/gadget/function/f_mass_storage.h b/drivers/usb/gadget/function/f_mass_storage.h
index b4866fc..0a7c656 100644
--- a/drivers/usb/gadget/function/f_mass_storage.h
+++ b/drivers/usb/gadget/function/f_mass_storage.h
@@ -81,6 +81,7 @@ struct fsg_opts {
 	struct fsg_common *common;
 	struct usb_function_instance func_inst;
 	struct fsg_lun_opts lun0;
+	struct fsg_lun_opts *lun_opts[FSG_MAX_LUNS];
 	struct config_group *default_groups[2];
 	bool no_configfs; /* for legacy gadgets */
 
-- 
1.7.9.5
