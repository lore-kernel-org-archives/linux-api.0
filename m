From: Aleksa Sarai <cyphar@cyphar.com>
Subject: Re: [PATCH 2/3] namei: implement AT_THIS_ROOT chroot-like path
 resolution
Date: Fri, 5 Oct 2018 02:26:11 +1000
Message-ID: <20181004162611.vdlujbdguvagalpt@ryuk>
References: <20180929103453.12025-1-cyphar@cyphar.com>
 <20180929131534.24472-1-cyphar@cyphar.com>
 <CAG48ez30WJhbsro2HOc_DR7V91M+hNFzBP5ogRMZaxbAORvqzg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="yctqpzljjmj7ahzy"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAG48ez30WJhbsro2HOc_DR7V91M+hNFzBP5ogRMZaxbAORvqzg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jann Horn <jannh@google.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, jlayton@kernel.org, Bruce Fields <bfields@fieldses.org>, Al Viro <viro@zeniv.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>, shuah@kernel.org, David Howells <dhowells@redhat.com>, Andy Lutomirski <luto@kernel.org>, christian@brauner.io, Tycho Andersen <tycho@tycho.ws>, kernel list <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org, linux-arch <linux-arch@vger.kernel.org>, linux-kselftest@vger.kernel.org, dev@opencontainers.org, containers@lists.linux-foundation.org, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org


--yctqpzljjmj7ahzy
Content-Type: multipart/mixed; boundary="a6nob3ksibii64qu"
Content-Disposition: inline


--a6nob3ksibii64qu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2018-09-29, Jann Horn <jannh@google.com> wrote:
> You attempt to open "C/../../etc/passwd" under the root "/A/B".
> Something else concurrently moves /A/B/C to /A/C. This can result in
> the following:
>=20
> 1. You start the path walk and reach /A/B/C.
> 2. The other process moves /A/B/C to /A/C. Your path walk is now at /A/C.
> 3. Your path walk follows the first ".." up into /A. This is outside
> the process root, but you never actually encountered the process root,
> so you don't notice.
> 4. Your path walk follows the second ".." up to /. Again, this is
> outside the process root, but you don't notice.
> 5. Your path walk walks down to /etc/passwd, and the open completes
> successfully. You now have an fd pointing outside your chroot.

I've been playing with this and I have the following patch, which
according to my testing protects against attacks where ".." skips over
nd->root. It abuses __d_path to figure out if nd->path can be resolved
=66rom nd->root (obviously a proper version of this patch would refactor
__d_path so it could be used like this -- and would not return
-EMULTIHOP).

I've also attached my reproducer. With it, I was seeing fairly constant
breakouts before this patch and after it I didn't see a single breakout
after running it overnight. Obviously this is not conclusive, but I'm
hoping that it can show what my idea for protecting against ".." was.

Does this patch make sense? Or is there something wrong with it that I'm
not seeing?

--8<-------------------------------------------------------------------

There is a fairly easy-to-exploit race condition with chroot(2) (and
thus by extension AT_THIS_ROOT and AT_BENEATH) where a rename(2) of a
path can be used to "skip over" nd->root and thus escape to the
filesystem above nd->root.

  thread1 [attacker]:
    for (;;)
      renameat2(AT_FDCWD, "/a/b/c", AT_FDCWD, "/a/d", RENAME_EXCHANGE);
  thread2 [victim]:
    for (;;)
      openat(dirb, "b/c/../../etc/shadow", O_THISROOT);

With fairly significant regularity, thread2 will resolve to
"/etc/shadow" rather than "/a/b/etc/shadow". With this patch, such cases
will be detected during ".." resolution (which is the weak point of
chroot(2) -- since walking *into* a subdirectory tautologically cannot
result in you walking *outside* nd->root).

The use of __d_path here might seem suspect, however we don't mind if a
path is moved from within the chroot to outside the chroot and we
incorrectly decide it is safe (because at that point we are still within
the set of files which were accessible at the beginning of resolution).
However, we can fail resolution on the next path component if it remains
outside of the root. A path which has always been outside nd->root
during resolution will never be resolveable from nd->root and thus will
always be blocked.

DO NOT MERGE: Currently this code returns -EMULTIHOP in this case,
	      purely as a debugging measure (so that you can see that
	      the protection actually does something). Obviously in the
	      proper patch this will return -EXDEV.

Signed-off-by: Aleksa Sarai <cyphar@cyphar.com>
---
 fs/namei.c | 32 ++++++++++++++++++++++++++++++--
 1 file changed, 30 insertions(+), 2 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 6f995e6de6b1..c8349693d47b 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -53,8 +53,8 @@
  * The new code replaces the old recursive symlink resolution with
  * an iterative one (in case of non-nested symlink chains).  It does
  * this with calls to <fs>_follow_link().
- * As a side effect, dir_namei(), _namei() and follow_link() are now=20
- * replaced with a single function lookup_dentry() that can handle all=20
+ * As a side effect, dir_namei(), _namei() and follow_link() are now
+ * replaced with a single function lookup_dentry() that can handle all
  * the special cases of the former code.
  *
  * With the new dcache, the pathname is stored at each inode, at least as
@@ -1375,6 +1375,20 @@ static int follow_dotdot_rcu(struct nameidata *nd)
 				return -EXDEV;
 			break;
 		}
+		if (unlikely(nd->flags & (LOOKUP_BENEATH | LOOKUP_CHROOT))) {
+			char *pathbuf, *pathptr;
+
+			pathbuf =3D kmalloc(PATH_MAX, GFP_ATOMIC);
+			if (!pathbuf)
+				return -ECHILD;
+			pathptr =3D __d_path(&nd->path, &nd->root, pathbuf, PATH_MAX);
+			kfree(pathbuf);
+			if (IS_ERR_OR_NULL(pathptr)) {
+				if (!pathptr)
+					pathptr =3D ERR_PTR(-EMULTIHOP);
+				return PTR_ERR(pathptr);
+			}
+		}
 		if (nd->path.dentry !=3D nd->path.mnt->mnt_root) {
 			struct dentry *old =3D nd->path.dentry;
 			struct dentry *parent =3D old->d_parent;
@@ -1510,6 +1524,20 @@ static int follow_dotdot(struct nameidata *nd)
 				return -EXDEV;
 			break;
 		}
+		if (unlikely(nd->flags & (LOOKUP_BENEATH | LOOKUP_CHROOT))) {
+			char *pathbuf, *pathptr;
+
+			pathbuf =3D kmalloc(PATH_MAX, GFP_KERNEL);
+			if (!pathbuf)
+				return -ENOMEM;
+			pathptr =3D __d_path(&nd->path, &nd->root, pathbuf, PATH_MAX);
+			kfree(pathbuf);
+			if (IS_ERR_OR_NULL(pathptr)) {
+				if (!pathptr)
+					pathptr =3D ERR_PTR(-EMULTIHOP);
+				return PTR_ERR(pathptr);
+			}
+		}
 		if (nd->path.dentry !=3D nd->path.mnt->mnt_root) {
 			int ret =3D path_parent_directory(&nd->path);
 			if (ret)
--=20
2.19.0

--=20
Aleksa Sarai
Senior Software Engineer (Containers)
SUSE Linux GmbH
<https://www.cyphar.com/>

--a6nob3ksibii64qu
Content-Type: text/x-c; charset=us-ascii
Content-Disposition: attachment; filename="rename_attack.c"

// SPDX-License-Identifier: GPL-2.0+
/*
 * Author: Aleksa Sarai <cyphar@cyphar.com>
 * Copyright (C) 2018 SUSE LLC.
 */

#define _GNU_SOURCE
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <limits.h>
#include <sys/syscall.h>
#include <linux/fs.h>

/* These come from <uapi/asm-generic/linux/fcntl.h> */
#ifndef O_BENEATH
# define O_BENEATH	00040000000
# define O_XDEV		00100000000
# define O_NOPROCLINKS	00200000000
# define O_NOSYMLINKS	01000000000
# define O_THISROOT	02000000000
#endif
#ifndef AT_BENEATH
# define AT_BENEATH		0x8000
# define AT_XDEV		0x10000
# define AT_NO_PROCLINKS	0x20000
# define AT_NO_SYMLINKS		0x40000
# define AT_THIS_ROOT		0x80000
#endif

#define bail(...)							\
	do {								\
		fprintf(stderr, __VA_ARGS__);				\
		fputs("\n", stderr);					\
		exit(1);						\
	} while (0)

int renameat2(int olddirfd, const char *oldpath,
	      int newdirfd, const char *newpath, unsigned int flags)
{
	errno = syscall(__NR_renameat2, olddirfd, oldpath,
					newdirfd, newpath, flags);
	return errno < 0 ? -1 : 0;
}

char *sprint_path(int fd)
{
	char *fdpath = NULL, *fullpath;
	if (asprintf(&fdpath, "/proc/self/fd/%d", fd) < 0)
		return NULL;

	fullpath = malloc(PATH_MAX+1);
	if (!fullpath)
		goto out1;
	memset(fullpath, '\0', PATH_MAX+1);
	if (readlink(fdpath, fullpath, PATH_MAX) < 0)
		goto out2;

	free(fdpath);
	return fullpath;

out2:
	free(fullpath);
out1:
	free(fdpath);
	return NULL;
}

int rename_attacker(int dirfd, char *namea, char *nameb)
{
	for (;;) {
		if (renameat2(dirfd, namea, dirfd, nameb, RENAME_EXCHANGE) < 0)
			fprintf(stderr, "rename a<=>b failed: %m\n");
	}
	return 1;
}

int openat_victim(int dirfd, char *path, unsigned int flags)
{
	char *last_path = NULL;
	int last_errno = 0;

	for (;;) {
		int fd = openat(dirfd, path, flags);
		if (fd < 0) {
			if (errno != last_errno)
				printf("errno=%m\n");
			last_errno = errno;
		} else {
			char *path = sprint_path(fd);
			if (!strcmp(path, "/")) {
				puts("[[ BREAKOUT ]]");
				printf("fd=%d\n", fd);
				for (;;)
					;
			}
			if (!last_path || strcmp(last_path, path)) {
				printf("path=%s\n", path);
				free(last_path);
				last_path = strdup(path);
			}
			free(path);
			close(fd);
		}
	}
	free(last_path);
	return 1;
}

int main(void)
{
	char tmppath[] = "__TEST_rename_attack.XXXXXX";

	if (!mkdtemp(tmppath))
		bail("mkdtemp: %m");

	int tmpfd = openat(AT_FDCWD, tmppath, O_PATH|O_DIRECTORY);
	if (tmpfd < 0)
		bail("open tmppath: %m");

	// Make dira and dirb.
	if (mkdirat(tmpfd, "a", 0755) < 0)
		bail("mkdir dira: %m");
	if (mkdirat(tmpfd, "b", 0755) < 0)
		bail("mkdir dirb: %m");
	if (mkdirat(tmpfd, "a/c", 0755) < 0)
		bail("mkdir dira/c: %m");

	// Open "a".
	int afd = openat(tmpfd, "a", O_PATH|O_DIRECTORY);
	if (afd < 0)
		bail("open dira: %m");

	pid_t child = fork();
	if (child < 0)
		bail("fork child: %m");
	else if (!child)
		return rename_attacker(tmpfd, "a/c", "b");
	else
		return openat_victim(afd, "c/../../../../../../../../../../../../../../../../../../../../../../../../../", O_THISROOT|O_RDONLY);

	return 1;
}

--a6nob3ksibii64qu--

--yctqpzljjmj7ahzy
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEXzbGxhtUYBJKdfWmnhiqJn3bjbQFAlu2PyIACgkQnhiqJn3b
jbSVDg/7Bx+z8hb5qGjoqssEvn4I5mHYbgn5xANcLmAV09OCbVdNKT/cFxwvPuVa
6mFjEbrZof8cqw1OWflAZv0Ihk2fV/fm3SZqYXu2u1L3VRkvHEdx1ncldHDM+qqy
orH11t0LyV+KF3gNmth9XHBFgRZhHHqluxW/QjihdWgT4/mzLJmMPl9Ec46rpR+4
LUuMoD37IkWrRIthGinXzVuu7QPs48Wz6rjCzaLMdvdO+jyXBDN9nNGyeezEJnfs
LH8bPryEUWMY6BTRxZjc08sP/xXZF4566yRxJa2u4VB0+gZb8+jqqI8uFTU9YHOF
fbXlMFv6FQOPyQYWsRb5VHvHLB0zzvE1TuMfm9HDMd2n4OQSorliIcZHtqpeJq5O
zRrvN8p3ZVTNhj8pzsGtduFsknCplsLO3MZCDhzH91CkpAztJ3tVfBGOgptyi/sL
R6w+8MNmnVW+GioUIB3fWq9a0ocKmmyhd+XU19M/2y/8DbwfWwOfM5lNbriajmBI
lzQnoY/egItX7Jz5jGnnKtK0YY4o2xTJitHbdzK7o5Mto9DarG96wvR0VaievTqm
ENsQNEwfwIqxGICW8S7ljRU1KmT/HAdC/usn3m/FQoojlRFGk153O22jQIVI2dl/
wq+IcAk2cy6IJr2ribHpc5cw4E/R1GnyhLRdc3HnSCyu66KIBgI=
=fhzh
-----END PGP SIGNATURE-----

--yctqpzljjmj7ahzy--
