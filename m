From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [RFC PATCH] getcpu_cache system call: caching current CPU number (x86)
Date: Mon, 20 Jul 2015 14:09:14 -0700
Message-ID: <CALCETrUZ8vB30rdmeoV4JKPUsRnVPvoxXRJ47CEFud2aSF2=Ew@mail.gmail.com>
References: <1436724386-30909-1-git-send-email-mathieu.desnoyers@efficios.com>
 <5CDDBDF2D36D9F43B9F5E99003F6A0D48D5F39C6@PRN-MBX02-1.TheFacebook.com>
 <587954201.31.1436808992876.JavaMail.zimbra@efficios.com> <5CDDBDF2D36D9F43B9F5E99003F6A0D48D5F5DA0@PRN-MBX02-1.TheFacebook.com>
 <549319255.383.1437070088597.JavaMail.zimbra@efficios.com>
 <CALCETrWEKE=mow3vVh7C4r8CuGy_d5VOEz7KkpijuR5cpBfFtg@mail.gmail.com>
 <CA+55aFz-VBnEKh0SPKgu8xV5=Zb+=6odybVUDoOYOknshbcFJA@mail.gmail.com>
 <20150717232836.GA13604@domone> <CALCETrVY=kjeA_4pazy3BL+ekfcV6WHKw8e3z-LBxx_uP1bw2Q@mail.gmail.com>
 <55ACB2DC.5010503@redhat.com> <CALCETrV9Vp5UUOb3e_R5tphyE-urBgTwQR2pFWUOOFnHqWXHKQ@mail.gmail.com>
 <55AD14A4.6030101@redhat.com> <CALCETrUx6wFxmz+9TyW5bNgaMN0q180G8y9YOyq_D41sdhFaRQ@mail.gmail.com>
 <CA+55aFzMJkzydXb7uVv1iSUnp=539d43ghQaonGdzMoF7QLZBA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CA+55aFzMJkzydXb7uVv1iSUnp=539d43ghQaonGdzMoF7QLZBA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, libc-alpha <libc-alpha-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, =?UTF-8?B?T25kxZllaiBCw61sa2E=?= <neleai-9Vj9tDbzfuSlVyrhU4qvOw@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Florian Weimer <fweimer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Lai Jiangshan <laijs-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Jul 20, 2015 at 1:50 PM, Linus Torvalds
<torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:
>
> On Jul 20, 2015 10:41 AM, "Andy Lutomirski" <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> wrote:
>>
>> glibc will have to expose a way to turn it off, I guess. (ELF flag?)
>
> Ugh. That just sounds nasty.
>
> I'm on mobile, so can't check right now, but don't we already have a per-cpu
> gdt? We could just make a very simple rule:
>
> - create a single gdt entry with a segment that is per-cpu and points to one
> single read-only page in kernel space that contains the virtual address of
> that segment in vmalloc space (and maybe we can have the CPU number there
> somewhere, and extend it to something else later)

Annoying problem one: the segment base field is only 32 bits in the GDT.

>
> - make the rule be that if you hold that segment in %fs or %gs in your user
> space state, it gets cleared when the thread is scheduled out.

That sounds a bit evil, but okay.

>
> What does this get you?
>
> It basically means that:
>
> - user space can just load the segment selector in %gs
>

IIRC this is very expensive -- 40 cycles or so.  At this point
userspace might as well just use a real lock cmpxchg.

> - user space can load the virtual address of the segment base into a bar
> register, and use that to calculate a pointer to regular data structures.
>
> - user space can use that "reverse offset" to access any data it wants, and
> access that data with a gs override.
>
> - if the user space thread is scheduled, that access will fault with a GP
> fault, because %gs became NUL.

Cute.

>
> So basically you can do any memory access you want, and you'll be guaranteed
> that it will be done "atomically" on the same CPU you did the segment load
> on, or it will fault because you got scheduled away.
>
> And it's very cheap for both kernel and user space. One extra gdt entry (not
> per process or anything like that - it's system global, although different
> cpus all end up with different entries), and for each cpu one virtually
> mapped page. And all user space needs to do is to do a segment load.
>
> No system calls, no nothing.
>
> Would that be useful?
>

Does it solve the Wine problem?  If Wine uses gs for something and
calls a function that does this, Wine still goes boom, right?

Could Wine just save and restore gs on calls into and out of Windows
code?  That would solve all the problems, right?

--Andy
