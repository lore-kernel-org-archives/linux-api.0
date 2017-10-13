From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [RFC PATCH 3/3] mm/map_contig: Add mmap(MAP_CONTIG) support
Date: Fri, 13 Oct 2017 18:17:36 +0200
Message-ID: <20171013161736.htumyr4cskfrjq64@dhcp22.suse.cz>
References: <20171012014611.18725-1-mike.kravetz@oracle.com>
 <20171012014611.18725-4-mike.kravetz@oracle.com>
 <20171012143756.p5bv4zx476qkmqhh@dhcp22.suse.cz>
 <f4a46a19-5f71-ebcc-3098-a35728fbfd03@oracle.com>
 <20171013084054.me3kxhgbxzgm2lpr@dhcp22.suse.cz>
 <alpine.DEB.2.20.1710131015420.3949@nuc-kabylake>
 <20171013152801.nbpk6nluotgbmfrs@dhcp22.suse.cz>
 <alpine.DEB.2.20.1710131040570.4247@nuc-kabylake>
 <20171013154747.2jv7rtfqyyagiodn@dhcp22.suse.cz>
 <alpine.DEB.2.20.1710131053450.4400@nuc-kabylake>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.20.1710131053450.4400@nuc-kabylake>
Sender: owner-linux-mm@kvack.org
To: Christopher Lameter <cl@linux.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Marek Szyprowski <m.szyprowski@samsung.com>, Michal Nazarewicz <mina86@mina86.com>, "Aneesh Kumar K . V" <aneesh.kumar@linux.vnet.ibm.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Guy Shattah <sguy@mellanox.com>, Anshuman Khandual <khandual@linux.vnet.ibm.com>, Laura Abbott <labbott@redhat.com>, Vlastimil Babka <vbabka@suse.cz>
List-Id: linux-api@vger.kernel.org

On Fri 13-10-17 10:56:13, Cristopher Lameter wrote:
> On Fri, 13 Oct 2017, Michal Hocko wrote:
> 
> > > There is a generic posix interface that could we used for a variety of
> > > specific hardware dependent use cases.
> >
> > Yes you wrote that already and my counter argument was that this generic
> > posix interface shouldn't bypass virtual memory abstraction.
> 
> It does do that? In what way?

availability of the virtual address space depends on the availability of
the same sized contiguous physical memory range. That sounds like the
abstraction is gone to large part to me.

> > > There are numerous RDMA devices that would all need the mmap
> > > implementation. And this covers only the needs of one subsystem. There are
> > > other use cases.
> >
> > That doesn't prevent providing a library function which could be reused
> > by all those drivers. Nothing really too much different from
> > remap_pfn_range.
> 
> And then in all the other use cases as well. It would be much easier if
> mmap could give you the memory you need instead of havig numerous drivers
> improvise on their own. This is in particular also useful
> for numerous embedded use cases where you need contiguous memory.

But a generic implementation would have to deal with many issues as
already mentioned. If you make this driver specific you can have access
control based on fd etc... I really fail to see how this is any
different from remap_pfn_range.
-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
