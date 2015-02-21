From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Documenting MS_LAZYTIME
Date: Fri, 20 Feb 2015 21:56:36 -0500
Message-ID: <20150221025636.GB7922@thunk.org>
References: <CAHO5Pa0k7QkV_6BDjwTVxa7LV9tFyN9nGFFcSvOC6HYO08wfrw@mail.gmail.com>
 <54E7578E.4090809@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-btrfs-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <54E7578E.4090809@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>, Ext4 Developers List <linux-ext4@vger.kernel.org>, Linux btrfs Developers List <linux-btrfs@vger.kernel.org>, XFS Developers <xfs@oss.sgi.com>, linux-man@vger.kernel.org, Linux-Fsdevel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Fri, Feb 20, 2015 at 09:49:34AM -0600, Eric Sandeen wrote:
> 
> >               This mount option significantly reduces  writes  to  the
> >               inode  table  for workloads that perform frequent random
> >               writes to preallocated files.
> 
> This seems like an overly specific description of a single workload out
> of many which may benefit, but what do others think?  "inode table" is also
> fairly extN-specific.

How about somethign like "This mount significantly reduces writes
needed to update the inode's timestamps, especially mtime and actime.
Examples of workloads where this could be a large win include frequent
random writes to preallocated files, as well as cases where the
MS_STRICTATIME mount option is enabled."?

(The advantage of MS_STRICTATIME | MS_LAZYTIME is that stat system
calls will return the correctly updated atime, but those atime updates
won't get flushed to disk unless the inode needs to be updated for
file system / data consistency reasons, or when the inode is pushed
out of memory, or when the file system is unmounted.)

						- Ted
