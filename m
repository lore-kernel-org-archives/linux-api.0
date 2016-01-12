From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC PATCH 0/3] Implement getcpu_cache system call
Date: Tue, 12 Jan 2016 00:49:18 +0000 (UTC)
Message-ID: <137700396.343696.1452559758752.JavaMail.zimbra@efficios.com>
References: <1451977320-4886-1-git-send-email-mathieu.desnoyers@efficios.com> <DDB9C85B850785449757F9914A034FCB4450ACF7@G9W0766.americas.hpqcorp.net> <20160111230306.GC28717@cloud>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160111230306.GC28717@cloud>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
Cc: Shane M Seymour <shane.seymour-ZPxbGqLxI0U@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

----- On Jan 11, 2016, at 6:03 PM, Josh Triplett josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org wrote:

> On Mon, Jan 11, 2016 at 10:38:28PM +0000, Seymour, Shane M wrote:
>> I have some concerns and suggestions for you about this.
>> 
>> What's to stop someone in user space from requesting an arbitrarily large number
>> of CPU # cache locations that the kernel needs to allocate memory to track and
>> each time the task migrates to a new CPU it needs to update them all? Could you
>> use it to dramatically slow down a system/task switching? Should there be a
>> ulimit type value or a sysctl setting to limit the number that you're allowed
>> to register per-task?
> 
> The documented behavior of the syscall allows only one location per
> thread, so the kernel can track that one and only address rather easily
> in the task_struct.  Allowing dynamic allocation definitely doesn't seem
> like a good idea.

The current implementation now allows more than one location per
thread. Which piece of documentation states that only one location
per thread is allowed ? This was indeed the case for the prior
implementations, but I moved to implementing a linked-list of
cpu_cache areas per thread to allow the getcpu_cache system call to
be used by more than a single shared object within a given program.

Without the linked list, as soon as more than one shared object try
to register their cache, the first one will prohibit all others from
doing so.

We could perhaps try to document that this system call should only
ever be used by *libc, and all libraries and applications should
then use the libc TLS cache variable, but it seems rather fragile,
and any app/lib could try to register its own cache.

Thoughts ?

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
