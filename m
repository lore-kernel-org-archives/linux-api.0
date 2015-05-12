From: NeilBrown <neilb-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH RFC] vfs: add a O_NOMTIME flag
Date: Wed, 13 May 2015 08:39:51 +1000
Message-ID: <20150513083951.5eb63bc0@notabene.brown>
References: <CAHQdGtQjMHA8rVPkggB2zMz=k3O667+APH_1EY_2FtYmHL7-hw@mail.gmail.com>
	<20150508221325.GM4327@dastard>
	<alpine.DEB.2.00.1505081517470.28239@cobra.newdream.net>
	<CAHQdGtTFTN2XuvmarFZ9HPQV=cuhh7FosdHSrJME_U4htr=i8w@mail.gmail.com>
	<20150511144719.GA14088@thunk.org>
	<alpine.DEB.2.00.1505110920520.28239@cobra.newdream.net>
	<20150511231021.GC14088@thunk.org>
	<20150512050821.GA9404@chicago.guarana.org>
	<5551E7EB.8040301@gmail.com>
	<21842.1555.38099.868100@quad.stoffel.home>
	<20150512143637.GA6370@fieldses.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/0D4m/+CtwMSsg1VoXjsHSm+"; protocol="application/pgp-signature"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150512143637.GA6370-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Cc: John Stoffel <john-HgN6juyGXH5AfugRpC6u6w@public.gmane.org>, Austin S Hemmelgarn <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Kevin Easton <kevin-RFfraI6bZkdAfugRpC6u6w@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Sage Weil <sage-BnTBU8nroG7k1uMJSBkQmQ@public.gmane.org>, Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, Zach Brown <zab-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Linux FS-devel Mailing List <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API Mailing List <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

--Sig_/0D4m/+CtwMSsg1VoXjsHSm+
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 12 May 2015 10:36:37 -0400 bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org (J. Bruce Fields)
wrote:

> On Tue, May 12, 2015 at 09:54:27AM -0400, John Stoffel wrote:
> > >>>>> "Austin" =3D=3D Austin S Hemmelgarn <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> writes:
> >=20
> > Austin> On 2015-05-12 01:08, Kevin Easton wrote:
> > >> On Mon, May 11, 2015 at 07:10:21PM -0400, Theodore Ts'o wrote:
> > >>> On Mon, May 11, 2015 at 09:24:09AM -0700, Sage Weil wrote:
> > >>>>> Let me re-ask the question that I asked last week (and was appare=
ntly
> > >>>>> ignored).  Why not trying to use the lazytime feature instead of
> > >>>>> pointing a head straight at the application's --- and system
> > >>>>> administrators' --- heads?
> > >>>>=20
> > >>>> Sorry Ted, I thought I responded already.
> > >>>>=20
> > >>>> The goal is to avoid inode writeout entirely when we can, and
> > >>>> as I understand it lazytime will still force writeout before the i=
node
> > >>>> is dropped from the cache.  In systems like Ceph in particular, the
> > >>>> IOs can be spread across lots of files, so simply deferring writeo=
ut
> > >>>> doesn't always help.
> > >>>=20
> > >>> Sure, but it would reduce the writeout by orders of magnitude.  I c=
an
> > >>> understand if you want to reduce it further, but it might be good
> > >>> enough for your purposes.
> > >>>=20
> > >>> I considered doing the equivalent of O_NOMTIME for our purposes at
> > >>> $WORK, and our use case is actually not that different from Ceph's
> > >>> (i.e., using a local disk file system to support a cluster file
> > >>> system), and lazytime was (a) something I figured was something I
> > >>> could upstream in good conscience, and (b) was more than good enough
> > >>> for us.
> > >>=20
> > >> A safer alternative might be a chattr file attribute that if set, the
> > >> mtime is not updated on writes, and stat() on the file always shows =
the
> > >> mtime as "right now".  At least that way, the file won't accidentally
> > >> get left out of backups that rely on the mtime.
> > >>=20
> > >> (If the file attribute is unset, you immediately update the mtime th=
en
> > >> too, and from then on the file is back to normal).
> > >>=20
> >=20
> > Austin> I like this even better than the flag suggestion, it provides
> > Austin> better control, means that you don't need to update
> > Austin> applications to get the benefits, and prevents backup software
> > Austin> from breaking (although backups would be bigger).
> >=20
> > Me too, it fails in a safer mode, where you do more work on backups
> > than strictly needed.  I'm still against this as a mount option
> > though, way way way too many bullets in the foot gun.  And as someone
> > else said, once you mount with O_NOMTIME, then unmount, then mount
> > again without O_NOMTIME, you've lost information.  Not good. =20
>=20
> That was me.  Zach also pointed out to me that'd mean figuring out where
> to store that information on-disk for every filesystem you care about.
> I like the idea of something persistent, but maybe it's more trouble
> than it's worth--I honestly don't know.
>=20

When this persistent flag is in effect, the values stored in mtime and atim=
e,
and probably ctime, become irrelevant.  Surely we can choose some magic val=
ue
to store there that would never happen in practice.

e.g. ctime is signed and so goes back to 1902 (is that right?).  As ctime
cannot be set (via POSIX) to anything but "now", and as there were no Unix
systems in 1902, such values are impossible.

So a specific large negative value in ctime could safely be take to mean
"don't update time stamps, and always report them as 'now'".

Or do we need to keep ctime 'real'?


BTW When you "swap" to a file the mtime doesn't get updated.  No one seems =
to
complain about that.  I guess it is a rather narrow use-case though.


NeilBrown

--Sig_/0D4m/+CtwMSsg1VoXjsHSm+
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVVKBODnsnt1WYoG5AQL3XA//Uy9AuNd7KYX5oaywU34WxRaJnG1c8fGK
hdelglpuBdMJbu9+DpZqD6Vy6SLCbjn1qb+CM5eqS2nCk3f4wlyQT2Go5JIdrRhu
GbI0L5ZZ+PQCFwDeywRen8sRtuVpOOujtC8hLc4XTmgBOEX4Xzj/XNUAVwB1d4na
p3TYA2Gu7llhTDFjTf5a90LAog41lWMhxZQlhyGRVQWA4oiZ39NY7kGEZm2ci4pj
fNzkTmvRiNUmnbTN0LUhNdX9vLRzK/QpKyCGE1hbkRrewNUVmh/IDAptjQUeHiLz
8LQ9fgWmOWXLX0CC6dZ+e66yNeIejQtSrhqOfaVMSxqdUpUO9FYgerr1TAZ9TGFx
oi8QjjlKcN/Irb4vVjBYjAXRliV8t+TujViSBdNl6NcqMNm5sHr55isiYXZlLGSR
8jhoKbNn27j+KpdHlz9LquUmqgto8S9AYURmlIKrKWIL+wccRkPusb91EId9quRT
1Ma9dR/y75i5NSkWECjHoBZvt5PwM681027f3utgHs+N3L54KiKblDqHYpuPUWg8
LlmVjHS8LfhEIMSCt+iXhACQsf3anXcRV7sXRWJUVmQITDnAujYNNNn+PFbAtbzG
dbOGvYwABxhnpORU7dT2PhRaXp1beRMIl9TZeNqCn3gtC6kKOthmsAFdJR1xVAQ1
e5+spLOQMNs=
=Fbg6
-----END PGP SIGNATURE-----

--Sig_/0D4m/+CtwMSsg1VoXjsHSm+--
