From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH 3/3] mm/map_contig: Add mmap(MAP_CONTIG) support
Date: Mon, 16 Oct 2017 20:07:49 +0200
Message-ID: <20171016180749.2y2v4ucchb33xnde@dhcp22.suse.cz>
References: <f4a46a19-5f71-ebcc-3098-a35728fbfd03@oracle.com>
 <20171013084054.me3kxhgbxzgm2lpr@dhcp22.suse.cz>
 <alpine.DEB.2.20.1710131015420.3949@nuc-kabylake>
 <20171013152801.nbpk6nluotgbmfrs@dhcp22.suse.cz>
 <alpine.DEB.2.20.1710131040570.4247@nuc-kabylake>
 <20171013154747.2jv7rtfqyyagiodn@dhcp22.suse.cz>
 <alpine.DEB.2.20.1710131053450.4400@nuc-kabylake>
 <20171013161736.htumyr4cskfrjq64@dhcp22.suse.cz>
 <752b49eb-55c6-5a34-ab41-6e91dd93ea70@mellanox.com>
 <aff6b405-6a06-f84d-c9b1-c6fb166dff81@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <aff6b405-6a06-f84d-c9b1-c6fb166dff81-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Kravetz <mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Guy Shattah <sguy-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christopher Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Marek Szyprowski <m.szyprowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Michal Nazarewicz <mina86-deATy8a+UHjQT0dZR+AlfA@public.gmane.org>, "Aneesh Kumar K . V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Anshuman Khandual <khandual-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Laura Abbott <labbott-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon 16-10-17 10:43:38, Mike Kravetz wrote:
> On 10/15/2017 12:50 AM, Guy Shattah wrote:
> > On 13/10/2017 19:17, Michal Hocko wrote:
[...]
> >> But a generic implementation would have to deal with many issues as
> >> already mentioned. If you make this driver specific you can have access
> >> control based on fd etc... I really fail to see how this is any
> >> different from remap_pfn_range.
> > Why have several driver specific implementation if you can generalize the idea and implement
> > an already existing POSIX standard?
> 
> Just to be clear, the posix standard talks about a typed memory object.
> The suggested implementation has one create a connection to the memory
> object to receive a fd, then use mmap as usual to get a mapping backed
> by contiguous pages/memory.  Of course, this type of implementation is
> not a requirement.

I am not sure that POSIC standard for typed memory is easily
implementable in Linux. Does any OS actually implement this API?

> However, this type of implementation looks quite a
> bit like hugetlbfs today.
> - Both require opening a special file/device, and then calling mmap on
>   the returned fd.  You can technically use mmap(MAP_HUGETLB), but that
>   still ends up using hugetbfs.  BTW, there was resistance to adding the
>   MAP_HUGETLB flag to mmap.

And I think we shouldn't really shape any API based on hugetlb.

> - Allocation of contiguous memory is much like 'on demand' allocation of
>   huge pages.  There are some (not many) users that use this model.  They
>   attempt to allocate huge pages on demand, and if not available fall back
>   to base pages.  This is how contiguous allocations would need to work.
>   Of course, most hugetlbfs users pre-allocate pages for their use, and
>   this 'might' be something useful for contiguous allocations as well.

But there is still admin configuration required to consume memory from
the pool or overcommit that pool.

> I wonder if going down the path of a separate devide/filesystem/etc for
> contiguous allocations might be a better option.  It would keep the
> implementation somewhat separate.  However, I would then be afraid that
> we end up with another 'separate/special vm' as in the case of hugetlbfs
> today.

That depends on who is actually going to use the contiguous memory. If
we are talking about drivers to communication to the userspace then
using driver specific fd with its mmap implementation then we do not
need any special fs nor a seperate infrastructure. Well except for a
library function to handle the MM side of the thing.

If we really need a general purpose physical contiguous memory allocator
then I would agree that using MAP_ flag might be a way to go but that
would require a very careful consideration of who is allowed to allocate
and how much/large blocks. I do not see a good fit to conveying that
information to the kernel right now. Moreover, and most importantly, I
haven't heard any sound usecase for such a functionality in the first
place. There is some hand waving about performance but there are no real
numbers to back those claims AFAIK. Not to mention a serious
consideration of potential consequences of the whole MM.
-- 
Michal Hocko
SUSE Labs
