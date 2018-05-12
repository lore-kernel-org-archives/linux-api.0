From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/2 V2] hoist BTRFS_IOC_[SG]ET_FSLABEL to vfs
Date: Fri, 11 May 2018 17:20:49 -0700
Message-ID: <20180512002049.GH9510@magnolia>
References: <d2979d75-5e45-b145-9ca5-2c315d8ead9c@redhat.com>
 <b8c7feca-68ce-b1a8-3a96-a99b50457a84@sandeen.net>
 <4a4f33c3-2173-9795-f4e4-1e9d338fd9a7@sandeen.net>
 <20180510191608.GR30522@ZenIV.linux.org.uk>
 <20180511141017.GZ6649@twin.jikos.cz>
 <9F0DCA90-AD82-4179-B50A-F112CF966CCB@fb.com>
 <94b5a947-d7f5-19e7-fb2b-161a5c20e85e@sandeen.net>
 <20180511144145.GA6649@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-btrfs-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180511144145.GA6649@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
To: dsterba@suse.cz, Eric Sandeen <sandeen@sandeen.net>, Chris Mason <clm@fb.com>, Al Viro <viro@ZenIV.linux.org.uk>, Eric Sandeen <sandeen@redhat.com>, fsdevel <linux-fsdevel@vger.kernel.org>, linux-btrfs@vger.kernel.org, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Fri, May 11, 2018 at 04:41:45PM +0200, David Sterba wrote:
> On Fri, May 11, 2018 at 09:36:09AM -0500, Eric Sandeen wrote:
> > On 5/11/18 9:32 AM, Chris Mason wrote:
> > > On 11 May 2018, at 10:10, David Sterba wrote:
> > > 
> > >> On Thu, May 10, 2018 at 08:16:09PM +0100, Al Viro wrote:
> > >>> On Thu, May 10, 2018 at 01:13:57PM -0500, Eric Sandeen wrote:
> > >>>> Move the btrfs label ioctls up to the vfs for general use.
> > >>>>
> > >>>> This retains 256 chars as the maximum size through the interface, which
> > >>>> is the btrfs limit and AFAIK exceeds any other filesystem's maximum
> > >>>> label size.
> > >>>>
> > >>>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> > >>>> Reviewed-by: Andreas Dilger <adilger@dilger.ca>
> > >>>> Reviewed-by: David Sterba <dsterba@suse.com>
> > >>>
> > >>> No objections (and it obviously ought to go through btrfs tree).
> > >>
> > >> I can take it through my tree, but Eric mentioned that there's a patch
> > >> for xfs that depends on it. In this case it would make sense to take
> > >> both patches at once via the xfs tree. There are no pending conflicting
> > >> changes in btrfs.
> > > 
> > > Probably easiest to just have a separate pull dedicated just for this series.  That way it doesn't really matter which tree it goes through.
> > 
> > Actually, I just realized that the changes to include/uapi/linux/fs.h are completely
> > independent of any btrfs changes, right - there's nothing wrong w/ redefining
> > the common ioctl under a different name in btrfs.  So the fs.h patch could go first,
> > through the xfs tree since it'll be using it.
> > 
> > Once the common ioctl definition goes in, then btrfs can change to define its ioctls to
> > the common ioctls, or act on them directly as my patch did, etc.  Would that be
> > a better plan?  IOWs there's no urgent need to coordinate a btrfs change.
> 
> Agreed, I like that plan.

Ok, I'll await a new series with all the patches that Eric wants to
squeeze through the xfs tree.  I don't mind carrying the btrfs changes
too, so long as they're one-liners and the btrfs maintainers ack/rvb it.

--D
