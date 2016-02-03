From: Jann Horn <jann@thejh.net>
Subject: Re: [PATCH v5] fuse: Add support for passthrough read/write
Date: Wed, 3 Feb 2016 20:53:03 +0100
Message-ID: <20160203195303.GA991@pc.thejh.net>
References: <56AFAA5B.3000006@codeaurora.org>
 <20160202081035.GA18246@pc.thejh.net>
 <56B24F95.9040702@codeaurora.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1yeeQ81UyVL57Vl7"
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <56B24F95.9040702@codeaurora.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Nikhilesh Reddy <reddyn@codeaurora.org>
Cc: torvalds@linux-foundation.org, Miklos Szeredi <miklos@szeredi.hu>, fuse-devel <fuse-devel@lists.sourceforge.net>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, gregkh@linuxfoundation.org, linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk, Richard Weinberger <richard@nod.at>, Theodore Ts'o <tytso@mit.edu>, jack@suse.cz, Antonio SJ Musumeci <trapexit@spawn.link>, sven.utcke@gmx.de, Nikolaus Rath <nikolaus@rath.org>, Jann Horn <jannhorn@googlemail.com>, Mike Shal <marfey@gmail.com>
List-Id: linux-api@vger.kernel.org


--1yeeQ81UyVL57Vl7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 03, 2016 at 11:05:57AM -0800, Nikhilesh Reddy wrote:
> Hi
> Thanks for your review again :)
> >
> >Uh... how do you know at this point that the file is actually writable?
> >Normally, e.g. vfs_write() will ensure that the file is writable, and
> >e.g. generic_file_write_iter() won't check for writability as far as I
> >can tell. This might allow someone to use the passthrough mechanism to
> >overwrite a file he is only allowed to read, but not write, like
> >/etc/passwd.
>=20
> I considered adding the checks ( the same ones that VFS does)  but not su=
re
> if we need to.
> So the user will need to construct a fuse filesystem ( that opens for
> O_READONLY even though the user asks for a O_RDWR from the FUSE open) and
> then mount it , with CAP_SYS_ADMIN  for which you need to be root but  on=
ce
> he has that he should be able to easily get to the files without needing =
to
> go through FUSE  right using CAP_DAC_OVERRIDE?
>=20
> Am i missing something? Please do help me understand.
>=20
> But yes if really needed I can add additional checks once i understand it

On most Linux desktop systems, and on many servers, the userland "fuse"
package is installed, which ships with a setuid root helper "fusermount":

$ ls -l /bin/fusermount
-rwsr-xr-x 1 root root 30800 May 21  2015 /bin/fusermount

This setuid helper allows any user to mount FUSE filesystems anywhere he
wants. This works as follows: main() calls mount_fuse(), which opens
/dev/fuse by calling open_fuse_device(). mount_fuse() then makes sure
that the caller has write access to the directory he is about to mount
over using check_perm(), then calls mount() via do_mount(). mount_fuse()
returns the /dev/fuse fd, which is then sent to the invoker of fusermount
through a unix domain socket.

(What the setuid binary does control are the mount options; those are
used to enforce that the user can't mount filesystems that are
accessible for other users.)

Note that at no point, any data is sent to or read from the FUSE control
fd by fusermount. Therefore, the init reply that is processed in
process_init_reply() and determines whether passthrough will be enabled
is controlled by the unprivileged caller.

This fusermount mechanism is used by pseudo-filesystems like sshfs in
order to allow unprivileged users to use them.

fusermount aside, there is also an (as far as I know) pending patch with
the intent to make FUSE usable in user namespaces, which is going to
allow unprivileged users to mount FUSE filesystems even without a
userspace helper: https://lkml.org/lkml/2015/12/2/472

(Note that this is very different from CUSE, which by design must never
be exposed to non-root code.)

> >Also, I think this might bypass mandatory locks, the
> >security_file_permission hook (which seems like a bad idea anyway
> >though), inotify/fsnotify and sb_start_write.
> >
> Can you please elaborate/clarify further? I am am not sure what you mean.

--1yeeQ81UyVL57Vl7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJWslqfAAoJED4KNFJOeCOolEEQAKxK/3+QtJMwTlJgayLIZV5x
IRnQzBnQROtQgXf3fSSsObLE8/TmEJRspVwo3zUQg/r1vvW5G8fTxcFCe5PPpDG5
4kTwU0BlGzUyqHSkKoa/4IxmsarfGMgfjlh5lT5VacjEPzeRCUWUE2P9A89cLEb1
5V3ahYOhEx8pzaMgIeHrEjtD57BKP8NQmdt7dMcjEbXmPGXDKyraliJB+Mb7xxX0
dzFQzfrzrQKQrx8ehtTUO81bjR6r5gSDO/yIoi08BMRjXLSUlDO6ysjBLTgrSMN6
/HONtLlWwdnCmiejDswg7sypkgAlSlMHqz38jFzACJlY/1xh9bI5+1OkkKFWRMej
8PxrFK3dW+3Xktf4qepFPMg+ul36AFXZTTEydpfPsw3SRUiS9QIylGshNpPVb/Sh
dpFpe73Py1P4fA0vYx9nwbvouRVH4dmQxU5YFu1PSPpIKFToQYdEiRViDy51ZPXm
Ze7tV5ib90jdZrsUMBpsgALpaMffbJZBR5XvBSkcNMqgTk8zvqPXOXq5FLB+xqQM
lOB1O9tTQW+uqtWu+duNlJlFEoIJIQIIUwEslqJDo5goWP71a3HEmsl8v/00oAmr
dq4WRPAF0h6ENDnIPh6h3ERjwCcRML+ZcCaGZqkTKWGB1LMD/uEw/JOJbwYpVyr5
vhll4wK5Zmsj+Jc81CIb
=lSPQ
-----END PGP SIGNATURE-----

--1yeeQ81UyVL57Vl7--
