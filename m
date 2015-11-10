From: Michal Nazarewicz <mina86-deATy8a+UHjQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/2] mm: introduce page reference manipulation functions
Date: Tue, 10 Nov 2015 16:58:56 +0100
Message-ID: <xa1th9ktg81r.fsf@mina86.com>
References: <1447053784-27811-1-git-send-email-iamjoonsoo.kim@lge.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1447053784-27811-1-git-send-email-iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Joonsoo Kim <js1304-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Nov 09 2015, Joonsoo Kim wrote:
> Success of CMA allocation largely depends on success of migration
> and key factor of it is page reference count. Until now, page referen=
ce
> is manipulated by direct calling atomic functions so we cannot follow=
 up
> who and where manipulate it. Then, it is hard to find actual reason
> of CMA allocation failure. CMA allocation should be guaranteed to suc=
ceed
> so finding offending place is really important.
>
> In this patch, call sites where page reference is manipulated are con=
verted
> to introduced wrapper function. This is preparation step to add trace=
point
> to each page reference manipulation function. With this facility, we =
can
> easily find reason of CMA allocation failure. There is no functional =
change
> in this patch.
>
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>

Acked-by: Michal Nazarewicz <mina86-deATy8a+UHjQT0dZR+AlfA@public.gmane.org>

> ---
>  arch/mips/mm/gup.c                                |  2 +-
>  arch/powerpc/mm/mmu_context_hash64.c              |  3 +-
>  arch/powerpc/mm/pgtable_64.c                      |  2 +-
>  arch/x86/mm/gup.c                                 |  2 +-
>  drivers/block/aoe/aoecmd.c                        |  4 +-
>  drivers/net/ethernet/freescale/gianfar.c          |  2 +-
>  drivers/net/ethernet/intel/fm10k/fm10k_main.c     |  2 +-
>  drivers/net/ethernet/intel/igb/igb_main.c         |  2 +-
>  drivers/net/ethernet/intel/ixgbe/ixgbe_main.c     |  2 +-
>  drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c |  2 +-
>  drivers/net/ethernet/mellanox/mlx4/en_rx.c        |  7 +--
>  drivers/net/ethernet/sun/niu.c                    |  2 +-
>  include/linux/mm.h                                | 21 ++-----
>  include/linux/page_ref.h                          | 76 +++++++++++++=
++++++++++
>  include/linux/pagemap.h                           | 19 +-----
>  mm/huge_memory.c                                  |  6 +-
>  mm/internal.h                                     |  5 --
>  mm/memory_hotplug.c                               |  4 +-
>  mm/migrate.c                                      | 10 +--
>  mm/page_alloc.c                                   |  6 +-
>  mm/vmscan.c                                       |  6 +-
>  21 files changed, 114 insertions(+), 71 deletions(-)
>  create mode 100644 include/linux/page_ref.h
>

--=20
Best regards,                                            _     _
=2Eo. | Liege of Serenely Enlightened Majesty of         o' \,=3D./ `o
=2E.o | Computer Science,  =E3=83=9F=E3=83=8F=E3=82=A6 =E2=80=9Cmina86=E2=
=80=9D =E3=83=8A=E3=82=B6=E3=83=AC=E3=83=B4=E3=82=A4=E3=83=84  (o o)
ooo +--<mpn-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>--<xmpp:mina86-/eSpBmjxGS4dnm+yROfE0A@public.gmane.org>-----ooO--(_)--Ooo--
