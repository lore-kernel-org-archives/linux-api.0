From: Jann Horn <jann@thejh.net>
Subject: Re: [PATCH v5] fuse: Add support for passthrough read/write
Date: Wed, 3 Feb 2016 21:42:36 +0100
Message-ID: <20160203204236.GA17361@pc.thejh.net>
References: <56AFAA5B.3000006@codeaurora.org>
 <20160202081035.GA18246@pc.thejh.net>
 <56B24F95.9040702@codeaurora.org>
 <20160203195303.GA991@pc.thejh.net>
 <56B26011.70609@codeaurora.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="d6Gm4EdcadzBjdND"
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <56B26011.70609@codeaurora.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Nikhilesh Reddy <reddyn@codeaurora.org>
Cc: torvalds@linux-foundation.org, Miklos Szeredi <miklos@szeredi.hu>, fuse-devel <fuse-devel@lists.sourceforge.net>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, gregkh@linuxfoundation.org, linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk, Richard Weinberger <richard@nod.at>, Theodore Ts'o <tytso@mit.edu>, jack@suse.cz, Antonio SJ Musumeci <trapexit@spawn.link>, sven.utcke@gmx.de, Nikolaus Rath <nikolaus@rath.org>, Jann Horn <jannhorn@googlemail.com>, Mike Shal <marfey@gmail.com>
List-Id: linux-api@vger.kernel.org


--d6Gm4EdcadzBjdND
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 03, 2016 at 12:16:17PM -0800, Nikhilesh Reddy wrote:
> On 02/03/2016 11:53 AM, Jann Horn wrote:
> >On Wed, Feb 03, 2016 at 11:05:57AM -0800, Nikhilesh Reddy wrote:
> >>Hi
> >>Thanks for your review again :)
> >>>
> >>>Uh... how do you know at this point that the file is actually writable?
> >>>Normally, e.g. vfs_write() will ensure that the file is writable, and
> >>>e.g. generic_file_write_iter() won't check for writability as far as I
> >>>can tell. This might allow someone to use the passthrough mechanism to
> >>>overwrite a file he is only allowed to read, but not write, like
> >>>/etc/passwd.
> >>
> >>I considered adding the checks ( the same ones that VFS does)  but not =
sure
> >>if we need to.
> >>So the user will need to construct a fuse filesystem ( that opens for
> >>O_READONLY even though the user asks for a O_RDWR from the FUSE open) a=
nd
> >>then mount it , with CAP_SYS_ADMIN  for which you need to be root but  =
once
> >>he has that he should be able to easily get to the files without needin=
g to
> >>go through FUSE  right using CAP_DAC_OVERRIDE?
> >>
> >>Am i missing something? Please do help me understand.
> >>
> >>But yes if really needed I can add additional checks once i understand =
it
> >
> >On most Linux desktop systems, and on many servers, the userland "fuse"
> >package is installed, which ships with a setuid root helper "fusermount":
> >
> >$ ls -l /bin/fusermount
> >-rwsr-xr-x 1 root root 30800 May 21  2015 /bin/fusermount
> >
> >This setuid helper allows any user to mount FUSE filesystems anywhere he
> >wants. This works as follows: main() calls mount_fuse(), which opens
> >/dev/fuse by calling open_fuse_device(). mount_fuse() then makes sure
> >that the caller has write access to the directory he is about to mount
> >over using check_perm(), then calls mount() via do_mount(). mount_fuse()
> >returns the /dev/fuse fd, which is then sent to the invoker of fusermount
> >through a unix domain socket.
> >
> >(What the setuid binary does control are the mount options; those are
> >used to enforce that the user can't mount filesystems that are
> >accessible for other users.)
> >
> >Note that at no point, any data is sent to or read from the FUSE control
> >fd by fusermount. Therefore, the init reply that is processed in
> >process_init_reply() and determines whether passthrough will be enabled
> >is controlled by the unprivileged caller.
> >
> >This fusermount mechanism is used by pseudo-filesystems like sshfs in
> >order to allow unprivileged users to use them.
> >
> >fusermount aside, there is also an (as far as I know) pending patch with
> >the intent to make FUSE usable in user namespaces, which is going to
> >allow unprivileged users to mount FUSE filesystems even without a
> >userspace helper: https://lkml.org/lkml/2015/12/2/472
> >
> >(Note that this is very different from CUSE, which by design must never
> >be exposed to non-root code.)
>=20
> Thanks for the explanation ..I am convinced :)
>  will add the checks when i send out the next version ( Probably by end of
> the week.. hopefully will be the last version :) :) )
>=20
> Something on the lines of
> if (!(file->f_mode & FMODE_WRITE))
> 	return -EBADF;
> if (!(file->f_mode & FMODE_CAN_WRITE))
> 	return -EINVAL;
>=20
> And
> if (!(file->f_mode & FMODE_READ))
> 	return -EBADF;
> if (!(file->f_mode & FMODE_CAN_READ))
> 	return -EINVAL;
> =09
>=20
> >
> >>>Also, I think this might bypass mandatory locks, the
> >>>security_file_permission hook (which seems like a bad idea anyway
> >>>though), inotify/fsnotify and sb_start_write.
> >>>
> >>Can you please elaborate/clarify further? I am am not sure what you mea=
n.
>=20
> Can you please also explain what you meant by :
> "might bypass mandatory locks, the security_file_permission hook (which
> seems like a bad idea anyway though), inotify/fsnotify and sb_start_write=
=2E"

Have a look at the stuff that goes on in vfs_write:


It checks that FMODE_WRITE is in file->f_mode (to ensure that the file is
open for writing.

It uses rw_verify_area() to check for various things; in particular, it
verifies that nobody else has taken a mandatory lock on the target of
the write operation and that no LSM wishes to prevent the write access
through the file_permission hook.

It uses file_start_write() and file_end_write() to (as far as I can
tell) prevent the filesystem from being frozen (for standby/hibernate)
while a write access is in progress.

It uses fsnotify_modify() to inform userspace that the file changed.


You might want to call one of the vfs helper functions so that you
don't have to do all of this yourself. Something like
vfs_readv/vfs_writev - but I'm not very familiar with this part.

--d6Gm4EdcadzBjdND
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJWsmY8AAoJED4KNFJOeCOolIYQAMYkPGvnSP11cWPIXui8oKFo
il60fuIESg0aVqD+RliWlAOzmtOCA176iOouB2bcwpLdZjXGbjoUV6AzqQGbC1cy
3D2jSg0OMW9izvSj0Shwhh8vpzeCs8LeEm2Khn4RnDzBZr6ZejfQ8rqbYRcRV+jU
dtRIejfNAFUCPrbR37wehbRhvYyEnuyUcv4CtLMzcEBxsjt3VAc8x8eacSRf66od
HLljInvm2XyV7/qcAAr4NYK3d9he39qtIsNnR8GvermhTXUwrLaYlc8F68V2ENH6
FNcFqiJ/4leMjpOv6gsJdLdNUs2Pgt8KL55Ag6imWn7V8SzKIQQEemXovBf2HE3/
Ed5outppZBYdW0npsgpHolA9T6kmlX76vwgkWSvN3nFhB/8BJ832aaUsYt/Hwy7j
Sx3io0vTIPDBLXB1QPI+GnLlfNyTdKdSx1K0p7TGPd9qojzIAM9dGB22oThuzheG
Xrcdi+anVnCksjkVliaQqjhKxVf41Y92j4a87QOp9/nogcIUD8t84IcXCHOhAfRi
JxmCOkCrwF0fB7XPwfIhXSYbxK/ukqwIajtWrG2GogPDCkYSzGlAJ+wVYBR6/NP8
OXGCWhnhLlNIXXakcY5B7Ry9THNjyEtdwqzjPKTDRScGmDVJ0IxrnUT8+WAR5oZJ
Yfty8D2lbPnDPvhLYo5K
=eGWH
-----END PGP SIGNATURE-----

--d6Gm4EdcadzBjdND--
