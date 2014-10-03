From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH] x86,seccomp,prctl: Remove PR_TSC_SIGSEGV and seccomp TSC
 filtering
Date: Fri, 3 Oct 2014 23:04:28 +0200
Message-ID: <20141003210428.GH6324@worktop.programming.kicks-ass.net>
References: <fc0c2447cbc39257941c6b118388c024b719353a.1412356529.git.luto@amacapital.net>
 <CALCETrUfCrvidOS6VvUpWFAcHUrPUs58zSQqGRC5UOTS=E37rw@mail.gmail.com>
 <20141003201409.GM10583@worktop.programming.kicks-ass.net>
 <CALCETrVvFP66s5XOmSKaC8Vq73=uh11819HOOLkVTu7jJZotew@mail.gmail.com>
 <CALCETrWfrWpdMCAYySMAMGCHU3XRkNGmeMTECTE=PXQUfjGPZA@mail.gmail.com>
 <20141003204443.GP10583@worktop.programming.kicks-ass.net>
 <20141003210213.GG6324@worktop.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20141003210213.GG6324-IIpfhp3q70z/8w/KjCw3T+5/BudmfyzbbVWyRVo5IupeoWH0uzbU5w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Erik Bosman <ebn310-vHs5IaWfoDhmR6Xm/wNWPw@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michael Kerrisk-manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Oct 03, 2014 at 11:02:13PM +0200, Peter Zijlstra wrote:
> @@ -1928,7 +1939,7 @@ void arch_perf_update_userpage(struct perf_event_mmap_page *userpg, u64 now)
>  
>  	userpg->cap_user_time = 0;
>  	userpg->cap_user_time_zero = 0;
> -	userpg->cap_user_rdpmc = x86_pmu.attr_rdpmc;
> +	userpg->cap_user_rdpmc = x86_pmu.attr_rdpmc && test_thread_flag(TIF_SECCOMP);

&& !test_thread_flag(TIF_SECCOMP) would probably work better

>  	userpg->pmc_width = x86_pmu.cntval_bits;
>  
>  	if (!sched_clock_stable())
