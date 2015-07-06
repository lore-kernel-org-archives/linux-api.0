From: Andrey Vagin <avagin@openvz.org>
Subject: [PATCH 18/24] task_diag: add ability to handle one task in a continious mode
Date: Mon,  6 Jul 2015 11:47:19 +0300
Message-ID: <1436172445-6979-19-git-send-email-avagin@openvz.org>
References: <1436172445-6979-1-git-send-email-avagin@openvz.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1436172445-6979-1-git-send-email-avagin@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, Andrey Vagin <avagin@openvz.org>, Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Cyrill Gorcunov <gorcunov@openvz.org>, Pavel Emelyanov <xemul@parallels.com>, Roger Luethi <rl@hellgate.ch>, Arnd Bergmann <arnd@arndb.de>, Arnaldo Carvalho de Melo <acme@kernel.org>, David Ahern <dsahern@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Pavel Odintsov <pavel.odintsov@gmail.com>
List-Id: linux-api@vger.kernel.org

If a task has many vma-s, the size of information about them can be too
big to be placed into one skb.

Signed-off-by: Andrey Vagin <avagin@openvz.org>
---
 include/uapi/linux/task_diag.h |  1 +
 kernel/taskdiag.c              | 17 +++++++++++++++++
 2 files changed, 18 insertions(+)

diff --git a/include/uapi/linux/task_diag.h b/include/uapi/linux/task_diag.h
index e1d09e6..4a1cecb 100644
--- a/include/uapi/linux/task_diag.h
+++ b/include/uapi/linux/task_diag.h
@@ -151,6 +151,7 @@ static inline struct task_diag_vma_stat *task_diag_vma_stat(struct task_diag_vma
 #define TASK_DIAG_DUMP_ALL	0
 #define TASK_DIAG_DUMP_CHILDREN	1
 #define TASK_DIAG_DUMP_THREAD	2
+#define TASK_DIAG_DUMP_ONE	3
 
 struct task_diag_pid {
 	__u64	show_flags;
diff --git a/kernel/taskdiag.c b/kernel/taskdiag.c
index dc319bf..20494ee 100644
--- a/kernel/taskdiag.c
+++ b/kernel/taskdiag.c
@@ -559,6 +559,16 @@ static struct task_struct *iter_start(struct task_iter *iter)
 	}
 
 	switch (iter->req.dump_strategy) {
+	case TASK_DIAG_DUMP_ONE:
+		if (iter->parent == NULL)
+			return ERR_PTR(-ESRCH);
+		iter->pos = iter->cb->args[0];
+		if (iter->pos == 0) {
+			iter->task = iter->parent;
+			get_task_struct(iter->task);
+		} else
+			iter->task = NULL;
+		return iter->task;
 	case TASK_DIAG_DUMP_THREAD:
 		if (iter->parent == NULL)
 			return ERR_PTR(-ESRCH);
@@ -588,6 +598,13 @@ static struct task_struct *iter_start(struct task_iter *iter)
 static struct task_struct *iter_next(struct task_iter *iter)
 {
 	switch (iter->req.dump_strategy) {
+	case TASK_DIAG_DUMP_ONE:
+		iter->pos++;
+		iter->cb->args[0] = iter->pos;
+		if (iter->task)
+			put_task_struct(iter->task);
+		iter->task = NULL;
+		return NULL;
 	case TASK_DIAG_DUMP_THREAD:
 		iter->pos++;
 		iter->task = task_next_tid(iter->task);
-- 
2.1.0
