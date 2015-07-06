From: Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 07/24] task_diag: add a new group to get process credentials
Date: Mon,  6 Jul 2015 11:47:08 +0300
Message-ID: <1436172445-6979-8-git-send-email-avagin@openvz.org>
References: <1436172445-6979-1-git-send-email-avagin@openvz.org>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1436172445-6979-1-git-send-email-avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Roger Luethi <rl-7uj+XXdSDtwfv37vnLkPlQ@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Ahern <dsahern-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Pavel Odintsov <pavel.odintsov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
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

This group is optional and it's filled only if show_flags contains
TASK_DIAG_SHOW_CRED.

Signed-off-by: Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
---
 include/uapi/linux/task_diag.h | 22 ++++++++++++++++++
 kernel/taskdiag.c              | 53 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 75 insertions(+)

diff --git a/include/uapi/linux/task_diag.h b/include/uapi/linux/task_diag.h
index 3a1e6c4..0e659d6 100644
--- a/include/uapi/linux/task_diag.h
+++ b/include/uapi/linux/task_diag.h
@@ -7,6 +7,7 @@
 enum {
 	/* optional attributes which can be specified in show_flags */
 	TASK_DIAG_BASE	= 0,
+	TASK_DIAG_CRED,
 
 	/* other attributes */
 	TASK_DIAG_PID	= 64,	/* u32 */
@@ -16,6 +17,7 @@ enum {
 };
 
 #define TASK_DIAG_SHOW_BASE	(1ULL << TASK_DIAG_BASE)
+#define TASK_DIAG_SHOW_CRED	(1ULL << TASK_DIAG_CRED)
 
 enum {
 	TASK_DIAG_RUNNING,
@@ -40,6 +42,26 @@ struct task_diag_base {
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
 #define TASK_DIAG_DUMP_ALL	0
 
 struct task_diag_pid {
diff --git a/kernel/taskdiag.c b/kernel/taskdiag.c
index 5771baf..5123e12 100644
--- a/kernel/taskdiag.c
+++ b/kernel/taskdiag.c
@@ -16,6 +16,9 @@ static size_t taskdiag_packet_size(u64 show_flags)
 	if (show_flags & TASK_DIAG_SHOW_BASE)
 		size += nla_total_size(sizeof(struct task_diag_base));
 
+	if (show_flags & TASK_DIAG_SHOW_CRED)
+		size += nla_total_size(sizeof(struct task_diag_creds));
+
 	return size;
 }
 
@@ -83,6 +86,48 @@ static int fill_task_base(struct task_struct *p, struct sk_buff *skb)
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
+	put_cred(cred);
+
+	return 0;
+}
+
 static int task_diag_fill(struct task_struct *tsk, struct sk_buff *skb,
 				u64 show_flags, u32 portid, u32 seq,
 				struct netlink_callback *cb)
@@ -115,6 +160,14 @@ static int task_diag_fill(struct task_struct *tsk, struct sk_buff *skb,
 		i++;
 	}
 
+	if (show_flags & TASK_DIAG_SHOW_CRED) {
+		if (i >= n)
+			err = fill_creds(tsk, skb);
+		if (err)
+			goto err;
+		i++;
+	}
+
 	genlmsg_end(skb, reply);
 	if (cb)
 		cb->args[2] = 0;
-- 
2.1.0
