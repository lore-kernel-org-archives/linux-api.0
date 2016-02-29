From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v4 1/5] getcpu_cache system call: cache CPU number of
 running thread
Date: Mon, 29 Feb 2016 11:01:10 +0100
Message-ID: <20160229100110.GH6356@twins.programming.kicks-ass.net>
References: <alpine.DEB.2.11.1602261719440.3638@nanos>
 <967083634.8940.1456507201156.JavaMail.zimbra@efficios.com>
 <alpine.DEB.2.11.1602261855100.3638@nanos>
 <724964987.9217.1456518255392.JavaMail.zimbra@efficios.com>
 <7096DA23-3908-40DC-A46B-C4CF2252CEE8@zytor.com>
 <1150363257.9781.1456533630895.JavaMail.zimbra@efficios.com>
 <56D14132.5050100@zytor.com>
 <2053850250.10158.1456582501604.JavaMail.zimbra@efficios.com>
 <20160227145809.GD6356@twins.programming.kicks-ass.net>
 <CA+55aFysWipEagSdgeXbLx+Au4vomvyttdNFJtM+HffmBECQiA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CA+55aFysWipEagSdgeXbLx+Au4vomvyttdNFJtM+HffmBECQiA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Sat, Feb 27, 2016 at 10:35:28AM -0800, Linus Torvalds wrote:
> On Sat, Feb 27, 2016 at 6:58 AM, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
> >
> > Paul's patches have the following structure:
> >
> > struct thread_local_abi {
> >         union {
> >                 struct {
> >                         u32     cpu_id;
> >                         u32     seq;
> >                 };
> >                 u64 cpu_seq;
> >         };
> >         unsigned long post_commit_ip;
> > };
> 
> Please don't do "unsigned long" in ABI structures any more.
> 
> Make it u64, and make sure it is 64-bit aligned (which it would be in
> this case). Make it so that we don't have to have separate compat
> paths.

Yes, for sure. I was 'only' trying to reflect the state of the last rseq
patches. But yes, I should have called that out and avoided 'confusion'.
