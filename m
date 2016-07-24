From: "W. Trevor King" <wking-vJI2gpByivqcqzYg7KEe8g@public.gmane.org>
Subject: Re: [PATCH 2/5] kernel: add a helper to get an owning user namespace
	for a namespace
Date: Sun, 24 Jul 2016 09:54:59 -0700
Message-ID: <20160724165459.GA5395@odin.tremily.us>
References: <CANaxB-xw_xBUq=0uT14ANv-jfg2NsGaPy=jyDO9=yF03_7toSw@mail.gmail.com>
	<1468548742-32136-1-git-send-email-avagin@openvz.org>
	<1468548742-32136-2-git-send-email-avagin@openvz.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7332441047114326608=="
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <1468548742-32136-2-git-send-email-avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
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


--===============7332441047114326608==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nFreZHaLTZJo0R7j"
Content-Disposition: inline


--nFreZHaLTZJo0R7j
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 14, 2016 at 07:12:19PM -0700, Andrey Vagin wrote:
> +struct ns_common *ns_get_owner(struct ns_common *ns)
> +{
> +	=E2=80=A6
> +	return &get_user_ns(user_ns)->ns;
> +}

Is there a reason to return the generic =E2=80=98struct ns_common *=E2=80=
=99 here
instead of =E2=80=98struct user_namespace *=E2=80=99?  The current use case=
 doesn't
need access to the additional information, but future ng_get_owner
callers might, and we know the returned namespace (if any) will be a
user namespace.

Cheers,
Trevor

--=20
This email may be signed or encrypted with GnuPG (http://www.gnupg.org).
For more information, see http://en.wikipedia.org/wiki/Pretty_Good_Privacy

--nFreZHaLTZJo0R7j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJXlPLgAAoJEBBpoQVgXJg1Y+YQAL53v01sQLz6ZMYNO3EU7QH0
Qdlqm6Pnm1i24HaSIbfLdJwcgMGYZ+Xll2QdkzAtF7R21oCt9nW0qqQ/LTx+opwK
TNURnCw2wTcwEJSVaKm9cn9Amiu3GNxSYpGMB04VWA9eQYhXwlfdBLH3fBdP1/Gv
Nad9n03/n2UOkKp4YSlWYT8BKb5GMAL05P0Ovkfh2KodEEN2xV0b6JmCq25fN5Jz
WF4ynuMjoR7PaGzJPA2fKeiSNJAnOanNFuu8mhEkf6EpHgo17MQRDK4uYKpisJTt
q075IpUFnlacrAwPpvy3TYWZjvsd0NxQFFdrr1/dx1+yJNEOB8zwCwrfu7Zz9D0O
d4fveKTZF41JJcwHeJ0g8bt4TTdG9E0TBxAZS3mGcxC9/+kycXlqWF9si1z2ZSpL
7SyyjV9p2Su/1iG/GpHlGJXr+2/6xnfOySSyrwt/a2oLVb+Go99V1fLwHSESmtiV
RfKt4yYqL0lEJJ76OC2b/UwXh3SBhcZOHf2oAQj5G7KN3Kjmp0oXYTKmzQzzNYTt
DmenCSravlhiRIRnzspC1p6M4+7pkGwglcLuLzVynvFp3F/fX8NB/zf0xOc1BZEn
60fi38m6UJHDYy7FPtGEbf9EBFAi/Q+hPwd3ew1/+WBrueb0ziMD2UAfarKfV+j5
/0xOtmRqhQVkSIqpq7qr
=ZWqH
-----END PGP SIGNATURE-----

--nFreZHaLTZJo0R7j--

--===============7332441047114326608==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Containers mailing list
Containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
https://lists.linuxfoundation.org/mailman/listinfo/containers
--===============7332441047114326608==--
