From: Kirill Tkhai <ktkhai@virtuozzo.com>
Subject: [PATCH RESEND 1/2] ns: Allow ns_entries to have custom symlink
 content
Date: Thu, 30 Mar 2017 13:27:49 +0300
Message-ID: <149086966919.4388.10564546347286785860.stgit@localhost.localdomain>
References: <149086931397.4388.9604947335273204415.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <149086931397.4388.9604947335273204415.stgit@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: agruenba@redhat.com, keescook@chromium.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, oleg@redhat.com, paul@paul-moore.com, ebiederm@xmission.com, avagin@openvz.org, linux-fsdevel@vger.kernel.org, mtk.manpages@gmail.com, akpm@linux-foundation.org, luto@amacapital.net, mingo@kernel.org, serge@hallyn.com
List-Id: linux-api@vger.kernel.org

Make possible to have link content prefix yyy
different from the link name xxx:

$ readlink /proc/[pid]/ns/xxx
yyy:[4026531838]

This will be used in next patch.

Signed-off-by: Kirill Tkhai <ktkhai@virtuozzo.com>
Reviewed-by: Cyrill Gorcunov <gorcunov@openvz.org>
Acked-by: Andrei Vagin <avagin@virtuozzo.com>
---
 fs/nsfs.c               |    4 +++-
 include/linux/proc_ns.h |    1 +
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/nsfs.c b/fs/nsfs.c
index 1656843e87d2..495f12b83a7b 100644
--- a/fs/nsfs.c
+++ b/fs/nsfs.c
@@ -195,9 +195,11 @@ int ns_get_name(char *buf, size_t size, struct task_struct *task,
 {
 	struct ns_common *ns;
 	int res = -ENOENT;
+	const char *name;
 	ns = ns_ops->get(task);
 	if (ns) {
-		res = snprintf(buf, size, "%s:[%u]", ns_ops->name, ns->inum);
+		name = ns_ops->real_ns_name ? : ns_ops->name;
+		res = snprintf(buf, size, "%s:[%u]", name, ns->inum);
 		ns_ops->put(ns);
 	}
 	return res;
diff --git a/include/linux/proc_ns.h b/include/linux/proc_ns.h
index 12cb8bd81d2d..88dba3b53375 100644
--- a/include/linux/proc_ns.h
+++ b/include/linux/proc_ns.h
@@ -14,6 +14,7 @@ struct inode;
 
 struct proc_ns_operations {
 	const char *name;
+	const char *real_ns_name;
 	int type;
 	struct ns_common *(*get)(struct task_struct *task);
 	void (*put)(struct ns_common *ns);
