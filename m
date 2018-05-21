From: Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [PATCH v2 0/4] Interface for higher order contiguous allocations
Date: Mon, 21 May 2018 14:00:04 +0200
Message-ID: <8ce9884c-36b0-68ea-45a4-06177c41af4a@suse.cz>
References: <20180503232935.22539-1-mike.kravetz@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180503232935.22539-1-mike.kravetz@oracle.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Kravetz <mike.kravetz@oracle.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Cc: Reinette Chatre <reinette.chatre@intel.com>, Michal Hocko <mhocko@kernel.org>, Christopher Lameter <cl@linux.com>, Guy Shattah <sguy@mellanox.com>, Anshuman Khandual <khandual@linux.vnet.ibm.com>, Michal Nazarewicz <mina86@mina86.com>, David Nellans <dnellans@nvidia.com>, Laura Abbott <labbott@redhat.com>, Pavel Machek <pavel@ucw.cz>, Dave Hansen <dave.hansen@intel.com>, Andrew Morton <akpm@linux-foundation.org>
List-Id: linux-api@vger.kernel.org

On 05/04/2018 01:29 AM, Mike Kravetz wrote:
> Vlastimil and Michal brought up the issue of allocation alignment.  The
> routine will currently align to 'nr_pages' (which is the requested size
> argument).  It does this by examining and trying to allocate the first
> nr_pages aligned/nr_pages sized range.  If this fails, it moves on to the
> next nr_pages aligned/nr_pages sized range until success or all potential
> ranges are exhausted.

As I've noted in my patch 3/4 review, in fact nr_pages is first rounded
up to an order, which makes this simpler, but suboptimal. I think we
could perhaps assume that nr_pages that's a power of two should be
aligned as such, and other values of nr_pages need no alignment? This
should fit existing users, and can be extended to explicit alignment
when such user appears?

> If we allow an alignment to be specified, we will
> need to potentially check all alignment aligned/nr_pages sized ranges.
> In the worst case where alignment = PAGE_SIZE, this could result in huge
> increase in the number of ranges to check.
> To help cut down on the number of ranges to check, we could identify the
> first page that causes a range allocation failure and start the next
> range at the next aligned boundary.  I tried this, and we still end up
> with a huge number of ranges and wasted CPU cycles.

I think the wasted cycle issues is due to the current code structure,
which is based on the CMA use-case, which assumes that the allocations
will succeed, because the areas are reserved and may contain only
movable allocations

find_alloc_contig_pages()
  __alloc_contig_pages_nodemask()
    contig_pfn_range_valid()
      - performs only very basic pfn validity and belongs-to-zone checks
    alloc_contig_range()
      start_isolate_page_range()
       for (pfn per pageblock) - the main cycle
         set_migratetype_isolate()
           has_unmovable_pages() - cancel if yes
           move_freepages_block() - expensive!
      __alloc_contig_migrate_range()
etc (not important)

So I think the problem is that in the main cycle we might do a number of
expensive move_freepages_block() operations, then hit a block where
has_unmovable_pages() is true, cancel and do more expensive
undo_isolate_page_range() operations.

If we instead first scanned the range with has_unmovable_pages() and
only start doing the expensive work when we find a large enough (aligned
or not depending on caller) range, it should be much faster and there
should be no algorithmic difference between aligned and non-aligned case.

Thanks,
Vlastimil
