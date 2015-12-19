From: "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [RFCv4 0/9] vfs: hoist reflink/dedupe ioctls to the VFS
Date: Sat, 19 Dec 2015 00:55:05 -0800
Message-ID: <20151219085505.12478.71157.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org, darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi all,

This patch set goes along with the fourth revision of an RFC adding to
XFS kernel support for tracking reverse-mappings of physical blocks to
file and metadata; and support for mapping multiple file logical
blocks to the same physical block, more commonly known as reflinking.

The first four patches are taken verbatim from Anna Schumaker's
patches adding a physical copy call to the kernel.  The next two
patches are from Christoph Hellwig, and hoist the clone and
clone_range ioctls into the VFS.  These patches are a bit old at
this point; they're in here solely to demonstrate how this (long)
patchset diverges from upstream.

The third patch fixes some bugs in the first four patches, and the
fourth patch hoists the extent_same ioctl into the VFS as the dedupe
ioctl.

The patch set is based on the current (4.4-rc5) upstream kernel.

If you're going to start using this mess, you probably ought to just
pull from my github trees for kernel[1], xfsprogs[2], and xfstests[3].
See also the xfs-docs[4] and manpage[5] updates.

This is an extraordinary way to eat your data.  Enjoy!

Comments and questions are, as always, welcome.

--D

[1] https://github.com/djwong/linux/tree/for-dave
[2] https://github.com/djwong/xfsprogs/tree/for-dave
[3] https://github.com/djwong/xfstests/tree/for-dave
[4] https://github.com/djwong/xfs-documentation/tree/for-dave
[5] https://github.com/djwong/man-pages/commits/for-mtk
