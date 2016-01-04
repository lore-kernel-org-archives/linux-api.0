From: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Subject: lazytime implementation questions
Date: Mon, 4 Jan 2016 17:22:19 +1100
Message-ID: <20160104062219.GB19802@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org
Cc: ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi folks,

I've been looking at implementing the lazytime mount option for XFS,
and I'm struggling to work out what it is supposed to mean.

AFAICT, on ext4, lazytime means that pure timestamp updates are not
journalled and they are only ever written back when the inode is
otherwise dirtied and written, or they are timestamp dirty for 24
hours which triggers writeback.

This poses a couple of problems for XFS:

	1. we log every timestamp change, so there is no mechanism
	   for delayed/deferred update.

	2. we track dirty metadata in the journal, not via the VFS
	   dirty inode lists, so all the infrastructure written for
	   ext4 to do periodic flushing is useless to us.

These are solvable problems, but what I'm not sure about is exactly
what the intended semantics of lazytime durability are. That is,
exactly what guaranteed are we giving userspace about timestamp
updates when lazytime is used? The guarantees we have to give will
greatly influence the XFS implementation, so I really need to nail
down what we are expected to provide userspace. Can we:

	a) just ignore all durability concerns?
	b) if not, do we only need to care about the 24 hour
	   writeback and unmount?
	c) if not, are fsync/sync/syncfs/freeze/unmount supposed
	   to provide durability of all metadata changes?
	d) do we have to care about ordering - if we fsync one inode
	   with 1 hour old timestamps, do we also need to guarantee
	   that all the inodes with older dirty timestamps also get
	   made durable?

I really want to completely ignore all ordering and forced
durability requirements for lazytime (i.e. implement only periodic,
optimistic and freeze/unmount writeback), but I haven't found any
documentation of what durability lazytime is supposed to provide and
can really only guess what was intended from the ext4
implementation....

Clarity would be appreciated.

Cheers,

Dave.
-- 
Dave Chinner
david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org
