From: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 07/26] pidns: Improve the error handling in alloc_pid
Date: Tue,  6 Jun 2017 14:03:19 -0500
Message-ID: <20170606190338.28347-7-ebiederm@xmission.com>
References: <877f0pym71.fsf@xmission.com>
 <20170606190338.28347-1-ebiederm@xmission.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170606190338.28347-1-ebiederm@xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Kees Cook <keescook@chromium.org>, Roland McGrath <roland@hack.frob.com>, Al Viro <viro@ZenIV.linux.org.uk>, David Howells <dhowells@redhat.com>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>
List-Id: linux-api@vger.kernel.org

Cause any failure to allocate pid 1 to permanently disable pid
allocations for the pid namespace.

Before the pid becomes pid 1 there ns->last_pid and other state
remains unchanged so it is safe to try again...

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 kernel/pid.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/kernel/pid.c b/kernel/pid.c
index fd1cde1e4576..f4fb1a84109b 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -321,10 +321,8 @@ struct pid *alloc_pid(struct pid_namespace *ns)
 	}
 
 	if (unlikely(is_child_reaper(pid))) {
-		if (pid_ns_prepare_proc(ns)) {
-			disable_pid_allocation(ns);
+		if (pid_ns_prepare_proc(ns))
 			goto out_free;
-		}
 	}
 
 	get_pid_ns(ns);
@@ -350,6 +348,10 @@ struct pid *alloc_pid(struct pid_namespace *ns)
 	put_pid_ns(ns);
 
 out_free:
+	/* Ensure everything stops if allocation of pid 1 failed */
+	if ((i < ns->level) && (pid->numbers[ns->level].nr == 1))
+		disable_pid_allocation(ns);
+
 	while (++i <= ns->level)
 		free_pidmap(pid->numbers + i);
 
-- 
2.10.1
