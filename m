From: Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 03/24] proc: add /proc/<pid>/fsgid_map
Date: Tue, 11 Feb 2020 17:57:32 +0100
Message-ID: <20200211165753.356508-4-christian.brauner@ubuntu.com>
References: <20200211165753.356508-1-christian.brauner@ubuntu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20200211165753.356508-1-christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: =?UTF-8?q?St=C3=A9phane=20Graber?= <stgraber-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>, Jann Horn <jannh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: smbarber-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Serge Hallyn <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, James Morris <jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

The /proc/<pid>/fsgid_map file can be written to once to setup an fsgid mapping
for a user namespace. Writing to this file has the same restrictions as writing
to /proc/<pid>/fsgid_map.

root@e1-vm:/# cat /proc/13023/fsgid_map
         0     300000     100000

Fsid mappings have always been around. They are currently always identical to
the id mappings for a user namespace. This means, currently whenever an fsid
needs to be looked up the kernel will use the id mapping of the user namespace.
With the introduction of fsid mappings the kernel will now lookup fsids in the
fsid mappings of the user namespace. If no fsid mapping exists the kernel will
continue looking up fsids in the id mappings of the user namespace. Hence, if a
system supports fsid mappings through /proc/<pid>/fs*id_map and a container
runtime is not aware of fsid mappings it or does not use them it will it will
continue to work just as before.

Signed-off-by: Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
---
 fs/proc/base.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index ad5f6adc9344..e085ad579604 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2884,6 +2884,11 @@ static int proc_fsuid_map_open(struct inode *inode, struct file *file)
 {
 	return proc_id_map_open(inode, file, &proc_fsuid_seq_operations);
 }
+
+static int proc_fsgid_map_open(struct inode *inode, struct file *file)
+{
+	return proc_id_map_open(inode, file, &proc_fsgid_seq_operations);
+}
 #endif
 
 static const struct file_operations proc_uid_map_operations = {
@@ -2918,6 +2923,14 @@ static const struct file_operations proc_fsuid_map_operations = {
 	.llseek		= seq_lseek,
 	.release	= proc_id_map_release,
 };
+
+static const struct file_operations proc_fsgid_map_operations = {
+	.open		= proc_fsgid_map_open,
+	.write		= proc_fsgid_map_write,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= proc_id_map_release,
+};
 #endif
 
 static int proc_setgroups_open(struct inode *inode, struct file *file)
@@ -3098,6 +3111,7 @@ static const struct pid_entry tgid_base_stuff[] = {
 #ifdef CONFIG_USER_NS
 #ifdef CONFIG_USER_NS_FSID
 	REG("fsuid_map",  S_IRUGO|S_IWUSR, proc_fsuid_map_operations),
+	REG("fsgid_map",  S_IRUGO|S_IWUSR, proc_fsgid_map_operations),
 #endif
 	REG("uid_map",    S_IRUGO|S_IWUSR, proc_uid_map_operations),
 	REG("gid_map",    S_IRUGO|S_IWUSR, proc_gid_map_operations),
-- 
2.25.0
