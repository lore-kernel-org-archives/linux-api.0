From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH][RFC] open_tree(2) (was Re: [PATCH 30/32] vfs: Allow
 cloning of a mount tree with open(O_PATH|O_CLONE_MOUNT) [ver #8])
Date: Mon, 4 Jun 2018 12:34:44 +0200
Message-ID: <CAELBmZCXMkCY+Lkz2xmhUiK_5oDctZzozHP-cXv9vp7qWsOtVQ@mail.gmail.com>
References: <20180602040434.GW30522@ZenIV.linux.org.uk> <20180601063928.GS30522@ZenIV.linux.org.uk>
 <152720672288.9073.9868393448836301272.stgit@warthog.procyon.org.uk>
 <152720691829.9073.10564431140980997005.stgit@warthog.procyon.org.uk>
 <20180601062654.GA32397@infradead.org> <7067.1527841663@warthog.procyon.org.uk>
 <20180602030913.GU30522@ZenIV.linux.org.uk> <20180602034255.GV30522@ZenIV.linux.org.uk>
 <21804.1527954321@warthog.procyon.org.uk> <20180602174957.GX30522@ZenIV.linux.org.uk>
 <20180603005532.GZ30522@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180603005532.GZ30522@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: David Howells <dhowells@redhat.com>, Christoph Hellwig <hch@infradead.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-afs@lists.infradead.org, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Sun, Jun 3, 2018 at 2:55 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Sat, Jun 02, 2018 at 06:49:58PM +0100, Al Viro wrote:
>
>> > > Hell, might even add AT_UMOUNT for "open root and detach, to be dissolved on
>> > > close", incompatible with AT_CLONE.
>> >
>> > Cute.  Guess you could do:
>> >
>> >     fd = open_mount(..., OPEN_TREE_DETACH);
>> >     mount_setattr(fd, "",
>> >                   MOUNT_SETATTR_EMPTY_PATH,
>> >                   MOUNT_SETATTR_NOSUID, NULL);
>> >     move_mount(fd, "", ...);
>
> Hadn't added that yet, but as for the rest of open_tree() - see
> vfs.git#mount-open_tree.  open() and its flags are not touched at all.
> Other changes compared to the previous:
>         * may_mount() is required for OPEN_TREE_CLONE
>         * sys_ni.c cruft is dropped - those make no sense until and unless
> those syscalls become conditional.
>
> Appears to work, combined with move_mount() it yields eqiuvalents of
> mount --{move,bind,rbind}.  Combined with mount_setattr(2) (when that
> gets added) we'll get mount -o remount,bind,nodev et.al.

fsopen = create fsfd
fsmount = fsfd -> mountfd & set attr on mountfd & attach mountfd
fspick = path -> fsfd
move_mount = attach mountfd or move existing
fsinfo = info from path
open_tree = new mountfd from path or clone
mount_setattr = set attr on mountfd

Notice that fsmount() encompasses mount_setattr() + move_mount()
functionality.   Split those out and leave fsmount() to actually do
the "fsfd ->mountfd" translation?

fsinfo() name suggests it's in the same class as
fsopen/fsmount/fspick, operating on fsfd object, but's it's not and I
think that's slightly confusing.

Rename move_mount() -> mount_move()?

Also does it make sense to make the cloning behavior of open_tree()
optional?  Without cloning it's just a plain open(O_PATH).  That  way
it could be renamed mount_clone().

Thanks,
Miklos
