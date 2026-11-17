Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794957282;
	b=ABIlvwVllU8Jhv2Z4bSt0uOxiE0xTMz+yc7TBLFAXeyV8z8roF4aIvJk3RREtywAT45Q
	 8HHy9ljZP8UKz9TijlwMUXv+QQbG76ms7w5q94CL56Xnlzc4mErBz5oFdM4ZUPwYynzji
	 MFWiIJubQ+q03WqY670xRrF4YwH1IAhGscAwsk3VVnQQtiQpff6xie/NDaiaC2X94qtml
	 tWI9e5zUgBn8n1B1u8u6ovY/RSAYftGWERZJE+fxSXvXuye4yhtVzftkccGIXuQ/dxJzH
	 iiF3fXS32NkartY/EPdQDBgBDgQzRquHmFxQevUSPFSdgIIFokGzPbqRAEguVYOFbGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794957282;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=YM03tj0qhFqGxTChBGNPgoRuD3foZkehP4IPWon9Cak=;
	b=jvysgB8q1hxov+oYgo/d+Mf60KyRfATRt/eCPYd+dtXf93jHPWXf+aDeKG1i3cTcGlNl
	 yh7OSAcKdL1W8REbdteSS7RyTw4D28hI5f/ISupcWfrrIpYBt1xMgYzT5dPDW/YD/1vVf
	 F9j0RBZHcMrxjAjCTn9k/IgUee+DbN7VinS1QreH7vTvDzXLcT88tpmQyPJX9l8y5YgYQ
	 EYdpIqFCDs060hOEQs/2nXtXG1ICFfsr/W1qAFNM5Wm6AW5IgAgkW/6Kq2qq+T8t+uYv4
	 HPb35BRklx8yKBL4dbEEOucStyMoU28jufUEvBmXvumDDIz7jj1gDG+QBB03BnlDHYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LlbF1Z8k;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 342DE606A333;
	Tue, 17 Nov 2026 23:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LlbF1Z8k
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 13F081F000C7;
	Tue, 17 Nov 2026 23:14:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794957281;
	bh=YM03tj0qhFqGxTChBGNPgoRuD3foZkehP4IPWon9Cak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LlbF1Z8kYcrI81oTdyGlWvMBJelrKdR1O0TNUGnwdcSbm1rm5rYP2lq8EA8WLEmHu
	 Ae2hPOt8GGUUFMavRV3OHSY2o5KUQXiJIoLwa/y8zyDkzVkamtybC8Bqh+hqdS4LLk
	 +n/Wtcnkw0q4/KieF+4OlYnFr2sSuK2UrrDWe1RUoFeCTJcJqMJOfTlMICwwtRLx+7
	 QDVKs5lSJNCG4sKcWPGwgJEx/vl9Mrquhfwun8eDx61f8Yb+k1+64IhUd777R/9iqR
	 AIIeEgZ522tGsQYlh1hrVh79oByO1TQKw7qE4XHN1QAvasmPI2yRO+T4hqt/2sfk3p
	 hpX3JBhXZeTDA==
From: Jarkko Sakkinen <jarkko@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Jarkko Sakkinen <jarkko@kernel.org>,
	linux-api@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@amacapital.net>,
	Ben Segall <bsegall@google.com>,
	Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jan Kara <jack@suse.cz>,
	Jonathan Corbet <corbet@lwn.net>,
	John Johansen <john.johansen@canonical.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Kees Cook <kees@kernel.org>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Manfred Spraul <manfred@colorfullife.com>,
	Mel Gorman <mgorman@suse.de>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Neal Gompa <neal@gompa.dev>,
	Paul Moore <paul@paul-moore.com>,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Serge Hallyn <sergeh@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
Subject: [RFC PATCH v2 08/13] fs: Support FSCONFIG_SET_ROOTNS in fsconfig()
Date: Wed, 18 Nov 2026 01:13:47 +0200
Message-ID: <20261117231352.3816603-9-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261117231352.3816603-1-jarkko@kernel.org>
References: <20261117231352.3816603-1-jarkko@kernel.org>
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

fsopen() initializes a filesystem context from current's user, network,
PID, and IPC namespaces, preventing an external manager from creating
proc, mqueue, or userns-owned superblocks bound to an unentered root
namespace.

Add FSCONFIG_SET_ROOTNS so callers holding CAP_SYS_ADMIN in the target
rootns user namespace can bind a newly opened fs_context to that rootns
once before offering parameters. Update fc->net_ns, switch fc->user_ns
for non-global FS_USERNS_MOUNT or FS_USERNS_DELEGATABLE filesystems
whose mounter fsuid/fsgid map into the rootns user namespace, and pass
the rootns to ->set_rootns() for proc and mqueue.

Co-developed-by: David Howells <dhowells@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 fs/fsopen.c                | 76 ++++++++++++++++++++++++++++++++++++--
 fs/proc/root.c             | 13 +++++++
 include/linux/fs_context.h |  3 ++
 include/uapi/linux/mount.h |  1 +
 ipc/mqueue.c               | 12 ++++++
 5 files changed, 101 insertions(+), 4 deletions(-)

diff --git a/fs/fsopen.c b/fs/fsopen.c
index 70024870fefa..ca3234c8c4e4 100644
--- a/fs/fsopen.c
+++ b/fs/fsopen.c
@@ -13,9 +13,14 @@
 #include <linux/security.h>
 #include <linux/anon_inodes.h>
 #include <linux/namei.h>
+#include <linux/capability.h>
+#include <linux/nsproxy.h>
+#include <linux/rootns.h>
+#include <linux/user_namespace.h>
 #include <linux/file.h>
 #include <uapi/linux/mount.h>
 #include <linux/audit.h>
+#include <net/net_namespace.h>
 #include "internal.h"
 #include "mount.h"
 
@@ -41,6 +46,50 @@ static inline const char *fetch_message_locked(struct fc_log *log, size_t len,
 	return p;
 }
 
+/**
+ * DOC: FSCONFIG_SET_ROOTNS
+ *
+ * ``fsconfig(fsfd, FSCONFIG_SET_ROOTNS, NULL, NULL, rootnsfd)`` binds a newly
+ * opened filesystem context to ``rootnsfd`` once before any parameters are
+ * supplied (subsequent calls fail with ``-EBUSY``).
+ *
+ * The caller must hold ``CAP_SYS_ADMIN`` in the target ``rootns`` user
+ * namespace.
+ *
+ * ``fc->net_ns`` is switched to the ``rootns`` network namespace,
+ * ``fc->user_ns`` is delegated for non-global ``FS_USERNS_MOUNT`` or
+ * ``FS_USERNS_DELEGATABLE`` filesystems when the mounter ``fsuid``/``fsgid``
+ * map into the target user namespace, and ``proc`` and ``mqueue`` contexts
+ * bind to the target ``rootns`` PID and IPC namespaces.
+ */
+static int fsconfig_set_rootns(struct fs_context *fc, struct fs_parameter *param)
+{
+	struct user_namespace *user_ns;
+	struct rootns *c;
+
+	if (!is_rootns_file(param->file))
+		return -EINVAL;
+
+	c = param->file->private_data;
+	user_ns = c->cred->user_ns;
+	if (!ns_capable(user_ns, CAP_SYS_ADMIN))
+		return -EPERM;
+
+	put_net(fc->net_ns);
+	fc->net_ns = get_net(c->ns->net_ns);
+	if (!fc->global &&
+	    (fc->fs_type->fs_flags & (FS_USERNS_MOUNT | FS_USERNS_DELEGATABLE)) &&
+	    kuid_has_mapping(user_ns, fc->cred->fsuid) &&
+	    kgid_has_mapping(user_ns, fc->cred->fsgid)) {
+		put_user_ns(fc->user_ns);
+		fc->user_ns = get_user_ns(user_ns);
+	}
+	if (fc->ops->set_rootns)
+		fc->ops->set_rootns(fc, c);
+	fc->phase = FS_CONTEXT_CREATE_PARAMS;
+	return 0;
+}
+
 /*
  * Allow the user to read back any error, warning or informational messages.
  * Only one message is returned for each read(2) call.
@@ -147,7 +196,7 @@ SYSCALL_DEFINE2(fsopen, const char __user *, _fs_name, unsigned int, flags)
 	if (IS_ERR(fc))
 		return PTR_ERR(fc);
 
-	fc->phase = FS_CONTEXT_CREATE_PARAMS;
+	fc->phase = FS_CONTEXT_CREATE_NS;
 
 	ret = fscontext_alloc_log(fc);
 	if (ret < 0)
@@ -222,7 +271,8 @@ static int vfs_cmd_create(struct fs_context *fc, bool exclusive)
 	struct super_block *sb;
 	int ret;
 
-	if (fc->phase != FS_CONTEXT_CREATE_PARAMS)
+	if (fc->phase != FS_CONTEXT_CREATE_NS &&
+	    fc->phase != FS_CONTEXT_CREATE_PARAMS)
 		return -EBUSY;
 
 	if (!mount_capable(fc))
@@ -298,9 +348,16 @@ static int vfs_fsconfig_locked(struct fs_context *fc, int cmd,
 		return vfs_cmd_create(fc, true);
 	case FSCONFIG_CMD_RECONFIGURE:
 		return vfs_cmd_reconfigure(fc);
+	case FSCONFIG_SET_ROOTNS:
+		if (fc->phase != FS_CONTEXT_CREATE_NS)
+			return -EBUSY;
+		return fsconfig_set_rootns(fc, param);
+
 	default:
-		if (fc->phase != FS_CONTEXT_CREATE_PARAMS &&
-		    fc->phase != FS_CONTEXT_RECONF_PARAMS)
+		if (fc->phase == FS_CONTEXT_CREATE_NS)
+			fc->phase = FS_CONTEXT_CREATE_PARAMS;
+		else if (fc->phase != FS_CONTEXT_CREATE_PARAMS &&
+			 fc->phase != FS_CONTEXT_RECONF_PARAMS)
 			return -EBUSY;
 
 		return vfs_parse_fs_param(fc, param);
@@ -390,6 +447,10 @@ SYSCALL_DEFINE5(fsconfig,
 		if (!_key || _value || aux < 0)
 			return -EINVAL;
 		break;
+	case FSCONFIG_SET_ROOTNS:
+		if (_key || _value || aux < 0)
+			return -EINVAL;
+		break;
 	case FSCONFIG_CMD_CREATE:
 	case FSCONFIG_CMD_CREATE_EXCL:
 	case FSCONFIG_CMD_RECONFIGURE:
@@ -457,6 +518,12 @@ SYSCALL_DEFINE5(fsconfig,
 			goto out_key;
 		param.dirfd = aux;
 		break;
+	case FSCONFIG_SET_ROOTNS:
+		ret = -EBADF;
+		param.file = fget(aux);
+		if (!param.file)
+			goto out_key;
+		break;
 	default:
 		break;
 	}
@@ -482,6 +549,7 @@ SYSCALL_DEFINE5(fsconfig,
 			putname(param.name);
 		break;
 	case FSCONFIG_SET_FD:
+	case FSCONFIG_SET_ROOTNS:
 		if (param.file)
 			fput(param.file);
 		break;
diff --git a/fs/proc/root.c b/fs/proc/root.c
index 7fbbe92bf73a..5976029ad3f8 100644
--- a/fs/proc/root.c
+++ b/fs/proc/root.c
@@ -15,6 +15,8 @@
 #include <linux/sched/stat.h>
 #include <linux/module.h>
 #include <linux/bitops.h>
+#include <linux/nsproxy.h>
+#include <linux/rootns.h>
 #include <linux/user_namespace.h>
 #include <linux/fs_context.h>
 #include <linux/mount.h>
@@ -323,6 +325,16 @@ static int proc_get_tree(struct fs_context *fc)
 	return get_tree_nodev(fc, proc_fill_super);
 }
 
+static void proc_set_rootns(struct fs_context *fc, struct rootns *rootns)
+{
+	struct proc_fs_context *ctx = fc->fs_private;
+
+	put_pid_ns(ctx->pid_ns);
+	ctx->pid_ns = get_pid_ns(rootns->ns->pid_ns_for_children);
+	put_user_ns(fc->user_ns);
+	fc->user_ns = get_user_ns(ctx->pid_ns->user_ns);
+}
+
 static void proc_fs_context_free(struct fs_context *fc)
 {
 	struct proc_fs_context *ctx = fc->fs_private;
@@ -334,6 +346,7 @@ static void proc_fs_context_free(struct fs_context *fc)
 static const struct fs_context_operations proc_fs_context_ops = {
 	.free		= proc_fs_context_free,
 	.parse_param	= proc_parse_param,
+	.set_rootns	= proc_set_rootns,
 	.get_tree	= proc_get_tree,
 	.reconfigure	= proc_reconfigure,
 };
diff --git a/include/linux/fs_context.h b/include/linux/fs_context.h
index d1727dffecc5..cb978273c8bc 100644
--- a/include/linux/fs_context.h
+++ b/include/linux/fs_context.h
@@ -21,6 +21,7 @@ struct file_system_type;
 struct mnt_namespace;
 struct net;
 struct pid_namespace;
+struct rootns;
 struct super_block;
 struct user_namespace;
 struct vfsmount;
@@ -36,6 +37,7 @@ enum fs_context_purpose {
  * Userspace usage phase for fsopen/fspick.
  */
 enum fs_context_phase {
+	FS_CONTEXT_CREATE_NS,		/* Set namespaces for sb creation */
 	FS_CONTEXT_CREATE_PARAMS,	/* Loading params for sb creation */
 	FS_CONTEXT_CREATING,		/* A superblock is being created */
 	FS_CONTEXT_AWAITING_MOUNT,	/* Superblock created, awaiting fsmount() */
@@ -117,6 +119,7 @@ struct fs_context_operations {
 	int (*dup)(struct fs_context *fc, struct fs_context *src_fc);
 	int (*parse_param)(struct fs_context *fc, struct fs_parameter *param);
 	int (*parse_monolithic)(struct fs_context *fc, void *data);
+	void (*set_rootns)(struct fs_context *fc, struct rootns *rootns);
 	int (*get_tree)(struct fs_context *fc);
 	int (*reconfigure)(struct fs_context *fc);
 };
diff --git a/include/uapi/linux/mount.h b/include/uapi/linux/mount.h
index ac865edac517..cb55cfcfc92e 100644
--- a/include/uapi/linux/mount.h
+++ b/include/uapi/linux/mount.h
@@ -105,6 +105,7 @@ enum fsconfig_command {
 	FSCONFIG_CMD_CREATE	= 6,	/* Create new or reuse existing superblock */
 	FSCONFIG_CMD_RECONFIGURE = 7,	/* Invoke superblock reconfiguration */
 	FSCONFIG_CMD_CREATE_EXCL = 8,	/* Create new superblock, fail if reusing existing superblock */
+	FSCONFIG_SET_ROOTNS	= 9,	/* Set a rootns, supplied by fd */
 };
 
 /*
diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index 322c3dd98c44..a85ca188d370 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -32,6 +32,7 @@
 #include <linux/mutex.h>
 #include <linux/nsproxy.h>
 #include <linux/pid.h>
+#include <linux/rootns.h>
 #include <linux/ipc_namespace.h>
 #include <linux/user_namespace.h>
 #include <linux/slab.h>
@@ -400,6 +401,16 @@ static struct inode *mqueue_get_inode(struct super_block *sb,
 	return ERR_PTR(ret);
 }
 
+static void mqueue_set_rootns(struct fs_context *fc, struct rootns *rootns)
+{
+	struct mqueue_fs_context *ctx = fc->fs_private;
+
+	put_ipc_ns(ctx->ipc_ns);
+	ctx->ipc_ns = get_ipc_ns(rootns->ns->ipc_ns);
+	put_user_ns(fc->user_ns);
+	fc->user_ns = get_user_ns(ctx->ipc_ns->user_ns);
+}
+
 static int mqueue_fill_super(struct super_block *sb, struct fs_context *fc)
 {
 	struct inode *inode;
@@ -1613,6 +1624,7 @@ static const struct super_operations mqueue_super_ops = {
 
 static const struct fs_context_operations mqueue_fs_context_ops = {
 	.free		= mqueue_fs_context_free,
+	.set_rootns	= mqueue_set_rootns,
 	.get_tree	= mqueue_get_tree,
 };
 
-- 
2.47.3

