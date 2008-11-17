From: Evgeniy Polyakov <zbr-i6C2adt8DTjR7s880joybQ@public.gmane.org>
Subject: Re: [take 3] Use pid in inotify events.
Date: Mon, 17 Nov 2008 20:52:12 +0300
Message-ID: <20081117175212.GA2224@ioremap.net>
References: <acdcfe7e0811081035l56eedf05x8b3b7ee2fc01eee6@mail.gmail.com> <20081116232450.GA13547@ioremap.net> <cfd18e0f0811170859w1d3f903ej1d5626f2d2bf4496@mail.gmail.com> <20081117171508.GA564@ioremap.net> <cfd18e0f0811170923q6b72bd0fn9d319bbceb8fa6a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <cfd18e0f0811170923q6b72bd0fn9d319bbceb8fa6a-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: Robert Love <rlove-L7G0xEPcOZbYtjvyW6yDsg@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Nov 17, 2008 at 12:23:01PM -0500, Michael Kerrisk (mtk.manpages-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org) wrote:
> > Cookie was created to store information used to somehow connect events to
> > each other. PID does that from another angle than rename.
> 
> Yes, but it does it in an inconsistent, incomplete way.

It was not my decision, I can not argue if it could be good, bad, perfect
or shine. It is what we have, and I'm trying to extend it not breaking
other things up.

> > Extending
> > (rewriting userspace event processing part) events is a solution for the
> > new project,
> 
> Not quite sure of your point here.  Whatever change is made, userspace
> apps will need to be trained to understand the interface.

I mean kernel event generation side will have to be rewritten: new
event structures, new members, new field usage scenario and so on.

> > while existing patch (where all security concerns are
> > resolved) is a minimum functionality extension.
> 
> It is a minimum functionality extension that serves the needs of one
> or a few projects, while dirtying the design for all users.

Yes, this is a minimum functionality extension, which breaks nothing.
That's why it is a good idea, but I agree that there may be better than
just a good idea and implementation :)

Users do not use cookie field, since it is unused by all but two events
(move_to and move_from), now it may carry not zero, but process ID of
the IO origin for all but two events. Exactly the same situation.
Even more on this: because of mismatched uids process will see
the same zero as before for all 'alien' IO, and have a non-zero cookie
to show that IO belongs to the same user as watcher.

> > if I will spent a day and rewrite userspace report side to report new
> > events I'm pretty sure there will be people, who will start complaining
> > that again design does not match some theoretically perfect
> > expectations,
> 
> Maybe.  Mabe not.  But that is (a necessary) part of the design process.

No, this will be done not at design time. At design time it requires to
think about how to implement the feature, when things are done it is
much more comfortable and more pleasure to flame about.
I already messed with generic interfaces 3 years ago :)

That's a joke of course, it is possible that it will be very popular
frequently used interface. We can discuss and create a good interface,
but who will use it (except me, who wants this for the own project)?

> > and for the purpose of reporting origin's PID cookie
> > fields can be reused since right now it is unused.
> 
> You didn't really respond to my earlier comment.  Why are you doing
> things this way.  As far as I can see, only becuase it is quicker to
> implement.

And because it will be/is used. Even current inotify is very rarely used
(it was created to solve particular problem for single application
those days) by similar to beagle programms, do you really expect they
suddenly will jump into the vagon and change the whole interfaces
because of that fact, that new events have pid not in old cookie but in
additional field? That new inotify1() will be used by my single
application only :) While I propose to extend existing interface not
disturbing anyone.

And I actually answered, that this may be a good idea for the new
project. Although if things work right now no one will ever try to
change it. It does not work in my case, so I need to invent as simple
as possible way to fix it.

> > Plus, if it is that hard to comment on patch which adds 14 (!) lines
> > including blank, which feedback we should expect on larger one? :)
> 
> Still NAK, sorry.

That was kind of rhetorical question, I understood that you want to
change interface to something different with cleaner layout :)
Like having pid in a different field, which will be unused for all
events except those originated from the processes with the same UID as
watcher application.

But now I'm curious about feedback you think will be done for the
updated version?

-- 
	Evgeniy Polyakov
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
