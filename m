From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC PATCH for 4.17 02/21] rseq: Introduce restartable
 sequences system call (v12)
Date: Tue, 3 Apr 2018 12:36:27 -0400 (EDT)
Message-ID: <17439540.2334.1522773387555.JavaMail.zimbra@efficios.com>
References: <20180327160542.28457-1-mathieu.desnoyers@efficios.com> <20180327160542.28457-3-mathieu.desnoyers@efficios.com> <20180401171356.085a2a33@alans-desktop> <1890356924.1736.1522683188833.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1890356924.1736.1522683188833.JavaMail.zimbra@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Andrew Hunter <ahh@google.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <cata>
List-Id: linux-api@vger.kernel.org

----- On Apr 2, 2018, at 11:33 AM, Mathieu Desnoyers mathieu.desnoyers@efficios.com wrote:

> ----- On Apr 1, 2018, at 12:13 PM, One Thousand Gnomes
> gnomes@lxorguk.ukuu.org.uk wrote:
> 
>> On Tue, 27 Mar 2018 12:05:23 -0400
>> Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:
>> 
>>> Expose a new system call allowing each thread to register one userspace
>>> memory area to be used as an ABI between kernel and user-space for two
>>> purposes: user-space restartable sequences and quick access to read the
>>> current CPU number value from user-space.
>> 
>> What is the *worst* case timing achievable by using the atomics ? What
>> does it do to real time performance requirements ?
> 
> Given that there are two system calls introduced in this series (rseq and
> cpu_opv), can you clarify which system call you refer to in the two questions
> above ?
> 
> For rseq, given that its userspace works pretty much like a read seqlock
> (it retries on failure), it has no impact whatsoever on scheduler behavior.
> So characterizing its worst case timing does not appear to be relevant.
> 
>> For cpu_opv you now
>> give an answer but your answer is assuming there isn't another thread
>> actively thrashing the cache or store buffers, and that the user didn't
>> sneakily pass in a page of uncacheable memory (eg framebuffer, or GPU
>> space).
> 
> Are those considered as device pages ?
> 
>> 
>> I don't see anything that restricts it to cached pages. With that check
>> in place for x86 at least it would probably be ok and I think the sneaky
>> attacks to make it uncacheable would fail becuase you've got the pages
>> locked so trying to give them to an accelerator will block until you are
>> done.
>> 
>> I still like the idea it's just the latencies concern me.
> 
> Indeed, cpu_opv touches pages that are shared with user-space with
> preemption off, so this one affects the scheduler latency. The worse-case
> timings I measured for cpu_opv were with cache-cold memory. So I expect that
> another thread actively trashing the cache would be in the same ballpark
> figure. It does not account for a concurrent thread thrashing the store
> buffers though.
> 
> The checks enforcing which pages can be touched by cpu_opv operations are
> done within cpu_op_check_page(). is_zone_device_page() is used to ensure no
> device page is touched with preempt disabled. I understand that you would
> prefer to disallow pages of uncacheable memory as well, which I'm fine with.
> Is there an API similar to is_zone_device_page() to check whether a page is
> uncacheable ?

Looking into this a bit more, I notice the following: The pgprot_noncached
(_PAGE_NOCACHE on x86) pgprot is part of the vma->vm_page_prot. Therefore,
in order to have userspace provide pointers to noncached pages as input
to cpu_opv, they need to be part of a userspace vma which has a
pgprot_noncached vm_page_prot.

The cpu_opv system call uses get_user_pages_fast() to grab the struct page
from the userspace addresses, and then passes those pages to vm_map_ram(),
with a PAGE_KERNEL pgprot. This creates a temporary kernel mapping to those
pages, which is then used to read/write from/to those pages with preemption
disabled.

Therefore, with the proposed cpu_opv implementation, the kernel is not
touching noncached mappings with preemption disabled, which should take
care of your latency concern.

Am I missing something ?

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
