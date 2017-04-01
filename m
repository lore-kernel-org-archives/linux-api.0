From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: [RFC][PATCH 1/2] sighand: Count each thread group once in sighand_struct
Date: Sat, 01 Apr 2017 00:14:17 -0500
Message-ID: <8737dspv4m.fsf_-_@xmission.com>
References: <20170213141452.GA30203@redhat.com>
        <20170224160354.GA845@redhat.com> <87shmv6ufl.fsf@xmission.com>
        <20170303173326.GA17899@redhat.com> <87tw7axlr0.fsf@xmission.com>
        <87d1dyw5iw.fsf@xmission.com> <87tw7aunuh.fsf@xmission.com>
        <87lgsmunmj.fsf_-_@xmission.com> <20170304170312.GB13131@redhat.com>
        <8760ir192p.fsf@xmission.com> <878tnkpv8h.fsf_-_@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <878tnkpv8h.fsf_-_-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org> (Eric W. Biederman's message of
        "Sat, 01 Apr 2017 00:11:58 -0500")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Aleksa Sarai <asarai-IBi9RG/b67k@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Attila Fazekas <afazekas-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jann Horn <jann-XZ1E9jl8jIdeoWH0uzbU5w@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ulrich Obergfell <uobergfe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org


In practice either a thread group is either using a sighand_struct or
it isn't.  Therefore simplify things a bit and only increment the
count in sighand_struct when a new thread group is created that uses
the existing sighand_struct, and only decrement the count in
sighand_struct when a thread group exits.

As well as standing on it's own merits this has the potential to simply
de_thread.

Signed-off-by: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
---
 kernel/exit.c | 2 +-
 kernel/fork.c | 6 ++++--
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index e126ebf2400c..8c5b3e106298 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -163,9 +163,9 @@ static void __exit_signal(struct task_struct *tsk)
 	tsk->sighand = NULL;
 	spin_unlock(&sighand->siglock);
 
-	__cleanup_sighand(sighand);
 	clear_tsk_thread_flag(tsk, TIF_SIGPENDING);
 	if (group_dead) {
+		__cleanup_sighand(sighand);
 		flush_sigqueue(&sig->shared_pending);
 		tty_kref_put(tty);
 	}
diff --git a/kernel/fork.c b/kernel/fork.c
index 6c463c80e93d..fe6f1bf32bb9 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1295,7 +1295,8 @@ static int copy_sighand(unsigned long clone_flags, struct task_struct *tsk)
 	struct sighand_struct *sig;
 
 	if (clone_flags & CLONE_SIGHAND) {
-		atomic_inc(&current->sighand->count);
+		if (!(clone_flags & CLONE_THREAD))
+			atomic_inc(&current->sighand->count);
 		return 0;
 	}
 	sig = kmem_cache_alloc(sighand_cachep, GFP_KERNEL);
@@ -1896,7 +1897,8 @@ static __latent_entropy struct task_struct *copy_process(
 	if (!(clone_flags & CLONE_THREAD))
 		free_signal_struct(p->signal);
 bad_fork_cleanup_sighand:
-	__cleanup_sighand(p->sighand);
+	if (!(clone_flags & CLONE_THREAD))
+		__cleanup_sighand(p->sighand);
 bad_fork_cleanup_fs:
 	exit_fs(p); /* blocking */
 bad_fork_cleanup_files:
-- 
2.10.1
