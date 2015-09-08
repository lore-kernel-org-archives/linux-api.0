From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v1 0/8] VFS: In-kernel copy system call
Date: Tue, 8 Sep 2015 13:45:17 -0700
Message-ID: <20150908204517.GC30681@birch.djwong.org>
References: <1441397823-1203-1-git-send-email-Anna.Schumaker@Netapp.com>
 <4B41043F-5D85-42D6-8F20-2DCC45930EF4@dilger.ca>
 <20150905083342.GG22011@ZenIV.linux.org.uk>
 <55EEF9D3.6050505@Netapp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-btrfs-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <55EEF9D3.6050505@Netapp.com>
Sender: linux-btrfs-owner@vger.kernel.org
To: Anna Schumaker <Anna.Schumaker@netapp.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Andreas Dilger <adilger@dilger.ca>, linux-nfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, zab@zabbo.net, clm@fb.com, mtk.manpages@gmail.com, andros@netapp.com, hch@infradead.org
List-Id: linux-api@vger.kernel.org

On Tue, Sep 08, 2015 at 11:08:03AM -0400, Anna Schumaker wrote:
> On 09/05/2015 04:33 AM, Al Viro wrote:
> > On Fri, Sep 04, 2015 at 04:25:27PM -0600, Andreas Dilger wrote:
> > 
> >> This is a bit of a surprising result, since in my testing in the
> >> past, copy_{to/from}_user() is a major consumer of CPU time (50%
> >> of a CPU core at 1GB/s).  What backing filesystem did you test on?
> > 
> > While we are at it, was cp(1) using read(2)/write(2) loop or was it using
> > something else (sendfile(2), for example)?
> 
> cp uses a read / write loop, and has some heuristics for guessing an optimum buffer size.

..but afaict cp doesn't fsync at the end, which means it's possible that
the destination file's blocks are still delalloc and nothing's been flushed
to disk yet.  What happens if you time (cp /tmp/a /tmp/b ; sync) ?

2048M / 1.667s = ~1200MB/s.

--D

> 
> Anna
> 
> > 
> 
