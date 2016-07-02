From: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH review 01/11] fs: Refuse uid/gid changes which don't map into s_user_ns
Date: Sat,  2 Jul 2016 12:20:25 -0500
Message-ID: <20160702172035.19568-1-ebiederm@xmission.com>
References: <87ziq03qnj.fsf@x220.int.ebiederm.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <87ziq03qnj.fsf@x220.int.ebiederm.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Seth Forshee <seth.forshee@canonical.com>
Cc: Linux Containers <containers@lists.linux-foundation.org>, linux-fsdevel@vger.kernel.org, Linux API <linux-api@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Djalal Harouni <tixxdz@gmail.com>, "Serge E. Hallyn" <serge@hallyn.com>, Andy Lutomirski <luto@amacapital.net>, Jan Kara <jack@suse.cz>, Jann Horn <jannh@google.com>, Michael Kerrisk <mtk.manpages@gmail.com>
List-Id: linux-api@vger.kernel.org

From: Seth Forshee <seth.forshee@canonical.com>

Add checks to notify_change to verify that uid and gid changes
will map into the superblock's user namespace. If they do not
fail with -EOVERFLOW.

This is mandatory so that fileystems don't have to even think
of dealing with ia_uid and ia_gid that

--EWB Moved the test from inode_change_ok to notify_change

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/attr.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/attr.c b/fs/attr.c
index 25b24d0f6c88..dd723578ddce 100644
--- a/fs/attr.c
+++ b/fs/attr.c
@@ -255,6 +255,17 @@ int notify_change(struct dentry * dentry, struct iattr * attr, struct inode **de
 	if (!(attr->ia_valid & ~(ATTR_KILL_SUID | ATTR_KILL_SGID)))
 		return 0;
 
+	/*
+	 * Verify that uid/gid changes are valid in the target
+	 * namespace of the superblock.
+	 */
+	if (ia_valid & ATTR_UID &&
+	    !kuid_has_mapping(inode->i_sb->s_user_ns, attr->ia_uid))
+		return -EOVERFLOW;
+	if (ia_valid & ATTR_GID &&
+	    !kgid_has_mapping(inode->i_sb->s_user_ns, attr->ia_gid))
+		return -EOVERFLOW;
+
 	error = security_inode_setattr(dentry, attr);
 	if (error)
 		return error;
-- 
2.8.3

