From: Chris Metcalf <cmetcalf@ezchip.com>
Subject: Re: [PATCH 5/6] nohz: support PR_DATAPLANE_STRICT mode
Date: Fri, 15 May 2015 17:25:10 -0400
Message-ID: <55566436.40002@ezchip.com>
References: <1431107927-13998-1-git-send-email-cmetcalf@ezchip.com> <1431107927-13998-6-git-send-email-cmetcalf@ezchip.com> <CALCETrUoptUPVUxL87jUgry1pFac0rDPpnZ790zDKyK4a0FARA@mail.gmail.com> <5550FF63.1030107@ezchip.com> <CALCETrW8aNOZmNKx8P=mCD2iZmjxjDFzZH4Yzmh5im9Werzw9g@mail.gmail.com> <55526B39.10208@ezchip.com> <CALCETrXVLGi=DSHza2fCXDNbkh_MOAbxQANNg738=AWVMsYPrw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrXVLGi=DSHza2fCXDNbkh_MOAbxQANNg738=AWVMsYPrw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Frederic Weisbecker <fweisbec@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Rik van Riel <riel@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Linux API <linux-api@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Tejun Heo <tj@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Steven Rostedt <rostedt@goodmis.org>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, Christoph Lameter <cl@linux.com>, Gilad Ben Yossef <giladb@ezchip.com>, Ingo Molnar <mingo@kernel.org>
List-Id: linux-api@vger.kernel.org

On 05/12/2015 06:23 PM, Andy Lutomirski wrote:
> On May 13, 2015 6:06 AM, "Chris Metcalf" <cmetcalf@ezchip.com> wrote:
>> On 05/11/2015 06:28 PM, Andy Lutomirski wrote:
>>> On Mon, May 11, 2015 at 12:13 PM, Chris Metcalf <cmetcalf@ezchip.com> wrote:
>>>> In this case, killing the task is appropriate, since that's exactly
>>>> the semantics that have been asked for - it's like on architectures
>>>> that don't natively support unaligned accesses, but fake it relatively
>>>> slowly in the kernel, and in development you just say "give me a
>>>> SIGBUS when that happens" and in production you might say
>>>> "fix it up and let's try to keep going".
>>> I think more control is needed.  I also think that, if we go this
>>> route, we should distinguish syscalls, synchronous non-syscall
>>> entries, and asynchronous non-syscall entries.  They're quite
>>> different.
>>
>> I don't think it's necessary to distinguish the types.  As long as we
>> have a PC pointing to the instruction that triggered the problem,
>> we can see if it's a system call instruction, a memory write that
>> caused a page fault, a trap instruction, etc.
> Not true.  PC right after a syscall insn could be any type of kernel
> entry, and you can't even reliably tell whether the syscall insn was
> executed or, on x86, whether it was a syscall at all.  (x86 insns
> can't be reliably decided backwards.)
>
> PC pointing at a load could be a page fault or an IPI.

All that we are trying to do with this API, though, is distinguish
synchronous faults.  So IPIs, etc., should not be happening
(they would be bugs), and hopefully we are mostly just
distinguishing different types of synchronous program entries.
That said, I did a si_info flag to differentiate syscalls from other
synchronous entries, and I'm open to looking at more such if
it seems useful.

> Again, though, I think we really do need to distinguish at least MCE 
> and NMI (on x86) from the others. 

Yes, those are both interesting cases, and I'm not entirely
sure what the right way to handle them is - for example,
likely disable STRICT if you are running with perf enabled.

I look forward to hearing more when you're back next week!

-- 
Chris Metcalf, EZChip Semiconductor
http://www.ezchip.com
