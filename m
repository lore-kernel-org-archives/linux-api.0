Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80FD9417D8D;
	Fri, 17 Jul 2026 13:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.97.179.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784296529; cv=none; b=X66kHBEBhWA6zUO98nb7woSnYRyYqFxD5FsyYImmNv1n2lQ5wWwgViWX2nJ5iTV86UMZLr8v3NqHkWOE95E7FkeWkxuYLikwqdTjqytS6QXIaqIYtgr137ChLskCFYgO4T+70Tb+JNmoWnryecKd6Yz5/jKbWi+NYRMKlqyrYW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784296529; c=relaxed/simple;
	bh=VFd1bNoj3SZ1Rqf2HIQlit76v3FPDsvh++/o0emys20=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=LJp5Jb9SyiEwBtZEGv/5BY/3VNXN/JISPc6cfvy4Brx/ATsLYZjC3uHf3r+NqKIKp04S9RhH7+E8exjAgIpV9O7W4xAOZzbOlzSUu2JZBURz1jccevmZQdiUdU6fgxKCajBNZcHQkXqqCnHt0C7xqMOTuqKxVRUB2jZ2oPEgQ78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com; spf=pass smtp.mailfrom=igalia.com; dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.b=S838Ccto; arc=none smtp.client-ip=213.97.179.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=igalia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.b="S838Ccto"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Cc:To:Message-Id:Content-Transfer-Encoding:Content-Type:
	MIME-Version:Subject:Date:From:From:Reply-To;
	bh=npwCtp/b+xCXE/6K8LMFhJD3vd/LJ/ptWlLY3x80Hbs=; b=S838CctoEfAe6RVXtXUp6bV6BP
	B4X8wEMhDQDbgPgSDvzdxRt5gAOeE5DkhZnLnsH8e0qQhMa33dUD2LzZVqv+HJvBaWZU/K7tQ2M+z
	S2fonEjbQjT5kkae6IhrdowOHhg4fcyLvDEqPfBLMxaG4b7H8PRkCHFPdQ3N7OI+HDg3Yhbas2iI9
	c3VH7ZLwBAJGV5l+f/vcgoUnveRRBluPqq+IHAy9rQ1PhrXFByiedwMbK62eBu2pFuILe5uTKjg7a
	19ngUTN16RCYAwQjymRuSxX35Kxcjc8lflX9WuMXQe+LYsc13oLZdNGv0z1382XE5YgN7X/5fvs4z
	p732RU1Q==;
Received: from [179.118.191.219] (helo=[192.168.15.100])
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1wkj25-00GXeM-Gq; Fri, 17 Jul 2026 15:55:17 +0200
From: =?utf-8?q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
Date: Fri, 17 Jul 2026 10:54:37 -0300
Subject: [PATCH v4 4/6] sched: Extend task command name with
 TASK_COMM_EXT_LEN
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260717-tonyk-long_name-v4-4-1fedfc870d21@igalia.com>
References: <20260717-tonyk-long_name-v4-0-1fedfc870d21@igalia.com>
In-Reply-To: <20260717-tonyk-long_name-v4-0-1fedfc870d21@igalia.com>
To: Peter Zijlstra <peterz@infradead.org>, 
 Juri Lelli <juri.lelli@redhat.com>, 
 Vincent Guittot <vincent.guittot@linaro.org>, 
 Steven Rostedt <rostedt@goodmis.org>, 
 Christian Brauner <brauner@kernel.org>, Kees Cook <kees@kernel.org>, 
 Shuah Khan <shuah@kernel.org>, willy@infradead.org, 
 mathieu.desnoyers@efficios.com, David Laight <david.laight.linux@gmail.com>, 
 Linus Torvalds <torvalds@linux-foundation.org>, akpm@linux-foundation.org, 
 Yafang Shao <laoar.shao@gmail.com>, andrii.nakryiko@gmail.com, 
 arnaldo.melo@gmail.com, Petr Mladek <pmladek@suse.com>
Cc: linux-kernel@vger.kernel.org, kernel-dev@igalia.com, linux-mm@kvack.org, 
 linux-api@vger.kernel.org, 
 =?utf-8?q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
X-Mailer: b4 0.15.2

Command name has been restrict to only 16 bytes, which is too limiting,
specially when debugging and tracing complex software with thousands of
threads and the need to differentiate them.

Just as it was done with kthreads in commit 6b59808bfe48 ("workqueue:
Show the latest workqueue name in /proc/PID/{comm,stat,status}"), support
long names for userspace threads as well.

To avoid buffer overflows, cap all existing userspace APIs to
TASK_COMM_LEN, and leave the full extended name for a new interface.

Signed-off-by: André Almeida <andrealmeid@igalia.com>
---
 fs/proc/array.c          |  2 +-
 include/linux/sched.h    |  3 ++-
 kernel/sys.c             | 10 +++++-----
 lib/tests/string_kunit.c |  2 +-
 4 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/fs/proc/array.c b/fs/proc/array.c
index 905d910b598f..0490b9ef2788 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -110,7 +110,7 @@ void proc_task_name(struct seq_file *m, struct task_struct *p, bool escape)
 	else if (p->flags & PF_KTHREAD)
 		get_kthread_comm(tcomm, sizeof(tcomm), p);
 	else
-		strscpy_pad(tcomm, p->comm);
+		strscpy_pad(tcomm, p->comm, TASK_COMM_LEN);
 
 	if (escape)
 		seq_escape_str(m, tcomm, ESCAPE_SPACE | ESCAPE_SPECIAL, "\n\\");
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 9b6a413f6618..6a48517f01cc 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -323,6 +323,7 @@ struct user_event_mm;
  */
 enum {
 	TASK_COMM_LEN = 16,
+	TASK_COMM_EXT_LEN = 64,
 };
 
 extern void sched_tick(void);
@@ -1178,7 +1179,7 @@ struct task_struct {
 	 * - set it with set_task_comm() to ensure it is always
 	 *   NUL-terminated and zero-padded
 	 */
-	char				comm[TASK_COMM_LEN];
+	char				comm[TASK_COMM_EXT_LEN];
 
 	struct nameidata		*nameidata;
 
diff --git a/kernel/sys.c b/kernel/sys.c
index 74c22d6dded0..3c37b5c1c072 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -2535,7 +2535,7 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 		unsigned long, arg4, unsigned long, arg5)
 {
 	struct task_struct *me = current;
-	unsigned char comm[sizeof(me->comm)];
+	unsigned char comm[TASK_COMM_LEN];
 	long error;
 
 	error = security_task_prctl(option, arg2, arg3, arg4, arg5);
@@ -2601,16 +2601,16 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 			error = -EINVAL;
 		break;
 	case PR_SET_NAME:
-		comm[sizeof(me->comm) - 1] = 0;
+		comm[TASK_COMM_LEN - 1] = 0;
 		if (strncpy_from_user(comm, (char __user *)arg2,
-				      sizeof(me->comm) - 1) < 0)
+				      TASK_COMM_LEN - 1) < 0)
 			return -EFAULT;
 		set_task_comm(me, comm);
 		proc_comm_connector(me);
 		break;
 	case PR_GET_NAME:
-		strscpy_pad(comm, me->comm);
-		if (copy_to_user((char __user *)arg2, comm, sizeof(comm)))
+		strscpy_pad(comm, me->comm, TASK_COMM_LEN);
+		if (copy_to_user((char __user *)arg2, comm, TASK_COMM_LEN))
 			return -EFAULT;
 		break;
 	case PR_GET_ENDIAN:
diff --git a/lib/tests/string_kunit.c b/lib/tests/string_kunit.c
index b64d7f0e54a3..5d26029d2d01 100644
--- a/lib/tests/string_kunit.c
+++ b/lib/tests/string_kunit.c
@@ -883,7 +883,7 @@ static void string_bench_strrchr(struct kunit *test)
 
 #define TASK_NAME "task_name"
 #define TASK_NAME_LEN 9
-#define TASK_MAX_LEN TASK_COMM_LEN
+#define TASK_MAX_LEN TASK_COMM_EXT_LEN
 #define SMALLER_LEN TASK_NAME_LEN - 3
 #define BIGGER_LEN TASK_MAX_LEN + 3
 

-- 
2.55.0

