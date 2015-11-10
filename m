From: Michal Nazarewicz <mina86-deATy8a+UHjQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/2] mm/page_ref: add tracepoint to track down page reference manipulation
Date: Tue, 10 Nov 2015 17:02:43 +0100
Message-ID: <xa1tegfxg7vg.fsf@mina86.com>
References: <1447053784-27811-1-git-send-email-iamjoonsoo.kim@lge.com> <1447053784-27811-2-git-send-email-iamjoonsoo.kim@lge.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1447053784-27811-2-git-send-email-iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Joonsoo Kim <js1304-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Nov 09 2015, Joonsoo Kim wrote:
> CMA allocation should be guaranteed to succeed by definition,=20

Uh?  That=E2=80=99s a peculiar statement.  Which is to say that it=E2=80=
=99s not true.

> but,
> unfortunately, it would be failed sometimes. It is hard to track down
> the problem, because it is related to page reference manipulation and
> we don't have any facility to analyze it.
>
> This patch adds tracepoints to track down page reference manipulation=
=2E
> With it, we can find exact reason of failure and can fix the problem.
> Following is an example of tracepoint output.
>
> <...>-9018  [004]    92.678375: page_ref_set:         pfn=3D0x17ac9 f=
lags=3D0x0 count=3D1 mapcount=3D0 mapping=3D(nil) mt=3D4 val=3D1
> <...>-9018  [004]    92.678378: kernel_stack:
>  =3D> get_page_from_freelist (ffffffff81176659)
>  =3D> __alloc_pages_nodemask (ffffffff81176d22)
>  =3D> alloc_pages_vma (ffffffff811bf675)
>  =3D> handle_mm_fault (ffffffff8119e693)
>  =3D> __do_page_fault (ffffffff810631ea)
>  =3D> trace_do_page_fault (ffffffff81063543)
>  =3D> do_async_page_fault (ffffffff8105c40a)
>  =3D> async_page_fault (ffffffff817581d8)
> [snip]
> <...>-9018  [004]    92.678379: page_ref_mod:         pfn=3D0x17ac9 f=
lags=3D0x40048 count=3D2 mapcount=3D1 mapping=3D0xffff880015a78dc1 mt=3D=
4 val=3D1
> [snip]
> ...
> ...
> <...>-9131  [001]    93.174468: test_pages_isolated:  start_pfn=3D0x1=
7800 end_pfn=3D0x17c00 fin_pfn=3D0x17ac9 ret=3Dfail
> [snip]
> <...>-9018  [004]    93.174843: page_ref_mod_and_test: pfn=3D0x17ac9 =
flags=3D0x40068 count=3D0 mapcount=3D0 mapping=3D0xffff880015a78dc1 mt=3D=
4 val=3D-1 ret=3D1
>  =3D> release_pages (ffffffff8117c9e4)
>  =3D> free_pages_and_swap_cache (ffffffff811b0697)
>  =3D> tlb_flush_mmu_free (ffffffff81199616)
>  =3D> tlb_finish_mmu (ffffffff8119a62c)
>  =3D> exit_mmap (ffffffff811a53f7)
>  =3D> mmput (ffffffff81073f47)
>  =3D> do_exit (ffffffff810794e9)
>  =3D> do_group_exit (ffffffff81079def)
>  =3D> SyS_exit_group (ffffffff81079e74)
>  =3D> entry_SYSCALL_64_fastpath (ffffffff817560b6)
>
> This output shows that problem comes from exit path. In exit path,
> to improve performance, pages are not freed immediately. They are gat=
hered
> and processed by batch. During this process, migration cannot be poss=
ible
> and CMA allocation is failed. This problem is hard to find without th=
is
> page reference tracepoint facility.
>
> Enabling this feature bloat kernel text 20 KB in my configuration.
>
>    text    data     bss     dec     hex filename
> 12041272        2223424 1507328 15772024         f0a978 vmlinux_disab=
led
> 12064844        2225920 1507328 15798092         f10f4c vmlinux_enabl=
ed
>
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>

Acked-by: Michal Nazarewicz <mina86-deATy8a+UHjQT0dZR+AlfA@public.gmane.org>

> ---
>  include/trace/events/page_ref.h | 128 ++++++++++++++++++++++++++++++=
++++++++++

I haven=E2=80=99t really looked at the above file though.

--=20
Best regards,                                            _     _
=2Eo. | Liege of Serenely Enlightened Majesty of         o' \,=3D./ `o
=2E.o | Computer Science,  =E3=83=9F=E3=83=8F=E3=82=A6 =E2=80=9Cmina86=E2=
=80=9D =E3=83=8A=E3=82=B6=E3=83=AC=E3=83=B4=E3=82=A4=E3=83=84  (o o)
ooo +--<mpn-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>--<xmpp:mina86-/eSpBmjxGS4dnm+yROfE0A@public.gmane.org>-----ooO--(_)--Ooo--
