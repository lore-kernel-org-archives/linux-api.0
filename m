From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [RFC PATCH] getcpu_cache system call: caching current CPU number (x86)
Date: Thu, 16 Jul 2015 12:27:10 -0700
Message-ID: <CALCETrWEKE=mow3vVh7C4r8CuGy_d5VOEz7KkpijuR5cpBfFtg@mail.gmail.com>
References: <1436724386-30909-1-git-send-email-mathieu.desnoyers@efficios.com>
 <5CDDBDF2D36D9F43B9F5E99003F6A0D48D5F39C6@PRN-MBX02-1.TheFacebook.com>
 <587954201.31.1436808992876.JavaMail.zimbra@efficios.com> <5CDDBDF2D36D9F43B9F5E99003F6A0D48D5F5DA0@PRN-MBX02-1.TheFacebook.com>
 <549319255.383.1437070088597.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <549319255.383.1437070088597.JavaMail.zimbra-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Cc: Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Lai Jiangshan <laijs-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, libc-alpha <libc-alpha-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Jul 16, 2015 at 11:08 AM, Mathieu Desnoyers
<mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org> wrote:
> ----- On Jul 14, 2015, at 5:34 AM, Ben Maurer bmaurer-b10kYP2dOMg@public.gmane.org wrote:
>
>> Mathieu Desnoyers wrote:
>>> If we invoke this per-thread registration directly in the glibc NPTL
>>> implementation,
>>> in start_thread, do you think it would fit your requirements ?
>>
>> I guess this would basically be transparent to the user -- we'd just need to
>> make sure that the registration happens very early, before any chance of
>> calling malloc.
>
> Yes, this is my thinking too.
>
>>
>> That said, having the ability for the kernel to understand that TLS
>> implementation are laid out using the same offset on each thread seems like
>> something that could be valuable long term. Doing so makes it possible to build
>> other TLS-based features without forcing each thread to be registered.
>
> AFAIU, using a fixed hardcoded ABI between kernel and user-space might make
> transition from the pre-existing ABI (where this memory area is not
> reserved) a bit tricky without registering the area, or getting a "feature"
> flag, through a system call.
>
> The related question then becomes: should we issue this system call once
> per process, or once per thread at thread creation ? Issuing it once per
> thread is marginally more costly for thread creation, but seems to be
> easier to deal with internally within the kernel.
>
> We could however ensure that only a single system call is needed per new-coming
> thread, rather than one system call per feature. One way to do this would be
> to register an area that may contain more than just the CPU id. It could
> consist of an expandable structure with fixed offsets. When registered, we
> could pass the size of that structure as an argument to the system call, so
> the kernel knows which features are expected by user-space.

If we actually bit the bullet and implemented per-cpu mappings, we
could have this be completely flexible because there would be no
format at all.  Similarly, if we implemented per-cpu segments,
userspace would need to agree with *itself* how to arbitrate it, but
the kernel wouldn't need to be involved.

With this kind of memory poking, it's definitely messier, which is unfortunate.

--Andy
