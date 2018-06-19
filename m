From: Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [PATCH v2 6/7] mm, proc: add KReclaimable to /proc/meminfo
Date: Tue, 19 Jun 2018 09:30:03 +0200
Message-ID: <650c3fab-3137-4fe6-272a-f4ec104855a7@suse.cz>
References: <20180618091808.4419-1-vbabka@suse.cz>
 <20180618091808.4419-7-vbabka@suse.cz>
 <20180618143317.eb8f5d7b6c667784343ef902@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180618143317.eb8f5d7b6c667784343ef902@linux-foundation.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, Roman Gushchin <guro@fb.com>, Michal Hocko <mhocko@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, linux-api@vger.kernel.org, Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>, Mel Gorman <mgorman@techsingularity.net>, Matthew Wilcox <willy@infradead.org>
List-Id: linux-api@vger.kernel.org

On 06/18/2018 11:33 PM, Andrew Morton wrote:
> On Mon, 18 Jun 2018 11:18:07 +0200 Vlastimil Babka <vbabka@suse.cz> wrote:
> 
>> The vmstat NR_KERNEL_MISC_RECLAIMABLE counter is for kernel non-slab
>> allocations that can be reclaimed via shrinker. In /proc/meminfo, we can show
>> the sum of all reclaimable kernel allocations (including slab) as
>> "KReclaimable". Add the same counter also to per-node meminfo under /sys
> 
> Why do you consider this useful enough to justify adding it to
> /pro/meminfo?  How will people use it, what benefit will they see, etc?

Let's add this:

With this counter, users will have more complete information about
kernel memory usage. Non-slab reclaimable pages (currently just the ION
allocator) will not be missing from /proc/meminfo, making users wonder
where part of their memory went. More precisely, they already appear in
MemAvailable, but without the new counter, it's not obvious why the
value in MemAvailable doesn't fully correspond with the sum of other
counters participating in it.

> Maybe you've undersold this whole patchset, but I'm struggling a bit to
> see what the end-user benefits are.  What would be wrong with just
> sticking with what we have now?

Fair enough, I will add more info in reply to the cover letter.
