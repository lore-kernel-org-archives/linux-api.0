From: Christian Kellner <ckellner@redhat.com>
Subject: [PATCH v3 1/2] pidfd: show pids for nested pid namespaces in fdinfo
Date: Fri, 11 Oct 2019 14:23:20 +0200
Message-ID: <20191011122323.7770-1-ckellner@redhat.com>
References: <20191009160532.20674-1-ckellner@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191009160532.20674-1-ckellner@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, Christian Kellner <christian@kellner.me>, Christian Brauner <christian@brauner.io>, Andrew Morton <akpm@linux-foundation.org>, "Peter Zijlstra (Intel)" <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>, Michal Hocko <mhocko@suse.com>, Thomas Gleixner <tglx@linutronix.de>, Elena Reshetova <elena.reshetova@intel.com>, Roman Gushchin <guro@fb.com>, Andrea Arcangeli <aarcange@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, Aleksa Sarai <cyphar@cyphar.com>, "Dmitry V. Levin" <ldv@altlinux.org>
List-Id: linux-api@vger.kernel.org

From: Christian Kellner <christian@kellner.me>

The fdinfo file for a process file descriptor already contains the
pid of the process in the callers namespaces. Additionally, if pid
namespaces are configured, show the process ids of the process in
all nested namespaces in the same format as in the procfs status
file, i.e. "NSPid:\t%d\%d...". This allows the easy identification
of the processes in nested namespaces.

Signed-off-by: Christian Kellner <christian@kellner.me>
---

Changes in v2:
- Moved into separate function to avoid multiple ifdefs as suggested
  by Michal Hocko
Changes in v3:
- Helper function takes struct pid_namespace *ns param and got a new
  name

 kernel/fork.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/kernel/fork.c b/kernel/fork.c
index bcdf53125210..183950aad82b 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1695,12 +1695,27 @@ static int pidfd_release(struct inode *inode, struct file *file)
 }
 
 #ifdef CONFIG_PROC_FS
+static inline void print_pidfd_nspid(struct seq_file *m, struct pid *pid,
+				     struct pid_namespace *ns)
+{
+#ifdef CONFIG_PID_NS
+	int i;
+
+	seq_puts(m, "\nNSpid:");
+	for (i = ns->level; i <= pid->level; i++) {
+		ns = pid->numbers[i].ns;
+		seq_put_decimal_ull(m, "\t", pid_nr_ns(pid, ns));
+	}
+#endif
+}
+
 static void pidfd_show_fdinfo(struct seq_file *m, struct file *f)
 {
 	struct pid_namespace *ns = proc_pid_ns(file_inode(m->file));
 	struct pid *pid = f->private_data;
 
 	seq_put_decimal_ull(m, "Pid:\t", pid_nr_ns(pid, ns));
+	print_pidfd_nspid(m, pid, ns);
 	seq_putc(m, '\n');
 }
 #endif
-- 
2.21.0
