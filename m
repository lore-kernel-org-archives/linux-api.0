From: Palmer Dabbelt <palmer-96lFi9zoCfxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 09/13] Move bp_type_idx to kernel/event/hw_breakpoint.c
Date: Wed, 16 Sep 2015 20:56:00 -0700 (PDT)
Message-ID: <55fa39d0.2c1b450a.6854.4115@mx.google.com>
References: <20150915193910.GH16853@twins.programming.kicks-ass.net>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150915193910.GH16853-ndre7Fmf5hadTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
Cc: arnd-r2nGTMty4D4@public.gmane.org, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, ast-uqk4Ao+rVK5Wk0Htik3J/w@public.gmane.org, aishchuk-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, 3chas3-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, chris-YvXeqwSYzG2sTnJN9+BGXg@public.gmane.org, dave-gkUM19QKKo4@public.gmane.org, dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, geoff-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, iulia.manda21-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, plagnioj-sclMFOaUSTBWk0Htik3J/w@public.gmane.org, jikos-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-xtensa-PjhNF2WwrV/0Sa2dR60CXw@public.gmane.org, mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org, jcmvbkbc-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, tomi.valkeinen-l0cyMroinI0@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, 15 Sep 2015 12:39:10 PDT (-0700), peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org wrote:
> On Tue, Sep 15, 2015 at 11:40:11AM -0700, Palmer Dabbelt wrote:
>> On Tue, 15 Sep 2015 01:06:07 PDT (-0700), peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org wrote:
>> > On Mon, Sep 14, 2015 at 03:50:43PM -0700, Palmer Dabbelt wrote:
>> >> This has a "#ifdef CONFIG_*" that used to be exposed to userspace.
>> >>
>> >> The names in here are so generic that I don't think it's a good idea
>> >> to expose them to userspace (or even the rest of the kernel).  Since
>> >> there's only one kernel user, it's been moved to that file.
>> >>
>> >> Signed-off-by: Palmer Dabbelt <palmer-96lFi9zoCfxBDgjK7y7TUQ@public.gmane.org>
>> >> Reviewed-by: Andrew Waterman <waterman-aFE07iDfcCIb0cFwG/AQJIdd74u8MsAO@public.gmane.org>
>> >> Reviewed-by: Albert Ou <aou-aFE07iDfcCIb0cFwG/AQJIdd74u8MsAO@public.gmane.org>
>> >> ---
>> >>  include/uapi/linux/hw_breakpoint.h | 10 ----------
>> >>  kernel/events/hw_breakpoint.c      | 10 ++++++++++
>> >>  2 files changed, 10 insertions(+), 10 deletions(-)
>> >>
>> >> diff --git a/include/uapi/linux/hw_breakpoint.h b/include/uapi/linux/hw_breakpoint.h
>> >> index b04000a2296a..7a6a5a7f9511 100644
>> >> --- a/include/uapi/linux/hw_breakpoint.h
>> >> +++ b/include/uapi/linux/hw_breakpoint.h
>> >> @@ -17,14 +17,4 @@ enum {
>> >>  	HW_BREAKPOINT_INVALID   = HW_BREAKPOINT_RW | HW_BREAKPOINT_X,
>> >>  };
>> >>
>> >> -enum bp_type_idx {
>> >> -	TYPE_INST 	= 0,
>> >> -#ifdef CONFIG_HAVE_MIXED_BREAKPOINTS_REGS
>> >> -	TYPE_DATA	= 0,
>> >> -#else
>> >> -	TYPE_DATA	= 1,
>> >> -#endif
>> >> -	TYPE_MAX
>> >> -};
>> >
>> > This is rather unfortunate; you are correct that the naming is too
>> > generic (and I tend to agree), but I think these values are required by
>> > userspace to fill out:
>> >
>> >   perf_event_attr::bp_type
>> >
>> > So removing them will break things.
>> >
>> > Frederic?
>>
>> perf_event_open(2) says
>>
>>        bp_type (since Linux 2.6.33)
>>               This chooses the breakpoint type.  It is one of:
>>
>>               HW_BREAKPOINT_EMPTY
>>                      No breakpoint.
>>
>>               HW_BREAKPOINT_R
>>                      Count when we read the memory location.
>>
>>               HW_BREAKPOINT_W
>>                      Count when we write the memory location.
>>
>>               HW_BREAKPOINT_RW
>>                      Count when we read or write the memory location.
>>
>>               HW_BREAKPOINT_X
>>                      Count when we execute code at the memory location.
>>
>>               The values can be combined via a bitwise or, but the combination
>>               of HW_BREAKPOINT_R or HW_BREAKPOINT_W  with  HW_BREAKPOINT_X  is
>>               not allowed.
>>
>> so I think removing this enum from userspace is OK.  Did I miss
>> something?
>
> Nah, could've just been me not being awake. Unless Frederic says
> otherwise I'll chalk it up to not having drank enough morning juice.

Well, I'm going to leave this alone, then -- as Arnd pointed out in a
later email that got mis-threaded, this would be super tricky to fix
if userspace actually relied on it (which is why I was scared I was
wrong).

v4 (which is hopefully the final version of the patch set) will leave
this as it is.
