From: Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: MADV_DONTNEED semantics? Was: [RFC PATCH] mm: madvise: Ignore
 repeated MADV_DONTNEED hints
Date: Mon, 9 Feb 2015 15:46:00 +0900
Message-ID: <20150209064600.GA32300@blaptop>
References: <54D08483.40209@suse.cz>
 <20150203105301.GC14259@node.dhcp.inet.fi>
 <54D0B43D.8000209@suse.cz>
 <54D0F56A.9050003@gmail.com>
 <54D22298.3040504@suse.cz>
 <CAKgNAkgOOCuzJz9whoVfFjqhxM0zYsz94B1+oH58SthC5Ut9sg@mail.gmail.com>
 <54D2508A.9030804@suse.cz>
 <CAKgNAkhNbHQX7RukSsSe3bMqY11f493rYbDpTOA2jH7vsziNww@mail.gmail.com>
 <20150205010757.GA20996@blaptop>
 <54D4E098.8050004@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <54D4E098.8050004-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-man <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hello, Michael

On Fri, Feb 06, 2015 at 04:41:12PM +0100, Michael Kerrisk (man-pages) w=
rote:
> On 02/05/2015 02:07 AM, Minchan Kim wrote:
> > Hello,
> >=20
> > On Wed, Feb 04, 2015 at 08:24:27PM +0100, Michael Kerrisk (man-page=
s) wrote:
> >> On 4 February 2015 at 18:02, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org> wrot=
e:
> >>> On 02/04/2015 03:00 PM, Michael Kerrisk (man-pages) wrote:
> >>>>
> >>>> Hello Vlastimil,
> >>>>
> >>>> On 4 February 2015 at 14:46, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org> wr=
ote:
> >>>>>>>
> >>>>>>> - that covers mlocking ok, not sure if the rest fits the "sha=
red pages"
> >>>>>>> case
> >>>>>>> though. I dont see any check for other kinds of shared pages =
in the
> >>>>>>> code.
> >>>>>>
> >>>>>>
> >>>>>> Agreed. "shared" here seems confused. I've removed it. And I'v=
e
> >>>>>> added mention of "Huge TLB pages" for this error.
> >>>>>
> >>>>>
> >>>>> Thanks.
> >>>>
> >>>>
> >>>> I also added those cases for MADV_REMOVE, BTW.
> >>>
> >>>
> >>> Right. There's also the following for MADV_REMOVE that needs upda=
ting:
> >>>
> >>> "Currently, only shmfs/tmpfs supports this; other filesystems ret=
urn with
> >>> the error ENOSYS."
> >>>
> >>> - it's not just shmem/tmpfs anymore. It should be best to refer t=
o
> >>> fallocate(2) option FALLOC_FL_PUNCH_HOLE which seems to be (more)=
 up to
> >>> date.
> >>>
> >>> - AFAICS it doesn't return ENOSYS but EOPNOTSUPP. Also neither er=
ror code is
> >>> listed in the ERRORS section.
> >>
> >> Yup, I recently added that as well, based on a patch from Jan Chal=
oupka.
> >>
> >>>>>>>>> - The word "will result" did sound as a guarantee at least =
to me. So
> >>>>>>>>> here it
> >>>>>>>>> could be changed to "may result (unless the advice is ignor=
ed)"?
> >>>>>>>>
> >>>>>>>> It's too late to fix documentation. Applications already dep=
ends on
> >>>>>>>> the
> >>>>>>>> beheviour.
> >>>>>>>
> >>>>>>> Right, so as long as they check for EINVAL, it should be safe=
=2E It
> >>>>>>> appears
> >>>>>>> that
> >>>>>>> jemalloc does.
> >>>>>>
> >>>>>> So, first a brief question: in the cases where the call does n=
ot error
> >>>>>> out,
> >>>>>> are we agreed that in the current implementation, MADV_DONTNEE=
D will
> >>>>>> always result in zero-filled pages when the region is faulted =
back in
> >>>>>> (when we consider pages that are not backed by a file)?
> >>>>>
> >>>>> I'd agree at this point.
> >>>>
> >>>> Thanks for the confirmation.
> >>>>
> >>>>> Also we should probably mention anonymously shared pages (shmem=
). I think
> >>>>> they behave the same as file here.
> >>>>
> >>>> You mean tmpfs here, right? (I don't keep all of the synonyms st=
raight.)
> >>>
> >>> shmem is tmpfs (that by itself would fit under "files" just fine)=
, but also
> >>> sys V segments created by shmget(2) and also mappings created by =
mmap with
> >>> MAP_SHARED | MAP_ANONYMOUS. I'm not sure if there's a single manp=
age to
> >>> refer to the full list.
> >>
> >> So, how about this text:
> >>
> >>               After a successful MADV_DONTNEED operation, the sema=
n=E2=80=90
> >>               tics  of  memory  access  in  the specified region a=
re
> >>               changed: subsequent accesses of  pages  in  the  ran=
ge
> >>               will  succeed,  but will result in either reloading =
of
> >>               the memory contents from the  underlying  mapped  fi=
le
> >>               (for  shared file mappings, shared anonymous mapping=
s,
> >>               and shmem-based techniques such  as  System  V  shar=
ed
> >>               memory  segments)  or  zero-fill-on-demand  pages  f=
or
> >>               anonymous private mappings.
> >=20
> > Hmm, I'd like to clarify.
> >=20
> > Whether it was intention or not, some of userspace developers thoug=
ht
> > about that syscall drop pages instantly if was no-error return so t=
hat
> > they will see more free pages(ie, rss for the process will be decre=
ased)
> > with keeping the VMA. Can we rely on it?
>=20
> I do not know. Michael?

It's important to identify difference between MADV_DONTNEED and MADV_FR=
EE
so it would be better to clear out in this chance.

>=20
> > And we should make error section, too.
> > "locked" covers mlock(2) and you said you will add hugetlb. Then,
> > VM_PFNMAP? In that case, it fails. How can we say about VM_PFNMAP?
> > special mapping for some drivers?
>=20
> I'm open for offers on what to add.

I suggests from quote "LWN" http://lwn.net/Articles/162860/
"*special mapping* which is not made up of "normal" pages.
It is usually created by device drivers which map special memory areas
into user space"

> =20
> > One more thing, "The kernel is free to ignore the advice".
> > It conflicts "This call does not influence the semantics of the
> > application (except in the case of MADV_DONTNEED)" so
> > is it okay we can believe "The kernel is free to ingmore the advise
> > except MADV_DONTNEED"?
>=20
> I decided to just drop the sentence
>=20
>      The kernel is free to ignore the advice.
>=20
> It creates misunderstandings, and does not really add information.

Sounds good.

>=20
> Cheers,
>=20
> Michael
>=20
> --=20
> Michael Kerrisk
> Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
> Linux/UNIX System Programming Training: http://man7.org/training/

--=20
Kind regards,
Minchan Kim
