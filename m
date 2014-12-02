From: Richard Yao <ryao@gentoo.org>
Subject: Re: Why not make kdbus use CUSE?
Date: Tue, 02 Dec 2014 07:22:11 -0500
Message-ID: <547DAEF3.1090106@gentoo.org>
References: <20141129063416.GE32286@woodpecker.gentoo.org> <20141129175947.GB32510@kroah.com> <547D50B9.9040909@gentoo.org> <20141202054850.GA17043@kroah.com> <547D7159.2040900@gentoo.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="AouaX40JOEF1LqN14GjkwF9fRUAsH5P92"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <547D7159.2040900@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--AouaX40JOEF1LqN14GjkwF9fRUAsH5P92
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Dear Greg,

I had hoped that I could avoid reading through the code for yet another
IPC mechanism when I asked why we needed kdbus at LinuxCon Europe. In
hindsight, I should have just checked out the code and read it instead
of asking. However, what I did instead was ask and then do some thinking
based on that, mean to send an email and then sent it long after I
should have.

Our conversation now has lead me to realize my mistake and I have tried
to rectify it. I now see that kdbus is hooking into kernel interface to
implement KDBUS_ITEM_PAYLOAD_MEMFD in a way that we could only achieve
from userspace with UNIX domain sockets. I imagine that we could avoid
putting this code into the kernel through a combination of libev,
libfuse, memfds and UNIX domain sockets.

A fallback path could be provided by using anonymous files on the FUSE
filesystem. This could probably by by the sender doing something like
the following:

void *buf;
int coookie;
char *name =3D strdup("/sys/fs/kdbus/tmp/XXXXXX");
int fd =3D mkstemp(name);
unlink(name);
buf =3D mmap(NULL, LENGTH, PROT_WRITE, MAP_SHARED, fd, 0);
// Do your writes here
cookie =3D ioctl(fd, SEAL);
close(fd);
munmap(buf);
// Send a message via a UNIX domain socket to the server with the
// cookie, plus whatever XXXXXX became and instructions on where to
// send the data. If the file had been closed before the message was
// received, the server should be able to say okay. Otherwise, it can //
send an error. The server would need to have a timer to handle the
// case where a process never actually sends a message with the cookie.

Assuming that this dance succeeds, the FUSE process could then make a
readonly file in itself, open it read only, unlink it, put the data into
the file and send the file descriptor via UNIX domain socket while
refusing further writes. If it has its own user/group, the file should
be safe from prying eyes.

This is not as good as a memfd and also suffers from the race that
O_TMPFILE was meant to close, but it should be able to function as a
decent fallback. This would preserve portability across not only
different versions of Linux, but also other POSIX systems. Keeping the
code in userspace would allow us to apply SELinux policies to it, which
is something that we would lose if it were go to into the kernel.

That said, it is still not clear to me that dbus must be inside the
kernel to be able to perform multicast and zero copy using memfd. Is
there something that I have missed that make this not the case?

Yours truly,
Richard Yao


--AouaX40JOEF1LqN14GjkwF9fRUAsH5P92
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJUfa7/AAoJECDuEZm+6ExkNxcP/0zw9TxwLI8+s+cgwKJ1zTd4
vna3Zt6dokmzrwLibQC0P/ILuvP0jXSVvHjk995nl9Bn2UFC1XVkb9vu/90L7apP
46bRPGNDYwDi+VNTurp85cAu0LY6CFZ4qg3XgdYhovngyCQMk34ZefSCeOapV7+o
mvs1dlJ4Q8gWZ6EIHlSnRwc7Hbqwa6QAYj0gYwHfLdMSyGQqVnRRlazkGk3s9heU
QSegG4FKxt4IcaQf6UE71sZgES2xqcT2C6GUF9bIIRnqIuYg9DuWDlikcGqXV3vS
zbzIY5gHzIdshCAb6tHjkfuArX/YSn16P74VWbh5ZUlR/Fq+3z7iA+b7wCpYqDSp
Zo5/RvCniknWLlMKwOwmhgnAPZovb8zjVJFpEslSLYRC3LQvmG9HshiBWKWcOA/n
HRtMODt6lsGoNaEsEAh1cG8gs9d5eI+vi3JuDjKLHdmyPm/HcfNiEnbhrXyr/m5h
aaP9ytyRaN9dWi+9czk6sAuWI/H6JedxIcElWGghdGHWTFrqkve5wCW/bD1Rk0mp
6RbCOClh+hw0PyuDr2zAtPEbnEuxrHq1wO6BpvKAqg15S7YPALJGZ00dasooKgj6
9pAFIfOq6nUbhMDIY018Vd+M6CdyGSZVPGq1Ox3rEvXLbcQDkFwt2LgwnQ6NEQJP
4EmUKVTcM4mADu0ZnjFq
=bicU
-----END PGP SIGNATURE-----

--AouaX40JOEF1LqN14GjkwF9fRUAsH5P92--
