From: Eric B Munson <emunson-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4 00/10] hugetlbfs: add fallocate support
Date: Thu, 23 Jul 2015 13:17:28 -0400
Message-ID: <20150723171728.GC9203@akamai.com>
References: <1437502184-14269-1-git-send-email-mike.kravetz@oracle.com>
 <20150722150647.2597c7e5be9ee1eecc438b6f@linux-foundation.org>
 <1437603594.3298.5.camel@stgolabs.net>
 <20150722153023.e8f15eb4e490f79cc029c8cd@linux-foundation.org>
 <55B024C6.8010504@oracle.com>
 <20150723151707.GB7795@akamai.com>
 <55B11EEF.1070605@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="w7PDEPdKQumQfZlR"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <55B11EEF.1070605-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Kravetz <mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Davidlohr Bueso <dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Naoya Horiguchi <n-horiguchi-PaJj6Psr51x8UrSeD/g0lQ@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Aneesh Kumar <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Hillf Danton <hillf.zj-gPhfCIXyaqCqndwCJWfcng@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, emunson-CVBTeua0HjReoWH0uzbU5w@public.gmane.org
List-Id: linux-api@vger.kernel.org


--w7PDEPdKQumQfZlR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, 23 Jul 2015, Mike Kravetz wrote:

> On 07/23/2015 08:17 AM, Eric B Munson wrote:
> >On Wed, 22 Jul 2015, Mike Kravetz wrote:
> >
> >>On 07/22/2015 03:30 PM, Andrew Morton wrote:
> >>>On Wed, 22 Jul 2015 15:19:54 -0700 Davidlohr Bueso <dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org>=
 wrote:
> >>>
> >>>>>
> >>>>>I didn't know that libhugetlbfs has tests.  I wonder if that makes
> >>>>>tools/testing/selftests/vm's hugetlbfstest harmful?
> >>>>
> >>>>Why harmful? Redundant, maybe(?).
> >>>
> >>>The presence of the in-kernel tests will cause people to add stuff to
> >>>them when it would be better if they were to apply that effort to
> >>>making libhugetlbfs better.  Or vice versa.
> >>>
> >>>Mike's work is an example.  Someone later makes a change to hugetlbfs,=
 runs
> >>>the kernel selftest and says "yay, everything works", unaware that they
> >>>just broke fallocate support.
> >>>
> >>>>Does anyone even use selftests for
> >>>>hugetlbfs regression testing? Lets see, we also have these:
> >>>>
> >>>>- hugepage-{mmap,shm}.c
> >>>>- map_hugetlb.c
> >>>>
> >>>>There's probably a lot of room for improvement here.
> >>>
> >>>selftests is a pretty scrappy place.  It's partly a dumping ground for
> >>>things so useful test code doesn't just get lost and bitrotted.  Partly
> >>>a framework so people who add features can easily test them. Partly to
> >>>provide tools to architecture maintainers when they wire up new
> >>>syscalls and the like.
> >>>
> >>>Unless there's some good reason to retain the hugetlb part of
> >>>selftests, I'm thinking we should just remove it to avoid
> >>>distracting/misleading people.  Or possibly move the libhugetlbfs test
> >>>code into the kernel tree and maintain it there.
> >>
> >>Adding Eric as he is the libhugetlbfs maintainer.
> >>
> >>I think removing the hugetlb selftests in the kernel and pointing
> >>people to libhugetlbfs is the way to go.  From a very quick scan
> >>of the selftests, I would guess libhugetlbfs covers everything
> >>in those tests.
> >>
> >>I'm willing to verify the testing provided by selftests is included
> >>in libhugetlbfs, and remove selftests if that is the direction we
> >>want to take.
> >
> >I would rather see the test suite stay in the library, there are a
> >number of tests that rely on infrastructure in the library that is not
> >available in selftests.
> >
> >I am happy to help with any tests that need to be added/modified in the
> >library to cover.
>=20
> I thought about this some more and think there are two distinct
> groups of users that should be considered.
> 1) Application developers who simply want to use hugetlb
> 2) Kernel developers who are modifying hugetlb related code
>=20
> The application developers will mostly want information in the
> man pages, hugetlbpage.txt and hugetlb selftest programs to use
> as sample code to get started.  They can also use libhugetlbfs
> man pages/library if they desire.  Because of this, I do not
> really want to remove the hugetlb selftest programs.  There are
> no equivalent simple stand alone programs in libhugetlbfs.
>=20
> Kernel developers would be more concerned about introducing
> regressions.  The selftest programs are of limited use for this
> purpose.  The libhugetlbfs test suite is much more suited for
> regression testing.
>=20
> With this in mind, I suggest:
> - Keep the mmap man page reference to Documentation/vm/hugetlbpage.txt
> - Small modification to hugetlbpage.txt saying the selftest code is
>   good for application development examples.  And, kernel developers
>   should use libhugetlbfs test suite for regression testing.  In any
>   case, the sourceforge URL for libhugetlbfs is no longer valid and
>   needs to be updated.
> - Modify the run_vmtests selftest script to print out a message saying
>   libhugetlbfs should be used for hugetlb regression testing.  This
>   would help catch people who might think the few selftests are
>   sufficient.
>=20
> Thoughts?

There are a number of tests in the libhugetlbfs suite that cover kernel
problems, are you suggesting that we move all these tests out of
libhugetlbfs and into selftests?  I don't think we should separate the
responsibility for testing kernel regressions so where ever they end up,
they should all be together.  The libhugetlbfs suite has some nice
features for setting up the test environment (consider that a plug to
move tests in that direction).


--w7PDEPdKQumQfZlR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJVsSGoAAoJELbVsDOpoOa9WhkP/iFxn4rxF7z59L/43n/CfuTF
WYHU+M9yuGVePuS93emyT4gjqNA+JMRKOUYYT1rYyDy3jVDoTFrB+qkogWEpM+yD
LBJYRTgGQfbw5dxiKCJPMgE7XxTz9aOhVUxs+5/NjbDFuoS/DXO7bHd2SIEXO3qH
x4jUn1PsZolv6loWf7qrWfTzWkMLqkCa3IdF7IGh9lcK+2ytC7iTYdt+BU04eX+X
uF1tQkv5zL6svKJ/k1cDSQcrwGCfzc6T30yII7xTmqsfhxPWvpUr8O0qHehlZhve
oZJHwBi90J2ZT8lJm4bW5oH67wV7aeGAdzxUUo3WVIofmXBT0hFxNoH9WLtdWLeG
vslF3UWc8QgjRe5/LfKJIjUJ7ZKw7ijQypMUKa42z0K3f/WPJKPIG7oLnl5zsk+m
9MP7gVlhhUzEQX9Y+ydBfH+d+jzoCGLhyUaNkSvDewpj0d8tKAc9SDCuS4zdNlvF
vG3oP8pCJJHQt3QQKCUspPjat/ygVrM41fwGO+f7utkLdcsB4rRpUPJ6ItPpcozY
s0jrd4CETuD+uuVslTKsjrvYFqMmyU38oJXngxh9u++wvpaygohLygA1HPY2YuTU
kGKlDRmS1p5qA4huDLxj8UMW8geGwxGLE3p8Z0y5RT5a9qwbiEp++4KVBs8pde9X
Muh3FAlye2/Sm7zzdiNd
=taq5
-----END PGP SIGNATURE-----

--w7PDEPdKQumQfZlR--
