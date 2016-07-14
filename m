From: "W. Trevor King" <wking-vJI2gpByivqcqzYg7KEe8g@public.gmane.org>
Subject: Re: [PATCH 2/5] kernel: add a helper to get an owning user namespace
	for a namespace
Date: Thu, 14 Jul 2016 12:07:42 -0700
Message-ID: <20160714190742.GA24913@odin.tremily.us>
References: <1468520419-28220-1-git-send-email-avagin@openvz.org>
	<1468520419-28220-3-git-send-email-avagin@openvz.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============9173048978471368832=="
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <1468520419-28220-3-git-send-email-avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
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
Cc: criu-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org


--===============9173048978471368832==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0F1p//8PRICkK4MW"
Content-Disposition: inline


--0F1p//8PRICkK4MW
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 14, 2016 at 11:20:16AM -0700, Andrey Vagin wrote:
> +struct ns_common *ns_get_owner(struct ns_common *ns)
> +{
> +	const struct cred *cred =3D current_cred();
> +	struct user_namespace *user_ns, *p;
> +
> +	user_ns =3D p =3D ns->user_ns;
> +	if (user_ns =3D=3D NULL) { /* ns is init_user_ns */
> +		/* Unprivileged user should not know that it's init_user_ns. */
> +		if (capable(CAP_SYS_ADMIN))
> +			return ERR_PTR(-ENOENT);
> +		return ERR_PTR(-EPERM);
> +	}
> +
> +	for (;;) {
> +		if (p =3D=3D cred->user_ns)
> +			break;
> +		if (p =3D=3D &init_user_ns)
> +			return ERR_PTR(-EPERM);
> +		p =3D p->parent;
> +	}
> +
> +	return &get_user_ns(user_ns)->ns;
> +}

I'm still not sure we need the CAP_SYS_ADMIN check [1].  Maybe =E2=80=9Cyou
have an open file descriptor for the namespace=E2=80=9D means you've already
been authorized to access the parent information (e.g. via POSIX
permissions on /proc/<pid>/ns/=E2=80=A6 or the bind-mounted namespace).
Whether you can get the parent information probably depends whether
you can use setns to join the parent namespace (I haven't looked up
the backing code for that).

But whichever way we go there, I think we do want to be consistent
between init_user_ns and other namespaces.  So we should have a
CAP_SYS_ADMIN check for init_user_ns if and only if we also have a
CAP_SYS_ADMIN check for the returned parent in the non-init_user_ns
case as well:

  user_ns =3D p =3D ns->user_ns;
  if (user_ns =3D=3D NULL) { /* ns is init_user_ns */
    /* Unprivileged user should not know that it's init_user_ns. */
    if (capable(CAP_SYS_ADMIN))
      return ERR_PTR(-ENOENT);
     return ERR_PTR(-EPERM);
  } else if (! capable_in(user_ns, CAP_SYS_ADMIN)) {
    /* Unprivileged user should not know about the owning user ns. */
    return ERR_PTR(-ENOENT);
  }

Although I'm not sure what the real name for capable_in is, or even if
it exists.

Cheers,
Trevor

[1]: https://github.com/avagin/linux-task-diag/commit/2663bc803d324785e3282=
61f3c07a0fef37d2088#commitcomment-18223327

--=20
This email may be signed or encrypted with GnuPG (http://www.gnupg.org).
For more information, see http://en.wikipedia.org/wiki/Pretty_Good_Privacy

--0F1p//8PRICkK4MW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJXh+L9AAoJEBBpoQVgXJg1WAQP/3zGzSbt3KtNcjY0VzJjWx6B
zRUoohunKTRl4SLBr5I+cJdMZn1UPqeJC9V9k1uekAJfaM4cSPSEJ1TKPcjiIyu2
iJrRRIiq6JE735pQMzCYM5iMuMT0oBcdLzxiuL8qcDPY8uxYTHTDdLxvHMfB2/IM
YomjJqequ/Hr8wBXM9WCpwgrc/MnSmHpIqgVXJWPKSdD+UCXoRH6vOdruKx1msWB
tJw+zjMYfFY9Uxbe6lduR/hwAPXPRvsxk3FHQlK+E2pmFegTXX9pK7fRnPnLmTdc
u+GycDEZD+Gw1va28Na49VKxLBTXQVbKzQSBPL3Gf/nVzXZD7YuubiIUp5mreQIM
6fz+LOql3Mt6Hez/ZfSrPys4FLobuE71KFHyB+hDbwlMHxA6bxv9R9mbyUXWBkHA
r2nUczB1pHg7/v1S77ZrQjiViSgfYkEc4WsFcGa5d84aW4R7WGQKfifu6DwE+MNz
SuPgtFRlxsMjDkHspNTVT8sNXr+5J1MTJEd8L95nvRH/R5ZUVjLbzoarCS62GqG8
qf45B8Z/56DNRDOBuEhdXRLZqbXc4hKRwlYv30Pk+1cYY5O9bRmYsakvdJXTueIY
fxQ5gAfmcV3StwKDOq5NAX2SMJdgDmnX8eRF+rUm0ERafZPlQ5+TQ7w60pU9U5Mn
rppYaIy0ePnMwEaPvJ4T
=3AMb
-----END PGP SIGNATURE-----

--0F1p//8PRICkK4MW--

--===============9173048978471368832==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Containers mailing list
Containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
https://lists.linuxfoundation.org/mailman/listinfo/containers
--===============9173048978471368832==--
