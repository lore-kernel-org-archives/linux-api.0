From: Richard Guy Briggs <rgb@redhat.com>
Subject: [PATCH ghak90 V7 19/21] audit: check cont depth
Date: Wed, 18 Sep 2019 21:22:36 -0400
Message-ID: <8cb68e43b55b1b0a021710402ded89444edaf13c.1568834525.git.rgb@redhat.com>
References: <cover.1568834524.git.rgb@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1568834524.git.rgb@redhat.com>
In-Reply-To: <cover.1568834524.git.rgb@redhat.com>
References: <cover.1568834524.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: containers@lists.linux-foundation.org, linux-api@vger.kernel.org, Linux-Audit Mailing List <linux-audit@redhat.com>, linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Cc: Paul Moore <paul@paul-moore.com>, sgrubb@redhat.com, omosnace@redhat.com, dhowells@redhat.com, simo@redhat.com, eparis@parisplace.org, serge@hallyn.com, ebiederm@xmission.com, nhorman@tuxdriver.com, dwalsh@redhat.com, mpatel@redhat.com, Richard Guy Briggs <rgb@redhat.com>
List-Id: linux-api@vger.kernel.org

Set an arbitrary limit on the depth of audit container identifier
nesting to limit abuse.

Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 kernel/audit.c | 21 +++++++++++++++++++++
 kernel/audit.h |  2 ++
 2 files changed, 23 insertions(+)

diff --git a/kernel/audit.c b/kernel/audit.c
index 848fd1c8c579..a70c9184e5d9 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -2667,6 +2667,22 @@ int audit_signal_info(int sig, struct task_struct *t)
 	return audit_signal_info_syscall(t);
 }
 
+static int audit_contid_depth(struct audit_cont *cont)
+{
+	struct audit_cont *parent;
+	int depth = 1;
+
+	if (!cont)
+		return 0;
+
+	parent = cont->parent;
+	while (parent) {
+		depth++;
+		parent = parent->parent;
+	}
+	return depth;
+}
+
 struct audit_cont *audit_cont(struct task_struct *tsk)
 {
 	if (!tsk->audit || !tsk->audit->cont)
@@ -2785,6 +2801,11 @@ int audit_set_contid(struct task_struct *task, u64 contid)
 			rc = -ENOSPC;
 			goto conterror;
 		}
+		/* Set max contid depth */
+		if (audit_contid_depth(audit_cont(current->real_parent)) >= AUDIT_CONTID_DEPTH) {
+			rc = -EMLINK;
+			goto conterror;
+		}
 		if (!newcont) {
 			newcont = kmalloc(sizeof(struct audit_cont), GFP_ATOMIC);
 			if (newcont) {
diff --git a/kernel/audit.h b/kernel/audit.h
index 89b7de323c13..cb25341c1a0f 100644
--- a/kernel/audit.h
+++ b/kernel/audit.h
@@ -231,6 +231,8 @@ struct audit_contid_status {
 	u64	id;
 };
 
+#define AUDIT_CONTID_DEPTH	5
+
 /* Indicates that audit should log the full pathname. */
 #define AUDIT_NAME_FULL -1
 
-- 
1.8.3.1
