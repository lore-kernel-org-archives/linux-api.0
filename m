From: Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH 3/3] posix timers: Add syscall that works on timer sigevent
Date: Sun, 17 Feb 2013 22:53:40 +0400
Message-ID: <51212734.2060700@parallels.com>
References: <511D0E50.7090505@parallels.com> <511D0EA1.9060704@parallels.com> <20130217134248.GD13378@debjann.fritz.box>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130217134248.GD13378-7cfQGs147y6a6lf8Wg2v7Z5kstrrjoWp@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jann Horn <jannhorn-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 02/17/2013 05:42 PM, Jann Horn wrote:
> On Thu, Feb 14, 2013 at 08:19:45PM +0400, Pavel Emelyanov wrote:
>> +	struct sigevent event;
> [...]
>> +	event.sigev_notify = timer->it_sigev_notify;
>> +	event.sigev_signo = timer->sigq->info.si_signo;
>> +	event.sigev_value = timer->sigq->info.si_value;
>> +	event.sigev_notify_thread_id = pid_vnr(timer->it_pid);
> [...]
>> +	if (old_event && copy_to_user(old_event, &event, sizeof(event)))
> 
> Won't this leak uninitialized kernel stack data to userspace? As far as I can
> see, the _sigev_un union is bigger than the _tid field in it, so the rest of
> it will be copied over without initialization, right?

Indeed :( Thanks for catching this, I will memezro the thing before copying
to the user-space.

> Jann
> 
