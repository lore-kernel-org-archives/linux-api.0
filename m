From: Richard Guy Briggs <rgb@redhat.com>
Subject: [PATCH ghak90 V8 03/16] audit: read container ID of a process
Date: Tue, 31 Dec 2019 14:48:16 -0500
Message-ID: <05ba38492e83101df4d2aea72c3adda041e46fcf.1577736799.git.rgb@redhat.com>
References: <cover.1577736799.git.rgb@redhat.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <cover.1577736799.git.rgb@redhat.com>
In-Reply-To: <cover.1577736799.git.rgb@redhat.com>
References: <cover.1577736799.git.rgb@redhat.com>
Sender: netdev-owner@vger.kernel.org
To: containers@lists.linux-foundation.org, linux-api@vger.kernel.org, Linux-Audit Mailing List <linux-audit@redhat.com>, linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Cc: Paul Moore <paul@paul-moore.com>, sgrubb@redhat.com, omosnace@redhat.com, dhowells@redhat.com, simo@redhat.com, eparis@parisplace.org, serge@hallyn.com, ebiederm@xmission.com, nhorman@tuxdriver.com, dwalsh@redhat.com, mpatel@redhat.com, Richard Guy Briggs <rgb@redhat.com>
List-Id: linux-api@vger.kernel.org

Add support for reading the audit container identifier from the proc
filesystem.

This is a read from the proc entry of the form
/proc/PID/audit_containerid where PID is the process ID of the task
whose audit container identifier is sought.

The read expects up to a u64 value (unset: 18446744073709551615).

This read requires CAP_AUDIT_CONTROL.

Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
Acked-by: Serge Hallyn <serge@hallyn.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
Reviewed-by: Ondrej Mosnacek <omosnace@redhat.com>
---
 fs/proc/base.c | 25 ++++++++++++++++++++++---
 1 file changed, 22 insertions(+), 3 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index e2e7c9f4702f..26091800180c 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -1224,7 +1224,7 @@ static ssize_t oom_score_adj_write(struct file *file, const char __user *buf,
 };
 
 #ifdef CONFIG_AUDIT
-#define TMPBUFLEN 11
+#define TMPBUFLEN 21
 static ssize_t proc_loginuid_read(struct file * file, char __user * buf,
 				  size_t count, loff_t *ppos)
 {
@@ -1308,6 +1308,24 @@ static ssize_t proc_sessionid_read(struct file * file, char __user * buf,
 	.llseek		= generic_file_llseek,
 };
 
+static ssize_t proc_contid_read(struct file *file, char __user *buf,
+				  size_t count, loff_t *ppos)
+{
+	struct inode *inode = file_inode(file);
+	struct task_struct *task = get_proc_task(inode);
+	ssize_t length;
+	char tmpbuf[TMPBUFLEN];
+
+	if (!task)
+		return -ESRCH;
+	/* if we don't have caps, reject */
+	if (!capable(CAP_AUDIT_CONTROL))
+		return -EPERM;
+	length = scnprintf(tmpbuf, TMPBUFLEN, "%llu", audit_get_contid(task));
+	put_task_struct(task);
+	return simple_read_from_buffer(buf, count, ppos, tmpbuf, length);
+}
+
 static ssize_t proc_contid_write(struct file *file, const char __user *buf,
 				   size_t count, loff_t *ppos)
 {
@@ -1338,6 +1356,7 @@ static ssize_t proc_contid_write(struct file *file, const char __user *buf,
 }
 
 static const struct file_operations proc_contid_operations = {
+	.read		= proc_contid_read,
 	.write		= proc_contid_write,
 	.llseek		= generic_file_llseek,
 };
@@ -3101,7 +3120,7 @@ static int proc_stack_depth(struct seq_file *m, struct pid_namespace *ns,
 #ifdef CONFIG_AUDIT
 	REG("loginuid",   S_IWUSR|S_IRUGO, proc_loginuid_operations),
 	REG("sessionid",  S_IRUGO, proc_sessionid_operations),
-	REG("audit_containerid", S_IWUSR, proc_contid_operations),
+	REG("audit_containerid", S_IWUSR|S_IRUSR, proc_contid_operations),
 #endif
 #ifdef CONFIG_FAULT_INJECTION
 	REG("make-it-fail", S_IRUGO|S_IWUSR, proc_fault_inject_operations),
@@ -3502,7 +3521,7 @@ static int proc_tid_comm_permission(struct inode *inode, int mask)
 #ifdef CONFIG_AUDIT
 	REG("loginuid",  S_IWUSR|S_IRUGO, proc_loginuid_operations),
 	REG("sessionid",  S_IRUGO, proc_sessionid_operations),
-	REG("audit_containerid", S_IWUSR, proc_contid_operations),
+	REG("audit_containerid", S_IWUSR|S_IRUSR, proc_contid_operations),
 #endif
 #ifdef CONFIG_FAULT_INJECTION
 	REG("make-it-fail", S_IRUGO|S_IWUSR, proc_fault_inject_operations),
-- 
1.8.3.1
