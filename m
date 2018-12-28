From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [Qemu-devel] d_off field in struct dirent and 32-on-64 emulation
Date: Thu, 27 Dec 2018 17:23:28 -0700
Message-ID: <9C6A7D45-CF53-4C61-B5DD-12CA0D419972@dilger.ca>
References: <87bm56vqg4.fsf@mid.deneb.enyo.de>
 <CAFEAcA92m4vhzjJ+B=mP_o6Wfhx1XSKo3uWxah3osh=u5UXFuw@mail.gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_6F3080DD-1C91-40F7-84C8-6E083D782885";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAFEAcA92m4vhzjJ+B=mP_o6Wfhx1XSKo3uWxah3osh=u5UXFuw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Maydell <peter.maydell@linaro.org>
Cc: Florian Weimer <fw@deneb.enyo.de>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Ext4 Developers List <linux-ext4@vger.kernel.org>, lucho@ionkov.net, libc-alpha@sourceware.org, Arnd Bergmann <arnd@arndb.de>, ericvh@gmail.com, hpa@zytor.com, lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>, QEMU Developers <qemu-devel@nongnu.org>, rminnich@sandia.gov, v9fs-developer@lists.sourceforge.net
List-Id: linux-api@vger.kernel.org


--Apple-Mail=_6F3080DD-1C91-40F7-84C8-6E083D782885
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Dec 27, 2018, at 10:41 AM, Peter Maydell <peter.maydell@linaro.org> =
wrote:
>=20
> On Thu, 27 Dec 2018 at 17:19, Florian Weimer <fw@deneb.enyo.de> wrote:
>> We have a bit of an interesting problem with respect to the d_off
>> field in struct dirent.
>>=20
>> When running a 64-bit kernel on certain file systems, notably ext4,
>> this field uses the full 63 bits even for small directories (strace =
-v
>> output, wrapped here for readability):
>>=20
>> getdents(3, [
>>  {d_ino=3D1494304, d_off=3D3901177228673045825, d_reclen=3D40, =
d_name=3D"authorized_keys", d_type=3DDT_REG},
>>  {d_ino=3D1494277, d_off=3D7491915799041650922, d_reclen=3D24, =
d_name=3D".", d_type=3DDT_DIR},
>>  {d_ino=3D1314655, d_off=3D9223372036854775807, d_reclen=3D24, =
d_name=3D"..", d_type=3DDT_DIR}
>> ], 32768) =3D 88
>>=20
>> When running in 32-bit compat mode, this value is somehow truncated =
to
>> 31 bits, for both the getdents and the getdents64 (!) system call (at
>> least on i386).
>=20
> Yes -- look for hash2pos() and friends in fs/ext4/dir.c.
> The ext4 code in the kernel uses a 32 bit hash if (a) the kernel
> is 32 bit (b) this is a compat syscall (b) some other bit of
> the kernel asked it to via the FMODE_32BITHASH flag (currently only
> NFS does that I think).
>=20
> As you note, this causes breakage for userspace programs which
> need to implement an API/ABI with 32-bit offset but which only
> have access to the kernel's 64-bit offset API/ABI.

This is (IMHO) a bit of an oxymoron, isn't it?  Applications using
the 64-bit API, but storing the value in a 32-bit field?  The same
problem would exist for filesystems with 64-bit inodes or 64-bit
file offsets trying to store these values in 32-bit variables.
It might work most of the time, but it can also break randomly.

> I think the best fix for this would be for the kernel to either
> (a) consistently use a 32-bit hash or (b) to provide an API
> so that userspace can use the FMODE_32BITHASH flag the way
> that kernel-internal users already can.

It would be relatively straight forward to add a "32bitapi" mount
option to return a 32-bit directory hash to userspace for operations
on that mountpoint (ext4 doesn't have 64-bit inode numbers yet).
However, I can't think of an easy way to do this on a per-process
basis without just having it call the 32-bit API directly.

> I couldn't think of or find any existing way for userspace
> to get the right results here, which is why
> 32-bit-guest-on-64-bit-host QEMU doesn't work on these filesystems
> (depending on what exactly the guest's libc etc do).
>=20
>> the 32-bit getdents system call emulation in a 64-bit qemu-user
>> process would just silently truncate the d_off field as part of
>> the translation, not reporting an error.
>> [...]
>> This truncation has always been a bug; it breaks telldir/seekdir
>> at least in some cases.
>=20
> Yes; you can't fit a quart into a pint pot, so if the guest
> only handles 32-bit offsets then truncation is about all we
> can do. This works fine if offsets are offsets, assuming the
> directory isn't so enormous it would have broken the guest
> anyway. I'm not aware of any issues with this other than the
> oddball ext4 offsets-are-hashes situation -- could you expand
> on the telldir/seekdir issue? (I suppose we should probably
> make QEMU's syscall emulation layer return "no more entries"
> rather than entries with truncated hashes.)

For ext4 at least, you could just shift the high 32-bit part of
the 64-bit hash down into a 32-bit value in telldir(), and
shift it back up when seekdir() is called.

Cheers, Andreas






--Apple-Mail=_6F3080DD-1C91-40F7-84C8-6E083D782885
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEDb73u6ZejP5ZMprvcqXauRfMH+AFAlwlbQEACgkQcqXauRfM
H+DTmRAAtE1K8llCpAAh6pb9XLbHF5UY+Ku7sXMR9kxGgLgoV2aU7jgT/kPCwR+p
wHucd80Rfr4pA57R7H53zrUZ23p4yY+vYil+TMYp17KOb0YoO6QJHI93D9dta7sg
hV0+v1Xf1BpEfhtEhAj3WGgsPVE5rvCQDCGABF/ZmiN6/nLRIe73LaJbdxVdCh4G
bTsX8V+oaEvR0GEzjoGwoXB2id8RemUWX6Md7gWUdmmNDeF5Ic11YYqvX/R83F/r
JGgqh5P4p9L/LbbfYDIBVMX+VHZTaUrE45OeULR6dPP9I//zk57NWB2fjTLEyUVL
VMTxU7l4SNBGIXkaRiE/mwe8cWRpM4aIZOT3UVId7f4Urjk3n/92GQ3dHK4b7rda
YeOff8Cgni60CSXw6kjzaivSwce2DM3hWpwKRITS9+ast+Av6X/VcrmETCKQ5Orx
Vt7kh9O8+RjApPBPTpB45e23439pKbv4oiPWG9vyLQjkO00R6KzVnYRXyy5XHH/g
julO83BrEcmA2/ZyK6yp49AbUdRcxNxarx/YbphtyOBKrmnjMa5lD8clnickveHO
A3GWDZwA2T1zH+ymZK5K4QdlFjDMg7RE95P9mQYFdV6k3rWhD4OVr2dVvZ7t+ZET
whSDJ7dvGGG1j0Px27FsUhhXCHnD20j0TvyOyxAr7oj/1e+Utrg=
=JCC9
-----END PGP SIGNATURE-----

--Apple-Mail=_6F3080DD-1C91-40F7-84C8-6E083D782885--
