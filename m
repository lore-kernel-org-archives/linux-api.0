From: Zach Brown <zab-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Getting ready for IO extensions, v3
Date: Mon, 22 Sep 2014 14:19:24 -0700
Message-ID: <20140922211924.GG920@lenny.home.zabbo.net>
References: <20140920004634.GA18529@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140920004634.GA18529-PTl6brltDGh4DFYR7WNSRA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Martin Petersen <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Sep 19, 2014 at 05:46:34PM -0700, Darrick J. Wong wrote:
> Hi everyone,
> 
> I've been working (albeit slowly) on the userspace IO extension interface that
> I talked about last April[1].  The mechanism of attaching various attributes
> (which so far have been mandatory ones) to IO requests has been messy, since it
> requires me to design an interface for both the extensions I have in mind as
> well as a generic way to pass extensions into the kernel from userland.
> 
> Is this the appropriate forum to talk about API design in Linux?  It seems that
> way to me based on the list archives, but then I'm new at this, and would like
> to discuss the design before sending full patches (again).
> 
> So far I've defined this structure:
> 
> /* IO extension flags */
> #define IO_EXT_PI	(1)	/* protection info (checksums, etc) */
> #define IO_EXT_REPLICA	(0x2)	/* replica */
> #define IO_EXT_ALL	(IO_EXT_PI | IO_EXT_REPLICA)

Do we have more examples?  It's hard to make a strong case for the need
for variadic io syscalls with only a handful of optional arguments.

Completion timestamps?  priorities?  cgroup annotation?  (Haha, how
about a flag for a "trim" IO instead of having to do a stupid sync
ioctl).  I suppose the leading question is: what can the bio interface
do that userspace can't?

> The glaring downsides of this approach of course is that we waste memory on
> fields that might not be turned on, we have to find a sane way to handle the
> ie_has flags, and fields cannot be removed from the structure.  I don't know of
> a good way to design around those problems without greatly increasing the
> complexity of the data structure (a generic dictionary would work but ye gods
> that's horrifying), so I was wondering if any of you could suggest something
> better?

Maybe it'd just be easier to punt and re-use one of the N type/payload
interfaces.  sendmsg() and netlink are the big ones, right?  I think the
important thing is to translate them to internal kernel interfaces as
high up as possible so that the optional arg parsing is not pushed down
the stack.
 
- z
