From: Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>
Subject: Re: [RFC PATCH 0/3] Implement getcpu_cache system call
Date: Tue, 12 Jan 2016 04:27:52 +0000
Message-ID: <9F8D25C2-B5EE-479D-BD61-0FE466962B9E@fb.com>
References: <1451977320-4886-1-git-send-email-mathieu.desnoyers@efficios.com>
 <DDB9C85B850785449757F9914A034FCB4450ACF7@G9W0766.americas.hpqcorp.net>
 <20160111230306.GC28717@cloud>
 <137700396.343696.1452559758752.JavaMail.zimbra@efficios.com>,<20160112024549.GA6488@x>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160112024549.GA6488@x>
Content-Language: en-US
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>, Shane M Seymour <shane.seymour-ZPxbGqLxI0U@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

One disadvantage of only allowing one is that high performance server applications tend to statically link. It'd suck to have to go through what ever type of relocation we'd need to pull this out of glibc. But if there's only one registration allowed a statically linked app couldn't create its own if glibc might use it some day. 



Sent from my iPhone

> On Jan 11, 2016, at 6:46 PM, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org> wrote:
> 
>> On Tue, Jan 12, 2016 at 12:49:18AM +0000, Mathieu Desnoyers wrote:
>> ----- On Jan 11, 2016, at 6:03 PM, Josh Triplett josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org wrote:
>> 
>>>> On Mon, Jan 11, 2016 at 10:38:28PM +0000, Seymour, Shane M wrote:
>>>> I have some concerns and suggestions for you about this.
>>>> 
>>>> What's to stop someone in user space from requesting an arbitrarily large number
>>>> of CPU # cache locations that the kernel needs to allocate memory to track and
>>>> each time the task migrates to a new CPU it needs to update them all? Could you
>>>> use it to dramatically slow down a system/task switching? Should there be a
>>>> ulimit type value or a sysctl setting to limit the number that you're allowed
>>>> to register per-task?
>>> 
>>> The documented behavior of the syscall allows only one location per
>>> thread, so the kernel can track that one and only address rather easily
>>> in the task_struct.  Allowing dynamic allocation definitely doesn't seem
>>> like a good idea.
>> 
>> The current implementation now allows more than one location per
>> thread. Which piece of documentation states that only one location
>> per thread is allowed ? This was indeed the case for the prior
>> implementations, but I moved to implementing a linked-list of
>> cpu_cache areas per thread to allow the getcpu_cache system call to
>> be used by more than a single shared object within a given program.
> 
> Ah, I missed that change.
> 
>> Without the linked list, as soon as more than one shared object try
>> to register their cache, the first one will prohibit all others from
>> doing so.
>> 
>> We could perhaps try to document that this system call should only
>> ever be used by *libc, and all libraries and applications should
>> then use the libc TLS cache variable, but it seems rather fragile,
>> and any app/lib could try to register its own cache.
> 
> That does seem a bit fragile, true; on the other hand, the linked-list
> approach would allow userspace to allocate an unbounded amount of kernel
> memory, without any particular control on it.  That doesn't seem
> reasonable.  Introducing an rlimit or similar for this seems like
> massive overkill, and hardcoding a fixed limit breaks the 0-1-infinity
> rule.
> 
> Given that any registered location will always provide the same value,
> allowing only a single registration doesn't seem *too* problematic;
> libc-based programs can use the libc implementation, and non-libc-based
> programs can register a location themselves.  And users of this API will
> already likely want to use some TLS mechanism, which already interacts
> heavily with libc (set_thread_area/clone).
> 
> Allowing only one registration at a time seems preferable to introducing
> another way to allocate kernel resources on a process's behalf.
> 
> - Josh Triplett
