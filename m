From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/4] statx: Add a system call to make enhanced file info available
Date: Fri, 18 Nov 2016 08:59:24 +0000
Message-ID: <25517.1479459564@warthog.procyon.org.uk>
References: <2D8B8AAF-2016-45BD-9D70-A532DDDB23D2@dilger.ca> <147938969703.13574.10295364502230379833.stgit@warthog.procyon.org.uk> <147938970382.13574.11581172952175034619.stgit@warthog.procyon.org.uk> <1479407964.4556.5.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2D8B8AAF-2016-45BD-9D70-A532DDDB23D2-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>
Content-ID: <25498.1479459547.1-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andreas Dilger <adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, drepper-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Andreas Dilger <adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org> wrote:

> >> If neither AT_STATX_*_SYNC flag is set, the behaviour is the default for
> >> stat() on that filesystem.
> > 
> > We also need to specify here what happens if both bits are set. Should
> > that be -EINVAL?
> 
> If that is the case, then it doesn't make sense to have two contradictory
> flags.

Yes it does.  There are actually *three* cases, not two.  Maybe, rather than a
pair of flags, I should stake out a 2-bit field with three possible values.

> Pick a default behaviour (i.e. return what is known on the client),

The default behaviour has to be what stat() does now for any particular
filesystem.  statx() is likely to get used to emulate stat() so that stat()
can be made to return safe timestamps.  If we make it so that statx() cannot
do this, it's very likely that we'll see yet another stat() variant syscall
being added.

> and if this is 100% accurate (e.g. local filesystem or filesystem with
> strong coherency)

In a netfs, it was 100% accurate at the point the server started transmitting
its reply.  This may no longer be true - even with something like AFS that has
change notifications.

> then it can optionally set the SYNC flag in the returned
> flags.

So you suggest putting the SYNC flag(s) in the request mask rather than
sharing the AT_* flag space?

> If the application needs 100% accurate size info, then it can set the SYNC
> flag in the request and the filesystem may need to do extra work to fetch
> accurate data from the server.

Note that one of the things that people asked for was a
DONT_GO_TO_THE_SERVER_AT_ALL flag.  I take it this is your suggested default?

David
