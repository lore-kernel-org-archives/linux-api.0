From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [RFC PATCH] percpu system call: fast userspace percpu critical sections
Date: Tue, 26 May 2015 14:44:06 -0700
Message-ID: <CALCETrX4y2_cPdPHsr=iqcqS7k3GvBz7yBGb_d4A0wDUzbTWCg@mail.gmail.com>
References: <1432219487-13364-1-git-send-email-mathieu.desnoyers@efficios.com>
 <757752240.6470.1432330487312.JavaMail.zimbra@efficios.com>
 <CALCETrUxp-dP-kaTy4prEdciM-=sTXjpqnMbkvk38g5BTEvX0g@mail.gmail.com>
 <1839774559.6579.1432400944032.JavaMail.zimbra@efficios.com>
 <CALCETrWzoFX7hXqvQqDEq=r=7PNaGKVjZeHEBWxPvC28Zi1AKA@mail.gmail.com>
 <1184354091.7499.1432578613872.JavaMail.zimbra@efficios.com>
 <CALCETrW3_Hv0jc3cpiwsHTinBqJzvab_EiPS8BVJhX-xe5D8qw@mail.gmail.com>
 <CALCETrXzmO=fQC=UdCh5b0zWiGWAJScEtdT4QDJkoqLgtgEVig@mail.gmail.com>
 <821493560.8531.1432674243321.JavaMail.zimbra@efficios.com> <CALCETrXXtu1BNqQopd5eCfa6wE9O+001ofhjjsXUe2f9K_hj8g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrXXtu1BNqQopd5eCfa6wE9O+001ofhjjsXUe2f9K_hj8g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Andi Kleen <andi@firstfloor.org>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, Lai Jiangshan <laijs@cn.fujitsu.com>, Ben Maurer <bmaurer@fb.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Ingo Molnar <mingo@redhat.com>, Josh Triplett <josh@joshtriplett.org>, Andrew Morton <akpm@linux-foundation.org>, Michael Kerrisk <mtk.manpages@gmail.com>, Linux API <linux-api@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>, Paul Turner <pjt@google.com>, Peter Zijlstra <peterz@infradead.org>, Linus Torvalds <torvalds@linux-foundation.org>, Steven Rostedt <rostedt@goodmis.org>, Andrew Hunter <ahh@google.com>
List-Id: linux-api@vger.kernel.org

On Tue, May 26, 2015 at 2:18 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> On Tue, May 26, 2015 at 2:04 PM, Mathieu Desnoyers
>>
>>>
>>> It's too bad that not all architectures have a single-instruction
>>> unlocked compare-and-exchange.
>>
>> Based on my benchmarks, it's not clear that single-instruction
>> unlocked CAS is actually faster than doing the same with many
>> instructions.
>
> True, but with a single instruction the user can't get preempted in the middle.
>
> Looking at your code, it looks like percpu_user_sched_in has some
> potentially nasty issues with page faults.  Avoiding touching user
> memory from the scheduler would be quite nice from an implementation
> POV, and the x86-specific gs hack wins in that regard.

ARM has "TLB lockdown entries" which could, I think, be used to
implement per-cpu or per-thread mappings.  I'm actually rather
surprised that Linux doesn't already use a TLB lockdown entry for TLS.
(Hmm.  Maybe it's because the interface to write the entries requires
actually touching the page.  Maybe not -- the ARM docs, in general,
seem to be much less clear than the Intel and AMD docs.)

ARM doesn't seem to have any single-instruction compare-exchange or
similar instruction, though, so this might be all that useful.  On the
other hand, ARM can probably do reasonably efficient per-cpu memory
allocation and such with a single ldrex/strex pair.

--Andy
