From: Sukadev Bhattiprolu <sukadev-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [RFC][PATCH] SEND_SIG_NOINFO: Set si_pid to tgid instead of pid
Date: Wed, 17 Dec 2008 19:58:23 -0800
Message-ID: <20081218035823.GA21062@us.ibm.com>
References: <20081217020601.GB2866@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20081217020601.GB2866-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, roland-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: daniel-nym3zxDgnZcAvxtiuMwx3w@public.gmane.org, bastian-yyjItF7Rl6lg9hUCZPvPmw@public.gmane.org, xemul-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, containers-qjLDD68F18O7TbgM5vRIOg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org


Ccing linux-api for the user-visible changes per Roland's suggestion.
Not sure if the current behavior is documented somewhere. but should
the new behavior be documented in pipe(7) and prctl(2) ?

This patch was recently added to -mm tree.

Sukadev

Sukadev Bhattiprolu [sukadev-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org] wrote:
| 
| From: Sukadev Bhattiprolu <sukadev-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
| Date: Tue, 16 Dec 2008 17:07:17 -0800
| Subject: [PATCH] SEND_SIG_NOINFO: Set si_pid to tgid instead of pid
| 
| POSIX requires the si_pid to be the process id of the sender, so ->si_pid
| should really be set to 'tgid'. This change does have following changes
| in behavior:
| 
| 	- When sending pdeath_signal on re-parent to a sub-thread, ->si_pid
| 	  cannot be used to identify the thread that did the re-parent since
| 	  it will now show the tgid instead of thread id.
| 
| 	- A multi-threaded application that expects to find the specific
| 	  thread that encountered a SIGPIPE using the ->si_pid will now
| 	  break.
| 
| Signed-off-by: Sukadev Bhattiprolu <sukadev-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
| ---
|  kernel/signal.c |    2 +-
|  1 files changed, 1 insertions(+), 1 deletions(-)
| 
| diff --git a/kernel/signal.c b/kernel/signal.c
| index d11e5f8..700d767 100644
| --- a/kernel/signal.c
| +++ b/kernel/signal.c
| @@ -856,7 +856,7 @@ static int send_signal(int sig, struct siginfo *info, struct task_struct *t,
|  			q->info.si_signo = sig;
|  			q->info.si_errno = 0;
|  			q->info.si_code = SI_USER;
| -			q->info.si_pid = task_pid_nr_ns(current,
| +			q->info.si_pid = task_tgid_nr_ns(current,
|  							task_active_pid_ns(t));
|  			q->info.si_uid = current_uid();
|  			break;
| -- 
| 1.5.2.5
| 
| --
| To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
| the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
| More majordomo info at  http://vger.kernel.org/majordomo-info.html
| Please read the FAQ at  http://www.tux.org/lkml/
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
