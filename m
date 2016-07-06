From: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH review 02/12] userns: Handle -1 in k[ug]id_has_mapping when !CONFIG_USER_NS
Date: Wed,  6 Jul 2016 13:12:02 -0500
Message-ID: <20160706181212.16267-2-ebiederm@xmission.com>
References: <874m82bptc.fsf@x220.int.ebiederm.org>
 <20160706181212.16267-1-ebiederm@xmission.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20160706181212.16267-1-ebiederm@xmission.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Linux Containers <containers@lists.linux-foundation.org>
Cc: Seth Forshee <seth.forshee@canonical.com>, linux-fsdevel@vger.kernel.org, Linux API <linux-api@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Djalal Harouni <tixxdz@gmail.com>, "Serge E. Hallyn" <serge@hallyn.com>, Andy Lutomirski <luto@amacapital.net>, Jan Kara <jack@suse.cz>, Jann Horn <jann@thejh.net>, Michael Kerrisk <mtk.manpages@gmail.com>
List-Id: linux-api@vger.kernel.org

Refuse to admit any user namespace has a mapping of the INVALID_UID
and the INVALID_GID when !CONFIG_USER_NS.

Acked-by: Seth Forshee <seth.forshee@canonical.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 include/linux/uidgid.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/uidgid.h b/include/linux/uidgid.h
index 03835522dfcb..25e9d9216340 100644
--- a/include/linux/uidgid.h
+++ b/include/linux/uidgid.h
@@ -177,12 +177,12 @@ static inline gid_t from_kgid_munged(struct user_namespace *to, kgid_t kgid)
 
 static inline bool kuid_has_mapping(struct user_namespace *ns, kuid_t uid)
 {
-	return true;
+	return uid_valid(uid);
 }
 
 static inline bool kgid_has_mapping(struct user_namespace *ns, kgid_t gid)
 {
-	return true;
+	return gid_valid(gid);
 }
 
 #endif /* CONFIG_USER_NS */
-- 
2.8.3

