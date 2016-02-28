From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH v4 1/5] getcpu_cache system call: cache CPU number of
 running thread
Date: Sat, 27 Feb 2016 16:57:32 -0800
Message-ID: <CA+55aFwZY1BR5NdjAP-rytd29hE2EZEXgcaBKjepWFFj+oR1SA@mail.gmail.com>
References: <1456270120-7560-1-git-send-email-mathieu.desnoyers@efficios.com>
	<1150363257.9781.1456533630895.JavaMail.zimbra@efficios.com>
	<56D14132.5050100@zytor.com>
	<2053850250.10158.1456582501604.JavaMail.zimbra@efficios.com>
	<20160227145809.GD6356@twins.programming.kicks-ass.net>
	<CA+55aFysWipEagSdgeXbLx+Au4vomvyttdNFJtM+HffmBECQiA@mail.gmail.com>
	<1401667361.10273.1456617236327.JavaMail.zimbra@efficios.com>
	<CA+55aFwcgwRxvVBz5kk_3O8dESXAGJ4KHBkf=pSXjiS7Xh4NwA@mail.gmail.com>
	<1082926946.10326.1456619994590.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1082926946.10326.1456619994590.JavaMail.zimbra-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Cc: Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Sat, Feb 27, 2016 at 4:39 PM, Mathieu Desnoyers
<mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org> wrote:
>
>
> I'm particularly interested to know what are the best practices to
> deal with an extensible bitfield (the features mask). cpu_set_t
> and sigmask each seem to do their own thing.

Quite frankly, why would the kernel ever touch anything else?

And if the kernel doesn't touch anything else, why make it part of the ABI?

I don't see why the kernel would ever want to have a more complex
interface. Explain.

           Linus
