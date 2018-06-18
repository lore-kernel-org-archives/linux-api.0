From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 6/7] mm, proc: add KReclaimable to /proc/meminfo
Date: Mon, 18 Jun 2018 14:33:17 -0700
Message-ID: <20180618143317.eb8f5d7b6c667784343ef902@linux-foundation.org>
References: <20180618091808.4419-1-vbabka@suse.cz>
        <20180618091808.4419-7-vbabka@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180618091808.4419-7-vbabka@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Vlastimil Babka <vbabka@suse.cz>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, Roman Gushchin <guro@fb.com>, Michal Hocko <mhocko@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, linux-api@vger.kernel.org, Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>, Mel Gorman <mgorman@techsingularity.net>, Matthew Wilcox <willy@infradead.org>
List-Id: linux-api@vger.kernel.org

On Mon, 18 Jun 2018 11:18:07 +0200 Vlastimil Babka <vbabka@suse.cz> wrote:

> The vmstat NR_KERNEL_MISC_RECLAIMABLE counter is for kernel non-slab
> allocations that can be reclaimed via shrinker. In /proc/meminfo, we can show
> the sum of all reclaimable kernel allocations (including slab) as
> "KReclaimable". Add the same counter also to per-node meminfo under /sys

Why do you consider this useful enough to justify adding it to
/pro/meminfo?  How will people use it, what benefit will they see, etc?


Maybe you've undersold this whole patchset, but I'm struggling a bit to
see what the end-user benefits are.  What would be wrong with just
sticking with what we have now?
