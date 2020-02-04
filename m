From: Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v5 5/6] clone3: allow spawning processes into cgroups
Date: Tue, 4 Feb 2020 16:01:44 +0100
Message-ID: <20200204150144.fojbdmuyr7bnvgnj@wittgenstein>
References: <20200121154844.411-1-christian.brauner@ubuntu.com>
 <20200121154844.411-6-christian.brauner@ubuntu.com>
 <20200204115351.GD14879@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20200204115351.GD14879-Nxj+rRp3nVydTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, Feb 04, 2020 at 12:53:51PM +0100, Peter Zijlstra wrote:
> On Tue, Jan 21, 2020 at 04:48:43PM +0100, Christian Brauner wrote:
> > This adds support for creating a process in a different cgroup than its
> > parent. Callers can limit and account processes and threads right from
> > the moment they are spawned:
> > - A service manager can directly spawn new services into dedicated
> >   cgroups.
> > - A process can be directly created in a frozen cgroup and will be
> >   frozen as well.
> > - The initial accounting jitter experienced by process supervisors and
> >   daemons is eliminated with this.
> > - Threaded applications or even thread implementations can choose to
> >   create a specific cgroup layout where each thread is spawned
> >   directly into a dedicated cgroup.
> > 
> > This feature is limited to the unified hierarchy. Callers need to pass
> > an directory file descriptor for the target cgroup. The caller can
> > choose to pass an O_PATH file descriptor. All usual migration
> > restrictions apply, i.e. there can be no processes in inner nodes. In
> > general, creating a process directly in a target cgroup adheres to all
> > migration restrictions.
> 
> AFAICT, he *big* win here is avoiding the write side of the
> cgroup_threadgroup_rwsem. Or am I mis-reading the patch?

No, you're absolutely right. I just didn't bother putting implementation
specifics in the cover letter and I probably should have. So thanks for
pointing that out!

> 
> That global lock is what makes moving tasks/threads around super
> expensive, avoiding that by use of this clone() variant wins the day.

:)
Christian
