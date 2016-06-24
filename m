From: Jann Horn <jann-XZ1E9jl8jIdeoWH0uzbU5w@public.gmane.org>
Subject: Re: Documenting ptrace access mode checking
Date: Fri, 24 Jun 2016 08:35:27 +0200
Message-ID: <20160624063527.GA786@pc.thejh.net>
References: <e335a243-2199-2185-c7b3-fb1c898e9ab4@gmail.com>
 <20160621205550.GA5191@pc.thejh.net>
 <86486234-d78a-234b-58bb-6ca646881dc6@gmail.com>
 <20160622224428.GA15902@pc.thejh.net>
 <33209000-3fd4-0b26-f249-eb4e1a9e1651@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7AUc2qLy4jB3hD7Z"
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <33209000-3fd4-0b26-f249-eb4e1a9e1651-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: James Morris <jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>, linux-man <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Stephen Smalley <sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, linux-security-module <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org


--7AUc2qLy4jB3hD7Z
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 23, 2016 at 09:42:09AM +0200, Michael Kerrisk (man-pages) wrote:
> Hi Jann,
>=20
> Thanks for your further review. Follow-up of one point below.
>=20
> On 06/23/2016 12:44 AM, Jann Horn wrote:
> >On Wed, Jun 22, 2016 at 09:21:29PM +0200, Michael Kerrisk (man-pages) wr=
ote:
> >>On 06/21/2016 10:55 PM, Jann Horn wrote:
> >>>On Tue, Jun 21, 2016 at 11:41:16AM +0200, Michael Kerrisk (man-pages) =
wrote:
>=20
> [...]
>=20
> >>>>      The  algorithm  employed for ptrace access mode checking deter=
=E2=80=90
> >>>>      mines whether the calling process is  allowed  to  perform  the
> >>>>      corresponding action on the target process, as follows:
> >>>>
> >>>>      1.  If the calling thread and the target thread are in the same
> >>>>          thread group, access is always allowed.
> >>>>
> >>>>      2.  If the access mode specifies PTRACE_MODE_FSCREDS, then  for
> >>>>          the  check in the next step, employ the caller's filesystem
> >>>>          user ID and group ID (see credentials(7));  otherwise  (the
> >>>>          access  mode  specifies  PTRACE_MODE_REALCREDS, so) use the
> >>>>          caller's real user ID and group ID.
> >>>
> >>>Might want to add a "for historical reasons" or so here.
> >>
> >>Can you be a little more precise about "here", and maybe tell me why
> >>you think it helps?
> >
> >I'm not sure, but it might be a good idea to add something like this at =
the
> >end of 2.:
> >"(Most other APIs that check one of the caller's UIDs use the effective =
one.
> >This API uses the real UID instead for historical reasons.)"
> >
> >In my opinion, it is inconsistent to use the real UID/GID here, the
> >effective one would be more appropriate. But since the existing code uses
> >the real UID/GID and that's not a security issue for existing users of
> >the ptrace API, this wasn't changed when I added the REALCREDS/FSCREDS
> >distinction.
> >
> >I think that for a reader, it might help to point out that in most cases,
> >when a process is the subject in an access check, its effective UID/GID
> >are used, and this is (together with kill()) an exception to that rule.
> >But you're the expert on writing documentation, if you think that that's
> >too much detail / confusing here, it probably is.
>=20
> Okay -- got it now, I think. I made this text:
>=20
>        2.  If the access mode specifies PTRACE_MODE_FSCREDS, then, for
>            the check in the next step, employ the caller's  filesystem
>            UID  and  GID.  (As noted in credentials(7), the filesystem
>            UID and GID almost always have the same values as the  cor=E2=
=80=90
>            responding effective IDs.)
>=20
>            Otherwise, the access mode specifies PTRACE_MODE_REALCREDS,
>            so use the caller's real UID and GID for the checks in  the
>            next  step.  (Most APIs that check the caller's UID and GID
>            use  the  effective  IDs.   For  historical  reasons,   the
>            PTRACE_MODE_REALCREDS check uses the real IDs instead.)

Thanks, that sounds good.

--7AUc2qLy4jB3hD7Z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXbNSvAAoJED4KNFJOeCOoorAP/iczL3I4q+8CaK6fWnmy8FGF
HhJdOz9ja2nd2oVdCh3a2cBbOVsvdcHVFtgvrx9tXLJ+ndkssb66+nvkUQa7hZTX
dzqqQ7DANaqM4uSxqSh4D4Cyn9DMrajHUEUZjJ/JVDKfWhi5iXbubQpd3RfQ+hvy
886x5O3jWW1EM2ONxfMXGR006/ucX6+VlKSBcOvhiqWkmpzR5E7/TrOECzDeLbgc
pDbnB45n+AV07q6zDZoZMEJDhXc33iTa3MYTb7UxsYtrlQOeSgn3LcLDENe/M5/t
i80Qfpw4lz7eBBg2O+F8QPXg3KYXJH6hNpUcsHbpbfZMjLINTPyLPSGloLSvKvE5
6uZrk8uqYjkdcLYCbtDB8IbH1yEqMCMCQuPW8WN1YY2UNO9o4WSGBNt8eerKix9E
XvQm9W2gjoz7NRCGHnygy0lP8QveAHh98bv/CTM2eWcmSBGyddy9xevHCBbvYwYP
FZU8TEjloSc5LBt9lzFDJw01+zhzD38uYXbnCWhpuc8NxSHFzHR5yuQQFqWHkyWj
cEjFV8XwCeU/RC8JiV8ZwJUwxIpOuAe/HpyAofZBQ8ou8IDycRcqOxmpT4eVjicw
NhAgjEoLGkkzCoXJTn0jtktEBFye4qWEsLHpO+1kLuKLdXiKMdLr7Nog26UPQqFh
vFacqzzXnGvDXIxUKGV8
=XNg9
-----END PGP SIGNATURE-----

--7AUc2qLy4jB3hD7Z--
--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
