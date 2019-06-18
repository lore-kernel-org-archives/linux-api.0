From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH] mm, memcg: Report number of memcg caches in slabinfo
Date: Tue, 18 Jun 2019 12:59:24 -0400
Message-ID: <dee4dee2-1f4f-a7c9-0014-dca54b991377@redhat.com>
References: <20190617142149.5245-1-longman@redhat.com>
 <20190617143842.GC1492@dhcp22.suse.cz>
 <9e165eae-e354-04c4-6362-0f80fe819469@redhat.com>
 <20190618123750.GG3318@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190618123750.GG3318@dhcp22.suse.cz>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Michal Hocko <mhocko@kernel.org>
Cc: Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Roman Gushchin <guro@fb.com>, Johannes Weiner <hannes@cmpxchg.org>, Shakeel Butt <shakeelb@google.com>, Vladimir Davydov <vdavydov.dev@gmail.com>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 6/18/19 8:37 AM, Michal Hocko wrote:
> On Mon 17-06-19 10:50:23, Waiman Long wrote:
>> On 6/17/19 10:38 AM, Michal Hocko wrote:
>>> [Cc linux-api]
>>>
>>> On Mon 17-06-19 10:21:49, Waiman Long wrote:
>>>> There are concerns about memory leaks from extensive use of memory
>>>> cgroups as each memory cgroup creates its own set of kmem caches. There
>>>> is a possiblity that the memcg kmem caches may remain even after the
>>>> memory cgroup removal.
>>>>
>>>> Therefore, it will be useful to show how many memcg caches are present
>>>> for each of the kmem caches.
>>> How is a user going to use that information?  Btw. Don't we have an
>>> interface to display the number of (dead) cgroups?
>> The interface to report dead cgroups is for cgroup v2 (cgroup.stat)
>> only. I don't think there is a way to find that for cgroup v1.
> Doesn't debug_legacy_files provide the information for both cgroups
> APIs?

Not really. The debug controller doesn't provide information about the
number of dead cgroups, for instance. Of course, we can always add those
information there. Also the debug controller is not typically configured
into a production kernel.


>> Also the
>> number of memcg kmem caches may not be the same as the number of
>> memcg's. It can range from 0 to above the number of memcg's.  So it is
>> an interesting number by itself.
> Is this useful enough to put into slabinfo? Doesn't this sound more like
> a debugfs kinda a thing?

I guess it is probably more on the debug side of things. I add it to
slabinfo as the data is readily available. It will be much more work if
we need to export the data via debugfs.

We are seeing the kmem_cache slab growing continuously overtime when
running a container-based workloads. Roman's kmem_cache reparenting
patch will hopefully solve a major part of the problem, but we still
need a way to confirm that by looking at how many memcg kmem_caches are
associated with each root kmem_cache.

Cheers,
Longman
