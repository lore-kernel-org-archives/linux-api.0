From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: Re: [PATCH RFC] mm/madvise: implement MADV_STOCKPILE (kswapd from
 user space)
Date: Tue, 28 May 2019 09:25:13 +0300
Message-ID: <9c55a343-2a91-46c6-166d-41b94bf5e9c8@yandex-team.ru>
References: <155895155861.2824.318013775811596173.stgit@buzz>
 <20190527141223.GD1658@dhcp22.suse.cz> <20190527142156.GE1658@dhcp22.suse.cz>
 <20190527143926.GF1658@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190527143926.GF1658@dhcp22.suse.cz>
Content-Language: en-CA
Sender: linux-kernel-owner@vger.kernel.org
To: Michal Hocko <mhocko@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, Vladimir Davydov <vdavydov.dev@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@techsingularity.net>, Roman Gushchin <guro@fb.com>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 27.05.2019 17:39, Michal Hocko wrote:
> On Mon 27-05-19 16:21:56, Michal Hocko wrote:
>> On Mon 27-05-19 16:12:23, Michal Hocko wrote:
>>> [Cc linux-api. Please always cc this list when proposing a new user
>>>   visible api. Keeping the rest of the email intact for reference]
>>>
>>> On Mon 27-05-19 13:05:58, Konstantin Khlebnikov wrote:
>> [...]
>>>> This implements manual kswapd-style memory reclaim initiated by userspace.
>>>> It reclaims both physical memory and cgroup pages. It works in context of
>>>> task who calls syscall madvise thus cpu time is accounted correctly.
>>
>> I do not follow. Does this mean that the madvise always reclaims from
>> the memcg the process is member of?
> 
> OK, I've had a quick look at the implementation (the semantic should be
> clear from the patch descrition btw.) and it goes all the way up the
> hierarchy and finally try to impose the same limit to the global state.
> This doesn't really make much sense to me. For few reasons.
> 
> First of all it breaks isolation where one subgroup can influence a
> different hierarchy via parent reclaim.

madvise(NULL, size, MADV_STOCKPILE) is the same as memory allocation and
freeing immediately, but without pinning memory and provoking oom.

So, there is shouldn't be any isolation or security issues.

At least probably it should be limited with portion of limit (like half)
instead of whole limit as it does now.

> 
> I also have a problem with conflating the global and memcg states. Does
> it really make any sense to have the same target to the global state
> as per-memcg? How are you supposed to use this interface to shrink a
> particular memcg or for the global situation with a proportional
> distribution to all memcgs?

For now this is out of my use cease. This could be done in userspace
with multiple daemons in different contexts and connection between them.
In this case each daemon should apply pressure only its own level.

Also kernel could remember static pressure applied from each cgroup which
fades away when memory is allocated. And each call adds this pressure to
own requests to cooperate with neighbours. But rhight I don't know how to
implement this without over-engineering. Pure userspace solution looks
much better.

> 
> There also doens't seem to be anything about security model for this
> operation. There is no capability check from a quick look. Is it really
> safe to expose such a functionality for a common user?

Yep, it seems save. This is same as memory allocation and freeing.

> 
> Last but not least, I am not really convinced that madvise is a proper
> interface. It stretches the API which is address range based and it has
> per-process implications.
> 

Well, this is silly but semantic could be explained as preparation for
memory allocation via faulting into region. But since it doesn't need
to know exact range starting address could be arbitrary.

Also we employ MADV_POPULATE which implements batched faults into range
for robust memory allocation and undo for MADV_FREE. Will publish later.
