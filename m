From: Eric Blake <eblake@redhat.com>
Subject: Re: [BUG] Generic syscalls -- chmod vs. fchmodat
Date: Tue, 25 Jan 2011 14:32:06 -0700
Message-ID: <4D3F4156.7010900@redhat.com>
References: <AANLkTikhKHnR+7DskxYqWXduX4=tpfgsfL4sNYq+4QDq@mail.gmail.com> <20110125174515.C1DC2183C19@magilla.sf.frob.com> <201101251921.15184.arnd@arndb.de> <201101251352.03079.vapier@gentoo.org> <4D3F2AD9.8060000@redhat.com> <4D3F3308.1050305@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256; protocol="application/pgp-signature"; boundary="------------enigB8B280F5F3CB958B1C534D9A"
Return-path: <libc-ports-return-1823-gclgp-libc-ports=m.gmane.org@sourceware.org>
In-Reply-To: <4D3F3308.1050305@redhat.com>
List-Unsubscribe: <mailto:libc-ports-unsubscribe-gclgp-libc-ports=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-ports-subscribe@sourceware.org>
List-Post: <mailto:libc-ports@sourceware.org>
List-Help: <mailto:libc-ports-help@sourceware.org>, <http://sourceware.org/lists.html#faqs>
Sender: libc-ports-owner@sourceware.org
Cc: Mike Frysinger <vapier@gentoo.org>, Arnd Bergmann <arnd@arndb.de>, Paul Eggert <eggert@cs.ucla.edu>, Roland McGrath <roland@redhat.com>, linasvepstas@gmail.com, Chris Metcalf <cmetcalf@tilera.com>, GLIBC Devel <libc-alpha@sourceware.org>, linux-kernel@vger.kernel.org, libc-ports@sourceware.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigB8B280F5F3CB958B1C534D9A
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 01/25/2011 01:31 PM, Eric Blake wrote:
> One other thing to point out - this is not the first time glibc has
> added code around *at kernel syscalls in order to provide POSIX
> semantics where the Linux syscall does not.  Remember that both futimens
> and utimensat are implemented on top of the same syscall, and that
> futimens(AT_FDCWD, times) must fail rather than set the times on ".".

I guess an executive summary of the issue, from my point of view, is
that I like the idea of making both simple versions of a command call
into the same *at version of the syscall [chmod via
sys_fchmodat(AT_FDCWD,name), and fchmod via sys_fchmodat(fd, NULL)],
provided that:

1. chmod("") must continue to fail with ENOENT (here, it might make
sense for the kernel to do the filtering, since there is an obvious
difference between "" and NULL; but if the kernel call does not change,
then the burden is on glibc instead)

2. fchmod(AT_FDCWD) must continue to fail with EBADF (here, it might
make sense for the kernel to do the filtering - if the name argument is
NULL, then the fd argument must be non-negative; but precedence with
futimens vs. sys_utimensat puts the burden on glibc instead)

3. chmod(NULL) is undefined.  Currently it fails with EFAULT, but I see
no reason why it can't start failing with EBADF (assuming the kernel
does filtering as for point 2) or start operating on ".", because it's
only a buggy program that would be making that call in the first place
(actually, failing with EBADF is a little safer, as silent conversion
between two types of failures is a bit easier to audit for consequences
than is silent conversion from error to success).

4. fchmodat(fd, NULL) is undefined.  For non-negative fd, POSIX allows
failure, but it also allows behaving like fchmod.  Portable programs
can't rely on a particular behavior, but glibc is more than welcome to
rely on a particular syscall behavior for implementing the simpler
functions.

5. fchmodat(fd, "") must fail with ENOENT.  For non-negative fd,
apparently the kernel currently modifies fd, although point 1 says it
might make more sense to fail with ENOENT so that glibc doesn't have to
do as much work in chmod and fchmodat (if the kernel call does not
change, then the burden is on glibc).

6. fchmodat(AT_FDCWD, NULL) is undefined.  For AT_FDCWD, the kernel
currently modifies ".", although point 2 says it might make more sense
to fail with EBADF so that glibc doesn't have to do as much work in fchmod.

7. fchmodat(AT_FDCWD, "") must fail with ENOENT.  Apparently, the kernel
currently modifies ".", although point 1 says it might make more sense
to fail with ENOENT so that glibc doesn't have to do as much work in
chmod and fchmodat (if the kernel call does not change, then the burden
is on glibc).

--=20
Eric Blake   eblake@redhat.com    +1-801-349-2682
Libvirt virtualization library http://libvirt.org


--------------enigB8B280F5F3CB958B1C534D9A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Public key at http://people.redhat.com/eblake/eblake.gpg
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org/

iQEcBAEBCAAGBQJNP0FWAAoJEKeha0olJ0NqfmMH/0lATthcNht9vU/kP49SnvKx
e1wmOUH5l7O7X6MtDXxHQYgp7IxiU4QJcvdZuqQ2HiyoAFCW41H4R+E7pwujKO38
wYSVnpebsfT3vAck+ocz3EKNdDp4mudf7PLcVicDvJVnzYbg5NdKktvyygR2LBo+
aqDr87bEeB7RcYqK7mIMBxpRRijpIhmj3IPjV1oScNjKxKPZI8B8HjTGIZ/4jcGR
cIQ20S5Wu6ShV1j1gsHpK7HxnSVS7fppnuKRgmVPl/wnWGCQuvmPViLolboUlJ6x
9YDreoTQwz5Ajq52h03ftiNFtLBXYS81T7jpwQkdF7qew/gFj9U13iGEl75ddgg=
=TbNi
-----END PGP SIGNATURE-----

--------------enigB8B280F5F3CB958B1C534D9A--
