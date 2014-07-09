From: Minchan Kim <minchan@kernel.org>
Subject: Re: [PATCH v11 6/7] ARM: add pmd_[dirty|mkclean] for THP
Date: Wed, 9 Jul 2014 14:38:37 +0900
Message-ID: <20140709053837.GC9824@bbox>
References: <1404799424-1120-1-git-send-email-minchan@kernel.org>
 <1404799424-1120-7-git-send-email-minchan@kernel.org>
 <20140708113737.GA2958@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20140708113737.GA2958@linaro.org>
Sender: owner-linux-mm@kvack.org
To: Steve Capper <steve.capper@linaro.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Michael Kerrisk <mtk.manpages@gmail.com>, Linux API <linux-api@vger.kernel.org>, Hugh Dickins <hughd@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@redhat.com>, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, Mel Gorman <mgorman@suse.de>, Jason Evans <je@fb.com>, Zhang Yanfei <zhangyanfei@cn.fujitsu.com>, "Kirill A. Shutemov" <kirill@shutemov.name>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Russell King <linux@arm.linux.org.uk>, linux-arm-kernel@lists.infradead.org
List-Id: linux-api@vger.kernel.org

Hello Steve,

On Tue, Jul 08, 2014 at 12:37:38PM +0100, Steve Capper wrote:
> On Tue, Jul 08, 2014 at 03:03:43PM +0900, Minchan Kim wrote:
> > MADV_FREE needs pmd_dirty and pmd_mkclean for detecting recent
> > overwrite of the contents since MADV_FREE syscall is called for
> > THP page.
> >=20
> > This patch adds pmd_dirty and pmd_mkclean for THP page MADV_FREE
> > support.
> >=20
> > Cc: Catalin Marinas <catalin.marinas@arm.com>
> > Cc: Will Deacon <will.deacon@arm.com>
> > Cc: Steve Capper <steve.capper@linaro.org>
> > Cc: Russell King <linux@arm.linux.org.uk>
> > Cc: linux-arm-kernel@lists.infradead.org
> > Signed-off-by: Minchan Kim <minchan@kernel.org>
> > ---
> >  arch/arm/include/asm/pgtable-3level.h | 3 +++
> >  arch/arm64/include/asm/pgtable.h      | 2 ++
> >  2 files changed, 5 insertions(+)
>=20
> Hi Minchan,
> arch/arm and arch/arm64 are handled separately.
> Could you please split this patch into arm and arm64 versions?
>=20

Sure.

>=20
> >=20
> > diff --git a/arch/arm/include/asm/pgtable-3level.h b/arch/arm/include=
/asm/pgtable-3level.h
> > index 85c60adc8b60..3a7bb8dc7d05 100644
> > --- a/arch/arm/include/asm/pgtable-3level.h
> > +++ b/arch/arm/include/asm/pgtable-3level.h
> > @@ -220,6 +220,8 @@ static inline pmd_t *pmd_offset(pud_t *pud, unsig=
ned long addr)
> >  #define pmd_trans_splitting(pmd) (pmd_val(pmd) & PMD_SECT_SPLITTING)
> >  #endif
> > =20
> > +#define pmd_dirty	(pmd_val(pmd) & PMD_SECT_DIRTY)
>=20
> This macro is missing the parameter definition, and will generate a
> compile errror when CONFIG_ARM_LPAE=3Dy
>=20
> For 32-bit ARM with CONFIG_ARM_LPAE=3Dn, we don't have THP support and =
I noticed
> some compiler errors in mm/madvise.c:
>=20
>   CC      mm/madvise.o
> mm/madvise.c: In function =E2=80=98madvise_free_pte_range=E2=80=99:
> mm/madvise.c:279:3: error: implicit declaration of function =E2=80=98pm=
dp_get_and_clear=E2=80=99 [-Werror=3Dimplicit-function-declaration]
>    orig_pmd =3D pmdp_get_and_clear(mm, addr, pmd);
>    ^
> mm/madvise.c:285:3: error: implicit declaration of function =E2=80=98pm=
d_mkold=E2=80=99 [-Werror=3Dimplicit-function-declaration]
>    orig_pmd =3D pmd_mkold(orig_pmd);
>    ^
> mm/madvise.c:286:3: error: implicit declaration of function =E2=80=98pm=
d_mkclean=E2=80=99 [-Werror=3Dimplicit-function-declaration]
>    orig_pmd =3D pmd_mkclean(orig_pmd);
>    ^
> mm/madvise.c:288:3: error: implicit declaration of function =E2=80=98se=
t_pmd_at=E2=80=99 [-Werror=3Dimplicit-function-declaration]
>    set_pmd_at(mm, addr, pmd, orig_pmd);
>    ^
> cc1: some warnings being treated as errors
> make[1]: *** [mm/madvise.o] Error 1
>=20

Oops, will fix.

Thanks for the review!

>=20
> Cheers,
> --=20
> Steve=20
>=20
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=3Dmailto:"dont@kvack.org"> email@kvack.org </a>

--=20
Kind regards,
Minchan Kim

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=3Dmailto:"dont@kvack.org"> email@kvack.org </a>
