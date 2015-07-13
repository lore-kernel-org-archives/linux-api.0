From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [RFC PATCH] getcpu_cache system call: caching current CPU number (x86)
Date: Sun, 12 Jul 2015 20:40:26 -0700
Message-ID: <CALCETrXPFb2P0xueU41c1n5ZB7MjdDpkqXz6n9LP6N-fSDnj8Q@mail.gmail.com>
References: <1436724386-30909-1-git-send-email-mathieu.desnoyers@efficios.com> <20150712184730.GD18191@x>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150712184730.GD18191@x>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Lai Jiangshan <laijs-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Sun, Jul 12, 2015 at 11:47 AM, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org> wrote:
> On Sun, Jul 12, 2015 at 02:06:26PM -0400, Mathieu Desnoyers wrote:
>> Expose a new system call allowing threads to register a userspace memory
>> area where to store the current CPU number. Scheduler migration sets the
>> TIF_NOTIFY_RESUME flag on the current thread. Upon return to user-space,
>> a notify-resume handler updates the current CPU value within that
>> user-space memory area.
>>

>> +
>> +/*
>> + * sys_getcpu_cache - setup getcpu cache for caller thread
>> + */
>> +SYSCALL_DEFINE2(getcpu_cache, int32_t __user *, gcp, int, flags)
>> +{
>> +     if (flags)
>> +             return -EINVAL;
>> +     if (gcp != NULL && !access_ok(VERIFY_WRITE, gcp, sizeof(int32_t)))
>> +             return -EFAULT;
>> +     current->getcpu_cache = gcp;
>
> So, you store a userspace address, and intentionally only validate it
> when initially set, not when used.  You clear it on exec, though not on
> fork.  Could any cases other than exec could make this problematic?  In
> particular, what about unusual personality flags, such as
> ADDR_LIMIT_32BIT or ADDR_LIMIT_3GB?
>

On x86, this is safe, although it does violate the rules.

That being said, I've never understood why access_ok cares at all what
kind of task we're in.
