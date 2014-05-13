From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [SCHED_DEADLINE man pages 0/2] Summary
Date: Tue, 13 May 2014 16:54:45 +0200
Message-ID: <53723235.40101@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Juri Lelli <juri.lelli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Dario Faggioli <raistlin-k2GhghHVRtY@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Peter, at al.

The follow ups to this mail contain the changes to man-pages for
the new sched_setattr() and sched_getattr() system calls, as well
as the changes to the sched(7) man page to document the 
SCHED_DEADLINE policy, all new changes in kernel 3.14.

I used the text you submitted, but _heavily_ edited it, and added
a _lot_ of further details. Therefore, could you (and Juri, and 
Dario?) please carefully review the text.

The follow-up mails are:

[1/2] The sched_setattr.2 page that documents sched_setattr(2) 
      and sched_getattr(2).

[2/2] The revisions to the sched(7) page.

In each case, I've posted the formatted output for easy reading,
and attached the page source to the message.

Thanks,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
