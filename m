From: Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v4 04/22] kthread: Add create_kthread_worker*()
Date: Tue, 16 Feb 2016 17:10:09 +0100
Message-ID: <20160216161009.GO3305@pathway.suse.cz>
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
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue 2016-02-16 16:44:43, Petr Mladek wrote:
> On Mon 2016-01-25 13:53:39, Tejun Heo wrote:
> > On Mon, Jan 25, 2016 at 04:44:53PM +0100, Petr Mladek wrote:
> > > +struct kthread_worker *
> > > +create_kthread_worker_on_cpu(int cpu, const char namefmt[])
> > > +{
> > > +	if (cpu < 0 || cpu > num_possible_cpus())
> > > +		return ERR_PTR(-EINVAL);
> > 
> > Comparing cpu ID to num_possible_cpus() doesn't make any sense.  It
> > should either be testing against cpu_possible_mask or testing against
> > nr_cpu_ids.  Does this test need to be in this function at all?
> 
> I wanted to be sure. The cpu number is later passed to
> cpu_to_node(cpu) in kthread_create_on_cpu().
> 
> I am going to replace this with a check against nr_cpu_ids in
> kthread_create_on_cpu() which makes more sense.
> 
> I might be too paranoid. But this is slow path. People
> do mistakes...

I take it back. I will remove the check at all.
Michal Hocko persuaded me offline that it does not make
much sense. This function is used from kernel code.
I need to believe that the usage is sane at this level.
Also too many checks makes the code harder to read.

Thanks,
Petr
