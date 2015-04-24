From: Pantelis Antoniou <pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v3 3/4] of: overlay: add per overlay sysfs attributes
Date: Fri, 24 Apr 2015 12:45:43 +0300
Message-ID: <1429868744-19863-4-git-send-email-pantelis.antoniou@konsulko.com>
References: <1429868744-19863-1-git-send-email-pantelis.antoniou@konsulko.com>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1429868744-19863-1-git-send-email-pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Rob Herring <robherring2-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Grant Likely <grant.likely-s3s/WqlpOiPyB63q8FvJNQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Matt Porter <mporter-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>, Koen Kooi <koen-QLwJDigV5abLmq1fohREcCpxlwaOVQ5f@public.gmane.org>, Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Pantelis Antoniou <pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>, Pantelis Antoniou <panto-wVdstyuyKrO8r51toPun2/C9HSW9iNxf@public.gmane.org>
List-Id: linux-api@vger.kernel.org

The two default overlay attributes are:

* A targets sysfs attribute listing the targets of the installed
overlay. The targets list the path on the kernel's device tree
where each overlay fragment is applied to

* A per overlay can_remove sysfs attribute that reports whether
the overlay can be removed or not due to another overlapping overlay.

Signed-off-by: Pantelis Antoniou <pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>
---
 drivers/of/overlay.c | 53 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 53 insertions(+)

diff --git a/drivers/of/overlay.c b/drivers/of/overlay.c
index c335809..9af4d8d 100644
--- a/drivers/of/overlay.c
+++ b/drivers/of/overlay.c
@@ -375,8 +375,61 @@ static const struct attribute *overlay_global_attrs[] = {
 	NULL
 };
 
+static ssize_t can_remove_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct of_overlay *ov = kobj_to_overlay(kobj);
+
+	return snprintf(buf, PAGE_SIZE, "%d\n", overlay_removal_is_ok(ov));
+}
+
+static ssize_t targets_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct of_overlay *ov = kobj_to_overlay(kobj);
+	struct of_overlay_info *ovinfo;
+	char *s, *e;
+	ssize_t ret;
+	int i, len;
+
+	s = buf;
+	e = buf + PAGE_SIZE;
+
+	mutex_lock(&of_mutex);
+
+	/* targets */
+	for (i = 0; i < ov->count; i++) {
+		ovinfo = &ov->ovinfo_tab[i];
+
+		len = snprintf(s, e - s, "%s\n",
+				of_node_full_name(ovinfo->target));
+		if (len == 0) {
+			ret = -ENOSPC;
+			goto err;
+		}
+		s += len;
+	}
+
+	/* the buffer is zero terminated */
+	ret = s - buf;
+err:
+	mutex_unlock(&of_mutex);
+	return ret;
+}
+
+static struct kobj_attribute can_remove_attr = __ATTR_RO(can_remove);
+static struct kobj_attribute targets_attr = __ATTR_RO(targets);
+
+static struct attribute *overlay_attrs[] = {
+	&can_remove_attr.attr,
+	&targets_attr.attr,
+	NULL
+};
+
 static struct kobj_type of_overlay_ktype = {
 	.release = of_overlay_release,
+	.sysfs_ops = &kobj_sysfs_ops,	/* default kobj sysfs ops */
+	.default_attrs = overlay_attrs,
 };
 
 static struct kset *ov_kset;
-- 
1.7.12

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
