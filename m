From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH v4 1/5] getcpu_cache system call: cache CPU number of
 running thread
Date: Sun, 28 Feb 2016 08:21:09 -0800
Message-ID: <CA+55aFzqW=5ewSW=Hz0YUb1ty8-dsXr_f14n+xxySVRPQRtq+w@mail.gmail.com>
References: <1456270120-7560-1-git-send-email-mathieu.desnoyers@efficios.com>
	<alpine.DEB.2.11.1602261719440.3638@nanos>
	<967083634.8940.1456507201156.JavaMail.zimbra@efficios.com>
	<alpine.DEB.2.11.1602261855100.3638@nanos>
	<724964987.9217.1456518255392.JavaMail.zimbra@efficios.com>
	<7096DA23-3908-40DC-A46B-C4CF2252CEE8@zytor.com>
	<1150363257.9781.1456533630895.JavaMail.zimbra@efficios.com>
	<56D14132.5050100@zytor.com>
	<2053850250.10158.1456582501604.JavaMail.zimbra@efficios.com>
	<20160227145809.GD6356@twins.programming.kicks-ass.net>
	<CA+55aFysWipEagSdgeXbLx+Au4vomvyttdNFJtM+HffmBECQiA@mail.gmail.com>
	<CAMuHMdV2dHsJfchyHBnQEAVEMSQ+1N7X4-iqGZ7K7J=Lf8qs4A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAMuHMdV2dHsJfchyHBnQEAVEMSQ+1N7X4-iqGZ7K7J=Lf8qs4A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Sun, Feb 28, 2016 at 5:07 AM, Geert Uytterhoeven
<geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org> wrote:
>
> __alignof__(u64) is not 8 on all architectures.

Indeed, which is why I said "make sure it's 64-bit aligned". We do it
manually for ABI structures (although we did have some discussion
about adding a alignment directive, and then having an explicitly
unaligned type for legacy cases that we got wrong).

In the above case it was already properly aligned, because the
previous structure members added up to 64-bit boundaries.

Of course, nothing then stops user space from giving us structures
that are unaligned to begin with, but that's not our problem. As long
as the layout is correct, we're fine, and that's all we care about.

              Linus
