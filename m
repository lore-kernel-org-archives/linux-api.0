From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [RFC] vfs: skip extra attributes check on removal for symlinks
Date: Thu, 10 May 2018 23:05:51 +0000
Message-ID: <20180510230551.GE27853@wotan.suse.de>
References: <20180426234639.12480-1-mcgrof@kernel.org>
 <20180510204807.GV30522@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180510204807.GV30522@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, sandeen@sandeen.net, darrick.wong@oracle.com, dhowells@redhat.com, tytso@mit.edu, fliu@suse.com, jack@suse.cz, jeffm@suse.com, nborisov@suse.com, jake.norris@suse.com, mtk.manpages@gmail.com, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, May 10, 2018 at 09:48:07PM +0100, Al Viro wrote:
> On Thu, Apr 26, 2018 at 04:46:39PM -0700, Luis R. Rodriguez wrote:
> 
> > Since we cannot set these attributes we should special-case the
> > immutable/append on delete for symlinks, this would be consistent with
> > what we *do* allow on Linux for all filesystems.
> 
> Er...  So why not simply sanity-check it in places that set it on
> inodes? 

The patch is not about sanity-checks on setters though as *that* is in place
already. Its about the case where the filesystem gets corrupted and the VFS
*still* does process these attributes for symlinks and still prevents
deletion because of these attributes.

So we already do not allow for settings these attributes.

> If anything, I would suggest
> 	* converting all places that set those in ->i_flags to
> inode_set_flags()
> 	* making inode_set_flags() check and return an error on
> that...

But if I misunderstood your suggestion please let me know. I'll send out
a v2 RFC next which illustrates what filesystems can do for now.

  Luis
