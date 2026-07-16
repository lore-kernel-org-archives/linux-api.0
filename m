Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48CA13101A2;
	Thu, 16 Jul 2026 14:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784213097; cv=pass; b=AdvV5qa3gN/H0gWwCIH+hBmvhLjlDckH8o9Jw2Z/anRoO/gMa4mDPAJLblI2KNeQcRojWqFDN+MYXgJxgnRCH3jg4tOtKHYpHlQW/9l2mJ4/3K8NhK751n/2EtDXmIwvGJcYfU//r1vVL7jrXNCA5d63qAeh5NfvmUNjUHzdaXc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784213097; c=relaxed/simple;
	bh=yU3uXXjlx6D4YmFEK+13/H943g0/+C5W91SJ4mQA01g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RxXUyPxynz58u8bZSqTo495qjwbZ3432HcO9fbAlBKhzUKiEPcLoH7AZW6SYFq2AjGSa7nsshgJN+9MhY4joHBrWCA8WqR3EIl1Q48AnucHb3K2biZDR2gZrznX7iTTKriN4w9h60/2bUCKrbD172OadvTCbAUjRg32mBFaHm3E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=WP2UrJUb; arc=pass smtp.client-ip=136.143.188.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="WP2UrJUb"
ARC-Seal: i=1; a=rsa-sha256; t=1784212539; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=Y1A6Pt+xHHCc6RftA1oxacOJWFGI+BHSGYSSzIilKYi44zxyibzMlZx+JFgjaCuIl2X+tsTcOTLhp1njQqNdEHT8eBjIZK/5vpVn3BlfBCJvxx9gns/ezgXVmn9AwLSiXgijV3/rUK/XWdnpYOXaKz/r/OkNMJIB4rMKDbrv9Bg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1784212539; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=290s3lUtxsTRNn8ivro74GnBQQOXcWg9/LqGiGBD/JE=; 
	b=fR/XaeXfTU1N2cLozyBjs81xrzUG8XtAbAXU1CLc7XyNeNhn3/NDG8wxlc7uU2sJlcvh3OFbX4UlI7pN3jSg3SHD+OsFxLJNYVKDZ1vp2sk84WCcyLnXeGQJBXgmDgjf+RvXXBm8DRDnL7QoXMEFgJ06+hpNWLKCny4pkjVfqZc=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1784212539;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=290s3lUtxsTRNn8ivro74GnBQQOXcWg9/LqGiGBD/JE=;
	b=WP2UrJUbiLu8S5BIoqWeQ3oKsAnfg+6GHKQe1Uj+MZYX0v39zEVjgf7nqHdgyson
	6Jfto1cKV4coKRtOlwQ19kWrICdvnYj4O/K8/CvgBvKXOGewhe4bjk5Cco/p4rEsyFG
	jMBRYBMg/7dGS0djGkyHDfjrTuj1KI2cpNs9ka6Q=
Received: by mx.zohomail.com with SMTPS id 178421253796522.239109081508104;
	Thu, 16 Jul 2026 07:35:37 -0700 (PDT)
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
Subject: [RFC PATCH 21/24] pidfd: consume spawn builders on the first run attempt
Date: Thu, 16 Jul 2026 22:31:47 +0800
Message-ID: <efb77493eead572a22228a917066917c0a40ba7c.1784204592.git.me@linux.beauty>
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

A pre-task run failure currently returns the builder to CONFIGURING. A
second thread can then publish another invocation before the first
caller probes the pidfd, making the observed process state ambiguous.

Claim the builder after type, authority, and ptrace checks but before
run argument access. Any later validation, uaccess, allocation, or
task-creation failure leaves a terminal taskless builder. Later config
and run operations return EBUSY, while process-dependent pidfd
operations return ESRCH.

Normalize every internal restart error after the claim to EINTR so the
architecture cannot restart a consumed invocation and replace its
result with EBUSY. Preserve normal restart behavior before the claim.

Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Li Chen <me@linux.beauty>
---
 fs/pidfd_spawn.c | 164 +++++++++++++++++++++++++++++++----------------
 1 file changed, 109 insertions(+), 55 deletions(-)

diff --git a/fs/pidfd_spawn.c b/fs/pidfd_spawn.c
index 3e46a12c0ba07..1309fe99ec091 100644
--- a/fs/pidfd_spawn.c
+++ b/fs/pidfd_spawn.c
@@ -73,6 +73,7 @@ DEFINE_FREE(pidfd_spawn_dismiss_filename, struct delayed_filename,
 enum pidfd_spawn_status {
 	PIDFD_SPAWN_CONFIGURING,
 	PIDFD_SPAWN_STARTING,
+	PIDFD_SPAWN_FAILED_TASKLESS,
 	PIDFD_SPAWN_SETUP_DONE,
 	PIDFD_SPAWN_STARTED,
 	PIDFD_SPAWN_CANCELLED,
@@ -100,6 +101,14 @@ struct pidfd_spawn_state {
 	enum pidfd_spawn_status status;
 };
 
+struct pidfd_spawn_resources {
+	struct pidfd_spawn_action *actions;
+	struct mm_struct *creator_mm;
+	const struct cred *creator_cred;
+	struct pid_namespace *creator_pid_ns;
+	char *staged_path;
+};
+
 static struct pid *
 pidfd_spawn_load_pid(const struct pidfd_spawn_state *state)
 {
@@ -183,8 +192,16 @@ static struct pid *pidfd_spawn_file_pid(void *data)
 	return pid ? pid : ERR_PTR(-ESRCH);
 }
 
+static bool pidfd_spawn_file_terminal(void *data)
+{
+	struct pidfd_spawn_state *state = data;
+
+	return pidfd_spawn_get_status(state) == PIDFD_SPAWN_FAILED_TASKLESS;
+}
+
 static const struct pidfs_future_file_ops pidfd_spawn_future_ops = {
 	.get_pid = pidfd_spawn_file_pid,
+	.is_terminal = pidfd_spawn_file_terminal,
 	.release = pidfd_spawn_state_release,
 };
 
@@ -199,31 +216,47 @@ pidfd_spawn_state_get_file(struct file *file)
 	return state;
 }
 
+static void
+pidfd_spawn_detach_resources(struct pidfd_spawn_state *state,
+			     struct pidfd_spawn_resources *resources)
+{
+	resources->actions = state->actions;
+	resources->creator_mm = state->creator_mm;
+	resources->creator_cred = state->creator_cred;
+	resources->creator_pid_ns = state->creator_pid_ns;
+	resources->staged_path = state->staged_path;
+	state->actions = NULL;
+	state->creator_mm = NULL;
+	state->creator_cred = NULL;
+	state->creator_pid_ns = NULL;
+	state->staged_path = NULL;
+	state->nr_actions = 0;
+}
+
+static void
+pidfd_spawn_put_resources(struct pidfd_spawn_resources *resources)
+{
+	if (resources->creator_mm)
+		mmdrop(resources->creator_mm);
+	if (resources->creator_cred)
+		put_cred(resources->creator_cred);
+	if (resources->creator_pid_ns)
+		put_pid_ns(resources->creator_pid_ns);
+	kfree(resources->staged_path);
+	kvfree(resources->actions);
+}
+
 static void pidfd_spawn_drop_run_data(struct pidfd_spawn_state *state,
 				      struct filename *filename, int result)
 {
-	const struct cred *creator_cred;
-	struct pidfd_spawn_action *actions;
-	struct mm_struct *creator_mm;
-	struct pid_namespace *creator_pid_ns;
-	char *staged_path;
+	struct pidfd_spawn_resources resources = {};
 
 	/*
 	 * Run data is one-shot. Detach it under the lock, then drop refs
 	 * after the child no longer needs the shared setup payload.
 	 */
 	mutex_lock(&state->lock);
-	actions = state->actions;
-	creator_mm = state->creator_mm;
-	creator_cred = state->creator_cred;
-	creator_pid_ns = state->creator_pid_ns;
-	staged_path = state->staged_path;
-	state->actions = NULL;
-	state->creator_mm = NULL;
-	state->creator_cred = NULL;
-	state->creator_pid_ns = NULL;
-	state->staged_path = NULL;
-	state->nr_actions = 0;
+	pidfd_spawn_detach_resources(state, &resources);
 	state->argv = native_arg(NULL);
 	state->envp = native_arg(NULL);
 	memset(state->audit_args, 0, sizeof(state->audit_args));
@@ -235,14 +268,7 @@ static void pidfd_spawn_drop_run_data(struct pidfd_spawn_state *state,
 	mutex_unlock(&state->lock);
 
 	putname(filename);
-	if (creator_mm)
-		mmdrop(creator_mm);
-	if (creator_cred)
-		put_cred(creator_cred);
-	if (creator_pid_ns)
-		put_pid_ns(creator_pid_ns);
-	kfree(staged_path);
-	kvfree(actions);
+	pidfd_spawn_put_resources(&resources);
 }
 
 static bool pidfd_spawn_cancel(struct pidfd_spawn_state *state,
@@ -291,16 +317,44 @@ static bool pidfd_spawn_same_creator(struct pidfd_spawn_state *state)
 	       pidfd_spawn_same_pid_ns(state);
 }
 
-static int pidfd_spawn_check_startable(struct pidfd_spawn_state *state)
+static int pidfd_spawn_claim(struct pidfd_spawn_state *state)
 {
 	int ret;
 
-	scoped_cond_guard(mutex_intr, return -EINTR, &state->lock) {
+	scoped_guard(mutex, &state->lock) {
 		ret = pidfd_spawn_configuring_error(state);
-		if (!ret && !pidfd_spawn_same_creator(state))
-			ret = -EPERM;
+		if (ret)
+			return ret;
+		if (!pidfd_spawn_same_creator(state))
+			return -EPERM;
+
+		pidfd_spawn_set_status(state, PIDFD_SPAWN_STARTING);
 	}
-	return ret;
+	return 0;
+}
+
+static void pidfd_spawn_fail_taskless(struct file *file,
+				      struct pidfd_spawn_state *state, int result)
+{
+	struct pidfd_spawn_resources resources = {};
+
+	mutex_lock(&state->lock);
+	if (WARN_ON_ONCE(pidfd_spawn_get_status(state) !=
+			 PIDFD_SPAWN_STARTING || pidfd_spawn_load_pid(state))) {
+		mutex_unlock(&state->lock);
+		return;
+	}
+	state->result = result;
+	pidfd_spawn_detach_resources(state, &resources);
+	state->argv = native_arg(NULL);
+	state->envp = native_arg(NULL);
+	memset(state->audit_args, 0, sizeof(state->audit_args));
+	state->audit_syscall = 0;
+	pidfd_spawn_set_status(state, PIDFD_SPAWN_FAILED_TASKLESS);
+	mutex_unlock(&state->lock);
+
+	pidfd_spawn_put_resources(&resources);
+	pidfs_future_file_notify(file);
 }
 
 static struct filename *pidfd_spawn_get_path(const char __user *value)
@@ -718,7 +772,7 @@ static void pidfd_spawn_child(struct callback_head *work)
 }
 
 static int pidfd_spawn_copy_run_args(struct pidfd_spawn_run_args *kargs,
-				     struct pidfd_spawn_run_args __user *uargs,
+				     const struct pidfd_spawn_run_args __user *uargs,
 				     size_t usize)
 {
 	size_t actions_size;
@@ -873,6 +927,13 @@ static int pidfd_spawn_start(struct file *file,
 	struct task_struct *task;
 	int ret;
 
+	scoped_cond_guard(mutex_intr, return -EINTR, &state->lock) {
+		if (pidfd_spawn_get_status(state) != PIDFD_SPAWN_STARTING)
+			return -EBUSY;
+		if (!!state->staged_path == !!kargs->path)
+			return -EINVAL;
+	}
+
 	if (kargs->path) {
 		ret = pidfd_spawn_get_delayed_path(&filename,
 						   pidfd_spawn_user_ptr(kargs->path));
@@ -881,15 +942,8 @@ static int pidfd_spawn_start(struct file *file,
 	}
 
 	scoped_cond_guard(mutex_intr, return -EINTR, &state->lock) {
-		ret = pidfd_spawn_configuring_error(state);
-		if (ret)
-			return ret;
-		if (!pidfd_spawn_same_creator(state))
-			return -EPERM;
-		if (state->staged_path && kargs->path)
-			return -EINVAL;
-		if (!state->staged_path && !kargs->path)
-			return -EINVAL;
+		if (pidfd_spawn_get_status(state) != PIDFD_SPAWN_STARTING)
+			return -EBUSY;
 		if (state->staged_path) {
 			ret = pidfd_spawn_get_delayed_kernel_path(&filename,
 								  state->staged_path);
@@ -903,7 +957,6 @@ static int pidfd_spawn_start(struct file *file,
 		state->envp = pidfd_spawn_user_arg(kargs->envp);
 		state->actions = *actions;
 		state->nr_actions = kargs->nr_actions;
-		pidfd_spawn_set_status(state, PIDFD_SPAWN_STARTING);
 		pidfd_spawn_save_audit_context(state);
 		*actions = NULL;
 		reinit_completion(&state->done);
@@ -921,9 +974,6 @@ static int pidfd_spawn_start(struct file *file,
 			memset(state->audit_args, 0,
 			       sizeof(state->audit_args));
 			state->audit_syscall = 0;
-			state->result = 0;
-			pidfd_spawn_set_status(state,
-					       PIDFD_SPAWN_CONFIGURING);
 			return ret;
 		}
 
@@ -1002,17 +1052,13 @@ int pidfd_empty_open(unsigned int flags)
 }
 
 SYSCALL_DEFINE3(pidfd_spawn_run, int, fd,
-		struct pidfd_spawn_run_args __user *, uargs, size_t, usize)
+		const struct pidfd_spawn_run_args __user *, uargs, size_t, usize)
 {
 	struct pidfd_spawn_action *actions __free(kvfree) = NULL;
 	struct pidfd_spawn_run_args kargs;
 	struct pidfd_spawn_state *state __free(pidfd_spawn_state) = NULL;
 	int ret;
 
-	ret = pidfd_spawn_copy_run_args(&kargs, uargs, usize);
-	if (ret)
-		return ret;
-
 	CLASS(fd, f)(fd);
 	if (fd_empty(f))
 		return -EBADF;
@@ -1020,19 +1066,27 @@ SYSCALL_DEFINE3(pidfd_spawn_run, int, fd,
 	state = pidfd_spawn_state_get_file(fd_file(f));
 	if (IS_ERR(state))
 		return PTR_ERR(state);
-	ret = pidfd_spawn_copy_actions(&actions, kargs.actions,
-				       kargs.nr_actions, kargs.action_size);
-	if (ret)
-		return ret;
-
 	scoped_cond_guard(mutex_intr, return -ERESTARTNOINTR,
 			  &current->signal->cred_guard_mutex) {
 		if (READ_ONCE(current->ptrace))
 			return -EPERM;
-		ret = pidfd_spawn_check_startable(state);
+		ret = pidfd_spawn_claim(state);
 		if (ret)
 			return ret;
-		ret = pidfd_spawn_start(fd_file(f), state, &kargs, &actions);
+
+		ret = pidfd_spawn_copy_run_args(&kargs, uargs, usize);
+		if (!ret)
+			ret = pidfd_spawn_copy_actions(&actions, kargs.actions,
+						       kargs.nr_actions,
+						       kargs.action_size);
+		if (!ret)
+			ret = pidfd_spawn_start(fd_file(f), state, &kargs,
+						&actions);
+		if (ret) {
+			ret = pidfd_spawn_normalize_result(ret);
+			if (!pidfd_spawn_load_pid(state))
+				pidfd_spawn_fail_taskless(fd_file(f), state, ret);
+		}
 	}
 	if (!ret)
 		ret = pid_vnr(state->pid);
-- 
2.52.0

