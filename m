From: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 06/26] rlimit: Remove unnecessary grab of tasklist_lock
Date: Tue,  6 Jun 2017 14:03:18 -0500
Message-ID: <20170606190338.28347-6-ebiederm@xmission.com>
References: <877f0pym71.fsf@xmission.com>
 <20170606190338.28347-1-ebiederm@xmission.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170606190338.28347-1-ebiederm@xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Kees Cook <keescook@chromium.org>, Roland McGrath <roland@hack.frob.com>, Al Viro <viro@ZenIV.linux.org.uk>, David Howells <dhowells@redhat.com>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>
List-Id: linux-api@vger.kernel.org

There is no reason to take the tasklist lock here.  The sighand
structure is never referenced and and tsk->signal is guaranteed
to stick around until tsk is freed. Further update_rlimit_cpu
does not need the tasklist_lock.  And the rlim_lock is used
to guarantee mutual exclusion.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 kernel/sys.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/kernel/sys.c b/kernel/sys.c
index 8a94b4eabcaa..705f14b28134 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1380,13 +1380,6 @@ int do_prlimit(struct task_struct *tsk, unsigned int resource,
 			return -EPERM;
 	}
 
-	/* protect tsk->signal and tsk->sighand from disappearing */
-	read_lock(&tasklist_lock);
-	if (!tsk->sighand) {
-		retval = -ESRCH;
-		goto out;
-	}
-
 	rlim = tsk->signal->rlim + resource;
 	task_lock(tsk->group_leader);
 	if (new_rlim) {
@@ -1425,8 +1418,7 @@ int do_prlimit(struct task_struct *tsk, unsigned int resource,
 	     new_rlim->rlim_cur != RLIM_INFINITY &&
 	     IS_ENABLED(CONFIG_POSIX_TIMERS))
 		update_rlimit_cpu(tsk, new_rlim->rlim_cur);
-out:
-	read_unlock(&tasklist_lock);
+
 	return retval;
 }
 
-- 
2.10.1
