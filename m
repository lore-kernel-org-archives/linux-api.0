From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH] mm: don't show nr_indirectly_reclaimable in /proc/vmstat
Date: Fri, 27 Apr 2018 11:57:08 -0700
Message-ID: <20180427185708.GA2444@bombadil.infradead.org>
References: <20180425191422.9159-1-guro@fb.com>
 <20180426200331.GZ17484@dhcp22.suse.cz>
 <alpine.DEB.2.21.1804261453460.238822@chino.kir.corp.google.com>
 <99208563-1171-b7e7-a0d7-b47b6c5e2307@suse.cz>
 <alpine.DEB.2.21.1804271139500.152082@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.21.1804271139500.152082@chino.kir.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: David Rientjes <rientjes@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <guro@fb.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, kernel-team@fb.com, Andrew Morton <akpm@linux-foundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Johannes Weiner <hannes@cmpxchg.org>
List-Id: linux-api@vger.kernel.org

On Fri, Apr 27, 2018 at 11:41:31AM -0700, David Rientjes wrote:
> On Fri, 27 Apr 2018, Vlastimil Babka wrote:
> 
> > It was in the original thread, see e.g.
> > <08524819-14ef-81d0-fa90-d7af13c6b9d5@suse.cz>
> > 
> > However it will take some time to get that in mainline, and meanwhile
> > the current implementation does prevent a DOS. So I doubt it can be
> > fully reverted - as a compromise I just didn't want the counter to
> > become ABI. TBH though, other people at LSF/MM didn't seem concerned
> > that /proc/vmstat is an ABI that we can't change (i.e. counters have
> > been presumably removed in the past already).
> > 
> 
> What prevents this from being a simple atomic_t that gets added to in 
> __d_alloc(), subtracted from in __d_free_external_name(), and read in 
> si_mem_available() and __vm_enough_memory()?

I'd think you'd want one atomic_t per NUMA node at least ...
