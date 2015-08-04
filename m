From: Andreas Gruenbacher <andreas.gruenbacher-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [RFC v6 34/40] ext4: Don't allow unmapped identifiers in richacls
Date: Tue,  4 Aug 2015 13:53:32 +0200
Message-ID: <1438689218-6921-35-git-send-email-agruenba@redhat.com>
References: <1438689218-6921-1-git-send-email-agruenba@redhat.com>
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1438689218-6921-1-git-send-email-agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Don't allow acls which contain unmapped identifiers: they are meaningful
for remote file systems only.

Signed-off-by: Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/ext4/richacl.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/richacl.c b/fs/ext4/richacl.c
index 4385f6d..9d80299 100644
--- a/fs/ext4/richacl.c
+++ b/fs/ext4/richacl.c
@@ -68,8 +68,13 @@ ext4_set_richacl(handle_t *handle, struct inode *inode, struct richacl *acl)
 	int retval;
 
 	if (acl) {
-		mode_t mode = inode->i_mode;
+		mode_t mode;
 
+		/* Don't allow acls with unmapped identifiers. */
+		if (richacl_has_unmapped_identifiers(acl))
+			return -EINVAL;
+
+		mode = inode->i_mode;
 		if (richacl_equiv_mode(acl, &mode) == 0) {
 			inode->i_mode = mode;
 			ext4_mark_inode_dirty(handle, inode);
-- 
2.5.0

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
