From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH v2] fadvise: introduce POSIX_FADV_DONTNEED_FS
Date: Wed, 27 Apr 2011 12:47:56 -0600
Message-ID: <20110427184756.GB16716@parisc-linux.org>
References: <1303928027-5100-1-git-send-email-andrea@betterlinux.com> <20110427183308.GA16716@parisc-linux.org> <BANLkTinPTPMWPN+JELtCZDjrVepLetX6FQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <BANLkTinPTPMWPN+JELtCZDjrVepLetX6FQ@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Mike Frysinger <vapier@gentoo.org>
Cc: Andrea Righi <andrea@betterlinux.com>, Andrew Morton <akpm@linux-foundation.org>, Dave Chinner <david@fromorbit.com>, Al Viro <viro@zeniv.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, Apr 27, 2011 at 02:39:53PM -0400, Mike Frysinger wrote:
> > Mmm ... what if I open /dev/sdxyz and call fadvise() on it? ??I think
> > you end up flushing /dev's page cache entries, instead of the filesystem
> > which is on /dev/sdxyz.
> 
> i was thinking of that, but was trying to come up with situations
> where there might not have a node to work on.  fs's in a file go
> through loop devs, dm/lvm have ones created, and flash fs's still have
> a mtd block.  how about network based fs's ?  how you going to signal
> dropping of pages for nfs or cifs or fuse ones ?

For a regular file, mapping->host->i_sb points to the superblock this
file is on.  For a device, mapping->host->i_sb points to the superblock
corresponding to this device.  So it's always what we want.

(hm, what about block devices not currently mounted?  do we need to check
whether mapping->host is NULL?)

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
