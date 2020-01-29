From: "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
Subject: Re: [PATCH v2] mm: Add MREMAP_DONTUNMAP to mremap().
Date: Wed, 29 Jan 2020 13:46:55 +0300
Message-ID: <20200129104655.egvpavc2tzozlbqe@box>
References: <20200123014627.71720-1-bgeffon@google.com>
 <20200124190625.257659-1-bgeffon@google.com>
 <20200126220650.i4lwljpvohpgvsi2@box>
 <CADyq12xCK_3MhGi88Am5P6DVZvrW8vqtyJMHO0zjNhvhYegm1w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CADyq12xCK_3MhGi88Am5P6DVZvrW8vqtyJMHO0zjNhvhYegm1w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Brian Geffon <bgeffon-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Michael S . Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sonny Rao <sonnyrao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Joel Fernandes <joel-QYYGw3jwrUn5owFQY34kdNi2O/JbrIOy@public.gmane.org>, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jesse Barnes <jsbarnes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Jan 27, 2020 at 05:35:40PM -0800, Brian Geffon wrote:
> Hi Kirill,
> Thanks for taking the time to look at this. I'll update the wording to
> make it clear that MREMAP_FIXED is required with MREMAP_DONTUNMAP.

I still think that chaining flags is strange. The new flag requires all
existing.

And based on the use case you probably don't really need 'fixed'
semantics all the time. The user should be fine with moving the mapping
*somewhere*, not neccessary to the given address.

BTW, name of the flag is confusing. My initial reaction was that it is
variant of MREMAP_FIXED that does't anything at the target address.
Like MAP_FIXED vs. MAP_FIXED_NOREPLACE.

Any better options for the flag name? (I have none)

> Regarding rmap, you're completely right I'm going to roll a new patch
> which will call unlink_anon_vmas() to make sure the rmap is correct,
> I'll also explicitly check that the vma is anonymous and not shared
> returning EINVAL if not, how does that sound?

Fine, I guess. But let me see the end result.

-- 
 Kirill A. Shutemov
