From: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Subject: Re: User-visible context-mount API
Date: Fri, 19 Jan 2018 06:32:29 +0000
Message-ID: <20180119063229.GH13338@ZenIV.linux.org.uk>
References: <28167.1516032442@warthog.procyon.org.uk>
 <CAOssrKdgudK7kKbhQBAnV9EwzHBq=4+9M26JGfmhNDGrGXmnFg@mail.gmail.com>
 <1643.1516117204@warthog.procyon.org.uk>
 <CAOssrKdn-ZhOB9V28uL-JK9zgNGJzF4cFBeyoqLLj4pADqNFVQ@mail.gmail.com>
 <20180117041727.GS13338@ZenIV.linux.org.uk>
 <CAOssrKfN_ZT5yJC1mxkhUf6FG=_eMD4nzQtETfu_4X3vOf1kHw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <util-linux-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAOssrKfN_ZT5yJC1mxkhUf6FG=_eMD4nzQtETfu_4X3vOf1kHw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: util-linux-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Miklos Szeredi <mszeredi-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Eric W. Biederman" <ebiederm-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, util-linux-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Jan 17, 2018 at 10:53:36AM +0100, Miklos Szeredi wrote:

> Documenting  --make-private thing properly would also help.  To me the
> wording "make private" strongly implies "I want to make submounts
> private to this instance".  See for example rhbz#1432211.
> 
> > If anything, "private bind on itself" would be a useful operation.
> > Turning given location into a mountpoint, and having everything
> > under it looking as it used to, but with no propagation at all.
> > Without bothering anybody else, even if location currently happens
> > to be on a shared/master mount.
> >
> > I can slap that together for mount(2), but I'm not sure what a sane
> > combination of flags for that would look like ;-)  For fsmount
> > I think it would be very useful thing to have.
> 
> Yes, I think such an operation would be pretty useful.   Not sure if
> it's the whole story, though.

FWIW, there's a fun variant of the API:

* fsopen(): string -> fsfd; takes fs type name, returns a file descriptor
connected to fs driver.  Subsequent read/write on it is used to pass
options, authenticate, etc. - all you need to talk the driver into
creating an active instance.

* fspick(): location -> fsfd; fsfd connected to filesystem mounted at given
place.  After that you can talk to the driver to get superblock-level
remount.

* new_mount(): fsfd x string -> fd.  Creates a vfsmount and gives a file
descriptor for given relative pathname.

* clone_mount(): location x bool -> fd.  Copies a vfsmount or an entire
subtree (depending upon the second parameter) and returns a file descriptor.
Basically, bind or rbind sans attaching it anywhere.

* change_flags(): fd x (propagation or vfsmount flags) x bool -> int
fd should point to root of some vfsmount (O_PATH, or either of the previous
two.  Flag is "do we want it to affect the entire subtree"; the tricky
question is what to do with vfsmount flags - for those we might want
things like "here's the full set" or "change those flags thus".
Hell knows - there might be two primitives there; the second one
would be fd x mask x new_flags x bool -> int, as in "set the bits
present in mask to values as in new_flags".  Not sure.

* move_mount(): fd x location x bool -> int.  fd - what to move, location -
where to put it, bool - do we want to suppress propagation.  Potentially
hacky part is that if fd is not attached to anything, we simply attach it;
otherwise - move.

Normal mount: fsopen, talk to driver, new_mount, move_mount, close descriptors
mount --bind: fd = clone_mount(old, false); move_mount(fd, new, false); close
mount --rbind: clone_mount(old, true); move_mount; close
mount --make-shared et.al.: open(..., O_PATH); change_flags; close
mount --move: open; mount_move; close
vfsmount-level remount: open; change_flags (or change_mount_flags, if we keep
it separate from topology ones); close
sb-level remount: fspick; talk to driver; close
make an arbitrary subtree really private (as discussed upthread):
	fd = clone_mount(old, true); change_flags (or change_propagation_flags);
	mount_move(fd, old, true); close(fd);

The tricky part in terms of implementation is that we want a
tree created by clone_mount() and never attached anywhere to be
dissolved on the final close() of the result of clone_mount().
It's not quite O_PATH - we want file_operations for that sucker
that would have ->release() doing that.

It would do namespace_lock(), check ->f_path.mnt for a flag and do
umount_tree() if not set, then namespace_unlock().  move_mount()
would set the flag.
--
To unsubscribe from this list: send the line "unsubscribe util-linux" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
