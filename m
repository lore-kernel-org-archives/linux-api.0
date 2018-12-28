From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [Qemu-devel] d_off field in struct dirent and 32-on-64 emulation
Date: Fri, 28 Dec 2018 16:16:21 -0700
Message-ID: <1EF1B31A-83D8-4642-BEBF-F56E45485223@dilger.ca>
References: <87bm56vqg4.fsf@mid.deneb.enyo.de>
 <CAFEAcA92m4vhzjJ+B=mP_o6Wfhx1XSKo3uWxah3osh=u5UXFuw@mail.gmail.com>
 <9C6A7D45-CF53-4C61-B5DD-12CA0D419972@dilger.ca>
 <CAFEAcA9W+JK7_TrtTnL1P2ES1knNPJX9wcUvhfLwxLq9augq1w@mail.gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_08DEB4F4-6BEB-4500-881F-7C4F24C62FEB";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Return-path: <libc-alpha-return-98851-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
In-Reply-To: <CAFEAcA9W+JK7_TrtTnL1P2ES1knNPJX9wcUvhfLwxLq9augq1w@mail.gmail.com>
To: Peter Maydell <peter.maydell@linaro.org>
Cc: Florian Weimer <fw@deneb.enyo.de>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Ext4 Developers List <linux-ext4@vger.kernel.org>, lucho@ionkov.net, libc-alpha@sourceware.org, Arnd Bergmann <arnd@arndb.de>, ericvh@gmail.com, hpa@zytor.com, lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>, QEMU Developers <qemu-devel@nongnu.org>, rminnich@sandia.gov, v9fs-developer@lists.sourceforge.net
List-Id: linux-api@vger.kernel.org


--Apple-Mail=_08DEB4F4-6BEB-4500-881F-7C4F24C62FEB
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Dec 28, 2018, at 4:18 AM, Peter Maydell <peter.maydell@linaro.org> =
wrote:
>=20
> On Fri, 28 Dec 2018 at 00:23, Andreas Dilger <adilger@dilger.ca> =
wrote:
>> On Dec 27, 2018, at 10:41 AM, Peter Maydell =
<peter.maydell@linaro.org> wrote:
>>> As you note, this causes breakage for userspace programs which
>>> need to implement an API/ABI with 32-bit offset but which only
>>> have access to the kernel's 64-bit offset API/ABI.
>>=20
>> This is (IMHO) a bit of an oxymoron, isn't it?  Applications using
>> the 64-bit API, but storing the value in a 32-bit field?
>=20
> I didn't say "which choose to store the value in a 32-bit field",
> I said "which have to implement an API/ABI which has 32-bit fields".
> In QEMU's case, we use the host kernel's ABI, which has 64-bit
> offset fields. We implement a syscall ABI for the guest binary
> we are running under emulation, which may have 32-bit offset fields
> (for instance if we are running a 32-bit Arm binary.) Both of
> these ABIs are fixed -- QEMU doesn't have a choice here, it
> just has to make the best effort it can with what the host kernel
> provides it, to provide the semantics the guest binary needs.
> My suggestion in this thread is that the host kernel provides
> a wider range of facilities so that QEMU can do the job it's
> trying to do.
>=20
>> The same
>> problem would exist for filesystems with 64-bit inodes or 64-bit
>> file offsets trying to store these values in 32-bit variables.
>> It might work most of the time, but it can also break randomly.
>=20
> In general inodes and offsets start from 0 and work up --
> so almost all of the time they don't actually overflow.
> The problem with ext4 directory hash "offsets" is that they
> overflow all the time and immediately, so instead of "works
> unless you have a weird edge case" like all the other filesystems,
> it's "never works".
>=20
>>> I think the best fix for this would be for the kernel to either
>>> (a) consistently use a 32-bit hash or (b) to provide an API
>>> so that userspace can use the FMODE_32BITHASH flag the way
>>> that kernel-internal users already can.
>>=20
>> It would be relatively straight forward to add a "32bitapi" mount
>> option to return a 32-bit directory hash to userspace for operations
>> on that mountpoint (ext4 doesn't have 64-bit inode numbers yet).
>> However, I can't think of an easy way to do this on a per-process
>> basis without just having it call the 32-bit API directly.
>=20
> The problem is that there is no 32-bit API in some cases
> (unless I have misunderstood the kernel code) -- not all
> host architectures implement compat syscalls or allow them
> to be called from 64-bit processes or implement all the older
> syscall variants that had smaller offets. If there was a guaranteed
> "this syscall always exists and always gives me 32-bit offsets"
> we could use it.

The "32bitapi" mount option would use 32-bit hash for seekdir
and telldir, regardless of what kernel API was used.  That would
just set the FMODE_32BITHASH flag in the file->f_mode for all files.

Using 32-bit directory hash values is not necessarily harmful, but
it returns the possibility to hit the problem with hash collisions
that previously existed before the move to 64-bit hash values.
This becomes more of a problem as directory sizes increase.

>> For ext4 at least, you could just shift the high 32-bit part of
>> the 64-bit hash down into a 32-bit value in telldir(), and
>> shift it back up when seekdir() is called.
>=20
> Yes, that has been suggested, but it seemed a bit dubious
> to bake in knowledge of ext4's internal implementation details.
> Can we rely on this as an ABI promise that will always work
> for all versions of all file systems going forwards?

Well, the directory cookies need to be relatively stable over
time because they are exported to applications and possibly
remote nodes via NFS, so it can't be changed very much.

Cheers, Andreas






--Apple-Mail=_08DEB4F4-6BEB-4500-881F-7C4F24C62FEB
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEDb73u6ZejP5ZMprvcqXauRfMH+AFAlwmrsUACgkQcqXauRfM
H+BcEQ//QtSwKaRnVgyNL34t9fYOhxAIo5A4AwgxC6dafaNLpFdDCfow3frNBTFj
wtyqIoCmGFa10unoaI1hY+u9gTgs+//zAOtggfvLV3VRHzupxc5g2dILnAo4jVVW
td+CgZamBXFaMrYkTX4gx2rm/9Bc/W0R/1KasC/DXtNQEMrUybwv1x2OMmhx8cfH
fcVcjLbl94JNqfVZLVtCF08sqECh2dvBNWHB95Mfnzy6qEeLyI4VS32ydZ2HEAcB
tkRGukzGn3eDhh3nZl5FiqWEEB5ZYSTE8KIPkZ/h2dCsSZjvW5gB/o6EC7Ig+A80
IuBddSkTF023UmQ6PiGKDr8BmKGYf7lJxa6IYW+2HjT6Vp89XmJSTCdoFRJnFW9z
nKHTA2mFmHZN3L4DAvdMGc3VfXBEHyTw4V1q/Mf37QtP8Z+FSYvAGll22DbMMysl
hlNFqothpjCNcjWpuT22Pu6T9gKLmwSvLYA0cr8C8dYGHt2F8+jbhL7ld5I0kBPA
IGREujjMVKuA46BMrqQ8oL12PrYhAo0HbPvaAvwJ2HHcYtwjuv3bUOc6VgV8oipq
wOFgTk8WAZfHEPQrfSoG5TatNixl58Q+GvBD7S8TS4/hgxaMluhxfw9sqQ6C7SwO
JFVtp2MYJumNd6niFwfR8J52SV3+lIXohPfbccr6LEtvc7fMtIc=
=Hl10
-----END PGP SIGNATURE-----

--Apple-Mail=_08DEB4F4-6BEB-4500-881F-7C4F24C62FEB--
