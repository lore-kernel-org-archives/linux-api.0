From: Steve Capper <steve.capper-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v11 6/7] ARM: add pmd_[dirty|mkclean] for THP
Date: Tue, 8 Jul 2014 12:37:38 +0100
Message-ID: <20140708113737.GA2958@linaro.org>
References: <1404799424-1120-1-git-send-email-minchan@kernel.org>
 <1404799424-1120-7-git-send-email-minchan@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1404799424-1120-7-git-send-email-minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Jason Evans <je-b10kYP2dOMg@public.gmane.org>, Zhang Yanfei <zhangyanfei-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, Jul 08, 2014 at 03:03:43PM +0900, Minchan Kim wrote:
> MADV_FREE needs pmd_dirty and pmd_mkclean for detecting recent
> overwrite of the contents since MADV_FREE syscall is called for
> THP page.
>=20
> This patch adds pmd_dirty and pmd_mkclean for THP page MADV_FREE
> support.
>=20
> Cc: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
> Cc: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
> Cc: Steve Capper <steve.capper-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> Cc: Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>
> Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
> Signed-off-by: Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> ---
>  arch/arm/include/asm/pgtable-3level.h | 3 +++
>  arch/arm64/include/asm/pgtable.h      | 2 ++
>  2 files changed, 5 insertions(+)

Hi Minchan,
arch/arm and arch/arm64 are handled separately.
Could you please split this patch into arm and arm64 versions?


>=20
> diff --git a/arch/arm/include/asm/pgtable-3level.h b/arch/arm/include=
/asm/pgtable-3level.h
> index 85c60adc8b60..3a7bb8dc7d05 100644
> --- a/arch/arm/include/asm/pgtable-3level.h
> +++ b/arch/arm/include/asm/pgtable-3level.h
> @@ -220,6 +220,8 @@ static inline pmd_t *pmd_offset(pud_t *pud, unsig=
ned long addr)
>  #define pmd_trans_splitting(pmd) (pmd_val(pmd) & PMD_SECT_SPLITTING)
>  #endif
> =20
> +#define pmd_dirty	(pmd_val(pmd) & PMD_SECT_DIRTY)

This macro is missing the parameter definition, and will generate a
compile errror when CONFIG_ARM_LPAE=3Dy

=46or 32-bit ARM with CONFIG_ARM_LPAE=3Dn, we don't have THP support an=
d I noticed
some compiler errors in mm/madvise.c:

  CC      mm/madvise.o
mm/madvise.c: In function =E2=80=98madvise_free_pte_range=E2=80=99:
mm/madvise.c:279:3: error: implicit declaration of function =E2=80=98pm=
dp_get_and_clear=E2=80=99 [-Werror=3Dimplicit-function-declaration]
   orig_pmd =3D pmdp_get_and_clear(mm, addr, pmd);
   ^
mm/madvise.c:285:3: error: implicit declaration of function =E2=80=98pm=
d_mkold=E2=80=99 [-Werror=3Dimplicit-function-declaration]
   orig_pmd =3D pmd_mkold(orig_pmd);
   ^
mm/madvise.c:286:3: error: implicit declaration of function =E2=80=98pm=
d_mkclean=E2=80=99 [-Werror=3Dimplicit-function-declaration]
   orig_pmd =3D pmd_mkclean(orig_pmd);
   ^
mm/madvise.c:288:3: error: implicit declaration of function =E2=80=98se=
t_pmd_at=E2=80=99 [-Werror=3Dimplicit-function-declaration]
   set_pmd_at(mm, addr, pmd, orig_pmd);
   ^
cc1: some warnings being treated as errors
make[1]: *** [mm/madvise.o] Error 1


Cheers,
--=20
Steve=20
