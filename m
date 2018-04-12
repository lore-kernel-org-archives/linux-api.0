From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH 1/3] mm: introduce NR_INDIRECTLY_RECLAIMABLE_BYTES
Date: Thu, 12 Apr 2018 13:52:17 +0200
Message-ID: <20180412115217.GC23400@dhcp22.suse.cz>
References: <20180305133743.12746-1-guro@fb.com>
 <20180305133743.12746-2-guro@fb.com>
 <08524819-14ef-81d0-fa90-d7af13c6b9d5@suse.cz>
 <20180411135624.GA24260@castle.DHCP.thefacebook.com>
 <46dbe2a5-e65f-8b72-f835-0210bc445e52@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <46dbe2a5-e65f-8b72-f835-0210bc445e52@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Roman Gushchin <guro@fb.com>, linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Johannes Weiner <hannes@cmpxchg.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu 12-04-18 08:52:52, Vlastimil Babka wrote:
> On 04/11/2018 03:56 PM, Roman Gushchin wrote:
> > On Wed, Apr 11, 2018 at 03:16:08PM +0200, Vlastimil Babka wrote:
[...]
> >> With that in mind, can we at least for now put the (manually maintained)
> >> byte counter in a variable that's not directly exposed via /proc/vmstat,
> >> and then when printing nr_slab_reclaimable, simply add the value
> >> (divided by PAGE_SIZE), and when printing nr_slab_unreclaimable,
> >> subtract the same value. This way we would be simply making the existing
> >> counters more precise, in line with their semantics.
> > 
> > Idk, I don't like the idea of adding a counter outside of the vm counters
> > infrastructure, and I definitely wouldn't touch the exposed
> > nr_slab_reclaimable and nr_slab_unreclaimable fields.

Why?

> We would be just making the reported values more precise wrt reality.

I was suggesting something similar in an earlier discussion. I am not
really happy about the new exposed counter either. It is just arbitrary
by name yet very specific for this particular usecase.

What is a poor user supposed to do with the new counter? Can this be
used for any calculations?
-- 
Michal Hocko
SUSE Lab
