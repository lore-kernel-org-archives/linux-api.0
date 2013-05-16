From: Pavel Tikhomirov <snorcht-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/1] posix-timers: Show clock ID in proc file
Date: Fri, 17 May 2013 02:12:03 +0400
Message-ID: <1368742323-46949-2-git-send-email-snorcht@gmail.com>
References: <1368742323-46949-1-git-send-email-snorcht@gmail.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1368742323-46949-1-git-send-email-snorcht-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Matthew Helsley <matt.helsley-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Pavel Tikhomirov <snorcht-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Expand information about posix-timers in /proc/<pid>/timers by adding
info about clock, with which the timer was created. I.e. in the forth
line of timer info after "notify:" line go "ClockID: <clock_id>".

Signed-off-by: Pavel Tikhomirov <snorcht-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/proc/base.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 2dad4a9..8a38eef 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2079,6 +2079,7 @@ static int show_timer(struct seq_file *m, void *v)
 		nstr[notify & ~SIGEV_THREAD_ID],
 		(notify & SIGEV_THREAD_ID) ? "tid" : "pid",
 		pid_nr_ns(timer->it_pid, tp->ns));
+	seq_printf(m, "ClockID: %d\n", timer->it_clock);
 
 	return 0;
 }
-- 
1.7.9.5
