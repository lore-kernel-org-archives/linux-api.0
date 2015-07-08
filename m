From: Paul Osmialowski <p.osmialowsk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Subject: [RFC 4/8] lsm: smack: smack callbacks for kdbus security hooks
Date: Wed, 08 Jul 2015 12:25:06 +0200
Message-ID: <1436351110-5902-5-git-send-email-p.osmialowsk@samsung.com>
References: <1436351110-5902-1-git-send-email-p.osmialowsk@samsung.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <1436351110-5902-1-git-send-email-p.osmialowsk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Paul Moore <pmoore-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Casey Schaufler <casey-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org>, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>, Stephen Smalley <sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>, Neil Brown <neilb-l3A5Bk7waGM@public.gmane.org>, Mark Rustad <mark.d.rustad-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>, David Herrmann <dh.herrmann-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>, Djalal Harouni <tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Karol Lewandowski <k.lewandowsk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Paul Osmialowski <p.osmialowsk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Lukasz Skalski <l.skalski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

This adds implementation of three smack callbacks sitting behind kdbus
security hooks as proposed by Karol Lewandowski.

Originates from:

git://git.infradead.org/users/pcmoore/selinux (branch: working-kdbus)
commit: fc3505d058c001fe72a6f66b833e0be5b2d118f3

https://github.com/lmctl/linux.git (branch: kdbus-lsm-v4.for-systemd-v212)
commit: 103c26fd27d1ec8c32d85dd3d85681f936ac66fb

Signed-off-by: Karol Lewandowski <k.lewandowsk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Signed-off-by: Paul Osmialowski <p.osmialowsk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
---
 security/smack/smack_lsm.c | 68 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 68 insertions(+)

diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index a143328..033b756 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -41,6 +41,7 @@
 #include <linux/msg.h>
 #include <linux/shm.h>
 #include <linux/binfmts.h>
+#include <kdbus/connection.h>
 #include "smack.h"
 
 #define TRANS_TRUE	"TRUE"
@@ -3336,6 +3337,69 @@ static int smack_setprocattr(struct task_struct *p, char *name,
 }
 
 /**
+ * smack_kdbus_connect - Set the security blob for a KDBus connection
+ * @conn: the connection
+ * @secctx: smack label
+ * @seclen: smack label length
+ *
+ * Returns 0
+ */
+static int smack_kdbus_connect(struct kdbus_conn *conn,
+			       const char *secctx, u32 seclen)
+{
+	struct smack_known *skp;
+
+	if (secctx && seclen > 0)
+		skp = smk_import_entry(secctx, seclen);
+	else
+		skp = smk_of_current();
+	conn->security = skp;
+
+	return 0;
+}
+
+/**
+ * smack_kdbus_conn_free - Clear the security blob for a KDBus connection
+ * @conn: the connection
+ *
+ * Clears the blob pointer
+ */
+static void smack_kdbus_conn_free(struct kdbus_conn *conn)
+{
+	conn->security = NULL;
+}
+
+/**
+ * smack_kdbus_talk - Smack access on KDBus
+ * @src: source kdbus connection
+ * @dst: destination kdbus connection
+ *
+ * Return 0 if a subject with the smack of sock could access
+ * an object with the smack of other, otherwise an error code
+ */
+static int smack_kdbus_talk(const struct kdbus_conn *src,
+			    const struct kdbus_conn *dst)
+{
+	struct smk_audit_info ad;
+	struct smack_known *sskp = src->security;
+	struct smack_known *dskp = dst->security;
+	int ret;
+
+	BUG_ON(sskp == NULL);
+	BUG_ON(dskp == NULL);
+
+	if (smack_privileged(CAP_MAC_OVERRIDE))
+		return 0;
+
+	smk_ad_init(&ad, __func__, LSM_AUDIT_DATA_NONE);
+
+	ret = smk_access(sskp, dskp, MAY_WRITE, &ad);
+	if (ret)
+		return ret;
+	return 0;
+}
+
+/**
  * smack_unix_stream_connect - Smack access on UDS
  * @sock: one sock
  * @other: the other sock
@@ -4393,6 +4457,10 @@ struct security_hook_list smack_hooks[] = {
 	LSM_HOOK_INIT(inode_notifysecctx, smack_inode_notifysecctx),
 	LSM_HOOK_INIT(inode_setsecctx, smack_inode_setsecctx),
 	LSM_HOOK_INIT(inode_getsecctx, smack_inode_getsecctx),
+
+	LSM_HOOK_INIT(kdbus_connect, smack_kdbus_connect),
+	LSM_HOOK_INIT(kdbus_conn_free, smack_kdbus_conn_free),
+	LSM_HOOK_INIT(kdbus_talk, smack_kdbus_talk),
 };
 
 
-- 
1.9.1
