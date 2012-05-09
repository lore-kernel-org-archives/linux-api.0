From: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Subject: Re: Extended file stat: Splitting file- and fs-specific info?
Date: Tue, 8 May 2012 21:09:41 -0400
Message-ID: <20120509010941.GC20160@fieldses.org>
References: <20120419140558.17272.74360.stgit@warthog.procyon.org.uk>
 <16281.1336508382@redhat.com>
 <20120509002420.GL5091@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120509002420.GL5091@dastard>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Cc: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org, smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org, Trond.Myklebust-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org, roland-/Z5OmTQCD9xF6kxbq+BtvQ@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, libc-alpha-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, May 09, 2012 at 10:24:20AM +1000, Dave Chinner wrote:
> On Tue, May 08, 2012 at 09:19:42PM +0100, David Howells wrote:
> >=20
> > Should I split the file-specific info and the fs-specific info and =
make the
> > second optional?  What I'm thinking of is something like this:
> >=20
> > Have a file information structure:
> >=20
> > struct statx {
> > 	/* 0x00 */
> > 	uint32_t	st_mask;	/* What results were written */
> > 	uint32_t	st_information;	/* Information about the file */
> > 	uint16_t	st_mode;	/* File mode */
> > 	uint16_t	__spare0[3];
> > 	/* 0x10 */
> > 	uint32_t	st_uid;		/* User ID of owner */
> > 	uint32_t	st_gid;		/* Group ID of owner */
> > 	uint32_t	st_nlink;	/* Number of hard links */
> > 	uint32_t	st_blksize;	/* Optimal size for filesystem I/O */
> > 	/* 0x20 */
> > 	struct statx_dev st_rdev;	/* Device ID of special file */
> > 	struct statx_dev st_dev;	/* ID of device containing file */
> > 	/* 0x30 */
> > 	int32_t		st_atime_ns;	/* Last access time (ns part) */
> > 	int32_t		st_btime_ns;	/* File creation time (ns part) */
> > 	int32_t		st_ctime_ns;	/* Last attribute change time (ns part) */
> > 	int32_t		st_mtime_ns;	/* Last data modification time (ns part) */
> > 	/* 0x40 */
> > 	int64_t		st_atime;	/* Last access time */
> > 	int64_t		st_btime;	/* File creation time */
> > 	int64_t		st_ctime;	/* Last attribute change time */
> > 	int64_t		st_mtime;	/* Last data modification time */
> > 	/* 0x60 */
> > 	uint64_t	st_ino;		/* Inode number */
> > 	uint64_t	st_size;	/* File size */
> > 	uint64_t	st_blocks;	/* Number of 512-byte blocks allocated */
> > 	uint64_t	st_gen;		/* Inode generation number */
>=20
> I don't think we want to expose the inode generation numbers. It is
> trivial to construct NFS file handles (usually just fsid, inode
> number and generation) with that information and hence bypass
> security checks to access files.

I'm not convinced there's much value in trying to keep filehandles
secret.

If you're going to base your security on a secret, then it should be
hard to guess, easy to keep secret, and changeable in case it ever does
get out.

=46ilehandles are pretty easy to guess (even without help like this), t=
hey
usually go over the wire in cleartext, and they can't be changed.

--b.

>=20
> > 	uint64_t	st_version;	/* Data version number */
> > 	uint64_t	st_ioc_flags;	/* As FS_IOC_GETFLAGS */
> > 	/* 0x90 */
> > 	uint64_t	__spare1[13];	/* Spare space for future expansion */
> > 	/* 0x100 */
> > };
> >=20
> > And an fs information structure for less commonly needed data:
> >=20
> > struct statx_fsinfo {
> > 	/* 0x00 - General info */
> > 	uint32_t	st_mask;	/* What optional fields are filled in */
> > 	uint32_t	st_type;	/* Filesystem type from linux/magic.h */
> >=20
> > 	/* 0x08 - file timestamp granularity info */
> > 	uint16_t	st_atime_gran_mantissa;	/* gran(secs) =3D mant * 10^exp *=
/
> > 	uint16_t	st_btime_gran_mantissa;
> > 	uint16_t	st_ctime_gran_mantissa;
> > 	uint16_t	st_mtime_gran_mantissa;
> > 	/* 0x10 */
> > 	int8_t		st_atime_gran_exponent;
> > 	int8_t		st_btime_gran_exponent;
> > 	int8_t		st_ctime_gran_exponent;
> > 	int8_t		st_mtime_gran_exponent;
> >=20
> > 	/* 0x14 - I/O parameters */
> > 	uint32_t	st_blksize;	  /* File block size */
> > 	uint32_t	st_alloc_blksize; /* Allocation block size/alignment */
> > 	uint32_t	st_small_io_size; /* IO size/alignment that avoids fs/pag=
e cache RMW */
> > 	uint32_t	st_pref_io_size;  /* Preferred IO size for general usage =
*/
> > 	uint32_t	st_large_io_size; /* IO size/alignment for high bandwidth=
 sequential IO */
>=20
> That's per file information, not per filesystem. XFS definitely
> needs this IO information per-file....
>=20
> >=20
> > 	/* 0x28 - Restrictions on struct statx contents */
> > 	uint64_t	st_supported_ioc_flags; /* FS_IOC_GETFLAGS flags supporte=
d  */
> >=20
> > 	/* 0x30 - Volume/filesystem information */
> > 	uint64_t	st_fsid;	/* Short 64-bit Filesystem ID (as statfs) */
> > 	uint64_t	__spare0[3];
> > 	/* 0x50 */
> > 	uint8_t		st_volume_id[16]; /* Volume/fs identifier */
> > 	uint8_t		st_volume_uuid[16]; /* Volume/fs UUID */
>=20
> And there's all the remaining information needed to construct file
> NFS handles without root priviledges...
>=20
> > 	/* 0x80 */
> > 	uint64_t	__spare1[8];
> > 	/* 0xc0 */
> > 	uint8_t		st_volume_name[64]; /* Volume name (up to 64 chars) */
> > 	/* 0x100 */
> > 	uint8_t		st_domain_name[256]; /* Domain/cell/workgroup name (up to=
 256 chars) */
> > 	/* 0x200 */
> > };
> >=20
> > One could argue a bit over what goes in which, should we go for thi=
s.  This
> > may be better split between multiple syscalls though (with the race=
 that that
> > implies) and potentially merging with statfs.
> >=20
> >=20
> > The statxat() syscall [n=C3=A9e xstat] could then use the 6th param=
eter thusly:
> >=20
> > asmlinkage long sys_statxat(int dfd, const char __user *path, unsig=
ned flags,
> > 			    unsigned mask, struct statx __user *buffer,
> > 			    struct statx_fsinfo __user *fsinfo);
> >=20
> >=20
> > letting fsinfo be NULL to indicate a lack of interest.  I'm not sur=
e we want
> > to do that, though.
> >=20
> >=20
> > Also, do Dave Chinner's ideas for indicating five I/O parameters wa=
nt to be
> > 32-bit numbers?  Larger?  Smaller?  Can they be log2?
>=20
> Definitely 32 bit, IMO, as it's not uncommon to see optimal IO sizes
> in the tens of megabytes on large, high bandwidth storage systems.
> As for being log2 - that's just making it more complex to use and
> making code ugly - we'd have to convert to log2 in kernel, then
> convert back in every single application....
>=20
> > Note also, that I've suggested that we represent the timestamp gran=
ularity
> > information as a decimal float (which requires 3 bytes per timestam=
p) and that
> > we provide separate granularities for each timestamp.
> >=20
> > David
> >=20
>=20
> --=20
> Dave Chinner
> david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org
