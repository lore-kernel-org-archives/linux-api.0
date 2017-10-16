From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [RFC PATCH 3/3] mm/map_contig: Add mmap(MAP_CONTIG) support
Date: Mon, 16 Oct 2017 19:33:58 +0200
Message-ID: <20171016173358.t3twty3wttbutcro@dhcp22.suse.cz>
References: <20171013084054.me3kxhgbxzgm2lpr@dhcp22.suse.cz>
 <alpine.DEB.2.20.1710131015420.3949@nuc-kabylake>
 <20171013152801.nbpk6nluotgbmfrs@dhcp22.suse.cz>
 <alpine.DEB.2.20.1710131040570.4247@nuc-kabylake>
 <20171013154747.2jv7rtfqyyagiodn@dhcp22.suse.cz>
 <20171015065856.GC3916@xo-6d-61-c0.localdomain>
 <20171016081804.yiqck2g4bwlbdqi6@dhcp22.suse.cz>
 <20171016095447.GA4639@amd>
 <20171016121808.m4sq3g5nxeyxoymc@dhcp22.suse.cz>
 <alpine.DEB.2.20.1710161101310.12436@nuc-kabylake>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.20.1710161101310.12436@nuc-kabylake>
Sender: owner-linux-mm@kvack.org
To: Christopher Lameter <cl@linux.com>
Cc: Pavel Machek <pavel@ucw.cz>, Mike Kravetz <mike.kravetz@oracle.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Marek Szyprowski <m.szyprowski@samsung.com>, Michal Nazarewicz <mina86@mina86.com>, "Aneesh Kumar K . V" <aneesh.kumar@linux.vnet.ibm.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Guy Shattah <sguy@mellanox.com>, Anshuman Khandual <khandual@linux.vnet.ibm.com>, Laura Abbott <labbott@redhat.com>, Vlastimil Babka <vbabka@suse.cz>
List-Id: linux-api@vger.kernel.org

On Mon 16-10-17 11:02:24, Cristopher Lameter wrote:
> On Mon, 16 Oct 2017, Michal Hocko wrote:
> 
> > > So I mmap(MAP_CONTIG) 1GB working of working memory, prefer some data
> > > structures there, maybe recieve from network, then decide to write
> > > some and not write some other.
> >
> > Why would you want this?
> 
> Because we are receiving a 1GB block of data and then wan to write it to
> disk. Maybe we want to modify things a bit and may not write all that we
> received.
 
And why do you need that in a single contiguous numbers? If performance,
do you have any numbers that would clearly tell the difference?

-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
