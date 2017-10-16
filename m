From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH 3/3] mm/map_contig: Add mmap(MAP_CONTIG) support
Date: Mon, 16 Oct 2017 19:42:29 +0200
Message-ID: <20171016174229.pz3o4uhzz3qbrp6n@dhcp22.suse.cz>
References: <20171013152801.nbpk6nluotgbmfrs@dhcp22.suse.cz>
 <alpine.DEB.2.20.1710131040570.4247@nuc-kabylake>
 <20171013154747.2jv7rtfqyyagiodn@dhcp22.suse.cz>
 <alpine.DEB.2.20.1710131053450.4400@nuc-kabylake>
 <20171013161736.htumyr4cskfrjq64@dhcp22.suse.cz>
 <752b49eb-55c6-5a34-ab41-6e91dd93ea70@mellanox.com>
 <20171016082456.no6ux63uy2rmj4fe@dhcp22.suse.cz>
 <0e238c56-c59d-f648-95fc-c8cb56c3652e@mellanox.com>
 <20171016123248.csntl6luxgafst6q@dhcp22.suse.cz>
 <alpine.DEB.2.20.1710161058470.12436@nuc-kabylake>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.20.1710161058470.12436@nuc-kabylake>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christopher Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: Guy Shattah <sguy-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Mike Kravetz <mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Marek Szyprowski <m.szyprowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Michal Nazarewicz <mina86-deATy8a+UHjQT0dZR+AlfA@public.gmane.org>, "Aneesh Kumar K . V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Anshuman Khandual <khandual-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Laura Abbott <labbott-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon 16-10-17 11:00:19, Cristopher Lameter wrote:
> On Mon, 16 Oct 2017, Michal Hocko wrote:
> 
> > But putting that aside. Pinning a lot of memory might cause many
> > performance issues and misbehavior. There are still kernel users
> > who need high order memory to work properly. On top of that you are
> > basically allowing an untrusted user to deplete higher order pages very
> > easily unless there is a clever way to enforce per user limit on this.
> 
> We already have that issue and have ways to control that by tracking
> pinned and mlocked pages as well as limits on their allocations.

Ohh, it is very different because mlock limit is really small (64kB)
which is not even close to what this is supposed to be about. Moreover
mlock doesn't prevent from migration and so it doesn't prevent
compaction to form higher order allocations.

Really, this is just too dangerous without a deep consideration of all
the potential consequences. The more I am thinking about this the more I
am convinced that this all should be driver specific mmap based thing.
If it turns out to be too restrictive over time and there are more
experiences about the usage we can consider thinking about a more
generic API. But starting from the generic MAP_ flag is just asking for
problems.

> > That being said, the list is far from being complete, I am pretty sure
> > more would pop out if I thought more thoroughly. The bottom line is that
> > while I see many problems to actually implement this feature and
> > maintain it longterm I simply do not see a large benefit outside of a
> > very specific HW.
> 
> There is not much new here in terms of problems. The hardware that
> needs this seems to become more and more plentiful. That is why we need a
> generic implementation.

It would really help to name that HW and other potential usecases
independent on the HW because I am rather skeptical about the
_plentiful_ part. And so I really do not see any foundation to claim
the generic part. Because, fundamentally, it is the HW which requires
the specific memory placement/physically contiguous range etc. So the
generic implementation doesn't really make sense in such a context.

-- 
Michal Hocko
SUSE Labs
