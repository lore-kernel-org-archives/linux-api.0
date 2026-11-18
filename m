Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030572;
	b=oPgYTJksLZCsVc2A82ndygk1DbKWHtHd/Y4CuRP0K6ppQVioF1LXuglZbMTmYsHqa+R3
	 NzAAfbAvjo8L/bMF62gSoxacppTSMJtAy7/91bnfOK3OvY8TnB0BsfxpHluZ1pfGWxyP8
	 6u8MelyBety/HhxGZ1AEQZtj/Pm9a77JbCQ8kU7/q/3g1OcugfFz4Ra+G1mWysHnTar2A
	 8DS4gH0uSfGF4nCZuKBd6UT1wC730CzvZtw6cV5O0FBV2QwSCprp7VF1WVD0fOTCI01zG
	 rAH4esS+54eFlNZyOG+umIJdaPrPClD3Gz7WMJSLLxFxf5KK+7Zw67a9omR7m473cvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030572;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=yaA3ERKl4qIEc5biEQv6iu7eXMjtpeIqoYNmqvuQLqw=;
	b=3ZhiH1HRWjIPWp/A9bjw7ZfMIdZR53ZQNSR+z+gMCvX1twQ9Ub6+zlbtYqlcajryw7bP
	 E26zk2JOgHMQdm3/K5Ge/yyKW4chGpdwWPK1QnoubQ8cO5doe+IK+wyOiGFSgaBO4DQnv
	 NXdrDUrPhE0ZkiVIU+U3lbS19lDNtuxhEJuAFogiQBj9ySP3GzYNA34mE8ms0wiw5K270
	 uEz5jVpvrH/V7kR2+8wM9Y7MA8lyKYTwBNsD08YFMqeU3smiF+wPC7eebw6K9Kp3OQPHg
	 kzwiVU99Jkmy+++UpC6nkR9hai0WxYFRyNjx5sSQPAIHGtNm+Cy6bT0O2jRPzUQlb7g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=a2mNj0hN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id BE8B8606E7DD;
	Wed, 18 Nov 2026 19:36:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=a2mNj0hN
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id E82401F000C4;
	Wed, 18 Nov 2026 19:36:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795030572;
	bh=yaA3ERKl4qIEc5biEQv6iu7eXMjtpeIqoYNmqvuQLqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a2mNj0hNjg6sky+s8cpxmwPfl8llMXFT9DIOdQC0BES4dK4PITy4ph4FlC/J/qWgo
	 JBIN1np7dCzY1ashyhWLAiHNc8KP6eJaKabfMC3ItFJGWL5b67ChpvMKmdrtvfjQ+5
	 N+Gedj72owic4tpf+51aUCpzsfq5LqCqQT3QUez0LDshPO9tH3mszG1FHWj0dz1O1b
	 VH11s6YXVwECM3Jw1xKXnK5uZZK3juehV4PqfcSxvIRBM9fNdFjD8pyBl50J8wWSwC
	 i6coJCwGDh6wVMFqsH4OGw3M/r6f7Jr65737mZjv/8G2gslCGV0KE3c43dCJCfzcAa
	 Rr42I3tbibb6Q==
From: Jarkko Sakkinen <jarkko@kernel.org>
To: David Howells <dhowells@redhat.com>
Cc: Jarkko Sakkinen <jarkko@kernel.org>,
	linux-api@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@amacapital.net>,
	Anna-Maria Behnsen <anna-maria@linutronix.de>,
	Ben Segall <bsegall@google.com>,
	Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Jan Kara <jack@suse.cz>,
	John Johansen <john.johansen@canonical.com>,
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
	Thomas Gleixner <tglx@kernel.org>,
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
Subject: [RFC PATCH v3 06/13] rootns: Add rootns_kill() system call
Date: Wed, 18 Nov 2026 21:35:32 +0200
Message-ID: <20261118193539.240065-7-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261118193539.240065-1-jarkko@kernel.org>
References: <20261118193539.240065-1-jarkko@kernel.org>
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

Signaling every process inside a container from userspace via /proc is
racy against concurrent fork() calls.

Add the rootns_kill() system call to require an ancestor active PID
namespace, walk the root namespace's PID namespace IDR under
tasklist_lock, and deliver a validated signal once to each thread group
including in-flight forks, aggregating per-process delivery results.

Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 include/linux/syscalls.h |  1 +
 kernel/rootns.c          | 71 ++++++++++++++++++++++++++++++++++++++++
 kernel/sys_ni.c          |  1 +
 3 files changed, 73 insertions(+)

diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 60e9c4ff71e7..a854d248c8a3 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -1009,6 +1009,7 @@ asmlinkage long sys_lsm_list_modules(u64 __user *ids, u32 __user *size, u32 flag
 asmlinkage long sys_rootns_create(unsigned int flags);
 asmlinkage long sys_rootns_wait(int rootnsfd, int __user *status,
 				unsigned int options, struct rusage __user *ru);
+asmlinkage long sys_rootns_kill(int rootnsfd, int sig);
 
 /*
  * Architecture-specific system calls
diff --git a/kernel/rootns.c b/kernel/rootns.c
index 5582ff010ca5..32bb8ef5ed58 100644
--- a/kernel/rootns.c
+++ b/kernel/rootns.c
@@ -408,3 +408,74 @@ COMPAT_SYSCALL_DEFINE4(rootns_wait, int, rootnsfd,
 	return ret;
 }
 #endif
+
+static int rootns_kill_members(struct rootns *rootns, int sig)
+{
+	struct pid_namespace *pid_ns = rootns->ns->pid_ns_for_children;
+	bool any_success = false;
+	bool any_other = false;
+	bool any_perm = false;
+	int other_err = 0;
+	struct pid *pid;
+	int nr;
+
+	if (!pidns_is_ancestor(pid_ns, task_active_pid_ns(current)))
+		return -EXDEV;
+	if (READ_ONCE(rootns->state) != ROOTNS_RUNNING)
+		return -ESRCH;
+
+	scoped_guard(rcu) {
+		read_lock(&tasklist_lock);
+		idr_for_each_entry(&pid_ns->idr, pid, nr) {
+			struct task_struct *task = pid_task(pid, PIDTYPE_TGID);
+			int err;
+
+			if (!task)
+				continue;
+
+			err = group_send_sig_info(sig, SEND_SIG_NOINFO, task,
+						  PIDTYPE_MAX);
+			if (!err) {
+				any_success = true;
+			} else if (err == -EPERM) {
+				any_perm = true;
+			} else if (err != -ESRCH && !any_other) {
+				any_other = true;
+				other_err = err;
+			}
+		}
+		read_unlock(&tasklist_lock);
+	}
+
+	if (any_success)
+		return 0;
+	if (any_other)
+		return other_err;
+	if (any_perm)
+		return -EPERM;
+	return -ESRCH;
+}
+
+/**
+ * sys_rootns_kill - Send a signal to all thread groups in a root namespace
+ * @rootnsfd: Root namespace control file descriptor
+ * @sig: Signal number to deliver (or 0 for permission check)
+ *
+ * Walk the target root namespace's PID namespace IDR under ``tasklist_lock``
+ * and deliver @sig once to each member thread group.
+ *
+ * Return: 0 if at least one thread group was signaled, %-EXDEV if the caller's
+ * active PID namespace is not an ancestor, %-ESRCH if the rootns is not
+ * running or has no members, or negative error code on failure.
+ */
+SYSCALL_DEFINE2(rootns_kill, int, rootnsfd, int, sig)
+{
+	CLASS(fd, f)(rootnsfd);
+
+	if (fd_empty(f))
+		return -EBADF;
+	if (!is_rootns_file(fd_file(f)) || !valid_signal(sig))
+		return -EINVAL;
+
+	return rootns_kill_members(fd_file(f)->private_data, sig);
+}
diff --git a/kernel/sys_ni.c b/kernel/sys_ni.c
index f9918d38107b..fba44c49ddbb 100644
--- a/kernel/sys_ni.c
+++ b/kernel/sys_ni.c
@@ -403,3 +403,4 @@ COND_SYSCALL(uprobe);
 COND_SYSCALL(rootns_create);
 COND_SYSCALL(rootns_wait);
 COND_SYSCALL_COMPAT(rootns_wait);
+COND_SYSCALL(rootns_kill);
-- 
2.47.3

