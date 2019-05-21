From: Minchan Kim <minchan@kernel.org>
Subject: Re: [RFC 6/7] mm: extend process_madvise syscall to support vector
 arrary
Date: Tue, 21 May 2019 19:26:13 +0900
Message-ID: <20190521102613.GC219653@google.com>
References: <20190520035254.57579-1-minchan@kernel.org>
 <20190520035254.57579-7-minchan@kernel.org>
 <20190520092258.GZ6836@dhcp22.suse.cz>
 <20190521024820.GG10039@google.com>
 <20190521062421.GD32329@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190521062421.GD32329@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Michal Hocko <mhocko@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, Johannes Weiner <hannes@cmpxchg.org>, Tim Murray <timmurray@google.com>, Joel Fernandes <joel@joelfernandes.org>, Suren Baghdasaryan <surenb@google.com>, Daniel Colascione <dancol@google.com>, Shakeel Butt <shakeelb@google.com>, Sonny Rao <sonnyrao@google.com>, Brian Geffon <bgeffon@google.com>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Tue, May 21, 2019 at 08:24:21AM +0200, Michal Hocko wrote:
> On Tue 21-05-19 11:48:20, Minchan Kim wrote:
> > On Mon, May 20, 2019 at 11:22:58AM +0200, Michal Hocko wrote:
> > > [Cc linux-api]
> > > 
> > > On Mon 20-05-19 12:52:53, Minchan Kim wrote:
> > > > Currently, process_madvise syscall works for only one address range
> > > > so user should call the syscall several times to give hints to
> > > > multiple address range.
> > > 
> > > Is that a problem? How big of a problem? Any numbers?
> > 
> > We easily have 2000+ vma so it's not trivial overhead. I will come up
> > with number in the description at respin.
> 
> Does this really have to be a fast operation? I would expect the monitor
> is by no means a fast path. The system call overhead is not what it used
> to be, sigh, but still for something that is not a hot path it should be
> tolerable, especially when the whole operation is quite expensive on its
> own (wrt. the syscall entry/exit).

What's different with process_vm_[readv|writev] and vmsplice?
If the range needed to be covered is a lot, vector operation makes senese
to me.

> 
> I am not saying we do not need a multiplexing API, I am just not sure
> we need it right away. Btw. there was some demand for other MM syscalls
> to provide a multiplexing API (e.g. mprotect), maybe it would be better
> to handle those in one go?

That's the exactly what Daniel Colascione suggested from internal
review. That would be a interesting approach if we could aggregate
all of system call in one go.

> -- 
> Michal Hocko
> SUSE Labs
