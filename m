From: Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v28 19/21] vfs: Move check_posix_acl and check_richacl out of fs/namei.c
Date: Mon, 13 Feb 2017 16:32:35 +0100
Message-ID: <1486999957-2381-20-git-send-email-agruenba@redhat.com>
References: <1486999957-2381-1-git-send-email-agruenba@redhat.com>
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1486999957-2381-1-git-send-email-agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Cc: Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Andreas Dilger <adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>, "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>, Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>, Anna Schumaker <anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

By moving those functions into fs/posix_acl.c and fs/richacl.c, the
ifdefs can be moved into include/linux/posix_acl.h and
include/linux/richacl.h.  This may be seen as a small improvement.

Suggested-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/namei.c                | 72 ++++-------------------------------------------
 fs/posix_acl.c            | 28 ++++++++++++++++++
 fs/richacl.c              | 28 ++++++++++++++++++
 include/linux/posix_acl.h |  5 ++++
 include/linux/richacl.h   |  8 ++++++
 5 files changed, 74 insertions(+), 67 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 7ea153b..3c54b48 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -258,73 +258,6 @@ void putname(struct filename *name)
 		__putname(name);
 }
 
-static int check_richacl(struct inode *inode, int mask)
-{
-#ifdef CONFIG_FS_RICHACL
-	if (mask & MAY_NOT_BLOCK) {
-		struct base_acl *base_acl;
-
-		base_acl = rcu_dereference(inode->i_acl);
-		if (!base_acl)
-			goto no_acl;
-		/* no ->get_richacl() calls in RCU mode... */
-		if (is_uncached_acl(base_acl))
-			return -ECHILD;
-		return richacl_permission(inode, richacl(base_acl),
-					  mask & ~MAY_NOT_BLOCK);
-	} else {
-		struct richacl *acl;
-
-		acl = get_richacl(inode);
-		if (IS_ERR(acl))
-			return PTR_ERR(acl);
-		if (acl) {
-			int error = richacl_permission(inode, acl, mask);
-			richacl_put(acl);
-			return error;
-		}
-	}
-no_acl:
-#endif
-	if (mask & (MAY_DELETE_SELF | MAY_TAKE_OWNERSHIP |
-		    MAY_CHMOD | MAY_SET_TIMES)) {
-		/* File permission bits cannot grant this. */
-		return -EACCES;
-	}
-	return -EAGAIN;
-}
-
-static int check_posix_acl(struct inode *inode, int mask)
-{
-#ifdef CONFIG_FS_POSIX_ACL
-	if (mask & MAY_NOT_BLOCK) {
-		struct base_acl *base_acl;
-
-		base_acl = rcu_dereference(inode->i_acl);
-	        if (!base_acl)
-	                return -EAGAIN;
-		/* no ->get_acl() calls in RCU mode... */
-		if (is_uncached_acl(base_acl))
-			return -ECHILD;
-	        return posix_acl_permission(inode, posix_acl(base_acl),
-					    mask & ~MAY_NOT_BLOCK);
-	} else {
-		struct posix_acl *acl;
-
-		acl = get_acl(inode, ACL_TYPE_ACCESS);
-		if (IS_ERR(acl))
-			return PTR_ERR(acl);
-		if (acl) {
-			int error = posix_acl_permission(inode, acl, mask);
-			posix_acl_release(acl);
-			return error;
-		}
-	}
-#endif
-
-	return -EAGAIN;
-}
-
 /*
  * This does the basic permission checking
  */
@@ -360,6 +293,11 @@ static int acl_permission_check(struct inode *inode, int mask)
 		error = check_richacl(inode, mask);
 		if (error != -EAGAIN)
 			return error;
+		if (mask & (MAY_DELETE_SELF | MAY_TAKE_OWNERSHIP |
+			    MAY_CHMOD | MAY_SET_TIMES)) {
+			/* File permission bits cannot grant this. */
+			return -EACCES;
+		}
 	}
 	if (likely(uid_eq(current_fsuid(), inode->i_uid)))
 		mode >>= 6;
diff --git a/fs/posix_acl.c b/fs/posix_acl.c
index 5d6c5fd..598b899 100644
--- a/fs/posix_acl.c
+++ b/fs/posix_acl.c
@@ -374,6 +374,34 @@ posix_acl_permission(struct inode *inode, const struct posix_acl *acl, int want)
 	return -EACCES;
 }
 
+int check_posix_acl(struct inode *inode, int mask)
+{
+	if (mask & MAY_NOT_BLOCK) {
+		struct base_acl *base_acl;
+
+		base_acl = rcu_dereference(inode->i_acl);
+	        if (!base_acl)
+	                return -EAGAIN;
+		/* no ->get_acl() calls in RCU mode... */
+		if (is_uncached_acl(base_acl))
+			return -ECHILD;
+	        return posix_acl_permission(inode, posix_acl(base_acl),
+					    mask & ~MAY_NOT_BLOCK);
+	} else {
+		struct posix_acl *acl;
+
+		acl = get_acl(inode, ACL_TYPE_ACCESS);
+		if (IS_ERR(acl))
+			return PTR_ERR(acl);
+		if (acl) {
+			int error = posix_acl_permission(inode, acl, mask);
+			posix_acl_release(acl);
+			return error;
+		}
+	}
+	return -EAGAIN;
+}
+
 /*
  * Modify acl when creating a new inode. The caller must ensure the acl is
  * only referenced once.
diff --git a/fs/richacl.c b/fs/richacl.c
index 416d57c..6aa17a6 100644
--- a/fs/richacl.c
+++ b/fs/richacl.c
@@ -385,6 +385,34 @@ richacl_permission(struct inode *inode, const struct richacl *acl,
 }
 EXPORT_SYMBOL_GPL(richacl_permission);
 
+int check_richacl(struct inode *inode, int mask)
+{
+	if (mask & MAY_NOT_BLOCK) {
+		struct base_acl *base_acl;
+
+		base_acl = rcu_dereference(inode->i_acl);
+		if (!base_acl)
+			return -EAGAIN;
+		/* no ->get_richacl() calls in RCU mode... */
+		if (is_uncached_acl(base_acl))
+			return -ECHILD;
+		return richacl_permission(inode, richacl(base_acl),
+					  mask & ~MAY_NOT_BLOCK);
+	} else {
+		struct richacl *acl;
+
+		acl = get_richacl(inode);
+		if (IS_ERR(acl))
+			return PTR_ERR(acl);
+		if (acl) {
+			int error = richacl_permission(inode, acl, mask);
+			richacl_put(acl);
+			return error;
+		}
+	}
+	return -EAGAIN;
+}
+
 /*
  * Note: functions like richacl_allowed_to_who(), richacl_group_class_allowed(),
  * and richacl_compute_max_masks() iterate through the entire acl in reverse
diff --git a/include/linux/posix_acl.h b/include/linux/posix_acl.h
index abfb786..5c65dc9 100644
--- a/include/linux/posix_acl.h
+++ b/include/linux/posix_acl.h
@@ -74,6 +74,7 @@ extern struct posix_acl *get_posix_acl(struct inode *, int);
 extern int set_posix_acl(struct inode *, int, struct posix_acl *);
 
 #ifdef CONFIG_FS_POSIX_ACL
+extern int check_posix_acl(struct inode *, int);
 extern int posix_acl_chmod(struct inode *, umode_t);
 extern int posix_acl_create(struct inode *, umode_t *, struct posix_acl **,
 		struct posix_acl **);
@@ -93,6 +94,10 @@ static inline void cache_no_acl(struct inode *inode)
 	inode->i_default_acl = NULL;
 }
 #else
+static inline int check_posix_acl(struct inode *inode, int mask) {
+	return -EAGAIN;
+}
+
 static inline int posix_acl_chmod(struct inode *inode, umode_t mode)
 {
 	return 0;
diff --git a/include/linux/richacl.h b/include/linux/richacl.h
index 7530920..368e918 100644
--- a/include/linux/richacl.h
+++ b/include/linux/richacl.h
@@ -207,4 +207,12 @@ extern struct richacl *richacl_inherit(const struct richacl *, int);
 extern struct richacl *richacl_create(umode_t *, struct inode *);
 extern int set_richacl(struct inode *, struct richacl *);
 
+#ifdef CONFIG_FS_RICHACL
+extern int check_richacl(struct inode *, int);
+#else
+static inline int check_richacl(struct inode *inode, int mask) {
+	return -EAGAIN;
+}
+#endif  /* CONFIG_FS_RICHACL */
+
 #endif /* __RICHACL_H */
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
