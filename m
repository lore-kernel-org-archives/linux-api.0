From: Brian Geffon <bgeffon-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] mm: Add MREMAP_DONTUNMAP to mremap().
Date: Sat, 1 Feb 2020 22:03:37 +0100
Message-ID: <CADyq12ysX9Ce+CUr=Cs-LcYrJDeYubDfZy2-GYFHAz111J8QBA@mail.gmail.com>
References: <20200123014627.71720-1-bgeffon@google.com> <20200124190625.257659-1-bgeffon@google.com>
 <20200126220650.i4lwljpvohpgvsi2@box> <CADyq12xCK_3MhGi88Am5P6DVZvrW8vqtyJMHO0zjNhvhYegm1w@mail.gmail.com>
 <20200129104655.egvpavc2tzozlbqe@box>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20200129104655.egvpavc2tzozlbqe@box>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Michael S . Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sonny Rao <sonnyrao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Joel Fernandes <joel-QYYGw3jwrUn5owFQY34kdNi2O/JbrIOy@public.gmane.org>, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jesse Barnes <jsbarnes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Kirill,

On Wed, Jan 29, 2020 at 11:46 AM Kirill A. Shutemov
<kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org> wrote:
> And based on the use case you probably don't really need 'fixed'
> semantics all the time. The user should be fine with moving the mapping
> *somewhere*, not neccessary to the given address

This is true and and it simplifies things a bit as for the outlined
use cases the user would not be required to mmap the destination
before hand. Part of the reason I chose to require MREMAP_FIXED was
because mremap need not move the mapping if it can shrink/grow in
place and it seemed a bit awkward to have "MUSTMOVE" behavior without
MAP_FIXED. I'll make this change to drop the requirement on
MREMAP_FIXED in my next patch.

> BTW, name of the flag is confusing. My initial reaction was that it is
> variant of MREMAP_FIXED that does't anything at the target address.
> Like MAP_FIXED vs. MAP_FIXED_NOREPLACE.
>
> Any better options for the flag name? (I have none)

I see your point. Perhaps MREMAP_MOVEPAGES or MREMAP_KEEP_SOURCE? I
struggle to come up with a single name that encapsulates this behavior
but I'll try to think of other ideas before I mail the next patch.
Given that we will drop the requirement on MREMAP_FIXED, perhaps
MOVEPAGES is the better option as it captures that the mapping WILL be
moved?

Thanks again for taking the time to look at this.

Best,
Brian
