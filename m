From: Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [PATCH v2 0/7] kmalloc-reclaimable caches
Date: Tue, 19 Jun 2018 09:54:54 +0200
Message-ID: <386fda93-a2d4-6302-c233-12bc77c7668c@suse.cz>
References: <20180618091808.4419-1-vbabka@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180618091808.4419-1-vbabka@suse.cz>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, Roman Gushchin <guro@fb.com>, Michal Hocko <mhocko@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, linux-api@vger.kernel.org, Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>, Mel Gorman <mgorman@techsingularity.net>, Matthew Wilcox <willy@infradead.org>, Laura Abbott <labbott@redhat.com>, Sumit Semwal <sumit.semwal@linaro.org>, Vijayanand Jitta <vjitta@codeaurora.org>
List-Id: linux-api@vger.kernel.org

On 06/18/2018 11:18 AM, Vlastimil Babka wrote:
> v2 changes:
> - shorten cache names to kmalloc-rcl-<SIZE>
> - last patch shortens <SIZE> for all kmalloc caches to e.g. "1k", "4M"
> - include dma caches to the 2D kmalloc_caches[] array to avoid a branch
> - vmstat counter nr_indirectly_reclaimable_bytes renamed to
>   nr_kernel_misc_reclaimable, doesn't include kmalloc-rcl-*
> - /proc/meminfo counter renamed to KReclaimable, includes kmalloc-rcl*
>   and nr_kernel_misc_reclaimable
> 
> Hi,
> 
> as discussed at LSF/MM [1] here's a patchset that introduces
> kmalloc-reclaimable caches (more details in the second patch) and uses them for
> SLAB freelists and dcache external names. The latter allows us to repurpose the
> NR_INDIRECTLY_RECLAIMABLE_BYTES counter later in the series.

More info about user benefits of the patchset:

With patch 4, dcache external names are allocated from kmalloc-rcl-*
caches, eliminating the need for manual accounting. More importantly, it
also ensures the reclaimable kmalloc allocations are grouped in pages
separate from the regular kmalloc allocations. The need for proper
accounting of dcache external names has shown it's easy for misbehaving
process to allocate lots of them, causing premature OOMs. Without the
added grouping, it's likely that similar workload can interleave the
dcache external names allocations with regular kmalloc allocations
(note: I haven't searched myself for an example of such regular kmalloc
allocation, but I would be very surprised if there wasn't some). A
pathological case would be e.g. one 64byte regular allocations with 63
external dcache names in a page (64x64=4096), which means the page is
not freed even after reclaiming after all dcache names, and the process
can thus steal the whole page with single 64byte allocation.

If there other kmalloc users similar to dcache external names become
identified, they can also benefit from the new functionality simply by
adding __GFP_RECLAIMABLE to the kmalloc calls.

Side benefits of the patchset (that could be also merged separately)
include removed branch for detecting __GFP_DMA kmalloc(), and shortening
kmalloc cache names in /proc/slabinfo output. The latter is potentially
an ABI break in case there are tools parsing the names and expecting the
values to be in bytes.
