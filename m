From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: Re: [PATCH v4 4/5] pagemap: hide physical addresses from
 non-privileged users
Date: Tue, 21 Jul 2015 08:11:50 +0000
Message-ID: <20150721081149.GC4490@hori1.linux.bs1.fc.nec.co.jp>
References: <20150714152516.29844.69929.stgit@buzz>
 <20150714153747.29844.13543.stgit@buzz>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: quoted-printable
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20150714153747.29844.13543.stgit@buzz>
Content-Language: ja-JP
Content-ID: <348F569F08A4794D8983C2FAFB19992E@gisp.nec.co.jp>
Sender: owner-linux-mm@kvack.org
To: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>, "Kirill A. Shutemov" <kirill@shutemov.name>, Mark Williamson <mwilliamson@undo-software.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, Jul 14, 2015 at 06:37:47PM +0300, Konstantin Khlebnikov wrote:
> This patch makes pagemap readable for normal users and hides physical
> addresses from them. For some use-cases PFN isn't required at all.
>=20
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
> Fixes: ab676b7d6fbf ("pagemap: do not leak physical addresses to non-priv=
ileged userspace")
> Link: http://lkml.kernel.org/r/1425935472-17949-1-git-send-email-kirill@s=
hutemov.name
> ---
>  fs/proc/task_mmu.c |   25 ++++++++++++++-----------
>  1 file changed, 14 insertions(+), 11 deletions(-)
>=20
> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index 040721fa405a..3a5d338ea219 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -937,6 +937,7 @@ typedef struct {
>  struct pagemapread {
>  	int pos, len;		/* units: PM_ENTRY_BYTES, not bytes */
>  	pagemap_entry_t *buffer;
> +	bool show_pfn;
>  };
> =20
>  #define PAGEMAP_WALK_SIZE	(PMD_SIZE)
> @@ -1013,7 +1014,8 @@ static pagemap_entry_t pte_to_pagemap_entry(struct =
pagemapread *pm,
>  	struct page *page =3D NULL;
> =20
>  	if (pte_present(pte)) {
> -		frame =3D pte_pfn(pte);
> +		if (pm->show_pfn)
> +			frame =3D pte_pfn(pte);
>  		flags |=3D PM_PRESENT;
>  		page =3D vm_normal_page(vma, addr, pte);
>  		if (pte_soft_dirty(pte))

Don't you need the same if (pm->show_pfn) check in is_swap_pte path, too?
(although I don't think that it can be exploited by row hammer attack ...)

Thanks,
Naoya Horiguchi=

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
