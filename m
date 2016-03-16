From: Andreas Dilger <adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>
Subject: Re: [PATCH 2/2] block: create ioctl to discard-or-zeroout a range of blocks
Date: Wed, 16 Mar 2016 15:45:49 -0600
Message-ID: <7674C689-C07E-4D38-85EB-4FD9B55CBB35@dilger.ca>
References: <20160311223047.GZ30721@dastard> <20160312003556.GF32214@thunk.org> <CA+55aFyLa0iFFkiVZq-nLH2yWoGzGnv8HB=4R1Xq2PRmjusJ=w@mail.gmail.com> <20160313233049.GA30721@dastard> <56E69398.7030508@redhat.com> <20160314144603.GO29218@thunk.org> <20160315201431.GG30721@dastard> <CA+55aFwHLJffmN-Dw=yZCGKzxe_2Tm9h2GjdaFL3JdvYXNstRw@mail.gmail.com> <20160315223313.GH30721@dastard> <20160315225224.GD23848@thunk.org> <20160316015139.GC5826@birch.djwong.org>
Mime-Version: 1.0 (Mac OS X Mail 9.2 \(3112\))
Content-Type: multipart/signed; boundary="Apple-Mail=_2539A429-1998-47EF-B639-5268E56D2513"; protocol="application/pgp-signature"; micalg=pgp-sha256
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160316015139.GC5826-PTl6brltDGh4DFYR7WNSRA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Ric Wheeler <rwheeler-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, One Thousand Gnomes <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Gregory Farnum <greg-3KCAGdo1P2hBDgjK7y7TUQ@public.gmane.org>, Martin Petersen <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, shane.seymour-ZPxbGqLxI0U@public.gmane.org, Bruce Fields <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>, Eric Sandeen <esandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org


--Apple-Mail=_2539A429-1998-47EF-B639-5268E56D2513
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Mar 15, 2016, at 7:51 PM, Darrick J. Wong <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> =
wrote:
>=20
> On Tue, Mar 15, 2016 at 06:52:24PM -0400, Theodore Ts'o wrote:
>> On Wed, Mar 16, 2016 at 09:33:13AM +1100, Dave Chinner wrote:
>>>=20
>>> Stale data escaping containment is a security issue. Enabling
>>> generic kernel mechanisms to *enable containment escape* is
>>> fundamentally wrong, and relying on userspace to Do The Right Thing
>>> is even more of a gamble, IMO.
>>=20
>> We already have generic kernel mechanisms such as "the block device". =
  P
>>=20
>>> It's a practical concern because if we enable this functionality in
>>> fallocate because it will get used by more than just special storage
>>> apps. i.e. this can't be waved away with "only properly managed
>>> applications will use it" arguments.
>>=20
>> It requires a mount option.  How is this going to allow random
>> applications to use this feature, again?
>>=20
>>> I also don't make a habit of publicising the fact that since we
>>> disabled the "-d unwritten=3DX" mkfs parameter (because of speed =
racer
>>> blogs such as the above and configuration cargo-culting resulting in
>>> unsuspecting users exposing stale data unintentionally) that the
>>> functionality still exists in the kernel code and that it only takes
>>> a single xfs_db command to turn off unwritten extents in XFS. i.e.
>>> we can easily make fallocate on XFS expose stale data, filesystem
>>> wide, without requiring mount options, kernel or application
>>> modifications.
>>=20
>> So you have something even more dangerous in XFS and it's in the
>> kernel tree?  Has Red Hat threatened to have a distro-specific patch
>=20
> xfs_db is the XFS debugger, so you can only enable that bit of =
functionality
> with magical commands, which IMHO isn't much different than people =
messing
> with their ext4 filesystems with debugfs.  You had better know what =
you're
> doing and if you break the filesystem you can eat both pieces. :P
>=20
>> to comment out this code to make sure irresponsible users can't use
>> it?  What I've been suggesting has even more controls that what you
>> have.  And I've been keeping it as an out-of-tree kernel patch mainly
>> because you've been arguing that it's such a horrible thing.
>=20
> One could lock it down even more -- hide it behind a Kconfig option =
that
> depends on CONFIG_EXPERT=3Dy and itself defaults to n, require a mount =
option,
> only allow the file owner to call no-hide-stale and only if the file =
is 0600
> (or the appropriate group equivalents like Ted's existing patch), and =
upon
> adding stale extents, set an inode flag that locks uid/gid/mode/flags.
> Obviously root can still get to the file, but at least there's hard =
evidence
> that one is entering the twilight zone.
>=20
>>> Making Google's hack more widely available through the fallocate
>>> API is entirely dependent on proving that:
>>=20
>> Ceph is about to completely bypass the file system because of your
>> intransigence, and reimplement a userspace file system.  They seem to
>> believe it's necessary.  I'll let them make the case, because they
>> seem to think it's necessary.  And if not, if Linus sides with you,
>> and doesn't want to take the patch, I'll just keep it as a
>> Google-specific out-of-tree patch.  I don't *need* to have this thing
>> upstream.
>=20
> Frankly, I second Eric Sandeen's comments -- just how bad is ext4's
> unwritten extent conversion for these folks?
>=20
> I ran this crappy looping microbenchmark against a ramdisk:
> 	fallocate 400M
> 	write 400M
> 	fsync
> 	rewrite the 400M
> 	fsync
> on kernel 4.5.
>=20
> For writing 400M through the page cache in 4k chunks,
> ext4: ~460MB/s -> ~580MB/s (~20%)
> XFS: ~660 -> ~870 (~25%)
> btrfs: ~130 -> ~200 (~35%)
>=20
> For writing 400M in 80M chunks,
> ext4: ~480MB/s -> ~720MB/s (~30%)
> XFS: ~1GB/s -> ~1.5GB/s (~35%)
> btrfs: ~590MB/s -> ~590MB/s (no change)
>=20
> For directio writing 400MB in 4k chunks,
> ext4: 25MB/s -> 26MB/s (~5%)
> XFS: 25 -> 27 (~8%)
> btrfs: 22 -> 18 (...)
>=20
> For directio writing 1200MB in 80M chunks,
> ext4: ~2.9GB/s -> ~3.3GB/s (~13%)
> XFS: 3.2 -> 3.5 (~9%)
> btrfs: 2.3 -> 2.2 (...)
>=20
> Clearly, the performance hit of unwritten extent conversion is large
> enough to tempt people to ask for no-hide-stale.  But I'd rather hear
> that directly from a developer, Ceph or otherwise.

I suspect that this gets significantly worse if you are running with
random writes instead of sequential overwrites.  With sequential =
overwrites
there is only a single boundary between init and uninit extents, so at
most one extra extent in the tree.  The above performance deltas will =
also
be much larger when real disks are involved and seek latency is a =
factor.

If you are doing random writes in a large file, then there may be many
thousands or millions of new extents and tree splits because the large
uninit extents from fallocate() need to be converted to init extents in
a piecemeal fashion.


We might consider tricks to optimize this somewhat for ext4, such as
limiting the uninit extent size below the init extent size (e.g. 1/2)
so that if such extent splits happen we can get a bunch of extent splits
in one leaf without having to also reshuffle the extent tree.  We =
already
ensure that there is a minimum uninit->init extent conversion size
(64KB IIRC?) so that we don't get pathological 4KB init/uninit extent
interleaving.  As all of the extents become initialized and merge we
can reduce the tree depth, but at least could avoid the worst case
scenarios.  However, I still suspect there would be a big overhead
from doing conversion under such a workload.

Cheers, Andreas

> In the meantime, please have a look at the v7 blockdev fallocate =
patches,
> which implement only the "you can read zeroes afterwards" commands.
>=20
> --D
>=20
>>=20
>> 			    	      	    	   - Ted
>> --
>> To unsubscribe from this list: send the line "unsubscribe =
linux-fsdevel" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe =
linux-fsdevel" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas






--Apple-Mail=_2539A429-1998-47EF-B639-5268E56D2513
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBVunUDnKl2rkXzB/gAQiilw/+MCf24wX0rnGA3WAUJOUeQs/43IF4t3t+
6oXQ7hJH8UcGNp95JZIMptaSgAQFPxnd1PPk+yPY6tt40hz/uYewp30Z0b/R23EY
675oWUOopja4xvbUkbODZxrTpIFRbvOrIyvIqsmM2T6TI7fBzLu5NnQ3lsaw3iLP
Tuf6r022AkIcb7kWHHVQF9QFF0WHMON2MMKZD3B90gGhf0ia3NPy+P12i4SljsqA
MCcGVO4bqjfH5bi11ohf/nee4WSUTTgF1SyoIx4vYSh+x930h0mqZzObp4wuTmGd
ARKG0cvGvoNTDOSk5uY/KSrCNcu5tz561v2pdZqbHxOETqiejNV2z5DZ3kyu7Ix8
LuM+MBiqWkYpweVDX+dxDc97UokZYotCJELt5/izB1PiCAnAQn0TkQgXcD5dxI53
cBTb7baTk2C3x0j9yy+VEni20jHAgCNXFx0HTWg+1cqAqhCKDxggNvWaY/TpxBZL
286N3+fASOYnOpqrrTFmBuR/mED+Ak3cJGrkUJOXyDl1BT4iTbL2NPjkFlqZsh0W
tKmNrjqKUX7hOkKoV4shUylFR6RGHOw5yqnPfi5W/bmuoKqk/ddmUggpfWoGMvK7
cH++FgaIqt35jQV714WwCv0vuPGi2cGAM9DvGO4MQqqrg0+uVZruZ3cVlfXFrd4H
WVewfUf9vkI=
=bC30
-----END PGP SIGNATURE-----

--Apple-Mail=_2539A429-1998-47EF-B639-5268E56D2513--
