From: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH review 09/12] quota: Handle quota data stored in s_user_ns in quota_setxquota
Date: Wed,  6 Jul 2016 13:12:09 -0500
Message-ID: <20160706181212.16267-9-ebiederm@xmission.com>
References: <874m82bptc.fsf@x220.int.ebiederm.org>
 <20160706181212.16267-1-ebiederm@xmission.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20160706181212.16267-1-ebiederm@xmission.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Linux Containers <containers@lists.linux-foundation.org>
Cc: Seth Forshee <seth.forshee@canonical.com>, linux-fsdevel@vger.kernel.org, Linux API <linux-api@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Djalal Harouni <tixxdz@gmail.com>, "Serge E. Hallyn" <serge@hallyn.com>, Andy Lutomirski <luto@amacapital.net>, Jan Kara <jack@suse.cz>, Jann Horn <jann@thejh.net>, Michael Kerrisk <mtk.manpages@gmail.com>
List-Id: linux-api@vger.kernel.org

In Q_XSETQLIMIT use sb->s_user_ns to detect when we are dealing with
the filesystems notion of id 0.

Cc: Jan Kara <jack@suse.cz>
Acked-by: Seth Forshee <seth.forshee@canonical.com>
Inspired-by: Seth Forshee <seth.forshee@canonical.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/quota/quota.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/quota/quota.c b/fs/quota/quota.c
index 73f6f4cf0a21..35df08ee9c97 100644
--- a/fs/quota/quota.c
+++ b/fs/quota/quota.c
@@ -584,7 +584,7 @@ static int quota_setxquota(struct super_block *sb, int type, qid_t id,
 	if (!qid_has_mapping(sb->s_user_ns, qid))
 		return -EINVAL;
 	/* Are we actually setting timer / warning limits for all users? */
-	if (from_kqid(&init_user_ns, qid) == 0 &&
+	if (from_kqid(sb->s_user_ns, qid) == 0 &&
 	    fdq.d_fieldmask & (FS_DQ_WARNS_MASK | FS_DQ_TIMER_MASK)) {
 		struct qc_info qinfo;
 		int ret;
-- 
2.8.3

