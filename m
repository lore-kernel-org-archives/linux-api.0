From: Eric B Munson <emunson-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v7 3/6] mm: Introduce VM_LOCKONFAULT
Date: Fri, 21 Aug 2015 14:31:32 -0400
Message-ID: <20150821183132.GA12835@akamai.com>
References: <1439097776-27695-1-git-send-email-emunson@akamai.com>
 <1439097776-27695-4-git-send-email-emunson@akamai.com>
 <20150812115909.GA5182@dhcp22.suse.cz>
 <20150819213345.GB4536@akamai.com>
 <20150820075611.GD4780@dhcp22.suse.cz>
 <20150820170309.GA11557@akamai.com>
 <20150821072552.GF23723@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nFreZHaLTZJo0R7j"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150821072552.GF23723-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org


--nFreZHaLTZJo0R7j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, 21 Aug 2015, Michal Hocko wrote:

> On Thu 20-08-15 13:03:09, Eric B Munson wrote:
> > On Thu, 20 Aug 2015, Michal Hocko wrote:
> >=20
> > > On Wed 19-08-15 17:33:45, Eric B Munson wrote:
> > > [...]
> > > > The group which asked for this feature here
> > > > wants the ability to distinguish between LOCKED and LOCKONFAULT reg=
ions
> > > > and without the VMA flag there isn't a way to do that.
> > >=20
> > > Could you be more specific on why this is needed?
> >=20
> > They want to keep metrics on the amount of memory used in a LOCKONFAULT
> > region versus the address space of the region.
>=20
> /proc/<pid>/smaps already exports that information AFAICS. It exports
> VMA flags including VM_LOCKED and if rss < size then this is clearly
> LOCKONFAULT because the standard mlock semantic is to populate. Would
> that be sufficient?
>=20
> Now, it is true that LOCKONFAULT wouldn't be distinguishable from
> MAP_LOCKED which failed to populate but does that really matter? It is
> LOCKONFAULT in a way as well.

Does that matter to my users?  No, they do not use MAP_LOCKED at all so
any VMA with VM_LOCKED set and rss < size is lock on fault.  Will it
matter to others?  I suspect so, but these are likely to be the same
group of users which will be suprised to learn that MAP_LOCKED does not
guarantee that the entire range is faulted in on return from mmap.

>=20
> > > > Do we know that these last two open flags are needed right now or is
> > > > this speculation that they will be and that none of the other VMA f=
lags
> > > > can be reclaimed?
> > >=20
> > > I do not think they are needed by anybody right now but that is not a
> > > reason why it should be used without a really strong justification.
> > > If the discoverability is really needed then fair enough but I haven't
> > > seen any justification for that yet.
> >=20
> > To be completely clear you believe that if the metrics collection is
> > not a strong enough justification, it is better to expand the mm_struct
> > by another unsigned long than to use one of these bits right?
>=20
> A simple bool is sufficient for that. And yes I think we should go with
> per mm_struct flag rather than the additional vma flag if it has only
> the global (whole address space) scope - which would be the case if the
> LOCKONFAULT is always an mlock modifier and the persistance is needed
> only for MCL_FUTURE. Which is imho a sane semantic.

I am in the middle of implementing lock on fault this way, but I cannot
see how we will hanlde mremap of a lock on fault region.  Say we have
the following:

    addr =3D mmap(len, MAP_ANONYMOUS, ...);
    mlock(addr, len, MLOCK_ONFAULT);
    ...
    mremap(addr, len, 2 * len, ...)

There is no way for mremap to know that the area being remapped was lock
on fault so it will be locked and prefaulted by remap.  How can we avoid
this without tracking per vma if it was locked with lock or lock on
fault?

--nFreZHaLTZJo0R7j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJV126DAAoJELbVsDOpoOa9eWQQAM0jfPO6S+BsPDiVFElyHT1K
z5SHCEVa/SNT78zRrOMFbHhsyf0ApVleinwcl2E6m9bqUcsj8eRUX4//sxzpyFJr
qJDeH2RIKSykk8SaZqjvAcAgfZ2PUSG675Ezheo2w4IV/e9/G1HItKshtvTJ5kLr
Vh6UhSmzyPJ5bBnd9L2SyK1MRMOxH+O5t/55EzvqIcRRZTG5aEfE1efmOmAmdVce
ZPrNGyMykIoyluqHDTCpQFZVoxjIGMTI2L66pOwwHKw8Wav0dF7eSrH+AKXo7JUn
W01M/MC6werWJSvQLnKrCNVMJnWC0Vmvw+7YJZzRAHfuZJ9cfifRb0xmNKrC5Rvr
CcAyeOOq9WM6KuerUnjwThfq/zku6EZmKPW1KHk5yM3688K1B3EvFH+U2ieiKUzL
7uhLPqRSlRbXUyAou6TrStw9swXiJzmsSfhY5Qwy2BLrxSkhAaqrUj+yt6h6Z7Cv
JpGMObE6cQS24VG5i0CkrXHvuqsjeTvcTbVD3VR3YnoBglwy/4LifnQ8Mile519g
AJIuqVhTr5B7Trlo35d3HYe9KoRLqzw++7eYFEGhDiZVn1l6Xe8EJ93ninBjn00c
QI7uEA69XaFzX6WixKo6+pbpte+XewF1H86FgOsxRL+g0vf56AW1hTc2jWL8qEDX
RE6snxvPH3ILjEzxNtAm
=0Vtz
-----END PGP SIGNATURE-----

--nFreZHaLTZJo0R7j--
