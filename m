From: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Subject: Re: [PATCH v1 0/8] VFS: In-kernel copy system call
Date: Mon, 14 Sep 2015 09:25:29 +1000
Message-ID: <20150913232529.GT26895@dastard>
References: <1441397823-1203-1-git-send-email-Anna.Schumaker@Netapp.com>
 <55EEFCEE.5090000@draigBrady.com>
 <55EF279B.3020101@Netapp.com>
 <CALCETrXxRB-LXVb+=nkwfj0zEjWuXXTctkSAc9Oec0fgyOQ5Yg@mail.gmail.com>
 <55EF3EFD.3080302@draigBrady.com>
 <20150908212907.GD30681@birch.djwong.org>
 <CALCETrWAotvN+MBsxq4QLQBr_WAyydqMnipcaTM88rM8sSx43w@mail.gmail.com>
 <20150908223959.GE30681@birch.djwong.org>
 <CALCETrVsWBdqvAgwxHcG=gbcWRNPG2ZziWUg1g=siKDrDu7S2Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALCETrVsWBdqvAgwxHcG=gbcWRNPG2ZziWUg1g=siKDrDu7S2Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, =?iso-8859-1?Q?P=E1draig?= Brady <P@draigbrady.com>, Anna Schumaker <Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux btrfs Developers List <linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Zach Brown <zab-ugsP4Wv/S6ZeoWH0uzbU5w@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Chris Mason <clm-b10kYP2dOMg@public.gmane.org>, Michael Kerrisk-manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, andros-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Coreutils <coreutils-mXXj517/zsQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Sep 08, 2015 at 04:08:43PM -0700, Andy Lutomirski wrote:
> Can we have a clean way to figure out whether two file ranges are the
> same in a way that allows false negatives?  I.e. return 1 if the
> ranges are reflinks of each other and 0 if not?  Pretty please?  I've
> implemented that in the past on btrfs by syncing the ranges and then
> comparing FIEMAP output, but that's hideous.

That fundamentally doesn't work for userspace, because the moment
the filesystem drops it's locks on the inodes in the kernel after
doing the comparison the mappings can change.  IOWs, by the time the
information gets back to userspace, it's already wrong. e.g. cp made
this mistake by trying to use FIEMAP to optimise hole detection in
files and ended up with corrupt copies.

It really doesn't matter what the syscall/ioctl interface is, trying
to make application logic decisions based on inode block mappings
from userspace is racy and not safe and will go wrong...

Cheers,

Dave.
-- 
Dave Chinner
david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org
