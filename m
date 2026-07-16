Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 489E61D435F;
	Thu, 16 Jul 2026 14:37:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212679; cv=pass; b=HH8aOLMUbZtlBOT0f7PBT9ByqHTvLEVZmxp25c2Oe5ZBAbxYx3KiL3qIGjHoOTbzPNyfT6d1RzL4psQfMvvGP3p+f4SuN77CSxQRxwt6m/8S6HKd2tvVDP6yFMWBqDaFIElB5CcwJO8nlZfU3MWM71wPm/pXZyqNt3wScRDp0zg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212679; c=relaxed/simple;
	bh=0S223wyaT62YTlyMtGU9bsyyCzfdd4jbU6pXmBqE6CU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dlyrwmnBhTN3J6IGWOWqO+DJqGPPe1qHmpm+fYvSqjfnqVyLThVcKTRFP3y5q7ViDWKN0IsxnOENuOOPQtWPuyTIu3wXQdoN9u7PHcHpH+3hhKZL+B0inCw0U4uDZNsJXic7r2oatuBTNY2PC+uI2iUGbib+6xLzgkoBZRFBZcU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=XS7JAmBc; arc=pass smtp.client-ip=136.143.188.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="XS7JAmBc"
ARC-Seal: i=1; a=rsa-sha256; t=1784212423; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=mP5Bo8nEM9S+Mw6KA6uiFRlAqKu176gQr+zRP8YXoU73ULcPYeuNuHcwNoAkPaL3v6C/W89/4YaHhryK+wmtlgLBwLRpZGkPr4YTLbh9AYrLcJsOMmmn40Ix5DuBqJTtzLt0g2w37NQbPF7LZr9L7fe9y3r8pfLvvdsNtwQjvig=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1784212423; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=csZJqwFw/LF9jvJifU7Wr9Kub+l+N/C7ZLf6/P48CP4=; 
	b=gYMXR3sey9S5i81vhtgYUlnAbvQH+FABm9cEuPB2FO2PiJZsTp7Ba8tiyMYE5VnuDYbLEXQNONua+D0WqevLpikCMyTn//L/gOnlKwYIS+5xckf+LJd8+/2xjs5v3i3ebFe51zGpxBLGarakg7agJNEDmrhzjuoUBEK/rR4COMs=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1784212423;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=csZJqwFw/LF9jvJifU7Wr9Kub+l+N/C7ZLf6/P48CP4=;
	b=XS7JAmBc4/sJx8XPkI0/vBhiJxXrqgfyFb0OLS/umUzn0lGKtGl/JzEc4Padd895
	rMMYGbAPFVb1zgbPNCcvFj1nMZ0KKvfy8cyBeJYKr73sd6XcDRqTuUcRArmydCKGy7k
	V8LvQMeRsOiLcisUxN4RhP8fDYgkyiDJLUnsIdFs=
Received: by mx.zohomail.com with SMTPS id 17842124204621023.6986145207051;
	Thu, 16 Jul 2026 07:33:40 -0700 (PDT)
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
Subject: [RFC PATCH 09/24] fork: let process builders supply preallocated pids
Date: Thu, 16 Jul 2026 22:31:35 +0800
Message-ID: <129eedc78affaf85e4d552daae1460a43057fb39.1784204592.git.me@linux.beauty>
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

Process builders can reserve a pidfs identity before copy_process()
makes a task visible. Add an alloc_pid() variant for a reserved pidfs
inode, and let copy_process() consume a caller-provided struct pid on
success.

Keep caller ownership on failure. The legacy NULL-pid path continues to
allocate and free its own pid. Validate the target PID namespace before
using a preallocated identity.

Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Li Chen <me@linux.beauty>
---
 include/linux/pid.h |  3 +++
 kernel/fork.c       | 16 ++++++++++++++--
 kernel/pid.c        | 22 ++++++++++++++++++++--
 3 files changed, 37 insertions(+), 4 deletions(-)

diff --git a/include/linux/pid.h b/include/linux/pid.h
index a29ffe2a5fa8e..fa8acae336f7c 100644
--- a/include/linux/pid.h
+++ b/include/linux/pid.h
@@ -142,6 +142,9 @@ extern struct pid *find_ge_pid(int nr, struct pid_namespace *);
 
 extern struct pid *alloc_pid(struct pid_namespace *ns, pid_t *set_tid,
 			     size_t set_tid_size);
+struct pid *alloc_pid_with_pidfs_ino(struct pid_namespace *ns,
+				     pid_t *set_tid, size_t set_tid_size,
+				     u64 pidfs_ino);
 extern void free_pid(struct pid *pid);
 void free_pids(struct pid **pids);
 extern void disable_pid_allocation(struct pid_namespace *ns);
diff --git a/kernel/fork.c b/kernel/fork.c
index 970810a01bbf6..d16405c037c2f 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -2006,6 +2006,9 @@ static bool need_futex_hash_allocate_default(u64 clone_flags)
  * It copies the registers, and all the appropriate
  * parts of the process environment (as per the clone
  * flags). The actual kick-off is left to the caller.
+ *
+ * Except for init_struct_pid, a caller-supplied pid reference remains owned
+ * by the caller on failure and is transferred to the new task on success.
  */
 __latent_entropy struct task_struct *copy_process(
 					struct pid *pid,
@@ -2017,6 +2020,7 @@ __latent_entropy struct task_struct *copy_process(
 	struct task_struct *p;
 	struct multiprocess_signals delayed;
 	struct file *pidfile = NULL;
+	bool allocated_pid = false;
 	const u64 clone_flags = args->flags;
 	struct nsproxy *nsp = current->nsproxy;
 
@@ -2317,13 +2321,21 @@ __latent_entropy struct task_struct *copy_process(
 
 	stackleak_task_init(p);
 
-	if (pid != &init_struct_pid) {
+	if (!pid) {
 		pid = alloc_pid(p->nsproxy->pid_ns_for_children, args->set_tid,
 				args->set_tid_size);
 		if (IS_ERR(pid)) {
 			retval = PTR_ERR(pid);
 			goto bad_fork_cleanup_thread;
 		}
+		allocated_pid = true;
+	} else if (pid != &init_struct_pid) {
+		if (args->set_tid_size ||
+		    ns_of_pid(pid) != p->nsproxy->pid_ns_for_children ||
+		    WARN_ON_ONCE(pid_has_task(pid, PIDTYPE_PID))) {
+			retval = -EINVAL;
+			goto bad_fork_cleanup_thread;
+		}
 	}
 
 	/*
@@ -2587,7 +2599,7 @@ __latent_entropy struct task_struct *copy_process(
 		put_unused_fd(pidfd);
 	}
 bad_fork_free_pid:
-	if (pid != &init_struct_pid)
+	if (allocated_pid)
 		free_pid(pid);
 bad_fork_cleanup_thread:
 	exit_thread(p);
diff --git a/kernel/pid.c b/kernel/pid.c
index f55189a3d07d4..010f80177cac8 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -156,8 +156,8 @@ void free_pids(struct pid **pids)
 			free_pid(pids[tmp]);
 }
 
-struct pid *alloc_pid(struct pid_namespace *ns, pid_t *arg_set_tid,
-		      size_t arg_set_tid_size)
+static struct pid *__alloc_pid(struct pid_namespace *ns, pid_t *arg_set_tid,
+			       size_t arg_set_tid_size, u64 pidfs_ino)
 {
 	int set_tid[MAX_PID_NS_LEVEL + 1] = {};
 	int pid_max[MAX_PID_NS_LEVEL + 1] = {};
@@ -198,6 +198,7 @@ struct pid *alloc_pid(struct pid_namespace *ns, pid_t *arg_set_tid,
 	init_waitqueue_head(&pid->wait_pidfd);
 	INIT_HLIST_HEAD(&pid->inodes);
 	pidfs_prepare_pid(pid);
+	pid->ino = pidfs_ino;
 
 	/*
 	 * 2. perm check checkpoint_restore_ns_capable()
@@ -358,6 +359,23 @@ struct pid *alloc_pid(struct pid_namespace *ns, pid_t *arg_set_tid,
 	return ERR_PTR(retval);
 }
 
+struct pid *alloc_pid(struct pid_namespace *ns, pid_t *arg_set_tid,
+		      size_t arg_set_tid_size)
+{
+	return __alloc_pid(ns, arg_set_tid, arg_set_tid_size, 0);
+}
+
+struct pid *alloc_pid_with_pidfs_ino(struct pid_namespace *ns,
+				     pid_t *arg_set_tid,
+				     size_t arg_set_tid_size,
+				     u64 pidfs_ino)
+{
+	if (!pidfs_ino)
+		return ERR_PTR(-EINVAL);
+
+	return __alloc_pid(ns, arg_set_tid, arg_set_tid_size, pidfs_ino);
+}
+
 void disable_pid_allocation(struct pid_namespace *ns)
 {
 	spin_lock(&pidmap_lock);
-- 
2.52.0

