From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v3 09/22] kthread: Allow to cancel kthread work
Date: Tue, 24 Nov 2015 12:49:00 -0800
Message-ID: <CA+55aFysmJAH_2U=TUCcMz_dc9TH5enPST9k5pJojtAL+F-Nkg@mail.gmail.com>
References: <1447853127-3461-1-git-send-email-pmladek@suse.com>
	<1447853127-3461-10-git-send-email-pmladek@suse.com>
	<20151123225823.GI19072@mtj.duckdns.org>
	<CA+55aFyW=hp-myZGcL+5r2x+fUbpBJLmxDY66QB5VQj-nNsCxQ@mail.gmail.com>
	<20151124202855.GV17033@mtj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20151124202855.GV17033@mtj.duckdns.org>
Sender: owner-linux-mm@kvack.org
To: Tejun Heo <tj@kernel.org>
Cc: Petr Mladek <pmladek@suse.com>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Steven Rostedt <rostedt@goodmis.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Josh Triplett <josh@joshtriplett.org>, Thomas Gleixner <tglx@linutronix.de>, Jiri Kosina <jkosina@suse.cz>, Borislav Petkov <bp@suse.de>, Michal Hocko <mhocko@suse.cz>, linux-mm <linux-mm@kvack.org>, Vlastimil Babka <vbabka@suse.cz>, Linux API <linux-api@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, Nov 24, 2015 at 12:28 PM, Tejun Heo <tj@kernel.org> wrote:
>>
>> In general, it's very dangerous to try to cook up your own locking
>> rules. People *always* get it wrong.
>
> It's either trylock on timer side or timer active spinning trick on
> canceling side, so this seems the lesser of the two evils.

I'm not saying the approach is wrong.

I'm saying that people need to realize that locking is harder than
they think, and not cook up their own lock primitives using things
like trylock without really thinking about it a *lot*.

Basically, "trylock()" on its own should never be used in a loop. The
main use for trylock should be one of:

 - thing that you can just not do at all if you can't get the lock

 - avoiding ABBA deadlocks: if you have a A->B locking order, but you
already hold B, instead of "drop B, then take A and B in the right
order", you may decide to first "trylock(A)" - and if that fails you
then fall back on the "drop and relock in the right order".

but if what you want to create is a "get lock using trylock", you need
to be very aware of the cache coherency traffic issue at least.

It is possible that we should think about trying to introduce a new
primitive for that "loop_try_lock()" thing. But it's probably not
common enough to be worth it - we've had this issue before, but I
think it's a "once every couple of years" kind of thing rather than
anything that we need to worry about.

The "locking is hard" issue is very real, though. We've traditionally
had a *lot* of code that tried to do its own locking, and not getting
the memory ordering right etc. Things that happen to work on x86 but
don't on other architectures etc.

                       Linus

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
