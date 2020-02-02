From: Brian Geffon <bgeffon@google.com>
Subject: Re: [PATCH v2] mm: Add MREMAP_DONTUNMAP to mremap().
Date: Sun, 2 Feb 2020 05:17:53 +0100
Message-ID: <CADyq12xgnVByYOkL=GcszYYKzDpg254QEOFoW8=e1y=bmOCcFQ@mail.gmail.com>
References: <20200123014627.71720-1-bgeffon@google.com> <20200124190625.257659-1-bgeffon@google.com>
 <20200126220650.i4lwljpvohpgvsi2@box> <CADyq12xCK_3MhGi88Am5P6DVZvrW8vqtyJMHO0zjNhvhYegm1w@mail.gmail.com>
 <20200129104655.egvpavc2tzozlbqe@box>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200129104655.egvpavc2tzozlbqe@box>
Sender: linux-kernel-owner@vger.kernel.org
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Andrew Morton <akpm@linux-foundation.org>, "Michael S . Tsirkin" <mst@redhat.com>, Arnd Bergmann <arnd@arndb.de>, LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, linux-api@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>, Andrea Arcangeli <aarcange@redhat.com>, Sonny Rao <sonnyrao@google.com>, Minchan Kim <minchan@kernel.org>, Joel Fernandes <joel@joelfernandes.org>, Yu Zhao <yuzhao@google.com>, Jesse Barnes <jsbarnes@google.com>
List-Id: linux-api@vger.kernel.org

On Wed, Jan 29, 2020 at 11:46 AM Kirill A. Shutemov
<kirill@shutemov.name> wrote:
> Any better options for the flag name? (I have none)

The other option is that it's broken up into two new flags the first
MREMAP_MUSTMOVE which can be used regardless of whether or not you're
leaving the original mapping mapped. This would do exactly what it
describes: move the mapping to a new address with or without
MREMAP_FIXED, this keeps consistency with MAYMOVE.

The second flag would be the new MREMAP_DONTUNMAP flag which requires
MREMAP_MUSTMOVE, again with or without MREMAP_FIXED.

What are your thoughts on this?
