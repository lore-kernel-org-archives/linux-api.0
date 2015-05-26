From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFC PATCH] percpu system call: fast userspace percpu critical
 sections
Date: Tue, 26 May 2015 23:20:41 +0200
Message-ID: <20150526212041.GQ19417@two.firstfloor.org>
References: <1432219487-13364-1-git-send-email-mathieu.desnoyers@efficios.com>
 <CAHO5Pa0Kok4_QN0v3JNWyzGT=GbZNZcRyLhu02R2npV9hSdt7g@mail.gmail.com>
 <CALCETrUSBqHG3tbOq1yFz33v1_ckEgLNorgAxwLFi7MkjNcwLA@mail.gmail.com>
 <757752240.6470.1432330487312.JavaMail.zimbra@efficios.com>
 <CALCETrUxp-dP-kaTy4prEdciM-=sTXjpqnMbkvk38g5BTEvX0g@mail.gmail.com>
 <1839774559.6579.1432400944032.JavaMail.zimbra@efficios.com>
 <CALCETrWzoFX7hXqvQqDEq=r=7PNaGKVjZeHEBWxPvC28Zi1AKA@mail.gmail.com>
 <1184354091.7499.1432578613872.JavaMail.zimbra@efficios.com>
 <CALCETrW3_Hv0jc3cpiwsHTinBqJzvab_EiPS8BVJhX-xe5D8qw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALCETrW3_Hv0jc3cpiwsHTinBqJzvab_EiPS8BVJhX-xe5D8qw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>, Borislav Petkov <bp@alien8.de>, Lai Jiangshan <laijs@cn.fujitsu.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Ben Maurer <bmaurer@fb.com>, Josh Triplett <josh@joshtriplett.org>, Ingo Molnar <mingo@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Linux API <linux-api@vger.kernel.org>, Michael Kerrisk <mtk.manpages@gmail.com>, Linux Kernel <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Peter Zijlstra <peterz@infradead.org>, Paul Turner <pjt@google.com>, Steven Rostedt <rostedt@goodmis.org>, Andrew Hunter <ahh@google.com>
List-Id: linux-api@vger.kernel.org


I haven't thought too much about it, but doing it in a vdso seems
reasonable. It would mean that the scheduler hot path would
need to know about its address though.

> > You appear to summarize the two things that are added to the kernel with
> > this RFC patch:
> > - faster getcpu(): 12.7 ns -> 0.3 ns
> 
> Yeah, I figured that out the second time I read your email and re-read
> the original message, but I apparently forgot to fix up the email I
> was typing.

The high speed users seem to have all switched to using LSL directly,
which is even faster. Since there are already users it cannot be changed
anymore. Should probably just document this as an official ABI,
and provide some standard include file with inline code.

> IIRC some other OS's use gs as a userspace per-cpu pointer instead of
> a per-thread pointer.  Would we want to consider enabling that?
> This may interact oddly with the WIP wrgsbase stuff.  (Grr, Intel, why
> couldn't you have made wrgsbase reset the gs selector to zero?  That
> would have been so much nicer.)

Applications really want the extra address registers. For example
OpenJDK could free a GPR. And it's needed for the TLS of user space
threads, which are becoming more and more popular. So there are
already more important users queued.

-Andi


-- 
ak@linux.intel.com -- Speaking for myself only.
