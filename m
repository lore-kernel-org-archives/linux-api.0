From: NeilBrown <neilb-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 2/2] block: create ioctl to discard-or-zeroout a range of blocks
Date: Sat, 19 Mar 2016 09:55:57 +1100
Message-ID: <87d1qre6pu.fsf@notabene.neil.brown.name>
References: <CA+55aFxQOgDjL643J33d-3q7gYGvyN84vCn4qJq-Ox8E-WRx9w@mail.gmail.com> <20160311223047.GZ30721@dastard> <20160312003556.GF32214@thunk.org> <CA+55aFyLa0iFFkiVZq-nLH2yWoGzGnv8HB=4R1Xq2PRmjusJ=w@mail.gmail.com> <20160313233049.GA30721@dastard> <56E69398.7030508@redhat.com> <20160314144603.GO29218@thunk.org> <20160315201431.GG30721@dastard> <CA+55aFwHLJffmN-Dw=yZCGKzxe_2Tm9h2GjdaFL3JdvYXNstRw@mail.gmail.com> <20160315223313.GH30721@dastard> <20160315225224.GD23848@thunk.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160315225224.GD23848-AKGzg7BKzIDYtjvyW6yDsg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Ric Wheeler <rwheeler-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, One Thousand Gnomes <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Gregory Farnum <greg-3KCAGdo1P2hBDgjK7y7TUQ@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, shane.seymour-ZPxbGqLxI0U@public.gmane.org, Bruce Fields <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>, Eric Sandeen <esandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 16 2016, Theodore Ts'o wrote:

> On Wed, Mar 16, 2016 at 09:33:13AM +1100, Dave Chinner wrote:
>>=20
>> Stale data escaping containment is a security issue. Enabling
>> generic kernel mechanisms to *enable containment escape* is
>> fundamentally wrong, and relying on userspace to Do The Right Thing
>> is even more of a gamble, IMO.
>
> We already have generic kernel mechanisms such as "the block device".   P

This is a bit of an 'off-the-wall' suggestion, but I agree that these
things that might be of value to user-space file servers do seem a lot
like block devices.  So why not make them look exactly like block
devices?

i.e. a new open flag O_BLOCKDEV which, when combined with O_CREAT
creates a thing that is managed in the filesystem much like a file, but
that appears to user-space like a block device.  The major/minor numbers
would be essentially meaningless - the filesystem wouldn't call
init_special_inode() like it does on normal block devices, it would
retain control itself.

That would make the content invisible to backups and rsync and all the
things that Dave has raised as potential concerns.  And it would be no
surprise if the contents included stale data because that is exactly
what you get when you create a new logical volume with LVM2.

The block device would initially be of size zero, but could be resized
using fallocate (which soon will work on block devices), which can
request zeros, leave holes, or with Teds new FALLOC flag (that would only
be permitted on block devices) could allocate uninitialized space.

Rules for using O_BLOCKDEV would still need to be clarified - mount
option, access to underlying block device, CAP_MKNOD .. whatever.

I think that being able to use a filesystem as a logical volume manager
is an extremely interesting idea.... we might even end up with a
filesystem interface on device-mapper :-)

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJW7Id9AAoJEDnsnt1WYoG5bGQQAJO6XM3jDsxlg/s5y6CmLfnU
yEsFGFdD+7Y9SgCRBrCNKtEXuz44B0SGR6aroJRe3lzqM8JRMJZHVjPGc2o1krw3
qP9RlCNuL2AWTY/G13VFAByqDYGOh7WwQdFakeXM3yLVxMpmscr2bXKoEoexy8mN
6Iv9/TQ6Jow1yW3dAVNTotaeLBrltQ2JUVsgheKEBg88E7c36UY2y9cWLAuqWRws
Nfbn6rJm7qsrXpCHc313f73lVruX1xFSI5GZGdt8lnaTV2upXVWU8UqJSyymODc3
YljZFMOvN2O4peKOjHDsRTcc+JAM/3qqMeIrQrwfCgqEvMl4cN5xQ016MDA6R49g
go0thJ/jTwawCuCg+5zwqMV3tLqtZEggNq30c9XmyQXx+I0jHYJMYGkF9Nf9NfwN
6ujSaLpSj29nABS14AjtXdmAagYosu/fuEP2tb3ghmDjSkoRICPrlnDmPCVYV5eG
x63AINNK5u7h8/MnmHio1ZHu+Z2nxTFDEH1nPusEsXC0K4VXyM7lbxmV8rn4gWbB
bAHxOXehLXpUGVCEZqRV5mWTBaZlvH7F6TeCauZNtNQj9ZCjCOYf1o8LSvtZFPjz
QiqN3SSYNWVBdRr7LGOuIBLxAMsNLpaD5Mm7p8F75k6fzfQV7RI1sQDBGp46VPWq
VkFv2yTMnFuHOuVvqgw/
=EPYc
-----END PGP SIGNATURE-----
--=-=-=--
