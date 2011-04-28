From: Andrea Righi <andrea@betterlinux.com>
Subject: Re: [PATCH v2] fadvise: introduce POSIX_FADV_DONTNEED_FS
Date: Thu, 28 Apr 2011 11:35:42 +0200
Message-ID: <20110428093542.GB2517@linux.develer.com>
References: <1303928027-5100-1-git-send-email-andrea@betterlinux.com>
 <BANLkTinG+ooNRH-VUjKdaHixbGCwk5XoXA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <BANLkTinG+ooNRH-VUjKdaHixbGCwk5XoXA@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Mike Frysinger <vapier@gentoo.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Dave Chinner <david@fromorbit.com>, Al Viro <viro@zeniv.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, Apr 27, 2011 at 02:25:17PM -0400, Mike Frysinger wrote:
> On Wed, Apr 27, 2011 at 14:13, Andrea Righi wrote:
> > Introduce a new fadvise flag to drop page cache pages of a single
> > filesystem.
> >
> > At the moment it is possible to drop page cache pages via
> > /proc/sys/vm/drop_pagecache or via posix_fadvise(POSIX_FADV_DONTNEED).
> >
> > The first method drops the whole page cache while the second can be used
> > to drop page cache pages of a single file descriptor. However, there's
> > not a simple way to drop all the pages of a filesystem (we could scan
> > all the file descriptors and use posix_fadvise(POSIX_FADV_DONTNEED), but
> > this solution obviously doesn't scale well).
> 
> what if you open the mount point and use POSIX_FADV_DONTNEED on that
> dir handle ?  if you required write access for that level, it'd also
> implicitly take care of the permission issue.  but maybe this is just
> trying to fit existing code in the wrong way.
> -mike

I still prefer the capability check. I think it's much more simple from
the userspace point of view to be able to specify any file or directory
instead of being forced to retrieve the mountpoint.

However, an advantage with the approach you're proposing is that a
non-privileged user can drop the page cache of a filesystem if it has
write permission in the root of that filesystem.

mmmh.. I don't see big problems also with the interface you propose, if
you all think it's better I can implement this in the next version.

Thanks,
-Andrea
