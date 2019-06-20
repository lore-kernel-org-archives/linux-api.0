From: Minchan Kim <minchan@kernel.org>
Subject: Re: [PATCH v2 1/5] mm: introduce MADV_COLD
Date: Thu, 20 Jun 2019 17:44:06 +0900
Message-ID: <20190620084406.GE105727@google.com>
References: <20190610111252.239156-1-minchan@kernel.org>
 <20190610111252.239156-2-minchan@kernel.org>
 <20190619125611.GO2968@dhcp22.suse.cz>
 <20190620000650.GB52978@google.com>
 <20190620070854.GC12083@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190620070854.GC12083@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Michal Hocko <mhocko@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>, Tim Murray <timmurray@google.com>, Joel Fernandes <joel@joelfernandes.org>, Suren Baghdasaryan <surenb@google.com>, Daniel Colascione <dancol@google.com>, Shakeel Butt <shakeelb@google.com>, Sonny Rao <sonnyrao@google.com>, Brian Geffon <bgeffon@google.com>, jannh@google.com, oleg@redhat.com, christian@brauner.io, oleksandr@redhat.com, hdanton@sina.com, lizeb@google.com
List-Id: linux-api@vger.kernel.org

On Thu, Jun 20, 2019 at 09:08:54AM +0200, Michal Hocko wrote:
> On Thu 20-06-19 09:06:51, Minchan Kim wrote:
> > On Wed, Jun 19, 2019 at 02:56:12PM +0200, Michal Hocko wrote:
> [...]
> > > Why cannot we reuse a large part of that code and differ essentially on
> > > the reclaim target check and action? Have you considered to consolidate
> > > the code to share as much as possible? Maybe that is easier said than
> > > done because the devil is always in details...
> > 
> > Yub, it was not pretty when I tried. Please see last patch in this
> > patchset.
> 
> That is bad because this code is quite subtle - especially the THP part
> of it. I will be staring at the code some more. Maybe some
> simplification pops out.

Yeah, I couldn't come up with better idea. Actually, I wanted to be
left. More suggestion to make simple/readable would be great.
