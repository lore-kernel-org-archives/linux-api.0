From: Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 2/5] mm: introduce external memory hinting API
Date: Tue, 21 Jan 2020 10:11:13 -0800
Message-ID: <20200121181113.GE140922@google.com>
References: <20200116235953.163318-1-minchan@kernel.org>
 <20200116235953.163318-3-minchan@kernel.org>
 <20200117115225.GV19428@dhcp22.suse.cz>
 <20200117155837.bowyjpndfiym6cgs@box>
 <20200117173239.GB140922@google.com>
 <20200117212653.7uftw3lk35oykkmb@box>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20200117212653.7uftw3lk35oykkmb@box>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, oleksandr-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tim Murray <timmurray-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Daniel Colascione <dancol-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Sandeep Patil <sspatil-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Sonny Rao <sonnyrao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Brian Geffon <bgeffon-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, John Dias <joaodias-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, ktkhai-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org, christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org, sjpark-ebkRAfMGSJGzQB+pC5nmwQ@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Sat, Jan 18, 2020 at 12:26:53AM +0300, Kirill A. Shutemov wrote:
> On Fri, Jan 17, 2020 at 09:32:39AM -0800, Minchan Kim wrote:
> > On Fri, Jan 17, 2020 at 06:58:37PM +0300, Kirill A. Shutemov wrote:
> > > On Fri, Jan 17, 2020 at 12:52:25PM +0100, Michal Hocko wrote:
> > > > On Thu 16-01-20 15:59:50, Minchan Kim wrote:
> > > > > There is usecase that System Management Software(SMS) want to give
> > > > > a memory hint like MADV_[COLD|PAGEEOUT] to other processes and
> > > > > in the case of Android, it is the ActivityManagerService.
> > > > > 
> > > > > It's similar in spirit to madvise(MADV_WONTNEED), but the information
> > > > > required to make the reclaim decision is not known to the app. Instead,
> > > > > it is known to the centralized userspace daemon(ActivityManagerService),
> > > > > and that daemon must be able to initiate reclaim on its own without
> > > > > any app involvement.
> > > > > 
> > > > > To solve the issue, this patch introduces new syscall process_madvise(2).
> > > > > It uses pidfd of an external processs to give the hint.
> > > > > 
> > > > >  int process_madvise(int pidfd, void *addr, size_t length, int advise,
> > > > > 			unsigned long flag);
> > > > > 
> > > > > Since it could affect other process's address range, only privileged
> > > > > process(CAP_SYS_PTRACE) or something else(e.g., being the same UID)
> > > > > gives it the right to ptrace the process could use it successfully.
> > > > > The flag argument is reserved for future use if we need to extend the
> > > > > API.
> > > > > 
> > > > > I think supporting all hints madvise has/will supported/support to
> > > > > process_madvise is rather risky. Because we are not sure all hints make
> > > > > sense from external process and implementation for the hint may rely on
> > > > > the caller being in the current context so it could be error-prone.
> > > > > Thus, I just limited hints as MADV_[COLD|PAGEOUT] in this patch.
> > > > > 
> > > > > If someone want to add other hints, we could hear hear the usecase and
> > > > > review it for each hint. It's more safe for maintainace rather than
> > > > > introducing a buggy syscall but hard to fix it later.
> > > > 
> > > > I have brought this up when we discussed this in the past but there is
> > > > no reflection on that here so let me bring that up again. 
> > > > 
> > > > I believe that the interface has an inherent problem that it is racy.
> > > > The external entity needs to know the address space layout of the target
> > > > process to do anyhing useful on it. The address space is however under
> > > > the full control of the target process though and the external entity
> > > > has no means to find out that the layout has changed. So
> > > > time-to-check-time-to-act is an inherent problem.
> > > > 
> > > > This is a serious design flaw and it should be explained why it doesn't
> > > > matter or how to use the interface properly to prevent that problem.
> > > 
> > > I agree, it looks flawed.
> > > 
> > > Also I don't see what System Management Software can generically do on
> > > sub-process level. I mean how can it decide which part of address space is
> > > less important than other.
> > > 
> > > I see how a manager can indicate that this process (or a group of
> > > processes) is less important than other, but on per-addres-range basis?
> > 
> > For example, memory ranges shared by several processes or critical for the
> > latency, we could avoid those ranges to be cold/pageout to prevent
> > unncecessary CPU burning/paging.
> 
> Hmm.. I still don't see why any external entity has a better (or any)
> knowledge about the matter. The process has to do this, no?

I think Sandeep already gave enough information in other thread.

> 
> > I also think people don't want to give an KSM hint to non-mergeable area.
> 
> And how the manager knows which data is mergable?

Oleksandr, could you say your thought why you need address range based
API?

> 
> If you are intimate enough with the process' internal state feel free to
> inject syscall into the process with ptrace. Why bother with half-measures?

Concern is we want to act the hint in caller's context, not calle because
calle is usually very limited in cpuset/cgroups or even freezed state so
they couldn't act by themselves quick enough, which makes many problems.
One of efforts to solve the issue was "Expedited memory reclaim"

	https://lwn.net/Articles/785709/

That could be also a good candidate for process_madvise API.
