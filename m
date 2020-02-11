From: Minchan Kim <minchan@kernel.org>
Subject: Re: [PATCH v3 5/5] mm: support both pid and pidfd for process_madvise
Date: Tue, 11 Feb 2020 13:11:49 -0800
Message-ID: <20200211211149.GC185752@google.com>
References: <20200128001641.5086-1-minchan@kernel.org>
 <20200128001641.5086-6-minchan@kernel.org>
 <CAKgT0Ue9y=CL-f8xNXLo70nSk1wR_tG6TYXQUYpfk42PkHWeug@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAKgT0Ue9y=CL-f8xNXLo70nSk1wR_tG6TYXQUYpfk42PkHWeug@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Alexander Duyck <alexander.duyck@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, Linux API <linux-api@vger.kernel.org>, oleksandr@redhat.com, Suren Baghdasaryan <surenb@google.com>, Tim Murray <timmurray@google.com>, Daniel Colascione <dancol@google.com>, Sandeep Patil <sspatil@google.com>, Sonny Rao <sonnyrao@google.com>, Brian Geffon <bgeffon@google.com>, Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, Shakeel Butt <shakeelb@google.com>, John Dias <joaodias@google.com>, Joel Fernandes <joel@joelfernandes.org>
List-Id: linux-api@vger.kernel.org

On Mon, Feb 10, 2020 at 03:12:52PM -0800, Alexander Duyck wrote:
> On Mon, Jan 27, 2020 at 4:17 PM Minchan Kim <minchan@kernel.org> wrote:
> >
> > There is a demand[1] to support pid as well pidfd for process_madvise
> > to reduce unncessary syscall to get pidfd if the user has control of
> > the targer process(ie, they could gaurantee the process is not gone
> > or pid is not reused. Or, it might be okay to give a hint to wrong
> > process).
> 
> It looks like you misspelled several items in here including
> "unnecessary", "target", and "guarantee".

Thanks, will fix it.

> 
> > This patch aims for supporting both options like waitid(2). So, the
> > syscall is currently,
> >
> >         int process_madvise(int which, pid_t pid, void *addr,
> >                 size_t length, int advise, unsigned long flag);
> >
> > @which is actually idtype_t for userspace libray and currently,
> > it supports P_PID and P_PIDFD.
> >
> > [1]  https://lore.kernel.org/linux-mm/9d849087-3359-c4ab-fbec-859e8186c509@virtuozzo.com/
> > Signed-off-by: Minchan Kim <minchan@kernel.org>
> > ---
> >  include/linux/pid.h      |  1 +
> >  include/linux/syscalls.h |  3 ++-
> >  kernel/exit.c            | 17 -----------------
> >  kernel/pid.c             | 17 +++++++++++++++++
> >  mm/madvise.c             | 34 ++++++++++++++++++++++------------
> >  5 files changed, 42 insertions(+), 30 deletions(-)
> >
> > diff --git a/include/linux/pid.h b/include/linux/pid.h
> > index 998ae7d24450..023d9c3a8edc 100644
> > --- a/include/linux/pid.h
> > +++ b/include/linux/pid.h
> > @@ -75,6 +75,7 @@ extern const struct file_operations pidfd_fops;
> >  struct file;
> >
> >  extern struct pid *pidfd_pid(const struct file *file);
> > +extern struct pid *pidfd_get_pid(unsigned int fd);
> >
> >  static inline struct pid *get_pid(struct pid *pid)
> >  {
> 
> So really this is two patches interleaved. You have the moving of the
> pidfd_get_pid function and the update of the syscall. Personally I
> would make the function move a separate patch and place it before you
> define the syscall and fold the syscall changes into your original
> patch.
> 
> Doing that you wouldn't have to worry about the syscall changing in
> behavior midway through a bisect. It would either be there or it
> wouldn't.

Will try it.
Thanks!
