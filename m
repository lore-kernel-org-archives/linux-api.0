From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [RFC PATCH] fs: fsnotify: account fsnotify metadata to kmemcg
Date: Tue, 31 Oct 2017 17:52:50 +0100
Message-ID: <20171031165250.GG26128@quack2.suse.cz>
References: <1508448056-21779-1-git-send-email-yang.s@alibaba-inc.com>
 <CAOQ4uxhPhXrMLu18TGKDA=ezUVHara95qJQ+BTCio8BHm-u6NA@mail.gmail.com>
 <b530521e-5215-f735-444a-13f722d90e40@alibaba-inc.com>
 <CAOQ4uxhFOoSknnG-0Jyv+=iCDjVNnAg6SiO-msxw4tORkVKJGQ@mail.gmail.com>
 <20171031105030.GE8989@quack2.suse.cz>
 <CAOQ4uxgqR1GvuTiMreDQrx2m=V4pzcn3o2T7_YQAj46AZ7fHQQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAOQ4uxgqR1GvuTiMreDQrx2m=V4pzcn3o2T7_YQAj46AZ7fHQQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Amir Goldstein <amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Yang Shi <yang.s-gPhfCIXyaqCqndwCJWfcng@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue 31-10-17 13:51:40, Amir Goldstein wrote:
> On Tue, Oct 31, 2017 at 12:50 PM, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org> wrote:
> > On Sun 22-10-17 11:24:17, Amir Goldstein wrote:
> >> But I think there is another problem, not introduced by your change, but could
> >> be amplified because of it - when a non-permission event allocation fails, the
> >> event is silently dropped, AFAICT, with no indication to listener.
> >> That seems like a bug to me, because there is a perfectly safe way to deal with
> >> event allocation failure - queue the overflow event.
> >>
> >> I am not going to be the one to determine if fixing this alleged bug is a
> >> prerequisite for merging your patch, but I think enforcing memory limits on
> >> event allocation could amplify that bug, so it should be fixed.
> >>
> >> The upside is that with both your accounting fix and ENOMEM = overlflow
> >> fix, it going to be easy to write a test that verifies both of them:
> >> - Run a listener in memcg with limited kmem and unlimited (or very
> >> large) event queue
> >> - Produce events inside memcg without listener reading them
> >> - Read event and expect an OVERFLOW event
> >>
> >> This is a simple variant of LTP tests inotify05 and fanotify05.
> >>
> >> I realize that is user application behavior change and that documentation
> >> implies that an OVERFLOW event is not expected when using
> >> FAN_UNLIMITED_QUEUE, but IMO no one will come shouting
> >> if we stop silently dropping events, so it is better to fix this and update
> >> documentation.
> >>
> >> Attached a compile-tested patch to implement overflow on ENOMEM
> >> Hope this helps to test your patch and then we can merge both, accompanied
> >> with LTP tests for inotify and fanotify.
> >>
> >> Amir.
> >
> >> From 112ecd54045f14aff2c42622fabb4ffab9f0d8ff Mon Sep 17 00:00:00 2001
> >> From: Amir Goldstein <amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> >> Date: Sun, 22 Oct 2017 11:13:10 +0300
> >> Subject: [PATCH] fsnotify: queue an overflow event on failure to allocate
> >>  event
> >>
> >> In low memory situations, non permissions events are silently dropped.
> >> It is better to queue an OVERFLOW event in that case to let the listener
> >> know about the lost event.
> >>
> >> With this change, an application can now get an FAN_Q_OVERFLOW event,
> >> even if it used flag FAN_UNLIMITED_QUEUE on fanotify_init().
> >>
> >> Signed-off-by: Amir Goldstein <amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> >
> > So I agree something like this is desirable but I'm uneasy about using
> > {IN|FAN}_Q_OVERFLOW for this. Firstly, it is userspace visible change for
> > FAN_UNLIMITED_QUEUE queues which could confuse applications as you properly
> > note. Secondly, the event is similar to queue overflow but not quite the
> > same (it is not that the application would be too slow in processing
> > events, it is just that the system is in a problematic state overall). What
> > are your thoughts on adding a new event flags like FAN_Q_LOSTEVENT or
> > something like that? Probably the biggest downside there I see is that apps
> > would have to learn to use it...
> >
> 
> Well, I can't say I like FAN_Q_LOSTEVENT, but I can't really think of
> a better option. I guess apps that would want to provide better protection
> against loosing event will have to opt-in with a new fanotify_init() flag.
> OTOH, if apps opts-in for this feature, we can also report Q_OVERFLOW
> and document that it *is* expected in OOM situation.
> 
> If we have FAN_Q_LOSTEVENT, we can use it to handle both the case of
> error to queue event (-ENOMEM) and the case of error on copy event to user
> (e.g. -ENODEV), which is another case where we silently drop events
> (in case buffer already contains good events).
> In latter case, the error would be reported to user on event->fd.
> In the former case, event->fd will also hold the error, as long as we can only
> report -ENOMEM from this sort of error, because like overflow event, there
> should probably be only one event of that sort in the queue.
> 
> Another option for API name is {IN|FAN}_Q_ERR, which implies that event->fd
> carries the error. And of course user can get an event with mask
> FAN_Q_OVERFLOW|FAN_Q_ERR, where event->fd is -ENOMEM or
> -EOVERFLOW and then there is no ambiguity between different kind of
> queue overflows.

I like this last option. I.e., userspace can opt in to get more detailed
error notification. In that case we can report error (I think we can just
reuse {IN|FAN}_Q_OVERFLOW for that) and store more detailed error
description in wd/fd. Will you have time to implement something like that
or should I put it to my todo list?

								Honza
-- 
Jan Kara <jack-IBi9RG/b67k@public.gmane.org>
SUSE Labs, CR
