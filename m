From: Alan Jenkins <alan.christopher.jenkins@gmail.com>
Subject: Re: [PATCH 01/33] vfs: syscall: Add open_tree(2) to reference or
 clone a mount [ver #11]
Date: Thu, 2 Aug 2018 18:31:06 +0100
Message-ID: <7a292a44-7e17-572b-2d1e-0085ef400010@gmail.com>
References: <153313703562.13253.5766498657900728120.stgit@warthog.procyon.org.uk>
 <153313705165.13253.4602180607294286849.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <153313705165.13253.4602180607294286849.stgit@warthog.procyon.org.uk>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>, viro@zeniv.linux.org.uk
Cc: linux-api@vger.kernel.org, torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Hi

I found this interesting, though I don't entirely follow the kernel 
mount/unmount code.  I had one puzzle about the code, and two questions 
which I was largely able to answer.

On 01/08/18 16:24, David Howells wrote:
> +void dissolve_on_fput(struct vfsmount *mnt)
> +{
> +	namespace_lock();
> +	lock_mount_hash();
> +	mntget(mnt);
> +	umount_tree(real_mount(mnt), UMOUNT_SYNC);
> +	unlock_mount_hash();
> +	namespace_unlock();
> +}

Can I ask why  UMOUNT_SYNC is used here?  I feel like I must have missed 
something, but doesn't it skip the IS_MNT_LOCKED() check in 
disconnect_mount() ?

UMOUNT_SYNC seems used for non-lazy unmounts, and in internal cleanups 
where userspace wouldn't be able to see.  But I think userspace can keep 
watching in this case, e.g. by `fd2 = openat(fd, ".", O_PATH)` (or `fd2 
= open_tree(fd, ".", 0)` ?).  I would think this function should avoid 
using UMOUNT_SYNC, like lazy unmount avoids it.

> From: Al Viro <viro@zeniv.linux.org.uk>
>
> open_tree(dfd, pathname, flags)
>
> Returns an O_PATH-opened file descriptor or an error.
> dfd and pathname specify the location to open, in usual
> fashion (see e.g. fstatat(2)).  flags should be an OR of
> some of the following:
> 	* AT_PATH_EMPTY, AT_NO_AUTOMOUNT, AT_SYMLINK_NOFOLLOW -
> same meanings as usual
> 	* OPEN_TREE_CLOEXEC - make the resulting descriptor
> close-on-exec
> 	* OPEN_TREE_CLONE or OPEN_TREE_CLONE | AT_RECURSIVE -
> instead of opening the location in question, create a detached
> mount tree matching the subtree rooted at location specified by
> dfd/pathname.  With AT_RECURSIVE the entire subtree is cloned,
> without it - only the part within in the mount containing the
> location in question.  In other words, the same as mount --rbind
> or mount --bind would've taken.

One of the limitations documented for `mount --bind`, is that `mount -o 
bind,ro` is not atomic.  There's a workaround if you need it, it's just 
a bit clunky.  I wondered if it was possible to improve `mount` by 
changing the mount flags between OPEN_TREE_CLONE and move_mount().

     fd = open_tree(..., OPEN_TREE_CLONE);
     fchdir(fd);
     mount(NULL, ".", NULL, MS_REMOUNT | MS_BIND | newbindflags, NULL);
     move_mount(fd, ...);

Another closely-related limitation of `mount`, is that it can't 
atomically set the propagation type at mount time.

My conclusion was the above doesn't quite work yet.  do_remount() still 
uses check_mnt(), so it doesn't accept detached mounts.  I wonder if it 
can be changed in future.

>    The detached tree will be
> dissolved on the final close of obtained file.

My last question turned out very dull, feel free to ignore.

It seems the only way to use MNT_FORCE[1], is to first attach the 
filesystem somewhere (and close the file descriptor).  I wondered if 
there was a way to make things more regular.  close_and_umount() feels 
too obscure to live though...

[1] "Ask the filesystem to abort pending requests before attempting 
theunmount. This may allow the unmount to complete without waitingfor an 
inaccessible server. If, after aborting requests, someprocesses still 
have active references to the filesystem, theunmount will still fail."

...and I suppose it's much less useful than I thought.  The point of 
MNT_FORCE is to kick out processes that were blocked _trying to access a 
file by name_, e.g. open() or stat().  But if we're considering a 
detached mount, then it's impossible to access it by name alone.  You 
need an fd (or cwd or root), which would stop the filesystem being 
unmounted anyway. close_and_umount(fd, MNT_FORCE) is pointless unless 
your process has other threads accessing the filesystem through the same 
fd, but that's a really bad idea anyway.

It could prevent someone else getting stuck indefinitely on 
/proc/$PID/fd, but that's still very obscure.

Regards
Alan
