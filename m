From: Davide Rizzo <elpa.rizzo-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/2] User access to internal clocks
Date: Mon, 9 Feb 2009 22:06:23 +0100
Message-ID: <8447d6730902091306ka260b1fi405dd7c17bb2b5d4@mail.gmail.com>
References: <8447d6730902090904y138af9c6r3d64278bc7a30811@mail.gmail.com>
	 <20090209171042.GA19453@n2100.arm.linux.org.uk>
	 <8447d6730902090944s9bc96f7r76da82ea09c629f0@mail.gmail.com>
	 <20090209175514.GB19453@n2100.arm.linux.org.uk>
	 <8447d6730902091017m21cb30d0w6be6fbbbf33db4f3@mail.gmail.com>
	 <8447d6730902091054x7c4c842m7339382e19260bd8@mail.gmail.com>
	 <20090209190142.GD19453@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20090209190142.GD19453-l+eeeJia6m9vn6HldHNs0ANdhmdF6hFW@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Russell King - ARM Linux <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>
Cc: gregkh-l3A5Bk7waGM@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ben-linux-elnMNo+KYs3YtjvyW6yDsg@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-xIg/pKzrS19vn6HldHNs0ANdhmdF6hFW@public.gmane.org
List-Id: linux-api@vger.kernel.org

What about adding a dedicated function to clk api that registers a struct clk
 in a linked list and associates it with a name, with the only specific purpose
 to enumerate and list (and possibly change rate and parents) all
clocks in sysfs ?
Obviously only specifically registered clocks will be visible in sysfs...

Or better, only proposed functions:
int clk_for_each(int(*fn)(struct clk *, void *), void *data)
and
const char *clk_sysname(struct clk *)
need to be added to clk api, the function to register the struct clk
in the linked list could be implementation specific.
Maybe a function like this:
struct clk *clk_get_by_sysname(const char *sysname);
could be useful to be added to api interface, too ?
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
