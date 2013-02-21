From: Matthew Helsley <matt.helsley-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/3] posix timers: Extend kernel API to report more info
 about timers
Date: Wed, 20 Feb 2013 17:21:29 -0800
Message-ID: <CA+RrjuURQTCP8yMa4nWxNQg=qxxsu6vrko2UVK4f8pFYbK6SYQ@mail.gmail.com>
References: <511D0E50.7090505@parallels.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <511D0E50.7090505-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Feb 14, 2013 at 8:18 AM, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org> wrote:
> Hi.
>
> I'm working on the checkpoint-restore project (http://criu.org), briefly
> it's aim is to collect information about process' state and saving it so
> that later it is possible to recreate the processes in the very same state
> as they were, using the collected information.
>
> One part of the task's state is the posix timers that this task has created.
> Currently kernel doesn't provide any API for getting information about
> what timers are currently created by process and in which state they are.
> I'd like to extend the posix timers API to provide more information about
> timers.
>
> Another problem with timers is the timer ID. Currently IDs are generated
> from global IDR and this makes it impossible to restore a timer from
> the saved state in general, as the required ID may be already busy at the
> time of restore.
>
> That said, I propose to
>
> 1. Change the way timer IDs are generated. This was done some time ago, so
>    I'm just re-sending this patch;

Seems fine in principle. Aside: I noticed there were some
important-looking patches to the idr usage in timer id allocation
today...

> 2. Add a system call that will list timer IDs created by the calling process;

If timers were listed in /proc like fds then you wouldn't need this
syscall. If we keep adding new syscalls like this CRIU will be
needlessly x86-specific when it could have been written more portably.

> 3. Add a system call that will allow to get the sigevent information about
>    particular timer in the sigaction-like manner.

You mentioned "extending the POSIX timer API". Isn't that something
best left to standards bodies lest your changes conflict with theirs?
Again, if this were a /proc interface you wouldn't have that issue
(you'll have others ;)).

>
> This is actually an RFC to start discussion about how the described problems
> can be addressed. Thus, if the approach with new system calls is not acceptable,
> I'm OK to implement this in any other form.

My preference is for "other form" for the reasons above.

Cheers,
    -Matt Helsley
