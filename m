From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH] x86,seccomp,prctl: Remove PR_TSC_SIGSEGV and seccomp TSC
 filtering
Date: Fri, 3 Oct 2014 22:42:56 +0200
Message-ID: <20141003204256.GO10583@worktop.programming.kicks-ass.net>
References: <fc0c2447cbc39257941c6b118388c024b719353a.1412356529.git.luto@amacapital.net>
 <CALCETrUfCrvidOS6VvUpWFAcHUrPUs58zSQqGRC5UOTS=E37rw@mail.gmail.com>
 <20141003201409.GM10583@worktop.programming.kicks-ass.net>
 <CALCETrVvFP66s5XOmSKaC8Vq73=uh11819HOOLkVTu7jJZotew@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALCETrVvFP66s5XOmSKaC8Vq73=uh11819HOOLkVTu7jJZotew-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Erik Bosman <ebn310-vHs5IaWfoDhmR6Xm/wNWPw@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michael Kerrisk-manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Oct 03, 2014 at 01:22:22PM -0700, Andy Lutomirski wrote:
> > So the problem with the default deny is that its:
> >  1) pointless -- the attacker can do sys_perf_event_open() just fine;
> 
> Not if the attacker is in a seccomp sandbox.

Clearly :-)

> >  2) and expensive -- the people trying to measure performance get the
> >     penalty of the CR4 write.
> 
> Does this matter for performance measuring?  I'm not 100% clear on how all
> the perf_event stuff gets used in practice, but, by my very vague
> understanding, there are two main workflows:
> 
> a) perf record, etc: one process creates a ringbuffer and wakes up
> rarely to record the contents.  The process being recorded doesn't
> have a perf_event mapped, so the cr4 switch will only happen when
> waking up the perf process.
> 
> perf record prints stuff like "[ perf record: Woken up 1 times to
> write data ]", which seems to confirm my understanding.
> 
> b) self-monitoring.  A task mmaps a perf_event, does rdpmc, does
> something, and does rdpmc again.  In that case, there's no context
> switch.

Agreed, but with the default disable, the self-monitoring task will get
CR4 writes to its context switches and will be slower.

Whereas if we default on and only disable with seccomp then only the
seccomp tasks will suffer the burden of a CR4 write at context switch
time.

And I don't see a security implication in the default.

> > So I would suggest a default on, but allow a disable for the seccomp
> > users, which might have also disabled the syscall. Note that is is
> > possible to disable RDPMC while still allowing the syscall.
> 
> Disabling RDPMC per-process while still allowing the syscall will need
> a bunch of work, right? 

Not much, all you need to do is make
perf_event_mmmap_page::cap_user_rdpmc be 0 and userspace should never
use rdpmc. Currently we set that bit based on the global sysfs rdpmc
value, but we could easy bitwise AND it with a per process value.

> What happens if the same perf_event is mapped
> by two different users?

Not entirely clear on what you mean here.

> We could make the rule be that RDPMC is enabled if a perf event is
> mmapped or TIF_SECCOMP is clear, but I'd prefer to be convinced that
> there's an actual performance issue first.  Ideally we can get this
> all working with no API or ABI change at all.

Well I just want to not have extra CR4 writes by default (and by default
I don't care about seccomp).

> P.S. Hey, Intel, let us context switch RDPMC accessibility of the
> individual counters, please :)

Ha sure, make it more complicated why don't you ;-) But yes, that has
come up before.
