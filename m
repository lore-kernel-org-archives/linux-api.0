From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH][RFC] open_tree(2) (was Re: [PATCH 30/32] vfs: Allow
 cloning of a mount tree with open(O_PATH|O_CLONE_MOUNT) [ver #8])
Date: Mon, 4 Jun 2018 21:27:24 +0200
Message-ID: <CAJfpegutvApf8GQdHSKx_tvZyz=BNntO2ZVsQcKHSJQ4pMHYeQ@mail.gmail.com>
References: <152720672288.9073.9868393448836301272.stgit@warthog.procyon.org.uk>
 <152720691829.9073.10564431140980997005.stgit@warthog.procyon.org.uk>
 <20180601062654.GA32397@infradead.org> <7067.1527841663@warthog.procyon.org.uk>
 <20180602030913.GU30522@ZenIV.linux.org.uk> <20180602034255.GV30522@ZenIV.linux.org.uk>
 <21804.1527954321@warthog.procyon.org.uk> <20180602174957.GX30522@ZenIV.linux.org.uk>
 <20180603005532.GZ30522@ZenIV.linux.org.uk> <CAELBmZCXMkCY+Lkz2xmhUiK_5oDctZzozHP-cXv9vp7qWsOtVQ@mail.gmail.com>
 <20180604155205.GH30522@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180604155205.GH30522@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: David Howells <dhowells@redhat.com>, Christoph Hellwig <hch@infradead.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-afs@lists.infradead.org, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Mon, Jun 4, 2018 at 5:52 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Mon, Jun 04, 2018 at 12:34:44PM +0200, Miklos Szeredi wrote:
>
>> fsopen = create fsfd
>> fsmount = fsfd -> mountfd & set attr on mountfd & attach mountfd
>> fspick = path -> fsfd
>> move_mount = attach mountfd or move existing
>> fsinfo = info from path
>> open_tree = new mountfd from path or clone
>> mount_setattr = set attr on mountfd
>>
>> Notice that fsmount() encompasses mount_setattr() + move_mount()
>> functionality.   Split those out and leave fsmount() to actually do
>> the "fsfd ->mountfd" translation?
>
> Might make sense.

> FWIW, to make it clear: fsmount(2) in this series actually does *NOT*
> attach it to the tree.

Ah, that leaves the mount_setattr() functionality to split out.   I'd
be more happy to rid this new API of all the old MS_* crap and have
have a new set of attributes, that just apply to mounts.   It will
also need  two args: a bitmap of new attributes and a mask to tell us
which attributes to change.

>  Commit message definitely needs updating - as it
> is, it's
>
> +SYSCALL_DEFINE5(fsmount, int, fs_fd, unsigned int, flags, unsigned int, ms_flags,
> +               void *, reserved4, void *, reserved5)
>
> PS: IMO these reserved... arguments are in bad taste; if anyone has good reasons
> for that practice in ABI design, I'd like to hear those.

Agreed.  A flags argument is often wise to add even if currently
unused (and should be checked for undefined flags), but adding a
random number of pointers doesn't seem to make a lot of sense.

>
>> fsinfo() name suggests it's in the same class as
>> fsopen/fsmount/fspick, operating on fsfd object, but's it's not and I
>> think that's slightly confusing.
>>
>> Rename move_mount() -> mount_move()?
>
> mount_move_bikeshed_bikeshed_bikeshed(), surely?

Consistent naming for related functions... not unheard of in API
design.  The above set definitely does not qualify.

>> Also does it make sense to make the cloning behavior of open_tree()
>> optional?  Without cloning it's just a plain open(O_PATH).  That  way
>> it could be renamed mount_clone().
>
> Umm...  I'm not sure about that one.  If nothing else, OPEN_TREE_DETACH
> might be a good idea, in which case cloning is not the primary effect;
> hell knows.

So conceptually we have the following distinct mount tree operations:

treefd = clone(path);
treefd = detach(path);
attach(treefd, path);
move(path1, path2);

The detach/move/attach trio are more related in functionality, while
clone and detach have the same signature. I'm not sure either.

Thanks,
Miklos
