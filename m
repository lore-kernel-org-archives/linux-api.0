From: Christian Brauner <christian@brauner.io>
Subject: [PATCH v1 1/2] proc: get process file descriptor from /proc/<pid>
Date: Mon, 19 Nov 2018 11:32:38 +0100
Message-ID: <20181119103241.5229-2-christian@brauner.io>
References: <20181119103241.5229-1-christian@brauner.io>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181119103241.5229-1-christian@brauner.io>
Sender: linux-kernel-owner@vger.kernel.org
To: ebiederm@xmission.com, linux-kernel@vger.kernel.org
Cc: serge@hallyn.com, jannh@google.com, luto@kernel.org, akpm@linux-foundation.org, oleg@redhat.com, cyphar@cyphar.com, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, dancol@google.com, timmurray@google.com, linux-man@vger.kernel.org, Christian Brauner <christian@brauner.io>, Kees Cook <keescook@chromium.org>
List-Id: linux-api@vger.kernel.org

With this patch an open() call on /proc/<pid> will give userspace a handle
to struct pid of the process associated with /proc/<pid>. This allows to
maintain a stable handle on a process.
I have been discussing various approaches extensively during technical
conferences this year culminating in a long argument with Eric at Linux
Plumbers. The general consensus was that having a handle on a process
should be something that is very simple and easy to maintain with the
option of being extensible via a more advanced api if the need arises. I
believe that this patch is the most simple, dumb, and therefore
maintainable solution.

[1]: https://lkml.org/lkml/2018/10/30/118

Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Serge Hallyn <serge@hallyn.com>
Cc: Jann Horn <jannh@google.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Andy Lutomirsky <luto@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Aleksa Sarai <cyphar@cyphar.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Christian Brauner <christian@brauner.io>
---
Changelog:
v1:
- remove ioctl() to signal processes and replace with a dedicated syscall
  in the next patch
---
 fs/proc/base.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index ce3465479447..6365a4fea314 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -3032,10 +3032,27 @@ static int proc_tgid_base_readdir(struct file *file, struct dir_context *ctx)
 				   tgid_base_stuff, ARRAY_SIZE(tgid_base_stuff));
 }
 
+static int proc_tgid_open(struct inode *inode, struct file *file)
+{
+	/* grab reference to struct pid and stash the pointer away */
+	file->private_data = get_pid(proc_pid(inode));
+	return 0;
+}
+
+static int proc_tgid_release(struct inode *inode, struct file *file)
+{
+	struct pid *pid = file->private_data;
+	/* drop reference to struct pid */
+	put_pid(pid);
+	return 0;
+}
+
 static const struct file_operations proc_tgid_base_operations = {
+	.open		= proc_tgid_open,
 	.read		= generic_read_dir,
 	.iterate_shared	= proc_tgid_base_readdir,
 	.llseek		= generic_file_llseek,
+	.release	= proc_tgid_release,
 };
 
 static struct dentry *proc_tgid_base_lookup(struct inode *dir, struct dentry *dentry, unsigned int flags)
-- 
2.19.1
