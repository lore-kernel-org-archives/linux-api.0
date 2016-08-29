From: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
Subject: Re: [RFC PATCH v8 1/9] Restartable sequences system call
Date: Mon, 29 Aug 2016 09:10:24 -0700
Message-ID: <20160829161023.snsjfsudoxzwosvj@x>
References: <1471637274-13583-1-git-send-email-mathieu.desnoyers@efficios.com>
 <1471637274-13583-2-git-send-email-mathieu.desnoyers@efficios.com>
 <CA+55aFz+Q33m1+ju3ANaznBwYCcWo9D9WDr2=p0YLEF4gJF12g@mail.gmail.com>
 <545371402.19191.1472144912215.JavaMail.zimbra@efficios.com>
 <1BD94294-23AD-40CC-8227-43AE1AD8092F@fb.com>
 <20160827042226.akfaq4wku2gdpxsi@x>
 <91715400.22162.1472483812389.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <91715400.22162.1472483812389.JavaMail.zimbra-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Cc: Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will
List-Id: linux-api@vger.kernel.org

On Mon, Aug 29, 2016 at 03:16:52PM +0000, Mathieu Desnoyers wrote:
> ----- On Aug 27, 2016, at 12:22 AM, Josh Triplett josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org wrote:
> > Ben, Mathieu, Dave, do you have jemalloc benchmark numbers with and
> > without rseq?  (As well as memory usage numbers for the reduced memory
> > usage of per-CPU pools rather than per-thread pools?)
> 
> Before I started reimplementing rseq, the numbers presented by Facebook
> at https://lkml.org/lkml/2015/10/22/588 were in my opinion a good proof
> that rseq is useful. I'm not sure if their memoryidler API was used back
> then.
> 
> I could take Dave's jemalloc branch adapted to Paul Turner's rseq and
> adapt it to mine. Then we could use this allocator to compare the
> memory use and speed of heavily multi-threaded applications.
> 
> Thoughts ?

That seems like it would provide a good concrete benchmark of this work,
and demonstrate the value of it.
