From: Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [RFC PATCH 0/5] kmalloc-reclaimable caches
Date: Thu, 24 May 2018 17:52:25 +0200
Message-ID: <fea26519-2b5f-b404-872d-47afabcd3393@suse.cz>
References: <20180524110011.1940-1-vbabka@suse.cz>
 <20180524121347.GA10763@castle.DHCP.thefacebook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180524121347.GA10763@castle.DHCP.thefacebook.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Roman Gushchin <guro@fb.com>
Cc: linux-mm@kvack.org, Michal Hocko <mhocko@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Mel Gorman <mgorman@techsingularity.net>, Vijayanand Jitta <vjitta@codeaurora.org>, Laura Abbott <labbott@redhat.com>
List-Id: linux-api@vger.kernel.org

On 05/24/2018 02:13 PM, Roman Gushchin wrote:
> On Thu, May 24, 2018 at 01:00:06PM +0200, Vlastimil Babka wrote:
>> Hi,
>>
>> - I haven't find any other obvious users for reclaimable kmalloc (yet)
> 
> As I remember, ION memory allocator was discussed related to this theme:
> https://lkml.org/lkml/2018/4/24/1288

+CC Laura

Yeah ION added the NR_INDIRECTLY_RECLAIMABLE_BYTES handling, which is
adjusted to page granularity in patch 4. I'm not sure if it should use
kmalloc as it seems to be allocating order-X pages, where kmalloc/slab
just means extra overhead. But maybe if it doesn't allocate/free too
frequently, it could work?

>> I did a superset as IIRC somebody suggested that in the older threads or at LSF.
> 
> This looks nice to me!
> 
> Thanks!
> 
