From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: Re: [RFC] mmap(MAP_CONTIG)
Date: Wed, 4 Oct 2017 10:38:57 -0700
Message-ID: <434a5870-0115-b8ab-bd6c-b7f4db847dc4@oracle.com>
References: <21f1ec96-2822-1189-1c95-79a2bb491571@oracle.com>
 <97c81533-5206-b130-1aeb-c5b9bfd93287@linux.vnet.ibm.com>
 <alpine.DEB.2.20.1710041104310.21484@nuc-kabylake>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <alpine.DEB.2.20.1710041104310.21484@nuc-kabylake>
Content-Language: en-US
Sender: owner-linux-mm@kvack.org
To: Christopher Lameter <cl@linux.com>, Anshuman Khandual <khandual@linux.vnet.ibm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Marek Szyprowski <m.szyprowski@samsung.com>, Michal Nazarewicz <mina86@mina86.com>, "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Guy Shattah <sguy@mellanox.com>
List-Id: linux-api@vger.kernel.org

On 10/04/2017 09:05 AM, Christopher Lameter wrote:
> On Wed, 4 Oct 2017, Anshuman Khandual wrote:
> 
>>> - Using 'pre-allocated' pages in the fault paths may be intrusive.
>>
>> But we have already faulted in all of them for the mapping and they
>> are also locked. Hence there should not be any page faults any more
>> for the VMA. Am I missing something here ?
> 
> The PTEs may be torn down and have to reestablished through a page faults.
> Page faults would not allocate memory.
> 
>> I am still wondering why wait till fault time not pre fault all of them
>> and populate the page tables.
> 
> They are populated but some processes (swap and migration) may tear them
> down.

As mentioned in my reply to Anshuman, the mention of fault paths here
may be a source of confusion.  I would expect the entire mapping to be
populated at mmap time, and the pages locked.  Therefore, there should
be no swap or migration.

-- 
Mike Kravetz

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
