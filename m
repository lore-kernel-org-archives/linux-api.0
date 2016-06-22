From: Jann Horn <jann@thejh.net>
Subject: Re: Documenting ptrace access mode checking
Date: Thu, 23 Jun 2016 00:44:28 +0200
Message-ID: <20160622224428.GA15902@pc.thejh.net>
References: <e335a243-2199-2185-c7b3-fb1c898e9ab4@gmail.com>
 <20160621205550.GA5191@pc.thejh.net>
 <86486234-d78a-234b-58bb-6ca646881dc6@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NzB8fVQJ5HfG6fxh"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <86486234-d78a-234b-58bb-6ca646881dc6@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: James Morris <jmorris@namei.org>, linux-man <linux-man@vger.kernel.org>, Stephen Smalley <sds@tycho.nsa.gov>, lkml <linux-kernel@vger.kernel.org>, Kees Cook <keescook@chromium.org>, "Eric W. Biederman" <ebiederm@xmission.com>, linux-security-module <linux-security-module@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org


--NzB8fVQJ5HfG6fxh
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 22, 2016 at 09:21:29PM +0200, Michael Kerrisk (man-pages) wrote:
> On 06/21/2016 10:55 PM, Jann Horn wrote:
> >On Tue, Jun 21, 2016 at 11:41:16AM +0200, Michael Kerrisk (man-pages) wr=
ote:
> >>Here's the new ptrace(2) text. Any comments, technical or terminological
> >>fixes, other improvements, etc. are welcome.
> >
> >As others have said, I'm surprised about seeing documentation about
> >kernel-internal constants in manpages - but I think it might be a good
> >thing to have there, given that people who look at ptrace(2) are likely
> >to be interested in low-level details.
>=20
> I agree that it is a little surprising to add kernel-internal
> constants in a man page. (There are precedents, but they are few.)
> But see my reply to Kees. It's more than just explaining low level
> details: there are various kinds of user-space behavior differences
> (real vs filesystem credentials; permitted vs effective capabilities)
> produced by the ptrace_may_access() checks, and those behaviors need
> to be described and *somehow* labeled for cross-referencing from
> other man pages.

Makes sense.


> >>       The  algorithm  employed for ptrace access mode checking deter=
=E2=80=90
> >>       mines whether the calling process is  allowed  to  perform  the
> >>       corresponding action on the target process, as follows:
> >>
> >>       1.  If the calling thread and the target thread are in the same
> >>           thread group, access is always allowed.
> >>
> >>       2.  If the access mode specifies PTRACE_MODE_FSCREDS, then  for
> >>           the  check in the next step, employ the caller's filesystem
> >>           user ID and group ID (see credentials(7));  otherwise  (the
> >>           access  mode  specifies  PTRACE_MODE_REALCREDS, so) use the
> >>           caller's real user ID and group ID.
> >
> >Might want to add a "for historical reasons" or so here.
>=20
> Can you be a little more precise about "here", and maybe tell me why
> you think it helps?

I'm not sure, but it might be a good idea to add something like this at the
end of 2.:
"(Most other APIs that check one of the caller's UIDs use the effective one.
This API uses the real UID instead for historical reasons.)"

In my opinion, it is inconsistent to use the real UID/GID here, the
effective one would be more appropriate. But since the existing code uses
the real UID/GID and that's not a security issue for existing users of
the ptrace API, this wasn't changed when I added the REALCREDS/FSCREDS
distinction.

I think that for a reader, it might help to point out that in most cases,
when a process is the subject in an access check, its effective UID/GID
are used, and this is (together with kill()) an exception to that rule.
But you're the expert on writing documentation, if you think that that's
too much detail / confusing here, it probably is.


> I changed this text to:
>=20
>        Various parts of the kernel-user-space API (not just  ptrace(2)
>        operations), require so-called "ptrace access mode permissions"
>        which are gated by any enabled Linux Security Module (LSMs)=E2=80=
=94for
>        example,  SELinux,  Yama, or Smack=E2=80=94and by the the commonca=
p LSM
>        (which is always invoked).  Prior to  Linux  2.6.27,  all  such
>        checks  were  of a single type.  Since Linux 2.6.27, two access
>        mode levels are distinguished:

Sounds good to me.

--NzB8fVQJ5HfG6fxh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXaxTMAAoJED4KNFJOeCOoTrcQAMS2slVcv5KN01ydzJbs6K0X
p80LFkl3+PvtTvbWY60H4KiPGRZMjTqSAe/Be4gxP0d4MuSxNced7y1f/xVXteZb
x+X44yCOr/DBxc8MITFi1lmnxsd77mwNlQwT4NpQx5iTWD3klI/JtXEr2XhDfNgF
+4dsKNTulW/wBYpvoHcSZ8OfEMxR7HCPV8KXSoTKuSnvlp2oWbADHYIK6XNhZNb3
n08oMVEfAkSAd+L98QGvkdxXKbEHqS3+eyRzqs99DGdouQGDzNl3Zc0nFktIZuts
oLg9wJNXX3L9fuhz83ntiNr/cw8Qx/hES90fo8sd+Z8otpxiHh2UR8TSvEUgHppU
Yx91rh2yLmkGrtFz3BxvvCb9g4+Miwt3amW2ua3l6w7J52FUkQyupD2hp3hCVahb
eB1VKSutoFngo2TTw0ejnz54m1N3RhkHagbsXndf582wcNcKAnoEQjewPP7KNI3U
dw+egoecx+WU8hi8LvCdS2Z5EYJHmUHtSJXzK78rcUzoXylOHIEJCdUtD43Pgo5W
TBv0qi9anqBzsRBZ0slkpqR1M/XjGroWj5AehKmogsIOv6scTZSYQ5/gjLU/Lt6r
lj+O7GWMN8HQvaBgxGii83swnjqvgdtljXPF3+vY6qdZycUnctdZTob2/oOs8eC3
l/tGfkeR3U1HO5ApJMnN
=nx9P
-----END PGP SIGNATURE-----

--NzB8fVQJ5HfG6fxh--
