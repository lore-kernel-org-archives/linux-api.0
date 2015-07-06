From: Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 17/24] task_diag: add ability to dump theads
Date: Mon,  6 Jul 2015 11:47:18 +0300
Message-ID: <1436172445-6979-18-git-send-email-avagin@openvz.org>
References: <1436172445-6979-1-git-send-email-avagin@openvz.org>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1436172445-6979-1-git-send-email-avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Roger Luethi <rl-7uj+XXdSDtwfv37vnLkPlQ@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Ahern <dsahern-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Pavel Odintsov <pavel.odintsov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Signed-off-by: Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
---
 include/uapi/linux/task_diag.h |  1 +
 kernel/taskdiag.c              | 15 ++++++++++++++-
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/task_diag.h b/include/uapi/linux/task_diag.h
index 9e4c3c4..e1d09e6 100644
--- a/include/uapi/linux/task_diag.h
+++ b/include/uapi/linux/task_diag.h
@@ -150,6 +150,7 @@ static inline struct task_diag_vma_stat *task_diag_vma_stat(struct task_diag_vma
 
 #define TASK_DIAG_DUMP_ALL	0
 #define TASK_DIAG_DUMP_CHILDREN	1
+#define TASK_DIAG_DUMP_THREAD	2
 
 struct task_diag_pid {
 	__u64	show_flags;
diff --git a/kernel/taskdiag.c b/kernel/taskdiag.c
index 8e00c3e..dc319bf 100644
--- a/kernel/taskdiag.c
+++ b/kernel/taskdiag.c
@@ -559,8 +559,15 @@ static struct task_struct *iter_start(struct task_iter *iter)
 	}
 
 	switch (iter->req.dump_strategy) {
-	case TASK_DIAG_DUMP_CHILDREN:
+	case TASK_DIAG_DUMP_THREAD:
+		if (iter->parent == NULL)
+			return ERR_PTR(-ESRCH);
+
+		iter->pos = iter->cb->args[0];
+		iter->task = task_first_tid(iter->parent, 0, iter->pos, iter->ns);
+		return iter->task;
 
+	case TASK_DIAG_DUMP_CHILDREN:
 		if (iter->parent == NULL)
 			return ERR_PTR(-ESRCH);
 
@@ -581,6 +588,12 @@ static struct task_struct *iter_start(struct task_iter *iter)
 static struct task_struct *iter_next(struct task_iter *iter)
 {
 	switch (iter->req.dump_strategy) {
+	case TASK_DIAG_DUMP_THREAD:
+		iter->pos++;
+		iter->task = task_next_tid(iter->task);
+		iter->cb->args[0] = iter->pos;
+		iter->cb->args[1] = task_pid_nr_ns(iter->task, iter->ns);
+		return iter->task;
 	case TASK_DIAG_DUMP_CHILDREN:
 		iter->pos++;
 		iter->task = task_next_child(iter->parent, iter->task, iter->pos);
-- 
2.1.0
