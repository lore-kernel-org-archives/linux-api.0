From: Pavel Tikhomirov <snorcht-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 0/1] posix timers: Expand exitsting info in proc file
Date: Fri, 17 May 2013 02:12:02 +0400
Message-ID: <1368742323-46949-1-git-send-email-snorcht@gmail.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Matthew Helsley <matt.helsley-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Pavel Tikhomirov <snorcht-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi.

I'm working on the checkpoint-restore project (http://criu.org), on
realisation of posix-timers. To compleatly checkpoint and restore these
timers we need to know which clock they are using. So I d'like to add
this information to existing syscall which shows posix-timers info.

Pavel Tikhomirov (1):
  posix-timers: Show clock ID in proc file

 fs/proc/base.c |    1 +
 1 file changed, 1 insertion(+)

-- 
1.7.9.5
