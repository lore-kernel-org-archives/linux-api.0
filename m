From: Omar Sandoval <osandov-nWWhXC5lh1RBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [RFC PATCH 2/3] vfs: add d_replace()
Date: Tue, 22 Nov 2016 19:57:16 -0800
Message-ID: <20161123035716.GA29697@mew>
References: <cover.1479802448.git.osandov@fb.com>
 <527297d2dae27845b3b7ba8ad6e81ef477fddee2.1479802448.git.osandov@fb.com>
 <20161123034004.GK1555@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161123034004.GK1555-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Nov 23, 2016 at 03:40:04AM +0000, Al Viro wrote:
> On Tue, Nov 22, 2016 at 12:25:02AM -0800, Omar Sandoval wrote:
> > From: Omar Sandoval <osandov-b10kYP2dOMg@public.gmane.org>
> > 
> > Changes the inode associated with a dentry. This'll be useful for
> > implementations of linkat() AT_REPLACE.
> 
> Hard NAK.  That violates all kinds of assumptions made by VFS and
> filesystems alike; never, ever do that.  If you have a reference to
> a positive dentry, inode should *NEVER* change.

Okay, thanks for the sanity check.

> If it unhashed the old dentry, created a new one and attached inode to
> it, it _might_ have a chance.  I'm less than sure it's a good idea, but
> it this form it's a non-starter.

One thing I considered was having the filesystem unhash the dentry and
just letting the next lookup that comes along instantiate the new one.
Is that better or worse than doing something like your suggestion?

> Again,
> 
> NAKed-by: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
> 
> and don't bring it back in that form.

-- 
Omar
