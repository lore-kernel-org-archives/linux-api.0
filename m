From: Jann Horn <jann@thejh.net>
Subject: Re: [PATCH] seccomp: add ptrace commands for suspend/resume
Date: Tue, 2 Jun 2015 21:24:50 +0200
Message-ID: <20150602192450.GA14907@pc.thejh.net>
References: <1433186918-9626-1-git-send-email-tycho.andersen@canonical.com>
 <20150602182829.GA23449@redhat.com>
 <556DFDB2.3050205@parallels.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GvXjxJ+pjyke8COw"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <556DFDB2.3050205@parallels.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Pavel Emelyanov <xemul@parallels.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Tycho Andersen <tycho.andersen@canonical.com>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@amacapital.net>, Will Drewry <wad@chromium.org>, Roland McGrath <roland@hack.frob.com>, "Serge E. Hallyn" <serge.hallyn@ubuntu.com>
List-Id: linux-api@vger.kernel.org


--GvXjxJ+pjyke8COw
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 02, 2015 at 10:02:10PM +0300, Pavel Emelyanov wrote:
>=20
> >> +int suspend_seccomp(struct task_struct *task)
> >> +{
> >> +	int ret =3D -EACCES;
> >> +
> >> +	spin_lock_irq(&task->sighand->siglock);
> >> +
> >> +	if (!capable(CAP_SYS_ADMIN))
> >> +		goto out;
> >=20
> > I am puzzled ;) Why do we need ->siglock? And even if we need it, why
> > we can't check CAP_SYS_ADMIN lockless?
> >=20
> > And I am not sure I understand why do we need the additional security
> > check, but I leave this to you and Andy.
> >=20
> > If you have the rights to trace this task, then you can do anything
> > the tracee could do without the filtering.
>=20
> I think _this_ check is required, otherwise the seccomp-ed task (in
> filtered mode) fork-s a child, then this child ptrace-attach to parent
> (allowed) then suspend its seccomd. And -- we have unpriviledged process=
=20
> de-seccomped.

If you can ptrace(), you can already escape from seccomp. See this
section in man 2 seccomp, in the SECCOMP_RET_TRACE section:

              The seccomp check will not be run again after the tracer is
              notified.  (This means that seccomp-based sandboxes must not
              allow use of ptrace(2)=E2=80=94even of other sandboxed proces=
ses=E2=80=94
              without extreme care; ptracers can use this mechanism to
              escape from the seccomp sandbox.)

(But I think there have been discussions about changing that behavior in
the future?)

--GvXjxJ+pjyke8COw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJVbgMCAAoJED4KNFJOeCOoB60P/if9eXOJ6Cg1rRQJanS0+oLE
P1a0pS+TChhRMUJBd8dD4UTNbqFG1+Y6ovARpuzzttXh/BIEEPeENVrWYTCes3TZ
p57BjT/J0cA22ey4N10TMeUEcc0zZisOHjMf2swQgWGhKgbDxkWoMMjsj8HdUaOL
DdTp/5OkfrvPSLulFmn/UCe+Orv00aq4oObLiV8k0OtyH4EiKOd0hYgUjxHcPK8O
epJOimMEp1u5kNUEChNxGI713RlsIhWaJyyrPZZZadZ2LxP4h/BBKvtxzhoGlYTW
smybdCrYAlXSBhqJZe1Hi3UKUA+t8I2wOIV73u3czkoDwnfUMzIspwFUz58/jCnx
DWVFa5X0iTi702+aIua83P/Y2JvAVguKx+NlIv2xcjGDiUjO+hxL3rTUpbGOmqRs
5vloW7KItGbXkEld009P/PBe3/lBsX357ACiomHR8P4LYPwKnDbeeENFB3S/3xOu
Z8JAdGe4eV9Lsref7juzjpDw8Jl8xp/NwMaGidBWEfm3olZ0jWf8rkpcrhKmNF0c
casoz3kzyQ3GxY61KSA5D5TIqshIF4nQc1tNpYCKtL5ik+Vic6FZmHWVCXlTPHxl
toBHjHwjmG/FYFOK93ygYtBtoCBoc4aoF/MfGMV+zWSQjWfePgEp9bB1nDqISCAl
LN6veSN9Xha5vuydmBl1
=J3kN
-----END PGP SIGNATURE-----

--GvXjxJ+pjyke8COw--
