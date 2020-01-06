From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH for 5.5 1/2] rseq: Fix: Clarify rseq.h UAPI rseq_cs
 memory reclaim requirements
Date: Mon, 6 Jan 2020 15:25:55 -0500 (EST)
Message-ID: <2129265980.1223.1578342355079.JavaMail.zimbra@efficios.com>
References: <20191220201207.17389-1-mathieu.desnoyers@efficios.com> <87imman36g.fsf@mid.deneb.enyo.de> <173832695.14381.1576875253374.JavaMail.zimbra@efficios.com> <875zian2a2.fsf@mid.deneb.enyo.de> <669061171.14506.1576876500152.JavaMail.zimbra@efficios.com> <1025393027.850.1578337717165.JavaMail.zimbra@efficios.com> <87a7709ydd.fsf@mid.deneb.enyo.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <87a7709ydd.fsf@mid.deneb.enyo.de>
Sender: stable-owner@vger.kernel.org
To: Florian Weimer <fw@deneb.enyo.de>, Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, paulmck <paulmck@linux.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>, Paul Turner <pjt@google.com>, linux-api <linux-api@vger.kernel.org>, stable <stable@vger.kernel.org>, Dmitry Vyukov <dvyukov@google.com>, Neel Natu <neelnatu@google.com>
List-Id: linux-api@vger.kernel.org

----- On Jan 6, 2020, at 2:30 PM, Florian Weimer fw@deneb.enyo.de wrote:

> * Mathieu Desnoyers:
> 
>> Just to clarify: should the discussion here prevent the UAPI
>> documentation change from being merged into the Linux kernel ? Our
>> discussion seems to be related to integration of rseq into glibc,
>> rather than the kernel UAPI per se.
> 
> I still think that clearing rseq_cs upon exit from the function that
> contains the sequence is good practice, and the UAPI header should
> mention that.

My understanding is that a UAPI header should document what is strictly
required (here, clearing rseq_cs before unmapping the memory area
containing the rseq_cs structure or the code). Documenting a "best
practice" would AFAIU belong to a man page and not a UAPI header.

I'm adding Michael Kerrisk in CC in case he has an opinion on this
matter.

> For glibc, if I recall correctly, we decided against doing anything in
> dlclose to deal with this issue (remapping new code in an existing
> rseq area) because it would need updating all threads, not just the
> thread calling dlclose.  That's why we're punting this to
> applications and why I think the UAPI header should mention this.

Nothing prevents us from implementing a clever scheme in the future,
e.g. as a new membarrier command, that could be invoked from dlclose()
when it becomes available.

By documenting only the basic requirement in the UAPI header (do not
use-after-free) and not providing a "best practice" (which is not so good
performance-wise), we can then let the man page state the best practices,
and update them as new system call commands are implemented.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
