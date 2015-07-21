From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: Re: [PATCH v3 01/10] mm/hugetlb: add cache of descriptors to
 resv_map for region_add
Date: Tue, 21 Jul 2015 04:16:30 +0000
Message-ID: <20150721041629.GA19982@hori1.linux.bs1.fc.nec.co.jp>
References: <1436761268-6397-1-git-send-email-mike.kravetz@oracle.com>
 <1436761268-6397-2-git-send-email-mike.kravetz@oracle.com>
 <20150717090213.GB32135@hori1.linux.bs1.fc.nec.co.jp>
 <55AD34D4.2020804@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: quoted-printable
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <55AD34D4.2020804@oracle.com>
Content-Language: ja-JP
Content-ID: <22AD3C911DA5AE4BAF7FA181F0F5C9B4@gisp.nec.co.jp>
Sender: owner-linux-mm@kvack.org
To: Mike Kravetz <mike.kravetz@oracle.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>, David Rientjes <rientjes@google.com>, Hugh Dickins <hughd@google.com>, Davidlohr Bueso <dave@stgolabs.net>, Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>, Hillf Danton <hillf.zj@alibaba-inc.com>, Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>
List-Id: linux-api@vger.kernel.org

On Mon, Jul 20, 2015 at 10:50:12AM -0700, Mike Kravetz wrote:
...
> > ...
> >> @@ -3236,11 +3360,14 @@ retry:
> >>   	 * any allocations necessary to record that reservation occur outsi=
de
> >>   	 * the spinlock.
> >>   	 */
> >> -	if ((flags & FAULT_FLAG_WRITE) && !(vma->vm_flags & VM_SHARED))
> >> +	if ((flags & FAULT_FLAG_WRITE) && !(vma->vm_flags & VM_SHARED)) {
> >>   		if (vma_needs_reservation(h, vma, address) < 0) {
> >>   			ret =3D VM_FAULT_OOM;
> >>   			goto backout_unlocked;
> >>   		}
> >> +		/* Just decrements count, does not deallocate */
> >> +		vma_abort_reservation(h, vma, address);
> >> +	}
> >=20
> > This is not "abort reservation" operation, but you use "abort reservati=
on"
> > routine, which might confusing and makes future maintenance hard. I thi=
nk
> > this should be done in a simplified variant of vma_commit_reservation()
> > (maybe just an alias of your vma_abort_reservation()) or fast path in
> > vma_commit_reservation().
>=20
> I am struggling a bit with the names of these routines.  The
> routines in question are:
>=20
> vma_needs_reservation - This is a wrapper for region_chg(), so the
> 	return value is the number of regions needed for the page.
> 	Since there is only one page, the routine effectively
> 	becomes a boolean.  Hence the name "needs".
>=20
> vma_commit_reservation - This is a wrapper for region_add().  It
> 	must be called after a prior call to vma_needs_reservation
> 	and after actual allocation of the page.
>=20
> We need a way to handle the case where vma_needs_reservation has
> been called, but the page allocation is not successful.  I chose
> the name vma_abort_reservation, but as noted (even in my comments)
> it is not an actual abort.
>=20
> I am not sure if you are suggesting vma_commit_reservation() should
> handle this as a special case.  I think a separately named routine which
> indicates and end of the reservation/allocation process would be
> easier to understand.
>=20
> What about changing the name vma_abort_reservation() to
> vma_end_reservation()?  This would indicate that the reservation/
> allocation process is ended.

OK, vma_end_reservation() sounds nice to me.

> > Thanks,
> > Naoya Horiguchi
>=20
> Thank you for your reviews.

You're welcome :)

Naoya Horiguchi=

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
