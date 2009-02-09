From: Davide Rizzo <elpa.rizzo-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/2] User access to internal clocks
Date: Mon, 9 Feb 2009 19:17:07 +0100
Message-ID: <8447d6730902091017m21cb30d0w6be6fbbbf33db4f3@mail.gmail.com>
References: <8447d6730902090904y138af9c6r3d64278bc7a30811@mail.gmail.com>
	 <20090209171042.GA19453@n2100.arm.linux.org.uk>
	 <8447d6730902090944s9bc96f7r76da82ea09c629f0@mail.gmail.com>
	 <20090209175514.GB19453@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20090209175514.GB19453-l+eeeJia6m9vn6HldHNs0ANdhmdF6hFW@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Russell King - ARM Linux <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>
Cc: gregkh-l3A5Bk7waGM@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ben-linux-elnMNo+KYs3YtjvyW6yDsg@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

> You're not understanding the issue(s).
>
> 1. there is no 1:1 mapping between the identifiers (struct device +
>   connection ID) and the struct clk.  It's actually a many-to-one
>   mapping.
>
>   That means there is _no_ name associated with a struct clk.
>
>   Conceptually, clk_get() gives you a struct clk for the struct device
>   and a connection ID.  How that mapping is achieved isn't specified
>   in the API, all that's required is that such a mapping is performed.
>   It is _specifically_ intended that more than one set of {device,id}
>   pairs will map to the same clk.
>
>   So, now to insist that you can go from a struct clk to some kind of
>   string identifier for it is changing this - you're now requiring
>   that every struct clk has a unique name.  This is not the case.
>   PXA, for instance, struct clk's are now completely nameless.  They
>   have no identifier.
>
>   If you want to have a string identifier which works in every case,
>   this will:
>
>        sprintf(identifer, "%p", clk);
>
>   Or, I guess you could force every struct clk to have a 'sysfs_name'
>   field just to export them out via sysfs - and that'll be all that
>   it's used for.
>
> 2. there is no generic way to walk a set of struct clk's - indeed, there
>   may be no list of them (and there exists implmentations where that is
>   true) and the only list which does exist is a set ID to clk mapping
>   structures.
>
>> Otherwise, what do you suggest to enumerate and distinguish all system
>> clocks ?
>
> There exists no such concept in the API, what you're asking for is
> implementation specific.
>

Thank you for this explanation, now it's much more clear to me.

What about adding a dedicated function to clk api that registers a struct clk
 in a linked list and associates it with a name, with the only specific purpose
 to enumerate and list (and possibly change rate and parents) all
clocks in sysfs ?
Obviously only specifically registered clocks will be visible in sysfs...
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
