From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH] mm, memcg: Report number of memcg caches in slabinfo
Date: Tue, 18 Jun 2019 15:27:24 -0400
Message-ID: <681ed4dc-e8a5-afcf-98b6-c17544c6094d@redhat.com>
References: <20190617142149.5245-1-longman@redhat.com>
 <20190617143842.GC1492@dhcp22.suse.cz>
 <9e165eae-e354-04c4-6362-0f80fe819469@redhat.com>
 <20190618123750.GG3318@dhcp22.suse.cz>
 <dee4dee2-1f4f-a7c9-0014-dca54b991377@redhat.com>
 <20190618183208.GK3318@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190618183208.GK3318@dhcp22.suse.cz>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Michal Hocko <mhocko@kernel.org>
Cc: Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Roman Gushchin <guro@fb.com>, Johannes Weiner <hannes@cmpxchg.org>, Shakeel Butt <shakeelb@google.com>, Vladimir Davydov <vdavydov.dev@gmail.com>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 6/18/19 2:32 PM, Michal Hocko wrote:
> On Tue 18-06-19 12:59:24, Waiman Long wrote:
>> On 6/18/19 8:37 AM, Michal Hocko wrote:
> [...]
>>> Is this useful enough to put into slabinfo? Doesn't this sound more like
>>> a debugfs kinda a thing?
>> I guess it is probably more on the debug side of things. I add it to
>> slabinfo as the data is readily available. It will be much more work if
>> we need to export the data via debugfs.
>>
>> We are seeing the kmem_cache slab growing continuously overtime when
>> running a container-based workloads. Roman's kmem_cache reparenting
>> patch will hopefully solve a major part of the problem, but we still
>> need a way to confirm that by looking at how many memcg kmem_caches are
>> associated with each root kmem_cache.
> I am not disputing usefulness. Dead memcgs are showing up as a problem
> for a longer time and having a more debugging information is definitely
> useful. I am just not really sure that /proc/slabinfo is the proper
> vehicle for that information. It might be just easier to stick it there
> but that is not the best justification for adding something we will have
> to maintain for ever. Not to mention that the number of dead memcgs
> might not be enough to debug further when we can easily end up needing
> to provide more in something less "carved in stone" kinda interface like
> debugfs.
>
Fair enough.

I will rework the patch and expose the information via debugfs then.

Cheers,
Longman
