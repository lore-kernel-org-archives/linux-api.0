From: "W. Trevor King" <wking-vJI2gpByivqcqzYg7KEe8g@public.gmane.org>
Subject: Re: [CRIU] Introspecting userns relationships to other namespaces?
Date: Fri, 8 Jul 2016 13:50:52 -0700
Message-ID: <20160708205052.GA4916@odin.tremily.us>
References: <c2a26220-69f2-f2f5-491a-e43abd9a6f92@gmail.com>
 <87r3b7pxja.fsf@x220.int.ebiederm.org>
 <CAKgNAkgQbxLH-B3N3Xti3LLis+1Y-SJD2h1DEaXao7zTDA7pug@mail.gmail.com>
 <20160706141348.GB20728@mail.hallyn.com>
 <871t36kbvq.fsf@x220.int.ebiederm.org>
 <20160708015758.GA10512@outlook.office365.com>
 <87vb0gy3nr.fsf@x220.int.ebiederm.org>
 <1467988533.2322.118.camel@HansenPartnership.com>
 <20160708203818.GA2602@outlook.office365.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/biO8xG9SRhq5SLW"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160708203818.GA2602-1ViLX0X+lBJGNQ1M2rI3KwRV3xvJKrda@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Vagin <avagin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, criu-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org


--/biO8xG9SRhq5SLW
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 08, 2016 at 01:38:19PM -0700, Andrew Vagin wrote:
> What do you think about the idea to mount nsfs and be able to look up
> any alive namespace by inum:
>
>   $ tree .
>   .
>   =E2=94=9C=E2=94=80=E2=94=80 mnt{inum}
>   =E2=94=82   =E2=94=94=E2=94=80=E2=94=80 user -> ../user{inum}
>   =E2=94=9C=E2=94=80=E2=94=80 pid{inum}
>   =E2=94=82   =E2=94=9C=E2=94=80=E2=94=80 pid{inum}
>   =E2=94=82   =E2=94=82   =E2=94=94=E2=94=80=E2=94=80 user -> ../../user{=
inum}/user{inum}
>   =E2=94=82   =E2=94=94=E2=94=80=E2=94=80 user -> ../user{inum}
>   =E2=94=94=E2=94=80=E2=94=80 user{inum}
>       =E2=94=94=E2=94=80=E2=94=80 user{inum}
>
> https://lkml.org/lkml/2016/7/8/59
>
> I think it solves all requirements which were mentioned in this thread.

It may need an additional entry per directory for the bit you setns.
Maybe =E2=80=98handle=E2=80=99?

  $ tree .
  .
  =E2=94=9C=E2=94=80=E2=94=80 mnt{inum}
  =E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 handle -> mnt:[{inum}]
  =E2=94=82=C2=A0=C2=A0 =E2=94=94=E2=94=80=E2=94=80 user -> ../user{inum}
  =E2=80=A6

but that's not a major revision.

> On Fri, Jul 08, 2016 at 07:35:33AM -0700, James Bottomley wrote:
> > On Fri, 2016-07-08 at 02:44 -0500, Eric W. Biederman wrote:
> > > Starting with 4.8 we are also going to need to be able to
> > > retrieve the user namespace owner of filesystems.  That will be
> > > an interesting mix.
> >
> > This is per mount point, isn't it? so it can't be in /proc/fs/ and
> > it would have to be per local mount tree.  Yes, that is a bit
> > nasty.  Sounds like we might need to unfold mount or mountinfo
> > into something that has one directory per entry?
>
> If we will be able to look up namespaces in nsfs by inum, we can
> print an userns inum in mountinfo.

With the tree view you can find a namespace by inum (if it's one of
your descendants), but it's not going to be particularly efficient
(you'll have to walk the tree).  Folks that need to do that quickly
can index the tree (which would be fairly straightforward if the nsfs
mount supports inotify), but it would be nice to have a more elegant
solution for this use-case.

Cheers,
Trevor

--=20
This email may be signed or encrypted with GnuPG (http://www.gnupg.org).
For more information, see http://en.wikipedia.org/wiki/Pretty_Good_Privacy

--/biO8xG9SRhq5SLW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJXgBIqAAoJEBBpoQVgXJg11ooQAMSEKjOgRrdyW/5mWQX9oi9h
L+esjLhougJEI5g0AAT3LeTKbW70tDoMPqLN3uz0JyAJmRG89o8tGku6IDAGlz9t
zTM3cHzeQo3fPwTeFMsbQ82lSL340KyFoJHA3nz+e4juFlNNeMQjDK6CkJXClvI0
VM+ZYI19tgQ8uiMTgg1kbM3o/TdwojwbrRFvRAfOOiYJ9JrTSf6Lnf09ErIcjI+6
tOAAza2iSzWlWDaxjO71YEyoaIp3Bk47fjcu5oyxgeO/Tnr2XkRrRd98a+5tTfYE
Cv4IqjaiyUQK0+FRH4cPvKHbbNaLSAZiZgmdMzK6piU14VdYcC1xaVOY8/7T8QZJ
6o90HdYpG6h8+RZY86opP6HCIrO0poLtG4lygUeaB6qMgCMkTKnro98LyXN1Vvzp
ME7DOmUe5/9T4AAFKbwUsJRaAufLdxMWw0k7bFAI8yOpo/wqsVuuOucriAd+KERx
LMaBi2q2YgAj3eTSmekAkrUhwaWDIDf3rWgkgGADLJutf1Kyj6GUcEv/Br+J6ax9
jU8D8cy7l6njNmkrjJcDGSVP8NMD8cCgxI+0M2hXhFTrJA7Vk772GCO8gM+lzkJ9
CBkbnEe1jGN6PubtcJ8ZWbEf73swpK7xgowIFqH5+ydxBdFWxyQ+XxTUvw42pUT2
IqgHWW1PraLhC8AZKTYb
=tz7X
-----END PGP SIGNATURE-----

--/biO8xG9SRhq5SLW--
