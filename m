Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4340E324B06;
	Thu, 16 Jul 2026 14:36:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212612; cv=pass; b=LQ8tVPJu4MX2U31lJhcTJBqq3F9AHi/DH6AUpv06kfllhaVZUgO+XZ3Px3nnESpgCJiGAnmyjTqIoimBXL0pyPWjmWoFUdxQ/aUDYmdzJ7gIAeYKDAWsbPx9E/x9C3F1JJoJFcx1xUwkpHUHpA0wBXUINJW6aEHn888M/xD4ImE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212612; c=relaxed/simple;
	bh=gNIdL9utBeA1Pu407ECCViJPyXb4rWdhO5eR9F/wo2s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L1pGbaLCbG1hehUTdPHIBJNLRoxEVr5Na164qcwOjjWKfBerga4HlCktqvAwD13Nxj1wEWV4E2suMACGmkRdK9evgGeft0ZWj74Y9VBTbLk+lFEzuYehuCD1mtS7nV+PuRJj3+hiorXkujCeYZPIEtLIHg423cSyhNVIhlRwbZA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=MxkEnFl7; arc=pass smtp.client-ip=136.143.188.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="MxkEnFl7"
ARC-Seal: i=1; a=rsa-sha256; t=1784212403; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=dMV9ZN1HA5HIBvY4+WV4YpiNJFU3cvQjedrufXW1PYD+fjRhIzE1dZfMAM3bdTLIoKSMyAcGdOc8C1mbDETJORaIOoaiFXJsTJExVmYIdldJgYYgPJqW9xMAmz9H8VCR9beMpQXu2HapXvo9Ka38/rg++NrvrwsvKZ94HsrGPlw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1784212403; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=yb6Cwm/3woTUAoheO4z7KKKAu6lXR9oCBGtztGfVAug=; 
	b=cfYMuO7L2esHwoKyzWcFcEY0/CiF/Pq+Qv68PEy+L77nPyCCoulRNcQfY9Y086LvBx6Xemug3ccOfPEuKi/SdUJdiJFIKi7XxoO31q9fV8VtmoEaWMSJNwLGkuB9ckQwWSuPnCXy1pXRrYkAC7G/uQq2i5Bp/ZmLiYdDcRBJV7s=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1784212403;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=yb6Cwm/3woTUAoheO4z7KKKAu6lXR9oCBGtztGfVAug=;
	b=MxkEnFl7cfoArhzoENi4PknhrlsAuitJVyM04IyV0ygMcamDMbtLCiPRIyNRQoZY
	K0Q623GvfSSRvYsApqZ4muOcfMJSRvYdjMO04lveUVm1vCLLQHqtueHI6PYucgfKhwz
	IklWLzpodiO2DFjS+MApJH6Ofa/OyqiAGXs7O+jQ=
Received: by mx.zohomail.com with SMTPS id 1784212400577476.8024498506385;
	Thu, 16 Jul 2026 07:33:20 -0700 (PDT)
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
Subject: [RFC PATCH 07/24] fork: expose vfork completion helper
Date: Thu, 16 Jul 2026 22:31:33 +0800
Message-ID: <daf1064397a3f3ccd11f65f07683edf493e4a435.1784204592.git.me@linux.beauty>
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

Allow process builders that call copy_process() directly to attach and
wait for the existing vfork completion without duplicating its signal
and task-reference handling.

Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Li Chen <me@linux.beauty>
---
 include/linux/sched/task.h | 3 +++
 kernel/fork.c              | 3 +--
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/linux/sched/task.h b/include/linux/sched/task.h
index e0c1ca8c6a188..92b4e3bc31e66 100644
--- a/include/linux/sched/task.h
+++ b/include/linux/sched/task.h
@@ -14,6 +14,7 @@
 
 struct task_struct;
 struct rusage;
+struct completion;
 union thread_union;
 struct css_set;
 
@@ -99,6 +100,8 @@ extern void exit_itimers(struct task_struct *);
 extern pid_t kernel_clone(struct kernel_clone_args *kargs);
 struct task_struct *copy_process(struct pid *pid, int trace, int node,
 				 struct kernel_clone_args *args);
+int wait_for_vfork_done(struct task_struct *child,
+			struct completion *vfork);
 struct task_struct *create_io_thread(int (*fn)(void *), void *arg, int node);
 struct task_struct *fork_idle(int);
 extern pid_t kernel_thread(int (*fn)(void *), void *arg, const char *name,
diff --git a/kernel/fork.c b/kernel/fork.c
index f3f378a85be4c..970810a01bbf6 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1435,8 +1435,7 @@ static void complete_vfork_done(struct task_struct *tsk)
 	task_unlock(tsk);
 }
 
-static int wait_for_vfork_done(struct task_struct *child,
-				struct completion *vfork)
+int wait_for_vfork_done(struct task_struct *child, struct completion *vfork)
 {
 	unsigned int state = TASK_KILLABLE|TASK_FREEZABLE;
 	int killed;
-- 
2.52.0

