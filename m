From: Russell King - ARM Linux <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>
Subject: Re: [PATCH 1/2] User access to internal clocks
Date: Mon, 9 Feb 2009 17:55:14 +0000
Message-ID: <20090209175514.GB19453@n2100.arm.linux.org.uk>
References: <8447d6730902090904y138af9c6r3d64278bc7a30811@mail.gmail.com> <20090209171042.GA19453@n2100.arm.linux.org.uk> <8447d6730902090944s9bc96f7r76da82ea09c629f0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <8447d6730902090944s9bc96f7r76da82ea09c629f0-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Davide Rizzo <elpa.rizzo-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: gregkh-l3A5Bk7waGM@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ben-linux-elnMNo+KYs3YtjvyW6yDsg@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, Feb 09, 2009 at 06:44:40PM +0100, Davide Rizzo wrote:
> >> This driver is for user level programs to interact with system clocks.
> >> It allows to read and modify rates and parents, using virtual files.
> >> It requires the implementation of 2 additional functions in the clk interface:
> >>  clk_for_each() and clk_name().
> >> Actually I implemented that functions only for Samsung S3C24xx platform.
> >
> > NAK.
> >
> >> +       name = clk_get_name(clk);
> >
> > This implies that there is a 1:1 relationship between a 'name' and a
> > struct clk.  No such thing exists (and where it does, it's being
> > eliminated in ARM because it's just plain and simple WRONG.)
>
> Not exactly, clk_get() could work in both way: a struct clk can be
> exactly identified by name and device id (like clk_get is acting now)
> or by full name, in the format clkname.device

You're not understanding the issue(s).

1. there is no 1:1 mapping between the identifiers (struct device +
   connection ID) and the struct clk.  It's actually a many-to-one
   mapping.

   That means there is _no_ name associated with a struct clk.

   Conceptually, clk_get() gives you a struct clk for the struct device
   and a connection ID.  How that mapping is achieved isn't specified
   in the API, all that's required is that such a mapping is performed.
   It is _specifically_ intended that more than one set of {device,id}
   pairs will map to the same clk.

   So, now to insist that you can go from a struct clk to some kind of
   string identifier for it is changing this - you're now requiring
   that every struct clk has a unique name.  This is not the case.
   PXA, for instance, struct clk's are now completely nameless.  They
   have no identifier.

   If you want to have a string identifier which works in every case,
   this will:

	sprintf(identifer, "%p", clk);

   Or, I guess you could force every struct clk to have a 'sysfs_name'
   field just to export them out via sysfs - and that'll be all that
   it's used for.

2. there is no generic way to walk a set of struct clk's - indeed, there
   may be no list of them (and there exists implmentations where that is
   true) and the only list which does exist is a set ID to clk mapping
   structures.

> Otherwise, what do you suggest to enumerate and distinguish all system
> clocks ?

There exists no such concept in the API, what you're asking for is
implementation specific.
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
