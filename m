From: Minchan Kim <minchan@kernel.org>
Subject: Re: [RFC 7/7] mm: madvise support MADV_ANONYMOUS_FILTER and
 MADV_FILE_FILTER
Date: Tue, 28 May 2019 17:49:27 +0900
Message-ID: <20190528084927.GB159710@google.com>
References: <20190520035254.57579-8-minchan@kernel.org>
 <20190520092801.GA6836@dhcp22.suse.cz>
 <20190521025533.GH10039@google.com>
 <20190521062628.GE32329@dhcp22.suse.cz>
 <20190527075811.GC6879@google.com>
 <20190527124411.GC1658@dhcp22.suse.cz>
 <20190528032632.GF6879@google.com>
 <20190528062947.GL1658@dhcp22.suse.cz>
 <20190528081351.GA159710@google.com>
 <CAKOZuesnS6kBFX-PKJ3gvpkv8i-ysDOT2HE2Z12=vnnHQv0FDA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAKOZuesnS6kBFX-PKJ3gvpkv8i-ysDOT2HE2Z12=vnnHQv0FDA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Daniel Colascione <dancol@google.com>
Cc: Michal Hocko <mhocko@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, Johannes Weiner <hannes@cmpxchg.org>, Tim Murray <timmurray@google.com>, Joel Fernandes <joel@joelfernandes.org>, Suren Baghdasaryan <surenb@google.com>, Shakeel Butt <shakeelb@google.com>, Sonny Rao <sonnyrao@google.com>, Brian Geffon <bgeffon@google.com>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, May 28, 2019 at 01:31:13AM -0700, Daniel Colascione wrote:
> On Tue, May 28, 2019 at 1:14 AM Minchan Kim <minchan@kernel.org> wrote:
> > if we went with the per vma fd approach then you would get this
> > > feature automatically because map_files would refer to file backed
> > > mappings while map_anon could refer only to anonymous mappings.
> >
> > The reason to add such filter option is to avoid the parsing overhead
> > so map_anon wouldn't be helpful.
> 
> Without chiming on whether the filter option is a good idea, I'd like
> to suggest that providing an efficient binary interfaces for pulling
> memory map information out of processes.  Some single-system-call
> method for retrieving a binary snapshot of a process's address space
> complete with attributes (selectable, like statx?) for each VMA would
> reduce complexity and increase performance in a variety of areas,
> e.g., Android memory map debugging commands.

I agree it's the best we can get *generally*.
Michal, any opinion?
