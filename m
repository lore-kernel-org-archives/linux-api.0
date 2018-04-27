From: Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [PATCH] mm: don't show nr_indirectly_reclaimable in /proc/vmstat
Date: Fri, 27 Apr 2018 11:17:01 +0200
Message-ID: <99208563-1171-b7e7-a0d7-b47b6c5e2307@suse.cz>
References: <20180425191422.9159-1-guro@fb.com>
 <20180426200331.GZ17484@dhcp22.suse.cz>
 <alpine.DEB.2.21.1804261453460.238822@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.21.1804261453460.238822@chino.kir.corp.google.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: David Rientjes <rientjes@google.com>, Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <guro@fb.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, kernel-team@fb.com, Matthew Wilcox <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Johannes Weiner <hannes@cmpxchg.org>
List-Id: linux-api@vger.kernel.org

On 04/26/2018 11:55 PM, David Rientjes wrote:
> On Thu, 26 Apr 2018, Michal Hocko wrote:
> 
>>> Don't show nr_indirectly_reclaimable in /proc/vmstat,
>>> because there is no need in exporting this vm counter
>>> to the userspace, and some changes are expected
>>> in reclaimable object accounting, which can alter
>>> this counter.
>>>
>>> Signed-off-by: Roman Gushchin <guro@fb.com>
>>> Cc: Vlastimil Babka <vbabka@suse.cz>
>>> Cc: Matthew Wilcox <willy@infradead.org>
>>> Cc: Andrew Morton <akpm@linux-foundation.org>
>>> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
>>> Cc: Michal Hocko <mhocko@suse.com>
>>> Cc: Johannes Weiner <hannes@cmpxchg.org>
>>
>> This is quite a hack. I would much rather revert the counter and fixed
>> it the way Vlastimil has proposed. But if there is a strong opposition
>> to the revert then this is probably the simples thing to do. Therefore
>>
> 
> Implementing this counter as a vmstat doesn't make much sense based on how 
> it's used.  Do you have a link to what Vlastimil proposed?  I haven't seen 
> mention of alternative ideas.

It was in the original thread, see e.g.
<08524819-14ef-81d0-fa90-d7af13c6b9d5@suse.cz>

However it will take some time to get that in mainline, and meanwhile
the current implementation does prevent a DOS. So I doubt it can be
fully reverted - as a compromise I just didn't want the counter to
become ABI. TBH though, other people at LSF/MM didn't seem concerned
that /proc/vmstat is an ABI that we can't change (i.e. counters have
been presumably removed in the past already).
