Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AB714C8FFB;
	Thu, 27 Aug 2026 18:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.97.179.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787855038; cv=none; b=uHydPBjLkJLhrc5BcklrrnVJERxaWhuR+vJBH2n67LYxEfkWttCGTCithOGvf6qCI1lGG+IdBIDOOjQdhK0+rHKBqEMit7MFk4YgX5MhouZqA+HQ3asXDwHZuR816/G6eiNbf6I/t6AmWsJneSEXW68GMNdzS52x5eQCsL8LNrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787855038; c=relaxed/simple;
	bh=yOzWuXtQ2j/SL/0BiwMyC1Mw5Q0MIxHagw6Oo4LiBFc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=qoVfqOjQcfLR7tEeiNBZAdUU4rF49zpHHCaIs240Wyb+XKbUh5zsnLaa1Ub/TIiAtFO75LbsnL0Z4lss8w1Ex3v9ALtlf/QuQNkvD5f8jYFOesZTSUxRwsrxbcKw01wz0kOesN68+/T6eM86yaa15+XPph88L7ouLcAD76xjP38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com; spf=pass smtp.mailfrom=igalia.com; dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.b=at6oDwZd; arc=none smtp.client-ip=213.97.179.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=igalia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.b="at6oDwZd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Cc:To:Message-Id:Content-Transfer-Encoding:Content-Type:
	MIME-Version:Subject:Date:From:From:Reply-To;
	bh=WwqeHqUYJu3OSjLPCkapAyi6pywTO4QN+uPji9ROHhg=; b=at6oDwZdvMMfjaicvNK76Q+xeE
	5U31g6f4iMZLc/xEfMra+AG/eAoO8VVskEbrelaDGXGFsvr6p1x4T6ewcd2h+d05Y0nNHfJdopLku
	LtEk/ct2SKoBaxfYmvErgjv8aSBefcEv+yRU5X7uOc2atI2vDDheZPeK9j9l4LjmR5jslxrnazEyT
	e2Nuc1XoR4bM259i1pQ+Q5/G3gwg6w/WnpIgXjlCZ6zgN1q2SIA0z+znxMTh2L+5QP4BYCEMzxcd9
	NKhwruIamvJzboSZVAkdaZB9NFFuBs0avXqiPxLXjZ8dz/2Hkh1xzGgPmmVI0+McgdS9bB4HzGc1G
	0cqOnV/A==;
Received: from [187.57.78.212] (helo=[192.168.15.100])
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1wzelH-00AOUg-Aq; Thu, 27 Aug 2026 20:23:39 +0200
From: =?utf-8?q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
Date: Thu, 27 Aug 2026 15:23:03 -0300
Subject: [PATCH v5 4/6] sched: Extend task command name with
 TASK_COMM_EXT_LEN
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260827-tonyk-long_name-v5-4-5fa843782a00@igalia.com>
References: <20260827-tonyk-long_name-v5-0-5fa843782a00@igalia.com>
In-Reply-To: <20260827-tonyk-long_name-v5-0-5fa843782a00@igalia.com>
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
 linux-api@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
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
 fs/proc/array.c       |  2 +-
 include/linux/sched.h |  5 +++--
 kernel/sys.c          | 10 +++++-----
 3 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/fs/proc/array.c b/fs/proc/array.c
index 8ebb7cf1a7b0..0d70b21c803c 100644
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
index 8d2355e41619..c41d61e9babf 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -323,6 +323,7 @@ struct user_event_mm;
  */
 enum {
 	TASK_COMM_LEN = 16,
+	TASK_COMM_EXT_LEN = 64,
 };
 
 extern void sched_tick(void);
@@ -1187,7 +1188,7 @@ struct task_struct {
 	 * - set it with set_task_comm() to ensure it is always
 	 *   NUL-terminated and zero-padded
 	 */
-	char				comm[TASK_COMM_LEN];
+	char				comm[TASK_COMM_EXT_LEN];
 
 	struct nameidata		*nameidata;
 
@@ -2041,7 +2042,7 @@ extern void __set_task_comm(struct task_struct *tsk, const char *from, bool exec
 static __always_inline void copy_task_comm(char *dst, struct task_struct *tsk, size_t len)
 {
 	const char *_src = tsk->comm;
-	size_t _len = min(len, TASK_COMM_LEN);
+	size_t _len = min(len, TASK_COMM_EXT_LEN);
 
 	if (!_len)
 		return;
diff --git a/kernel/sys.c b/kernel/sys.c
index 97df708c11a0..5ebd3c1dfddf 100644
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

-- 
2.55.0

