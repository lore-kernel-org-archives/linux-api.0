From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: [CFT][PATCH 7/8] userns: Add a knob to disable setgroups on a per user namespace basis
Date: Tue, 09 Dec 2014 14:42:34 -0600
Message-ID: <87fvcok11h.fsf_-_@x220.int.ebiederm.org>
References: <52e0643bd47b1e5c65921d6e00aea1f724bb510a.1417281801.git.luto@amacapital.net>
	<87h9xez20g.fsf@x220.int.ebiederm.org>
	<CALCETrXOz4C7Tu8mggBtR=k47ZmkuAhinVUxWJSFyS1Ep0HvRw@mail.gmail.com>
	<87mw75ygwp.fsf@x220.int.ebiederm.org>
	<CALCETrVfO4sBdZcQiZXsofPZMj7pqKeVbX+4g3dAj6WjUca+1w@mail.gmail.com>
	<87fvcxyf28.fsf_-_@x220.int.ebiederm.org>
	<874mtdyexp.fsf_-_@x220.int.ebiederm.org>
	<CALCETrXyC7XPaqj6oe-TmyypOVc_CkZbF6UAAx8YfkyD=gEMOQ@mail.gmail.com>
	<87a935u3nj.fsf@x220.int.ebiederm.org>
	<CALCETrXkEOiyzpvqtXtk1f4sL+M1Q-Y6rV=K91ez3yv2nb4Y0Q@mail.gmail.com>
	<87388xodlj.fsf@x220.int.ebiederm.org>
	<CALCETrXWx2-ZejEHmOi7aSoF-qJMRGR5yseeMhuurZwJRrQbUg@mail.gmail.com>
	<87h9x5re41.fsf_-_@x220.int.ebiederm.org>
	<87mw6xpzb0.fsf_-_@x220.int.ebiederm.org>
	<CALCETrU-o5mPr1jCaLXDuuF6J2N470zAtx=8Fa-SjF=ZpdE8mQ@mail.gmail.com>
	<87ppbtn4mv.fsf@x220.int.ebiederm.org>
	<CALCETrXSScp77BUJR5NSTh5-RnEZ9rqELSGJBeEzgdQ-OtohuQ@mail.gmail.com>
	<87a92xn2io.fsf@x220.int.ebiederm.org>
	<87r3w8liw4.fsf@x220.int.ebiederm.org>
	<87iohklfvj.fsf_-_@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <87iohklfvj.fsf_-_-JOvCrm2gF+uungPnsOpG7nhyD016LWXt@public.gmane.org> (Eric W. Biederman's
	message of "Tue, 09 Dec 2014 14:36:48 -0600")
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Michael Kerrisk-manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-man <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel@vger.kernel.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LSM <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Casey Schaufler <casey-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org>, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Kenton Varda <kenton-AuYgBwuPrUQTaNkGU808tA@public.gmane.org>, stable <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org


- Expose the knob to user space through a proc file /proc/<pid>/setgroups

  A value of "deny" means the setgroups system call is disabled in the
  current processes user namespace and can not be enabled in the
  future in this user namespace.

  A value of "allow" means the segtoups system call is enabled.

- Descendant user namespaces inherit the value of setgroups from
  their parents.

- A proc file is used (instead of a sysctl) as sysctls
  currently do not pass in a struct file so file_ns_capable
  is unusable.

Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Signed-off-by: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
---
 fs/proc/base.c                 |  31 +++++++++----
 include/linux/user_namespace.h |   7 +++
 kernel/user.c                  |   1 +
 kernel/user_namespace.c        | 103 +++++++++++++++++++++++++++++++++++++++++
 4 files changed, 134 insertions(+), 8 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 772efa45a452..4ebed9f01d97 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2386,7 +2386,7 @@ static int proc_tgid_io_accounting(struct seq_file *m, struct pid_namespace *ns,
 #endif /* CONFIG_TASK_IO_ACCOUNTING */
 
 #ifdef CONFIG_USER_NS
-static int proc_id_map_open(struct inode *inode, struct file *file,
+static int proc_userns_open(struct inode *inode, struct file *file,
 	const struct seq_operations *seq_ops)
 {
 	struct user_namespace *ns = NULL;
@@ -2418,7 +2418,7 @@ err:
 	return ret;
 }
 
-static int proc_id_map_release(struct inode *inode, struct file *file)
+static int proc_userns_release(struct inode *inode, struct file *file)
 {
 	struct seq_file *seq = file->private_data;
 	struct user_namespace *ns = seq->private;
@@ -2428,17 +2428,17 @@ static int proc_id_map_release(struct inode *inode, struct file *file)
 
 static int proc_uid_map_open(struct inode *inode, struct file *file)
 {
-	return proc_id_map_open(inode, file, &proc_uid_seq_operations);
+	return proc_userns_open(inode, file, &proc_uid_seq_operations);
 }
 
 static int proc_gid_map_open(struct inode *inode, struct file *file)
 {
-	return proc_id_map_open(inode, file, &proc_gid_seq_operations);
+	return proc_userns_open(inode, file, &proc_gid_seq_operations);
 }
 
 static int proc_projid_map_open(struct inode *inode, struct file *file)
 {
-	return proc_id_map_open(inode, file, &proc_projid_seq_operations);
+	return proc_userns_open(inode, file, &proc_projid_seq_operations);
 }
 
 static const struct file_operations proc_uid_map_operations = {
@@ -2446,7 +2446,7 @@ static const struct file_operations proc_uid_map_operations = {
 	.write		= proc_uid_map_write,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
-	.release	= proc_id_map_release,
+	.release	= proc_userns_release,
 };
 
 static const struct file_operations proc_gid_map_operations = {
@@ -2454,7 +2454,7 @@ static const struct file_operations proc_gid_map_operations = {
 	.write		= proc_gid_map_write,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
-	.release	= proc_id_map_release,
+	.release	= proc_userns_release,
 };
 
 static const struct file_operations proc_projid_map_operations = {
@@ -2462,7 +2462,20 @@ static const struct file_operations proc_projid_map_operations = {
 	.write		= proc_projid_map_write,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
-	.release	= proc_id_map_release,
+	.release	= proc_userns_release,
+};
+
+static int proc_setgroups_open(struct inode *inode, struct file *file)
+{
+	return proc_userns_open(inode, file, &proc_setgroups_seq_operations);
+}
+
+static const struct file_operations proc_setgroups_operations = {
+	.open		= proc_setgroups_open,
+	.write		= proc_setgroups_write,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= proc_userns_release,
 };
 #endif /* CONFIG_USER_NS */
 
@@ -2572,6 +2585,7 @@ static const struct pid_entry tgid_base_stuff[] = {
 	REG("uid_map",    S_IRUGO|S_IWUSR, proc_uid_map_operations),
 	REG("gid_map",    S_IRUGO|S_IWUSR, proc_gid_map_operations),
 	REG("projid_map", S_IRUGO|S_IWUSR, proc_projid_map_operations),
+	REG("setgroups",  S_IRUGO|S_IWUSR, proc_setgroups_operations),
 #endif
 #ifdef CONFIG_CHECKPOINT_RESTORE
 	REG("timers",	  S_IRUGO, proc_timers_operations),
@@ -2913,6 +2927,7 @@ static const struct pid_entry tid_base_stuff[] = {
 	REG("uid_map",    S_IRUGO|S_IWUSR, proc_uid_map_operations),
 	REG("gid_map",    S_IRUGO|S_IWUSR, proc_gid_map_operations),
 	REG("projid_map", S_IRUGO|S_IWUSR, proc_projid_map_operations),
+	REG("setgroups",  S_IRUGO|S_IWUSR, proc_setgroups_operations),
 #endif
 };
 
diff --git a/include/linux/user_namespace.h b/include/linux/user_namespace.h
index 8d493083486a..feb0f4ec5573 100644
--- a/include/linux/user_namespace.h
+++ b/include/linux/user_namespace.h
@@ -17,6 +17,10 @@ struct uid_gid_map {	/* 64 bytes -- 1 cache line */
 	} extent[UID_GID_MAP_MAX_EXTENTS];
 };
 
+#define USERNS_SETGROUPS_ALLOWED 1UL
+
+#define USERNS_INIT_FLAGS USERNS_SETGROUPS_ALLOWED
+
 struct user_namespace {
 	struct uid_gid_map	uid_map;
 	struct uid_gid_map	gid_map;
@@ -27,6 +31,7 @@ struct user_namespace {
 	kuid_t			owner;
 	kgid_t			group;
 	unsigned int		proc_inum;
+	unsigned long		flags;
 
 	/* Register of per-UID persistent keyrings for this namespace */
 #ifdef CONFIG_PERSISTENT_KEYRINGS
@@ -60,9 +65,11 @@ struct seq_operations;
 extern const struct seq_operations proc_uid_seq_operations;
 extern const struct seq_operations proc_gid_seq_operations;
 extern const struct seq_operations proc_projid_seq_operations;
+extern const struct seq_operations proc_setgroups_seq_operations;
 extern ssize_t proc_uid_map_write(struct file *, const char __user *, size_t, loff_t *);
 extern ssize_t proc_gid_map_write(struct file *, const char __user *, size_t, loff_t *);
 extern ssize_t proc_projid_map_write(struct file *, const char __user *, size_t, loff_t *);
+extern ssize_t proc_setgroups_write(struct file *, const char __user *, size_t, loff_t *);
 extern bool userns_may_setgroups(const struct user_namespace *ns);
 #else
 
diff --git a/kernel/user.c b/kernel/user.c
index 4efa39350e44..2d09940c9632 100644
--- a/kernel/user.c
+++ b/kernel/user.c
@@ -51,6 +51,7 @@ struct user_namespace init_user_ns = {
 	.owner = GLOBAL_ROOT_UID,
 	.group = GLOBAL_ROOT_GID,
 	.proc_inum = PROC_USER_INIT_INO,
+	.flags = USERNS_INIT_FLAGS,
 #ifdef CONFIG_PERSISTENT_KEYRINGS
 	.persistent_keyring_register_sem =
 	__RWSEM_INITIALIZER(init_user_ns.persistent_keyring_register_sem),
diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
index 44a555ac6104..b507f9af7ff2 100644
--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -100,6 +100,11 @@ int create_user_ns(struct cred *new)
 	ns->owner = owner;
 	ns->group = group;
 
+	/* Inherit USERNS_SETGROUPS_ALLOWED from our parent */
+	mutex_lock(&userns_state_mutex);
+	ns->flags = parent_ns->flags;
+	mutex_unlock(&userns_state_mutex);
+
 	set_cred_user_ns(new, ns);
 
 #ifdef CONFIG_PERSISTENT_KEYRINGS
@@ -839,6 +844,102 @@ static bool new_idmap_permitted(const struct file *file,
 	return false;
 }
 
+static void *setgroups_m_start(struct seq_file *seq, loff_t *ppos)
+{
+	struct user_namespace *ns = seq->private;
+
+	return (*ppos == 0) ?  ns : NULL;
+}
+
+static void *setgroups_m_next(struct seq_file *seq, void *v, loff_t *ppos)
+{
+	++*ppos;
+	return NULL;
+}
+
+static void setgroups_m_stop(struct seq_file *seq, void *v)
+{
+}
+
+static int setgroups_m_show(struct seq_file *seq, void *v)
+{
+	struct user_namespace *ns = seq->private;
+
+	seq_printf(seq, "%s\n",
+		   test_bit(USERNS_SETGROUPS_ALLOWED, &ns->flags) ?
+		   "allow" : "deny");
+	return 0;
+}
+
+const struct seq_operations proc_setgroups_seq_operations = {
+	.start	= setgroups_m_start,
+	.stop = setgroups_m_stop,
+	.next = setgroups_m_next,
+	.show = setgroups_m_show,
+};
+
+ssize_t proc_setgroups_write(struct file *file, const char __user *buf,
+			     size_t count, loff_t *ppos)
+{
+	struct seq_file *seq = file->private_data;
+	struct user_namespace *ns = seq->private;
+	char kbuf[8], *pos;
+	bool setgroups_allowed;
+	ssize_t ret;
+
+	ret = -EACCES;
+	if (!file_ns_capable(file, ns, CAP_SYS_ADMIN))
+		goto out;
+
+	/* Only allow a very narrow range of strings to be written */
+	ret = -EINVAL;
+	if ((*ppos != 0) || (count >= sizeof(kbuf)))
+		goto out;
+
+	/* What was written? */
+	ret = -EFAULT;
+	if (copy_from_user(kbuf, buf, count))
+		goto out;
+	kbuf[count] = '\0';
+	pos = kbuf;
+
+	/* What is being requested? */
+	ret = -EINVAL;
+	if (strncmp(pos, "allow", 5) == 0) {
+		pos += 5;
+		setgroups_allowed = true;
+	}
+	else if (strncmp(pos, "deny", 4) == 0) {
+		pos += 4;
+		setgroups_allowed = false;
+	}
+	else
+		goto out;
+
+	/* Verify there is not trailing junk on the line */
+	pos = skip_spaces(pos);
+	if (*pos != '\0')
+		goto out;
+
+	mutex_lock(&userns_state_mutex);
+	if (setgroups_allowed) {
+		ret = -EPERM;
+		if (!(ns->flags & USERNS_SETGROUPS_ALLOWED)) {
+			mutex_unlock(&userns_state_mutex);
+			goto out;
+		}
+	} else {
+		ns->flags &= ~USERNS_SETGROUPS_ALLOWED;
+	}
+	mutex_unlock(&userns_state_mutex);
+
+	/* Report a successful write */
+	*ppos = count;
+	ret = count;
+out:
+	return ret;
+}
+
 bool userns_may_setgroups(const struct user_namespace *ns)
 {
 	bool allowed;
@@ -848,6 +949,8 @@ bool userns_may_setgroups(const struct user_namespace *ns)
 	 * the user namespace has been established.
 	 */
 	allowed = ns->gid_map.nr_extents != 0;
+	/* Is setgroups allowed? */
+	allowed = allowed && (ns->flags & USERNS_SETGROUPS_ALLOWED);
 	mutex_unlock(&userns_state_mutex);
 
 	return allowed;
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
