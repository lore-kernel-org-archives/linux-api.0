From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH 28/33] vfs: syscall: Add fsconfig() for configuring and
 managing a context [ver #11]
Date: Sat, 11 Aug 2018 16:26:07 -0700
Message-ID: <CALCETrXQgOXbV+XWtgtJSBFXymY3yRdBdkr4PYHGJBsq6zhk2g@mail.gmail.com>
References: <153313703562.13253.5766498657900728120.stgit@warthog.procyon.org.uk>
 <153313723557.13253.9055982745313603422.stgit@warthog.procyon.org.uk>
 <87in4n9zg0.fsf@xmission.com> <27374.1533824694@warthog.procyon.org.uk>
 <CAJfpegvWE9htLjqeR6=2BWBSuvJzJpWcjBC_EmX_k1RCGXTfbw@mail.gmail.com> <5152.1534018808@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5152.1534018808@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, "Eric W. Biederman" <ebiederm@xmission.com>, Al Viro <viro@zeniv.linux.org.uk>, Linux API <linux-api@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Sat, Aug 11, 2018 at 1:20 PM, David Howells <dhowells@redhat.com> wrote:
> Miklos Szeredi <miklos@szeredi.hu> wrote:
>
>> You can determine at fsopen() time whether the filesystem is able to
>> support the O_EXCL behavior?  If so, then it's trivial to enable this
>> conditionally.  I think that's what Eric is asking for, it's obviously
>> not fair to ask for a change in behavior of the legacy interface.
>
> It's not trivial, see btrfs and nfs :-/
>

I'm not convinced that btrfs and nfs are the same situation.  As far
as I can tell, in NFS's case, NFS shares superblocks as an
implementation detail.  With Al's example, someone can do:

mount -t nfs4 wank.example.org:/foo/bar /mnt/a
mount -t nfs4 wank.example.org:/baz/barf /mnt/b
mount -t nfs4 wank.example.org:/foo/bar -o wsize=16384 /mnt/c

or equivalently create three fscontexts and FSCONFIG_CMD_CREATE all of
them, and the kernel creates one superblock for /mnt/a and /mnt/b and
a second one for /mnt/c.  That seems like a good optimization, but I
think it really is just an optimization.  In any sane implementation,
all three calls should succeed, and it should in general be possible
to create as many totally fresh mounts of the same network file system
as anyone wants.

Given this example, I think that it may be important to give
FSCONFIG_CMD_RECONFIGURE a very clear definition, and possibly a
definition that doesn't use the word superblock.  After all, if
someone does FSCONFIG_CMD_RECONFIGURE on /mnt/a, if it really
reconfigures a *superblock*, then it will change /mnt/b as a side
effect but will not change /mnt/c.  This seems like a mistake.

But I think that btrfs is quite a bit different.  With btrfs, I can do:

mount -t btrfs /dev/sda1 -o subvol=a /mnt/a
mount -t btrfs /dev/sda1 -o subvol=b /mnt/b

and I get two mounts, each pointing at a different subvolume, that
(I'm pretty sure) share a superblock

mount -t btrfs /dev/sda1 -o subvol=c,foo=bar /mnt/c

where foo is a per-superblock option, it probably gets ignored.  If I
set up /dev/mapper/foo as a linear alias for /dev/sda1 and I do:

mount -t btrfs /dev/mapper/foo -o subvol=d /mnt/d

then I get a fresh superblock.  If /dev/sda1 is still mounted and the
various O_EXCL-like checks don'e catch it, then I get massive
corruption.

The btrfs case seems quite fragile to me, and it seems like a bit of
an abuse of mount(2).  (Of course, basically everything anyone does
with mount(2) is a bit of an abuse.)

I would hope that the new fs mounting API would clean this up.  The
NFS case seems just fine, but for btrfs, it seems like maybe the whole
CMD_CREATE operation should be more fine grained.  There seem to be
*two* actions going on in a btrfs mount.  First there's the act of
instantiating the filesystem driver backed by the device (I think this
is open_ctree()), and *then* there's the act of instantiating a dentry
tree pointing at some subvolume, etc.

ZFS seems to handle this quite nicely.  First you fire up a zpool, and
then you start mounting its volumes.
