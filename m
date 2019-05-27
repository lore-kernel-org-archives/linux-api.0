From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: Re: [PATCH RFC] mm/madvise: implement MADV_STOCKPILE (kswapd from
 user space)
Date: Mon, 27 May 2019 17:30:31 +0300
Message-ID: <e17e1370-9e88-e50c-94e3-736c122c1baf@yandex-team.ru>
References: <155895155861.2824.318013775811596173.stgit@buzz>
 <20190527141223.GD1658@dhcp22.suse.cz> <20190527142156.GE1658@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190527142156.GE1658@dhcp22.suse.cz>
Content-Language: en-CA
Sender: linux-kernel-owner@vger.kernel.org
To: Michal Hocko <mhocko@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, Vladimir Davydov <vdavydov.dev@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@techsingularity.net>, Roman Gushchin <guro@fb.com>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 27.05.2019 17:21, Michal Hocko wrote:
> On Mon 27-05-19 16:12:23, Michal Hocko wrote:
>> [Cc linux-api. Please always cc this list when proposing a new user
>>   visible api. Keeping the rest of the email intact for reference]
>>
>> On Mon 27-05-19 13:05:58, Konstantin Khlebnikov wrote:
> [...]
>>> This implements manual kswapd-style memory reclaim initiated by userspace.
>>> It reclaims both physical memory and cgroup pages. It works in context of
>>> task who calls syscall madvise thus cpu time is accounted correctly.
> 
> I do not follow. Does this mean that the madvise always reclaims from
> the memcg the process is member of?
> 

First it reclaims in its own memcg while limit - usage < requested.
Then repeats this in parent memcg and so on. And at least pokes global
direct reclaimer while system wide free memory is less than requested.

So, if machine is divided into containers without overcommit global
reclaim will never happens - memcg will free enough memory.
