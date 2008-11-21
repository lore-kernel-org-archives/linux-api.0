From: Evgeniy Polyakov <zbr-i6C2adt8DTjR7s880joybQ@public.gmane.org>
Subject: Re: [take 3] Use pid in inotify events.
Date: Fri, 21 Nov 2008 17:53:29 +0300
Message-ID: <20081121145329.GA14556@ioremap.net>
References: <acdcfe7e0811081035l56eedf05x8b3b7ee2fc01eee6@mail.gmail.com> <20081116232450.GA13547@ioremap.net> <cfd18e0f0811170859w1d3f903ej1d5626f2d2bf4496@mail.gmail.com> <20081117171508.GA564@ioremap.net> <cfd18e0f0811170923q6b72bd0fn9d319bbceb8fa6a@mail.gmail.com> <20081117175212.GA2224@ioremap.net> <20081120130902.GA1408@ucw.cz> <20081121140325.GA12384@ioremap.net> <acdcfe7e0811210630s65404ef5pf2b94731c2a872e1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <acdcfe7e0811210630s65404ef5pf2b94731c2a872e1-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Robert Love <rlove-L7G0xEPcOZbYtjvyW6yDsg@public.gmane.org>
Cc: Pavel Machek <pavel-AlSwsSmVLrQ@public.gmane.org>, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Nov 21, 2008 at 09:30:38AM -0500, Robert Love (rlove-L7G0xEPcOZbYtjvyW6yDsg@public.gmane.org) wrote:
> Your solution needs to be (a) generally applicable and useful, with an
> (b) elegant and clean API, which (c) does not break ABI or API.
> 
> Overloading the cookie field is not the way to go. Finding ways to
> extend the API through inotify_init might be--you will have even
> higher hurdles of "do we really need this" though.

That's it. Does it mean neither solution will be accepted?
Just because 'we' do not need to know IO origin identity.

According to your three requirements for the solution. They can not be
satisfied, just because inotify event returned to userspace is fixed, so
there will be at least extension of the API and ABI.

> John & I intentionally did not add the pid field when writing inotify
> for reasons of security and questionable need. It also stinks to have
> to add a pid field to the event structure if that field is seldom
> used.

That's it: overloading existing cookie is a no-go, new interface is not
needed :)

What I would implement if things are getting that far, is a nesting
attributes in form of header and data, like

[generic inotify header: event, watch and attached data size]
[attribute0 size data]
[attribute1 size data]
...
[attributeN size data]

where attribute list, needed to be sent per event is created via ioctls
on top of inotify file descriptor, since overloading flag value of the
inotify_init1() allows to have only 32 attributes, while that may be not
enough. So far I see several: pid, IO offset and start, attributes
changed (access mode, permissions, xattrs names), combine move event
into two attributes of the same event instead of two events with the
same cookie. Maybe something else, this can be extended infinitely.

> Working on lkml often sounds like everyone is screaming NO, channeling
> nothing but stop energy. Sometimes people are, but more often what
> they really mean is you just have to take your time and do things
> right. Admittedly it is a lot of iteration, but Linux is a noble
> pursuit.

It is linux-kernel@ only. All subsystems I worked with behave
cooperately to solve the problem. All except generic changes, which end
up in linux-kernel@. But that's the matter of feeling that this is a
so special mail lists. We can live with it of course :)

-- 
	Evgeniy Polyakov
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
