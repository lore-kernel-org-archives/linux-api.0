From: David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH 1/2 V2] fs: hoist BTRFS_IOC_[SG]ET_FSLABEL to vfs
Date: Fri, 11 May 2018 16:10:17 +0200
Message-ID: <20180511141017.GZ6649@twin.jikos.cz>
References: <d2979d75-5e45-b145-9ca5-2c315d8ead9c@redhat.com>
 <b8c7feca-68ce-b1a8-3a96-a99b50457a84@sandeen.net>
 <4a4f33c3-2173-9795-f4e4-1e9d338fd9a7@sandeen.net>
 <20180510191608.GR30522@ZenIV.linux.org.uk>
Reply-To: dsterba@suse.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-btrfs-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180510191608.GR30522@ZenIV.linux.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Eric Sandeen <sandeen@sandeen.net>, Eric Sandeen <sandeen@redhat.com>, fsdevel <linux-fsdevel@vger.kernel.org>, "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu, May 10, 2018 at 08:16:09PM +0100, Al Viro wrote:
> On Thu, May 10, 2018 at 01:13:57PM -0500, Eric Sandeen wrote:
> > Move the btrfs label ioctls up to the vfs for general use.
> > 
> > This retains 256 chars as the maximum size through the interface, which
> > is the btrfs limit and AFAIK exceeds any other filesystem's maximum
> > label size.
> > 
> > Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> > Reviewed-by: Andreas Dilger <adilger@dilger.ca>
> > Reviewed-by: David Sterba <dsterba@suse.com>
> 
> No objections (and it obviously ought to go through btrfs tree).

I can take it through my tree, but Eric mentioned that there's a patch
for xfs that depends on it. In this case it would make sense to take
both patches at once via the xfs tree. There are no pending conflicting
changes in btrfs.
