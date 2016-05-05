From: "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [RFC 0/3] getfsmapx ioctl
Date: Thu, 5 May 2016 12:47:54 -0700
Message-ID: <20160505194754.GA2785@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Fasheh <mfasheh-l3A5Bk7waGM@public.gmane.org>, Josef Bacik <jbacik-b10kYP2dOMg@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, xfs <xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org>, linux-btrfs <linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-ext4 <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi,

Building on the discussion "Exposing Extent Information to Userspace"
at LSF, this patchset offers the userspace definition, implementation,
and manpages for a new FS_IOC_GETFSMAPX ioctl that enables userspace
to query the filesystem for a map of every extent in a given range of
physical block keyspace.

Note that prior to the existence of block sharing, I'd have said
"given range of physical blocks", but now that we can return multiple
owner:offset pairs for a given block, the block keyspace now has to
include extra fields to uniquely identify a reverse mapping record.

This ioctl behaves in a similar manner to XFS_IOC_GETBMAPX -- pass in
an array of struct getfsmapx with key and other control values in the
first two array elements, and the kernel passes back extent
information in the other array elements.  The particulars of how to do
this are documented in the manpage that goes along with this set (it
applies against man-pages.git) and example code in the other patches
is against xfsprogs.git#for-next.

Basically, set the lowest key for which you want records in the first
array element; the highest key in the second; and the kernel spits out
records in the rest of the elements.  That's similar to how GETBMAPX
does it, but different from FIEMAP.  I added a dummy 64-bit "device
id" per Josef's request, though I'm thinking that could be cut down to
a simple dev_t.  I also wonder if the kernel should rewrite the low
key with the last element returned so as to seed the next call, but
userspace can do that too.

The kernel-space implementation (for XFS) is buried inside the xfs
reverse mapping patchset which is treading water at github[1].  I
prefer not to patchbomb the whole kernel series until I've put the
mess through better testing, but this should be enough to get the
mailing list discussion started.

Questions?  Comments?  Bike sheds?

--D

[1] https://github.com/djwong/linux/tree/djwong-experimental
