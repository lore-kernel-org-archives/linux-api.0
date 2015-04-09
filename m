From: Krzysztof Opasiak <k.opasiak-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v3 1/4] fs: configfs: Add unlocked version of
 configfs_depend_item()
Date: Thu, 09 Apr 2015 18:18:07 +0200
Message-ID: <1428596290-23637-2-git-send-email-k.opasiak@samsung.com>
References: <1428596290-23637-1-git-send-email-k.opasiak@samsung.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <1428596290-23637-1-git-send-email-k.opasiak-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: balbi-l0cyMroinI0@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, jlbec-aKy9MeLSZ9dg9hUCZPvPmw@public.gmane.org
Cc: andrzej.p-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, m.szyprowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Krzysztof Opasiak <k.opasiak-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Sometimes it might be desirable to prohibit removing a directory
in configfs. One example is USB gadget (mass_storage function):
when gadget is already bound, if lun directory is removed,
the gadget must be thrown away, too. A better solution would be
to fail with e.g. -EBUSY.

Currently configfs has configfs_depend/undepend_item() methods
but they cannot be used in configfs callbacks. This commit
adds unlocked version of this methods which can be used
only in configfs callbacks.

Signed-off-by: Krzysztof Opasiak <k.opasiak-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
---
 fs/configfs/dir.c        |   29 +++++++++++++++++++++++++++++
 include/linux/configfs.h |    9 +++++++++
 2 files changed, 38 insertions(+)

diff --git a/fs/configfs/dir.c b/fs/configfs/dir.c
index cf0db00..7875a5e 100644
--- a/fs/configfs/dir.c
+++ b/fs/configfs/dir.c
@@ -1152,6 +1152,35 @@ void configfs_undepend_item(struct configfs_subsystem *subsys,
 }
 EXPORT_SYMBOL(configfs_undepend_item);
 
+int configfs_depend_item_unlocked(struct config_item *target)
+{
+	struct configfs_dirent *sd;
+	int ret = -ENOENT;
+
+	spin_lock(&configfs_dirent_lock);
+	BUG_ON(!target->ci_dentry);
+
+	sd = target->ci_dentry->d_fsdata;
+	if ((sd->s_type & CONFIGFS_DIR) &&
+	    ((sd->s_type & CONFIGFS_USET_DROPPING) ||
+	     (sd->s_type & CONFIGFS_USET_CREATING)))
+		goto out_unlock_dirent_lock;
+
+	sd->s_dependent_count += 1;
+	ret = 0;
+
+out_unlock_dirent_lock:
+	spin_unlock(&configfs_dirent_lock);
+	return ret;
+}
+EXPORT_SYMBOL(configfs_depend_item_unlocked);
+
+void configfs_undepend_item_unlocked(struct config_item *target)
+{
+	configfs_undepend_item(NULL, target);
+}
+EXPORT_SYMBOL(configfs_undepend_item_unlocked);
+
 static int configfs_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
 {
 	int ret = 0;
diff --git a/include/linux/configfs.h b/include/linux/configfs.h
index 34025df..e9dbf01 100644
--- a/include/linux/configfs.h
+++ b/include/linux/configfs.h
@@ -257,4 +257,13 @@ void configfs_unregister_subsystem(struct configfs_subsystem *subsys);
 int configfs_depend_item(struct configfs_subsystem *subsys, struct config_item *target);
 void configfs_undepend_item(struct configfs_subsystem *subsys, struct config_item *target);
 
+/*
+ * These functions can sleep and can alloc with GFP_KERNEL
+ * NOTE: These should be called only underneath configfs callbacks.
+ * WARNING: These cannot be called on newly created item
+ *        (in make_group()/make_item callback)
+ */
+int configfs_depend_item_unlocked(struct config_item *target);
+void configfs_undepend_item_unlocked(struct config_item *target);
+
 #endif /* _CONFIGFS_H_ */
-- 
1.7.9.5
