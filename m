From: Alan Jenkins <alan.christopher.jenkins@gmail.com>
Subject: Re: [PATCH 01/33] vfs: syscall: Add open_tree(2) to reference or
 clone a mount [ver #11]
Date: Fri, 3 Aug 2018 00:46:14 +0100
Message-ID: <c50af5da-2168-b35a-0d28-5af887cd997a@gmail.com>
References: <7a292a44-7e17-572b-2d1e-0085ef400010@gmail.com>
 <153313703562.13253.5766498657900728120.stgit@warthog.procyon.org.uk>
 <153313705165.13253.4602180607294286849.stgit@warthog.procyon.org.uk>
 <21311.1533246718@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <21311.1533246718@warthog.procyon.org.uk>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: viro@zeniv.linux.org.uk, linux-api@vger.kernel.org, torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 02/08/18 22:51, David Howells wrote:
> Alan Jenkins <alan.christopher.jenkins@gmail.com> wrote:
>
>> Another closely-related limitation of `mount`, is that it can't atomically set
>> the propagation type at mount time.
> I want to add a mount_setattr() too at some point:
>
> 	fd = open_tree(..., OPEN_TREE_CLONE);
> 	mount_setattr(fd, ...);
> 	move_mount(fd, ...);

Cool.  Not having to mess with fchdir() sounds nice.  (And as a bonus, 
being able to avoid the existing multiplexed mount() call, which looks 
ugly from all the NULL arguments if nothing else).

> I'm not sure whether you should be able to fchdir into the cloned tree since
> it isn't attached to any mount namespace.
>
> David

I don't see a check prohibiting it :-). I don't think it's a problem.

You can already chdir/chroot into a different mount namespace, you just 
can't do any mount operations on it.  (You said you want to be able to, 
but so far move_mount() still prohibits it, I guess that's for the future).

And you can already do the same into a mount that has been detached, 
which will have `mount->mnt_ns = NULL` if I'm reading correctly.

Hmm, there is something that's been nagging at me though.  I'm 
suspicious about what happens in this series, when you move_mount() from 
a victim of MNT_DETACH.  I think umount2(MNT_DETACH) sets a flag 
MNT_UMOUNT.  It's a flag that was added to help correctly handle 
MNT_LOCKED in the face of umount2(MNT_DETACH).  It's also the point 
where my understanding of the kernel mount/unmount code breaks down 
:-).  But it seems to override both IS_MNT_LOCKED() and UMOUNT_CONNECTED 
in disconnect_mount().  That would give another chance to defeat locked 
mounts.

Regards
Alan
