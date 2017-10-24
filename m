From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: Re: [RFC] mmap(MAP_CONTIG)
Date: Tue, 24 Oct 2017 15:49:12 -0700
Message-ID: <29f88dc2-81f7-4042-50c3-f1c3bc957af8@oracle.com>
References: <21f1ec96-2822-1189-1c95-79a2bb491571@oracle.com>
 <b2dee13d-a19a-2b53-7317-7227749375d9@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <b2dee13d-a19a-2b53-7317-7227749375d9@intel.com>
Content-Language: en-US
Sender: owner-linux-mm@kvack.org
To: Dave Hansen <dave.hansen@intel.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, Michal Nazarewicz <mina86@mina86.com>, "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Guy Shattah <sguy@mellanox.com>, Christoph Lameter <cl@linux.com>
List-Id: linux-api@vger.kernel.org

On 10/23/2017 03:10 PM, Dave Hansen wrote:
> On 10/03/2017 04:56 PM, Mike Kravetz wrote:
>> mmap(MAP_CONTIG) would have the following semantics:
>> - The entire mapping (length size) would be backed by physically contiguous
>>   pages.
>> - If 'length' physically contiguous pages can not be allocated, then mmap
>>   will fail.
>> - MAP_CONTIG only works with MAP_ANONYMOUS mappings.
>> - MAP_CONTIG will lock the associated pages in memory.  As such, the same
>>   privileges and limits that apply to mlock will also apply to MAP_CONTIG.
>> - A MAP_CONTIG mapping can not be expanded.
> 
> Do you also need to lock out the NUMA migration APIs somehow?  What
> about KSM (or does it already ignore VM_LOCKED)?

Yes, and no.
The primary use case driving this request is RDMA.  As such, the pages
can not move while being used for this purpose.

When this thread was started the thought was that generic mmap would
handle the contiguous allocations.  The resulting allocated pages would
be handed to the driver for additional setup based on it's specific needs.
Since then, the thought is that the driver should handle contiguous
allocations as well.  I am looking at making the existing contiguous memory
allocator more usable for driver writers.

-- 
Mike Kravetz

> 
>> - At fork time, private MAP_CONTIG mappings will be converted to regular
>>   (non-MAP_CONTIG) mapping in the child.  As such a COW fault in the child
>>   will not require a contiguous allocation.
> Maybe we should just define it as acting as if it had MADV_DONTFORK set
> on it, and also that it doesn't allow MADV_DONTFORK to be called on it.
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
