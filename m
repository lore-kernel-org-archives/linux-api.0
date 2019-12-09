From: Sargun Dhillon <sargun@sargun.me>
Subject: [PATCH v2 1/4] vfs, fdtable: Add get_task_file helper
Date: Mon, 9 Dec 2019 07:06:12 +0000
Message-ID: <20191209070609.GA32438@ircssh-2.c.rugged-nimbus-611.internal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: tycho@tycho.ws, jannh@google.com, cyphar@cyphar.com, christian.brauner@ubuntu.com, oleg@redhat.com, luto@amacapital.net, viro@zeniv.linux.org.uk
List-Id: linux-api@vger.kernel.org

This introduces a function which can be used to fetch a file, given an
arbitrary task. As long as the user holds a reference (refcnt) to the
task_struct it is safe to call, and will either return NULL on failure,
or a pointer to the file, with a refcnt.

Signed-off-by: Sargun Dhillon <sargun@sargun.me>
---
 fs/file.c               | 19 +++++++++++++++++++
 include/linux/fdtable.h | 10 ++++++++++
 2 files changed, 29 insertions(+)

diff --git a/fs/file.c b/fs/file.c
index 3da91a112bab..98601a503a0f 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -1015,3 +1015,22 @@ int iterate_fd(struct files_struct *files, unsigned n,
 	return res;
 }
 EXPORT_SYMBOL(iterate_fd);
+
+struct file *get_task_file(struct task_struct *task, unsigned int fd)
+{
+	struct file *file = NULL;
+
+	task_lock(task);
+	rcu_read_lock();
+
+	if (task->files) {
+		file = fcheck_files(task->files, fd);
+		if (file && !get_file_rcu(file))
+			file = NULL;
+	}
+
+	rcu_read_unlock();
+	task_unlock(task);
+
+	return file;
+}
diff --git a/include/linux/fdtable.h b/include/linux/fdtable.h
index f07c55ea0c22..eacb1a56df44 100644
--- a/include/linux/fdtable.h
+++ b/include/linux/fdtable.h
@@ -115,6 +115,16 @@ int iterate_fd(struct files_struct *, unsigned,
 		int (*)(const void *, struct file *, unsigned),
 		const void *);
 
+/*
+ * get_task_file - get a reference to a file from another task
+ * @task: the task to get the file descriptor from
+ * @fd: the file descriptor number to fetch
+ *
+ * returns NULL on failure, or pointer to the file on success, with a reference
+ * It requires that the task is pinned prior to calling it.
+ */
+struct file *get_task_file(struct task_struct *task, unsigned int fd);
+
 extern int __alloc_fd(struct files_struct *files,
 		      unsigned start, unsigned end, unsigned flags);
 extern void __fd_install(struct files_struct *files,
-- 
2.20.1
