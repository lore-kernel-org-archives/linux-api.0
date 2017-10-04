From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Subject: Re: [RFC] mmap(MAP_CONTIG)
Date: Wed, 4 Oct 2017 19:19:12 +0530
Message-ID: <97c81533-5206-b130-1aeb-c5b9bfd93287@linux.vnet.ibm.com>
References: <21f1ec96-2822-1189-1c95-79a2bb491571@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <21f1ec96-2822-1189-1c95-79a2bb491571@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Kravetz <mike.kravetz@oracle.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, Michal Nazarewicz <mina86@mina86.com>, "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Guy Shattah <sguy@mellanox.com>, Christoph Lameter <cl@linux.com>
List-Id: linux-api@vger.kernel.org

On 10/04/2017 05:26 AM, Mike Kravetz wrote:
> At Plumbers this year, Guy Shattah and Christoph Lameter gave a presentation
> titled 'User space contiguous memory allocation for DMA' [1].  The slides
> point out the performance benefits of devices that can take advantage of
> larger physically contiguous areas.
> 
> When such physically contiguous allocations are done today, they are done
> within drivers themselves in an ad-hoc manner.  In addition to allocations
> for DMA, allocations of this type are also performed for buffers used by
> coprocessors and other acceleration engines.

Right.

> 
> As mentioned in the presentation, posix specifies an interface to obtain
> physically contiguous memory.  This is via typed memory objects as described
> in the posix_typed_mem_open() man page.  Since Linux today does not follow
> the posix typed memory object model, adding infrastructure for contiguous
> memory allocations seems to be overkill.  Instead, a proposal was suggested
> to add support via a mmap flag: MAP_CONTIG.

Right.

> 
> mmap(MAP_CONTIG) would have the following semantics:
> - The entire mapping (length size) would be backed by physically contiguous
>   pages.
> - If 'length' physically contiguous pages can not be allocated, then mmap
>   will fail.
> - MAP_CONTIG only works with MAP_ANONYMOUS mappings.
> - MAP_CONTIG will lock the associated pages in memory.  As such, the same
>   privileges and limits that apply to mlock will also apply to MAP_CONTIG.
> - A MAP_CONTIG mapping can not be expanded.

Why ? May be we have memory around the edge of the existing mapping. Why
give up before trying ?

> - At fork time, private MAP_CONTIG mappings will be converted to regular
>   (non-MAP_CONTIG) mapping in the child.  As such a COW fault in the child
>   will not require a contiguous allocation.

Makes sense but need to be documented as the child still knows that the buffer
came from a mmap(MAP_CONTIG) call in the parent.

> 
> Some implementation considerations:
> - alloc_contig_range() or similar will be used for allocations larger
>   than MAX_ORDER.

As I had also mentioned during the presentation at Plumbers, there should be
a fallback approach while attempting to allocate the contiguous memory.

- If order < MAX_ORDER -> alloc_pages()
- If order > MAX_ORDER -> alloc_contig_range()
- If alloc_contig_range() fails attempt a CMA based allocation scheme
  The CMA area should have been initialized at the boot exclusively for
  this purpose (may be with a CONFIG option if some one wants to go for
  this fallback at all) and use cma_alloc() on that area when we need
  to service MAP_CONTIG requests.

> - MAP_CONTIG should imply MAP_POPULATE.  At mmap time, all pages for the
>   mapping must be 'pre-allocated', and they can only be used for the mapping,
>   so it makes sense to 'fault in' all pages.


> - Using 'pre-allocated' pages in the fault paths may be intrusive.

But we have already faulted in all of them for the mapping and they
are also locked. Hence there should not be any page faults any more
for the VMA. Am I missing something here ?

> - We need to keep keep track of those pre-allocated pages until the vma is
>   tore down, especially if free_contig_range() must be called

Right, probably tracking them as part of the vm_area_struct itself. 

> 
> Thoughts?
> - Is such an interface useful?
> - Any other ideas on how to achieve the same functionality?
> - Any thoughts on implementation?
> 
> I have started down the path of pre-allocating contiguous pages at mmap
> time and hanging those off the vma(vm_private_data) with some kludges to
> use the pages at fault time.  It is really ugly, which is why I am not
> sharing the code.  Hoping for some comments/suggestions.

I am still wondering why wait till fault time not pre fault all of them
and populate the page tables.
> 
> [1] https://www.linuxplumbersconf.org/2017/ocw/proposals/4669
> 
