From: Minchan Kim <minchan@kernel.org>
Subject: Re: [RFC 7/7] mm: madvise support MADV_ANONYMOUS_FILTER and
 MADV_FILE_FILTER
Date: Wed, 22 May 2019 10:50:25 +0900
Message-ID: <20190522015025.GA29449@google.com>
References: <20190520035254.57579-1-minchan@kernel.org>
 <20190520035254.57579-8-minchan@kernel.org>
 <20190520092801.GA6836@dhcp22.suse.cz>
 <20190521025533.GH10039@google.com>
 <20190521153310.GA3218@cmpxchg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190521153310.GA3218@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, Tim Murray <timmurray@google.com>, Joel Fernandes <joel@joelfernandes.org>, Suren Baghdasaryan <surenb@google.com>, Daniel Colascione <dancol@google.com>, Shakeel Butt <shakeelb@google.com>, Sonny Rao <sonnyrao@google.com>, Brian Geffon <bgeffon@google.com>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Tue, May 21, 2019 at 11:33:10AM -0400, Johannes Weiner wrote:
> On Tue, May 21, 2019 at 11:55:33AM +0900, Minchan Kim wrote:
> > On Mon, May 20, 2019 at 11:28:01AM +0200, Michal Hocko wrote:
> > > [cc linux-api]
> > > 
> > > On Mon 20-05-19 12:52:54, Minchan Kim wrote:
> > > > System could have much faster swap device like zRAM. In that case, swapping
> > > > is extremely cheaper than file-IO on the low-end storage.
> > > > In this configuration, userspace could handle different strategy for each
> > > > kinds of vma. IOW, they want to reclaim anonymous pages by MADV_COLD
> > > > while it keeps file-backed pages in inactive LRU by MADV_COOL because
> > > > file IO is more expensive in this case so want to keep them in memory
> > > > until memory pressure happens.
> > > > 
> > > > To support such strategy easier, this patch introduces
> > > > MADV_ANONYMOUS_FILTER and MADV_FILE_FILTER options in madvise(2) like
> > > > that /proc/<pid>/clear_refs already has supported same filters.
> > > > They are filters could be Ored with other existing hints using top two bits
> > > > of (int behavior).
> > > 
> > > madvise operates on top of ranges and it is quite trivial to do the
> > > filtering from the userspace so why do we need any additional filtering?
> > > 
> > > > Once either of them is set, the hint could affect only the interested vma
> > > > either anonymous or file-backed.
> > > > 
> > > > With that, user could call a process_madvise syscall simply with a entire
> > > > range(0x0 - 0xFFFFFFFFFFFFFFFF) but either of MADV_ANONYMOUS_FILTER and
> > > > MADV_FILE_FILTER so there is no need to call the syscall range by range.
> > > 
> > > OK, so here is the reason you want that. The immediate question is why
> > > cannot the monitor do the filtering from the userspace. Slightly more
> > > work, all right, but less of an API to expose and that itself is a
> > > strong argument against.
> > 
> > What I should do if we don't have such filter option is to enumerate all of
> > vma via /proc/<pid>/maps and then parse every ranges and inode from string,
> > which would be painful for 2000+ vmas.
> 
> Just out of curiosity, how do you get to 2000+ distinct memory regions
> in the address space of a mobile app? I'm assuming these aren't files,
> but rather anon objects with poor grouping. Is that from guard pages
> between individual heap allocations or something?

Android uses preload library model to speed up app launch so it loads
all of library in advance on zygote and forks new app based on it.
