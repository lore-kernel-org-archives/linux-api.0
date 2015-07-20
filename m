From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC PATCH] getcpu_cache system call: caching current CPU number (x86)
Date: Mon, 20 Jul 2015 15:39:41 -0700
Message-ID: <CA+55aFwLZLeeN7UN82dyt=emQcNBc8qZPJAw5iqtAbBwFA7FPQ@mail.gmail.com>
References: <1436724386-30909-1-git-send-email-mathieu.desnoyers@efficios.com>
	<5CDDBDF2D36D9F43B9F5E99003F6A0D48D5F39C6@PRN-MBX02-1.TheFacebook.com>
	<587954201.31.1436808992876.JavaMail.zimbra@efficios.com>
	<5CDDBDF2D36D9F43B9F5E99003F6A0D48D5F5DA0@PRN-MBX02-1.TheFacebook.com>
	<549319255.383.1437070088597.JavaMail.zimbra@efficios.com>
	<CALCETrWEKE=mow3vVh7C4r8CuGy_d5VOEz7KkpijuR5cpBfFtg@mail.gmail.com>
	<CA+55aFz-VBnEKh0SPKgu8xV5=Zb+=6odybVUDoOYOknshbcFJA@mail.gmail.com>
	<20150717232836.GA13604@domone>
	<CALCETrVY=kjeA_4pazy3BL+ekfcV6WHKw8e3z-LBxx_uP1bw2Q@mail.gmail.com>
	<55ACB2DC.5010503@redhat.com>
	<CALCETrV9Vp5UUOb3e_R5tphyE-urBgTwQR2pFWUOOFnHqWXHKQ@mail.gmail.com>
	<55AD14A4.6030101@redhat.com>
	<CALCETrUx6wFxmz+9TyW5bNgaMN0q180G8y9YOyq_D41sdhFaRQ@mail.gmail.com>
	<CA+55aFzMJkzydXb7uVv1iSUnp=539d43ghQaonGdzMoF7QLZBA@mail.gmail.com>
	<CALCETrUZ8vB30rdmeoV4JKPUsRnVPvoxXRJ47CEFud2aSF2=Ew@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <libc-alpha-return-61168-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
In-Reply-To: <CALCETrUZ8vB30rdmeoV4JKPUsRnVPvoxXRJ47CEFud2aSF2=Ew@mail.gmail.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Ben Maurer <bmaurer@fb.com>, Ingo Molnar <mingo@redhat.com>, libc-alpha <libc-alpha@sourceware.org>, Andrew Morton <akpm@linux-foundation.org>, linux-api <linux-api@vger.kernel.org>, =?UTF-8?B?T25kxZllaiBCw61sa2E=?= <neleai@seznam.cz>, rostedt <rostedt@goodmis.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Florian Weimer <fweimer@redhat.com>, Josh Triplett <josh@joshtriplett.org>, Lai Jiangshan <laijs@cn.fujitsu.com>, Paul Turner <pjt@google.com>, Andrew Hunter <ahh@google.com>, Peter Zijlstra <peterz@infradead.org>
List-Id: linux-api@vger.kernel.org

On Mon, Jul 20, 2015 at 2:09 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>
> Annoying problem one: the segment base field is only 32 bits in the GDT.

Ok. So if we go this way, we'd make the rule be something like "the
segment base is the CPU number shifted up by the page size", and then
you'd have to add some magic offset that we'd declare as the "per-cpu
page offset".

>> - user space can just load the segment selector in %gs
>
> IIRC this is very expensive -- 40 cycles or so.  At this point
> userspace might as well just use a real lock cmpxchg.

So cmpxchg may be as many cycles, but

 (a) you can choose to load the segment just once, and do several
operations with it

 (b) often - but admittedly not always - the real cost of a
non-cpu-local local and cmpxchg tends to be the cacheline ping-pong,
not the CPU cycles.

so I agree, loading a segment isn't free. But it's not *that*
expensive, and you could always decide to keep the segment loaded and
just do

 - read segment selector
 - if NUL segment, reload it.

although that only works if you own the segment entirely and can keep
it as the percpu segment (ie obviously not the Wine case, for
example).

> Does it solve the Wine problem?  If Wine uses gs for something and
> calls a function that does this, Wine still goes boom, right?

So the advantage of just making a global segment descriptor available
is that it's not *that* expensive to just save/restore segments. So
either wine could do it, or any library users would do it.

But anyway, I'm not sure this is a good idea. The advantage of it is
that the kernel support really is _very_ minimal.

                 Linus
