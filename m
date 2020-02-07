From: Brian Geffon <bgeffon@google.com>
Subject: Re: [PATCH v2] mm: Add MREMAP_DONTUNMAP to mremap().
Date: Fri, 7 Feb 2020 12:42:15 -0800
Message-ID: <CADyq12x98QspiWSqNui1OH8+FEUzVyJwxia+ho00S2+Q+PmTjw@mail.gmail.com>
References: <20200123014627.71720-1-bgeffon@google.com> <20200124190625.257659-1-bgeffon@google.com>
 <20200126220650.i4lwljpvohpgvsi2@box> <CADyq12xCK_3MhGi88Am5P6DVZvrW8vqtyJMHO0zjNhvhYegm1w@mail.gmail.com>
 <20200129104655.egvpavc2tzozlbqe@box> <CADyq12xgnVByYOkL=GcszYYKzDpg254QEOFoW8=e1y=bmOCcFQ@mail.gmail.com>
 <20200203130940.enfvdsbn42hhoaki@box>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200203130940.enfvdsbn42hhoaki@box>
Sender: linux-kernel-owner@vger.kernel.org
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Andrew Morton <akpm@linux-foundation.org>, "Michael S . Tsirkin" <mst@redhat.com>, Arnd Bergmann <arnd@arndb.de>, LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, linux-api@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>, Andrea Arcangeli <aarcange@redhat.com>, Sonny Rao <sonnyrao@google.com>, Minchan Kim <minchan@kernel.org>, Joel Fernandes <joel@joelfernandes.org>, Yu Zhao <yuzhao@google.com>, Jesse Barnes <jsbarnes@google.com>
List-Id: linux-api@vger.kernel.org

Hi Kirill,
I started a new thread https://lkml.org/lkml/2020/2/7/640 for my v4
patch. But I wanted to quickly address your comments. Regarding the
concern around the rmap, no changes actually need to be made. If we
were to unlink_anon_vma(vma) and then set vma->anon_vma = NULL, that
would be fine but then as soon as there was a fault the same anon_vma
would be attached since it's a private anonymous mapping. So there is
really nothing to do regarding the rmap.

I considered the two flag approach but since I could not come up with
a concrete use case of MREMAP_MUSTMOVE I decided to just leave the
single MREMAP_DONTUNMAP flag, the two flag approach would be only for
clarifying the operations so I'm not sure it's worth it. (Still trying
to come up with a better name). But I've attached a man page diff to
the latest patch.

Thanks,
Brian

On Mon, Feb 3, 2020 at 5:09 AM Kirill A. Shutemov <kirill@shutemov.name> wrote:
>
> On Sun, Feb 02, 2020 at 05:17:53AM +0100, Brian Geffon wrote:
> > On Wed, Jan 29, 2020 at 11:46 AM Kirill A. Shutemov
> > <kirill@shutemov.name> wrote:
> > > Any better options for the flag name? (I have none)
> >
> > The other option is that it's broken up into two new flags the first
> > MREMAP_MUSTMOVE which can be used regardless of whether or not you're
> > leaving the original mapping mapped. This would do exactly what it
> > describes: move the mapping to a new address with or without
> > MREMAP_FIXED, this keeps consistency with MAYMOVE.
> >
> > The second flag would be the new MREMAP_DONTUNMAP flag which requires
> > MREMAP_MUSTMOVE, again with or without MREMAP_FIXED.
> >
> > What are your thoughts on this?
>
> Sounds reasonable.
>
> MREMAP_DONTUNMAP doesn't really convey that you move pages to the new
> mapping, but leave empty mapping behind. But I guess there's only so much
> you can encode into the name. (Patch to the man page should do the rest)
>
> --
>  Kirill A. Shutemov
