From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH 2/2] block: create ioctl to discard-or-zeroout a range of blocks
Date: Thu, 3 Mar 2016 09:55:38 -0800
Message-ID: <CA+55aFwPA1X8XGTdVZmP5uzkWMwj+X=bjkGVcEkZDme+qskrzQ@mail.gmail.com>
References: <20160302040932.16685.62789.stgit@birch.djwong.org>
	<20160302040947.16685.42926.stgit@birch.djwong.org>
	<CA+55aFx_NPn0VYk=+Ad5S_r=D6J1xFmWmf7JzQ7RmkwKmdkYOg@mail.gmail.com>
	<20160302225601.GB21890@birch.djwong.org>
	<CA+55aFyNPnjJ-Nsu3bMr+HuLQnkj1B8FMddNnXW7HJqxdUzJmQ@mail.gmail.com>
	<20160303170205.GD24012@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160303170205.GD24012-AKGzg7BKzIDYtjvyW6yDsg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, shane.seymour-ZPxbGqLxI0U@public.gmane.org, Bruce Fields <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Mar 3, 2016 at 9:02 AM, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org> wrote:
>
> There is a massive bug in the SATA specs about trim, which is that it
> is considered advisory.  So the storage device can throw it away
> whenever it feels like it.  (In practice, when it's too busy doing
> other things).

Ugh.

But that essentially says that we shouldn't expose this interface at
all (unless we trust our white-lists - I'm sure they are getting
better, but if nobody has ever really _relied_ on the zeroing behavior
of trim, then I guess there could be tons of bugs lurking).

Or maybe we should expose it, but not call it BLKZEROOUT, and make it
*much* more generic.

That migth actually put some of my complaints to rest: if this is more
a general "manage this range of blocks" model, then the flags make
more sense to me.

So what are people actually wanting to do?

If they don't care horribly about the zeroing, they might then say
"using trim is ok". But why wouldn't they use the BLKDISCARD ioctl
then?

So just looking at this more, that "trim is ok" flag still doesn't
make much sense to me.

I see two cases: either we guarantee zero-out behavior with discard
set to true (and we trust our whitelists), or we don't. Can anybody
see a third alternative?

And if we don't guarantee zero-out behavior from
blkdev_issue_zeroout() with "discard" set to true, then why would we
expose such a random interface to user space? No sane user space could
*possibly* use it: if they care about zeroing, it's the wrong thing to
do, and if they *don't* care about zeroing it's still the wrong thing
to do.

In other words, I still don't see how that flag can possibly make
sense in any possible scenario.

Put succinctly:

 "Either we trust trim and and our whitelists (in which case _not_
using trim makes no sense), or we do (in which case exposing a random
untrustworthy user interface is pointless, since any user would be
fundamentally broken and should just have used BLKDISCARD)"

See where I'm coming from?

Now, the reason I think a more generic model that *isn't* hung up
about zeroing the buffer migth be ok is that maybe it would be a good
thing to have a more unified itnerface for doing all those things
people do want to do:

 - flush caches

 - discard (our current BLKDISCARD doesn't flush caches either, so
together with flushing caches this is something new)

 - zero out

 - synchronous/asynchronous

 - other things?

So I do see a case for passing in multiple flags, but a lot of that
case ends up depending on the zeroing out *not* being the most central
feature.

I very much could see wanting "discard these blocks and flush caches".
And I could see just "flush caches", with or without zeroing. But I do
*not* see the point of "discard blocks and zero" for the reasons
outlined above.

                   Linus
