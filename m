From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC PATCH for 4.18 12/23] cpu_opv: Provide cpu_opv system call
 (v7)
Date: Fri, 13 Apr 2018 14:06:27 -0400 (EDT)
Message-ID: <1111249972.9907.1523642787504.JavaMail.zimbra@efficios.com>
References: <20180412192800.15708-1-mathieu.desnoyers@efficios.com> <20180412192800.15708-13-mathieu.desnoyers@efficios.com> <CA+55aFxcJ2V_1BoW0Cct=Kkp7REkgiU_BTimGdmoFmWHaWaZ-g@mail.gmail.com> <1580648199.9463.1523563167045.JavaMail.zimbra@efficios.com> <CA+55aFwFUeNA6_0a1MOU-7VGzCw5T99cfVCPiyTpZQJdd6z=bw@mail.gmail.com> <625160026.9658.1523621809662.JavaMail.zimbra@efficios.com> <CA+55aFwXCnnfrOjPj5SB=G34xgveo1jqNyf23YNt6jOKX_VdGw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFwXCnnfrOjPj5SB=G34xgveo1jqNyf23YNt6jOKX_VdGw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Andrew Hunter <ahh@google.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@a>
List-Id: linux-api@vger.kernel.org

----- On Apr 13, 2018, at 12:37 PM, Linus Torvalds torvalds@linux-foundation.org wrote:

> On Fri, Apr 13, 2018 at 5:16 AM, Mathieu Desnoyers
> <mathieu.desnoyers@efficios.com> wrote:
>> The vmalloc space needed by cpu_opv is bound by the number of pages
>> a cpu_opv call can touch.
> 
> No it's not.
> 
> You can have a thousand different processes doing cpu_opv at the same time.
> 
> A *single* cpu_opv may me limited toi "only" a megabyte, but I'm not
> seeing any global limit anywhere.
> 
> In short, this looks like a guaranteed DoS approach to me.

Right, so one simple approach to solve this is to limit to the number
of concurrent cpu_opv executed at any given time.

Considering that cpu_opv is a slow path, we can limit the number
of concurrent cpu_opv executions by protecting this with a global
mutex, or a semaphore if we want the number of concurrent executions
to be greater than 1.

Another approach if we want to be fancier is to keep track of the
amount of vma address space currently used by all in-flight cpu_opv.
Beyond a given threshold, further execution of additional cpu_opv
instances would block, awaiting to be woken up when vmalloc address
space is freed when in-flight cpu_opv complete.

What global vmalloc address-space budget should we aim for ?

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
