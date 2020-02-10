From: Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 2/5] mm: introduce external memory hinting API
Date: Mon, 10 Feb 2020 13:27:27 -0800
Message-ID: <20200210212727.GA48790@google.com>
References: <20200128001641.5086-1-minchan@kernel.org>
 <20200128001641.5086-3-minchan@kernel.org>
 <CAJuCfpFOBUYfxyQZZCvKjD0pyh_D-ZEpJP9kLD8xav+hVHZWYQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAJuCfpFOBUYfxyQZZCvKjD0pyh_D-ZEpJP9kLD8xav+hVHZWYQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, oleksandr-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Tim Murray <timmurray-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Daniel Colascione <dancol-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Sandeep Patil <sspatil-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Sonny Rao <sonnyrao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Brian Geffon <bgeffon-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, John Dias <joaodias-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joel Fernandes <joel-QYYGw3jwrUn5owFQY34kdNi2O/JbrIOy@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Suren,

On Mon, Feb 10, 2020 at 09:50:20AM -0800, Suren Baghdasaryan wrote:
> On Mon, Jan 27, 2020 at 4:17 PM Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> >
> > There is usecase that System Management Software(SMS) want to give
> > a memory hint like MADV_[COLD|PAGEEOUT] to other processes and
> > in the case of Android, it is the ActivityManagerService.
> >
> > It's similar in spirit to madvise(MADV_WONTNEED), but the information
> > required to make the reclaim decision is not known to the app. Instead,
> > it is known to the centralized userspace daemon(ActivityManagerService),
> > and that daemon must be able to initiate reclaim on its own without
> > any app involvement.
> >
> > To solve the issue, this patch introduces a new syscall process_madvise(2).
> > It uses pidfd of an external process to give the hint.
> >
> >  int process_madvise(int pidfd, void *addr, size_t length, int advise,
> >                         unsigned long flag);
> >
> > Since it could affect other process's address range, only privileged
> > process(CAP_SYS_PTRACE) or something else(e.g., being the same UID)
> > gives it the right to ptrace the process could use it successfully.
> > The flag argument is reserved for future use if we need to extend the
> > API.
> >
> > I think supporting all hints madvise has/will supported/support to
> > process_madvise is rather risky. Because we are not sure all hints make
> > sense from external process and implementation for the hint may rely on
> > the caller being in the current context so it could be error-prone.
> > Thus, I just limited hints as MADV_[COLD|PAGEOUT] in this patch.
> >
> > If someone want to add other hints, we could hear hear the usecase and
> > review it for each hint. It's safer for maintenance rather than
> > introducing a buggy syscall but hard to fix it later.
> 
> I would definitely be interested in adding MADV_DONTNEED support for
> process_madvise() to allow quick memory reclaim after a kill. The
> scenario is that userspace daemon can kill a process and try to help
> reclaim its memory. Having process_madvise(MADV_DONTNEED) support
> helps in the following cases:
> 1. Process issuing process_madvise has a higher CPU bandwidth
> allowance than the victim process, therefore can reclaim victim's
> memory quicker.
> 2. In case the victim occupies large amounts of memory the process
> issuing process_madvise can spawn multiple (possibly high priority)
> threads each reclaiming portions of the victim's memory.
> Such an extension will add a destructive kind of madvise into the set
> supported by process_madvise and I want to make sure we can accomodate
> for that in the future. Do you see any issues with supporting
> MADV_DONTNEED in the future?

Or kernel could do by themselves to spawn mulitple tasks if the system has
available badwidth and target process has a lot memory to be reclaimed

Anyway, it doesn't have any issue because we already have some synchrnoization
methods(e.g., signal or cgroup freezer) to freeze target processes before
giving a hint. It's not different with usual write syscall on shared file
among processes.

< snip >

> > diff --git a/mm/madvise.c b/mm/madvise.c
> > index 0c901de531e4..00ffa7e92f79 100644
> > --- a/mm/madvise.c
> > +++ b/mm/madvise.c
> > @@ -17,6 +17,7 @@
> >  #include <linux/falloc.h>
> >  #include <linux/fadvise.h>
> >  #include <linux/sched.h>
> > +#include <linux/sched/mm.h>
> >  #include <linux/ksm.h>
> >  #include <linux/fs.h>
> >  #include <linux/file.h>
> > @@ -315,6 +316,8 @@ static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
> >
> >         if (fatal_signal_pending(task))
> >                 return -EINTR;
> > +       else if (current != task && fatal_signal_pending(current))
> > +               return -EINTR;
> 
> I think this can be simplified as:
> 
> +       if (fatal_signal_pending(current))
> +               return -EINTR;
> 
> current != task condition is not needed because if current == task
> then you would return earlier after checking
> fatal_signal_pending(task).

True, I will remove it.

Thanks!
