From: Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v3 22/22] thermal/intel_powerclamp: Convert the kthread
 to kthread worker API
Date: Wed, 13 Jan 2016 11:18:31 +0100
Message-ID: <20160113101831.GQ731@pathway.suse.cz>
References: <1447853127-3461-1-git-send-email-pmladek@suse.com>
 <1447853127-3461-23-git-send-email-pmladek@suse.com>
 <20160107115531.34279a9b@icelake>
 <20160108164931.GT3178@pathway.suse.cz>
 <20160111181718.0ace4a58@yairi>
 <20160112101129.GN731@pathway.suse.cz>
 <20160112082021.6a28dc66@icelake>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160112082021.6a28dc66@icelake>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jacob Pan <jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Zhang Rui <rui.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Eduardo Valentin <edubezval-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue 2016-01-12 08:20:21, Jacob Pan wrote:
> On Tue, 12 Jan 2016 11:11:29 +0100
> Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org> wrote:
> 
> > > > BTW: I wonder if the original code correctly handle freezing after
> > > > the schedule_timeout(). It does not call try_to_freeze()
> > > > there and the forced idle states might block freezing.
> > > > I think that the small overhead of kthread works is worth
> > > > solving such bugs. It makes it easier to maintain these
> > > > sleeping states.  
> > > it is in a while loop, so try_to_freeze() gets called. Am I missing
> > > something?  
> > 
> > But it might take some time until try_to_freeze() is called.
> > If I get it correctly. try_to_freeze_tasks() wakes freezable
> > tasks to get them into the fridge. If clamp_thread() is waken
> > from that schedule_timeout_interruptible(), it still might inject
> > the idle state before calling try_to_freeze(). It means that freezer
> > needs to wait "quite" some time until the kthread ends up in the
> > fridge.
> > 
> > Hmm, even my conversion does not solve this entirely. We might
> > need to call freezing(current) in the
> > 
> >    while (time_before(jiffies, target_jiffies)) {
> > 
> > cycle. And break injecting the idle state when freezing is requested.
> 
> The injection time for each period is very short, default 6ms. While on
> the other side the default freeze timeout is 20 sec. So I think task
> freeze can wait :)
> i.e.
> unsigned int __read_mostly freeze_timeout_msecs = 20 * MSEC_PER_SEC;

You are right. And it does not make sense to add an extra
freezer-specific code if not really necessary.

Otherwise, I will keep the conversion into the kthread worker as is
for now. Please, let me know if you are strongly against the split
into the two works.


Best Regards,
Petr
