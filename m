From: Florian Weimer <fweimer@redhat.com>
Subject: Re: [RFC PATCH v6 1/5] Thread-local ABI system call: cache CPU number
 of running thread
Date: Thu, 7 Apr 2016 11:01:25 +0200
Message-ID: <570621E5.7060306@redhat.com>
References: <1459789313-4917-1-git-send-email-mathieu.desnoyers@efficios.com>
 <1459789313-4917-2-git-send-email-mathieu.desnoyers@efficios.com>
 <5702A037.60200@zytor.com>
 <492303698.44994.1459799188052.JavaMail.zimbra@efficios.com>
 <856357054.45028.1459802903401.JavaMail.zimbra@efficios.com>
 <5703E191.2040707@redhat.com>
 <20160405164722.GB3430@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160405164722.GB3430@twins.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, "H. Peter Anvin" <hpa@zytor.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, linux-api <linux-api@vger.kernel.org>, Paul Turner <pjt@google.com>, Andrew Hunter <ahh@google.com>, Andy Lutomirski <luto@amacapital.net>, Andi Kleen <andi@firstfloor.org>, Dave Watson <davejwatson@fb.com>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Boqun Feng <boqun.feng@gmail.com>
List-Id: linux-api@vger.kernel.org

On 04/05/2016 06:47 PM, Peter Zijlstra wrote:
> On Tue, Apr 05, 2016 at 06:02:25PM +0200, Florian Weimer wrote:
>> On 04/04/2016 10:48 PM, Mathieu Desnoyers wrote:
>>
>>> Moreover, the feature set that the application knows about, glibc
>>> knows about, and the kernel knows about are three different things.
>>> My intent here is to have glibc stay out of the way as much as possible,
>>> since this is really an interface between various applications/libraries
>>> and the kernel.
>>
>> Surely glibc can allocate the space based on what is advertised as
>> needed by the kernel?  Why would it limit itself to what is supported by
>> the kernel headers it is compiled against if the actual size can be
>> queried from the kernel?
> 
> I guess the question is; can we do thread local variable arrays like:
> 
>   __thread uint32_t[x]; /* with x being a runtime constant */
> 
> Because then we can do:
> 
>   __thread struct thread_local_abi tla;
> 
> where sizeof(struct thread_local_abi) is a runtime variable.

It's slightly complicated.  ELF TLS in the GNU ABI will give you a
static offset only with static linking.

> Without that we cannot have this thread-local-abi structure be part of
> the immediately addressable TLS space. That is, we then need a pointer
> like:
> 
>   __thread struct thread_local_abi *tla;
> 
> and every usage will need the extra pointer deref.

The offset relative to the base will be dynamic anyway and need an extra
load (which can be hoisted out of loops etc., but it's still there in
some case).

> Because ideally this structure would be part of the initial (glibc) TCB
> with fixed offset etc.

This is not possible because we have layering violations and code
assumes it knows the precise of the glibc TCB.  I think Address
Sanitizer is in this category.  This means we cannot adjust the TCB size
based on the kernel headers used to compile glibc, and there will have
to be some indirection.

Florian
