From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH] x86,seccomp,prctl: Remove PR_TSC_SIGSEGV and seccomp TSC filtering
Date: Mon, 6 Oct 2014 09:44:27 -0700
Message-ID: <CALCETrWhwO1ZfCdYbt48eZ=VZ9gPM7qiODPnhkYCPRMYk47U3Q@mail.gmail.com>
References: <fc0c2447cbc39257941c6b118388c024b719353a.1412356529.git.luto@amacapital.net>
 <CALCETrUfCrvidOS6VvUpWFAcHUrPUs58zSQqGRC5UOTS=E37rw@mail.gmail.com>
 <20141003201409.GM10583@worktop.programming.kicks-ass.net>
 <CALCETrVvFP66s5XOmSKaC8Vq73=uh11819HOOLkVTu7jJZotew@mail.gmail.com>
 <CALCETrWfrWpdMCAYySMAMGCHU3XRkNGmeMTECTE=PXQUfjGPZA@mail.gmail.com>
 <20141003204443.GP10583@worktop.programming.kicks-ass.net>
 <20141003210213.GG6324@worktop.programming.kicks-ass.net> <CALCETrW7OCuAiK31iRvXgXJfcf3FE4GKjpKQ0doWFyUpETzT9A@mail.gmail.com>
 <20141003211204.GQ10583@worktop.programming.kicks-ass.net>
 <CALCETrVtK6w4smnRCTED=csAyt3WNNOaZE_WRzvECuSx260X3w@mail.gmail.com> <20141004081324.GR10583@worktop.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20141004081324.GR10583@worktop.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>, Kees Cook <keescook@chromium.org>, Andrea Arcangeli <aarcange@redhat.com>, Erik Bosman <ebn310@few.vu.nl>, "H. Peter Anvin" <hpa@zytor.com>, Linux API <linux-api@vger.kernel.org>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, Paul Mackerras <paulus@samba.org>, Arnaldo Carvalho de Melo <acme@kernel.org>, X86 ML <x86@kernel.org>
List-Id: linux-api@vger.kernel.org

On Sat, Oct 4, 2014 at 1:13 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, Oct 03, 2014 at 02:15:24PM -0700, Andy Lutomirski wrote:
>> On Fri, Oct 3, 2014 at 2:12 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>> > On Fri, Oct 03, 2014 at 02:04:53PM -0700, Andy Lutomirski wrote:
>> >> On Fri, Oct 3, 2014 at 2:02 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>> >
>> >> > Something like so.. slightly less ugly and possibly with more
>> >> > complicated conditions setting the cr4 if you want to fix tsc vs seccomp
>> >> > as well.
>> >>
>> >> This will crash anything that tries rdpmc in an allow-everything
>> >> seccomp sandbox.  It's also not very compatible with my grand scheme
>> >> of allowing rdtsc to be turned off without breaking clock_gettime. :)
>> >
>> > Well, we clear cap_user_rdpmc, so everybody who still tries it gets what
>> > he deserves, no problem there.
>>
>> Oh, interesting.
>>
>> To continue playing devil's advocate, what if you do perf_event_open,
>> then mmap it, then start the seccomp sandbox?
>
> We update that cap bit on every update to the self-monitor state, and in
> a perfect world people would also check the cap bit every time they try
> and read it, and fall back to the syscall. So we could just clear it..
> but I can imagine reality ruining things here.

If nothing else, the fact that rdpmc fails with SIGSEGV instead of
with some nonsense value means that this will always be racy.

>
>> My draft patches are currently tracking the number of perf_event mmaps
>> per mm.  I'm not thrilled with it, but it's straightforward.  And I
>> still need to benchmark cr4 writes, which is tedious, because I can't
>> do it from user code.
>
> Should be fairly straight fwd from kernel space, get a tsc stamp,
> read+write cr4 1000 times, get another tsc read, and maybe do that
> several times. No?

I tried it.  Rough numbers on my 2.7 GHz Sandy Bridge laptop

Writing to cr4 in VMX non-root (changing PCE) takes ~48ns.  RMW cr4
takes rougly 51ns.  IMO neither of these is enough to be worth
worrying *that* much about when switching into or out of a perf-using
task.  But you might disagree with me.

Changing TSD takes 700ns, because KVM has the VMCS programmed wrong.
I'll send a patch.

I suspect that the same experiment on bare metal would run faster.


--Andy
