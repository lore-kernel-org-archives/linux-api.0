From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 01/33] vfs: syscall: Add open_tree(2) to reference or
 clone a mount [ver #11]
Date: Thu, 2 Aug 2018 22:29:23 +0100
Message-ID: <20180802212923.GA30522@ZenIV.linux.org.uk>
References: <153313703562.13253.5766498657900728120.stgit@warthog.procyon.org.uk>
 <153313705165.13253.4602180607294286849.stgit@warthog.procyon.org.uk>
 <7a292a44-7e17-572b-2d1e-0085ef400010@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <7a292a44-7e17-572b-2d1e-0085ef400010@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Alan Jenkins <alan.christopher.jenkins@gmail.com>
Cc: David Howells <dhowells@redhat.com>, linux-api@vger.kernel.org, torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, Aug 02, 2018 at 06:31:06PM +0100, Alan Jenkins wrote:
> Hi
> 
> I found this interesting, though I don't entirely follow the kernel
> mount/unmount code.  I had one puzzle about the code, and two questions
> which I was largely able to answer.
> 
> On 01/08/18 16:24, David Howells wrote:
> > +void dissolve_on_fput(struct vfsmount *mnt)
> > +{
> > +	namespace_lock();
> > +	lock_mount_hash();
> > +	mntget(mnt);
> > +	umount_tree(real_mount(mnt), UMOUNT_SYNC);
> > +	unlock_mount_hash();
> > +	namespace_unlock();
> > +}
> 
> Can I ask why  UMOUNT_SYNC is used here?  I feel like I must have missed
> something, but doesn't it skip the IS_MNT_LOCKED() check in
> disconnect_mount() ?
> 
> UMOUNT_SYNC seems used for non-lazy unmounts, and in internal cleanups where
> userspace wouldn't be able to see.  But I think userspace can keep watching
> in this case, e.g. by `fd2 = openat(fd, ".", O_PATH)` (or `fd2 =
> open_tree(fd, ".", 0)` ?).  I would think this function should avoid using
> UMOUNT_SYNC, like lazy unmount avoids it.

FWIW, I suspect that UMOUNT_CONNECTED might be the right thing here...
