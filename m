From: Pantelis Antoniou <pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v2 3/4] of: overlay: Add sysfs attributes
Date: Tue,  7 Apr 2015 22:23:51 +0300
Message-ID: <1428434632-13789-4-git-send-email-pantelis.antoniou@konsulko.com>
References: <1428434632-13789-1-git-send-email-pantelis.antoniou@konsulko.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1428434632-13789-1-git-send-email-pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Rob Herring <robherring2-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Grant Likely <grant.likely-s3s/WqlpOiPyB63q8FvJNQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Matt Porter <mporter-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>, Koen Kooi <koen-QLwJDigV5abLmq1fohREcCpxlwaOVQ5f@public.gmane.org>, Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Pantelis Antoniou <pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>, Pantelis Antoniou <panto-wVdstyuyKrO8r51toPun2/C9HSW9iNxf@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Implement a number of sysfs attributes for overlays.

* A throw once master enable switch to protect against any
further overlay applications if the administrator desires so.

* A per overlay targets sysfs attribute listing the targets of
the installed overlay.

* A per overlay can_remove sysfs attribute that reports whether
the overlay can be removed or not due to another overlapping overlay.

Signed-off-by: Pantelis Antoniou <pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>
---
 drivers/of/overlay.c | 167 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 166 insertions(+), 1 deletion(-)

diff --git a/drivers/of/overlay.c b/drivers/of/overlay.c
index f17f5ef..c54d097 100644
--- a/drivers/of/overlay.c
+++ b/drivers/of/overlay.c
@@ -21,6 +21,7 @@
 #include <linux/err.h>
 #include <linux/idr.h>
 #include <linux/sysfs.h>
+#include <linux/atomic.h>
 
 #include "of_private.h"
 
@@ -55,8 +56,12 @@ struct of_overlay {
 	struct kobject kobj;
 };
 
+/* master enable switch; once set to 0 can't be re-enabled */
+static atomic_t ov_enable = ATOMIC_INIT(1);
+
 static int of_overlay_apply_one(struct of_overlay *ov,
 		struct device_node *target, const struct device_node *overlay);
+static int overlay_removal_is_ok(struct of_overlay *ov);
 
 static int of_overlay_apply_single_property(struct of_overlay *ov,
 		struct device_node *target, struct property *prop)
@@ -345,6 +350,144 @@ static struct kobj_type of_overlay_ktype = {
 
 static struct kset *ov_kset;
 
+static ssize_t enable_read(struct file *filp, struct kobject *kobj,
+		struct bin_attribute *bin_attr, char *buf,
+		loff_t offset, size_t count)
+{
+	char tbuf[3];
+
+	if (offset < 0)
+		return -EINVAL;
+
+	if (offset >= sizeof(tbuf))
+		return 0;
+
+	if (count > sizeof(tbuf) - offset)
+		count = sizeof(tbuf) - offset;
+
+	/* fill in temp */
+	tbuf[0] = '0' + atomic_read(&ov_enable);
+	tbuf[1] = '\n';
+	tbuf[2] = '\0';
+
+	/* copy to buffer */
+	memcpy(buf, tbuf + offset, count);
+
+	return count;
+}
+
+static ssize_t enable_write(struct file *filp, struct kobject *kobj,
+		struct bin_attribute *bin_attr, char *buf,
+		loff_t off, size_t count)
+{
+	unsigned int new_enable;
+
+	if (off != 0 || (buf[0] != '0' && buf[0] != '1'))
+		return -EINVAL;
+
+	new_enable = (unsigned int)(buf[0] - '0');
+	if (new_enable > 1)
+		return -EINVAL;
+
+	/* NOP for same value */
+	if (new_enable == atomic_read(&ov_enable))
+		return count;
+
+	/* if we've disabled it, no going back */
+	if (atomic_read(&ov_enable) == 0)
+		return -EPERM;
+
+	atomic_set(&ov_enable, new_enable);
+	return count;
+}
+
+/* just a single char + '\n' + '\0' */
+static BIN_ATTR_RW(enable, 3);
+
+static ssize_t targets_read(struct file *filp, struct kobject *kobj,
+		struct bin_attribute *bin_attr, char *buf,
+		loff_t offset, size_t count)
+{
+	struct of_overlay *ov = kobj_to_overlay(kobj);
+	struct of_overlay_info *ovinfo;
+	char *tmpbuf, *s, *e;
+	const char *name;
+	ssize_t ret;
+	int i, len;
+
+	/* allocate work buffer; we know that PAGE_SIZE is enough */
+	tmpbuf = kmalloc(PAGE_SIZE, GFP_KERNEL);
+	if (tmpbuf == NULL)
+		return -ENOMEM;
+
+	s = tmpbuf;
+	e = tmpbuf + PAGE_SIZE;
+
+	mutex_lock(&of_mutex);
+
+	/* targets */
+	for (i = 0; i < ov->count; i++) {
+		ovinfo = &ov->ovinfo_tab[i];
+
+		name = of_node_full_name(ovinfo->target);
+		len = strlen(name);
+		if (s + len + 1 >= e)
+			return -ENOMEM;
+		memcpy(s, name, len);
+		s += len;
+		*s++ = '\n';
+	}
+	if (s + 1 >= e)
+		return -ENOMEM;
+	*s++ = '\0';
+
+	/* the buffer is zero terminated */
+	len = s - tmpbuf;
+
+	mutex_unlock(&of_mutex);
+
+	/* perform the read */
+	ret = memory_read_from_buffer(buf, count, &offset, tmpbuf, len);
+
+	/* free the temporary buffer */
+	kfree(tmpbuf);
+
+	return ret;
+}
+
+/* targets property */
+static BIN_ATTR_RO(targets, PAGE_SIZE);
+
+static ssize_t can_remove_read(struct file *filp, struct kobject *kobj,
+		struct bin_attribute *bin_attr, char *buf,
+		loff_t offset, size_t count)
+{
+	struct of_overlay *ov = kobj_to_overlay(kobj);
+	char tbuf[3];
+
+	if (offset < 0)
+		return -EINVAL;
+
+	if (offset >= sizeof(tbuf))
+		return 0;
+
+	if (count > sizeof(tbuf) - offset)
+		count = sizeof(tbuf) - offset;
+
+	/* fill in temp */
+	tbuf[0] = '0' + overlay_removal_is_ok(ov);
+	tbuf[1] = '\n';
+	tbuf[2] = '\0';
+
+	/* copy to buffer */
+	memcpy(buf, tbuf + offset, count);
+
+	return count;
+}
+
+/* can_remove property */
+static BIN_ATTR_RO(can_remove, 3);
+
 /**
  * of_overlay_create() - Create and apply an overlay
  * @tree:	Device node containing all the overlays
@@ -360,6 +503,10 @@ int of_overlay_create(struct device_node *tree)
 	struct of_overlay *ov;
 	int err, id;
 
+	/* administratively disabled */
+	if (!atomic_read(&ov_enable))
+		return -EPERM;
+
 	/* allocate the overlay structure */
 	ov = kzalloc(sizeof(*ov), GFP_KERNEL);
 	if (ov == NULL)
@@ -416,6 +563,22 @@ int of_overlay_create(struct device_node *tree)
 		goto err_cancel_overlay;
 	}
 
+	/* create targets file */
+	err = sysfs_create_bin_file(&ov->kobj, &bin_attr_targets);
+	if (err != 0) {
+		pr_err("%s: sysfs_create_bin_file() failed for tree@%s\n",
+				__func__, tree->full_name);
+		goto err_cancel_overlay;
+	}
+
+	/* create can_remove file */
+	err = sysfs_create_bin_file(&ov->kobj, &bin_attr_can_remove);
+	if (err != 0) {
+		pr_err("%s: sysfs_create_bin_file() failed for tree@%s\n",
+				__func__, tree->full_name);
+		goto err_cancel_overlay;
+	}
+
 	/* add to the tail of the overlay list */
 	list_add_tail(&ov->node, &ov_list);
 
@@ -596,5 +759,7 @@ int of_overlay_init(void)
 	if (!ov_kset)
 		return -ENOMEM;
 
-	return 0;
+	rc = sysfs_create_bin_file(&ov_kset->kobj, &bin_attr_enable);
+	WARN(rc, "%s: error adding enable attribute\n", __func__);
+	return rc;
 }
-- 
1.7.12
