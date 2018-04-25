From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH] mm: don't show nr_indirectly_reclaimable in /proc/vmstat
Date: Wed, 25 Apr 2018 22:01:49 +0100
Message-ID: <20180425210143.GA10277@castle>
References: <20180425191422.9159-1-guro@fb.com>
 <alpine.DEB.2.21.1804251235330.151692@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.21.1804251235330.151692@chino.kir.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: David Rientjes <rientjes@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, kernel-team@fb.com, Vlastimil Babka <vbabka@suse.cz>, Matthew Wilcox <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>
List-Id: linux-api@vger.kernel.org

On Wed, Apr 25, 2018 at 12:37:26PM -0700, David Rientjes wrote:
> On Wed, 25 Apr 2018, Roman Gushchin wrote:
> 
> > Don't show nr_indirectly_reclaimable in /proc/vmstat,
> > because there is no need in exporting this vm counter
> > to the userspace, and some changes are expected
> > in reclaimable object accounting, which can alter
> > this counter.
> > 
> 
> I don't think it should be a per-node vmstat, in this case.  It appears 
> only to be used for the global context.  Shouldn't this be handled like 
> totalram_pages, total_swap_pages, totalreserve_pages, etc?

Hi, David!

I don't see any reasons why re-using existing infrastructure for
fast vm counters is bad, and why should we re-invent it for this case.

Thanks!
