Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C51E42377B;
	Thu, 16 Jul 2026 14:42:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212935; cv=pass; b=NIX5EnJ6bCZ3N47LXlzrx2x/Qz5FllzWP0gA7i6BKlV/1Bf4cpFnaR8G/tDIvF3mWpKAllwZ8QgxwK/WeK0S3Di6QnOiV3PnsDlhalVDvbrP8xLFHn/N2Al4ioCiY1F7trdvzCEVCLGu0/gFf0/zOKQvZpdOMFbMoQ7GM10TBWM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212935; c=relaxed/simple;
	bh=WNdzlWGWU4YvbInpjvrlLRsry/kR3wXV93/UWmx+W6c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V3UsqtQWhMJ4fgRj/1aAYKLTOnRpfRPE2VYPmCo7WWtTBJd4IoYxO5ukdfWWB7GcLs7TYY5R3jW5NblsIUVVHdgmr4eoWBJ9E0lO99AjHnYF2zD4OgUBlGkFSxujITRUz4Jf6pKbeNvb854xSaEKsl+COX3k4dTzyShZKW3ZAZU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=ZBwgMILz; arc=pass smtp.client-ip=136.143.188.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="ZBwgMILz"
ARC-Seal: i=1; a=rsa-sha256; t=1784212501; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=nu1K5fhyZ84BrranuLaPmdTdPYfLMNoVfqxjZVOEDlsCLoSILd2b6p7FBWjyRMnnVxAVgiJMzqzjUrTsQrI6EqbwTfOeRmduFAdjnEued9yZ2rGfJk7hPvsaoGRa/UuY1BimEwsnamw98SnbNQiobm9Po4lupS0jq89f03LAQe8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1784212501; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=yoK4SvsjwMeieg8o4bmFNUXZwhKfXanw0pGvrr4f5Qw=; 
	b=dk0WC6SoV2kLryLQGqSjCHYc8x6pN2bpOBCDJHFH6Q0InYDdkEaSk1/lUH2u+3sVqvUVQwdo+f/GAgBMzrKMomp9eFCbwncjZSFVkW8eFmEmkDPwV/Hs7H1/viELmAdpJ56cpzfY1Gq0GpNhGsK6kN6E15lmf7cVQX6ZkAXRkL8=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1784212501;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=yoK4SvsjwMeieg8o4bmFNUXZwhKfXanw0pGvrr4f5Qw=;
	b=ZBwgMILzjl5G63fDstUVtBkp8heqJiXzCOdKrgW63x/RQYv5US6IasXIoEcZHpxU
	UPtlNvrG5JJnrivIKEk7WsN4l4hqRGZ++4P4YPYiNBrOSnLBYa0lduxMelHrc3Bb3Y/
	a0m+7YUDJ7Y1F2iEvrXAhAhENxqtJTcGgc7rSWcM=
Received: by mx.zohomail.com with SMTPS id 1784212497833640.4955217561878;
	Thu, 16 Jul 2026 07:34:57 -0700 (PDT)
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
Subject: [RFC PATCH 17/24] pidfd: audit child spawn execution
Date: Thu, 16 Jul 2026 22:31:43 +0800
Message-ID: <f12dd4088017f2718bcaf4b2796426f16ba486cd.1784204592.git.me@linux.beauty>
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

The child exec path runs outside the caller's audit context. A delayed
filename can leave a name-only record in the caller transaction, but inode
metadata and exec arguments are otherwise lost because the new task starts
with an unused audit context.

Start a dedicated AUDIT_PIDFD_SPAWN transaction before executable lookup so
audit rules can observe child identity, EXECVE arguments, and inode-backed
PATH records. Close it explicitly with the child setup result.
Task work does not enter through a userspace syscall frame, so do not
synthesize one.

Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Li Chen <me@linux.beauty>
---
 fs/pidfd_spawn.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/fs/pidfd_spawn.c b/fs/pidfd_spawn.c
index 41d5cbb49a0f7..5586926988406 100644
--- a/fs/pidfd_spawn.c
+++ b/fs/pidfd_spawn.c
@@ -3,6 +3,8 @@
  * pidfd-backed process spawn builders
  */
 
+#include <asm/syscall.h>
+#include <linux/audit.h>
 #include <linux/completion.h>
 #include <linux/cred.h>
 #include <linux/file.h>
@@ -81,6 +83,8 @@ struct pidfd_spawn_state {
 	char *staged_path;
 	struct user_arg_ptr argv;
 	struct user_arg_ptr envp;
+	unsigned long audit_args[4];
+	int audit_syscall;
 	int result;
 	enum pidfd_spawn_status status;
 };
@@ -206,6 +210,8 @@ static void pidfd_spawn_drop_run_data(struct pidfd_spawn_state *state,
 	state->staged_path = NULL;
 	state->argv = native_arg(NULL);
 	state->envp = native_arg(NULL);
+	memset(state->audit_args, 0, sizeof(state->audit_args));
+	state->audit_syscall = 0;
 	state->result = result;
 	pidfd_spawn_set_status(state, PIDFD_SPAWN_SETUP_DONE);
 	mutex_unlock(&state->lock);
@@ -377,6 +383,22 @@ SYSCALL_DEFINE5(pidfd_config, int, fd, unsigned int, cmd,
 	return ret;
 }
 
+static void pidfd_spawn_save_audit_context(struct pidfd_spawn_state *state)
+{
+	struct pt_regs *regs = current_pt_regs();
+	unsigned long args[6];
+
+	syscall_get_arguments(current, regs, args);
+	state->audit_syscall = syscall_get_nr(current, regs);
+	memcpy(state->audit_args, args, sizeof(state->audit_args));
+}
+
+static void pidfd_spawn_audit_entry(struct pidfd_spawn_state *state)
+{
+	audit_pidfd_spawn_entry(state->audit_syscall, state->audit_args[0],
+				state->audit_args[1], state->audit_args[2],
+				state->audit_args[3]);
+}
 static void pidfd_spawn_finish_child(struct pidfd_spawn_state *state,
 				     struct filename *filename, int result)
 {
@@ -391,6 +413,7 @@ static void pidfd_spawn_child(struct callback_head *work)
 	struct filename *filename;
 	int ret;
 
+	pidfd_spawn_audit_entry(state);
 	filename = complete_getname(&state->filename);
 	if (IS_ERR(filename))
 		ret = PTR_ERR(filename);
@@ -403,9 +426,11 @@ static void pidfd_spawn_child(struct callback_head *work)
 
 	pidfd_spawn_finish_child(state, filename, ret);
 	if (ret) {
+		audit_pidfd_spawn_exit(0, ret);
 		pidfd_spawn_state_put(state);
 		do_group_exit(PIDFD_SPAWN_EXIT_FAILURE);
 	}
+	audit_pidfd_spawn_exit(1, 0);
 	pidfd_spawn_state_put(state);
 }
 
@@ -575,6 +600,7 @@ static int pidfd_spawn_start(struct file *file,
 		state->argv = pidfd_spawn_user_arg(kargs->argv);
 		state->envp = pidfd_spawn_user_arg(kargs->envp);
 		pidfd_spawn_set_status(state, PIDFD_SPAWN_STARTING);
+		pidfd_spawn_save_audit_context(state);
 		reinit_completion(&state->done);
 
 		task = pidfd_spawn_create_task(file, state, &clone_args);
@@ -584,6 +610,9 @@ static int pidfd_spawn_start(struct file *file,
 			INIT_DELAYED_FILENAME(&state->filename);
 			state->argv = native_arg(NULL);
 			state->envp = native_arg(NULL);
+			memset(state->audit_args, 0,
+			       sizeof(state->audit_args));
+			state->audit_syscall = 0;
 			state->result = 0;
 			pidfd_spawn_set_status(state,
 					       PIDFD_SPAWN_CONFIGURING);
-- 
2.52.0

