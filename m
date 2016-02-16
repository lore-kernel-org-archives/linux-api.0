From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v4 04/22] kthread: Add create_kthread_worker*()
Date: Tue, 16 Feb 2016 11:08:01 -0500
Message-ID: <20160216160801.GM3741@mtj.duckdns.org>
References: <1453736711-6703-1-git-send-email-pmladek@suse.com>
 <1453736711-6703-5-git-send-email-pmladek@suse.com>
 <20160125185339.GB3628@mtj.duckdns.org>
 <20160216154443.GW12548@pathway.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160216154443.GW12548-KsEp0d+Q8qECVLCxKZUutA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hello,

On Tue, Feb 16, 2016 at 04:44:43PM +0100, Petr Mladek wrote:
> I wanted to be sure. The cpu number is later passed to
> cpu_to_node(cpu) in kthread_create_on_cpu().
> 
> I am going to replace this with a check against nr_cpu_ids in
> kthread_create_on_cpu() which makes more sense.
> 
> I might be too paranoid. But this is slow path. People
> do mistakes...

idk, that just ended up adding a subtly broken code which checks for
an unlikely condition which would cause a crash anyway.  I don't see
the point.  If you want to insist on it, please at least make it a
WARN_ON().  It's a clear kernel bug.

Thanks.

-- 
tejun
