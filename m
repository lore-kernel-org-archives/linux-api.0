From: Dmitry Safonov <dima@arista.com>
Subject: [PATCH 23/32] timens/fs/proc: Introduce /proc/pid/timens_offsets
Date: Wed,  6 Feb 2019 00:10:57 +0000
Message-ID: <20190206001107.16488-24-dima@arista.com>
References: <20190206001107.16488-1-dima@arista.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190206001107.16488-1-dima@arista.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Andrei Vagin <avagin@gmail.com>, Dmitry Safonov <dima@arista.com>, Adrian Reber <adrian@lisas.de>, Andrei Vagin <avagin@openvz.org>, Andy Lutomirski <luto@kernel.org>, Andy Tucker <agtucker@google.com>, Arnd Bergmann <arnd@arndb.de>, Christian Brauner <christian.brauner@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, Dmitry Safonov <0x7f454c46@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jeff Dike <jdike@addtoit.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Shuah Khan <shuah@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, containers@lists.linux-foundation.org, criu@openvz.org, linux-api@vger.kernel.org, x86@kernel.org
List-Id: linux-api@vger.kernel.org

From: Andrei Vagin <avagin@gmail.com>

API to set time namespace offsets for children processes, i.e.:
echo "clockid off_ses off_nsec" > /proc/self/timens_offsets

Signed-off-by: Andrei Vagin <avagin@gmail.com>
Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 fs/proc/base.c                 | 101 +++++++++++++++++++++++++++++++++
 include/linux/time_namespace.h |  10 ++++
 kernel/time_namespace.c        |  71 +++++++++++++++++++++++
 3 files changed, 182 insertions(+)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 633a63462573..1ba31050dcb5 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -94,6 +94,7 @@
 #include <linux/sched/stat.h>
 #include <linux/flex_array.h>
 #include <linux/posix-timers.h>
+#include <linux/time_namespace.h>
 #include <trace/events/oom.h>
 #include "internal.h"
 #include "fd.h"
@@ -1520,6 +1521,103 @@ static const struct file_operations proc_pid_sched_autogroup_operations = {
 
 #endif /* CONFIG_SCHED_AUTOGROUP */
 
+#ifdef CONFIG_TIME_NS
+static int timens_offsets_show(struct seq_file *m, void *v)
+{
+	struct inode *inode = m->private;
+	struct task_struct *p;
+
+	p = get_proc_task(inode);
+	if (!p)
+		return -ESRCH;
+	proc_timens_show_offsets(p, m);
+
+	put_task_struct(p);
+
+	return 0;
+}
+
+static ssize_t
+timens_offsets_write(struct file *file, const char __user *buf,
+	    size_t count, loff_t *ppos)
+{
+	struct inode *inode = file_inode(file);
+	struct proc_timens_offset offsets[2];
+	char *kbuf = NULL, *pos, *next_line;
+	struct task_struct *p;
+	int ret, noffsets;
+
+	/* Only allow < page size writes at the beginning of the file */
+	if ((*ppos != 0) || (count >= PAGE_SIZE))
+		return -EINVAL;
+
+	/* Slurp in the user data */
+	kbuf = memdup_user_nul(buf, count);
+	if (IS_ERR(kbuf))
+		return PTR_ERR(kbuf);
+
+	/* Parse the user data */
+	ret = -EINVAL;
+	noffsets = 0;
+	pos = kbuf;
+	for (; pos; pos = next_line) {
+		struct proc_timens_offset *off = &offsets[noffsets];
+		int err;
+
+		/* Find the end of line and ensure I don't look past it */
+		next_line = strchr(pos, '\n');
+		if (next_line) {
+			*next_line = '\0';
+			next_line++;
+			if (*next_line == '\0')
+				next_line = NULL;
+		}
+
+		err = sscanf(pos, "%u %lld %lu", &off->clockid,
+				&off->val.tv_sec, &off->val.tv_nsec);
+		if (err != 3 || off->val.tv_nsec >= NSEC_PER_SEC)
+			goto out;
+		if (noffsets++ == ARRAY_SIZE(offsets))
+			break;
+	}
+
+	ret = -ESRCH;
+	p = get_proc_task(inode);
+	if (!p)
+		goto out;
+	ret = proc_timens_set_offset(p, offsets, noffsets);
+	put_task_struct(p);
+	if (ret)
+		goto out;
+
+	ret = count;
+out:
+	kfree(kbuf);
+	return ret;
+}
+
+static int timens_offsets_open(struct inode *inode, struct file *filp)
+{
+	int ret;
+
+	ret = single_open(filp, timens_offsets_show, NULL);
+	if (!ret) {
+		struct seq_file *m = filp->private_data;
+
+		m->private = inode;
+	}
+	return ret;
+}
+
+static const struct file_operations proc_timens_offsets_operations = {
+	.open		= timens_offsets_open,
+	.read		= seq_read,
+	.write		= timens_offsets_write,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+#endif /* CONFIG_TIME_NS */
+
 static ssize_t comm_write(struct file *file, const char __user *buf,
 				size_t count, loff_t *offset)
 {
@@ -2953,6 +3051,9 @@ static const struct pid_entry tgid_base_stuff[] = {
 #endif
 #ifdef CONFIG_SCHED_AUTOGROUP
 	REG("autogroup",  S_IRUGO|S_IWUSR, proc_pid_sched_autogroup_operations),
+#endif
+#ifdef CONFIG_TIME_NS
+	REG("timens_offsets",  S_IRUGO|S_IWUSR, proc_timens_offsets_operations),
 #endif
 	REG("comm",      S_IRUGO|S_IWUSR, proc_pid_set_comm_operations),
 #ifdef CONFIG_HAVE_ARCH_TRACEHOOK
diff --git a/include/linux/time_namespace.h b/include/linux/time_namespace.h
index f1807d7f524d..c9ba7366b3d6 100644
--- a/include/linux/time_namespace.h
+++ b/include/linux/time_namespace.h
@@ -41,6 +41,16 @@ static inline void put_time_ns(struct time_namespace *ns)
 }
 
 
+extern void proc_timens_show_offsets(struct task_struct *p, struct seq_file *m);
+
+struct proc_timens_offset {
+	int clockid;
+	struct timespec64 val;
+};
+
+extern int proc_timens_set_offset(struct task_struct *p,
+				struct proc_timens_offset *offsets, int n);
+
 extern void timens_clock_to_host(int clockid, struct timespec64 *val);
 extern void timens_clock_from_host(int clockid, struct timespec64 *val);
 
diff --git a/kernel/time_namespace.c b/kernel/time_namespace.c
index 1d1d1c023ec1..6e2e6629e1ba 100644
--- a/kernel/time_namespace.c
+++ b/kernel/time_namespace.c
@@ -13,6 +13,7 @@
 #include <linux/user_namespace.h>
 #include <linux/proc_ns.h>
 #include <linux/sched/task.h>
+#include <linux/seq_file.h>
 #include <linux/mm.h>
 #include <asm/vdso.h>
 
@@ -202,6 +203,76 @@ static struct user_namespace *timens_owner(struct ns_common *ns)
 	return to_time_ns(ns)->user_ns;
 }
 
+static void show_offset(struct seq_file *m, int clockid, struct timespec64 *ts)
+{
+	seq_printf(m, "%d %lld %ld\n", clockid, ts->tv_sec, ts->tv_nsec);
+}
+
+void proc_timens_show_offsets(struct task_struct *p, struct seq_file *m)
+{
+	struct ns_common *ns;
+	struct time_namespace *time_ns;
+	struct timens_offsets *ns_offsets;
+
+	ns = timens_for_children_get(p);
+	if (!ns)
+		return;
+	time_ns = to_time_ns(ns);
+
+	if (!time_ns->offsets) {
+		put_time_ns(time_ns);
+		return;
+	}
+	ns_offsets = time_ns->offsets;
+
+	show_offset(m, CLOCK_MONOTONIC, &ns_offsets->monotonic_time_offset);
+	show_offset(m, CLOCK_BOOTTIME, &ns_offsets->monotonic_boottime_offset);
+	put_time_ns(time_ns);
+}
+
+int proc_timens_set_offset(struct task_struct *p,
+			   struct proc_timens_offset *offsets, int noffsets)
+{
+	struct ns_common *ns;
+	struct time_namespace *time_ns;
+	struct timens_offsets *ns_offsets;
+	int i, err;
+
+	ns = timens_for_children_get(p);
+	if (!ns)
+		return -ESRCH;
+	time_ns = to_time_ns(ns);
+
+	if (!time_ns->offsets || time_ns->initialized ||
+	    !ns_capable(time_ns->user_ns, CAP_SYS_TIME)) {
+		put_time_ns(time_ns);
+		return -EPERM;
+	}
+	ns_offsets = time_ns->offsets;
+
+	err = -EINVAL;
+	for (i = 0; i < noffsets; i++) {
+		struct proc_timens_offset *off = &offsets[i];
+
+		switch (off->clockid) {
+		case CLOCK_MONOTONIC:
+			ns_offsets->monotonic_time_offset = off->val;
+			break;
+		case CLOCK_BOOTTIME:
+			ns_offsets->monotonic_boottime_offset = off->val;
+			break;
+		default:
+			goto out;
+		}
+	}
+
+	err = 0;
+out:
+	put_time_ns(time_ns);
+
+	return err;
+}
+
 static void clock_timens_fixup(int clockid, struct timespec64 *val, bool to_ns)
 {
 	struct timens_offsets *ns_offsets = current->nsproxy->time_ns->offsets;
-- 
2.20.1
