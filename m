Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794892153;
	b=Nsew4ajiYhLDxibgDIAsMfbzOIAgGQuw8r2Nhn0u0jghct/fqOHo8vQ5lWRB9oowP+ZD
	 3BTlEkSp9dgELw8dzEU1dXeajHHe7N3EpQ2viMvLXhpRmN6dzKhYtrgCPNF3X0ZB0T8GJ
	 Dz0PeeY5kq4XEuoefB1ODlBvlJwERTjNEXiJLeFE3K6i+akhzi7HbXi9mX7u3Fq95JY+q
	 GZmhjZ4RVuylq1pXCekG0f+hwwB1GbimK6QHlqKT7/Mx/MimFvh+dUOYAMLf3N/6CWuED
	 bv0rEfpo8nuKdxzemSitrv2+smIT4iZc9ZPVUqOHibUBbUgLJloddr6482sT/MMwkFQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794892153;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=8Kp2fiMZBMHreKa6yBm1C7kAqEfoSCeSULw1o1rg90g=;
	b=jf38jI13oIMXX8RKy0+YGZQyfLAfB1PPrqgeCx/Ri4DMSOyASCIhaAyp5h0jIS18Ui06
	 up9roKTPaC7+OqwmA16CGMyI9V5kyh8UquPu6kC0AlHlvf78K/A0VXEYAG4bet9Dyqv4P
	 ru74Zl0Vx2+iHG9M1Y8i8QL1F3EO7E0GlteuRuw3fX1V7YYJ5Yvg/uHNt1//Z5MngO1ON
	 DJ2BNK2d/qKxEh+iuaY6QXXeF2vThdy2HmPZTd0u4DTEiZ1vaqdGeNbyojahLeQABU+wl
	 x8aqSZtwvwq3Nih62pt3MqOH5NFIlxELDV3qQyGUUw+xXv6J+T2Wdh+ZEmW+7VsU/bw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SUrP14Sr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 402A2606A32A;
	Tue, 17 Nov 2026 05:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SUrP14Sr
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 246491F000C8;
	Tue, 17 Nov 2026 05:09:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794892152;
	bh=8Kp2fiMZBMHreKa6yBm1C7kAqEfoSCeSULw1o1rg90g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SUrP14SrTNoPVLYZKQ0CMdB5XademuzFki46MqB89BxmypSZtR9xR4zst1ho7zzKq
	 g3Z+xSOYSk5q3+fjMJOmfqvnbE2sdTuAEAbuGxGigYai9tDuMwTBfimmRgWsgOjVzu
	 s/q7SJBmPzfXdGo6aZVjbMD7yMEFzxAK9PbqOu/NxQ++GxzNYgwxCuPaTne5cL/OD/
	 DstCwgqPWyQ/DBWJHWVNbPkR3RW4knP/6GAS6RxlkfgDMJ8YaDhtTWzEdm6aL39oAV
	 sgpg27SV2djHLcKluQH9HlSfcShvKawPb7crhwdJ09wwjpvsq/5PDm1zDei56K2bCr
	 WFTo7qI+SKjbQ==
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
Subject: [RFC PATCH 06/13] rootns: Add rootns_kill() system call
Date: Tue, 17 Nov 2026 07:08:34 +0200
Message-ID: <20261117050841.3289652-7-jarkko@kernel.org>
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
index 8a1254db69df..f59b2fe9910d 100644
--- a/kernel/rootns.c
+++ b/kernel/rootns.c
@@ -21,6 +21,7 @@
 #include <linux/pid_namespace.h>
 #include <linux/user_namespace.h>
 #include <linux/compat.h>
+#include <linux/idr.h>
 #include <uapi/linux/rootns.h>
 
 /*
@@ -390,3 +391,67 @@ COMPAT_SYSCALL_DEFINE4(rootns_wait, int, rootnsfd,
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

