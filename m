From: Michal Hocko <mhocko@suse.cz>
Subject: Re: [RFC PATCH] fork: report pid reservation failure properly
Date: Tue, 3 Feb 2015 16:52:48 +0100
Message-ID: <20150203155248.GD8907@dhcp22.suse.cz>
References: <20150203150557.GB8907@dhcp22.suse.cz>
 <CAKgNAkjiz6Uop_QVBNyyHFu8kgAR46nB1HWi0yOKt4ZX=666vg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAKgNAkjiz6Uop_QVBNyyHFu8kgAR46nB1HWi0yOKt4ZX=666vg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: Linux API <linux-api@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, "Eric W. Biederman" <ebiederm@xmission.com>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue 03-02-15 16:33:03, Michael Kerrisk wrote:
> Hi Michal,
> 
> 
> On 3 February 2015 at 16:05, Michal Hocko <mhocko@suse.cz> wrote:
> > Hi,
> > while debugging an unexpected ENOMEM from fork (there was no memory
> > pressure and OVERCOMMIT_ALWAYS) I have found out that fork returns
> > ENOMEM even when not short on memory.
> >
> > In this particular case it was due to depleted pid space which is
> > documented to return EAGAIN in man pages.
> >
> > Here is a quick fix up.
> 
> Could you summarize briefly what the user-space visible change is
> here?

The user visible change is that the userspace will get EAGAIN when
calling fork and the pid space is depleted because of a system wide
limit as per man page description rather than ENOMEM which we return
currently.

> It is not so obvious from your message. I believe you're turning
> some cases of ENOMEM into EAGAIN, right?

Yes, except for the case mentioned below which discusses a potential
error code for pid namespace triggered failures.

> Note, by the way, that if I understandwhat you intend, this change
> would bring the implementation closer to POSIX, which specifies:

True.

HTH.

>        EAGAIN The  system  lacked  the  necessary  resources  to  create
>               another  process, or the system-imposed limit on the total
>               number of processes under execution system-wide  or  by  a
>               single user {CHILD_MAX} would be exceeded.
> 
> Thanks,
> 
> Michael
> 
> > I am sending that as a RFC because I am not
> > entirely sure about interaction with pid namespace which might cause
> > fork to fail. pid_ns_prepare_proc might return few error codes which are
> > not documented by man page but I am not sure whether that is actually
> > going to happen on a properly configured system.
> >
> > There doesn't seem to be a good error code for an already "closed"
> > namespace (PIDNS_HASH_ADDING disabled) as well.  I've chosen EBUSY but
> > that might be completely wrong.  I am also wondering how would this
> > error case happen in the first place because parent should still exist
> > while fork is going on so the pid namespace shouldn't go away but I
> > smell this might have something to do with setns or something similar.
> >
> > Any feedback would be appreciated.
> > ---
> > From 2a576175345fffa04da19cd51a25b7d94187b5f9 Mon Sep 17 00:00:00 2001
> > From: Michal Hocko <mhocko@suse.cz>
> > Date: Fri, 30 Jan 2015 14:50:15 +0100
> > Subject: [PATCH] fork: report pid reservation failure properly
> >
> > copy_process will report any failure in alloc_pid as ENOMEM currently
> > which is misleading because the pid allocation might fail not only when
> > the memory is short but also when the pid space is consumed already.
> >
> > The current man page even mentions this case:
> > "
> > EAGAIN
> >
> >       A system-imposed limit on the number of threads was encountered.
> >       There are a number of limits that may trigger this error: the
> >       RLIMIT_NPROC soft resource limit (set via setrlimit(2)), which
> >       limits the number of processes and threads for a real user ID, was
> >       reached; the kernel's system-wide limit on the number of processes
> >       and threads, /proc/sys/kernel/threads-max, was reached (see
> >       proc(5)); or the maximum number of PIDs, /proc/sys/kernel/pid_max,
> >       was reached (see proc(5)).
> > "
> >
> > so the current behavior is also incorrect wrt. documentation. This patch
> > simply propagates error code from alloc_pid and makes sure we return
> > -EAGAIN due to reservation failure.
> >
> > There is one side effect of the change which might be unexpected.
> > alloc_pid might fail even when the repear in the pid namespace is dead
> > (the namespace basically disallows all new processes) and there is no
> > good error code which would match documented ones. I've taken EBUSY
> > because it felt like a best fit for the condition - namespace is busy
> > tearing down all the infrastructure.
> >
> > Signed-off-by: Michal Hocko <mhocko@suse.cz>
> > ---
> >  kernel/fork.c |  5 +++--
> >  kernel/pid.c  | 19 +++++++++++--------
> >  2 files changed, 14 insertions(+), 10 deletions(-)
> >
> > diff --git a/kernel/fork.c b/kernel/fork.c
> > index 3ce8d57cff09..c37b88a162c5 100644
> > --- a/kernel/fork.c
> > +++ b/kernel/fork.c
> > @@ -1405,10 +1405,11 @@ static struct task_struct *copy_process(unsigned long clone_flags,
> >                 goto bad_fork_cleanup_io;
> >
> >         if (pid != &init_struct_pid) {
> > -               retval = -ENOMEM;
> >                 pid = alloc_pid(p->nsproxy->pid_ns_for_children);
> > -               if (!pid)
> > +               if (IS_ERR(pid)) {
> > +                       retval = PTR_ERR(pid);
> >                         goto bad_fork_cleanup_io;
> > +               }
> >         }
> >
> >         p->set_child_tid = (clone_flags & CLONE_CHILD_SETTID) ? child_tidptr : NULL;
> > diff --git a/kernel/pid.c b/kernel/pid.c
> > index 82430c858d69..c1a5875bd1ab 100644
> > --- a/kernel/pid.c
> > +++ b/kernel/pid.c
> > @@ -207,7 +207,7 @@ static int alloc_pidmap(struct pid_namespace *pid_ns)
> >                 }
> >                 pid = mk_pid(pid_ns, map, offset);
> >         }
> > -       return -1;
> > +       return -EAGAIN;
> >  }
> >
> >  int next_pidmap(struct pid_namespace *pid_ns, unsigned int last)
> > @@ -298,17 +298,20 @@ struct pid *alloc_pid(struct pid_namespace *ns)
> >         int i, nr;
> >         struct pid_namespace *tmp;
> >         struct upid *upid;
> > +       int retval;
> >
> >         pid = kmem_cache_alloc(ns->pid_cachep, GFP_KERNEL);
> >         if (!pid)
> > -               goto out;
> > +               return ERR_PTR(-ENOMEM);
> >
> >         tmp = ns;
> >         pid->level = ns->level;
> >         for (i = ns->level; i >= 0; i--) {
> >                 nr = alloc_pidmap(tmp);
> > -               if (nr < 0)
> > +               if (IS_ERR_VALUE(nr)) {
> > +                       retval = nr;
> >                         goto out_free;
> > +               }
> >
> >                 pid->numbers[i].nr = nr;
> >                 pid->numbers[i].ns = tmp;
> > @@ -316,7 +319,7 @@ struct pid *alloc_pid(struct pid_namespace *ns)
> >         }
> >
> >         if (unlikely(is_child_reaper(pid))) {
> > -               if (pid_ns_prepare_proc(ns))
> > +               if ((retval = pid_ns_prepare_proc(ns)))
> >                         goto out_free;
> >         }
> >
> > @@ -327,8 +330,10 @@ struct pid *alloc_pid(struct pid_namespace *ns)
> >
> >         upid = pid->numbers + ns->level;
> >         spin_lock_irq(&pidmap_lock);
> > -       if (!(ns->nr_hashed & PIDNS_HASH_ADDING))
> > +       if (!(ns->nr_hashed & PIDNS_HASH_ADDING)) {
> > +               retval = -EBUSY;
> >                 goto out_unlock;
> > +       }
> >         for ( ; upid >= pid->numbers; --upid) {
> >                 hlist_add_head_rcu(&upid->pid_chain,
> >                                 &pid_hash[pid_hashfn(upid->nr, upid->ns)]);
> > @@ -336,7 +341,6 @@ struct pid *alloc_pid(struct pid_namespace *ns)
> >         }
> >         spin_unlock_irq(&pidmap_lock);
> >
> > -out:
> >         return pid;
> >
> >  out_unlock:
> > @@ -348,8 +352,7 @@ out_free:
> >                 free_pidmap(pid->numbers + i);
> >
> >         kmem_cache_free(ns->pid_cachep, pid);
> > -       pid = NULL;
> > -       goto out;
> > +       return ERR_PTR(retval);
> >  }
> >
> >  void disable_pid_allocation(struct pid_namespace *ns)
> > --
> > 2.1.4
> >
> > --
> > Michal Hocko
> > SUSE Labs
> 
> 
> 
> -- 
> Michael Kerrisk
> Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
> Linux/UNIX System Programming Training: http://man7.org/training/

-- 
Michal Hocko
SUSE Labs
