From: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH review 05/11] cred: Reject inodes with invalid ids in set_create_file_as()
Date: Sat,  2 Jul 2016 12:20:29 -0500
Message-ID: <20160702172035.19568-5-ebiederm@xmission.com>
References: <87ziq03qnj.fsf@x220.int.ebiederm.org>
 <20160702172035.19568-1-ebiederm@xmission.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20160702172035.19568-1-ebiederm@xmission.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Seth Forshee <seth.forshee@canonical.com>
Cc: Linux Containers <containers@lists.linux-foundation.org>, linux-fsdevel@vger.kernel.org, Linux API <linux-api@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Djalal Harouni <tixxdz@gmail.com>, "Serge E. Hallyn" <serge@hallyn.com>, Andy Lutomirski <luto@amacapital.net>, Jan Kara <jack@suse.cz>, Jann Horn <jannh@google.com>, Michael Kerrisk <mtk.manpages@gmail.com>
List-Id: linux-api@vger.kernel.org

From: Seth Forshee <seth.forshee@canonical.com>

Using INVALID_[UG]ID for the LSM file creation context doesn't
make sense, so return an error if the inode passed to
set_create_file_as() has an invalid id.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 kernel/cred.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/cred.c b/kernel/cred.c
index 0c0cd8a62285..5f264fb5737d 100644
--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -689,6 +689,8 @@ EXPORT_SYMBOL(set_security_override_from_ctx);
  */
 int set_create_files_as(struct cred *new, struct inode *inode)
 {
+	if (!uid_valid(inode->i_uid) || !gid_valid(inode->i_gid))
+		return -EINVAL;
 	new->fsuid = inode->i_uid;
 	new->fsgid = inode->i_gid;
 	return security_kernel_create_files_as(new, inode);
-- 
2.8.3

