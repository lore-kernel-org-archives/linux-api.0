From: Laura Abbott <labbott@redhat.com>
Subject: Re: [RFC] mmap(MAP_CONTIG)
Date: Wed, 4 Oct 2017 14:29:08 -0700
Message-ID: <09210624-fb3a-4dc9-5720-49714dbef0f7@redhat.com>
References: <21f1ec96-2822-1189-1c95-79a2bb491571@oracle.com>
 <xa1tk20bxh5u.fsf@mina86.com>
 <c00b355a-cfb7-a4e0-56a3-01430dc9e9f5@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <c00b355a-cfb7-a4e0-56a3-01430dc9e9f5@oracle.com>
Content-Language: en-US
Sender: owner-linux-mm@kvack.org
To: Mike Kravetz <mike.kravetz@oracle.com>, Michal Nazarewicz <mina86@mina86.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Guy Shattah <sguy@mellanox.com>, Christoph Lameter <cl@linux.com>
List-Id: linux-api@vger.kernel.org

On 10/04/2017 10:08 AM, Mike Kravetz wrote:
> On 10/04/2017 04:54 AM, Michal Nazarewicz wrote:
>> On Tue, Oct 03 2017, Mike Kravetz wrote:
>>> At Plumbers this year, Guy Shattah and Christoph Lameter gave a presentation
>>> titled 'User space contiguous memory allocation for DMA' [1].  The slides
>>> point out the performance benefits of devices that can take advantage of
>>> larger physically contiguous areas.
>>
>> Issue I have is that kind of memory needed may depend on a device.  Some
>> may require contiguous blocks.  Some may support scatter-gather.  Some
>> may be behind IO-MMU and not care either way.
>>
>> Furthermore, I feel déjà vu.  Wasn’t dmabuf supposed to address this
>> issue?
> 
> Thanks Michal,
> 
> I was unaware of dmabuf and am just now looking at capabilities.  The
> question is whether or not the IB driver writers requesting mmap(MAP_CONTIG)
> functionality could make use of dmabuf.  That is out of my are of expertise,
> so I will let them reply.
> 

I don't think dmabuf as it exists today would help anything here.
It's designed to share buffers via fd but you still need some
place/driver to actually get the allocation and then export it
since there isn't a single interface for allocations. You could
convert drivers to take a dma_buf fd if there were appropriate
buffers available though.

Thanks,
Laura

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
