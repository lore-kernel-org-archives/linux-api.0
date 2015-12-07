From: Jann Horn <jann-XZ1E9jl8jIdeoWH0uzbU5w@public.gmane.org>
Subject: Re: [PATCH] ptrace: use fsuid, fsgid, effective creds for fs access
 checks
Date: Mon, 7 Dec 2015 21:38:24 +0100
Message-ID: <20151207203824.GA27364@pc.thejh.net>
References: <20151109131902.db961a5fe7b7fcbeb14f72fc@linux-foundation.org>
 <1449367476-15673-1-git-send-email-jann@thejh.net>
 <CAGXu5jJKOnWWSuLO5zWZ9=7Nhv0hWvJ0wEVJ3n+URY7-q_BCJw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZGiS0Q5IWpPtfppv"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAGXu5jJKOnWWSuLO5zWZ9=7Nhv0hWvJ0wEVJ3n+URY7-q_BCJw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kees Cook <keescook-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "Serge E. Hallyn" <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux-MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, linux-security-module <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "security-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <security-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Willy Tarreau <w@1wt.eu>
List-Id: linux-api@vger.kernel.org


--ZGiS0Q5IWpPtfppv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 07, 2015 at 12:32:06PM -0800, Kees Cook wrote:
> On Sat, Dec 5, 2015 at 6:04 PM, Jann Horn <jann-XZ1E9jl8jIdeoWH0uzbU5w@public.gmane.org> wrote:
[...]
> > -       if (ptrace_may_access(task, PTRACE_MODE_READ)) {
> > +       if (ptrace_may_access(task, PTRACE_MODE_READ | PTRACE_MODE_FSCR=
EDS)) {
>=20
> This should maybe use the PTRACE_MODE_READ_FSCREDS macro?

Oh, yes. I don't know how I missed that. :/


> >                 error =3D ns_get_path(&ns_path, task, ns_ops);
> >                 if (!error)
> >                         nd_jump_link(&ns_path);
> > @@ -63,7 +63,7 @@ static int proc_ns_readlink(struct dentry *dentry, ch=
ar __user *buffer, int bufl
> >         if (!task)
> >                 return res;
> >
> > -       if (ptrace_may_access(task, PTRACE_MODE_READ)) {
> > +       if (ptrace_may_access(task, PTRACE_MODE_READ | PTRACE_MODE_FSCR=
EDS)) {
>=20
> same here?

Yes.
--ZGiS0Q5IWpPtfppv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJWZe5AAAoJED4KNFJOeCOocOIQAIPkjimgJ/9cn9hzTXLsNyNA
eDdTVMa/MRT4ySXOUlu7FeC+i/FVi+f7SneiX5MPczQDO6t3lbr4LmiT1dpQrzca
/uvP+y5bCvzAERBKuBUvKs3dBoonMrMzkGr4oYHjkLiWzzO0oWlQQpiE8It5KdY5
fHeqje5hXihSYKD7YqUavdjJFFU0khkiKr1M5jlO6cUB/OwEJ83G9BpeH2VY31mn
3feLpC1+w1FOozbCYww0LteIXKWyR8cTRPTRrKsvxlj3OaxrAJBQaU0AWkBtZjEr
yNHtagE1EBoiPjwcRwAMwWzGUlsUc3lHyq/r5xA8jYHOixM1O6zZ7izYWXlzRx7d
NCVg4OVLj1rAkgSlgzFS+dYtVse91+nLA+8vqasXbhtFlDIEA1pTqZ6k+L6y2qL9
Iu60QmrmQjLoZ3OQlQIqaf+rYwCLX835Vw4FlyhEKtAsAcWk2b3Wm0dfEOILlIBz
qkK1S8G9nOIPHzFLWEvi8HWmL5qVT6ArnB4yADcNhvTFpahEKpJCxUW4A/m7vYB2
ztwxH68iW2PJHLuBEng6qGyqtZa/IaNmVRd6Kax6mqR7KDoZiubP/FXP8AhDyb/2
6KpC4upUwZ8IByn6q8kkuZm+YjvVIv7Jqu8dhJ9Nfh+o0JWbClCmkwZR0O3SPnxF
PUq8xAWIX3hmbpOFcE82
=+R/c
-----END PGP SIGNATURE-----

--ZGiS0Q5IWpPtfppv--
