From: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 1/3] proc: Stop reporting eip and esp in /proc/PID/stat
Date: Fri, 30 Sep 2016 10:58:56 -0700
Message-ID: <a5fed4c3f4e33ed25d4bb03567e329bc5a712bcc.1475257877.git.luto@kernel.org>
References: <cover.1475257877.git.luto@kernel.org>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1475257877.git.luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
In-Reply-To: <cover.1475257877.git.luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
References: <cover.1475257877.git.luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Brian Gerst <brgerst-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Jann Horn <jann-XZ1E9jl8jIdeoWH0uzbU5w@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Tycho Andersen <tycho.andersen-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Tetsuo Handa <penguin-kernel-1yMVhJb1mP/7nzcFbJAaVXf5DAMn2ifp@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Reporting these fields on a non-current task is dangerous.  If the
task is in any state other than normal kernel code, they may contain
garbage or even kernel addresses on some architectures.  (x86_64
used to do this.  I bet lots of architectures still do.)  With
CONFIG_THREAD_INFO_IN_TASK, it can OOPS, too.

As far as I know, there are no use programs that make any material
use of these fields, so just get rid of them.

Cc: Tetsuo Handa <penguin-kernel-1yMVhJb1mP/7nzcFbJAaVXf5DAMn2ifp@public.gmane.org>
Cc: Tycho Andersen <tycho.andersen-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Cc: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Reported-by: Jann Horn <jann-XZ1E9jl8jIdeoWH0uzbU5w@public.gmane.org>
Signed-off-by: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 fs/proc/array.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/proc/array.c b/fs/proc/array.c
index 88c7de12197b..1bb1097e73b7 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -417,10 +417,11 @@ static int do_task_stat(struct seq_file *m, struct pid_namespace *ns,
 	mm = get_task_mm(task);
 	if (mm) {
 		vsize = task_vsize(mm);
-		if (permitted) {
-			eip = KSTK_EIP(task);
-			esp = KSTK_ESP(task);
-		}
+		/*
+		 * esp and eip are intentionally zeroed out.  There is no
+		 * non-racy way to read them without freezing the task.
+		 * Programs that need reliable values can use ptrace(2).
+		 */
 	}
 
 	get_task_comm(tcomm, task);
-- 
2.7.4
