From: "W. Trevor King" <wking-vJI2gpByivqcqzYg7KEe8g@public.gmane.org>
Subject: Re: [CRIU] Introspecting userns relationships to other namespaces?
Date: Tue, 12 Jul 2016 20:59:26 -0700
Message-ID: <20160713035926.GJ4916@odin.tremily.us>
References: <1467988533.2322.118.camel@HansenPartnership.com>
	<20160708203818.GA2602@outlook.office365.com>
	<5e4cc802-f0e0-4f4c-a2f7-585aaaa8feec@email.android.com>
	<87wpkvpu1i.fsf@x220.int.ebiederm.org>
	<1468023332.2390.10.camel@HansenPartnership.com>
	<87bn27o6j5.fsf@x220.int.ebiederm.org>
	<20160709072627.GA7480@outlook.office365.com>
	<87eg72llu0.fsf@x220.int.ebiederm.org>
	<871t32ll6n.fsf@x220.int.ebiederm.org>
	<20160713000842.GC5818@outlook.office365.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2497779539552635832=="
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <20160713000842.GC5818-1ViLX0X+lBJGNQ1M2rI3KwRV3xvJKrda@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Andrew Vagin <avagin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: criu-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org


--===============2497779539552635832==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="s1QkCFPfJT0XII2l"
Content-Disposition: inline


--s1QkCFPfJT0XII2l
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 12, 2016 at 05:08:43PM -0700, Andrew Vagin wrote:
> Here is a patch to get an owning user namespace:
> https://github.com/avagin/linux-task-diag/commit/7fad8ff3fc4110bebf0920ce=
c2388390b3bd2238
> https://github.com/avagin/linux-task-diag/commit/2663bc803d324785e328261f=
3c07a0fef37d2088
>
> Here is an example how it looks from user-space:
> https://github.com/avagin/linux-task-diag/blob/namespaces/tools/testing/s=
elftests/nsfs/owner.c#L49

Overall this looks good to me (I left a handful of uninformed comments
inline ;).

It doesn't make it easy to walk leafward, but it doesn't look like the
kernel has a convenient way to list child namespaces either.
Something like /proc/<pid>/task/<tid>/children (with
CONFIG_PROC_CHILDREN) for namespaces would make it easier to get a
complete system overview (as far as your credentials and position in
the namespace hierarchies allow).  But looking at the
CONFIG_PROC_CHILDREN implementation doesn't make me all that excited
about mimicking it for namespaces ;).

You can still brute-force it in userspace by walking the root-most
procfs's you can find and peeking at all the /proc/<pid>/ns/=E2=80=A6 entri=
es
(but yuck ;).  With mount and other namespaces not being hierarchical,
the =E2=80=9Cleafword=E2=80=9D idea may not be all that useful anyway, but =
having a
more compact collection of mount namepaces (say) that you know about
would be nice.  Where =E2=80=9Cknow about=E2=80=9D should probably means =
=E2=80=9Cknow it
exists=E2=80=9D but not necessarily =E2=80=9Chave permission to enter=E2=80=
=9D.  Still,
getting that figured out can happen independently to this parent/owner
work.

Cheers,
Trevor

--=20
This email may be signed or encrypted with GnuPG (http://www.gnupg.org).
For more information, see http://en.wikipedia.org/wiki/Pretty_Good_Privacy

--s1QkCFPfJT0XII2l
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJXhbycAAoJEBBpoQVgXJg17l0QAKOHpMN/wh/oZl4c61p6wWbS
od1Ig3826aB1n6hWcQXlaSCJ50ZwC/dYf2T5CYCu9MYgMY3z+tNksbvW8MsjUvGs
RNY4NhIWNSJTng3f8c05lK9hRjQOodyBnvxiCkIfKT3zlksm3tdRKfKedZQ03+o+
h7Jn1BKM66hoRX3FHAnZjfJ5TvAozDNMsaigpZz68WypOPXgMb5M71aOkvuT+xD8
z9TDnFCW1I7znhWjijrN6pJd3o7nA/3Ae1aGRFSkm3fMLg+w0oQMen6HpesbRkV2
mvmH1RaUB4StEziwJdQV0U5QDOFA/VpBFPMBJZmfSQjLx1SyQnvJFsAp1QkH/TGl
T51iIKkGvHyjd1JTu69RHO8uO9ZQziKfFXOItTQctH+ichU3pZrkkNiT7j9r8eCJ
E7jk7Sd9XU6QFcEVmq2bKQTh0PstJolKJPWeBRxL2HHNxumNYNx2W+fyAY6VFvPb
rrWFuUKqnfi3WTRrQHDyH+201lPCtI8+ZrxQs6ESs3Whae48zXoyIqTBC41LYtJ1
ZMwUe9UOpWOL3VXhCotXaDush4sNuHsbwixsbzgcmTPYQxwN+OTAeGXGaq48g7y1
Vk/VWOgrgVEI5+WFkYGhbpxhez8JukdCt1TtBmZlCep6XNyytmTBWBclaECGRla2
CeMajiMGFxU9m5t8IafG
=qN6L
-----END PGP SIGNATURE-----

--s1QkCFPfJT0XII2l--

--===============2497779539552635832==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Containers mailing list
Containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
https://lists.linuxfoundation.org/mailman/listinfo/containers
--===============2497779539552635832==--
