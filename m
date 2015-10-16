From: Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v11 27/48] richacl: Propagate everyone@ permissions to other aces
Date: Fri, 16 Oct 2015 17:18:05 +0200
Message-ID: <1445008706-15115-28-git-send-email-agruenba@redhat.com>
References: <1445008706-15115-1-git-send-email-agruenba@redhat.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1445008706-15115-1-git-send-email-agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Andreas Dilger <adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>, "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>, Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>, Anna Schumaker <anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

The trailing everyone@ allow ace can grant permissions to all file
classes including the owner and group class.  Before we can apply the
other mask to this entry to turn it into an "other class" entry, we need
to ensure that members of the owner or group class will not lose any
permissions from that ace.

Conceptually, we do this by inserting additional <who>:<allow>::allow
entries before the trailing everyone@ allow ace with the same
permissions as the trailing everyone@ allow ace for owner@, group@, and
all explicitly mentioned users and groups.  (In practice, we will rarely
need to insert any additional aces in this step.)

Signed-off-by: Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Reviewed-by: J. Bruce Fields <bfields-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/richacl_compat.c | 198 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 198 insertions(+)

diff --git a/fs/richacl_compat.c b/fs/richacl_compat.c
index 4f0acf5..7d007d7 100644
--- a/fs/richacl_compat.c
+++ b/fs/richacl_compat.c
@@ -218,3 +218,201 @@ richacl_move_everyone_aces_down(struct richacl_alloc *alloc)
 	}
 	return 0;
 }
+
+/**
+ * __richacl_propagate_everyone  -  propagate everyone@ permissions up for @who
+ * @alloc:	acl and number of allocated entries
+ * @who:	identifier to propagate permissions for
+ * @allow:	permissions to propagate up
+ *
+ * Propagate the permissions in @allow up from the end of the acl to the start
+ * for the specified principal @who.
+ *
+ * The simplest possible approach to achieve this would be to insert a
+ * "<who>:<allow>::allow" ace before the final everyone@ allow ace.  Since this
+ * would often result in aces which are not needed or which could be merged
+ * with an existing ace, we make the following optimizations:
+ *
+ *   - We go through the acl and determine which permissions are already
+ *     allowed or denied to @who, and we remove those permissions from
+ *     @allow.
+ *
+ *   - If the acl contains an allow ace for @who and no aces after this entry
+ *     deny permissions in @allow, we add the permissions in @allow to this
+ *     ace.  (Propagating permissions across a deny ace which can match the
+ *     process can elevate permissions.)
+ *
+ * This transformation does not alter the permissions that the acl grants.
+ */
+static int
+__richacl_propagate_everyone(struct richacl_alloc *alloc, struct richace *who,
+			     unsigned int allow)
+{
+	struct richace *allow_last = NULL, *ace;
+	struct richacl *acl = alloc->acl;
+
+	/*
+	 * Remove the permissions from allow that are already determined for
+	 * this who value, and figure out if there is an allow entry for
+	 * this who value that is "reachable" from the trailing everyone@
+	 * allow ace.
+	 */
+	richacl_for_each_entry(ace, acl) {
+		if (richace_is_inherit_only(ace))
+			continue;
+		if (richace_is_allow(ace)) {
+			if (richace_is_same_identifier(ace, who)) {
+				allow &= ~ace->e_mask;
+				allow_last = ace;
+			}
+		} else if (richace_is_deny(ace)) {
+			if (richace_is_same_identifier(ace, who))
+				allow &= ~ace->e_mask;
+			else if (allow & ace->e_mask)
+				allow_last = NULL;
+		}
+	}
+	ace--;
+
+	/*
+	 * If for group class entries, all the remaining permissions will
+	 * remain granted by the trailing everyone@ allow ace, no additional
+	 * entry is needed.
+	 */
+	if (!richace_is_owner(who) &&
+	    richace_is_everyone(ace) &&
+	    !(allow & ~(ace->e_mask & acl->a_other_mask)))
+		allow = 0;
+
+	if (allow) {
+		if (allow_last)
+			return richace_change_mask(alloc, &allow_last,
+						   allow_last->e_mask | allow);
+		else {
+			struct richace who_copy;
+
+			richace_copy(&who_copy, who);
+			if (richacl_insert_entry(alloc, &ace))
+				return -1;
+			richace_copy(ace, &who_copy);
+			ace->e_type = RICHACE_ACCESS_ALLOWED_ACE_TYPE;
+			ace->e_flags &= ~RICHACE_INHERITANCE_FLAGS;
+			ace->e_mask = allow;
+		}
+	}
+	return 0;
+}
+
+/**
+ * richacl_propagate_everyone  -  propagate everyone@ permissions up the acl
+ * @alloc:	acl and number of allocated entries
+ *
+ * Make sure that group@ and all other users and groups mentioned in the acl
+ * will not lose any permissions when finally applying the other mask to the
+ * everyone@ allow ace at the end of the acl.  We modify the permissions of
+ * existing entries or add new entries before the final everyone@ allow ace to
+ * achieve that.
+ *
+ * For example, the following acl implicitly grants everyone rwpx access:
+ *
+ *    joe:r::allow
+ *    everyone@:rwpx::allow
+ *
+ * When applying mode 0660 to this acl, group@ would lose rwp access, and joe
+ * would lose wp access even though the mode does not exclude those
+ * permissions.  After propagating the everyone@ permissions, the result for
+ * applying mode 0660 becomes:
+ *
+ *    owner@:rwp::allow
+ *    joe:rwp::allow
+ *    group@:rwp::allow
+ *
+ * Deny aces complicate the matter.  For example, the following acl grants
+ * everyone but joe write access:
+ *
+ *    joe:wp::deny
+ *    everyone@:rwpx::allow
+ *
+ * When applying mode 0660 to this acl, group@ would lose rwp access, and joe
+ * would lose r access.  After propagating the everyone@ permissions, the
+ * result for applying mode 0660 becomes:
+ *
+ *    owner@:rwp::allow
+ *    joe:w::deny
+ *    group@:rwp::allow
+ *    joe:r::allow
+ */
+static int
+richacl_propagate_everyone(struct richacl_alloc *alloc)
+{
+	struct richace who = { .e_flags = RICHACE_SPECIAL_WHO };
+	struct richacl *acl = alloc->acl;
+	struct richace *ace;
+	unsigned int owner_allow, group_allow;
+
+	if (!acl->a_count)
+		return 0;
+	ace = acl->a_entries + acl->a_count - 1;
+	if (richace_is_inherit_only(ace) || !richace_is_everyone(ace))
+		return 0;
+
+	/*
+	 * Permissions the owner and group class are granted through the
+	 * trailing everyone@ allow ace.
+	 */
+	owner_allow = ace->e_mask & acl->a_owner_mask;
+	group_allow = ace->e_mask & acl->a_group_mask;
+
+	/*
+	 * If the group or other masks hide permissions which the owner should
+	 * be allowed, we need to propagate those permissions up.  Otherwise,
+	 * those permissions may be lost when applying the other mask to the
+	 * trailing everyone@ allow ace, or when isolating the group class from
+	 * the other class through additional deny aces.
+	 */
+	if (owner_allow & ~(acl->a_group_mask & acl->a_other_mask)) {
+		/* Propagate everyone@ permissions through to owner@. */
+		who.e_id.special = RICHACE_OWNER_SPECIAL_ID;
+		if (__richacl_propagate_everyone(alloc, &who, owner_allow))
+			return -1;
+		acl = alloc->acl;
+	}
+
+	/*
+	 * If the other mask hides permissions which the group class should be
+	 * allowed, we need to propagate those permissions up to the owning
+	 * group and to all other members in the group class.
+	 */
+	if (group_allow & ~acl->a_other_mask) {
+		int n;
+
+		/* Propagate everyone@ permissions through to group@. */
+		who.e_id.special = RICHACE_GROUP_SPECIAL_ID;
+		if (__richacl_propagate_everyone(alloc, &who, group_allow))
+			return -1;
+		acl = alloc->acl;
+
+		/*
+		 * Start from the entry before the trailing everyone@ allow
+		 * entry. We will not hit everyone@ entries in the loop.
+		 */
+		for (n = acl->a_count - 2; n != -1; n--) {
+			ace = acl->a_entries + n;
+
+			if (richace_is_inherit_only(ace) ||
+			    richace_is_owner(ace) ||
+			    richace_is_group(ace))
+				continue;
+
+			/*
+			 * Any inserted entry will end up below the current
+			 * entry.
+			 */
+			if (__richacl_propagate_everyone(alloc, ace,
+							 group_allow))
+				return -1;
+			acl = alloc->acl;
+		}
+	}
+	return 0;
+}
-- 
2.5.0
