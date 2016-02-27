From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH v4 1/5] getcpu_cache system call: cache CPU number of
 running thread
Date: Sat, 27 Feb 2016 23:53:56 +0000 (UTC)
Message-ID: <1401667361.10273.1456617236327.JavaMail.zimbra@efficios.com>
References: <1456270120-7560-1-git-send-email-mathieu.desnoyers@efficios.com> <724964987.9217.1456518255392.JavaMail.zimbra@efficios.com> <7096DA23-3908-40DC-A46B-C4CF2252CEE8@zytor.com> <1150363257.9781.1456533630895.JavaMail.zimbra@efficios.com> <56D14132.5050100@zytor.com> <2053850250.10158.1456582501604.JavaMail.zimbra@efficios.com> <20160227145809.GD6356@twins.programming.kicks-ass.net> <CA+55aFysWipEagSdgeXbLx+Au4vomvyttdNFJtM+HffmBECQiA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFysWipEagSdgeXbLx+Au4vomvyttdNFJtM+HffmBECQiA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, Paul Turner <pjt@google.com>, Andrew Hunter <ahh@google.com>, Andy Lutomirski <luto@amacapital.net>, Andi Kleen <andi@firstfloor.org>, Dave Watson <davejwatson@fb.com>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Josh Triplett <josh@joshtriplett.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Michael Kerrisk <mtk.manpages@gmail.com>
List-Id: linux-api@vger.kernel.org

----- On Feb 27, 2016, at 1:35 PM, Linus Torvalds torvalds@linux-foundation.org wrote:

> On Sat, Feb 27, 2016 at 6:58 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>>
>> Paul's patches have the following structure:
>>
>> struct thread_local_abi {
>>         union {
>>                 struct {
>>                         u32     cpu_id;
>>                         u32     seq;
>>                 };
>>                 u64 cpu_seq;
>>         };
>>         unsigned long post_commit_ip;
>> };
> 
> Please don't do "unsigned long" in ABI structures any more.
> 
> Make it u64, and make sure it is 64-bit aligned (which it would be in
> this case). Make it so that we don't have to have separate compat
> paths.

AFAIU, this "post_commit_ip" field is expected to be updated
with a single-copy-store by user-space. If we want to handle both
32-bit and 64-bit processes, how do you recommend doing this
without an unsigned long type ?

A 64-bit integer would not be a single-copy store for
32-bit processes, but a 32-bit integer would not be large
enough for 64-bit processes.

Would a

union {
    uint32_t val32;
    uint64_t val64;
} field;

be an acceptable option ? Then the kernel could use
one field or the other depending on the process bitness.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
