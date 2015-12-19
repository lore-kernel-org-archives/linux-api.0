From: "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [RFCv4 0/2] man-pages: document reflink/dedupe ioctls
Date: Sat, 19 Dec 2015 00:56:07 -0800
Message-ID: <20151219085607.12660.75196.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi all,

This patch set goes along with the fourth revision of an RFC adding to
XFS kernel support for tracking reverse-mappings of physical blocks to
file and metadata; and support for mapping multiple file logical
blocks to the same physical block, more commonly known as reflinking.

The two patches in this series document the clone, clone_range, and
dedupe ioctls in the form of man pages.

The patch set is based on a whole pile of proposed patches against the
current (4.4-rc5) upstream kernel; the ioctls are simply hoisted
version of the private btrfs ioctls.

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
