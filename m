Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E2FD431A3C;
	Thu, 16 Jul 2026 14:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212551; cv=pass; b=pWeIi/4KEfywQNXZ7ZYlt16DpVAW1egXxrkymxXceKACLAPMH4E67FHxmGSE2UN5/Tsd6A1HyKfIIqhgr5ePJe4COveMsF5akGjxL1lwIhVa3o9d9KLXUjhEKsWHEyCzaKftOuQOcYt69VnF2FqK4C2IJGT2qXjNR7Dhnom7bDk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212551; c=relaxed/simple;
	bh=qLPUK8vhUwRBwRRYoNn2yHn6H0bnoEd+X3OeEQIhk0k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uOwQ8BnzIbi+QQXB20gol5jQZHQVOXyaKXqDaZUepjTo902npoy4vv0PQCIjb2tPYo9UM5FvCdcOmF0oz7DPL+EQTiLUWjA1lQdSgPn/RRzaJ11RQPN5JuVQPudqX8VWIxpfc+VDwLcjtzHAOxlIpGVH1vUf/EipZ1bbnelRD1w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=W40agwh9; arc=pass smtp.client-ip=136.143.188.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="W40agwh9"
ARC-Seal: i=1; a=rsa-sha256; t=1784212384; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=b8F40UHI88oJ+h9SlDGv+TZAWYuh6HMgmPCy1ECs93EhJKSXPWvfWOEEIobgOd0supW/bczuM8sKj6QogvgVsgYdRpStanIRL2QUwr9C5LEwddgUMwCoqO5rCNEA4Y5H1go/k+rFczOZdPjAQNEDUzmejAssaRiQkEsH3piIPr0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1784212384; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=wURXbIM83i/KM001FnsACgDfZj9qHrMeiWNQVSUpwNw=; 
	b=XVZFji20ghNVUck8HXJ5I5EbAuTskTJY/sSDv6tX7i8jnMcCl1j7B8+pFQG3QURVMh35Waa+vx15S5Zd1UfbvksZ5NxSjLq+HtYpa8wqh8JFKdQojFTgBObxvLr0g6NCrkoKiq/mQv0vRlxOE8wLeIrBkCnYzItVIFT3lZyX0Vs=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1784212384;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=wURXbIM83i/KM001FnsACgDfZj9qHrMeiWNQVSUpwNw=;
	b=W40agwh93u/3odCcnpcCuhZwftUiJ+CDv+Ow+DUOGJNzad7HZg1t85R5EJQ+2Z3q
	SvgJCMkXrJOZzDr9cJutf5fDp0eAz9wdZwNrxiqgg6jjGmwsZJusi782ZFseDFp9XTI
	D0QuvG/DRdqT+3axpJvPnEoURoUP4MD4txFPOP70=
Received: by mx.zohomail.com with SMTPS id 1784212381524503.8460858206049;
	Thu, 16 Jul 2026 07:33:01 -0700 (PDT)
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
Subject: [RFC PATCH 05/24] pidfd: add spawn builder path configuration
Date: Thu, 16 Jul 2026 22:31:31 +0800
Message-ID: <650cf9dd6ed58ee90617f72f7743262787c822c7.1784204592.git.me@linux.beauty>
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

Add an fsconfig-style pidfd_config() implementation and the initial path
string key. The builder inode retains configuration, which userspace may
replace before the child is created.

Bind configuration authority to the creator mm, credential object, and
child PID namespace. Passing the fd alone therefore does not delegate
launch authority to a different process context.

Accept absolute and relative executable paths. A later run operation
resolves relative paths from the child working directory without PATH
search. Keep the syscall unreachable until the complete spawn state machine
is wired later in the series.

Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Li Chen <me@linux.beauty>
---
 fs/pidfd_spawn.c | 155 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 155 insertions(+)

diff --git a/fs/pidfd_spawn.c b/fs/pidfd_spawn.c
index ff2b0cb6365a5..46207c8e8139f 100644
--- a/fs/pidfd_spawn.c
+++ b/fs/pidfd_spawn.c
@@ -3,24 +3,47 @@
  * pidfd-backed process spawn builders
  */
 
+#include <linux/cred.h>
 #include <linux/file.h>
 #include <linux/fs.h>
+#include <linux/mm.h>
+#include <linux/mutex.h>
+#include <linux/namei.h>
 #include <linux/pid.h>
+#include <linux/pid_namespace.h>
 #include <linux/pidfd_spawn.h>
 #include <linux/pidfs.h>
 #include <linux/refcount.h>
+#include <linux/sched/signal.h>
 #include <linux/slab.h>
+#include <linux/syscalls.h>
+#include <linux/uaccess.h>
 #include <uapi/linux/pidfd.h>
 
+#define PIDFD_SPAWN_MAX_CONFIG_KEY_SIZE	256
+
 struct pidfd_spawn_state {
+	/* Serializes configuration and payload teardown. */
+	struct mutex lock;
 	refcount_t count;
 	struct pid *pid;
+	struct mm_struct *creator_mm;
+	const struct cred *creator_cred;
+	struct pid_namespace *creator_pid_ns;
+	char *staged_path;
 };
 
 static void pidfd_spawn_state_put(struct pidfd_spawn_state *state);
 
 static void pidfd_spawn_free_state(struct pidfd_spawn_state *state)
 {
+	kfree(state->staged_path);
+	if (state->creator_mm)
+		mmdrop(state->creator_mm);
+	if (state->creator_cred)
+		put_cred(state->creator_cred);
+	if (state->creator_pid_ns)
+		put_pid_ns(state->creator_pid_ns);
 	put_pid(state->pid);
 	kfree(state);
 }
@@ -31,6 +54,15 @@ static void pidfd_spawn_state_put(struct pidfd_spawn_state *state)
 		pidfd_spawn_free_state(state);
 }
 
+static void pidfd_spawn_state_put_cleanup(struct pidfd_spawn_state *state)
+{
+	if (!IS_ERR_OR_NULL(state))
+		pidfd_spawn_state_put(state);
+}
+
+DEFINE_FREE(pidfd_spawn_state, struct pidfd_spawn_state *,
+	    pidfd_spawn_state_put_cleanup(_T))
+
 static void pidfd_spawn_state_release(void *data)
 {
 	pidfd_spawn_state_put(data);
@@ -50,17 +82,140 @@ static const struct pidfs_future_file_ops pidfd_spawn_future_ops = {
 	.release = pidfd_spawn_state_release,
 };
 
+static struct pidfd_spawn_state *
+pidfd_spawn_state_get_file(struct file *file)
+{
+	struct pidfd_spawn_state *state;
+
+	state = pidfs_future_file_data(file, &pidfd_spawn_future_ops);
+	if (!state || !refcount_inc_not_zero(&state->count))
+		return ERR_PTR(state ? -ESRCH : -EINVAL);
+	return state;
+}
+
+static bool pidfd_spawn_same_creator(struct pidfd_spawn_state *state)
+{
+	return current->mm == state->creator_mm &&
+	       current_cred() == state->creator_cred &&
+	       current->nsproxy->pid_ns_for_children == state->creator_pid_ns;
+}
+
+static struct filename *pidfd_spawn_get_path(const char __user *value)
+{
+	CLASS(filename, name)(value);
+
+	if (IS_ERR(name))
+		return ERR_CAST(name);
+
+	return no_free_ptr(name);
+}
+
+static char *pidfd_spawn_copy_path(const char __user *value)
+{
+	struct filename *name __free(putname) = NULL;
+	char *path;
+
+	name = pidfd_spawn_get_path(value);
+	if (IS_ERR(name))
+		return ERR_CAST(name);
+	path = kstrdup(name->name, GFP_KERNEL_ACCOUNT);
+	if (!path)
+		return ERR_PTR(-ENOMEM);
+
+	return path;
+}
+
+static int pidfd_spawn_state_set_path(struct pidfd_spawn_state *state,
+				      const char __user *value)
+{
+	char *path __free(kfree) = NULL;
+	char *old __free(kfree) = NULL;
+
+	path = pidfd_spawn_copy_path(value);
+	if (IS_ERR(path))
+		return PTR_ERR(path);
+
+	scoped_cond_guard(mutex_intr, return -EINTR, &state->lock) {
+		if (!pidfd_spawn_same_creator(state))
+			return -EPERM;
+
+		old = state->staged_path;
+		state->staged_path = no_free_ptr(path);
+	}
+	return 0;
+}
+
+static int pidfd_spawn_state_set_string(struct pidfd_spawn_state *state,
+					const char *key,
+					const void __user *value)
+{
+	if (!strcmp(key, PIDFD_CONFIG_KEY_PATH))
+		return pidfd_spawn_state_set_path(state, value);
+
+	return -EOPNOTSUPP;
+}
+
+SYSCALL_DEFINE5(pidfd_config, int, fd, unsigned int, cmd,
+		const char __user *, ukey, const void __user *, uvalue,
+		int, aux)
+{
+	char *key __free(kfree) = NULL;
+	struct pidfd_spawn_state *state __free(pidfd_spawn_state) = NULL;
+	int ret;
+
+	switch (cmd) {
+	case PIDFD_CONFIG_SET_STRING:
+		if (!ukey || !uvalue || aux)
+			return -EINVAL;
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	CLASS(fd, f)(fd);
+	if (fd_empty(f))
+		return -EBADF;
+
+	state = pidfd_spawn_state_get_file(fd_file(f));
+	if (IS_ERR(state))
+		return PTR_ERR(state);
+
+	key = strndup_user(ukey, PIDFD_SPAWN_MAX_CONFIG_KEY_SIZE);
+	if (IS_ERR(key))
+		return PTR_ERR(key);
+
+	switch (cmd) {
+	case PIDFD_CONFIG_SET_STRING:
+		ret = pidfd_spawn_state_set_string(state, key, uvalue);
+		break;
+	default:
+		ret = -EOPNOTSUPP;
+		break;
+	}
+
+	return ret;
+}
+
 int pidfd_empty_open(unsigned int flags)
 {
 	struct pidfd_spawn_state *state;
 	struct file *pidfile;
 	int pidfd;
 
+	if (!current->mm)
+		return -EINVAL;
+
 	state = kzalloc_obj(*state, GFP_KERNEL_ACCOUNT);
 	if (!state)
 		return -ENOMEM;
 
+	mutex_init(&state->lock);
 	refcount_set(&state->count, 1);
+	mmgrab(current->mm);
+	state->creator_mm = current->mm;
+	state->creator_cred = get_current_cred();
+	state->creator_pid_ns =
+		get_pid_ns(current->nsproxy->pid_ns_for_children);
 
 	pidfile = pidfs_alloc_future_file("[pidfd_spawn]", state,
 					  &pidfd_spawn_future_ops,
-- 
2.52.0

