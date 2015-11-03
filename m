From: Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v13 14/51] richacl: Check if an acl is equivalent to a file mode
Date: Tue,  3 Nov 2015 16:16:50 +0100
Message-ID: <1446563847-14005-15-git-send-email-agruenba@redhat.com>
References: <1446563847-14005-1-git-send-email-agruenba@redhat.com>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1446563847-14005-1-git-send-email-agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Andreas Dilger <adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>, "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>, Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>, Anna Schumaker <anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

ACLs are considered equivalent to file modes if they only consist of
owner@, group@, and everyone@ entries, the owner@ permissions do not
depend on whether the owner is a member in the owning group, and no
inheritance flags are set.  This test is used to avoid storing richacls
if the acl can be computed from the file permission bits.

Signed-off-by: Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Reviewed-by: J. Bruce Fields <bfields-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/richacl_base.c       | 104 ++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/richacl.h |   1 +
 2 files changed, 105 insertions(+)

diff --git a/fs/richacl_base.c b/fs/richacl_base.c
index 00e87be..56b5ad6 100644
--- a/fs/richacl_base.c
+++ b/fs/richacl_base.c
@@ -382,3 +382,107 @@ __richacl_chmod(struct richacl *acl, umode_t mode)
 	return clone;
 }
 EXPORT_SYMBOL_GPL(__richacl_chmod);
+
+/**
+ * richacl_equiv_mode  -  compute the mode equivalent of @acl
+ *
+ * An acl is considered equivalent to a file mode if it only consists of
+ * owner@, group@, and everyone@ entries and the owner@ permissions do not
+ * depend on whether the owner is a member in the owning group.
+ */
+int
+richacl_equiv_mode(const struct richacl *acl, umode_t *mode_p)
+{
+	umode_t mode = *mode_p;
+
+	/*
+	 * The RICHACE_DELETE_CHILD flag is meaningless for non-directories, so
+	 * we ignore it.
+	 */
+	unsigned int x = S_ISDIR(mode) ? 0 : RICHACE_DELETE_CHILD;
+	struct {
+		unsigned int allowed;
+		unsigned int defined;  /* allowed or denied */
+	} owner = {
+		.defined = RICHACE_POSIX_ALWAYS_ALLOWED |
+			   RICHACE_POSIX_OWNER_ALLOWED  | x,
+	}, group = {
+		.defined = RICHACE_POSIX_ALWAYS_ALLOWED | x,
+	}, everyone = {
+		.defined = RICHACE_POSIX_ALWAYS_ALLOWED | x,
+	};
+	const struct richace *ace;
+
+	if (acl->a_flags & ~(RICHACL_WRITE_THROUGH | RICHACL_MASKED))
+		return -1;
+
+	richacl_for_each_entry(ace, acl) {
+		if (ace->e_flags & ~RICHACE_SPECIAL_WHO)
+			return -1;
+
+		if (richace_is_owner(ace) || richace_is_everyone(ace)) {
+			x = ace->e_mask & ~owner.defined;
+			if (richace_is_allow(ace)) {
+				unsigned int group_denied =
+					group.defined & ~group.allowed;
+
+				if (x & group_denied)
+					return -1;
+				owner.allowed |= x;
+			} else /* if (richace_is_deny(ace)) */ {
+				if (x & group.allowed)
+					return -1;
+			}
+			owner.defined |= x;
+
+			if (richace_is_everyone(ace)) {
+				x = ace->e_mask;
+				if (richace_is_allow(ace)) {
+					group.allowed |=
+						x & ~group.defined;
+					everyone.allowed |=
+						x & ~everyone.defined;
+				}
+				group.defined |= x;
+				everyone.defined |= x;
+			}
+		} else if (richace_is_group(ace)) {
+			x = ace->e_mask & ~group.defined;
+			if (richace_is_allow(ace))
+				group.allowed |= x;
+			group.defined |= x;
+		} else
+			return -1;
+	}
+
+	if (group.allowed & ~owner.defined)
+		return -1;
+
+	if (acl->a_flags & RICHACL_MASKED) {
+		if (acl->a_flags & RICHACL_WRITE_THROUGH) {
+			owner.allowed = acl->a_owner_mask;
+			everyone.allowed = acl->a_other_mask;
+		} else {
+			owner.allowed &= acl->a_owner_mask;
+			everyone.allowed &= acl->a_other_mask;
+		}
+		group.allowed &= acl->a_group_mask;
+	}
+
+	mode = (mode & ~S_IRWXUGO) |
+	       (richacl_mask_to_mode(owner.allowed) << 6) |
+	       (richacl_mask_to_mode(group.allowed) << 3) |
+		richacl_mask_to_mode(everyone.allowed);
+
+	/* Mask flags we can ignore */
+	x = S_ISDIR(mode) ? 0 : RICHACE_DELETE_CHILD;
+
+	if (((richacl_mode_to_mask(mode >> 6) ^ owner.allowed)    & ~x) ||
+	    ((richacl_mode_to_mask(mode >> 3) ^ group.allowed)    & ~x) ||
+	    ((richacl_mode_to_mask(mode)      ^ everyone.allowed) & ~x))
+		return -1;
+
+	*mode_p = mode;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(richacl_equiv_mode);
diff --git a/include/linux/richacl.h b/include/linux/richacl.h
index 3626314..ddd5aa6 100644
--- a/include/linux/richacl.h
+++ b/include/linux/richacl.h
@@ -185,6 +185,7 @@ extern unsigned int richacl_mode_to_mask(umode_t);
 extern unsigned int richacl_want_to_mask(unsigned int);
 extern void richacl_compute_max_masks(struct richacl *);
 extern struct richacl *__richacl_chmod(struct richacl *, umode_t);
+extern int richacl_equiv_mode(const struct richacl *, umode_t *);
 
 /* richacl_inode.c */
 extern int richacl_permission(struct inode *, const struct richacl *, int);
-- 
2.5.0
