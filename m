From: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH review 03/11] vfs: Verify acls are valid within superblock's s_user_ns.
Date: Sat,  2 Jul 2016 12:20:27 -0500
Message-ID: <20160702172035.19568-3-ebiederm@xmission.com>
References: <87ziq03qnj.fsf@x220.int.ebiederm.org>
 <20160702172035.19568-1-ebiederm@xmission.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20160702172035.19568-1-ebiederm@xmission.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Seth Forshee <seth.forshee@canonical.com>
Cc: Linux Containers <containers@lists.linux-foundation.org>, linux-fsdevel@vger.kernel.org, Linux API <linux-api@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Djalal Harouni <tixxdz@gmail.com>, "Serge E. Hallyn" <serge@hallyn.com>, Andy Lutomirski <luto@amacapital.net>, Jan Kara <jack@suse.cz>, Jann Horn <jannh@google.com>, Michael Kerrisk <mtk.manpages@gmail.com>
List-Id: linux-api@vger.kernel.org

Update posix_acl_valid to verify that an acl is within a user namespace.

Update the callers of posix_acl_valid to pass in an appropriate
user namespace.  For posix_acl_xattr_set and v9fs_xattr_set_acl pass in
inode->i_sb->s_user_ns to posix_acl_valid.  For md_unpack_acl pass in
&init_user_ns as no inode or superblock is in sight.

Acked-by: Seth Forshee <seth.forshee@canonical.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 drivers/staging/lustre/lustre/mdc/mdc_request.c | 2 +-
 fs/9p/acl.c                                     | 2 +-
 fs/posix_acl.c                                  | 8 ++++----
 include/linux/posix_acl.h                       | 2 +-
 4 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/lustre/lustre/mdc/mdc_request.c b/drivers/staging/lustre/lustre/mdc/mdc_request.c
index 86b7445365f4..40cf57fad581 100644
--- a/drivers/staging/lustre/lustre/mdc/mdc_request.c
+++ b/drivers/staging/lustre/lustre/mdc/mdc_request.c
@@ -434,7 +434,7 @@ static int mdc_unpack_acl(struct ptlrpc_request *req, struct lustre_md *md)
 		return rc;
 	}
 
-	rc = posix_acl_valid(acl);
+	rc = posix_acl_valid(&init_user_ns, acl);
 	if (rc) {
 		CERROR("validate acl: %d\n", rc);
 		posix_acl_release(acl);
diff --git a/fs/9p/acl.c b/fs/9p/acl.c
index 0576eaeb60b9..5b6a1743ea17 100644
--- a/fs/9p/acl.c
+++ b/fs/9p/acl.c
@@ -266,7 +266,7 @@ static int v9fs_xattr_set_acl(const struct xattr_handler *handler,
 		if (IS_ERR(acl))
 			return PTR_ERR(acl);
 		else if (acl) {
-			retval = posix_acl_valid(acl);
+			retval = posix_acl_valid(inode->i_sb->s_user_ns, acl);
 			if (retval)
 				goto err_out;
 		}
diff --git a/fs/posix_acl.c b/fs/posix_acl.c
index 8a4a266beff3..647c28180675 100644
--- a/fs/posix_acl.c
+++ b/fs/posix_acl.c
@@ -205,7 +205,7 @@ posix_acl_clone(const struct posix_acl *acl, gfp_t flags)
  * Check if an acl is valid. Returns 0 if it is, or -E... otherwise.
  */
 int
-posix_acl_valid(const struct posix_acl *acl)
+posix_acl_valid(struct user_namespace *user_ns, const struct posix_acl *acl)
 {
 	const struct posix_acl_entry *pa, *pe;
 	int state = ACL_USER_OBJ;
@@ -225,7 +225,7 @@ posix_acl_valid(const struct posix_acl *acl)
 			case ACL_USER:
 				if (state != ACL_USER)
 					return -EINVAL;
-				if (!uid_valid(pa->e_uid))
+				if (!kuid_has_mapping(user_ns, pa->e_uid))
 					return -EINVAL;
 				needs_mask = 1;
 				break;
@@ -240,7 +240,7 @@ posix_acl_valid(const struct posix_acl *acl)
 			case ACL_GROUP:
 				if (state != ACL_GROUP)
 					return -EINVAL;
-				if (!gid_valid(pa->e_gid))
+				if (!kgid_has_mapping(user_ns, pa->e_gid))
 					return -EINVAL;
 				needs_mask = 1;
 				break;
@@ -845,7 +845,7 @@ posix_acl_xattr_set(const struct xattr_handler *handler,
 			return PTR_ERR(acl);
 
 		if (acl) {
-			ret = posix_acl_valid(acl);
+			ret = posix_acl_valid(inode->i_sb->s_user_ns, acl);
 			if (ret)
 				goto out;
 		}
diff --git a/include/linux/posix_acl.h b/include/linux/posix_acl.h
index 5b5a80cc5926..1af6438fde3e 100644
--- a/include/linux/posix_acl.h
+++ b/include/linux/posix_acl.h
@@ -81,7 +81,7 @@ posix_acl_release(struct posix_acl *acl)
 
 extern void posix_acl_init(struct posix_acl *, int);
 extern struct posix_acl *posix_acl_alloc(int, gfp_t);
-extern int posix_acl_valid(const struct posix_acl *);
+extern int posix_acl_valid(struct user_namespace *, const struct posix_acl *);
 extern int posix_acl_permission(struct inode *, const struct posix_acl *, int);
 extern struct posix_acl *posix_acl_from_mode(umode_t, gfp_t);
 extern int posix_acl_equiv_mode(const struct posix_acl *, umode_t *);
-- 
2.8.3

