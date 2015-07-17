From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [RFC PATCH] getcpu_cache system call: caching current CPU number (x86)
Date: Fri, 17 Jul 2015 12:11:28 -0700
Message-ID: <CA+55aFzvQbjryGKjMySo9X4D+tGBDmyuRqtFm2zAmt51bckhtg@mail.gmail.com>
References: <1436724386-30909-1-git-send-email-mathieu.desnoyers@efficios.com>
	<5CDDBDF2D36D9F43B9F5E99003F6A0D48D5F39C6@PRN-MBX02-1.TheFacebook.com>
	<587954201.31.1436808992876.JavaMail.zimbra@efficios.com>
	<5CDDBDF2D36D9F43B9F5E99003F6A0D48D5F5DA0@PRN-MBX02-1.TheFacebook.com>
	<549319255.383.1437070088597.JavaMail.zimbra@efficios.com>
	<CALCETrWEKE=mow3vVh7C4r8CuGy_d5VOEz7KkpijuR5cpBfFtg@mail.gmail.com>
	<CA+55aFz-VBnEKh0SPKgu8xV5=Zb+=6odybVUDoOYOknshbcFJA@mail.gmail.com>
	<CALCETrVNcLpZVATHOs-gZR9AMUSW_ScvXW_0oY=OnFHXXHLdaA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALCETrVNcLpZVATHOs-gZR9AMUSW_ScvXW_0oY=OnFHXXHLdaA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Lai Jiangshan <laijs-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, libc-alpha <libc-alpha-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Jul 17, 2015 at 11:55 AM, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> wrote:
>
> I doubt I'll succeed, too.  But I don't want anything resembling full
> per-cpu page tables -- per-cpu pgds would be plenty.  Still kinda
> nasty to implement.

Per-cpu pgd's would have been trivial in the old 32-bit PAE
environment. There's only four entries at the top level, and they have
to be allocated at process startup anyway - and we wopuldn't even have
to do a per-cpu-and-VM allocation, we'd just have done one single
per-cpu entry, and when switching tasks we'd *copy* the VM entries to
the per-cpu one and re-load %cr3 with the same address. I thought
about it.

But I'm really happy we never went down that road. It's non-portable,
even on x86-32 (because it requires PAE). And even there it would be
limited to "the top 1GB of virtual address space ends up being
per-cpu", and then you have to get the vmalloc space right etc, so you
have that one PGE entry for the kernel mapping that you can make be
percpu and play tricks in. So you'd basically allocate one page per
CPU for the magic upper PGD entry that maps the top 1GB, and edit that
on-the-fly as you do task-switching. Very specialized, and the upside
was very dubious.

And that "simple" trick is not really doable with the x86-64 model any
more (you can't copy 4kB efficiently the way you could copy 32 _bytes_
efficiently). And you really don't want to pre-allocate the whole
top-level PGD either. So all the things that made it "easy" for 32-bit
PAE basically went away with x86-64.

No, I think the only thing that would make it possible is if there is
some architecture extension that replaces part of the page table
mappings with a percpu MSR describing a magic mapping or two. It would
be trivial to do such an addition in hardware (it's not even in the
critical path, it would be just a new magic special case for the TLB
fill code), but without hardware support it's just not a good idea.

(And I'm not claiming that the hw extension for per-cpu mappigns would
be a good idea either, although I think it would be an _interesting_
toy to play with ;)

                     Linus
