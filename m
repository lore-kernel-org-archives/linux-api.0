From: Palmer Dabbelt <palmer-96lFi9zoCfxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 09/13] Move bp_type_idx to kernel/event/hw_breakpoint.c
Date: Fri, 06 Nov 2015 22:44:07 -0800 (PST)
Message-ID: <563d9db7.6293420a.cdda3.ffffa5c8@mx.google.com>
References: <20151104122151.GB11639@twins.programming.kicks-ass.net>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151104122151.GB11639-ndre7Fmf5hadTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
Cc: arnd-r2nGTMty4D4@public.gmane.org, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, ast-uqk4Ao+rVK5Wk0Htik3J/w@public.gmane.org, aishchuk-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, 3chas3-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, chris-YvXeqwSYzG2sTnJN9+BGXg@public.gmane.org, dave-gkUM19QKKo4@public.gmane.org, dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, geoff-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, iulia.manda21-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, plagnioj-sclMFOaUSTBWk0Htik3J/w@public.gmane.org, jikos-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-xtensa-PjhNF2WwrV/0Sa2dR60CXw@public.gmane.org, mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org, jcmvbkbc-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, tomi.valkeinen-l0cyMroinI0@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, 04 Nov 2015 04:21:51 PST (-0800), peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org wrote:
> On Wed, Nov 04, 2015 at 12:41:06PM +0100, Peter Zijlstra wrote:
>> On Tue, Nov 03, 2015 at 11:46:30AM -0800, Palmer Dabbelt wrote:
>> > This has a "#ifdef CONFIG_*" that used to be exposed to userspace.
>> >
>> > The names in here are so generic that I don't think it's a good idea
>> > to expose them to userspace (or even the rest of the kernel).  Since
>> > there's only one kernel user, it's been moved to that file.
>> >
>> > Signed-off-by: Palmer Dabbelt <palmer-96lFi9zoCfxBDgjK7y7TUQ@public.gmane.org>
>> > Reviewed-by: Andrew Waterman <waterman-aFE07iDfcCIb0cFwG/AQJIdd74u8MsAO@public.gmane.org>
>> > Reviewed-by: Albert Ou <aou-aFE07iDfcCIb0cFwG/AQJIdd74u8MsAO@public.gmane.org>
>>
>> Assuming you want to keep all these patches together in a tree or so.
>> Let me know if you want me to take this patch.

Well, the plan was to try to get the whole patch set all upstream together.
I'd prefer that, because it'll be easier to make sure everything gets in before
the last checker patch.  Since it touches so many different places I'd be OK
with doing it peicemeal.

I'm kind of new to this whole process: do you think someone is likely to take
this patch set all together?

>> Acked-by: Peter Zijlstra (Intel) <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
>
> Ah, build-bot finds your change is broken and you didn't grep right. It
> is used in more places.

Sorry about that, I must have mis-grep'd.  I guess that's what the build-bot is
for :).

> How about moving it to include/linux/hw_breakpoint.h, instead of having
> it in the uapi crud?

Yep, that makes sense.

I'm going to re-submit a v5 of this patch set, since there was also a missing
patch for blackfin that the buildbot found.
