From: Ulrich Drepper <drepper@redhat.com>
Subject: Re: [PATCH v6 0/5] Add preadv & pwritev system calls.
Date: Fri, 16 Jan 2009 11:20:25 -0800
Message-ID: <4970DDF9.4090007@redhat.com>
References: <1232124344-25892-1-git-send-email-kraxel@redhat.com> <200901161852.04953.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <200901161852.04953.arnd@arndb.de>
Sender: linux-arch-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Gerd Hoffmann <kraxel@redhat.com>, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, aarcange@redhat.com
List-Id: linux-api@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Arnd Bergmann wrote:
> Did you get any feedback from Ulrich
> Drepper as to whether he plans to add support to glibc?

If they are in the kernel there is no reason not to export them from
glibc.  But I have a general comment about all kinds of read syscalls.
If think they have been misdesigned from day one and if we are going to
add new ones we might want to fix them.

The problem is that they don't allow for zero-copy operations in enough
cases.  The kernel is not free to store the data wherever it wants even
if the userlevel code is fine with that.  Ideally the program would tel=
l
the kernel that it is fine with any addressable address and provides a
buffer for the kernel to use in case zero-copy into that buffer is
possible or no zero-copy is possible at all.  An interface could look
like this:

   ssize_t readz (int fd, void *buf, size_t len, void **res)

(and accordingly for similar calls).  The application will then use the
pointer stored at the address pointed to by the fourth parameter instea=
d
of unconditionally using the buffer pointed to by the second parameter.
 For res=3D=3DNULL the semantics could be the same as the normal read()=
=2E

This is not the only interface needed to make this work.  Somehow the
memory used for the zero-copy buffers has to be administrated.  At the
very least an interface to mark the buffer returned by readz() as unuse=
d
is needed.

There is a lot to think about before this can be done (something I
started back in my 2006 OLS paper [1]).  But I wonder whether it's wort=
h
preparing for it and not add yet more interfaces which aren't ready for
this type of I/O.


[1] http://people.redhat.com/drepper/newni.pdf

- --
=E2=9E=A7 Ulrich Drepper =E2=9E=A7 Red Hat, Inc. =E2=9E=A7 444 Castro S=
t =E2=9E=A7 Mountain View, CA =E2=9D=96
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAklw3bIACgkQ2ijCOnn/RHSutgCgvIZki4gZfuLzwCOGkZqOf97v
1LYAn3fQj0C8CabsfvaYonFTZQ3oUtSn
=3DEDYF
-----END PGP SIGNATURE-----
