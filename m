From: David Disseldorp via Linux-f2fs-devel
 <linux-f2fs-devel@lists.sourceforge.net>
Subject: Re: [RFC PATCH 0/6] Allow setting file birth time with
 utimensat()
Date: Fri, 15 Feb 2019 14:57:13 +0100
Message-ID: <20190215145713.33b0748e@samba.org>
References: <cover.1550136164.git.osandov@fb.com>
 <20190214220626.GV14116@dastard> <20190214231429.GE9819@vader>
 <20190215001657.GY14116@dastard> <20190215065947.GG9819@vader>
Reply-To: David Disseldorp <ddiss@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
In-Reply-To: <20190215065947.GG9819@vader>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: Omar Sandoval <osandov@osandov.com>, Samba Technical <samba-technical@lists.samba.org>
Cc: Steve French <sfrench@samba.org>, Theodore Ts'o <tytso@mit.edu>, linux-api@vger.kernel.org, Dave Chinner <david@fromorbit.com>, linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>, kernel-team@fb.com, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, 14 Feb 2019 22:59:47 -0800, Omar Sandoval wrote:

> On Fri, Feb 15, 2019 at 11:16:57AM +1100, Dave Chinner wrote:
> > On Thu, Feb 14, 2019 at 03:14:29PM -0800, Omar Sandoval wrote:  
> > > On Fri, Feb 15, 2019 at 09:06:26AM +1100, Dave Chinner wrote:  
...
> > > > Inode create time is forensic metadata in XFS  - information we use
> > > > for sequence of event and inode lifetime analysis during examination
> > > > of broken filesystem images and systems that have been broken into.
> > > > Just because it's exposed to userspace via statx(), it doesn't mean
> > > > that it is information that users should be allowed to change. i.e.
> > > > allowing users to be able to change the create time on files makes
> > > > it completely useless for the purpose it was added to XFS for...
> > > > 
> > > > And allowing root to change the create time doesn't really help,
> > > > because once you've broken into a system, this makes it really easy
> > > > to cover tracks  
> > > 
> > > If the threat model is that the attacker has root, then they can
> > > overwrite the timestamp on disk anyways, no?  
> > 
> > Modifying the block devicee under an active filesystem is fraught
> > with danger, and there's no guarantee it will work if the metadata
> > being modified is still active in memory. Corrupting the filesystem
> > is a sure way to get noticed....
> >   
> > > > (e.g. we can't find files that were created and
> > > > unlinked during the break in window anymore) and lay false
> > > > trails....  
> > > 
> > > Fair point, although there's still ctime during the break-in window,  
> > 
> > Unless you're smart enough to know how to trigger S_NOCMTIME or
> > FMODE_NOCMTIME....
> >   
> > > which I assume you'd be looking for anyways since files modified during
> > > the break-in window are also of interest.  

I'm not sure I follow the forensics use-case for immutable btime. I'd
expect dm-verity or selinux/apparmor audits to do a better job for those
worried about this kind of attack.

> > ... and then that also can't be guaranteed. :/
> >   
> > > I see a few options, none of which are particularly nice:
> > > 
> > > 1. Filesystems like XFS could choose not to support setting btime even
> > >    if they support reading it.
> > > 2. XFS could add a second, writeable btime which is used for
> > >    statx/utimes when available (it would fit in di_pad2...).
> > > 3. We could add a btime_writable sysctl/mount option/mkfs option.  
> > 
> > 4. create time remains a read-only field, and btrfs grows its own
> > special interface to twiddle it in btrfs-recv if it really is
> > necessary.  
> 
> I'm curious to hear what the ext4/f2fs/CIFS developers think. If no one
> else wants btime to be mutable, then I might as well make it
> Btrfs-specific. That is, assuming we reach consensus on the Btrfs side
> that btrfs receive should set btime.

Samba currently uses a user.DOSATTRIB xattr for tracking creation time.
IMO a mutable btime accessible via statx would be useful for
cross-protocol interoperability.

Cheers, David
