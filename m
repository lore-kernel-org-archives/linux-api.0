From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Subject: Re: [RFC v1 00/17] seccomp-object: From attack surface reduction to
 sandboxing
Date: Fri, 29 Apr 2016 01:45:25 +0200
Message-ID: <5722A095.1080809@digikod.net>
References: <1458784008-16277-1-git-send-email-mic@digikod.net>
 <CAGXu5jK1U12vMk11HD_x_gNz3Rk4ZgEfdThY7DHvm4e4sPRh4g@mail.gmail.com>
Reply-To: kernel-hardening@lists.openwall.com
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="w4El8v5Rg2X5auNU5egn0mTehISP0VxKG"
Return-path: <kernel-hardening-return-3122-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <CAGXu5jK1U12vMk11HD_x_gNz3Rk4ZgEfdThY7DHvm4e4sPRh4g@mail.gmail.com>
To: Kees Cook <keescook@chromium.org>
Cc: linux-security-module <linux-security-module@vger.kernel.org>, Andreas Gruenbacher <agruenba@redhat.com>, Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Casey Schaufler <casey@schaufler-ca.com>, Daniel Borkmann <daniel@iogearbox.net>, David Drysdale <drysdale@google.com>, Eric Paris <eparis@redhat.com>, James Morris <james.l.morris@oracle.com>, Julien Tinnes <jln@google.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Paul Moore <pmoore@redhat.com>, "Serge E . Hallyn" <serge@hallyn.com>, Stephen Smalley <sds@tycho.nsa.gov>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Will Drewry <wad@chromium.org>, Linux API <linux-api@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-Id: linux-api@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--w4El8v5Rg2X5auNU5egn0mTehISP0VxKG
Content-Type: multipart/mixed; boundary="N0cl99CR830R5vkNpgHGq2Gw1dqs2jqRu"
From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
To: Kees Cook <keescook@chromium.org>
Cc: linux-security-module <linux-security-module@vger.kernel.org>,
 Andreas Gruenbacher <agruenba@redhat.com>, Andy Lutomirski
 <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
 Casey Schaufler <casey@schaufler-ca.com>,
 Daniel Borkmann <daniel@iogearbox.net>, David Drysdale
 <drysdale@google.com>, Eric Paris <eparis@redhat.com>,
 James Morris <james.l.morris@oracle.com>, Julien Tinnes <jln@google.com>,
 Michael Kerrisk <mtk.manpages@gmail.com>, Paul Moore <pmoore@redhat.com>,
 "Serge E . Hallyn" <serge@hallyn.com>, Stephen Smalley <sds@tycho.nsa.gov>,
 Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
 Will Drewry <wad@chromium.org>, Linux API <linux-api@vger.kernel.org>,
 "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
Message-ID: <5722A095.1080809@digikod.net>
Subject: Re: [RFC v1 00/17] seccomp-object: From attack surface reduction to
 sandboxing
References: <1458784008-16277-1-git-send-email-mic@digikod.net>
 <CAGXu5jK1U12vMk11HD_x_gNz3Rk4ZgEfdThY7DHvm4e4sPRh4g@mail.gmail.com>
In-Reply-To: <CAGXu5jK1U12vMk11HD_x_gNz3Rk4ZgEfdThY7DHvm4e4sPRh4g@mail.gmail.com>

--N0cl99CR830R5vkNpgHGq2Gw1dqs2jqRu
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Thanks for the comments. Here are mine:

On 28/04/2016 04:36, Kees Cook wrote:
> Okay, I've read through this whole series now (sorry for the huge
> delay). I think that it is overly complex for what it results in
> providing. Here are some background thoughts I had:

It may be a bit complex but my goal was to create a generic framework eas=
ily extensible in the future.

>=20
> 1) People have asked for "dereferenced argument inspection" (I will
> call this DAI...), in that they would like to be able to process
> arguments like how BPF traditionally processes packets. This series
> doesn't provide that. Rather, it provides static checks against
> specific arguments types (currently just path checks).

The thing is, a network packet can be filtered based on some basic type c=
hecks (e.g. integer, bit fields, enum) but it seems really complex to be =
able to check for stuff like file path (without even thinking about a BPF=
 regex engine :).
However, the approach taken in this series is to allow complex checks bas=
ed on a path *object* which could not be directly possible by inspecting =
the argument. Indeed, the kernel can expose more information than just a =
(user-controlled) string: parent directory, inode, device, mount point=E2=
=80=A6

I think that the need is not to be able to (directly) dereference syscall=
 arguments but to be able to evaluate arguments.

Moreover, exposing raw arguments in the seccomp_data struct can be tricky=
 because of possible multiple pointer indirections.

Last but not least, giving the ability to a BPF to interpret syscall argu=
ments can lead to inconsistent evaluation (incorrect mirroring of the OS =
code and state, cf. http://www.isoc.org/isoc/conferences/ndss/03/proceedi=
ngs/papers/11.pdf).

However, another approach could be to expose a high-level (canonicalized =
path, inode values=E2=80=A6) object in the seccomp_data struct but this s=
eems more complex and less flexible. How to store path reference object? =
How to check path hierarchy?

>=20
> 2) When I dig into the requirements people have around DAI, it's
> mostly about checking path names. There is some interest in some of
> the network structures, but mostly it's path names. This series
> certainly underscores this since your first example is path names. :)

Indeed. The same approach could be used to filter arguments as socket.

>=20
> 3) Solving ToCToU should also solve performance problems. For example,
> this series, on a successful syscall, will look up a pathname twice
> (once in seccomp, then again in the syscall, and then compares the
> results in the LSM as a ToCToU back-stop). This seems like a waste of
> effort, since this reimplements the work the kernel is already doing
> to pass the resulting structure to the LSM hooks. As such, since this
> series is doing static checks and not allowing byte processing for
> DAI, I'm convinced that it should entirely happen in the LSM hooks.

This could be misleading. This series use the audit cache to not evaluate=
 multiple path (and prevent ToCToU). I think there is then no more penalt=
y than a syscall using multiple times the same file descriptor. If the ch=
ecked file is not modified by another process, the file (path) cache chec=
k is only an integer/address comparison.

According to the current seccomp and syscall workflow in Linux, I don't s=
ee any other way to check an argument without modifying the current kerne=
l behavior (e.g. ptrace hook) or locking resources (i.e. file).


>=20
> 4) Performing the checks in the LSM hooks carries a risk of exposing
> the syscall's argument processing code to an attacker, but I think
> that is okay since very similar code would already need to be written
> to do the same thing before entering the syscall. The only way out of
> this, I think, would be to standardize syscall argument processing.

I created a basic, but generic and non-intrusive, syscall argument table =
to store useful types (e.g. int, char *) but standardizing syscall argume=
nt processing seems a big and long term task. However, using a cache simi=
lar to audit for some argument types seems more realistic ;)

>=20
> 5) If we can standardize syscall argument processing, we could also
> change when it happens, and retain the results for the syscall,
> allowing for full byte processing style of DAI. e.g. copy userspace to
> kernel space, do BPF on the argument, if okay, pass the kernel copy to
> the syscall where it continues the processing. If the kernel copy
> wasn't already created by seccomp, the syscall would just make that
> copy itself, etc.

Cf. my first comment and the mirroring code problem (and complexity).

>=20
> So, I see DAI as going one of two ways:
>=20
> a) rewrite all syscall entry to use a common cacheable argument parser
> and offering true BPF processing of the argument bytes.
>=20
> b) use the existing LSM hooks and define a policy language that can be
> loaded ahead of time.
>=20
> Doing "a" has many problems, I think. Not the least of which is that I
> can't imagine a way for such an architectural change to not have
> negative performance impacts for the regular case.

Agree :)

>=20
> Doing "b" means writing a policy engine. I would expect it to look a
> lot like either AppArmor or TOMOYO. TOMOYO has network structure
> processing, so probably it would look more like TOMOYO if you wanted
> more than just file paths. Maybe a seccomp LSM could share logic from
> one of the existing path-based LSMs.

An interesting thing about BPF is that it's already an engine and would b=
e interesting to do more than denying accesses but, for example, faking s=
yscall return values as it is already possible. Moreover, this keeps a sm=
all attack surface.

>=20
> Another note I had for this series was that because the checker tries
> to keep a cached struct path, it allows unprivileged users to check
> for path names existing or not, regardless of the user's permissions.

The registration of a new checker (SECCOMP_ADD_CHECKER_GROUP) against a f=
ile path should only be allowed according to the current user permissions=
, and only a filter from the same thread can checks against this same fil=
e path. So I don't see how this series allows unprivileged users to check=
 for path names regardless of their permissions.


> Instead, you have to check the path against the policy each time.

Well, each time doesn't means a path parsing but a cache comparison (like=
 does the kernel anyway).

> AppArmor does this efficiently with a pre-built deterministic finite
> automatons (built from regular expressions), and TOMOYO just does
> string compares and limited glob parsing every time.
>=20
> So, I can't take this as-is, but I'll take the one fix near the start.
> :) I hope this isn't too discouraging, since I'd love to see this
> solved. Hopefully you can keep chipping away at it!

Of course this series is not ready as-is, but I'm convinced the main idea=
s could make happy sandbox developers!

Regards,
 Micka=C3=ABl


--N0cl99CR830R5vkNpgHGq2Gw1dqs2jqRu--

--w4El8v5Rg2X5auNU5egn0mTehISP0VxKG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEcBAEBCgAGBQJXIqCWAAoJECLe/t9zvWqVdaEH/0BKT7i3j9DcgsAkGFpjb5Xr
0zbYXyvn9qCVgNYZ5C64QMIwuAK9UHrd/MLcPHf4kLPu0vewBZNrdGc7K0wYRg8O
YbryfmW7qLnBUVDHcUD+XwUu5YKGIrhVlHdbyY4aYPuivy/Rtbd9Xh9zadxpPGpw
SlK1gL9iOJ8zCHR9dvpPD5LG6Z4BC1b6Xx4RT29b3ewYkzokfMN4suw1n1p38U11
VjiblUmNvoZzjoWWVmdZyHxeBoLus0xXKYPBo79T04etlxqol8quULZYHiOgGj4C
oulygdWjMyC7Aw/StdbfVS+RY6WFup+fSTcuT39/0Xp77U85UhbSYufU4fPFicQ=
=3C2s
-----END PGP SIGNATURE-----

--w4El8v5Rg2X5auNU5egn0mTehISP0VxKG--
