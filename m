From: "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v5 0/2] man-pages: document reflink/dedupe ioctls
Date: Tue, 15 Mar 2016 09:48:04 -0700
Message-ID: <20160315164804.30909.83270.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi all,

This patch set goes along with the fifth revision of an RFC adding to
XFS kernel support for tracking reverse-mappings of physical blocks to
file and metadata; and support for mapping multiple file logical
blocks to the same physical block, more commonly known as reflinking.

The two patches in this series document the clone, clone_range, and
dedupe ioctls in the form of man pages.

The patch set is based on a whole pile of proposed patches against the
current (4.5) upstream kernel; the ioctls are simply hoisted version
of the private btrfs ioctls.

Comments and questions are, as always, welcome.

--D
