From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [RFC PATCH] getcpu_cache system call: caching current CPU number (x86)
Date: Fri, 17 Jul 2015 11:55:03 -0700
Message-ID: <CALCETrVNcLpZVATHOs-gZR9AMUSW_ScvXW_0oY=OnFHXXHLdaA@mail.gmail.com>
References: <1436724386-30909-1-git-send-email-mathieu.desnoyers@efficios.com>
 <5CDDBDF2D36D9F43B9F5E99003F6A0D48D5F39C6@PRN-MBX02-1.TheFacebook.com>
 <587954201.31.1436808992876.JavaMail.zimbra@efficios.com> <5CDDBDF2D36D9F43B9F5E99003F6A0D48D5F5DA0@PRN-MBX02-1.TheFacebook.com>
 <549319255.383.1437070088597.JavaMail.zimbra@efficios.com>
 <CALCETrWEKE=mow3vVh7C4r8CuGy_d5VOEz7KkpijuR5cpBfFtg@mail.gmail.com> <CA+55aFz-VBnEKh0SPKgu8xV5=Zb+=6odybVUDoOYOknshbcFJA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CA+55aFz-VBnEKh0SPKgu8xV5=Zb+=6odybVUDoOYOknshbcFJA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Lai Jiangshan <laijs-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, libc-alpha <libc-alpha-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Jul 17, 2015 at 11:48 AM, Linus Torvalds
<torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:
> On Thu, Jul 16, 2015 at 12:27 PM, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> wrote:
>>
>> If we actually bit the bullet and implemented per-cpu mappings
>
> That's not ever going to happen.
>
> Per-cpu page tables are a complete disaster. It's a recipe for crazy
> race conditions, when you have CPUs that update things like
> dirty/accessed bits atomically etc, and you have fundamental races
> when multiple CPU's allocating page tables at the same time (remember:
> we have concurrent page faults, and the locking is not per-vm, it's at
> a finer granularity).
>
> It's also a big memory management problem when you have lots and lots of CPU's.

>
> So you can try to prove me wrong, but seriously, I doubt you'll succeed.

I doubt I'll succeed, too.  But I don't want anything resembling full
per-cpu page tables -- per-cpu pgds would be plenty.  Still kinda
nasty to implement.  On the other hand, getting rid of swapgs would be
a nice win.

>
> On x86, if you want per-cpu memory areas, you should basically plan on
> using segment registers instead (although other odd state has been
> used - there's been the people who use segment limits etc rather than
> the *pointer* itself, preferring to use "lsl" to get percpu data. You
> could also imaging hiding things in the vector state somewhere if you
> control your environment well enough).

I do think we should implement per-cpu descriptor bases or gs bases,
and we should also implement rd/wrfsgsbase.  We should do them
together, give them well-defined sematics, and write tests.  The
current "segment register state kinda sorta context switches correctly
as long as no one looks carefully" approach is no good.  And once we
do that, we don't need a cached cpu number.

Sigh, if we had clean per-cpu memory mappings and got rid of swapgs,
then implementing the fsgsbase stuff would be so much easier.
(Although -- we could plausibly use r15 or something as our percpu
pointer in the kernel without too much loss, which would also get rid
of the fsgsbase mess.  Hmm.  It would make paranoid entries much
faster, too.)

Anyway, I do intend to ask Intel for real per-cpu mappings of some
sort if they ever ask my opinion again.  Maybe they'll give us
something in a few decades.

--Andy
