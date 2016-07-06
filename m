From: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH review 04/12] fs: Check for invalid i_uid in may_follow_link()
Date: Wed,  6 Jul 2016 13:12:04 -0500
Message-ID: <20160706181212.16267-4-ebiederm@xmission.com>
References: <874m82bptc.fsf@x220.int.ebiederm.org>
 <20160706181212.16267-1-ebiederm@xmission.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20160706181212.16267-1-ebiederm@xmission.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Linux Containers <containers@lists.linux-foundation.org>
Cc: Seth Forshee <seth.forshee@canonical.com>, linux-fsdevel@vger.kernel.org, Linux API <linux-api@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Djalal Harouni <tixxdz@gmail.com>, "Serge E. Hallyn" <serge@hallyn.com>, Andy Lutomirski <luto@amacapital.net>, Jan Kara <jack@suse.cz>, Jann Horn <jann@thejh.net>, Michael Kerrisk <mtk.manpages@gmail.com>
List-Id: linux-api@vger.kernel.org

From: Seth Forshee <seth.forshee@canonical.com>

Filesystem uids which don't map into a user namespace may result
in inode->i_uid being INVALID_UID. A symlink and its parent
could have different owners in the filesystem can both get
mapped to INVALID_UID, which may result in following a symlink
when this would not have otherwise been permitted when protected
symlinks are enabled.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/namei.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/namei.c b/fs/namei.c
index 757a32725d92..8701bd9a5270 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -901,6 +901,7 @@ static inline int may_follow_link(struct nameidata *nd)
 {
 	const struct inode *inode;
 	const struct inode *parent;
+	kuid_t puid;
 
 	if (!sysctl_protected_symlinks)
 		return 0;
@@ -916,7 +917,8 @@ static inline int may_follow_link(struct nameidata *nd)
 		return 0;
 
 	/* Allowed if parent directory and link owner match. */
-	if (uid_eq(parent->i_uid, inode->i_uid))
+	puid = parent->i_uid;
+	if (uid_valid(puid) && uid_eq(puid, inode->i_uid))
 		return 0;
 
 	if (nd->flags & LOOKUP_RCU)
-- 
2.8.3

