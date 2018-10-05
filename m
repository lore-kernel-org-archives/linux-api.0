From: Aleksa Sarai <cyphar@cyphar.com>
Subject: Re: [PATCH 2/3] namei: implement AT_THIS_ROOT chroot-like path
 resolution
Date: Sat, 6 Oct 2018 01:07:28 +1000
Message-ID: <20181005150728.mgqnpkbukpeu3bsm@ryuk>
References: <20180929103453.12025-1-cyphar@cyphar.com>
 <20180929131534.24472-1-cyphar@cyphar.com>
 <CAG48ez30WJhbsro2HOc_DR7V91M+hNFzBP5ogRMZaxbAORvqzg@mail.gmail.com>
 <20181004162611.vdlujbdguvagalpt@ryuk>
 <CAG48ez2u--Wac7d9n3idC92Pd-M40QzYtR6FKR8PAYr=VQHUBQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="oh4knwbqqdaenl7c"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAG48ez2u--Wac7d9n3idC92Pd-M40QzYtR6FKR8PAYr=VQHUBQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jann Horn <jannh@google.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, jlayton@kernel.org, Bruce Fields <bfields@fieldses.org>, Al Viro <viro@zeniv.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>, shuah@kernel.org, David Howells <dhowells@redhat.com>, Andy Lutomirski <luto@kernel.org>, christian@brauner.io, Tycho Andersen <tycho@tycho.ws>, kernel list <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org, linux-arch <linux-arch@vger.kernel.org>, linux-kselftest@vger.kernel.org, dev@opencontainers.org, containers@lists.linux-foundation.org, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org


--oh4knwbqqdaenl7c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2018-10-04, Jann Horn <jannh@google.com> wrote:
> On Thu, Oct 4, 2018 at 6:26 PM Aleksa Sarai <cyphar@cyphar.com> wrote:
> > On 2018-09-29, Jann Horn <jannh@google.com> wrote:
> > > You attempt to open "C/../../etc/passwd" under the root "/A/B".
> > > Something else concurrently moves /A/B/C to /A/C. This can result in
> > > the following:
> > >
> > > 1. You start the path walk and reach /A/B/C.
> > > 2. The other process moves /A/B/C to /A/C. Your path walk is now at /=
A/C.
> > > 3. Your path walk follows the first ".." up into /A. This is outside
> > > the process root, but you never actually encountered the process root,
> > > so you don't notice.
> > > 4. Your path walk follows the second ".." up to /. Again, this is
> > > outside the process root, but you don't notice.
> > > 5. Your path walk walks down to /etc/passwd, and the open completes
> > > successfully. You now have an fd pointing outside your chroot.
> >
> > I've been playing with this and I have the following patch, which
> > according to my testing protects against attacks where ".." skips over
> > nd->root. It abuses __d_path to figure out if nd->path can be resolved
> > from nd->root (obviously a proper version of this patch would refactor
> > __d_path so it could be used like this -- and would not return
> > -EMULTIHOP).
> >
> > I've also attached my reproducer. With it, I was seeing fairly constant
> > breakouts before this patch and after it I didn't see a single breakout
> > after running it overnight. Obviously this is not conclusive, but I'm
> > hoping that it can show what my idea for protecting against ".." was.
> >
> > Does this patch make sense? Or is there something wrong with it that I'm
> > not seeing?
> >
> > --8<-------------------------------------------------------------------
> >
> > There is a fairly easy-to-exploit race condition with chroot(2) (and
> > thus by extension AT_THIS_ROOT and AT_BENEATH) where a rename(2) of a
> > path can be used to "skip over" nd->root and thus escape to the
> > filesystem above nd->root.
> >
> >   thread1 [attacker]:
> >     for (;;)
> >       renameat2(AT_FDCWD, "/a/b/c", AT_FDCWD, "/a/d", RENAME_EXCHANGE);
> >   thread2 [victim]:
> >     for (;;)
> >       openat(dirb, "b/c/../../etc/shadow", O_THISROOT);
> >
> > With fairly significant regularity, thread2 will resolve to
> > "/etc/shadow" rather than "/a/b/etc/shadow". With this patch, such cases
> > will be detected during ".." resolution (which is the weak point of
> > chroot(2) -- since walking *into* a subdirectory tautologically cannot
> > result in you walking *outside* nd->root).
> >
> > The use of __d_path here might seem suspect, however we don't mind if a
> > path is moved from within the chroot to outside the chroot and we
> > incorrectly decide it is safe (because at that point we are still within
> > the set of files which were accessible at the beginning of resolution).
> > However, we can fail resolution on the next path component if it remains
> > outside of the root. A path which has always been outside nd->root
> > during resolution will never be resolveable from nd->root and thus will
> > always be blocked.
> >
> > DO NOT MERGE: Currently this code returns -EMULTIHOP in this case,
> >               purely as a debugging measure (so that you can see that
> >               the protection actually does something). Obviously in the
> >               proper patch this will return -EXDEV.
> >
> > Signed-off-by: Aleksa Sarai <cyphar@cyphar.com>
> > ---
> >  fs/namei.c | 32 ++++++++++++++++++++++++++++++--
> >  1 file changed, 30 insertions(+), 2 deletions(-)
> >
> > diff --git a/fs/namei.c b/fs/namei.c
> > index 6f995e6de6b1..c8349693d47b 100644
> > --- a/fs/namei.c
> > +++ b/fs/namei.c
> > @@ -53,8 +53,8 @@
> >   * The new code replaces the old recursive symlink resolution with
> >   * an iterative one (in case of non-nested symlink chains).  It does
> >   * this with calls to <fs>_follow_link().
> > - * As a side effect, dir_namei(), _namei() and follow_link() are now
> > - * replaced with a single function lookup_dentry() that can handle all
> > + * As a side effect, dir_namei(), _namei() and follow_link() are now
> > + * replaced with a single function lookup_dentry() that can handle all
> >   * the special cases of the former code.
> >   *
> >   * With the new dcache, the pathname is stored at each inode, at least=
 as
> > @@ -1375,6 +1375,20 @@ static int follow_dotdot_rcu(struct nameidata *n=
d)
> >                                 return -EXDEV;
> >                         break;
> >                 }
> > +               if (unlikely(nd->flags & (LOOKUP_BENEATH | LOOKUP_CHROO=
T))) {
> > +                       char *pathbuf, *pathptr;
> > +
> > +                       pathbuf =3D kmalloc(PATH_MAX, GFP_ATOMIC);
> > +                       if (!pathbuf)
> > +                               return -ECHILD;
> > +                       pathptr =3D __d_path(&nd->path, &nd->root, path=
buf, PATH_MAX);
> > +                       kfree(pathbuf);
> > +                       if (IS_ERR_OR_NULL(pathptr)) {
> > +                               if (!pathptr)
> > +                                       pathptr =3D ERR_PTR(-EMULTIHOP);
> > +                               return PTR_ERR(pathptr);
> > +                       }
> > +               }
>=20
> One somewhat problematic thing about this approach is that if someone
> tries to lookup
> "a/a/a/a/a/a/a/a/a/a/[...]/../../../../../../../../../.." for some
> reason, you'll have quadratic runtime: For each "..", you'll have to
> walk up to the root.

What if we took rename_lock (call it nd->r_seq) at the start of the
resolution, and then only tried the __d_path-style check

  if (read_seqretry(&rename_lock, nd->r_seq) ||
      read_seqretry(&mount_lock, nd->m_seq))
	  /* do the __d_path lookup. */

That way you would only hit the slow path if there were concurrent
renames or mounts *and* you are doing a path resolution with
AT_THIS_ROOT or AT_BENEATH. I've attached a modified patch that does
this (and after some testing it also appears to work).

I'm not sure if there's a way to always avoid the quadratic lookup
without (significantly and probably unreasonably) changing how dcache
invalidation works. And obviously using this slow path if there was
_any_ rename on the _entire_ system is suboptimal, but I think it is a
significant improvement.

Another possibility is to expand on Andy's suggestion to use
/proc/$pid/root, and instead require AT_THIS_ROOT to use the root of a
namespace as its dirfd (I'm not sure if there's a trivial way to detect
this though). This wouldn't help with AT_BENEATH, but it should protect
against ".." shenanigans without any ".." handling changes. (This is
less ideal because it requires a container process, but it is another
way of dealing with the issue.)

---
 fs/namei.c | 49 ++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 46 insertions(+), 3 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 6f995e6de6b1..12c9be175cb4 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -493,7 +493,7 @@ struct nameidata {
 	struct path	root;
 	struct inode	*inode; /* path.dentry.d_inode */
 	unsigned int	flags;
-	unsigned	seq, m_seq;
+	unsigned	seq, m_seq, r_seq;
 	int		last_type;
 	unsigned	depth;
 	int		total_link_count;
@@ -1375,6 +1375,27 @@ static int follow_dotdot_rcu(struct nameidata *nd)
 				return -EXDEV;
 			break;
 		}
+		if (unlikely((nd->flags & (LOOKUP_BENEATH | LOOKUP_CHROOT)) &&
+			     (read_seqretry(&rename_lock, nd->r_seq) ||
+			      read_seqretry(&mount_lock, nd->m_seq)))) {
+			char *pathbuf, *pathptr;
+
+			nd->r_seq =3D read_seqbegin(&rename_lock);
+			/* Cannot take m_seq here. */
+
+			pathbuf =3D kmalloc(PATH_MAX, GFP_ATOMIC);
+			if (!pathbuf)
+				return -ECHILD;
+			pathptr =3D __d_path(&nd->path, &nd->root, pathbuf, PATH_MAX);
+			kfree(pathbuf);
+			if (IS_ERR_OR_NULL(pathptr)) {
+				int error =3D PTR_ERR_OR_ZERO(pathptr);
+
+				if (!error)
+					error =3D nd_jump_root(nd);
+				return error;
+			}
+		}
 		if (nd->path.dentry !=3D nd->path.mnt->mnt_root) {
 			struct dentry *old =3D nd->path.dentry;
 			struct dentry *parent =3D old->d_parent;
@@ -1510,6 +1531,27 @@ static int follow_dotdot(struct nameidata *nd)
 				return -EXDEV;
 			break;
 		}
+		if (unlikely((nd->flags & (LOOKUP_BENEATH | LOOKUP_CHROOT)) &&
+			     (read_seqretry(&rename_lock, nd->r_seq) ||
+			      read_seqretry(&mount_lock, nd->m_seq)))) {
+			char *pathbuf, *pathptr;
+
+			nd->r_seq =3D read_seqbegin(&rename_lock);
+			/* Cannot take m_seq here. */
+
+			pathbuf =3D kmalloc(PATH_MAX, GFP_KERNEL);
+			if (!pathbuf)
+				return -ENOMEM;
+			pathptr =3D __d_path(&nd->path, &nd->root, pathbuf, PATH_MAX);
+			kfree(pathbuf);
+			if (IS_ERR_OR_NULL(pathptr)) {
+				int error =3D PTR_ERR_OR_ZERO(pathptr);
+
+				if (!error)
+					error =3D nd_jump_root(nd);
+				return error;
+			}
+		}
 		if (nd->path.dentry !=3D nd->path.mnt->mnt_root) {
 			int ret =3D path_parent_directory(&nd->path);
 			if (ret)
@@ -2269,6 +2311,9 @@ static const char *path_init(struct nameidata *nd, un=
signed flags)
 	nd->last_type =3D LAST_ROOT; /* if there are only slashes... */
 	nd->flags =3D flags | LOOKUP_JUMPED | LOOKUP_PARENT;
 	nd->depth =3D 0;
+	nd->m_seq =3D read_seqbegin(&mount_lock);
+	nd->r_seq =3D read_seqbegin(&rename_lock);
+
 	if (flags & LOOKUP_ROOT) {
 		struct dentry *root =3D nd->root.dentry;
 		struct inode *inode =3D root->d_inode;
@@ -2279,7 +2324,6 @@ static const char *path_init(struct nameidata *nd, un=
signed flags)
 		if (flags & LOOKUP_RCU) {
 			nd->seq =3D __read_seqcount_begin(&nd->path.dentry->d_seq);
 			nd->root_seq =3D nd->seq;
-			nd->m_seq =3D read_seqbegin(&mount_lock);
 		} else {
 			path_get(&nd->path);
 		}
@@ -2290,7 +2334,6 @@ static const char *path_init(struct nameidata *nd, un=
signed flags)
 	nd->path.mnt =3D NULL;
 	nd->path.dentry =3D NULL;
=20
-	nd->m_seq =3D read_seqbegin(&mount_lock);
 	if (unlikely(flags & (LOOKUP_CHROOT | LOOKUP_XDEV))) {
 		error =3D dirfd_path_init(nd);
 		if (unlikely(error))
--=20
2.19.0


--=20
Aleksa Sarai
Senior Software Engineer (Containers)
SUSE Linux GmbH
<https://www.cyphar.com/>

--oh4knwbqqdaenl7c
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEXzbGxhtUYBJKdfWmnhiqJn3bjbQFAlu3fjAACgkQnhiqJn3b
jbSTfw//cFzBBCEdluqIcPeMw8ANpTy3DdtjEtEOPy/DcE4z++lDYLO5jGhSyg8e
gdpEaNiiRS3BbSjxUqU9BD2EO8cg6DWtiOdAZfuJo2YKZlK/uuKnm/q+4eGSahYm
aHKmDdT4OqMBZR20Cguxkz2lt8DtIGBbw6OZVtgyMZlplpAmVmSj1E+YjIZFhGVe
ACr+goArC+WEuGzQiTP1fxqpi91wjpuec4HGeJTP9/296Gr8DkLVUZuZrDx7uOG3
0dznSloj6HSkvqAjam7pfyMm4W5xMgvy8WLod6lpIeM1CY577VoDnysJIYBIGRpS
TApxgka9VRQGd/7qukLH5ZIAmJfFVDmOpDfxUSamXdWwFM7521L3WJdombcGS2w7
3NvZW3Ig0O4ekek1rtjRGIUDJ6sZG0PNwokJz93aiMdkp8LTwM3VtbSCPOOAOFab
609ktJefCzqVSj3qmj43lKoB8rinEDMOVcqKna9AisJSTiYXYODrbR5MrQTUV6le
fLKF2UIwF4qToDnOn9o2TczI/XRZa8RCtcb3xeXGc2VL6caOQQv7puNximQLRN2H
tR79LaoTbEBxNmtHZOFlm0Xt3/2ExV/gHP1KE8QFka+kZqB0iImYo9n7+rka2bEZ
Sftv6wwZ2Z37aoO3xdhkhCAvIOQgujuWFRj1PVOWReJ1WtcgZSk=
=jMHa
-----END PGP SIGNATURE-----

--oh4knwbqqdaenl7c--
