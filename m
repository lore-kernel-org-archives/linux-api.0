From: Richard Guy Briggs <rgb@redhat.com>
Subject: [PATCH ghak90 (was ghak32) V4 06/10] audit: add containerid support for tty_audit
Date: Tue, 31 Jul 2018 16:07:41 -0400
Message-ID: <e41cb6760a8183c0955c378fce7b500819f9838f.1533065887.git.rgb@redhat.com>
References: <cover.1533065887.git.rgb@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1533065887.git.rgb@redhat.com>
In-Reply-To: <cover.1533065887.git.rgb@redhat.com>
References: <cover.1533065887.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: containers@lists.linux-foundation.org, linux-api@vger.kernel.org, Linux-Audit Mailing List <linux-audit@redhat.com>, linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Cc: luto@kernel.org, carlos@redhat.com, viro@zeniv.linux.org.uk, dhowells@redhat.com, simo@redhat.com, eparis@parisplace.org, serge@hallyn.com, ebiederm@xmission.com, Richard Guy Briggs <rgb@redhat.com>
List-Id: linux-api@vger.kernel.org

Add audit container identifier auxiliary record to tty logging rule
event standalone records.

Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
Acked-by: Serge Hallyn <serge@hallyn.com>
---
 drivers/tty/tty_audit.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/tty_audit.c b/drivers/tty/tty_audit.c
index 50f567b..3e21477 100644
--- a/drivers/tty/tty_audit.c
+++ b/drivers/tty/tty_audit.c
@@ -66,8 +66,9 @@ static void tty_audit_log(const char *description, dev_t dev,
 	uid_t uid = from_kuid(&init_user_ns, task_uid(tsk));
 	uid_t loginuid = from_kuid(&init_user_ns, audit_get_loginuid(tsk));
 	unsigned int sessionid = audit_get_sessionid(tsk);
+	struct audit_context *context = audit_alloc_local(GFP_KERNEL);
 
-	ab = audit_log_start(NULL, GFP_KERNEL, AUDIT_TTY);
+	ab = audit_log_start(context, GFP_KERNEL, AUDIT_TTY);
 	if (ab) {
 		char name[sizeof(tsk->comm)];
 
@@ -80,6 +81,8 @@ static void tty_audit_log(const char *description, dev_t dev,
 		audit_log_n_hex(ab, data, size);
 		audit_log_end(ab);
 	}
+	audit_log_contid(context, "tty", audit_get_contid(tsk));
+	audit_free_context(context);
 }
 
 /**
-- 
1.8.3.1
