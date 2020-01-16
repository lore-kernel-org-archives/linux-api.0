From: Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 2/3] clone3: allow spawning processes into cgroups
Date: Fri, 17 Jan 2020 00:57:22 +0100
Message-ID: <20200116235721.tnadjblifqirg5bo@wittgenstein>
References: <20191223061504.28716-1-christian.brauner@ubuntu.com>
 <20191223061504.28716-3-christian.brauner@ubuntu.com>
 <20200108160102.GA17415@blackbody.suse.cz>
 <20200108181049.ysmo73celrt4bvo2@wittgenstein>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20200108181049.ysmo73celrt4bvo2@wittgenstein>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, Jan 08, 2020 at 07:10:49PM +0100, Christian Brauner wrote:
> On Wed, Jan 08, 2020 at 05:01:02PM +0100, Michal Koutný wrote:
> > On Mon, Dec 23, 2019 at 07:15:03AM +0100, Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org> wrote:
> > > This adds support for creating a process in a different cgroup than its
> > > parent.
> > Binding fork and migration together looks useful.
> > 
> > > --- a/kernel/cgroup/cgroup.c
> > > +++ b/kernel/cgroup/cgroup.c
> > > @@ -5882,21 +5882,176 @@ void cgroup_fork(struct task_struct *child)
> > >  	INIT_LIST_HEAD(&child->cg_list);
> > Just a nitpick, I noticed the comment for cgroup_fork should be updated
> > too (generic migration happens in cgroup_post_fork).
> 
> Thanks.
> 
> > 
> > > --- a/kernel/fork.c
> > > +++ b/kernel/fork.c
> > > [...]
> > > @@ -2279,8 +2278,7 @@ static __latent_entropy struct task_struct *copy_process(
> > >  	write_unlock_irq(&tasklist_lock);
> > >  
> > >  	proc_fork_connector(p);
> > > -	cgroup_post_fork(p);
> > > -	cgroup_threadgroup_change_end(current);
> > > +	cgroup_post_fork(current, p, args);
> > I can see that when CLONE_INTO_CGROUP | CLONE_NEWCGROUP is passed, then
> > the child's cgroup NS will be rooted at parent's css set
> > (copy_namespaces precedes cgroup_post_fork).
> > 
> > Wouldn't it make better sense if this flags combination resulted in
> > child's NS rooted in its css set?
> 
> I need to take a closer look but it sounds like we should move the
> copying of the cgroup namespace to a later point; but again I need to
> look into this.

Ok, this is way simpler I think, we just set the root_cset of the new
cgroup namespace to the child's cset in cgroup_post_fork() if
CLONE_NEWCGROUP is requested.

Christian
