From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH for 4.18 0/6] Restartable Sequences updates
Date: Mon, 9 Jul 2018 14:04:44 -0400 (EDT)
Message-ID: <2129841179.2387.1531159484965.JavaMail.zimbra@efficios.com>
References: <20180708210330.27324-1-mathieu.desnoyers@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180708210330.27324-1-mathieu.desnoyers@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Michael
List-Id: linux-api@vger.kernel.org

----- On Jul 8, 2018, at 5:03 PM, Mathieu Desnoyers mathieu.desnoyers@efficios.com wrote:

> Following the recent discussion thread [1] about rseq uapi, here is
> a set of updates submitted for integration into 4.18. Those change all
> rseq __get_user/__put_user for get_user/put_user as discussed.

Considering that ppc32 does not implement 64-bit get_user(), I will re-spin
the whole series using __copy_from_user/__copy_to_user() to replace
__get_user()/__put_user() to load/store the 64-bit rseq_cs field.

I'm aiming for a minimal change at this stage of the rc cycle.

Thanks,

Mathieu

> 
> Thanks,
> 
> Mathieu
> 
> [1]
> https://lkml.kernel.org/r/20180702223143.4663-1-mathieu.desnoyers@efficios.com
> 
> Mathieu Desnoyers (6):
>  rseq: use __u64 for rseq_cs fields, validate user inputs
>  rseq: use get_user/put_user rather than __get_user/__put_user
>  rseq: uapi: update uapi comments
>  rseq: uapi: declare rseq_cs field as union, update includes
>  rseq: remove unused types_32_64.h uapi header
>  rseq/selftests: cleanup: update comment above rseq_prepare_unload
> 
> include/uapi/linux/rseq.h           | 102 ++++++++++++++++++++----------------
> include/uapi/linux/types_32_64.h    |  50 ------------------
> kernel/rseq.c                       |  36 ++++++++-----
> tools/testing/selftests/rseq/rseq.h |  24 ++++++---
> 4 files changed, 97 insertions(+), 115 deletions(-)
> delete mode 100644 include/uapi/linux/types_32_64.h
> 
> --
> 2.11.0

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
