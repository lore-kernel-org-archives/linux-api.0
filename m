From: Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [PATCH 1/3] mm: introduce NR_INDIRECTLY_RECLAIMABLE_BYTES
Date: Wed, 25 Apr 2018 18:59:00 +0200
Message-ID: <04bd46b5-b67b-9b0c-edb9-7e92427b9cef@suse.cz>
References: <20180305133743.12746-1-guro@fb.com>
 <20180305133743.12746-2-guro@fb.com>
 <08524819-14ef-81d0-fa90-d7af13c6b9d5@suse.cz>
 <20180411135624.GA24260@castle.DHCP.thefacebook.com>
 <46dbe2a5-e65f-8b72-f835-0210bc445e52@suse.cz>
 <20180412145702.GB30714@castle.DHCP.thefacebook.com>
 <CAOaiJ-=JtFWNPqdtf+5uim0-LcPE9zSDZmocAa_6K3yGpW2fCQ@mail.gmail.com>
 <20180425155539.GB8546@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180425155539.GB8546@bombadil.infradead.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Wilcox <willy@infradead.org>, vinayak menon <vinayakm.list@gmail.com>
Cc: Roman Gushchin <guro@fb.com>, linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On 04/25/2018 05:55 PM, Matthew Wilcox wrote:
> On Fri, Apr 13, 2018 at 05:43:39PM +0530, vinayak menon wrote:
>> One such case I have encountered is that of the ION page pool. The page pool
>> registers a shrinker. When not in any memory pressure page pool can go high
>> and thus cause an mmap to fail when OVERCOMMIT_GUESS is set. I can send
>> a patch to account ION page pool pages in NR_INDIRECTLY_RECLAIMABLE_BYTES.
> 
> Why not just account them as NR_SLAB_RECLAIMABLE?  I know it's not slab, but
> other than that mis-naming, it seems like it'll do the right thing.

Hm I think it would be confusing for anyone trying to correlate the
number with /proc/slabinfo - the numbers there wouldn't add up.
