From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH 0/3] Add mmap(MAP_CONTIG) support
Date: Thu, 12 Oct 2017 16:06:13 +0530
Message-ID: <f1737666-b65e-38e2-94af-129e66031503@linux.vnet.ibm.com>
References: <21f1ec96-2822-1189-1c95-79a2bb491571@oracle.com>
 <20171012014611.18725-1-mike.kravetz@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20171012014611.18725-1-mike.kravetz@oracle.com>
Sender: owner-linux-mm@kvack.org
To: Mike Kravetz <mike.kravetz@oracle.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, Michal Nazarewicz <mina86@mina86.com>, "Aneesh Kumar K . V" <aneesh.kumar@linux.vnet.ibm.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Guy Shattah <sguy@mellanox.com>, Christoph Lameter <cl@linux.com>, Anshuman Khandual <khandual@linux.vnet.ibm.com>, Laura Abbott <labbott@redhat.com>, Vlastimil Babka <vbabka@suse.cz>
List-Id: linux-api@vger.kernel.org

On 10/12/2017 07:16 AM, Mike Kravetz wrote:
> The following is a 'possible' way to add such functionality.  I just
> did what was easy and pre-allocated contiguous pages which are used
> to populate the mapping.  I did not use any of the higher order
> allocators such as alloc_contig_range.  Therefore, it is limited to

Just tried with a small prototype with an implementation similar to that
of alloc_gigantic_page() where we scan the zones (applicable zonelist)
for contiguous valid PFN range and try allocating with alloc_contig_range.
Will share it soon.

> allocations of MAX_ORDER size.  Also, the allocations should probably

Just did a quick test and it worked till 1UL << (MAX_ORDER - 1) numbers
of pages on a POWER system with the current RFC patches. As the pages
are allocated during VMA creation time, comparison to normal page fault
speed while accessing the buffer wont be fair.

> be done outside mmap_sem but that was the easiest place to do it in
> this quick and easy POC.

Why it should be done outside the mmap_sem, because it can take some
time ? But then VMA can just go away while we are allocating the big
chunks of pages (if we dont hold mmap_sem).

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
