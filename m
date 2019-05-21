From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [RFC 1/7] mm: introduce MADV_COOL
Date: Tue, 21 May 2019 08:04:43 +0200
Message-ID: <20190521060443.GA32329@dhcp22.suse.cz>
References: <20190520035254.57579-1-minchan@kernel.org>
 <20190520035254.57579-2-minchan@kernel.org>
 <20190520081621.GV6836@dhcp22.suse.cz>
 <20190520225419.GA10039@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190520225419.GA10039@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Minchan Kim <minchan@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, Johannes Weiner <hannes@cmpxchg.org>, Tim Murray <timmurray@google.com>, Joel Fernandes <joel@joelfernandes.org>, Suren Baghdasaryan <surenb@google.com>, Daniel Colascione <dancol@google.com>, Shakeel Butt <shakeelb@google.com>, Sonny Rao <sonnyrao@google.com>, Brian Geffon <bgeffon@google.com>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Tue 21-05-19 07:54:19, Minchan Kim wrote:
> On Mon, May 20, 2019 at 10:16:21AM +0200, Michal Hocko wrote:
[...]
> > > Internally, it works via deactivating memory from active list to
> > > inactive's head so when the memory pressure happens, they will be
> > > reclaimed earlier than other active pages unless there is no
> > > access until the time.
> > 
> > Could you elaborate about the decision to move to the head rather than
> > tail? What should happen to inactive pages? Should we move them to the
> > tail? Your implementation seems to ignore those completely. Why?
> 
> Normally, inactive LRU could have used-once pages without any mapping
> to user's address space. Such pages would be better candicate to
> reclaim when the memory pressure happens. With deactivating only
> active LRU pages of the process to the head of inactive LRU, we will
> keep them in RAM longer than used-once pages and could have more chance
> to be activated once the process is resumed.

You are making some assumptions here. You have an explicit call what is
cold now you are assuming something is even colder. Is this assumption a
general enough to make people depend on it? Not that we wouldn't be able
to change to logic later but that will always be risky - especially in
the area when somebody want to make a user space driven memory
management.
 
> > What should happen for shared pages? In other words do we want to allow
> > less privileged process to control evicting of shared pages with a more
> > privileged one? E.g. think of all sorts of side channel attacks. Maybe
> > we want to do the same thing as for mincore where write access is
> > required.
> 
> It doesn't work with shared pages(ie, page_mapcount > 1). I will add it
> in the description.

OK, this is good for the starter. It makes the implementation simpler
and we can add shared mappings coverage later.

Although I would argue that touching only writeable mappings should be
reasonably safe.

-- 
Michal Hocko
SUSE Labs
