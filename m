From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [PATCH] x86,seccomp,prctl: Remove PR_TSC_SIGSEGV and seccomp TSC filtering
Date: Fri, 3 Oct 2014 13:22:22 -0700
Message-ID: <CALCETrVvFP66s5XOmSKaC8Vq73=uh11819HOOLkVTu7jJZotew@mail.gmail.com>
References: <fc0c2447cbc39257941c6b118388c024b719353a.1412356529.git.luto@amacapital.net>
 <CALCETrUfCrvidOS6VvUpWFAcHUrPUs58zSQqGRC5UOTS=E37rw@mail.gmail.com> <20141003201409.GM10583@worktop.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141003201409.GM10583-IIpfhp3q70z/8w/KjCw3T+5/BudmfyzbbVWyRVo5IupeoWH0uzbU5w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Erik Bosman <ebn310-vHs5IaWfoDhmR6Xm/wNWPw@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michael Kerrisk-manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Oct 3, 2014 at 1:14 PM, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
> On Fri, Oct 03, 2014 at 10:27:47AM -0700, Andy Lutomirski wrote:
>> [adding linux-api.  whoops.]
>>
>> On Fri, Oct 3, 2014 at 10:18 AM, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> wrote:
>> > PR_SET_TSC / PR_TSC_SIGSEGV is a security feature to prevent heavily
>> > sandboxed programs from learning the time, presumably to avoid
>> > disclosing the wall clock and to make timing attacks much harder to
>> > exploit.
>> >
>> > Unfortunately, this feature is very insecure, for multiple reasons,
>> > and has probably been insecure since before it was written.
>> >
>> > Weakness 1: Before Linux 3.16, the vvar page and the HPET (!) were
>> > part of the kernel's fixmap, so any user process could read them.
>> > The vvar page contains low-resolution timing information (with real
>> > wall clock and frequency data), and the HPET can be used for high
>> > precision timing.  Even in Linux 3.16, there clean way to disable
>> > access to these pages.
>> >
>> > Weakness 2: On most configurations, most or all userspace processes
>> > have unrestricted access to RDPMC, which is even better than RDTSC
>> > for exploiting timing attacks.
>> >
>> > I would like to fix both of these issues.  I want to deny access to
>> > RDPMC to processes that haven't asked for access via
>> > perf_event_open.  I also want to implement real TSC blocking, which
>> > will require some vdso enhancements
>
> So the problem with the default deny is that its:
>  1) pointless -- the attacker can do sys_perf_event_open() just fine;

Not if the attacker is in a seccomp sandbox.

>  2) and expensive -- the people trying to measure performance get the
>     penalty of the CR4 write.

Does this matter for performance measuring?  I'm not 100% clear on how all
the perf_event stuff gets used in practice, but, by my very vague
understanding, there are two main workflows:

a) perf record, etc: one process creates a ringbuffer and wakes up
rarely to record the contents.  The process being recorded doesn't
have a perf_event mapped, so the cr4 switch will only happen when
waking up the perf process.

perf record prints stuff like "[ perf record: Woken up 1 times to
write data ]", which seems to confirm my understanding.

b) self-monitoring.  A task mmaps a perf_event, does rdpmc, does
something, and does rdpmc again.  In that case, there's no context
switch.

>
> So I would suggest a default on, but allow a disable for the seccomp
> users, which might have also disabled the syscall. Note that is is
> possible to disable RDPMC while still allowing the syscall.

Disabling RDPMC per-process while still allowing the syscall will need
a bunch of work, right?  What happens if the same perf_event is mapped
by two different users?

We could make the rule be that RDPMC is enabled if a perf event is
mmapped or TIF_SECCOMP is clear, but I'd prefer to be convinced that
there's an actual performance issue first.  Ideally we can get this
all working with no API or ABI change at all.

P.S. Hey, Intel, let us context switch RDPMC accessibility of the
individual counters, please :)

--Andy
