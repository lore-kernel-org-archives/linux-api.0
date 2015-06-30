From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH RESEND] Btrfs: add autodefrag inode flag
Date: Wed, 1 Jul 2015 07:45:19 +1000
Message-ID: <20150630214519.GN22807@dastard>
References: <85de09b87ad7b2847ea001f5bb03c044e8b419aa.1435681574.git.osandov@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <85de09b87ad7b2847ea001f5bb03c044e8b419aa.1435681574.git.osandov@fb.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Omar Sandoval <osandov@fb.com>
Cc: linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Tue, Jun 30, 2015 at 09:32:20AM -0700, Omar Sandoval wrote:
> In some cases, we may not want to enable automatic defragmentation for
> the whole filesystem with the "autodefrag" mount option but we still
> want to defragment specific files or directories. Add an inode flag
> which allows us to do specify that.
> 
> Signed-off-by: Omar Sandoval <osandov@fb.com>
> ---
> Resending this because I didn't send it to fsdevel or linux-api last
> time and I'm adding a new user-facing inode flag.

XFS has a "no defrag" inode flag to tell the defragmenter not to
defrag the file. (XFS_XFLAG_NODEFRAG, see xfsctl(3)). With the ext4
project quota work, this flag and interface is being pulled up to
the VFS, so perhaps it would be a good idea to turn this around the
other way?  i.e. autodefrag is the default behaviour, and the inode
contains an inheritable  "no defrag" flag to prevent defrag so that
we have the same flag, API and behaviour across filesystems?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
