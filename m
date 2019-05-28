From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: Re: [PATCH RFC] mm/madvise: implement MADV_STOCKPILE (kswapd from
 user space)
Date: Tue, 28 May 2019 11:58:49 +0300
Message-ID: <4ecf491b-68b5-9a65-5074-648a4f94d2b0@yandex-team.ru>
References: <155895155861.2824.318013775811596173.stgit@buzz>
 <20190527141223.GD1658@dhcp22.suse.cz> <20190527142156.GE1658@dhcp22.suse.cz>
 <20190527143926.GF1658@dhcp22.suse.cz>
 <9c55a343-2a91-46c6-166d-41b94bf5e9c8@yandex-team.ru>
 <20190528065153.GB1803@dhcp22.suse.cz>
 <a4e5eeb8-3560-d4b4-08a0-8a22c677c0f7@yandex-team.ru>
 <20190528073835.GP1658@dhcp22.suse.cz>
 <5af1ba69-61d1-1472-4aa3-20beb4ae44ae@yandex-team.ru>
 <20190528084243.GT1658@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190528084243.GT1658@dhcp22.suse.cz>
Content-Language: en-CA
Sender: linux-kernel-owner@vger.kernel.org
To: Michal Hocko <mhocko@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, Vladimir Davydov <vdavydov.dev@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@techsingularity.net>, Roman Gushchin <guro@fb.com>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 28.05.2019 11:42, Michal Hocko wrote:
> On Tue 28-05-19 11:04:46, Konstantin Khlebnikov wrote:
>> On 28.05.2019 10:38, Michal Hocko wrote:
> [...]
>>> Could you define the exact semantic? Ideally something for the manual
>>> page please?
>>>
>>
>> Like kswapd which works with thresholds of free memory this one reclaims
>> until 'free' (i.e. memory which could be allocated without invoking
>> direct recliam of any kind) is lower than passed 'size' argument.
> 
> s@lower@higher@ I guess

Yep. My wording still bad.
'size' argument should be called 'watermark' or 'threshold'.

I.e. reclaim while 'free' memory is lower passed 'threshold'.

> 
>> Thus right after madvise(NULL, size, MADV_STOCKPILE) 'size' bytes
>> could be allocated in this memory cgroup without extra latency from
>> reclaimer if there is no other memory consumers.
>>
>> Reclaimed memory is simply put into free lists in common buddy allocator,
>> there is no reserves for particular task or cgroup.
>>
>> If overall memory allocation rate is smooth without rough spikes then
>> calling MADV_STOCKPILE in loop periodically provides enough room for
>> allocations and eliminates direct reclaim from all other tasks.
>> As a result this eliminates unpredictable delays caused by
>> direct reclaim in random places.
> 
> OK, this makes it more clear to me. Thanks for the clarification!
> I have clearly misunderstood and misinterpreted target as the reclaim
> target rather than free memory target.  Sorry about the confusion.
> I sill think that this looks like an abuse of the madvise but if there
> is a wider consensus this is acceptable I will not stand in the way.
> 
