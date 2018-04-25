From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH 1/3] mm: introduce NR_INDIRECTLY_RECLAIMABLE_BYTES
Date: Wed, 25 Apr 2018 08:55:39 -0700
Message-ID: <20180425155539.GB8546@bombadil.infradead.org>
References: <20180305133743.12746-1-guro@fb.com>
 <20180305133743.12746-2-guro@fb.com>
 <08524819-14ef-81d0-fa90-d7af13c6b9d5@suse.cz>
 <20180411135624.GA24260@castle.DHCP.thefacebook.com>
 <46dbe2a5-e65f-8b72-f835-0210bc445e52@suse.cz>
 <20180412145702.GB30714@castle.DHCP.thefacebook.com>
 <CAOaiJ-=JtFWNPqdtf+5uim0-LcPE9zSDZmocAa_6K3yGpW2fCQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAOaiJ-=JtFWNPqdtf+5uim0-LcPE9zSDZmocAa_6K3yGpW2fCQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: vinayak menon <vinayakm.list@gmail.com>
Cc: Roman Gushchin <guro@fb.com>, Vlastimil Babka <vbabka@suse.cz>, linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Fri, Apr 13, 2018 at 05:43:39PM +0530, vinayak menon wrote:
> One such case I have encountered is that of the ION page pool. The page pool
> registers a shrinker. When not in any memory pressure page pool can go high
> and thus cause an mmap to fail when OVERCOMMIT_GUESS is set. I can send
> a patch to account ION page pool pages in NR_INDIRECTLY_RECLAIMABLE_BYTES.

Why not just account them as NR_SLAB_RECLAIMABLE?  I know it's not slab, but
other than that mis-naming, it seems like it'll do the right thing.
