From: Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Ping: [PATCH v15 00/13] support "task_isolation" mode
Date: Tue, 27 Sep 2016 16:49:45 +0200
Message-ID: <20160927144943.GE6242@lerouge>
References: <1471382376-5443-1-git-send-email-cmetcalf@mellanox.com>
 <d00bbe64-6e2c-51ce-1dfb-72ef1c4a04fa@mellanox.com>
 <057a958c-4491-b449-ae59-7d331afc872d@gmail.com>
 <909484ad-534d-524a-51db-19b7d013f73e@mellanox.com>
 <3e93004f-e1c5-f606-33fb-7cb44b99eb0a@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <3e93004f-e1c5-f606-33fb-7cb44b99eb0a-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Francis Giraldeau <francis.giraldeau-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Chris Metcalf <cmetcalf-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Gilad Ben Yossef <giladb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Viresh Kumar <viresh.kumar-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Daniel Lezcano <daniel.lezcano-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, Sep 12, 2016 at 08:20:16PM -0400, Francis Giraldeau wrote:
> 
> The args are valid, but the system has an unstable clock, therefore the
> operation is not supported. In the user point of view, maybe ENOTSUPP
> would be more appropriate? But then, we need to check the reason and
> can_stop_my_full_tick() returns only a boolean.
> 
> On a side note, the NOSIG mode may be confusing for the users. At first,
> I was expecting that NOSIG behaves the same way as the normal task isolation
> mode. In the current situation, if the user wants the normal behavior, but
> does not care about the signal, the user must register an empty signal handler.
> 
> However, if I understand correctly, other settings beside NOHZ and isolcpus
> are required to support quiet CPUs, such as irq_affinity and rcu_nocb. It would
> be very convenient from the user point of view if these other settings were configure
> correctly.
> 
> I can work on that and also write some doc (Documentation/task-isolation.txt ?).

That would be lovely! Part of this documentation already exists in
Documentation/timers/NO_HZ.txt and also in Documentation/kernel-per-CPU-kthreads.txt

I think we should extract the isolation informations that aren't related to the tick
from NO_HZ.txt and put them in task-isolation.txt, perhaps merge kernel-per-CPU-kthreads.txt
into it or at least add a pointer to it. Then add all the missing informations as many things
have evolved since then.

I'll gladly help.

Thanks.
