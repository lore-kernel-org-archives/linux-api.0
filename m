From: adam.manzanares@wdc.com
Subject: [PATCH v4 1/3] block: add ioprio_check_cap function
Date: Thu, 17 May 2018 13:38:01 -0700
Message-ID: <20180517203803.2664-2-adam.manzanares@wdc.com>
References: <20180517203803.2664-1-adam.manzanares@wdc.com>
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <20180517203803.2664-1-adam.manzanares@wdc.com>
Sender: owner-linux-aio@kvack.org
To: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, axboe@kernel.dk, bcrl@kvack.org
Cc: mingo@kernel.org, peterz@infradead.org, pombredanne@nexb.com, gregkh@linuxfoundation.org, bigeasy@linutronix.de, rgoldwyn@suse.com, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-aio@kvack.org, linux-api@vger.kernel.org, Adam Manzanares <adam.manzanares@wdc.com>
List-Id: linux-api@vger.kernel.org

From: Adam Manzanares <adam.manzanares@wdc.com>

Aio per command iopriority support introduces a second interface between
userland and the kernel capable of passing iopriority. The aio interface also
needs the ability to verify that the submitting context has sufficient
priviledges to submit IOPRIO_RT commands. This patch creates the
ioprio_check_cap function to be used by the ioprio_set system call and also by
the aio interface.

Signed-off-by: Adam Manzanares <adam.manzanares@wdc.com>
---
 block/ioprio.c         | 22 ++++++++++++++++------
 include/linux/ioprio.h |  2 ++
 2 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/block/ioprio.c b/block/ioprio.c
index 6f5d0b6625e3..f9821080c92c 100644
--- a/block/ioprio.c
+++ b/block/ioprio.c
@@ -61,15 +61,10 @@ int set_task_ioprio(struct task_struct *task, int ioprio)
 }
 EXPORT_SYMBOL_GPL(set_task_ioprio);
 
-SYSCALL_DEFINE3(ioprio_set, int, which, int, who, int, ioprio)
+int ioprio_check_cap(int ioprio)
 {
 	int class = IOPRIO_PRIO_CLASS(ioprio);
 	int data = IOPRIO_PRIO_DATA(ioprio);
-	struct task_struct *p, *g;
-	struct user_struct *user;
-	struct pid *pgrp;
-	kuid_t uid;
-	int ret;
 
 	switch (class) {
 		case IOPRIO_CLASS_RT:
@@ -92,6 +87,21 @@ SYSCALL_DEFINE3(ioprio_set, int, which, int, who, int, ioprio)
 			return -EINVAL;
 	}
 
+	return 0;
+}
+
+SYSCALL_DEFINE3(ioprio_set, int, which, int, who, int, ioprio)
+{
+	struct task_struct *p, *g;
+	struct user_struct *user;
+	struct pid *pgrp;
+	kuid_t uid;
+	int ret;
+
+	ret = ioprio_check_cap(ioprio);
+	if (ret)
+		return ret;
+
 	ret = -ESRCH;
 	rcu_read_lock();
 	switch (which) {
diff --git a/include/linux/ioprio.h b/include/linux/ioprio.h
index 627efac73e6d..4a28cec49ec3 100644
--- a/include/linux/ioprio.h
+++ b/include/linux/ioprio.h
@@ -77,4 +77,6 @@ extern int ioprio_best(unsigned short aprio, unsigned short bprio);
 
 extern int set_task_ioprio(struct task_struct *task, int ioprio);
 
+extern int ioprio_check_cap(int ioprio);
+
 #endif
-- 
2.15.1

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
