From: Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [PATCH v2 6/7] mm, proc: add KReclaimable to /proc/meminfo
Date: Tue, 19 Jun 2018 14:44:41 +0200
Message-ID: <10bfd013-0eab-aad3-ac69-7f854909eccf@suse.cz>
References: <20180618091808.4419-1-vbabka@suse.cz>
 <20180618091808.4419-7-vbabka@suse.cz>
 <20180618143317.eb8f5d7b6c667784343ef902@linux-foundation.org>
 <650c3fab-3137-4fe6-272a-f4ec104855a7@suse.cz>
 <20180619081357.GA95482@rodete-desktop-imager.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180619081357.GA95482@rodete-desktop-imager.corp.google.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Minchan Kim <minchan.kernel@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Roman Gushchin <guro@fb.com>, Michal Hocko <mhocko@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, linux-api@vger.kernel.org, Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>, Mel Gorman <mgorman@techsingularity.net>, Matthew Wilcox <willy@infradead.org>
List-Id: linux-api@vger.kernel.org

On 06/19/2018 10:13 AM, Minchan Kim wrote:
> On Tue, Jun 19, 2018 at 09:30:03AM +0200, Vlastimil Babka wrote:
>> On 06/18/2018 11:33 PM, Andrew Morton wrote:
>>> On Mon, 18 Jun 2018 11:18:07 +0200 Vlastimil Babka <vbabka@suse.cz> wrote:
>>>
>>>> The vmstat NR_KERNEL_MISC_RECLAIMABLE counter is for kernel non-slab
>>>> allocations that can be reclaimed via shrinker. In /proc/meminfo, we can show
>>>> the sum of all reclaimable kernel allocations (including slab) as
>>>> "KReclaimable". Add the same counter also to per-node meminfo under /sys
>>>
>>> Why do you consider this useful enough to justify adding it to
>>> /pro/meminfo?  How will people use it, what benefit will they see, etc?
>>
>> Let's add this:
>>
>> With this counter, users will have more complete information about
>> kernel memory usage. Non-slab reclaimable pages (currently just the ION
>> allocator) will not be missing from /proc/meminfo, making users wonder
>> where part of their memory went. More precisely, they already appear in
>> MemAvailable, but without the new counter, it's not obvious why the
>> value in MemAvailable doesn't fully correspond with the sum of other
>> counters participating in it.
> 
> Hmm, if we could get MemAvailable with sum of other counters participating
> in it, MemAvailable wouldn't be meaninful. IMO, MemAvailable don't need to
> be matched with other counters.

MemAvailable is meant as a "shortcut" for users, so they don't have to
remember which counters to count and add them up manually. It's also not
an exact sum, because there are some assumptions that part of
reclaimable memory might be pinned etc. Still, missing KReclaimable in
/proc/meminfo would be an odd exception wrt the other counters, IMHO.

> The benefit of ION KReclaimable in real field is there are some sluggish
> problem bugreport under memory pressure and found ION page pool is too
> much without shrinking. In that case, that meminfo would be useful to
> know something was broken in the system.

Right.

> In that point of view, a concern to me is if we put more KReclaimable
> pages(e.g., binder is candidate), it ends up we couldn't identify what
> caches are too much among them. That means we needs KReclaimableInfo(like
> slabinfo) to show each type's KReclaimable pages in future.

Yeah there are more direct kernel allocations that can eat significant
amounts of memory, without being visible in /proc/meminfo, and not
necessarily reclaimable. E.g. unless that changed, I recall XFS page
buffers. Striking a good balance of how detailed the accounting should
be is not easy.

BTW at some point I proposed MemUnaccounted to make it more obvious
(without adding up fields manually) that there is some memory consumed
by kernel allocations not visible in the other meminfo fields.
