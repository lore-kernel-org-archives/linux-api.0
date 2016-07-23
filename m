From: "W. Trevor King" <wking-vJI2gpByivqcqzYg7KEe8g@public.gmane.org>
Subject: Re: [PATCH 0/5 RFC] Add an interface to discover relationships
	between namespaces
Date: Sat, 23 Jul 2016 14:14:14 -0700
Message-ID: <20160723211414.GA25371@odin.tremily.us>
References: <1468520419-28220-1-git-send-email-avagin@openvz.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============5064082906048782473=="
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <1468520419-28220-1-git-send-email-avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Cc: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, criu-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org


--===============5064082906048782473==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WIyZ46R2i8wDzkSu"
Content-Disposition: inline


--WIyZ46R2i8wDzkSu
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 14, 2016 at 11:20:14AM -0700, Andrey Vagin wrote:
> Pid and user namepaces are hierarchical. There is no way to discover
> parent-child relationships too.

It bothers me that network namespaces are not hierarchical too ;).
namespaces(7) and clone(2) both have:

  When a network namespace is freed (i.e., when the last process in
  the namespace terminates), its physical network devices are moved
  back to the initial network namespace (not to the parent of the
  process).

So the initial network namespace (the head of net_namespace_list?) is
special [1].  To understand how physical network devices will be
handled, it seems like we want to treat network devices as a depth-1
tree, with all non-initial net namespaces as children of the initial
net namespace.  Can we extend this series' NS_GET_PARENT to return:

* EPERM for an unprivileged caller (like this series currently does
  for PID namespaces),
* ENOENT when called on net_namespace_list, and
* net_namespace_list when called on any other net namespace.

If that sounds reasonable, I'm happy to stumble my way through a patch
;).

And one benefit of the net_namespace_list approach is that it will be
really easy to walk children if we ever add a parent =E2=86=92 children loo=
kup
service to mirror this series' child =E2=86=92 parent service.

Cheers,
Trevor

[1]: The commit message for 2b035b39 (net: Batch network namespace
  destruction, 2009-11-29) opens with:

    It is fairly common to kill several network namespaces at once.
    Either because they are nested one inside the other or=E2=80=A6

  which I'm having trouble understanding if network namespaces aren't
  hierarchical (and they don't seem to be, except for the initial
  network namespace being special).  Maybe nested network namespaces
  were on the table at one point but never materialized?

  net->list looks like a reference to that namespace's entry in
  net_namespace_list, and I didn't see anything else that looked like
  a reference to a parent or list of children.

--=20
This email may be signed or encrypted with GnuPG (http://www.gnupg.org).
For more information, see http://en.wikipedia.org/wiki/Pretty_Good_Privacy

--WIyZ46R2i8wDzkSu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJXk94kAAoJEBBpoQVgXJg1pbcQAMp0lXyvbbCEhM4maGOG9tTr
c86VjfblWzgs05NDL+NLZfthIlFo+J2/TSDn68HSkmr5MGlW9VvRyJEgQtuD1+Cg
7ji8rWO3GK4LNeCLYUVx57o1cKDwQC34FQSbXXwCYCcz1D+JN4cqp/05kfGtNG59
ue8yzxkXyl+NGzjnfW6SxqH1lxoueYUJHd9RSo+lIQYDwi6+/OMOjSRHLbMiREX/
lVi1t6n7pqaDcHX/YX1OqQCydHsVkerEsWwqxEDpXd2ghD487irk9Cn/IKezI9U7
d4JKP9oBPavUMW38CWEWhYn6uxmBtd5WAf6QBeFDvA23QrT1g+lrC0DkZJlHR3ml
cnLf4ONNC+PXxImHPMkKAUPtJPTQb5FmDuBTctel2tLcsOTftqOkxfouVyV6W/Yn
oCdWM9EHYDl+Y/YBVJIST+LWP41B4JiKo4sGb456M8wqIlCx5blJ8VktqRFfPjeX
lzvi0R4FvURyxB2zW5g5TN057s9bDFapyEqXfF5VvEN4SA4Wb5n/dvyT5sVElHuv
CM7Eb/NpQkQVWSZfuRbRoxyeNAb2Miwzrf3t7BbLruML1wwaGR0m9Z9zC8GQPLZz
hocKaR5QGzAFP94cO4RL/YrKjm+rp3jewHKX/550NkXLhihhH5EMN3y3lzmKVLqR
zRaJKHu2d4BCjCwZGlW0
=C77c
-----END PGP SIGNATURE-----

--WIyZ46R2i8wDzkSu--

--===============5064082906048782473==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Containers mailing list
Containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
https://lists.linuxfoundation.org/mailman/listinfo/containers
--===============5064082906048782473==--
