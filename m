From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH 2/3] mm: add find_alloc_contig_pages() interface
Date: Tue, 24 Apr 2018 07:37:40 -0600
Message-ID: <20180424133740.GH17484@dhcp22.suse.cz>
References: <20180417020915.11786-1-mike.kravetz@oracle.com>
 <20180417020915.11786-3-mike.kravetz@oracle.com>
 <20180423000943.GO17484@dhcp22.suse.cz>
 <fc28bcb7-8f9a-e841-0fdf-8636523ebc2a@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <fc28bcb7-8f9a-e841-0fdf-8636523ebc2a@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Kravetz <mike.kravetz@oracle.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Reinette Chatre <reinette.chatre@intel.com>, Christopher Lameter <cl@linux.com>, Guy Shattah <sguy@mellanox.com>, Anshuman Khandual <khandual@linux.vnet.ibm.com>, Michal Nazarewicz <mina86@mina86.com>, Vlastimil Babka <vbabka@suse.cz>, David Nellans <dnellans@nvidia.com>, Laura Abbott <labbott@redhat.com>, Pavel Machek <pavel@ucw.cz>, Dave Hansen <dave.hansen@intel.com>, Andrew Morton <akpm@linux-foundation.org>
List-Id: linux-api@vger.kernel.org

On Sun 22-04-18 21:22:07, Mike Kravetz wrote:
> On 04/22/2018 05:09 PM, Michal Hocko wrote:
[...
> > Also do we want to check other usual suspects? E.g. PageReserved? And
> > generally migrateable pages if page count > 0. Or do we want to leave
> > everything to the alloc_contig_range?
> 
> I think you proposed something like the above with limited checking at
> some time in the past.  In my testing, allocations were more likely to
> succeed if we did limited testing here and let alloc_contig_range take
> a shot at migration/allocation.  There really are two ways to approach
> this, do as much checking up front or let it be handled by alloc_contig_range.

OK, it would be great to have a comment mentioning that. The discrepancy
will just hit eyes 

[...]
> Unless I am missing something, calls to alloc_contig range need to have
> a size that is a multiple of page block.  This is because isolation needs
> to take place at a page block level.  We can easily 'round up' and release
> excess pages.

I am not sure but can we simply leave a part of the page block behind? I
mean it might have a misleading migrate type but that shouldn't matter
much, no?

Thanks!
-- 
Michal Hocko
SUSE Labs
