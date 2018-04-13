From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH 1/3] mm: introduce NR_INDIRECTLY_RECLAIMABLE_BYTES
Date: Fri, 13 Apr 2018 08:59:44 +0200
Message-ID: <20180413065944.GE17484@dhcp22.suse.cz>
References: <20180305133743.12746-1-guro@fb.com>
 <20180305133743.12746-2-guro@fb.com>
 <08524819-14ef-81d0-fa90-d7af13c6b9d5@suse.cz>
 <20180411135624.GA24260@castle.DHCP.thefacebook.com>
 <46dbe2a5-e65f-8b72-f835-0210bc445e52@suse.cz>
 <20180412145702.GB30714@castle.DHCP.thefacebook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180412145702.GB30714@castle.DHCP.thefacebook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Roman Gushchin <guro@fb.com>
Cc: Vlastimil Babka <vbabka@suse.cz>, linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Johannes Weiner <hannes@cmpxchg.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu 12-04-18 15:57:03, Roman Gushchin wrote:
> On Thu, Apr 12, 2018 at 08:52:52AM +0200, Vlastimil Babka wrote:
[...]
> > We would be just making the reported values more precise wrt reality.
> 
> It depends on if we believe that only slab memory can be reclaimable
> or not. If yes, this is true, otherwise not.
> 
> My guess is that some drivers (e.g. networking) might have buffers,
> which are reclaimable under mempressure, and are allocated using
> the page allocator. But I have to look closer...

Well, we have many direct page allocator users which are not accounted
in vmstat. Some of those use their specific accounting (e.g. network
buffers, some fs metadata a many others). In the ideal world MM layer
would know about those but...

Anyway, this particular case is quite clear, no? We _use_ kmalloc so
this is slab allocator. We just misaccount it.

-- 
Michal Hocko
SUSE Labs
