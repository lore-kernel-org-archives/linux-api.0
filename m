From: Reinette Chatre <reinette.chatre@intel.com>
Subject: Re: [PATCH v2 3/4] mm: add find_alloc_contig_pages() interface
Date: Wed, 23 May 2018 11:07:59 -0700
Message-ID: <0db4cd65-8b03-fea5-0a30-512f10241d54@intel.com>
References: <20180503232935.22539-1-mike.kravetz@oracle.com>
 <20180503232935.22539-4-mike.kravetz@oracle.com>
 <eaa40ac0-365b-fd27-e096-b171ed28888f@suse.cz>
 <57dfd52c-22a5-5546-f8f3-848f21710cc1@oracle.com>
 <c7972da1-a908-7550-7253-9de9a963174c@intel.com>
 <01793788-1870-858e-2061-a0e6ef3a3171@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <01793788-1870-858e-2061-a0e6ef3a3171@suse.cz>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Vlastimil Babka <vbabka@suse.cz>, Mike Kravetz <mike.kravetz@oracle.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Cc: Michal Hocko <mhocko@kernel.org>, Christopher Lameter <cl@linux.com>, Guy Shattah <sguy@mellanox.com>, Anshuman Khandual <khandual@linux.vnet.ibm.com>, Michal Nazarewicz <mina86@mina86.com>, David Nellans <dnellans@nvidia.com>, Laura Abbott <labbott@redhat.com>, Pavel Machek <pavel@ucw.cz>, Dave Hansen <dave.hansen@intel.com>, Andrew Morton <akpm@linux-foundation.org>
List-Id: linux-api@vger.kernel.org

Hi Vlastimil,

On 5/23/2018 4:18 AM, Vlastimil Babka wrote:
> On 05/22/2018 06:41 PM, Reinette Chatre wrote:
>> On 5/21/2018 4:48 PM, Mike Kravetz wrote:
>>> I'm guessing that most (?all?) allocations will be order based.  The use
>>> cases I am aware of (hugetlbfs, Intel Cache Pseudo-Locking, RDMA) are all
>>> order based.  However, as commented in previous version taking arbitrary
>>> nr_pages makes interface more future proof.
>>>
>>
>> I noticed this Cache Pseudo-Locking statement and would like to clarify.
>> I have not been following this thread in detail so I would like to
>> apologize first if my comments are out of context.
>>
>> Currently the Cache Pseudo-Locking allocations are order based because I
>> assumed it was required by the allocator. The contiguous regions needed
>> by Cache Pseudo-Locking will not always be order based - instead it is
>> based on the granularity of the cache allocation. One example is a
>> platform with 55MB L3 cache that can be divided into 20 equal portions.
>> To support Cache Pseudo-Locking on this platform we need to be able to
>> allocate contiguous regions at increments of 2816KB (the size of each
>> portion). In support of this example platform regions needed would thus
>> be 2816KB, 5632KB, 8448KB, etc.
> 
> Will there be any alignment requirements for these allocations e.g. for
> minimizing conflict misses?

Two views on the usage of the allocated memory are: On the user space
side, the kernel memory is mapped to userspace (using remap_pfn_range())
and thus need to be page aligned. On the kernel side the memory is
loaded into the cache and it is here where the requirement originates
for it to be contiguous. The memory being contiguous reduces the
likelihood of physical addresses from the allocated memory mapping to
the same cache line and thus cause cache evictions of memory we are
trying to load into the cache.

I hope I answered your question, if not, please let me know which parts
I missed and I will try again.

Reinette
