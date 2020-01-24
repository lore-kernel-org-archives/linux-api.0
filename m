From: Sargun Dhillon <sargun@sargun.me>
Subject: [PATCH 1/4] pid: Add pidfd_create_file helper
Date: Fri, 24 Jan 2020 01:17:40 -0800
Message-ID: <20200124091743.3357-2-sargun@sargun.me>
References: <20200124091743.3357-1-sargun@sargun.me>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20200124091743.3357-1-sargun@sargun.me>
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: Sargun Dhillon <sargun@sargun.me>, tycho@tycho.ws, christian.brauner@ubuntu.com
List-Id: linux-api@vger.kernel.org

This helper allow for creation of pidfd files. The existing helper
(pidfd_create) creates file descriptors directly, which cannot
be used without race conditions when there is an intermediate
step between creation, and informing userspace the fd has been
created.

Signed-off-by: Sargun Dhillon <sargun@sargun.me>
---
 include/linux/pid.h |  1 +
 kernel/pid.c        | 22 ++++++++++++++++++++++
 2 files changed, 23 insertions(+)

diff --git a/include/linux/pid.h b/include/linux/pid.h
index 998ae7d24450..70d4725cf8da 100644
--- a/include/linux/pid.h
+++ b/include/linux/pid.h
@@ -75,6 +75,7 @@ extern const struct file_operations pidfd_fops;
 struct file;
 
 extern struct pid *pidfd_pid(const struct file *file);
+extern struct file *pidfd_create_file(struct pid *pid);
 
 static inline struct pid *get_pid(struct pid *pid)
 {
diff --git a/kernel/pid.c b/kernel/pid.c
index 2278e249141d..2a34db290128 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -521,6 +521,28 @@ static int pidfd_create(struct pid *pid)
 	return fd;
 }
 
+/**
+ * pidfd_create_file() - Create a new pidfd file.
+ *
+ * @pid:  struct pid that the pidfd will reference
+ *
+ * This creates a new pidfd file.
+ *
+ * Return: On success, a cloexec pidfd file is returned
+ *         On error, an err ptr will be returned.
+ */
+struct file *pidfd_create_file(struct pid *pid)
+{
+	struct file *f;
+
+	f = anon_inode_getfile("[pidfd]", &pidfd_fops, get_pid(pid),
+			       O_RDWR | O_CLOEXEC);
+	if (IS_ERR(f))
+		put_pid(pid);
+
+	return f;
+}
+
 /**
  * pidfd_open() - Open new pid file descriptor.
  *
-- 
2.20.1
