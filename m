From: Yang Shi <yang.shi@linux.alibaba.com>
Subject: Re: [RESEND PATCH 1/2 -mm] mm: account lazy free pages separately
Date: Wed, 14 Aug 2019 21:53:30 -0700
Message-ID: <96bd67c0-e53e-9802-a461-19ce47bba021@linux.alibaba.com>
References: <1565308665-24747-1-git-send-email-yang.shi@linux.alibaba.com>
 <20190809083216.GM18351@dhcp22.suse.cz>
 <1a3c4185-c7ab-8d6f-8191-77dce02025a7@linux.alibaba.com>
 <20190809180238.GS18351@dhcp22.suse.cz>
 <79c90f6b-fcac-02e1-015a-0eaa4eafdf7d@linux.alibaba.com>
 <564a0860-94f1-6301-5527-5c2272931d8b@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <564a0860-94f1-6301-5527-5c2272931d8b@suse.cz>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@kernel.org>
Cc: kirill.shutemov@linux.intel.com, hannes@cmpxchg.org, rientjes@google.com, akpm@linux-foundation.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org



On 8/14/19 5:49 AM, Vlastimil Babka wrote:
> On 8/9/19 8:26 PM, Yang Shi wrote:
>> Here the new counter is introduced for patch 2/2 to account deferred
>> split THPs into available memory since NR_ANON_THPS may contain
>> non-deferred split THPs.
>>
>> I could use an internal counter for deferred split THPs, but if it is
>> accounted by mod_node_page_state, why not just show it in /proc/meminfo?
> The answer to "Why not" is that it becomes part of userspace API (btw this
> patchset should have CC'd linux-api@ - please do for further iterations) and
> even if the implementation detail of deferred splitting might change in the
> future, we'll basically have to keep the counter (even with 0 value) in
> /proc/meminfo forever.
>
> Also, quite recently we have added the following counter:
>
> KReclaimable: Kernel allocations that the kernel will attempt to reclaim
>                under memory pressure. Includes SReclaimable (below), and other
>                direct allocations with a shrinker.
>
> Although THP allocations are not exactly "kernel allocations", once they are
> unmapped, they are in fact kernel-only, so IMHO it wouldn't be a big stretch to
> add the lazy THP pages there?

Thanks a lot for the suggestion. I agree it may be a good fit. Hope 
"kernel allocations" not cause confusion. But, we can explain in the 
documentation.

>
>> Or we fix NR_ANON_THPS and show deferred split THPs in /proc/meminfo?
>>
