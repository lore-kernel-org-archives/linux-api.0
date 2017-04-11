From: Greg Kurz <groug@kaod.org>
Subject: Re: [PATCH 1/2] vfs: implement fchmodat2() syscall
Date: Tue, 11 Apr 2017 14:04:19 +0200
Message-ID: <20170411140419.58df8e6d@bahia.lan>
References: <148830142269.7103.7429913851447595016.stgit@bahia>
        <CAHO5Pa2dPUQRXEs7W198M0wbxWAkjKzsVPo4yrc1VPfbNM5R9w@mail.gmail.com>
        <20170411133937.6aad294e@bahia.lan>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/_rdr+KditHC4.Zt9PfEMR9J"; protocol="application/pgp-signature"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170411133937.6aad294e@bahia.lan>
Sender: linux-kernel-owner@vger.kernel.org
To: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Linux-Fsdevel <linux-fsdevel@vger.kernel.org>, Eric Blake <eblake@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

--Sig_/_rdr+KditHC4.Zt9PfEMR9J
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 11 Apr 2017 13:39:37 +0200
Greg Kurz <groug@kaod.org> wrote:

> On Wed, 1 Mar 2017 10:01:53 +0100
> Michael Kerrisk <mtk.manpages@gmail.com> wrote:
>=20
> > [CC +=3D linux-api@vger.kernel.org]
> >=20
> > Hello Greg,
> >=20
> > Since this is a kernel-user-space API change, please CC linux-api@.
> > The kernel source file Documentation/SubmitChecklist notes that all
> > Linux kernel patches that change userspace interfaces should be CCed
> > to linux-api@vger.kernel.org, so that the various parties who are
> > interested in API changes are informed. For further information, see
> > https://www.kernel.org/doc/man-pages/linux-api-ml.html
> >=20
> > Thanks,
> >=20
> > Michael
> >  =20
>=20
> My bad :-\=20
>=20
> Anyway, since I had no feedback so far, I'll send a v2 and this time I'll
> rembember to Cc linux-api@vger.kernel.org.
>=20
> Thanks,
>=20

BTW, commit "186128f75392 docs-rst: add documents to development-process" m=
oved
Documentation/SubmitChecklist to Documentation/process/submit-checklist.rst=
, but
the www.kernel.org page hasn't been updated to reflect that...

Cheers.

--
Greg

> --
> Greg
>=20
> >=20
> > On Tue, Feb 28, 2017 at 6:03 PM, Greg Kurz <groug@kaod.org> wrote: =20
> > > According to the POSIX.1-2008 manual page [1], the fchmodat() functio=
n has
> > > a flag argument which may be passed the following value:
> > >
> > > AT_SYMLINK_NOFOLLOW
> > >     If path names a symbolic link, then the mode of the symbolic link=
 is
> > >     changed.
> > >
> > > and the following error may be returned:
> > >
> > > [EOPNOTSUPP]
> > >     The AT_SYMLINK_NOFOLLOW bit is set in the flag argument, path nam=
es a
> > >     symbolic link, and the system does not support changing the mode =
of a
> > >     symbolic link.
> > >
> > > The linux kernel doesn't support changing the mode of a symbolic link=
, but
> > > the current implementation doesn't even have a flag argument. It is t=
hen
> > > up to userspace to deal with that. Unfortunately, it is impossible to
> > > implement the POSIX behavior in a race-free manner.
> > >
> > > This patch introduces a new fchmodat2() syscall with a flag argument =
to
> > > address the issue.
> > >
> > > [1] http://pubs.opengroup.org/onlinepubs/9699919799/functions/chmod.h=
tml
> > >
> > > Signed-off-by: Greg Kurz <groug@kaod.org>
> > > ---
> > >  fs/open.c                         |   23 +++++++++++++++++++----
> > >  include/linux/syscalls.h          |    2 ++
> > >  include/uapi/asm-generic/unistd.h |    4 +++-
> > >  scripts/checksyscalls.sh          |    3 ++-
> > >  4 files changed, 26 insertions(+), 6 deletions(-)
> > >
> > > diff --git a/fs/open.c b/fs/open.c
> > > index 9921f70bc5ca..66a8c19f72ca 100644
> > > --- a/fs/open.c
> > > +++ b/fs/open.c
> > > @@ -558,24 +558,39 @@ SYSCALL_DEFINE2(fchmod, unsigned int, fd, umode=
_t, mode)
> > >         return err;
> > >  }
> > >
> > > -SYSCALL_DEFINE3(fchmodat, int, dfd, const char __user *, filename, u=
mode_t, mode)
> > > +SYSCALL_DEFINE4(fchmodat2, int, dfd, const char __user *, filename, =
umode_t,
> > > +               mode, int, flag)
> > >  {
> > >         struct path path;
> > > -       int error;
> > > -       unsigned int lookup_flags =3D LOOKUP_FOLLOW;
> > > +       int error =3D -EINVAL;
> > > +       unsigned int lookup_flags;
> > > +
> > > +       if ((flag & ~AT_SYMLINK_NOFOLLOW) !=3D 0)
> > > +               goto out;
> > > +
> > > +       lookup_flags =3D (flag & AT_SYMLINK_NOFOLLOW) ? 0 : LOOKUP_FO=
LLOW;
> > >  retry:
> > >         error =3D user_path_at(dfd, filename, lookup_flags, &path);
> > >         if (!error) {
> > > -               error =3D chmod_common(&path, mode);
> > > +               error =3D -EOPNOTSUPP;
> > > +               if (!d_is_symlink(path.dentry))
> > > +                       error =3D chmod_common(&path, mode);
> > >                 path_put(&path);
> > >                 if (retry_estale(error, lookup_flags)) {
> > >                         lookup_flags |=3D LOOKUP_REVAL;
> > >                         goto retry;
> > >                 }
> > >         }
> > > +out:
> > >         return error;
> > >  }
> > >
> > > +SYSCALL_DEFINE3(fchmodat, int, dfd, const char __user *, filename, u=
mode_t,
> > > +               mode)
> > > +{
> > > +       return sys_fchmodat2(dfd, filename, mode, 0);
> > > +}
> > > +
> > >  SYSCALL_DEFINE2(chmod, const char __user *, filename, umode_t, mode)
> > >  {
> > >         return sys_fchmodat(AT_FDCWD, filename, mode);
> > > diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
> > > index 91a740f6b884..982089d55b31 100644
> > > --- a/include/linux/syscalls.h
> > > +++ b/include/linux/syscalls.h
> > > @@ -775,6 +775,8 @@ asmlinkage long sys_futimesat(int dfd, const char=
 __user *filename,
> > >  asmlinkage long sys_faccessat(int dfd, const char __user *filename, =
int mode);
> > >  asmlinkage long sys_fchmodat(int dfd, const char __user * filename,
> > >                              umode_t mode);
> > > +asmlinkage long sys_fchmodat2(int dfd, const char __user *filename,
> > > +                             umode_t mode, int flag);
> > >  asmlinkage long sys_fchownat(int dfd, const char __user *filename, u=
id_t user,
> > >                              gid_t group, int flag);
> > >  asmlinkage long sys_openat(int dfd, const char __user *filename, int=
 flags,
> > > diff --git a/include/uapi/asm-generic/unistd.h b/include/uapi/asm-gen=
eric/unistd.h
> > > index 9b1462e38b82..e8b0a00908b1 100644
> > > --- a/include/uapi/asm-generic/unistd.h
> > > +++ b/include/uapi/asm-generic/unistd.h
> > > @@ -730,9 +730,11 @@ __SYSCALL(__NR_pkey_mprotect, sys_pkey_mprotect)
> > >  __SYSCALL(__NR_pkey_alloc,    sys_pkey_alloc)
> > >  #define __NR_pkey_free 290
> > >  __SYSCALL(__NR_pkey_free,     sys_pkey_free)
> > > +#define __NR_fchmodat2 291
> > > +__SYSCALL(__NR_fchmodat2,     sys_fchmodat2)
> > >
> > >  #undef __NR_syscalls
> > > -#define __NR_syscalls 291
> > > +#define __NR_syscalls 292
> > >
> > >  /*
> > >   * All syscalls below here should go away really,
> > > diff --git a/scripts/checksyscalls.sh b/scripts/checksyscalls.sh
> > > index 2c9082ba6137..2e7471a1d308 100755
> > > --- a/scripts/checksyscalls.sh
> > > +++ b/scripts/checksyscalls.sh
> > > @@ -19,7 +19,7 @@ cat << EOF
> > >  #define __IGNORE_link          /* linkat */
> > >  #define __IGNORE_unlink                /* unlinkat */
> > >  #define __IGNORE_mknod         /* mknodat */
> > > -#define __IGNORE_chmod         /* fchmodat */
> > > +#define __IGNORE_chmod         /* fchmodat2 */
> > >  #define __IGNORE_chown         /* fchownat */
> > >  #define __IGNORE_mkdir         /* mkdirat */
> > >  #define __IGNORE_rmdir         /* unlinkat */
> > > @@ -39,6 +39,7 @@ cat << EOF
> > >
> > >  /* Missing flags argument */
> > >  #define __IGNORE_renameat      /* renameat2 */
> > > +#define __IGNORE_fchmodat      /* fchmodat2 */
> > >
> > >  /* CLOEXEC flag */
> > >  #define __IGNORE_pipe          /* pipe2 */
> > >   =20
> >=20
> >=20
> >  =20
>=20


--Sig_/_rdr+KditHC4.Zt9PfEMR9J
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAljsxkMACgkQAvw66wEB28KGAwCfffS3UP7ol2tS7QTeNoRmo+4Q
aAYAn2PVitGZPVUqwC0DK8In09vvuo2p
=xyie
-----END PGP SIGNATURE-----

--Sig_/_rdr+KditHC4.Zt9PfEMR9J--
