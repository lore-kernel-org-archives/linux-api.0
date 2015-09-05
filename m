From: Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [RFC v7 24/41] richacl: Set the other permissions to the other mask
Date: Sat,  5 Sep 2015 12:27:19 +0200
Message-ID: <1441448856-13478-25-git-send-email-agruenba@redhat.com>
References: <1441448856-13478-1-git-send-email-agruenba@redhat.com>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1441448856-13478-1-git-send-email-agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Change the acl so that everyone@ is granted the permissions set in the
other mask.

Signed-off-by: Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/richacl_compat.c | 35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/fs/richacl_compat.c b/fs/richacl_compat.c
index 14a1b4b..30bdc95 100644
--- a/fs/richacl_compat.c
+++ b/fs/richacl_compat.c
@@ -459,3 +459,38 @@ richacl_set_owner_permissions(struct richacl_alloc *alloc)
 	}
 	return 0;
 }
+
+/**
+ * richacl_set_other_permissions  -  set the other permissions to the other mask
+ *
+ * Change the acl so that everyone@ is granted the permissions set in the other
+ * mask.  This leaves at most one efective everyone@ allow entry at the end of
+ * the acl.
+ */
+static int
+richacl_set_other_permissions(struct richacl_alloc *alloc)
+{
+	struct richacl *acl = alloc->acl;
+	unsigned int x = RICHACE_POSIX_ALWAYS_ALLOWED;
+	unsigned int other_mask = acl->a_other_mask & ~x;
+	struct richace *ace = acl->a_entries + acl->a_count - 1;
+
+	if (!(other_mask &&
+	      (acl->a_flags & RICHACL_WRITE_THROUGH) &&
+	      (acl->a_flags & RICHACL_MASKED)))
+		return 0;
+
+	if (acl->a_count == 0 ||
+	    !richace_is_everyone(ace) ||
+	    richace_is_inherit_only(ace)) {
+		ace++;
+		if (richacl_insert_entry(alloc, &ace))
+			return -1;
+		ace->e_type = RICHACE_ACCESS_ALLOWED_ACE_TYPE;
+		ace->e_flags = RICHACE_SPECIAL_WHO;
+		ace->e_mask = other_mask;
+		ace->e_id.special = RICHACE_EVERYONE_SPECIAL_ID;
+	} else
+		richace_change_mask(alloc, &ace, other_mask);
+	return 0;
+}
-- 
2.4.3
