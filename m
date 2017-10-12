From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH 2/3] mm/map_contig: Use pre-allocated pages for
 VM_CONTIG mappings
Date: Thu, 12 Oct 2017 16:34:22 +0530
Message-ID: <937dd9cd-d1c7-5623-f33f-725e2db8cd83@linux.vnet.ibm.com>
References: <21f1ec96-2822-1189-1c95-79a2bb491571@oracle.com>
 <20171012014611.18725-1-mike.kravetz@oracle.com>
 <20171012014611.18725-3-mike.kravetz@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171012014611.18725-3-mike.kravetz@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Kravetz <mike.kravetz@oracle.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, Michal Nazarewicz <mina86@mina86.com>, "Aneesh Kumar K . V" <aneesh.kumar@linux.vnet.ibm.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Guy Shattah <sguy@mellanox.com>, Christoph Lameter <cl@linux.com>, Anshuman Khandual <khandual@linux.vnet.ibm.com>, Laura Abbott <labbott@redhat.com>, Vlastimil Babka <vbabka@suse.cz>
List-Id: linux-api@vger.kernel.org

On 10/12/2017 07:16 AM, Mike Kravetz wrote:
> When populating mappings backed by contiguous memory allocations
> (VM_CONTIG), use the preallocated pages instead of allocating new.
> 
> Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
> ---
>  mm/memory.c | 13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index a728bed16c20..fbef78d07cf3 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -3100,7 +3100,18 @@ static int do_anonymous_page(struct vm_fault *vmf)
>  	/* Allocate our own private page. */
>  	if (unlikely(anon_vma_prepare(vma)))
>  		goto oom;
> -	page = alloc_zeroed_user_highpage_movable(vma, vmf->address);
> +
> +	/*
> +	 * In the special VM_CONTIG case, pages have been pre-allocated. So,
> +	 * simply grab the appropriate pre-allocated page.
> +	 */
> +	if (unlikely(vma->vm_flags & VM_CONTIG)) {
> +		VM_BUG_ON(!vma->vm_private_data);
> +		page = ((struct page *)vma->vm_private_data) +
> +			((vmf->address - vma->vm_start) / PAGE_SIZE);
> +	} else {
> +		page = alloc_zeroed_user_highpage_movable(vma, vmf->address);

vm_private_data should be fine. Seems like its getting used for HugeTLB,
special mappings and for shared memory as well. As long as we dont cross
these things (lets say while enabling this for file mapping etc with
MAP_CONTIG), we can keep using vm_private_data.
