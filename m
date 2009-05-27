From: Oren Laadan <orenl-eQaUEPhvms7ENvBUuze7eA@public.gmane.org>
Subject: [RFC v16][PATCH 30/43] c/r: stub implementation for IPC namespace
Date: Wed, 27 May 2009 13:32:56 -0400
Message-ID: <1243445589-32388-31-git-send-email-orenl@cs.columbia.edu>
References: <1243445589-32388-1-git-send-email-orenl@cs.columbia.edu>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1243445589-32388-1-git-send-email-orenl-eQaUEPhvms7ENvBUuze7eA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Linus Torvalds <torvalds-3NddpPZAyC0@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Serge Hallyn <serue-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, Dave Hansen <dave-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Pavel Emelyanov <xemul-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Dan Smith <danms-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, Oren Laadan <orenl-eQaUEPhvms7ENvBUuze7eA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

From: Dan Smith <danms-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>

Changes:
 - Update to match UTS changes

Signed-off-by: Dan Smith <danms-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Oren Laadan <orenl-eQaUEPhvms7ENvBUuze7eA@public.gmane.org>
---
 checkpoint/checkpoint.c        |    2 --
 checkpoint/objhash.c           |   28 ++++++++++++++++++++++++++++
 checkpoint/process.c           |   24 ++++++++++++++++++++++--
 include/linux/checkpoint.h     |   15 +++++++++++++++
 include/linux/checkpoint_hdr.h |    3 +++
 5 files changed, 68 insertions(+), 4 deletions(-)

diff --git a/checkpoint/checkpoint.c b/checkpoint/checkpoint.c
index 904f19b..afc7300 100644
--- a/checkpoint/checkpoint.c
+++ b/checkpoint/checkpoint.c
@@ -310,8 +310,6 @@ static int may_checkpoint_task(struct ckpt_ctx *ctx, struct task_struct *t)
 
 	rcu_read_lock();
 	nsproxy = task_nsproxy(t);
-	if (nsproxy->ipc_ns != ctx->root_nsproxy->ipc_ns)
-		ret = -EPERM;
 	if (nsproxy->mnt_ns != ctx->root_nsproxy->mnt_ns)
 		ret = -EPERM;
 	if (nsproxy->pid_ns != ctx->root_nsproxy->pid_ns)
diff --git a/checkpoint/objhash.c b/checkpoint/objhash.c
index 8b7adc6..045a920 100644
--- a/checkpoint/objhash.c
+++ b/checkpoint/objhash.c
@@ -15,6 +15,8 @@
 #include <linux/hash.h>
 #include <linux/file.h>
 #include <linux/fdtable.h>
+#include <linux/sched.h>
+#include <linux/ipc_namespace.h>
 #include <linux/checkpoint.h>
 #include <linux/checkpoint_hdr.h>
 
@@ -159,6 +161,22 @@ static int obj_uts_ns_users(void *ptr)
 	return atomic_read(&((struct uts_namespace *) ptr)->kref.refcount);
 }
 
+static int obj_ipc_ns_grab(void *ptr)
+{
+	get_ipc_ns((struct ipc_namespace *) ptr);
+	return 0;
+}
+
+static void obj_ipc_ns_drop(void *ptr)
+{
+	put_ipc_ns((struct ipc_namespace *) ptr);
+}
+
+static int obj_ipc_ns_users(void *ptr)
+{
+	return atomic_read(&((struct ipc_namespace *) ptr)->count);
+}
+
 static struct ckpt_obj_ops ckpt_obj_ops[] = {
 	/* ignored object */
 	{
@@ -226,6 +244,16 @@ static struct ckpt_obj_ops ckpt_obj_ops[] = {
 		.checkpoint = checkpoint_bad,
 		.restore = restore_bad,
 	},
+	/* ipc_ns object */
+	{
+		.obj_name = "IPC_NS",
+		.obj_type = CKPT_OBJ_IPC_NS,
+		.ref_drop = obj_ipc_ns_drop,
+		.ref_grab = obj_ipc_ns_grab,
+		.ref_users = obj_ipc_ns_users,
+		.checkpoint = checkpoint_bad,
+		.restore = restore_bad,
+	},
 };
 
 
diff --git a/checkpoint/process.c b/checkpoint/process.c
index a827987..eff3d76 100644
--- a/checkpoint/process.c
+++ b/checkpoint/process.c
@@ -89,6 +89,7 @@ static int do_checkpoint_ns(struct ckpt_ctx *ctx, struct nsproxy *nsproxy)
 	struct ckpt_hdr_ns *h;
 	int ns_flags = 0;
 	int uts_objref;
+	int ipc_objref;
 	int first, ret;
 
 	uts_objref = ckpt_obj_lookup_add(ctx, nsproxy->uts_ns,
@@ -98,12 +99,20 @@ static int do_checkpoint_ns(struct ckpt_ctx *ctx, struct nsproxy *nsproxy)
 	if (first)
 		ns_flags |= CLONE_NEWUTS;
 
+	ipc_objref = ckpt_obj_lookup_add(ctx, nsproxy->ipc_ns,
+					 CKPT_OBJ_IPC_NS, &first);
+	if (ipc_objref < 0)
+		return ipc_objref;
+	if (first)
+		ns_flags |= CLONE_NEWIPC;
+
 	h = ckpt_hdr_get_type(ctx, sizeof(*h), CKPT_HDR_NS);
 	if (!h)
 		return -ENOMEM;
 
 	h->flags = ns_flags;
 	h->uts_objref = uts_objref;
+	h->ipc_objref = ipc_objref;
 
 	ret = ckpt_write_obj(ctx, &h->h);
 	ckpt_hdr_put(ctx, h);
@@ -112,6 +121,10 @@ static int do_checkpoint_ns(struct ckpt_ctx *ctx, struct nsproxy *nsproxy)
 
 	if (ns_flags & CLONE_NEWUTS)
 		ret = checkpoint_uts_ns(ctx, nsproxy->uts_ns);
+#if 0
+	if (!ret && (ns_flags & CLONE_NEWIPC))
+		ret = checkpoint_ipc_ns(ctx, nsproxy->ipc_ns);
+#endif
 
 	/* FIX: Write other namespaces here */
 	return ret;
@@ -438,9 +451,10 @@ static struct nsproxy *do_restore_ns(struct ckpt_ctx *ctx)
 		return (struct nsproxy *) h;
 
 	ret = -EINVAL;
-	if (h->uts_objref <= 0)
+	if (h->uts_objref <= 0 ||
+	    h->ipc_objref <= 0)
 		goto out;
-	if (h->flags & ~CLONE_NEWUTS)
+	if (h->flags & ~(CLONE_NEWUTS | CLONE_NEWIPC))
 		goto out;
 
 	/* each unseen-before namespace will be un-shared now */
@@ -456,6 +470,12 @@ static struct nsproxy *do_restore_ns(struct ckpt_ctx *ctx)
 	 */
 	ret = restore_uts_ns(ctx, h->uts_objref, h->flags);
 	ckpt_debug("uts ns: %d\n", ret);
+	if (ret < 0)
+		goto out;
+#if 0
+	ret = restore_ipc_ns(ctx, h->ipc_objref, h->flags);
+	ckpt_debug("ipc ns: %d\n", ret);
+#endif
 
 	/* FIX: add more namespaces here */
  out:
diff --git a/include/linux/checkpoint.h b/include/linux/checkpoint.h
index a7125fc..5a42399 100644
--- a/include/linux/checkpoint.h
+++ b/include/linux/checkpoint.h
@@ -81,6 +81,21 @@ extern int restore_restart_block(struct ckpt_ctx *ctx);
 extern int checkpoint_ns(struct ckpt_ctx *ctx, void *ptr);
 extern void *restore_ns(struct ckpt_ctx *ctx);
 
+#if 0
+/* ipc-ns */
+#ifdef CONFIG_SYSVIPC
+extern int checkpoint_ipc_ns(struct ckpt_ctx *ctx,
+			     struct ipc_namespace *ipc_ns);
+extern int restore_ipc_ns(struct ckpt_ctx *ctx, int ns_objref, int flags);
+#else
+static inline int checkpoint_ipc_ns(struct ckpt_ctx *ctx,
+				    struct ipc_namespace *ipc_ns)
+{ return 0; }
+static inline int restore_ipc_ns(struct ckpt_ctx *ctx)
+{ return 0; }
+#endif /* CONFIG_SYSVIPC */
+#endif
+
 /* file table */
 extern int checkpoint_obj_file_table(struct ckpt_ctx *ctx,
 				     struct task_struct *t);
diff --git a/include/linux/checkpoint_hdr.h b/include/linux/checkpoint_hdr.h
index 1603279..44a48dc 100644
--- a/include/linux/checkpoint_hdr.h
+++ b/include/linux/checkpoint_hdr.h
@@ -55,6 +55,7 @@ enum {
 	CKPT_HDR_CPU,
 	CKPT_HDR_NS,
 	CKPT_HDR_UTS_NS,
+	CKPT_HDR_IPC_NS,
 
 	/* 201-299: reserved for arch-dependent */
 
@@ -95,6 +96,7 @@ enum obj_type {
 	CKPT_OBJ_MM,
 	CKPT_OBJ_NS,
 	CKPT_OBJ_UTS_NS,
+	CKPT_OBJ_IPC_NS,
 	CKPT_OBJ_MAX
 };
 
@@ -167,6 +169,7 @@ struct ckpt_hdr_ns {
 	struct ckpt_hdr h;
 	__u32 flags;
 	__s32 uts_objref;
+	__u32 ipc_objref;
 } __attribute__((aligned(8)));
 
 /* task's shared resources */
-- 
1.6.0.4

--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
