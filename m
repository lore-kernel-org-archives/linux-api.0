From: "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
Subject: Re: [PATCH v2] mm: Add MREMAP_DONTUNMAP to mremap().
Date: Mon, 10 Feb 2020 13:35:56 +0300
Message-ID: <20200210103556.wz72op4g554qn5jm@box>
References: <20200123014627.71720-1-bgeffon@google.com>
 <20200124190625.257659-1-bgeffon@google.com>
 <20200126220650.i4lwljpvohpgvsi2@box>
 <CADyq12xCK_3MhGi88Am5P6DVZvrW8vqtyJMHO0zjNhvhYegm1w@mail.gmail.com>
 <20200129104655.egvpavc2tzozlbqe@box>
 <CADyq12xgnVByYOkL=GcszYYKzDpg254QEOFoW8=e1y=bmOCcFQ@mail.gmail.com>
 <20200203130940.enfvdsbn42hhoaki@box>
 <CADyq12x98QspiWSqNui1OH8+FEUzVyJwxia+ho00S2+Q+PmTjw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CADyq12x98QspiWSqNui1OH8+FEUzVyJwxia+ho00S2+Q+PmTjw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Brian Geffon <bgeffon-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Michael S . Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sonny Rao <sonnyrao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Joel Fernandes <joel-QYYGw3jwrUn5owFQY34kdNi2O/JbrIOy@public.gmane.org>, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jesse Barnes <jsbarnes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Feb 07, 2020 at 12:42:15PM -0800, Brian Geffon wrote:
> Hi Kirill,
> I started a new thread https://lkml.org/lkml/2020/2/7/640 for my v4
> patch. But I wanted to quickly address your comments. Regarding the
> concern around the rmap, no changes actually need to be made. If we
> were to unlink_anon_vma(vma) and then set vma->anon_vma = NULL, that
> would be fine but then as soon as there was a fault the same anon_vma
> would be attached since it's a private anonymous mapping. So there is
> really nothing to do regarding the rmap.

Okay.

My worry was that we create a new VMA with the same anon_vma *and*
vm_pgoff, but I just realized we can do the same with the current
mremap(2) plus following mmap(2) in the old place. So it's not regression.

I guess we are fine here.

> I considered the two flag approach but since I could not come up with
> a concrete use case of MREMAP_MUSTMOVE I decided to just leave the
> single MREMAP_DONTUNMAP flag, the two flag approach would be only for
> clarifying the operations so I'm not sure it's worth it. (Still trying
> to come up with a better name). But I've attached a man page diff to
> the latest patch.

At least it doesn't have 'FIXED' semantics forced on user. It's fine with
me.

-- 
 Kirill A. Shutemov
