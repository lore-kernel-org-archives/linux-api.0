From: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 03/26] signal: Do not perform permission checks when sending pdeath_signal
Date: Tue,  6 Jun 2017 14:03:15 -0500
Message-ID: <20170606190338.28347-3-ebiederm@xmission.com>
References: <877f0pym71.fsf@xmission.com>
 <20170606190338.28347-1-ebiederm@xmission.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170606190338.28347-1-ebiederm@xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Kees Cook <keescook@chromium.org>, Roland McGrath <roland@hack.frob.com>, Al Viro <viro@ZenIV.linux.org.uk>, David Howells <dhowells@redhat.com>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>
List-Id: linux-api@vger.kernel.org

This fixes and old old regression.  When Roland switched from
sending pdeath_signal with send_sig() to send_group_sig_info
it gained a permission check, and started taking the tasklist
lock.  Roland earlier fixed the double taking of the tasklist
lock in 3f2a0d1df938 ("[PATCH] fix pdeath_signal SMP locking")
but pdeath_signal still performs an unnecessary permission
check.

Ordinarily I would be hesitant at fixing an ancient regression but
a permission check for our parent sending to us is almost never
likely to fail (so it is unlikely anyone has noticed), and it
is stupid.  It makes absolutely no sense to see if our
parent has permission to send us a signal we requested be
sent to us.

As this is more permisssive there is no chance anything will break.
The information of if our parent is living is available elsewhere
getppid, tkill, and proc with no special permissions so this should
not be an information leak.

See https://git.kernel.org/pub/scm/linux/kernel/git/tglx/history.git/
for the bitkeeper era history that I refer to.

Fixes: da334d91ff70 ("[PATCH] linux-2.5.66-signal-cleanup.patch")
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 kernel/exit.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index 516acdb0e0ec..8926cdd132f2 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -692,8 +692,8 @@ static void forget_original_parent(struct task_struct *father,
 			if (likely(!t->ptrace))
 				t->parent = t->real_parent;
 			if (t->pdeath_signal)
-				group_send_sig_info(t->pdeath_signal,
-						    SEND_SIG_NOINFO, t);
+				do_send_sig_info(t->pdeath_signal,
+						 SEND_SIG_NOINFO, t, true);
 		}
 		/*
 		 * If this is a threaded reparent there is no need to
-- 
2.10.1
