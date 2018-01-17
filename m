From: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Subject: Re: User-visible context-mount API
Date: Wed, 17 Jan 2018 04:17:27 +0000
Message-ID: <20180117041727.GS13338@ZenIV.linux.org.uk>
References: <28167.1516032442@warthog.procyon.org.uk>
 <CAOssrKdgudK7kKbhQBAnV9EwzHBq=4+9M26JGfmhNDGrGXmnFg@mail.gmail.com>
 <1643.1516117204@warthog.procyon.org.uk>
 <CAOssrKdn-ZhOB9V28uL-JK9zgNGJzF4cFBeyoqLLj4pADqNFVQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAOssrKdn-ZhOB9V28uL-JK9zgNGJzF4cFBeyoqLLj4pADqNFVQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Miklos Szeredi <mszeredi-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Eric W. Biederman" <ebiederm-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Jan 16, 2018 at 05:41:46PM +0100, Miklos Szeredi wrote:

> Right.
> 
> Still, those two (propagation and flags) are properties of the mount.
> No fundamental difference in how to handle them, that I see.  Okay, we
> have MS_REC handling in the propagation and not in the flags, but
> that's something that might make sense for flags as well.
> 
> What's more interesting is how MS_PRIVATE + MS_REC semantics are
> complete failure in the real world: the logical thing would be to mark
> a mount private on the supplied mount AND propagate an umount event to
> everywhere else.

This is utter nonsense.  Most of the time it's "Fedora, in its infinite
bogo^Wwisdom has made everything shared; I don't fucking need that
idiocy, so please unshare this, this and that".  You really don't want
(or have permissions for) unmounting e.g. /mnt in namespace of init
when you do that.

Sure, we get tons of bug reports.  Due to idiotic Fedora setup, with
everything shared.  The same setup that would go up in flames on the
semantics change you propose.

If anything, "private bind on itself" would be a useful operation.
Turning given location into a mountpoint, and having everything
under it looking as it used to, but with no propagation at all.
Without bothering anybody else, even if location currently happens
to be on a shared/master mount.

I can slap that together for mount(2), but I'm not sure what a sane
combination of flags for that would look like ;-)  For fsmount
I think it would be very useful thing to have.
