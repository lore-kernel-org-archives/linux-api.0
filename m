Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A559633C194;
	Thu, 16 Jul 2026 14:40:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212807; cv=pass; b=XipZTaZ1/OprfeEgqv+OWogNtayl712m+CKqzMwd8Z8xCIY1OzL+qtZ8Ghp016eZE3rjBywKRGIJ01V0kktW9iHxfelpNzMKUP5WcBA+IENVN65dVK2uMVzyw0lM5yyZT76QTNnxxCujZMVzLL2/O1fN1jxivcl30hWuujEs2Hg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212807; c=relaxed/simple;
	bh=mF5J9psbQfP8jUVleGHj/StkoANu/5N4LChUnn1C02M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LzYhwFahalJh/yZv5+ShRJk+M5p90exMlL56rhB5M/xyM+mFe6r4/ieLfZ6jMQtyLjtTbxM6Jbn96cQoso7YV0vHJoHjXCawLQNchSzCJifSsWOnKXHfaaZKRFxHQ+czLhY8YNJ6KFG/oQfMQdWDq3/6xUutKJBJTk8V3xxxn7o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=lUOjiNEA; arc=pass smtp.client-ip=136.143.188.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="lUOjiNEA"
ARC-Seal: i=1; a=rsa-sha256; t=1784212462; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=NL5sCBLc0dzSrKk0ctGJxf6xVg7GcEWBWgOTLSiTytPv37cluDJagT9/MuM7186bcBLQyxsMrZpgqVPNe4mklAJqFEnAdRUUFcpSdIUGii0q0NYX5EMysk44mKrtPcpV6J5v5bOOKb3lt5R5j6tE3j8XuGgy9EQ0NRN8NH0536U=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1784212462; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=arLEymkUVoitQLqfzvX2ap3GpzLfAGuJIPCpZdsJGXY=; 
	b=KUm1VnpBfYK9SXe+mGXg+Qn3vvLnCACE1XIX1crfmJzmqMUW3W3kke8dmBu/5FgSSNZGJ+nnJeQGSvPpeGrbYMcfStJDCn8NpVIvbrf/PjixfByOh6h3ALtCxOttShGaOfhKoLRNQR/rjCBu2u3xguFN0yW2+Yd+D2LbnbxboN8=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1784212462;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=arLEymkUVoitQLqfzvX2ap3GpzLfAGuJIPCpZdsJGXY=;
	b=lUOjiNEAs6gVFsKJ7ywvKHQj6bgQShhP9SBhiAd2VMu3l7Ql7s3RfxW1DptBI0CP
	49ibTx/3SwuBWhvFvcqhWYc+mdU7WGi1PfJOzrBX8g9dP1KfROPORzf+n0VoF5T/xAB
	ZXtnxpMJqC6Zlzdxg3QescLRlZH2IuiCV70W7H3E=
Received: by mx.zohomail.com with SMTPS id 17842124595011012.3223632220755;
	Thu, 16 Jul 2026 07:34:19 -0700 (PDT)
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
Subject: [RFC PATCH 13/24] fork: let new tasks start with task work
Date: Thu, 16 Jul 2026 22:31:39 +0800
Message-ID: <6a841a3d1ca2e4c5dfeccf1863d4e07290d33351.1784204592.git.me@linux.beauty>
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

Process builders need to run setup in the child before its first return
to userspace without storing a kernel callback in architecture-specific
saved registers.

Allow an internal clone caller to supply task work. Queue it after the
last ordinary fork failure check, while the child is still TASK_NEW. A
NULL work pointer leaves existing clone callers unchanged.

Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Li Chen <me@linux.beauty>
---
 include/linux/sched/task.h | 2 ++
 kernel/fork.c              | 6 ++++++
 2 files changed, 8 insertions(+)

diff --git a/include/linux/sched/task.h b/include/linux/sched/task.h
index 5b7facf12b33b..830de99aabaed 100644
--- a/include/linux/sched/task.h
+++ b/include/linux/sched/task.h
@@ -43,6 +43,8 @@ struct kernel_clone_args {
 	int idle;
 	int (*fn)(void *);
 	void *fn_arg;
+	/* Run before the new task first returns to userspace. */
+	struct callback_head *task_work;
 	struct cgroup *cgrp;
 	struct css_set *cset;
 	bool embryonic_exec;
diff --git a/kernel/fork.c b/kernel/fork.c
index e3ade83b2d4e2..c0584eaa74711 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -109,6 +109,7 @@
 #include <uapi/linux/pidfd.h>
 #include <linux/pidfs.h>
 #include <linux/tick.h>
+#include <linux/task_work.h>
 #include <linux/unwind_deferred.h>
 #include <linux/pgalloc.h>
 #include <linux/uaccess.h>
@@ -2504,6 +2505,11 @@ __latent_entropy struct task_struct *copy_process(
 		retval = -EINTR;
 		goto bad_fork_core_free;
 	}
+	if (args->task_work) {
+		retval = task_work_add(p, args->task_work, TWA_RESUME);
+		if (WARN_ON_ONCE(retval))
+			goto bad_fork_core_free;
+	}
 
 	/* No more failure paths after this point. */
 
-- 
2.52.0

