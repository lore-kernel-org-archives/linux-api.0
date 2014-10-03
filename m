From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [PATCH] x86,seccomp,prctl: Remove PR_TSC_SIGSEGV and seccomp TSC filtering
Date: Fri, 3 Oct 2014 14:15:24 -0700
Message-ID: <CALCETrVtK6w4smnRCTED=csAyt3WNNOaZE_WRzvECuSx260X3w@mail.gmail.com>
References: <fc0c2447cbc39257941c6b118388c024b719353a.1412356529.git.luto@amacapital.net>
 <CALCETrUfCrvidOS6VvUpWFAcHUrPUs58zSQqGRC5UOTS=E37rw@mail.gmail.com>
 <20141003201409.GM10583@worktop.programming.kicks-ass.net>
 <CALCETrVvFP66s5XOmSKaC8Vq73=uh11819HOOLkVTu7jJZotew@mail.gmail.com>
 <CALCETrWfrWpdMCAYySMAMGCHU3XRkNGmeMTECTE=PXQUfjGPZA@mail.gmail.com>
 <20141003204443.GP10583@worktop.programming.kicks-ass.net>
 <20141003210213.GG6324@worktop.programming.kicks-ass.net> <CALCETrW7OCuAiK31iRvXgXJfcf3FE4GKjpKQ0doWFyUpETzT9A@mail.gmail.com>
 <20141003211204.GQ10583@worktop.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141003211204.GQ10583-IIpfhp3q70z/8w/KjCw3T+5/BudmfyzbbVWyRVo5IupeoWH0uzbU5w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Erik Bosman <ebn310-vHs5IaWfoDhmR6Xm/wNWPw@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michael Kerrisk-manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Oct 3, 2014 at 2:12 PM, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
> On Fri, Oct 03, 2014 at 02:04:53PM -0700, Andy Lutomirski wrote:
>> On Fri, Oct 3, 2014 at 2:02 PM, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
>
>> > Something like so.. slightly less ugly and possibly with more
>> > complicated conditions setting the cr4 if you want to fix tsc vs seccomp
>> > as well.
>>
>> This will crash anything that tries rdpmc in an allow-everything
>> seccomp sandbox.  It's also not very compatible with my grand scheme
>> of allowing rdtsc to be turned off without breaking clock_gettime. :)
>
> Well, we clear cap_user_rdpmc, so everybody who still tries it gets what
> he deserves, no problem there.

Oh, interesting.

To continue playing devil's advocate, what if you do perf_event_open,
then mmap it, then start the seccomp sandbox?

My draft patches are currently tracking the number of perf_event mmaps
per mm.  I'm not thrilled with it, but it's straightforward.  And I
still need to benchmark cr4 writes, which is tedious, because I can't
do it from user code.

--Andy
