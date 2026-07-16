Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 178F043148D;
	Thu, 16 Jul 2026 14:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212840; cv=pass; b=u13J/1njh2AgnNmucLAGq5g57hn3w8Bdfz+YUpuRPyeCNh3QnCcYJvlap7jrhNLWdLkQJQRN1GXdhh3q7XnzNycIGiwozfVkIq8nbqUwqw/VrPer0P7evj6/08FOdPihGFUnYLgmSJTcHPKXTBCvNNLGURsQvIzbwTSvxAX0uns=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212840; c=relaxed/simple;
	bh=V4NwAJ1qZkkMhpH47WNIJ82d1+cWyktYNdFClDVrmZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EALJ6nhVB9wi8gry5/2cz8Pb5yKuOk6W+PFuL1GlrlWuvAuI+7OInuq2uoZCiaQ5svEty4cn5qmQOsTh1uKAUJkQaiiGkcqExF7zUWSOoNGH8TnedoHSd1p4N3y3ZPgDZqyyw5mAsxQPlVLyD4Y0BlcDuTzHPgrjitTXTn1n9ag=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=qxn+h0ds; arc=pass smtp.client-ip=136.143.188.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="qxn+h0ds"
ARC-Seal: i=1; a=rsa-sha256; t=1784212472; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=SQCSCmadAAHdXAGgv5VfGXJwPklN1QCdZMEouWgQBUbB6OvLfeN8d7vgPJIq3BTy2OSa2sASTbG5hNNApdAoYMRnuuytyx/wDltVNBoHqNdBrIJump3TYMKsc7KmRp+aXoKyNBAx+BHXOlFZS8XkLlRNGFumQxkLy20Mq5Ve2Fk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1784212472; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=/Ls7aI2YsKMrYCfbCVyA0Gxy3SdWzDVHyfYWUOskaec=; 
	b=b/2lj6767VDIqcCN6CWeRzUZwDpPf4/pl95bufrTfW23gCGnWFSAQS2x5/yXhxFFwc76YybzwvV1JCwA8M9bdKTv+x6Xy2kSG1lcjNg4POvjcnbHVZtlkTY5QtzyyiXxWVzHKCh92DpB9HhN3qLngrorna3Dym4t1dgoIUAAQn4=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1784212472;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=/Ls7aI2YsKMrYCfbCVyA0Gxy3SdWzDVHyfYWUOskaec=;
	b=qxn+h0dslvw6oMfd/2dt0iQrHdSMBAk98HreekQ2RjLChX2fY2YCs/Ft/kydrVm7
	mGSNLiICeCBGXsTtSRrlA3pcQkhLI2kEWjXwcUBQnEdUkvNyH/xMy+gKZrWu0BCGKgD
	IUaieW66Po9dFMQ0vCi/OXdojRG9FGEc+hSUUWK0=
Received: by mx.zohomail.com with SMTPS id 1784212468515488.1212460986567;
	Thu, 16 Jul 2026 07:34:28 -0700 (PDT)
From: Li Chen <me@linux.beauty>
To: Christian Brauner <brauner@kernel.org>
Cc: Kees Cook <kees@kernel.org>,
	Gabriel Krisman Bertazi <krisman@kernel.org>,
	Josh Triplett <josh@joshtriplett.org>,
	Mateusz Guzik <mjguzik@gmail.com>,
	Andy Lutomirski <luto@kernel.org>,
	John Ericson <mail@johnericson.me>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <shuah@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Oleg Nesterov <oleg@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Paul Moore <paul@paul-moore.com>,
	Eric Paris <eparis@redhat.com>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack@google.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>,
	linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-doc@vger.kernel.org,
	audit@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-mm@kvack.org,
	Li Chen <me@linux.beauty>
Subject: [RFC PATCH 14/24] pidfd: create and execute spawn builder tasks
Date: Thu, 16 Jul 2026 22:31:40 +0800
Message-ID: <8d58bce916b3f13da1ef7f2c7eee13cd7cb78a4c.1784204592.git.me@linux.beauty>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1784204592.git.me@linux.beauty>
References: <cover.1784204592.git.me@linux.beauty>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External

Add pidfd_spawn_run() for a taskless builder. Validate the versioned run
payload, including native and compat pointer-container widths. Allocate a
numeric pid with the reserved pidfs identity. Create the child through the
existing vfork backend.

Publish the same future pidfd as the child pidfd before waking the child.
Queue setup as initial task work so no kernel callback pointers are carried
through architecture register state. Keep the task embryonic until exec has
installed a valid userspace image and register frame.

A failure before task creation initially leaves the builder configurable.
Once a task exists, return setup errors after the child exits. A later
state-machine change tightens the pre-task path to a one-shot claim.

Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Li Chen <me@linux.beauty>
---
 fs/pidfd_spawn.c | 406 ++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 402 insertions(+), 4 deletions(-)

diff --git a/fs/pidfd_spawn.c b/fs/pidfd_spawn.c
index 99e3ef56ecfa3..c0e95c2ddbe6e 100644
--- a/fs/pidfd_spawn.c
+++ b/fs/pidfd_spawn.c
@@ -3,6 +3,7 @@
  * pidfd-backed process spawn builders
  */
 
+#include <linux/completion.h>
 #include <linux/cred.h>
 #include <linux/file.h>
 #include <linux/fs.h>
@@ -13,14 +14,50 @@
 #include <linux/pid_namespace.h>
 #include <linux/pidfd_spawn.h>
 #include <linux/pidfs.h>
+#include <linux/random.h>
 #include <linux/refcount.h>
+#include <linux/sched/mm.h>
 #include <linux/sched/signal.h>
+#include <linux/sched/task.h>
+#include <linux/security.h>
 #include <linux/slab.h>
 #include <linux/syscalls.h>
+#include <linux/task_work.h>
 #include <linux/uaccess.h>
 #include <uapi/linux/pidfd.h>
+#include <uapi/linux/wait.h>
+#include <trace/events/sched.h>
 
+#include "exec_internal.h"
+
+static inline void __user *pidfd_spawn_user_ptr(__u64 p)
+{
+	return u64_to_user_ptr(p);
+}
+
+static inline bool pidfd_spawn_user_ptr_fits(__u64 p)
+{
+#ifdef CONFIG_COMPAT
+	if (in_compat_syscall())
+		return p == (__u64)(compat_uptr_t)p;
+#endif
+	return p == (__u64)(unsigned long)p;
+}
+
+static inline struct user_arg_ptr pidfd_spawn_user_arg(__u64 p)
+{
+#ifdef CONFIG_COMPAT
+	if (in_compat_syscall())
+		return compat_arg((compat_uptr_t __user *)
+				  u64_to_user_ptr(p));
+#endif
+	return native_arg(u64_to_user_ptr(p));
+}
+
+#define PIDFD_SPAWN_EXIT_FAILURE	(127 << 8)
 #define PIDFD_SPAWN_MAX_CONFIG_KEY_SIZE	256
+DEFINE_FREE(pidfd_spawn_dismiss_filename, struct delayed_filename,
+	    dismiss_delayed_filename(&_T))
 
 enum pidfd_spawn_status {
 	PIDFD_SPAWN_CONFIGURING,
@@ -31,14 +68,20 @@ enum pidfd_spawn_status {
 };
 
 struct pidfd_spawn_state {
-	/* Serializes configuration and payload teardown. */
+	/* Serializes configuration, launch, cancellation, and payload teardown. */
 	struct mutex lock;
+	struct completion done;
+	struct callback_head task_work;
 	refcount_t count;
 	struct pid *pid;
 	struct mm_struct *creator_mm;
 	const struct cred *creator_cred;
 	struct pid_namespace *creator_pid_ns;
+	struct delayed_filename filename;
 	char *staged_path;
+	struct user_arg_ptr argv;
+	struct user_arg_ptr envp;
+	int result;
 	enum pidfd_spawn_status status;
 };
 
@@ -80,6 +123,10 @@ pidfd_spawn_configuring_error(const struct pidfd_spawn_state *state)
 
 static void pidfd_spawn_free_state(struct pidfd_spawn_state *state)
 {
+	if (!state)
+		return;
+
+	dismiss_delayed_filename(&state->filename);
 	kfree(state->staged_path);
 	if (state->creator_mm)
 		mmdrop(state->creator_mm);
@@ -136,11 +183,73 @@ pidfd_spawn_state_get_file(struct file *file)
 	return state;
 }
 
+static void pidfd_spawn_drop_run_data(struct pidfd_spawn_state *state,
+				      struct filename *filename, int result)
+{
+	const struct cred *creator_cred;
+	struct mm_struct *creator_mm;
+	struct pid_namespace *creator_pid_ns;
+	char *staged_path;
+
+	/*
+	 * Run data is one-shot. Detach it under the lock, then drop refs
+	 * after the child no longer needs the shared setup payload.
+	 */
+	mutex_lock(&state->lock);
+	creator_mm = state->creator_mm;
+	creator_cred = state->creator_cred;
+	creator_pid_ns = state->creator_pid_ns;
+	staged_path = state->staged_path;
+	state->creator_mm = NULL;
+	state->creator_cred = NULL;
+	state->creator_pid_ns = NULL;
+	state->staged_path = NULL;
+	state->argv = native_arg(NULL);
+	state->envp = native_arg(NULL);
+	state->result = result;
+	pidfd_spawn_set_status(state, PIDFD_SPAWN_SETUP_DONE);
+	mutex_unlock(&state->lock);
+
+	putname(filename);
+	if (creator_mm)
+		mmdrop(creator_mm);
+	if (creator_cred)
+		put_cred(creator_cred);
+	if (creator_pid_ns)
+		put_pid_ns(creator_pid_ns);
+	kfree(staged_path);
+}
+
+static bool pidfd_spawn_same_pid_ns(struct pidfd_spawn_state *state)
+{
+	return current->nsproxy->pid_ns_for_children == state->creator_pid_ns;
+}
+
 static bool pidfd_spawn_same_creator(struct pidfd_spawn_state *state)
 {
+	/*
+	 * Holding the pidfd alone is not enough authority to configure or start
+	 * this builder. A caller must also share the creator's mm, credential
+	 * object, and child PID namespace.
+	 *
+	 * The child PID namespace is part of the builder authority even though no
+	 * numeric PID is allocated until run.
+	 */
 	return current->mm == state->creator_mm &&
 	       current_cred() == state->creator_cred &&
-	       current->nsproxy->pid_ns_for_children == state->creator_pid_ns;
+	       pidfd_spawn_same_pid_ns(state);
+}
+
+static int pidfd_spawn_check_startable(struct pidfd_spawn_state *state)
+{
+	int ret;
+
+	scoped_cond_guard(mutex_intr, return -EINTR, &state->lock) {
+		ret = pidfd_spawn_configuring_error(state);
+		if (!ret && !pidfd_spawn_same_creator(state))
+			ret = -EPERM;
+	}
+	return ret;
 }
 
 static struct filename *pidfd_spawn_get_path(const char __user *value)
@@ -153,6 +262,31 @@ static struct filename *pidfd_spawn_get_path(const char __user *value)
 	return no_free_ptr(name);
 }
 
+static int
+pidfd_spawn_get_delayed_path(struct delayed_filename *delayed,
+			     const char __user *value)
+{
+	struct filename *name __free(putname) = NULL;
+
+	name = pidfd_spawn_get_path(value);
+	if (IS_ERR(name))
+		return PTR_ERR(name);
+
+	return putname_to_delayed(delayed, no_free_ptr(name));
+}
+
+static int
+pidfd_spawn_get_delayed_kernel_path(struct delayed_filename *delayed,
+				    const char *value)
+{
+	struct filename *name __free(putname) = getname_kernel(value);
+
+	if (IS_ERR(name))
+		return PTR_ERR(name);
+
+	return putname_to_delayed(delayed, no_free_ptr(name));
+}
+
 static char *pidfd_spawn_copy_path(const char __user *value)
 {
 	struct filename *name __free(putname) = NULL;
@@ -173,14 +307,14 @@ static int pidfd_spawn_state_set_path(struct pidfd_spawn_state *state,
 {
 	char *path __free(kfree) = NULL;
 	char *old __free(kfree) = NULL;
+	int ret;
 
 	path = pidfd_spawn_copy_path(value);
 	if (IS_ERR(path))
 		return PTR_ERR(path);
 
 	scoped_cond_guard(mutex_intr, return -EINTR, &state->lock) {
-		int ret = pidfd_spawn_configuring_error(state);
-
+		ret = pidfd_spawn_configuring_error(state);
 		if (ret)
 			return ret;
 		if (!pidfd_spawn_same_creator(state))
@@ -243,6 +377,230 @@ SYSCALL_DEFINE5(pidfd_config, int, fd, unsigned int, cmd,
 	return ret;
 }
 
+static void pidfd_spawn_finish_child(struct pidfd_spawn_state *state,
+				     struct filename *filename, int result)
+{
+	pidfd_spawn_drop_run_data(state, filename, result);
+	complete_all(&state->done);
+}
+
+static void pidfd_spawn_child(struct callback_head *work)
+{
+	struct pidfd_spawn_state *state =
+		container_of(work, struct pidfd_spawn_state, task_work);
+	struct filename *filename;
+	int ret;
+
+	filename = complete_getname(&state->filename);
+	if (IS_ERR(filename))
+		ret = PTR_ERR(filename);
+	else
+		ret = 0;
+
+	if (!ret)
+		ret = do_execveat_common(AT_FDCWD, filename,
+					 state->argv, state->envp, 0);
+	if (!ret)
+		task_clear_embryonic_exec(current);
+
+	pidfd_spawn_finish_child(state, filename, ret);
+	if (ret) {
+		pidfd_spawn_state_put(state);
+		do_group_exit(PIDFD_SPAWN_EXIT_FAILURE);
+	}
+	pidfd_spawn_state_put(state);
+}
+
+static int pidfd_spawn_copy_run_args(struct pidfd_spawn_run_args *kargs,
+				     struct pidfd_spawn_run_args __user *uargs,
+				     size_t usize)
+{
+	int ret;
+
+	BUILD_BUG_ON(sizeof(struct pidfd_spawn_run_args) !=
+		     PIDFD_SPAWN_RUN_SIZE_VER0);
+
+	if (usize < PIDFD_SPAWN_RUN_SIZE_VER0)
+		return -EINVAL;
+	if (usize > PAGE_SIZE)
+		return -E2BIG;
+	ret = copy_struct_from_user(kargs, sizeof(*kargs), uargs, usize);
+	if (ret)
+		return ret;
+	if (kargs->flags || kargs->reserved0 || kargs->reserved[0] ||
+	    kargs->reserved[1])
+		return -EINVAL;
+	if (!kargs->argv)
+		return -EINVAL;
+	if (kargs->nr_actions || kargs->actions || kargs->action_size)
+		return -EINVAL;
+	if (!pidfd_spawn_user_ptr_fits(kargs->path) ||
+	    !pidfd_spawn_user_ptr_fits(kargs->argv) ||
+	    !pidfd_spawn_user_ptr_fits(kargs->envp) ||
+	    !pidfd_spawn_user_ptr_fits(kargs->actions))
+		return -EFAULT;
+
+	return 0;
+}
+
+static struct task_struct *
+pidfd_spawn_create_task(struct file *file, struct pidfd_spawn_state *state,
+			struct kernel_clone_args *clone_args)
+{
+	struct pid *pid;
+	struct task_struct *task;
+	u64 ino;
+	int ret;
+
+	ino = pidfs_future_file_ino(file);
+	if (!ino)
+		return ERR_PTR(-EBADF);
+
+	pid = alloc_pid_with_pidfs_ino(current->nsproxy->pid_ns_for_children,
+				       NULL, 0, ino);
+	if (IS_ERR(pid))
+		return ERR_CAST(pid);
+
+	ret = pidfs_future_file_set_pid(file, pid);
+	if (ret) {
+		free_pid(pid);
+		return ERR_PTR(ret);
+	}
+
+	refcount_inc(&state->count);
+	task = copy_process(pid, 0, NUMA_NO_NODE, clone_args);
+	add_latent_entropy();
+	if (IS_ERR(task)) {
+		pidfd_spawn_state_put(state);
+		pidfs_future_file_clear_pid(file, pid);
+		free_pid(pid);
+		return task;
+	}
+
+	trace_sched_process_fork(current, task);
+	get_task_struct(task);
+	return task;
+}
+
+static void pidfd_spawn_publish_pid(struct file *file,
+				    struct pidfd_spawn_state *state,
+				    struct task_struct *task)
+{
+	struct pid *pid = get_task_pid(task, PIDTYPE_PID);
+
+	pidfs_future_file_publish_pid(file, pid);
+	/*
+	 * Publish only after the inode identity, pidfs attributes, and exit-wakeup
+	 * forwarding are ready. Pair with the acquire loads in pidfd resolution
+	 * and poll so readers that observe @pid can use ordinary pidfd operations.
+	 */
+	smp_store_release(&state->pid, pid);
+	pidfs_future_file_notify(file);
+}
+
+static void pidfd_spawn_attach_vfork_done(struct task_struct *task,
+					  struct completion *vfork)
+{
+	init_completion(vfork);
+
+	task_lock(task);
+	task->vfork_done = vfork;
+	task_unlock(task);
+}
+
+static void pidfd_spawn_wait_for_child(struct pidfd_spawn_state *state)
+{
+	wait_for_completion(&state->done);
+}
+
+static int pidfd_spawn_finish_vfork(struct pidfd_spawn_state *state,
+				    struct task_struct *task,
+				    struct completion *vfork)
+{
+	int ret;
+
+	ret = wait_for_vfork_done(task, vfork);
+	if (ret)
+		return ret;
+
+	mutex_lock(&state->lock);
+	ret = state->result;
+	pidfd_spawn_set_status(state, PIDFD_SPAWN_STARTED);
+	mutex_unlock(&state->lock);
+	return ret;
+}
+
+static int pidfd_spawn_start(struct file *file,
+			     struct pidfd_spawn_state *state,
+			     const struct pidfd_spawn_run_args *kargs)
+{
+	struct delayed_filename filename
+		__free(pidfd_spawn_dismiss_filename) = {};
+	struct delayed_filename drop_filename
+		__free(pidfd_spawn_dismiss_filename) = {};
+	struct kernel_clone_args clone_args = {
+		.flags		= CLONE_VM | CLONE_VFORK | CLONE_UNTRACED,
+		.exit_signal	= SIGCHLD,
+		.task_work	= &state->task_work,
+		.embryonic_exec = true,
+	};
+	struct completion vfork;
+	struct task_struct *task;
+	int ret;
+
+	if (kargs->path) {
+		ret = pidfd_spawn_get_delayed_path(&filename,
+						   pidfd_spawn_user_ptr(kargs->path));
+		if (ret)
+			return ret;
+	}
+
+	scoped_cond_guard(mutex_intr, return -EINTR, &state->lock) {
+		ret = pidfd_spawn_configuring_error(state);
+		if (ret)
+			return ret;
+		if (!pidfd_spawn_same_creator(state))
+			return -EPERM;
+		if (state->staged_path && kargs->path)
+			return -EINVAL;
+		if (!state->staged_path && !kargs->path)
+			return -EINVAL;
+		if (state->staged_path) {
+			ret = pidfd_spawn_get_delayed_kernel_path(&filename,
+								  state->staged_path);
+			if (ret)
+				return ret;
+		}
+		state->filename = filename;
+		INIT_DELAYED_FILENAME(&filename);
+
+		state->argv = pidfd_spawn_user_arg(kargs->argv);
+		state->envp = pidfd_spawn_user_arg(kargs->envp);
+		pidfd_spawn_set_status(state, PIDFD_SPAWN_STARTING);
+		reinit_completion(&state->done);
+
+		task = pidfd_spawn_create_task(file, state, &clone_args);
+		if (IS_ERR(task)) {
+			ret = PTR_ERR(task);
+			drop_filename = state->filename;
+			INIT_DELAYED_FILENAME(&state->filename);
+			state->argv = native_arg(NULL);
+			state->envp = native_arg(NULL);
+			state->result = 0;
+			pidfd_spawn_set_status(state,
+					       PIDFD_SPAWN_CONFIGURING);
+			return ret;
+		}
+
+		pidfd_spawn_publish_pid(file, state, task);
+		pidfd_spawn_attach_vfork_done(task, &vfork);
+	}
+
+	wake_up_new_task(task);
+	pidfd_spawn_wait_for_child(state);
+	return pidfd_spawn_finish_vfork(state, task, &vfork);
+}
+
 int pidfd_empty_open(unsigned int flags)
 {
 	struct pidfd_spawn_state *state;
@@ -257,7 +615,13 @@ int pidfd_empty_open(unsigned int flags)
 		return -ENOMEM;
 
 	mutex_init(&state->lock);
+	init_completion(&state->done);
+	init_task_work(&state->task_work, pidfd_spawn_child);
 	refcount_set(&state->count, 1);
+	/*
+	 * Remember the creator so later builder operations cannot be delegated
+	 * just by passing the pidfd through SCM_RIGHTS or similar fd passing.
+	 */
 	mmgrab(current->mm);
 	state->creator_mm = current->mm;
 	state->creator_cred = get_current_cred();
@@ -282,3 +646,37 @@ int pidfd_empty_open(unsigned int flags)
 	fd_install(pidfd, pidfile);
 	return pidfd;
 }
+
+SYSCALL_DEFINE3(pidfd_spawn_run, int, fd,
+		struct pidfd_spawn_run_args __user *, uargs, size_t, usize)
+{
+	struct pidfd_spawn_run_args kargs;
+	struct pidfd_spawn_state *state __free(pidfd_spawn_state) = NULL;
+	int ret;
+
+	ret = pidfd_spawn_copy_run_args(&kargs, uargs, usize);
+	if (ret)
+		return ret;
+
+	CLASS(fd, f)(fd);
+	if (fd_empty(f))
+		return -EBADF;
+
+	state = pidfd_spawn_state_get_file(fd_file(f));
+	if (IS_ERR(state))
+		return PTR_ERR(state);
+
+	scoped_cond_guard(mutex_intr, return -ERESTARTNOINTR,
+			  &current->signal->cred_guard_mutex) {
+		if (READ_ONCE(current->ptrace))
+			return -EPERM;
+		ret = pidfd_spawn_check_startable(state);
+		if (ret)
+			return ret;
+		ret = pidfd_spawn_start(fd_file(f), state, &kargs);
+	}
+	if (!ret)
+		ret = pid_vnr(state->pid);
+
+	return ret;
+}
-- 
2.52.0

