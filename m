Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794892150;
	b=y4XzJPyVwv8gU9A6XZZodrwh5aUF3W1gsBF++mcdKTiz7qlLmsr4z61cvxaNjWH7KtCF
	 Sg3O9GLPotSj0ByBE95VIwWSlaxPMfoXMvbhVR4sZpD0C8Q5OFoJss0bHGyPus7Vzj0gl
	 OU/cHAkLZPuBK6ifLAYsZD5yKZ8Vwm+pyhbpcr2SdayJu68VW5OiSsY4+yqyaVOnTAgfg
	 eWMEutLCUVJGO+CNI9oRom+MuBCYn67/+5ApXskx/fNbOR6uHkI9mXEFnLPmVMXWlusUS
	 wXj8WT0eHzj22SjSJt6EuuRo8epkLFQsBtwhNsRxZSi5CszuXkKjHpGu5aJ0MBWbACw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794892150;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=/j07RVXchf3zhK6LorIENxE4Qf7U0RuxmVpxnAnY7Mw=;
	b=0rSsnhF9In6aoC1/alqTENwmN411BlEmCLDz2IQKgXdvDAUVSK6gffbiqL+fwBOW8DOu
	 gxQjFn0mINyNQa9Hwlpir77OrBlbTuzi58ClpNfEft4Q9VITB4NVqExlel5kCYuSc0GSc
	 i0lYmbSZwverTKnWNDqTDlq0NLD3D8/RR0zhBipUBl/t4wIxrlHbToJ45/8o+zKpytUcw
	 4GGGTVIx7dHJ6tfHMRdKl82urrGlGVuorgOo3K748toqfbQIIzIVotb65tP+Lkxpoddhp
	 Z4LDWYsJ2m1TmcCzHVV/yxUQyINjD17wNZJmVfq8nbG3qQU+i9ZH7he9SeIldo7AdUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=E13Saay9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 21FE1606A323;
	Tue, 17 Nov 2026 05:09:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=E13Saay9
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 42F4B1F000C8;
	Tue, 17 Nov 2026 05:09:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794892148;
	bh=/j07RVXchf3zhK6LorIENxE4Qf7U0RuxmVpxnAnY7Mw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E13Saay9ThoYFiymvEwJcCX5YkI+DCERwN9bZxoLWB5HdazaYM2s1VJ6hh4V+oxB7
	 IO0dRERPUmvs0kVHCzcJZnv4D7kC9DDwhLtQTTdrvB7t/gBVXECUn5UGQLlWwRrJk6
	 n+Fcmfoh4KpoTJ5AxaPB5ElljV9E4QjuZVprztgFSzVxSaLjn/ooZTgY0D/kos3fPf
	 HeBlYNLGNGEfRdDchqh+7FIfU66cdF3f9bPRdYBLRNPHcfOM+4QQicDkHQVTCh2REK
	 3a75eoa976apspQ1C+yWfRjr65k58xrR2n1PjYAXCK0M6tiK+dSaSiIPkU51ZgLzQ+
	 7rU2wT6wuMP7g==
From: Jarkko Sakkinen <jarkko@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Jarkko Sakkinen <jarkko@kernel.org>,
	linux-api@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ben Segall <bsegall@google.com>,
	Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jan Kara <jack@suse.cz>,
	Jonathan Corbet <corbet@lwn.net>,
	Juri Lelli <juri.lelli@redhat.com>,
	Kees Cook <kees@kernel.org>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Manfred Spraul <manfred@colorfullife.com>,
	Mel Gorman <mgorman@suse.de>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Neal Gompa <neal@gompa.dev>,
	Paul Moore <paul@paul-moore.com>,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Serge Hallyn <sergeh@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vlastimil Babka <vbabka@kernel.org>
Subject: [RFC PATCH 05/13] rootns: Add rootns_wait() system call
Date: Tue, 17 Nov 2026 07:08:33 +0200
Message-ID: <20261117050841.3289652-6-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261117050841.3289652-1-jarkko@kernel.org>
References: <20261117050841.3289652-1-jarkko@kernel.org>
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

wait4() and waitid() only allow a parent or subreaper to collect exit
status, so an external manager holding a rootns file descriptor cannot
wait on a rootns init process forked by another process or observe exit
status multiple times across observers.

Add the rootns_wait() system call and its compat entry point to wait on
a rootns file descriptor until its init thread group exits and report
the recorded wait status and rusage. Return the init TGID translated
into the caller's active PID namespace, 0 for WNOHANG while still
running, or -ECHILD when the PID is not visible to the caller.

Co-developed-by: David Howells <dhowells@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 include/linux/compat.h   |   4 ++
 include/linux/syscalls.h |   2 +
 kernel/rootns.c          | 105 +++++++++++++++++++++++++++++++++++++++
 kernel/sys_ni.c          |   2 +
 4 files changed, 113 insertions(+)

diff --git a/include/linux/compat.h b/include/linux/compat.h
index ad37ca617e65..3a9ac9dbb24c 100644
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -779,6 +779,10 @@ asmlinkage long compat_sys_recvmmsg_time32(int fd, struct compat_mmsghdr __user
 asmlinkage long compat_sys_wait4(compat_pid_t pid,
 				 compat_uint_t __user *stat_addr, int options,
 				 struct compat_rusage __user *ru);
+asmlinkage long compat_sys_rootns_wait(int rootnsfd,
+				       compat_int_t __user *status,
+				       unsigned int options,
+				       struct compat_rusage __user *ru);
 asmlinkage long compat_sys_fanotify_mark(int, unsigned int, __u32, __u32,
 					    int, const char __user *);
 asmlinkage long compat_sys_open_by_handle_at(int mountdirfd,
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 272d54bddbe2..60e9c4ff71e7 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -1007,6 +1007,8 @@ asmlinkage long sys_lsm_set_self_attr(unsigned int attr, struct lsm_ctx __user *
 				      u32 size, u32 flags);
 asmlinkage long sys_lsm_list_modules(u64 __user *ids, u32 __user *size, u32 flags);
 asmlinkage long sys_rootns_create(unsigned int flags);
+asmlinkage long sys_rootns_wait(int rootnsfd, int __user *status,
+				unsigned int options, struct rusage __user *ru);
 
 /*
  * Architecture-specific system calls
diff --git a/kernel/rootns.c b/kernel/rootns.c
index 904d75ce9d90..8a1254db69df 100644
--- a/kernel/rootns.c
+++ b/kernel/rootns.c
@@ -5,6 +5,8 @@
 
 #include <linux/poll.h>
 #include <linux/wait.h>
+#include <uapi/linux/wait.h>
+#include <linux/file.h>
 #include <linux/fs.h>
 #include <linux/anon_inodes.h>
 #include <linux/rootns.h>
@@ -285,3 +287,106 @@ SYSCALL_DEFINE1(rootns_create, unsigned int, flags)
 
 	return fd;
 }
+
+/*
+ * Wait for rootns init to exit and report results for the caller.
+ *
+ * Returns caller-visible init TGID on success, 0 for WNOHANG when still
+ * running, and -ECHILD when init pid is not visible in caller pidns.
+ */
+static long rootns_wait_common(int rootnsfd, unsigned int options,
+			       int *status, struct rusage *ru)
+{
+	CLASS(fd, f)(rootnsfd);
+	struct pid_namespace *pid_ns = task_active_pid_ns(current);
+	struct rootns *rootns;
+	long ret;
+
+	if (fd_empty(f))
+		return -EBADF;
+	if (!is_rootns_file(fd_file(f)) || (options & ~WNOHANG))
+		return -EINVAL;
+
+	rootns = fd_file(f)->private_data;
+	if (!(options & WNOHANG)) {
+		ret = wait_event_killable(rootns->waitq,
+					  READ_ONCE(rootns->state) == ROOTNS_DEAD);
+		if (ret)
+			return ret;
+	}
+
+	scoped_guard(spinlock, &rootns->lock) {
+		if (rootns->state != ROOTNS_DEAD)
+			return 0;
+		if (!rootns->init_pid)
+			return -ECHILD;
+		ret = pid_nr_ns(rootns->init_pid, pid_ns);
+		if (ret <= 0)
+			return -ECHILD;
+		if (status)
+			*status = rootns->exit_code;
+		if (ru)
+			*ru = rootns->rusage;
+	}
+
+	return ret;
+}
+
+/**
+ * sys_rootns_wait - Wait for root namespace termination and collect init status
+ * @rootnsfd: Root namespace control file descriptor
+ * @status: Optional user pointer to receive wait status of init
+ * @options: Wait options (0 or %WNOHANG)
+ * @ru: Optional user pointer to receive resource usage of init
+ *
+ * Wait killably (unless %WNOHANG is set in @options) until @rootnsfd reaches
+ * %ROOTNS_DEAD, then copy out the recorded exit status and resource usage of
+ * the rootns init thread group.
+ *
+ * Return: Caller-visible init TGID on success, 0 if %WNOHANG is set and the
+ * rootns has not terminated, %-ECHILD if init was never started or is not
+ * visible in the caller's active PID namespace, or negative error code.
+ */
+SYSCALL_DEFINE4(rootns_wait, int, rootnsfd, int __user *, status,
+		unsigned int, options, struct rusage __user *, ru)
+{
+	int code;
+	long ret;
+	struct rusage rusage;
+
+	ret = rootns_wait_common(rootnsfd, options,
+				 status ? &code : NULL,
+				 ru ? &rusage : NULL);
+	if (ret <= 0)
+		return ret;
+
+	if (status && put_user(code, status))
+		return -EFAULT;
+	if (ru && copy_to_user(ru, &rusage, sizeof(rusage)))
+		return -EFAULT;
+	return ret;
+}
+
+#ifdef CONFIG_COMPAT
+COMPAT_SYSCALL_DEFINE4(rootns_wait, int, rootnsfd,
+		       compat_int_t __user *, status,
+		       unsigned int, options,
+		       struct compat_rusage __user *, ru)
+{
+	int code;
+	long ret;
+	struct rusage rusage;
+
+	ret = rootns_wait_common(rootnsfd, options,
+				 status ? &code : NULL,
+				 ru ? &rusage : NULL);
+	if (ret <= 0)
+		return ret;
+
+	if (status && put_user(code, status))
+		return -EFAULT;
+	if (ru && put_compat_rusage(&rusage, ru))
+		return -EFAULT;
+	return ret;
+}
+#endif
diff --git a/kernel/sys_ni.c b/kernel/sys_ni.c
index 4a6c4337cc74..f9918d38107b 100644
--- a/kernel/sys_ni.c
+++ b/kernel/sys_ni.c
@@ -401,3 +401,5 @@ COND_SYSCALL(uprobe);
 
 /* kernel/rootns.c */
 COND_SYSCALL(rootns_create);
+COND_SYSCALL(rootns_wait);
+COND_SYSCALL_COMPAT(rootns_wait);
-- 
2.47.3

