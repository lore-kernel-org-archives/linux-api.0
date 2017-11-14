From: Avi Kivity <avi@scylladb.com>
Subject: Re: [RFC PATCH 0/2] x86: Fix missing core serialization on migration
Date: Tue, 14 Nov 2017 19:03:26 +0200
Message-ID: <98b50de6-4cb1-9c43-4353-9ee7135dc63f@scylladb.com>
References: <20171110211249.10742-1-mathieu.desnoyers@efficios.com>
 <CA+55aFzbroWqi+FTdYhRVSwUZ-M0wDVxjXqDbh40JEnXc2LdgQ@mail.gmail.com>
 <885227610.13045.1510351034488.JavaMail.zimbra@efficios.com>
 <617343212.13932.1510592207202.JavaMail.zimbra@efficios.com>
 <4d47fbb8-8f99-19d3-a9cf-66841aeffac3@scylladb.com>
 <4431530.14831.1510672632887.JavaMail.zimbra@efficios.com>
 <20171114160541.GC3165@worktop.lehotels.local>
 <20171114160842.GH3857@worktop>
 <798843926.14994.1510678155257.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <798843926.14994.1510678155257.JavaMail.zimbra@efficios.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andrew Hunter <ahh@google.com>, maged michael <maged.michael@gmail.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, Dave Watson <davejwatson@fb.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Andrea Parri <parri.andrea@gmail.com>, "Russell King, ARM Linux" <linux@armlinux.org.uk>, Greg Hackmann <ghackmann@google.com>, Will Deacon <will.deacon@arm.com>
List-Id: linux-api@vger.kernel.org



On 11/14/2017 06:49 PM, Mathieu Desnoyers wrote:
> ----- On Nov 14, 2017, at 11:08 AM, Peter Zijlstra peterz@infradead.org wrote:
>
>> On Tue, Nov 14, 2017 at 05:05:41PM +0100, Peter Zijlstra wrote:
>>> On Tue, Nov 14, 2017 at 03:17:12PM +0000, Mathieu Desnoyers wrote:
>>>> I've tried to create a small single-threaded self-modifying loop in
>>>> user-space to trigger a trace cache or speculative execution quirk,
>>>> but I have not succeeded yet. I suspect that I would need to know
>>>> more about the internals of the processor architecture to create the
>>>> right stalls that would allow speculative execution to move further
>>>> ahead, and trigger an incoherent execution flow. Ideas on how to
>>>> trigger this would be welcome.
>>> I thought the whole problem was per definition multi-threaded.
>>>
>>> Single-threaded stuff can't get out of sync with itself; you'll always
>>> observe your own stores.
>> And even if you could, you can always execute a local serializing
>> instruction like CPUID to force things.
> What I'm trying to reproduce is something that breaks in single-threaded
> case if I explicitly leave out the CPUID core serializing instruction
> when doing code modification on upcoming code, in a loop.
>
> AFAIU, Intel requires a core serializing instruction to be issued even
> in single-threaded scenarios between code update and execution, to ensure
> that speculative execution does not observe incoherent code. Now the
> question we all have for Intel is: is this requirement too strong, or
> required by reality ?
>

In single-threaded execution, a jump is enough.

"As processor microarchitectures become more complex and start to 
speculatively execute code ahead of the retire-
ment point (as in P6 and more recent processor families), the rules 
regarding which code should execute, pre- or
post-modification, become blurred. To write self-modifying code and 
ensure that it is compliant with current and
future versions of the IA-32 architectures, use one of the following 
coding options:

(* OPTION 1 *)
Store modified code (as data) into code segment;
Jump to new code or an intermediate location;
Execute new code;"
