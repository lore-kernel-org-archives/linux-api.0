From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCH v2 2/5] mm: introduce external memory hinting API
Date: Mon, 20 Jan 2020 15:39:35 +0300
Message-ID: <20200120123935.onlls7enjtzenbvt@box>
References: <20200116235953.163318-1-minchan@kernel.org>
 <20200116235953.163318-3-minchan@kernel.org>
 <20200117115225.GV19428@dhcp22.suse.cz>
 <f57fb198-4070-d3b4-b6bd-43b29ff40a2c@virtuozzo.com>
 <20200120112722.GY18451@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200120112722.GY18451@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Michal Hocko <mhocko@kernel.org>
Cc: Kirill Tkhai <ktkhai@virtuozzo.com>, Minchan Kim <minchan@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, linux-api@vger.kernel.org, oleksandr@redhat.com, Suren Baghdasaryan <surenb@google.com>, Tim Murray <timmurray@google.com>, Daniel Colascione <dancol@google.com>, Sandeep Patil <sspatil@google.com>, Sonny Rao <sonnyrao@google.com>, Brian Geffon <bgeffon@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Shakeel Butt <shakeelb@google.com>, John Dias <joaodias@google.com>, christian.brauner@ubuntu.com, sjpark@amazon.de
List-Id: linux-api@vger.kernel.org

On Mon, Jan 20, 2020 at 12:27:22PM +0100, Michal Hocko wrote:
> On Mon 20-01-20 13:24:35, Kirill Tkhai wrote:
> > On 17.01.2020 14:52, Michal Hocko wrote:
> > > On Thu 16-01-20 15:59:50, Minchan Kim wrote:
> > >> There is usecase that System Management Software(SMS) want to give
> > >> a memory hint like MADV_[COLD|PAGEEOUT] to other processes and
> > >> in the case of Android, it is the ActivityManagerService.
> > >>
> > >> It's similar in spirit to madvise(MADV_WONTNEED), but the information
> > >> required to make the reclaim decision is not known to the app. Instead,
> > >> it is known to the centralized userspace daemon(ActivityManagerService),
> > >> and that daemon must be able to initiate reclaim on its own without
> > >> any app involvement.
> > >>
> > >> To solve the issue, this patch introduces new syscall process_madvise(2).
> > >> It uses pidfd of an external processs to give the hint.
> > >>
> > >>  int process_madvise(int pidfd, void *addr, size_t length, int advise,
> > >> 			unsigned long flag);
> > >>
> > >> Since it could affect other process's address range, only privileged
> > >> process(CAP_SYS_PTRACE) or something else(e.g., being the same UID)
> > >> gives it the right to ptrace the process could use it successfully.
> > >> The flag argument is reserved for future use if we need to extend the
> > >> API.
> > >>
> > >> I think supporting all hints madvise has/will supported/support to
> > >> process_madvise is rather risky. Because we are not sure all hints make
> > >> sense from external process and implementation for the hint may rely on
> > >> the caller being in the current context so it could be error-prone.
> > >> Thus, I just limited hints as MADV_[COLD|PAGEOUT] in this patch.
> > >>
> > >> If someone want to add other hints, we could hear hear the usecase and
> > >> review it for each hint. It's more safe for maintainace rather than
> > >> introducing a buggy syscall but hard to fix it later.
> > > 
> > > I have brought this up when we discussed this in the past but there is
> > > no reflection on that here so let me bring that up again. 
> > > 
> > > I believe that the interface has an inherent problem that it is racy.
> > > The external entity needs to know the address space layout of the target
> > > process to do anyhing useful on it. The address space is however under
> > > the full control of the target process though and the external entity
> > > has no means to find out that the layout has changed. So
> > > time-to-check-time-to-act is an inherent problem.
> > > 
> > > This is a serious design flaw and it should be explained why it doesn't
> > > matter or how to use the interface properly to prevent that problem.
> > 
> > Really, any address space manipulation, where more than one process is
> > involved, is racy.
> 
> They are, indeed. But that is not the point I wanted to make.
> 
> > Even two threads on common memory need a synchronization
> > to manage mappings in a sane way. Managing memory from two processes
> > is the same in principle, and the only difference is that another level
> > of synchronization is required.
> 
> Well, not really. The operation might simply attempt to perform an
> operation on a specific memory area and get a failure if it doesn't
> reference the same object anymore. What I think we need is some form of
> a handle to operate on. In the past we have discussed several
> directions. I was proposing /proc/self/map_anon/ (analogous to
> map_files) where you could inspect anonymous memory and get a file
> handle for it. madvise would then operate on the fd and then there
> shouldn't be a real problem to revalidate that the object is still
> valid. But there was no general enthusiasm about that approach. There
> are likely some land mines on the way.

Converting anon memory to file-backed is bad idea and going to backfire.
It will break many things around rmap (for THP in particular). We have
assumption that an anon page cannot be mapped twice in the same process.
Breaking rules around memory inheritance is not helpful too.

It is a major re-design of the subsystem and I don't see any real need for
this.

-- 
 Kirill A. Shutemov
