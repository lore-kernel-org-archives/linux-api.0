From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: [CFT][PATCH v6] userns: Add a knob to disable setgroups on a per user
	namespace basis
Date: Thu, 11 Dec 2014 19:31:43 -0600
Message-ID: <8761dh3b7k.fsf_-_@x220.int.ebiederm.org>
References: <52e0643bd47b1e5c65921d6e00aea1f724bb510a.1417281801.git.luto@amacapital.net>
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
	<87fvcok11h.fsf_-_@x220.int.ebiederm.org>
	<CALCETrVfKiXuY=KY_=nHpkTyLWgpy_3DK=4Mr2mhpyX9z1TzrA@mail.gmail.com>
	<971ad3f6-90fd-4e3f-916c-8988af3c826d@email.android.com>
	<CALCETrWpzvNm=fjOa3_+4QOqYP8qZUJvQAd6AsRZ71xyHZQRCg@mail.gmail.com>
	<87wq5zf83t.fsf@x220.int.ebiederm.org>
	<87iohh3c9c.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <87iohh3c9c.fsf-JOvCrm2gF+uungPnsOpG7nhyD016LWXt@public.gmane.org> (Eric W. Biederman's
	message of "Thu, 11 Dec 2014 19:09:03 -0600")
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: linux-man <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, stable <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kenton Varda <kenton-AuYgBwuPrUQTaNkGU808tA@public.gmane.org>, LSM <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michael Kerrisk-manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Casey Schaufler <casey-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-api@vger.kernel.org


- Expose the knob to user space through a proc file /proc/<pid>/setgroups

  A value of "deny" means the setgroups system call is disabled in the
  current processes user namespace and can not be enabled in the
  future in this user namespace.

  A value of "allow" means the segtoups system call is enabled.

- Descendant user namespaces inherit the value of setgroups from
  their parents.

- A proc file is used (instead of a sysctl) as sysctls currently do
  not allow checking the permissions at open time.

- Writing to the proc file is restricted to before the gid_map
  for the user namespace is set.

  This ensures that disabling setgroups at a user namespace
  level will never remove the ability to call setgroups
  from a process that already has that ability.

  A process may opt in to the setgroups disable for itself by
  creating, entering and configuring a user namespace or by calling
  setns on an existing user namespace with setgroups disabled.
  Processes without privileges already can not call setgroups so this
  is a noop.  Prodcess with privilege become processes without
  privilege when entering a user namespace and as with any other path
  to dropping privilege they would not have the ability to call
  setgroups.  So this remains within the bounds of what is possible
  without a knob to disable setgroups permanently in a user namespace.

Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Signed-off-by: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
---

Andy think you could look through this hopefully final version of this
patch.


 fs/proc/base.c                 | 53 ++++++++++++++++++++++++++
 include/linux/user_namespace.h |  7 ++++
 kernel/user.c                  |  1 +
 kernel/user_namespace.c        | 85 ++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 146 insertions(+)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 772efa45a452..7dc3ea89ef1a 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2464,6 +2464,57 @@ static const struct file_operations proc_projid_map_operations = {
 	.llseek		= seq_lseek,
 	.release	= proc_id_map_release,
 };
+
+static int proc_setgroups_open(struct inode *inode, struct file *file)
+{
+	struct user_namespace *ns = NULL;
+	struct task_struct *task;
+	int ret;
+
+	ret = -ESRCH;
+	task = get_proc_task(inode);
+	if (task) {
+		rcu_read_lock();
+		ns = get_user_ns(task_cred_xxx(task, user_ns));
+		rcu_read_unlock();
+		put_task_struct(task);
+	}
+	if (!ns)
+		goto err;
+
+	if (file->f_mode & FMODE_WRITE) {
+		ret = -EACCES;
+		if (!ns_capable(ns, CAP_SYS_ADMIN))
+			goto err_put_ns;
+	}
+
+	ret = single_open(file, &proc_setgroups_show, ns);
+	if (ret)
+		goto err_put_ns;
+
+	return 0;
+err_put_ns:
+	put_user_ns(ns);
+err:
+	return ret;
+}
+
+static int proc_setgroups_release(struct inode *inode, struct file *file)
+{
+	struct seq_file *seq = file->private_data;
+	struct user_namespace *ns = seq->private;
+	int ret = single_release(inode, file);
+	put_user_ns(ns);
+	return ret;
+}
+
+static const struct file_operations proc_setgroups_operations = {
+	.open		= proc_setgroups_open,
+	.write		= proc_setgroups_write,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= proc_setgroups_release,
+};
 #endif /* CONFIG_USER_NS */
 
 static int proc_pid_personality(struct seq_file *m, struct pid_namespace *ns,
@@ -2572,6 +2623,7 @@ static const struct pid_entry tgid_base_stuff[] = {
 	REG("uid_map",    S_IRUGO|S_IWUSR, proc_uid_map_operations),
 	REG("gid_map",    S_IRUGO|S_IWUSR, proc_gid_map_operations),
 	REG("projid_map", S_IRUGO|S_IWUSR, proc_projid_map_operations),
+	REG("setgroups",  S_IRUGO|S_IWUSR, proc_setgroups_operations),
 #endif
 #ifdef CONFIG_CHECKPOINT_RESTORE
 	REG("timers",	  S_IRUGO, proc_timers_operations),
@@ -2913,6 +2965,7 @@ static const struct pid_entry tid_base_stuff[] = {
 	REG("uid_map",    S_IRUGO|S_IWUSR, proc_uid_map_operations),
 	REG("gid_map",    S_IRUGO|S_IWUSR, proc_gid_map_operations),
 	REG("projid_map", S_IRUGO|S_IWUSR, proc_projid_map_operations),
+	REG("setgroups",  S_IRUGO|S_IWUSR, proc_setgroups_operations),
 #endif
 };
 
diff --git a/include/linux/user_namespace.h b/include/linux/user_namespace.h
index 8d493083486a..9f3579ff543d 100644
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
@@ -63,6 +68,8 @@ extern const struct seq_operations proc_projid_seq_operations;
 extern ssize_t proc_uid_map_write(struct file *, const char __user *, size_t, loff_t *);
 extern ssize_t proc_gid_map_write(struct file *, const char __user *, size_t, loff_t *);
 extern ssize_t proc_projid_map_write(struct file *, const char __user *, size_t, loff_t *);
+extern ssize_t proc_setgroups_write(struct file *, const char __user *, size_t, loff_t *);
+extern int proc_setgroups_show(struct seq_file *m, void *v);
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
index 44a555ac6104..6e80f4c1322b 100644
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
@@ -839,6 +844,84 @@ static bool new_idmap_permitted(const struct file *file,
 	return false;
 }
 
+int proc_setgroups_show(struct seq_file *seq, void *v)
+{
+	struct user_namespace *ns = seq->private;
+	unsigned long userns_flags = ACCESS_ONCE(ns->flags);
+
+	seq_printf(seq, "%s\n",
+		   (userns_flags & USERNS_SETGROUPS_ALLOWED) ?
+		   "allow" : "deny");
+	return 0;
+}
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
+	ret = -EPERM;
+	mutex_lock(&userns_state_mutex);
+	if (setgroups_allowed) {
+		/* Enabling setgroups after setgroups has been disabled
+		 * is not allowed.
+		 */
+		if (!(ns->flags & USERNS_SETGROUPS_ALLOWED))
+			goto out_unlock;
+	} else {
+		/* Permanently disabling setgroups after setgroups has
+		 * been enabled by writing the gid_map is not allowed.
+		 */
+		if (ns->gid_map.nr_extents != 0)
+			goto out_unlock;
+		ns->flags &= ~USERNS_SETGROUPS_ALLOWED;
+	}
+	mutex_unlock(&userns_state_mutex);
+
+	/* Report a successful write */
+	*ppos = count;
+	ret = count;
+out:
+	return ret;
+out_unlock:
+	mutex_unlock(&userns_state_mutex);
+	goto out;
+}
+
 bool userns_may_setgroups(const struct user_namespace *ns)
 {
 	bool allowed;
@@ -848,6 +931,8 @@ bool userns_may_setgroups(const struct user_namespace *ns)
 	 * the user namespace has been established.
 	 */
 	allowed = ns->gid_map.nr_extents != 0;
+	/* Is setgroups allowed? */
+	allowed = allowed && (ns->flags & USERNS_SETGROUPS_ALLOWED);
 	mutex_unlock(&userns_state_mutex);
 
 	return allowed;
-- 
1.9.1
