From: Andreas Gruenbacher <andreas.gruenbacher-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [RFC v6 23/40] richacl: Set the owner permissions to the owner mask
Date: Tue,  4 Aug 2015 13:53:21 +0200
Message-ID: <1438689218-6921-24-git-send-email-agruenba@redhat.com>
References: <1438689218-6921-1-git-send-email-agruenba@redhat.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1438689218-6921-1-git-send-email-agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Change the acl so that owner@ is granted the permissions set in the
owner mask.

Signed-off-by: Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/richacl_compat.c | 46 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/fs/richacl_compat.c b/fs/richacl_compat.c
index e9c350e..807372d 100644
--- a/fs/richacl_compat.c
+++ b/fs/richacl_compat.c
@@ -412,3 +412,49 @@ richacl_propagate_everyone(struct richacl_alloc *alloc)
 	}
 	return 0;
 }
+
+/**
+ * richacl_set_owner_permissions  -  set the owner permissions to the owner mask
+ *
+ * Change the acl so that owner@ is granted the permissions set in the owner
+ * mask.  This leaves at most one efective owner@ allow entry at the beginning
+ * of the acl.
+ */
+static int
+richacl_set_owner_permissions(struct richacl_alloc *alloc)
+{
+	unsigned int x = RICHACE_POSIX_ALWAYS_ALLOWED;
+	unsigned int owner_mask = alloc->acl->a_owner_mask & ~x;
+	unsigned int denied = 0;
+	struct richace *ace;
+
+	if (!((alloc->acl->a_flags & RICHACL_WRITE_THROUGH) &&
+	      (alloc->acl->a_flags & RICHACL_MASKED)))
+		return 0;
+
+	richacl_for_each_entry(ace, alloc->acl) {
+		if (richace_is_owner(ace)) {
+			if (richace_is_allow(ace) && !(owner_mask & denied)) {
+				richace_change_mask(alloc, &ace, owner_mask);
+				owner_mask = 0;
+			} else
+				richace_change_mask(alloc, &ace, 0);
+		} else {
+			if (richace_is_deny(ace))
+				denied |= ace->e_mask;
+		}
+	}
+
+	if (owner_mask & (denied |
+			  ~alloc->acl->a_other_mask |
+			  ~alloc->acl->a_group_mask)) {
+		ace = alloc->acl->a_entries;
+		if (richacl_insert_entry(alloc, &ace))
+			return -1;
+		ace->e_type = RICHACE_ACCESS_ALLOWED_ACE_TYPE;
+		ace->e_flags = RICHACE_SPECIAL_WHO;
+		ace->e_mask = owner_mask;
+		ace->e_id.special = RICHACE_OWNER_SPECIAL_ID;
+	}
+	return 0;
+}
-- 
2.5.0
