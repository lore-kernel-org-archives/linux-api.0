Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794957274;
	b=j5tmqfVc777tXWNH6im4xJZt8CxSt4BGn55x+2EqAlRdI5sWy22UW0zDynuYDPoLP4rq
	 9TiOngH4FcRY5ZC6r259reLOkn2QRMxmhnLD6+cJ4DdMTxoUKjAVrXKLCDgiVQr0BaEcZ
	 b0ChPex9HfuQn+yxop06iMnt9/KgBB89uyzLfF51UZhWSzpGmR568QYfPbPmvkLnxP4s5
	 d/wv8bWjUwbgIYfxa310zKBBC7BJ8qRK6QLohUxQO9kDLWGtwWInkUlCWh/alm4HGq1I9
	 mRQ1gwr3SeJZbMfAvQQl9H7pY04Fq+/0VT/jsu7TJSPm0C5WbATeUutqGjFIXXia/JQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794957274;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=SlzPffRgB/6gUqSBvb7zP1wBLoY8VjWDsPvdBt0XzKw=;
	b=WcVAA5EFFJxDOPWmCBdRQrD4vV45rOc/16S9u3wHXpEscUCiEn0eGlqYNJWN84PF2l3f
	 +R/Z72ZtURUEDjlvAV9eGSGLP9ygs9XSkCucaJyJbf+6VvdFzi/mLk/pJfjQ5R2lzCMTU
	 1rHHTbw6+xlBy6XnBpwwYU/Er+r8So3mqrOdp+TeruWYzm0OmpMUnlEhquD/r731rFS4b
	 WF7Zx2y88oX4LB/MCC9PdiKdPirYkK5Z37+KnJ0PVDKJhhVJlyA5TURMK/x8lmfFmUgJ+
	 6hxHUztEzoxWiRD8uWcfeQyQVkZ3oeu0AsL2pazyNPe3CEaurWTjp0+7YkgbGJ4bG+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DXjGpRQV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 5ECF2606A31C;
	Tue, 17 Nov 2026 23:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DXjGpRQV
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 42ABB1F000D4;
	Tue, 17 Nov 2026 23:14:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794957274;
	bh=SlzPffRgB/6gUqSBvb7zP1wBLoY8VjWDsPvdBt0XzKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DXjGpRQVnPgTfnjkyH/o1PjExJVbyZcqgliLVv8F9kk2R8UpR38v6/Qvsvt0RbrVr
	 sokfQ6Rl8CHQDA4838jsxJAxDc3e4nNzXnTWIk8pDGgcg78uWt2aljjL4K3+mcxqGr
	 gg5ymkfe5zPapllISsvjERekdfgml83D9eant9Cr/sdXtsD9HFoQWxqE+O/nJWMLKf
	 AvIMMjC8byZXL6C4SEp9x3yvMjYVzuoJWzNNUbo7qSnkKKZhbor/M3kFY+1hh8OqlN
	 PCP5T4m2BQBJxW2OTwXWvhGxqf8j1MMQtZJcGO8KYhvxeI7n0w0/0PWN/TPDLsiq5E
	 nkZ0Gmz9JI3dw==
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
	Andy Lutomirski <luto@amacapital.net>,
	Ben Segall <bsegall@google.com>,
	Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jan Kara <jack@suse.cz>,
	Jonathan Corbet <corbet@lwn.net>,
	John Johansen <john.johansen@canonical.com>,
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
	Vlastimil Babka <vbabka@kernel.org>,
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
Subject: [RFC PATCH v2 06/13] rootns: Add rootns_kill() system call
Date: Wed, 18 Nov 2026 01:13:45 +0200
Message-ID: <20261117231352.3816603-7-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261117231352.3816603-1-jarkko@kernel.org>
References: <20261117231352.3816603-1-jarkko@kernel.org>
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

Add the rootns_kill() system call to walk the root namespace's PID
namespace IDR under RCU and deliver a validated signal once to each
thread group, aggregating per-process delivery results.

Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 include/linux/syscalls.h |  1 +
 kernel/rootns.c          | 65 ++++++++++++++++++++++++++++++++++++++++
 kernel/sys_ni.c          |  1 +
 3 files changed, 67 insertions(+)

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
index 83ab759a31ec..90a070dbf4a8 100644
--- a/kernel/rootns.c
+++ b/kernel/rootns.c
@@ -21,6 +21,7 @@
 #include <linux/pid_namespace.h>
 #include <linux/user_namespace.h>
 #include <linux/compat.h>
+#include <linux/idr.h>
 #include <uapi/linux/rootns.h>
 
 /*
@@ -389,3 +390,67 @@ COMPAT_SYSCALL_DEFINE4(rootns_wait, int, rootnsfd,
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
+	if (READ_ONCE(rootns->state) != ROOTNS_RUNNING)
+		return -ESRCH;
+
+	scoped_guard(rcu) {
+		idr_for_each_entry(&pid_ns->idr, pid, nr) {
+			int err;
+
+			if (!pid_task(pid, PIDTYPE_TGID))
+				continue;
+
+			err = kill_pid(pid, sig, 0);
+			if (!err) {
+				any_success = true;
+			} else if (err == -EPERM) {
+				any_perm = true;
+			} else if (err != -ESRCH && !any_other) {
+				any_other = true;
+				other_err = err;
+			}
+		}
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
+ * Walk the target root namespace's PID namespace IDR under RCU and deliver
+ * @sig once to each member thread group.
+ *
+ * Return: 0 if at least one thread group was signaled, %-ESRCH if the rootns
+ * is not running or has no members, or negative error code on failure.
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

