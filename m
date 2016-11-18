From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 1/4] statx: Add a system call to make enhanced file info available [ver #2]
Date: Fri, 18 Nov 2016 17:57:55 +0100
Message-ID: <2756474.23HNgnMOUG@wuerfel>
References: <147948603103.5122.1043337990092830185.stgit@warthog.procyon.org.uk> <147948603812.5122.5116851833739815967.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <147948603812.5122.5116851833739815967.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Friday, November 18, 2016 4:20:38 PM CET David Howells wrote:
> Add a system call to make extended file information available, including
> file creation and some attribute flags where available through the
> underlying filesystem.

Looks great!

Is there still hope of scheduling this for v4.10, or are you
planning it for v4.11 at this point?

> ========
> OVERVIEW
> ========
> 
> The idea was initially proposed as a set of xattrs that could be retrieved
> with getxattr(), but the general preferance proved to be for a new syscall
> with an extended stat structure.
> 
> This has a number of uses:
...
> 
> Note that not all of the above are implemented here.

It's good to have the whole list of possible features here, but
the list of features that are actually implemented is probably
more important for the changelog. You seem to have that list
in the introductory mail but not in the actual patch.


> -       stat->atime = inode->i_atime;
> 
>         stat->mtime = inode->i_mtime;
>         stat->ctime = inode->i_ctime;
> 
> -       stat->blksize = (1 << inode->i_blkbits);
> +       stat->size = i_size_read(inode);
> 
>         stat->blocks = inode->i_blocks;
> 
> -}
> +       stat->blksize = 1 << inode->i_blkbits;
> 
> +       stat->result_mask |= STATX_BASIC_STATS;
> +       if (IS_NOATIME(inode))
> +               stat->result_mask &= ~STATX_ATIME;
> +       else
> +               stat->atime = inode->i_atime;

This looks like you are changing the behavior of the existing
stat call to no longer return the atime from the on-disk
inode if NOATIME is set.

Is my interpretation correct, and is this an intentional
change?

	Arnd
