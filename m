From: Jann Horn <jann@thejh.net>
Subject: Re: [PATCH RFC] Introduce new security.nscapability xattr
Date: Wed, 20 Jan 2016 13:48:16 +0100
Message-ID: <20160120124816.GB32379@pc.thejh.net>
References: <20151130224356.GA27972@mail.hallyn.com>
 <87two3w0el.fsf@x220.int.ebiederm.org>
 <20151204202116.GA4809@mail.hallyn.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VrqPEDrXMn8OVzN4"
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20151204202116.GA4809@mail.hallyn.com>
Sender: owner-linux-security-module@vger.kernel.org
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, "Serge E. Hallyn" <serge.hallyn@ubuntu.com>, lkml <linux-kernel@vger.kernel.org>, Andrew Morgan <morgan@kernel.org>, Andy Lutomirski <luto@amacapital.net>, lxc-devel@lists.linuxcontainers.org, Richard Weinberger <richard@nod.at>, LSM <linux-security-module@vger.kernel.org>, linux-api@vger.kernel.org, keescook@chromium.org
List-Id: linux-api@vger.kernel.org


--VrqPEDrXMn8OVzN4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 04, 2015 at 02:21:16PM -0600, Serge E. Hallyn wrote:
> Quoting Eric W. Biederman (ebiederm@xmission.com):
> > "Serge E. Hallyn" <serge.hallyn@ubuntu.com> writes:
> >=20
> > > A common way for daemons to run with minimal privilege is to start as=
 root,
> > > perhaps setuid-root, choose a desired capability set, set PR_SET_KEEP=
CAPS,
> > > then change uid to non-root.  A simpler way to achieve this is to set=
 file
> > > capabilities on a not-setuid-root binary.  However, when installing a=
 package
> > > inside a (user-namespaced) container, packages cannot be installed wi=
th file
> > > capabilities.  For this reason, containers must install ping setuid-r=
oot.
> >=20
> > Don't ping sockets avoid that specific problem?
> >=20
> > I expect the general case still holds.
> >=20
> > > To achieve this, we would need for containers to be able to request f=
ile
> > > capabilities be added to a file without causing these to be honored i=
n the
> > > initial user namespace.
> > >
> > > To this end, the patch below introduces a new capability xattr format=
=2E  The
> > > main enhancement over the existing security.capability xattr is that =
we
> > > tag capability sets with a uid - the uid of the root user in the name=
space
> > > where the capabilities are set.  The capabilities will be ignored in =
any
> > > other namespace.  The special case of uid =3D=3D -1 (which must only =
ever be
> > > able to be set by kuid 0) means use the capabilities in all
> > > namespaces.
>=20
> really since security.capability xattrs are currently honored in all
> namespaces this isn't really necessary.  Until and unless Seth's set
> changes that.
>=20
> >=20
> > A quick comment on this.
> >=20
> > We currently allow capabilities that have been gained to be valid in all
> > descendent user namespaces.
> >=20
> > Applying this principle to the on-disk capabilities would make it so
> > that uid 0 would mean capabilities in all namespaces.
> >=20
> > It might be worth it to introduce a fixed sized array with a length
> > parameter of perhaps 32 entries which is a path of root uids as seen by
> > the initial user namespace.  That way the entire construction of the
> > user namespace could be verified.  AKA verify the current user namespace
> > and the parent and the parents parent.  Up to the user namespace the
> > current filesystem is mounted in. We would look at how much space
> > allows an xattr to be stored without causing filesystems a challenge
> > to properly size such an array.
> >=20
> > Given that uids are fundamentally flat that might not be particularly
> > useful.  If we add an alternative way of identifying user namespaces
> > say a privileged operation that set a uuid, then the complete path would
> > be more interesting.
> >=20
> > > An alternative format would use a pair of uids to indicate a range of=
 rootids.
> > > This would allow root in a user namespace with uids 100000-165536 map=
ped to
> > > set the xattr once on a file, then launch nested containers wherein t=
he file
> > > could be used with privilege.  That's not what this patch does, but w=
ould be
> > > a trivial change if people think it would be worthwhile.
> > >
> > > This patch does not actually address the real problem, which is setti=
ng the
> > > xattrs from inside containers.  For that, I think the best solution i=
s to
> > > add a pair of new system calls, setfcap and getfcap. Userspace would =
for
> > > instance call fsetfcap(fd, cap_user_header_t, cap_user_data_t), to wh=
ich
> > > the kernel would, if not in init_user_ns, react by writing an appropr=
iate
> > > security.nscapability xattr.
> >=20
> > That feels hard to maintain, but you may be correct that we have a small
> > enough userspace that it would not be a problem.
> >=20
> > Eric
> >=20
> >=20
> > > The libcap2 library's cap_set_file/cap_get_file could be switched over
> > > transparently to use this to hide its use from all callers.
> > >
> > > Comments appreciated.
> > >
> > > Note - In this patch, file capabilities only work for containers whic=
h have
> > > a root uid defined.  We may want to allow -1 uids to work in all
> > > namespaces.  There certainly would be uses for this, but I'm a bit un=
settled
> > > about the implications of allowing a program privilege in a container=
 where
> > > there is no uid with privilege.  This needs more thought.
>=20
> So for actually enabling (user-namespaced) containers to use these, there
> are a few possibilities that come to mine.
>=20
> 1. A new setfcap (/getfcap) syscall.  Uses mapped uid 0 from
> current_user_ns() to write a value in the security.nscapability xattr.
> Userspace doesn't need to worry at all about namespace issues.

Your patch has an "ncaps" field and supports giving (possibly different)
privileges to different namespace root users.
I think that with a setfcap() syscall as you describe, it would be hard
to add more than one security.nscapability entry to a file without
poking holes into stuff:

If setfcap() requires inode write access, every namespace root for whom
a security.nscapability entry can be added can overwrite the file, so
namespace roots might be able to execute code as each other.

If setfcap() doesn't require inode write access, that isn't a big
security issue, but it allows unprivileged users to waste disk space
in a writable-mounted filesystem on which they have no write access
anywhere. I'm not sure whether that is a sufficiently big problem for
anyone to care.


Another issue with this would be that it makes restoring sub-namespace
capabilities from a backup somewhat ugly, at least if you're not in the
init ns: You'd have to parse the capabilities attribute, then, for every
attribute you want to restore whose rootid doesn't refer to your
namespace, clone(CLONE_NEWUSER), map the target uid to 0 from the parent
process, seteuid(0), do the setfcap() and exit.

It would require less synchronization with my ptrace hardening patch
that checks whether uids are mapped (if that lands, I don't think it has
yet?) because that would allow you to first setuid, then clone(), map
the uid to 0 inside the namespace and setfcap(), but it'd still require
special-case code in backup software.


> 2. Just expect userspace to write a xattr;  kernel checks that no values
> are changed for any other namespaces.  This could be a lot of parsing and
> verifying in the kernel.

This option would allow the first problem I described with option 1 (if
it is a problem?) to be worked around by letting a helper in the outer
namespace add capabilities for lower namespaces - but it wouldn't be
pretty.

I think it would also allow tar, which already supports xattrs, to
deal with namespace capabilities without needing any additional code.
I think that would be nice to have.


> 3. Switch the xattr scheme - instead of one security.nscapability xattr
> with multiple entries, use security.nscapability.$(rootid).  Now the
> kernel only needs to verify that the $rootid is valid for the writing
> task, and we don't need a new syscall.  OTOH userspace needs to know
> what it's doing.  Of course we can still hide that behind libcap2's helpe=
rs.

This doesn't sound so good - how would the namespace know its rootid?
If it is just one level below init_ns, it can grab it from
/proc/self/uid_map, but for deeper levels that won't work.


> Any opinions on which way seems best?  1 does seem cleanest (and supports
> use of seccomp if we want to forbit its use by some containers), but
> involves a new pair of syscalls.  2 seems to me to be right out, but
> others might disagree...

--VrqPEDrXMn8OVzN4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJWn4IQAAoJED4KNFJOeCOo3qkQAMY/7p5b+7p0QNtinEiy9Pch
DbzmaOXbdgXjcum6BV7uSUy3zHEuO3OZu6I12JRRPOmsbqUgALZ9vBnWAbT48nqH
wbqN8Ia8Rf7fpnqdRhY8S3hm2LYikHeSlXWE4C5vFAJgN1eDXycL4S6XKTZK54gW
EIIDrfsUiDUpLLaQQCXpA+TUKqfeVIHcAlOwbDhZBJwHd6O3HeFakxyrbo8OM2Gi
8B4YhPK9joblWtXfPgFTVmYIWn4SfkKNy+HI4DClr3byQrRQzeNBsIfmIZTv2vfr
YRVQEpK4MoSrnz2+WhPjedyttZsuqsvYPqb06YJaISSLttJU5DiXOacpu/b7ugb6
rDcKDtr218uZDhxTyVqPyj+xS4OP69WGCwlKHxtwWAOzIFCQLG5vZhuzpGkcWP06
hDBSB8hHil3IuUOa+DZG9AGnVVYYooik/S+hIxb22j92YOiBvkafHUnynOgwGJ32
emQd+2HH0rElPRqSQdx0mbnzM8pPBQTvjEceTH/c4R1nSBOsjn1/FrXDG+ZMLFd6
Rx9tyYsJyhqc9uxmVjTyhJMnxLwbMA1Xh9tY1QAJ6Uac8P17TGA4d1JXOuxkuRWh
PyHodKaUgVlt8Rc2wJEH9IBhmkx4yw76JHv2o4cBEpOhEsGjvFtpy140ETSykLei
93ZCDYP5sxg9wqGEycTN
=raYd
-----END PGP SIGNATURE-----

--VrqPEDrXMn8OVzN4--
