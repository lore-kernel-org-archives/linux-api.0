From: Dmitry Safonov <0x7f454c46@gmail.com>
Subject: Re: [PATCHv6 23/36] x86/vdso: Allocate timens vdso
Date: Mon, 19 Aug 2019 15:15:47 +0100
Message-ID: <37f08bfa-0ef8-6df9-e119-e010cdeb9a5a@gmail.com>
References: <20190815163836.2927-1-dima@arista.com>
 <20190815163836.2927-24-dima@arista.com>
 <b719199a-ed91-610b-38bc-015a0749f600@kernel.org>
 <alpine.DEB.2.21.1908162208190.1923@nanos.tec.linutronix.de>
 <483678c7-7687-5445-f09e-e45e9460d559@gmail.com>
 <alpine.DEB.2.21.1908171709360.1923@nanos.tec.linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.21.1908171709360.1923@nanos.tec.linutronix.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>, Andy Lutomirski <luto@kernel.org>
Cc: Dmitry Safonov <dima@arista.com>, linux-kernel@vger.kernel.org, Adrian Reber <adrian@lisas.de>, Andrei Vagin <avagin@openvz.org>, Arnd Bergmann <arnd@arndb.de>, Christian Brauner <christian.brauner@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, "Eric W. Biederman" <ebiederm@xmission.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jann Horn <jannh@google.com>, Jeff Dike <jdike@addtoit.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Shuah Khan <shuah@kernel.org>, Vincenzo Frascino <vincenzo.frascino@arm.com>, containers@lists.linux-foundation.org, criu@openvz.org, linux-api@vger.kernel.org, x86@kernel.org
List-Id: linux-api@vger.kernel.org

Hi Thomas,

On 8/18/19 5:21 PM, Thomas Gleixner wrote:
[..]
> I'm happy to review well written stuff which makes progress and takes
> review comments into account or the submitter discusses them for
> resolution.

Thanks again for both your and Andy time!

[..]
> Coming back to Andy's idea. Create your time namespace page as an exact
> copy of the vdso data page. When the page is created do:
> 
>      	 memset(p->vdso_data, 0, sizeof(p->vdso_data));
>      	 p->vdso_data[0].clock_mode = CLOCK_TIMENS;
> 	 p->vdso_data[0].seq = 1;
>  
> 	 /* Store the namespace offsets in basetime */
> 	 p->vdso_data[0].basetime[CLOCK_MONOTONIC].sec = myns->mono_sec;
> 	 p->vdso_data[0].basetime[CLOCK_MONOTONIC].nsec = myns->mono_nsec;
> 	 p->vdso_data[0].basetime[CLOCK_BOOTTIME].sec = myns->boot_sec;
> 	 p->vdso_data[0].basetime[CLOCK_BOOTTIME].nsec = myns->boot_nsec;
> 
>      	 p->vdso_data[1].clock_mode = CLOCK_TIMENS;
> 	 p->vdso_data[1].seq = 1;
> 
> For a normal task the VVAR pages are installed in the normal ordering:
> 
>        VVAR
>        PVCLOCK
>        HVCLOCK
>        TIMENS	<- Not really required
> 
> Now for a timens task you install the pages in the following order
> 
>        TIMENS
>        PVCLOCK
>        HVCLOCK
>        VVAR
> 
> The check for vdso_data->clock_mode is in the unlikely path of the now open
> coded seq begin magic. So for the non-timens case most of the time 'seq' is
> even, so the branch is not taken.
> 
> If 'seq' is odd, i.e. a concurrent update is in progress, the extra check
> for vdso_data->clock_mode is a non-issue. The task is spin waiting for the
> update to finish and for 'seq' to become even anyway.
> 
> Patch below. I tested this with the normal order and by installing a
> 'timens' page unconditionally for all processes. I'll reply with the timens
> testing hacks so you can see what I did.
> 
> The test results are pretty good.
> 
>     	 	 Base (upstream)  + VDSO patch	+ timens page
> 
> MONO		 30ns 		    30ns 	  32ns
> REAL		 30ns		    30ns	  32ns
> BOOT		 30ns		    30ns	  32ns
> MONOCOARSE	  7ns		     8ns	  10ns
> REALCOARSE	  7ns		     8ns	  10ns
> TAI		 30ns		    30ns	  32ns
> MONORAW		 30ns		    30ns	  32ns
> 
> So except for the coarse clocks there is no change when the timens page is
> not used, i.e. the regular VVAR page is at the proper place. But that's on
> one machine, a different one showed an effect in the noise range. I'm not
> worried about that as the VDSO behaviour varies depending on micro
> architecture anyway.
> 
> With timens enabled the performance hit (cache hot microbenchmark) is
> somewhere in the range of 5-7% when looking at the perf counters
> numbers. The hit for the coarse accessors is larger obviously because the
> overhead is constant time.
> 
> I did a quick comparison of the array vs. switch case (what you used for
> your clk_to_ns() helper). The switch case is slower.
> 
> So I rather go for the array based approach. It's simpler code and the
> I-cache footprint is smaller and no conditional branches involved.
> 
> That means your timens_to_host() and host_to_timens() conversion functions
> should just use that special VDSO page and do the same array based
> unconditional add/sub of the clock specific offset.

I was a bit scarred that clock_mode change would result in some complex
logic, but your patch showed me that it's definitely not so black as I
was painting it.
Will rework the patches set with Andrei based on your and Andy's
suggestions and patches.

Thanks,
          Dmitry
