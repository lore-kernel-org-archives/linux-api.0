From: Oleksandr Natalenko <oleksandr@redhat.com>
Subject: [PATCH RFC 1/5] proc: introduce madvise placeholder
Date: Thu, 16 May 2019 11:42:30 +0200
Message-ID: <20190516094234.9116-2-oleksandr@redhat.com>
References: <20190516094234.9116-1-oleksandr@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190516094234.9116-1-oleksandr@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Kirill Tkhai <ktkhai@virtuozzo.com>, Hugh Dickins <hughd@google.com>, Alexey Dobriyan <adobriyan@gmail.com>, Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@suse.com>, Matthew Wilcox <willy@infradead.org>, Pavel Tatashin <pasha.tatashin@soleen.com>, Greg KH <greg@kroah.com>, Suren Baghdasaryan <surenb@google.com>, Minchan Kim <minchan@kernel.org>, Timofey Titovets <nefelim4ag@gmail.com>, Aaron Tomlin <atomlin@redhat.com>, Grzegorz Halat <ghalat@redhat.com>, linux-mm@kvack.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Add a write-only /proc/<pid>/madvise file to handle remote madvise
operations.

For now, this is just a soother that does nothing.

Signed-off-by: Oleksandr Natalenko <oleksandr@redhat.com>
---
 fs/proc/base.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 6a803a0b75df..f69532d6b74f 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2957,6 +2957,25 @@ static int proc_stack_depth(struct seq_file *m, struct pid_namespace *ns,
 }
 #endif /* CONFIG_STACKLEAK_METRICS */
 
+static ssize_t madvise_write(struct file *file, const char __user *buf,
+		size_t count, loff_t *ppos)
+{
+	struct task_struct *task;
+
+	task = get_proc_task(file_inode(file));
+	if (!task)
+		return -ESRCH;
+
+	put_task_struct(task);
+
+	return count;
+}
+
+static const struct file_operations proc_madvise_operations = {
+	.write		= madvise_write,
+	.llseek		= noop_llseek,
+};
+
 /*
  * Thread groups
  */
@@ -3061,6 +3080,7 @@ static const struct pid_entry tgid_base_stuff[] = {
 #ifdef CONFIG_STACKLEAK_METRICS
 	ONE("stack_depth", S_IRUGO, proc_stack_depth),
 #endif
+	REG("madvise", S_IRUGO|S_IWUSR, proc_madvise_operations),
 };
 
 static int proc_tgid_base_readdir(struct file *file, struct dir_context *ctx)
-- 
2.21.0
