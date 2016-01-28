From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: Re: [PATCH v1] mm/madvise: pass return code of memory_failure() to
 userspace
Date: Thu, 28 Jan 2016 05:49:11 +0000
Message-ID: <20160128054910.GA5512@hori1.linux.bs1.fc.nec.co.jp>
References: <1453451277-20979-1-git-send-email-n-horiguchi@ah.jp.nec.com>
 <56A8CD2F.5080903@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: quoted-printable
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <56A8CD2F.5080903@suse.cz>
Content-Language: ja-JP
Content-ID: <660470AA4C6CBE4BBBE0AA15FAA87D66@gisp.nec.co.jp>
Sender: owner-linux-mm@kvack.org
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chen Gong <gong.chen@linux.intel.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Naoya Horiguchi <nao.horiguchi@gmail.com>, Linux API <linux-api@vger.kernel.org>, "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>, Michael Kerrisk <mtk.manpages@gmail.com>
List-Id: linux-api@vger.kernel.org

On Wed, Jan 27, 2016 at 02:59:11PM +0100, Vlastimil Babka wrote:
> [CC +=3D linux-api, linux-man]
>=20
> On 01/22/2016 09:27 AM, Naoya Horiguchi wrote:
> > Currently the return value of memory_failure() is not passed to userspa=
ce, which
> > is inconvenient for test programs that want to know the result of error=
 handling.
> > So let's return it to the caller as we already do in MADV_SOFT_OFFLINE =
case.
> >=20
> > Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> > ---
> >  mm/madvise.c | 5 +++--
> >  1 file changed, 3 insertions(+), 2 deletions(-)
> >=20
> > diff --git v4.4-mmotm-2016-01-20-16-10/mm/madvise.c v4.4-mmotm-2016-01-=
20-16-10_patched/mm/madvise.c
> > index f56825b..6a77114 100644
> > --- v4.4-mmotm-2016-01-20-16-10/mm/madvise.c
> > +++ v4.4-mmotm-2016-01-20-16-10_patched/mm/madvise.c
> > @@ -555,8 +555,9 @@ static int madvise_hwpoison(int bhv, unsigned long =
start, unsigned long end)
> >  		}
> >  		pr_info("Injecting memory failure for page %#lx at %#lx\n",
> >  		       page_to_pfn(p), start);
> > -		/* Ignore return value for now */
> > -		memory_failure(page_to_pfn(p), 0, MF_COUNT_INCREASED);
> > +		ret =3D memory_failure(page_to_pfn(p), 0, MF_COUNT_INCREASED);
> > +		if (ret)
> > +			return ret;
>=20
> Can you explain what madvise can newly return for MADV_HWPOISON in which
> situations, for the purposes of updated man page?

OK, this patch newly allows madvise(MADV_HWPOISON) to return EBUSY when
error handling failed due to 2 major reasons:
 - the target page is a page type which memory error handler doesn't suppor=
t
   (like slab pages, kernel-reserved pages)
 - the memory error handler failed to isolate the target page (for example,
   due to failure in unmapping)

And for man page purpose, errnos of MADV_SOFT_OFFLINE is not documented eit=
her.
So let me refer to 2 possible error code from madvise(MADV_SOFT_OFFLINE):
 - EBUSY: failed to isolate from lru list,
 - EIO: failed to migrate the target page to another page.

Thanks,
Naoya Horiguchi=

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
