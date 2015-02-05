From: Minchan Kim <minchan@kernel.org>
Subject: Re: MADV_DONTNEED semantics? Was: [RFC PATCH] mm: madvise: Ignore
 repeated MADV_DONTNEED hints
Date: Thu, 5 Feb 2015 10:07:58 +0900
Message-ID: <20150205010757.GA20996@blaptop>
References: <20150202165525.GM2395@suse.de>
 <54CFF8AC.6010102@intel.com>
 <54D08483.40209@suse.cz>
 <20150203105301.GC14259@node.dhcp.inet.fi>
 <54D0B43D.8000209@suse.cz>
 <54D0F56A.9050003@gmail.com>
 <54D22298.3040504@suse.cz>
 <CAKgNAkgOOCuzJz9whoVfFjqhxM0zYsz94B1+oH58SthC5Ut9sg@mail.gmail.com>
 <54D2508A.9030804@suse.cz>
 <CAKgNAkhNbHQX7RukSsSe3bMqY11f493rYbDpTOA2jH7vsziNww@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <CAKgNAkhNbHQX7RukSsSe3bMqY11f493rYbDpTOA2jH7vsziNww@mail.gmail.com>
Sender: owner-linux-mm@kvack.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>, "Kirill A. Shutemov" <kirill@shutemov.name>, Dave Hansen <dave.hansen@intel.com>, Mel Gorman <mgorman@suse.de>, "linux-mm@kvack.org" <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>, lkml <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, linux-man <linux-man@vger.kernel.org>, Hugh Dickins <hughd@google.com>
List-Id: linux-api@vger.kernel.org

Hello,

On Wed, Feb 04, 2015 at 08:24:27PM +0100, Michael Kerrisk (man-pages) wro=
te:
> On 4 February 2015 at 18:02, Vlastimil Babka <vbabka@suse.cz> wrote:
> > On 02/04/2015 03:00 PM, Michael Kerrisk (man-pages) wrote:
> >>
> >> Hello Vlastimil,
> >>
> >> On 4 February 2015 at 14:46, Vlastimil Babka <vbabka@suse.cz> wrote:
> >>>>>
> >>>>> - that covers mlocking ok, not sure if the rest fits the "shared =
pages"
> >>>>> case
> >>>>> though. I dont see any check for other kinds of shared pages in t=
he
> >>>>> code.
> >>>>
> >>>>
> >>>> Agreed. "shared" here seems confused. I've removed it. And I've
> >>>> added mention of "Huge TLB pages" for this error.
> >>>
> >>>
> >>> Thanks.
> >>
> >>
> >> I also added those cases for MADV_REMOVE, BTW.
> >
> >
> > Right. There's also the following for MADV_REMOVE that needs updating=
:
> >
> > "Currently, only shmfs/tmpfs supports this; other filesystems return =
with
> > the error ENOSYS."
> >
> > - it's not just shmem/tmpfs anymore. It should be best to refer to
> > fallocate(2) option FALLOC_FL_PUNCH_HOLE which seems to be (more) up =
to
> > date.
> >
> > - AFAICS it doesn't return ENOSYS but EOPNOTSUPP. Also neither error =
code is
> > listed in the ERRORS section.
>=20
> Yup, I recently added that as well, based on a patch from Jan Chaloupka=
.
>=20
> >>>>>>> - The word "will result" did sound as a guarantee at least to m=
e. So
> >>>>>>> here it
> >>>>>>> could be changed to "may result (unless the advice is ignored)"=
?
> >>>>>>
> >>>>>> It's too late to fix documentation. Applications already depends=
 on
> >>>>>> the
> >>>>>> beheviour.
> >>>>>
> >>>>> Right, so as long as they check for EINVAL, it should be safe. It
> >>>>> appears
> >>>>> that
> >>>>> jemalloc does.
> >>>>
> >>>> So, first a brief question: in the cases where the call does not e=
rror
> >>>> out,
> >>>> are we agreed that in the current implementation, MADV_DONTNEED wi=
ll
> >>>> always result in zero-filled pages when the region is faulted back=
 in
> >>>> (when we consider pages that are not backed by a file)?
> >>>
> >>> I'd agree at this point.
> >>
> >> Thanks for the confirmation.
> >>
> >>> Also we should probably mention anonymously shared pages (shmem). I=
 think
> >>> they behave the same as file here.
> >>
> >> You mean tmpfs here, right? (I don't keep all of the synonyms straig=
ht.)
> >
> > shmem is tmpfs (that by itself would fit under "files" just fine), bu=
t also
> > sys V segments created by shmget(2) and also mappings created by mmap=
 with
> > MAP_SHARED | MAP_ANONYMOUS. I'm not sure if there's a single manpage =
to
> > refer to the full list.
>=20
> So, how about this text:
>=20
>               After a successful MADV_DONTNEED operation, the seman=E2=80=
=90
>               tics  of  memory  access  in  the specified region are
>               changed: subsequent accesses of  pages  in  the  range
>               will  succeed,  but will result in either reloading of
>               the memory contents from the  underlying  mapped  file
>               (for  shared file mappings, shared anonymous mappings,
>               and shmem-based techniques such  as  System  V  shared
>               memory  segments)  or  zero-fill-on-demand  pages  for
>               anonymous private mappings.

Hmm, I'd like to clarify.

Whether it was intention or not, some of userspace developers thought
about that syscall drop pages instantly if was no-error return so that
they will see more free pages(ie, rss for the process will be decreased)
with keeping the VMA. Can we rely on it?

And we should make error section, too.
"locked" covers mlock(2) and you said you will add hugetlb. Then,
VM_PFNMAP? In that case, it fails. How can we say about VM_PFNMAP?
special mapping for some drivers?

One more thing, "The kernel is free to ignore the advice".
It conflicts "This call does not influence the semantics of the
application (except in the case of MADV_DONTNEED)" so
is it okay we can believe "The kernel is free to ingmore the advise
except MADV_DONTNEED"?

Thanks.
--=20
Kind regards,
Minchan Kim

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=3Dmailto:"dont@kvack.org"> email@kvack.org </a>
