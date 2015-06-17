From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: Re: [PATCH v3 2/4] pagemap: add mmap-exclusive bit for marking
 pages mapped only here
Date: Wed, 17 Jun 2015 08:11:51 +0000
Message-ID: <20150617081151.GD384@hori1.linux.bs1.fc.nec.co.jp>
References: <20150609195333.21971.58194.stgit@zurg>
 <20150609200017.21971.23391.stgit@zurg>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: quoted-printable
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20150609200017.21971.23391.stgit@zurg>
Content-Language: ja-JP
Content-ID: <F167C1AF14AAD2479227BBB1AD5A22B5@gisp.nec.co.jp>
Sender: owner-linux-mm@kvack.org
To: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, Mark Williamson <mwilliamson@undo-software.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Kirill A. Shutemov" <kirill@shutemov.name>
List-Id: linux-api@vger.kernel.org

On Tue, Jun 09, 2015 at 11:00:17PM +0300, Konstantin Khlebnikov wrote:
> From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
>=20
> This patch sets bit 56 in pagemap if this page is mapped only once.
> It allows to detect exclusively used pages without exposing PFN:
>=20
> present file exclusive state
> 0       0    0         non-present
> 1       1    0         file page mapped somewhere else
> 1       1    1         file page mapped only here
> 1       0    0         anon non-CoWed page (shared with parent/child)
> 1       0    1         anon CoWed page (or never forked)
>=20
> CoWed pages in MAP_FILE|MAP_PRIVATE areas are anon in this context.
>=20
> Mmap-exclusive bit doesn't reflect potential page-sharing via swapcache:
> page could be mapped once but has several swap-ptes which point to it.
> Application could detect that by swap bit in pagemap entry and touch
> that pte via /proc/pid/mem to get real information.
>=20
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
> Link: http://lkml.kernel.org/r/CAEVpBa+_RyACkhODZrRvQLs80iy0sqpdrd0AaP_-t=
gnX3Y9yNQ@mail.gmail.com
>=20
> ---
>=20
> v2:
> * handle transparent huge pages
> * invert bit and rename shared -> exclusive (less confusing name)
> ---
...

> @@ -1119,6 +1122,13 @@ static int pagemap_pte_range(pmd_t *pmd, unsigned =
long addr, unsigned long end,
>  		else
>  			pmd_flags2 =3D 0;
> =20
> +		if (pmd_present(*pmd)) {
> +			struct page *page =3D pmd_page(*pmd);
> +
> +			if (page_mapcount(page) =3D=3D 1)
> +				pmd_flags2 |=3D __PM_MMAP_EXCLUSIVE;
> +		}
> +

Could you do the same thing for huge_pte_to_pagemap_entry(), too?=20
                                                                 =20
Thanks,                                                          =20
Naoya Horiguchi                                                   =

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
