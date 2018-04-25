From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH 1/3] mm: introduce NR_INDIRECTLY_RECLAIMABLE_BYTES
Date: Wed, 25 Apr 2018 13:52:12 +0100
Message-ID: <20180425125211.GB3410@castle>
References: <20180305133743.12746-1-guro@fb.com>
 <20180305133743.12746-2-guro@fb.com>
 <08524819-14ef-81d0-fa90-d7af13c6b9d5@suse.cz>
 <20180411135624.GA24260@castle.DHCP.thefacebook.com>
 <46dbe2a5-e65f-8b72-f835-0210bc445e52@suse.cz>
 <20180412145702.GB30714@castle.DHCP.thefacebook.com>
 <CAOaiJ-=JtFWNPqdtf+5uim0-LcPE9zSDZmocAa_6K3yGpW2fCQ@mail.gmail.com>
 <69b4dcd8-1925-e0e8-d9b4-776f3405b769@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <69b4dcd8-1925-e0e8-d9b4-776f3405b769@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Vijayanand Jitta <vjitta@codeaurora.org>
Cc: vinayak menon <vinayakm.list@gmail.com>, Vlastimil Babka <vbabka@suse.cz>, linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Wed, Apr 25, 2018 at 09:19:29AM +0530, Vijayanand Jitta wrote:
> >>>> Idk, I don't like the idea of adding a counter outside of the vm counters
> >>>> infrastructure, and I definitely wouldn't touch the exposed
> >>>> nr_slab_reclaimable and nr_slab_unreclaimable fields.
> >>>
> >>> We would be just making the reported values more precise wrt reality.
> >>
> >> It depends on if we believe that only slab memory can be reclaimable
> >> or not. If yes, this is true, otherwise not.
> >>
> >> My guess is that some drivers (e.g. networking) might have buffers,
> >> which are reclaimable under mempressure, and are allocated using
> >> the page allocator. But I have to look closer...
> >>
> > 
> > One such case I have encountered is that of the ION page pool. The page pool
> > registers a shrinker. When not in any memory pressure page pool can go high
> > and thus cause an mmap to fail when OVERCOMMIT_GUESS is set. I can send
> > a patch to account ION page pool pages in NR_INDIRECTLY_RECLAIMABLE_BYTES.

Perfect!
This is exactly what I've expected.

> > 
> > Thanks,
> > Vinayak
> > 
> 
> As Vinayak mentioned NR_INDIRECTLY_RECLAIMABLE_BYTES can be used to solve the issue
> with ION page pool when OVERCOMMIT_GUESS is set, the patch for the same can be 
> found here https://lkml.org/lkml/2018/4/24/1288

This makes perfect sense to me.

Please, fell free to add:
Acked-by: Roman Gushchin <guro@fb.com>

Thank you!
