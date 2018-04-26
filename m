From: David Rientjes <rientjes@google.com>
Subject: Re: [PATCH] mm: don't show nr_indirectly_reclaimable in
 /proc/vmstat
Date: Thu, 26 Apr 2018 14:55:05 -0700 (PDT)
Message-ID: <alpine.DEB.2.21.1804261453460.238822@chino.kir.corp.google.com>
References: <20180425191422.9159-1-guro@fb.com> <20180426200331.GZ17484@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180426200331.GZ17484@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <guro@fb.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, kernel-team@fb.com, Vlastimil Babka <vbabka@suse.cz>, Matthew Wilcox <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Johannes Weiner <hannes@cmpxchg.org>
List-Id: linux-api@vger.kernel.org

On Thu, 26 Apr 2018, Michal Hocko wrote:

> > Don't show nr_indirectly_reclaimable in /proc/vmstat,
> > because there is no need in exporting this vm counter
> > to the userspace, and some changes are expected
> > in reclaimable object accounting, which can alter
> > this counter.
> > 
> > Signed-off-by: Roman Gushchin <guro@fb.com>
> > Cc: Vlastimil Babka <vbabka@suse.cz>
> > Cc: Matthew Wilcox <willy@infradead.org>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> > Cc: Michal Hocko <mhocko@suse.com>
> > Cc: Johannes Weiner <hannes@cmpxchg.org>
> 
> This is quite a hack. I would much rather revert the counter and fixed
> it the way Vlastimil has proposed. But if there is a strong opposition
> to the revert then this is probably the simples thing to do. Therefore
> 

Implementing this counter as a vmstat doesn't make much sense based on how 
it's used.  Do you have a link to what Vlastimil proposed?  I haven't seen 
mention of alternative ideas.
