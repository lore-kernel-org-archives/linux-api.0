From: Krzysztof Opasiak <k.opasiak@samsung.com>
Subject: [PATCH 2/5] fs: configfs: Add unlocked version of
 configfs_depend_item()
Date: Wed, 08 Apr 2015 13:28:45 +0200
Message-ID: <1428492528-11993-3-git-send-email-k.opasiak@samsung.com>
References: <1428492528-11993-1-git-send-email-k.opasiak@samsung.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <1428492528-11993-1-git-send-email-k.opasiak@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
To: balbi@ti.com, gregkh@linuxfoundation.org, jlbec@evilplan.org
Cc: andrzej.p@samsung.com, m.szyprowski@samsung.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org, Krzysztof Opasiak <k.opasiak@samsung.com>
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

Signed-off-by: Krzysztof Opasiak <k.opasiak@samsung.com>
---
 fs/configfs/dir.c        |   29 +++++++++++++++++++++++++++++
 include/linux/configfs.h |    9 +++++++++
 2 files changed, 38 insertions(+)

diff --git a/fs/configfs/dir.c b/fs/configfs/dir.c
index dee1cb5..ef51594 100644
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
