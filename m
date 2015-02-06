From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: MADV_DONTNEED semantics? Was: [RFC PATCH] mm: madvise: Ignore
 repeated MADV_DONTNEED hints
Date: Fri, 6 Feb 2015 21:45:36 +0100
Message-ID: <20150206204536.GA24245@dhcp22.suse.cz>
References: <54D08483.40209@suse.cz>
 <20150203105301.GC14259@node.dhcp.inet.fi>
 <54D0B43D.8000209@suse.cz>
 <54D0F56A.9050003@gmail.com>
 <54D22298.3040504@suse.cz>
 <CAKgNAkgOOCuzJz9whoVfFjqhxM0zYsz94B1+oH58SthC5Ut9sg@mail.gmail.com>
 <54D2508A.9030804@suse.cz>
 <CAKgNAkhNbHQX7RukSsSe3bMqY11f493rYbDpTOA2jH7vsziNww@mail.gmail.com>
 <20150205154102.GA20607@dhcp22.suse.cz>
 <54D4E47E.4020509@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <54D4E47E.4020509-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-man <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri 06-02-15 16:57:50, Michael Kerrisk wrote:
[...]
> > Yes, this wording is better because many users are not aware of
> > MAP_ANON|MAP_SHARED being file backed in fact and mmap man page doe=
sn't
> > mention that.
>=20
> (Michal, would you have a text to propose to add to the mmap(2) page?
> Maybe it would be useful to add something there.)

I am half way on vacation, but I can cook a patch after I am back after
week.
=20
> > I am just wondering whether it makes sense to mention that MADV_DON=
TNEED
> > for shared mappings might be surprising and not freeing the backing
> > pages thus not really freeing memory until there is a memory
> > pressure. But maybe this is too implementation specific for a man
> > page. What about the following wording on top of yours?
> > "
> > Please note that the MADV_DONTNEED hint on shared mappings might no=
t
> > lead to immediate freeing of pages in the range. The kernel is free=
 to
> > delay this until an appropriate moment. RSS of the calling process =
will
> > be reduced however.
> > "
>=20
> Thanks! I added this, but dropped in the word "immediately" in the la=
st=20
> sentence, since I assume that was implied. So now we have:
>=20
>               After  a  successful MADV_DONTNEED operation, the seman=
=E2=80=90
>               tics of  memory  access  in  the  specified  region  ar=
e
>               changed:  subsequent accesses of pages in the range wil=
l
>               succeed, but will result in either repopulating the mem=
=E2=80=90
>               ory  contents from the up-to-date contents of the under=
=E2=80=90
>               lying mapped file  (for  shared  file  mappings,  share=
d
>               anonymous  mappings,  and shmem-based techniques such a=
s
>               System V shared memory segments) or  zero-fill-on-deman=
d
>               pages for anonymous private mappings.
>=20
>               Note  that,  when applied to shared mappings, MADV_DONT=
=E2=80=90
>               NEED might not lead to immediate freeing of the pages i=
n
>               the  range.   The  kernel  is  free to delay freeing th=
e
>               pages until an appropriate  moment.   The  resident  se=
t
>               size  (RSS)  of  the calling process will be immediatel=
y
>               reduced however.

This sounds good to me and it is definitely much better than the curren=
t
state. Thanks!

> The current draft of the page can be found in a branch,
> http://git.kernel.org/cgit/docs/man-pages/man-pages.git/log/?h=3Ddraf=
t_madvise
>=20
> Thanks,
>=20
> Michael
>=20
>=20
>=20
> --=20
> Michael Kerrisk
> Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
> Linux/UNIX System Programming Training: http://man7.org/training/

--=20
Michal Hocko
SUSE Labs
