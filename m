From: Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 4/7] task-diag: add a new group to get process credentials
Date: Tue, 17 Feb 2015 11:20:23 +0300
Message-ID: <1424161226-15176-5-git-send-email-avagin@openvz.org>
References: <1424161226-15176-1-git-send-email-avagin@openvz.org>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1424161226-15176-1-git-send-email-avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Roger Luethi <rl-7uj+XXdSDtwfv37vnLkPlQ@public.gmane.org>, Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

A response is represented by the task_diag_creds structure:

struct task_diag_creds {
       struct task_diag_caps cap_inheritable;
       struct task_diag_caps cap_permitted;
       struct task_diag_caps cap_effective;
       struct task_diag_caps cap_bset;

       __u32 uid;
       __u32 euid;
       __u32 suid;
       __u32 fsuid;
       __u32 gid;
       __u32 egid;
       __u32 sgid;
       __u32 fsgid;
};

This group is optional and it filled only if show_flags contains
TASK_DIAG_SHOW_CRED.

Signed-off-by: Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
---
 include/uapi/linux/taskdiag.h | 23 ++++++++++++++++++
 kernel/taskdiag.c             | 55 ++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 77 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/taskdiag.h b/include/uapi/linux/taskdiag.h
index e1feb35..db12f6d 100644
--- a/include/uapi/linux/taskdiag.h
+++ b/include/uapi/linux/taskdiag.h
@@ -9,11 +9,14 @@
 
 enum {
 	/* optional attributes which can be specified in show_flags */
+	TASK_DIAG_CRED,
 
 	/* other attributes */
 	TASK_DIAG_MSG = 64,
 };
 
+#define TASK_DIAG_SHOW_CRED (1ULL << TASK_DIAG_CRED)
+
 enum {
 	TASK_DIAG_RUNNING,
 	TASK_DIAG_INTERRUPTIBLE,
@@ -37,6 +40,26 @@ struct task_diag_msg {
 	char	comm[TASK_DIAG_COMM_LEN];
 };
 
+struct task_diag_caps {
+	__u32 cap[_LINUX_CAPABILITY_U32S_3];
+};
+
+struct task_diag_creds {
+	struct task_diag_caps cap_inheritable;
+	struct task_diag_caps cap_permitted;
+	struct task_diag_caps cap_effective;
+	struct task_diag_caps cap_bset;
+
+	__u32 uid;
+	__u32 euid;
+	__u32 suid;
+	__u32 fsuid;
+	__u32 gid;
+	__u32 egid;
+	__u32 sgid;
+	__u32 fsgid;
+};
+
 enum {
 	TASKDIAG_CMD_UNSPEC = 0,	/* Reserved */
 	TASKDIAG_CMD_GET,
diff --git a/kernel/taskdiag.c b/kernel/taskdiag.c
index da4a51b..6ccbcaf 100644
--- a/kernel/taskdiag.c
+++ b/kernel/taskdiag.c
@@ -15,7 +15,14 @@ static struct genl_family family = {
 
 static size_t taskdiag_packet_size(u64 show_flags)
 {
-	return nla_total_size(sizeof(struct task_diag_msg));
+	size_t size;
+
+	size = nla_total_size(sizeof(struct task_diag_msg));
+
+	if (show_flags & TASK_DIAG_SHOW_CRED)
+		size += nla_total_size(sizeof(struct task_diag_creds));
+
+	return size;
 }
 
 /*
@@ -82,6 +89,46 @@ static int fill_task_msg(struct task_struct *p, struct sk_buff *skb)
 	return 0;
 }
 
+static inline void caps2diag(struct task_diag_caps *diag, const kernel_cap_t *cap)
+{
+	int i;
+
+	for (i = 0; i < _LINUX_CAPABILITY_U32S_3; i++)
+		diag->cap[i] = cap->cap[i];
+}
+
+static int fill_creds(struct task_struct *p, struct sk_buff *skb)
+{
+	struct user_namespace *user_ns = current_user_ns();
+	struct task_diag_creds *diag_cred;
+	const struct cred *cred;
+	struct nlattr *attr;
+
+	attr = nla_reserve(skb, TASK_DIAG_CRED, sizeof(struct task_diag_creds));
+	if (!attr)
+		return -EMSGSIZE;
+
+	diag_cred = nla_data(attr);
+
+	cred = get_task_cred(p);
+
+	caps2diag(&diag_cred->cap_inheritable, &cred->cap_inheritable);
+	caps2diag(&diag_cred->cap_permitted, &cred->cap_permitted);
+	caps2diag(&diag_cred->cap_effective, &cred->cap_effective);
+	caps2diag(&diag_cred->cap_bset, &cred->cap_bset);
+
+	diag_cred->uid   = from_kuid_munged(user_ns, cred->uid);
+	diag_cred->euid  = from_kuid_munged(user_ns, cred->euid);
+	diag_cred->suid  = from_kuid_munged(user_ns, cred->suid);
+	diag_cred->fsuid = from_kuid_munged(user_ns, cred->fsuid);
+	diag_cred->gid   = from_kgid_munged(user_ns, cred->gid);
+	diag_cred->egid  = from_kgid_munged(user_ns, cred->egid);
+	diag_cred->sgid  = from_kgid_munged(user_ns, cred->sgid);
+	diag_cred->fsgid = from_kgid_munged(user_ns, cred->fsgid);
+
+	return 0;
+}
+
 static int task_diag_fill(struct task_struct *tsk, struct sk_buff *skb,
 				u64 show_flags, u32 portid, u32 seq)
 {
@@ -96,6 +143,12 @@ static int task_diag_fill(struct task_struct *tsk, struct sk_buff *skb,
 	if (err)
 		goto err;
 
+	if (show_flags & TASK_DIAG_SHOW_CRED) {
+		err = fill_creds(tsk, skb);
+		if (err)
+			goto err;
+	}
+
 	return genlmsg_end(skb, reply);
 err:
 	genlmsg_cancel(skb, reply);
-- 
2.1.0
