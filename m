From: Steve Grubb <sgrubb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/1] audit: Record fanotify access control decisions
Date: Wed, 06 Sep 2017 13:34:32 -0400
Message-ID: <5301085.IFoDo9S5Tc@x2>
References: <1970763.eSnnJ2BxMO@x2> <5434938.YfYYiuuLFk@x2> <20170906164821.GA10018@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170906164821.GA10018-4I4JzKEfoa/jFM9bn6wA6Q@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Cc: fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Audit <linux-audit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Paul Moore <pmoore-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Amir Goldstein <amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hello Jan,

On Wednesday, September 6, 2017 12:48:21 PM EDT Jan Kara wrote:
> On Wed 06-09-17 10:35:32, Steve Grubb wrote:
> > On Wednesday, September 6, 2017 5:18:22 AM EDT Jan Kara wrote:
> > > Or is it that for CCrequirements you have to implement some deamon which
> > > will arbitrate access using fanotify and you need to have decisions
> > > logged using kernel audit interface?
> > 
> > Yes. And even virus scanners would probably want to allow admins to pick
> > when they record something being blocked.
> 
> But then if I understand it correctly, you would need to patch each and
> every user of fanotify permission events to know about FAN_AUDIT to meet
> those CC requirements? 

Not really. For CC, the mechanism just needs to be available.


> That seems pretty hard to do to me and even it done, it sounds like quite a
> bit of duplication?

AFAIK, there is only one that needs to get patched. It's totally opt in.


> So wouldn't it be better design to pipe all fanotify access decisions to
> audit subsystem which would based on policy decide whether the event should
> be logged or not?

There can be a lot of information to wade through. Normally, we don't parse 
events in the kernel or user space. They are in a race to keep events flowing 
so that the kernel stays fast and responsive. There are buffer limits where if 
we too far behind we start losing events. The decision to log should be rare. 
So, if we get lots of events that don't need to be logged, it will slow down 
the whole kernel.

But besides the performance side of it, the audit subsystem has part of the 
information to make a decision on whether or not this one should be logged. It 
doesn't know the same information as the daemon that is deciding to grant 
access. Only the daemon granting access knows if this one file alone should 
get an audit record. And based on the fanotify API there is no way to pass 
along additional information that could be taken into account by the audit 
subsystem for its decision.


> I assume something like this must be working when access
> is denied e.g. because of file permissions? And again I appologize for my
> total ignorance of how audit works...

We have control over that, too. You can audit all EPERM events or you can be 
selective about getting them from a specific directory, application, user, or 
MAC label. To get this kind of granularity would mean making another filter in 
the kernel and loading a set of rules which duplicates, for the most part, the 
rules the access daemon has. Then we'd still need the identifier saying the 
event originated from the fanotify subsystem. This leads to a lot more 
complexity.

As it stands, the patch set adds 24 lines of code. So, its much more 
minimalistic and places the decision in the only thing that truly knows if an 
event is needed. But let's examine that a bit.

The user space daemon could also directly log an event through the user space 
API. But, it would need to gather a lot of information to fully identify the 
subject and objects in the event. There is a size limit on how big an event 
could be. So, if we have a file that is at PATH_MAX and has control characters 
in it, we would need 8192 bytes to log the filename. Add in the MAC labels and 
other house keeping and we have less than 100 bytes to log information.

This also means we need to make new parsers and design reporting to make sense 
of this new record format. So, due to these size limits, it more robust to 
generate the record in the kernel and coopt all the reporting mechanisms that 
are already in place.

So, to sum it up, doing it this was is better performance for the kernel, only 
needs 24 or so additional lines of code in the kernel, only 4 lines in the 
user space daemon, and 4 lines in the user space audit code. Its the simplest 
approach with the best targeting of events.

Does this help?

> > > > +void __audit_fanotify(unsigned int response)
> > > > +{
> > > > +	audit_log(current->audit_context, GFP_ATOMIC,
> > > > +		AUDIT_FANOTIFY,	"resp=%u", response);
> > > > +}
> > > 
> > > Heh, GFP_ATOMIC looks pretty crude and it can fail more often than you'd
> > > think. In fact fanotify uses GFP_KERNEL for allocation of new event and
> > > I don't see a reason why __audit_fanotify() couldn't use the same.
> > 
> > Sure, that's easy enough to change. Is that the only change needed? Is
> > the choice of 0x80 for the FAN_AUDIT bit OK? I wanted to leave some room
> > for other numbers if there ever was a new use. The number is arbitrary
> > and could be anything.
> 
> Yeah, 0x80 for FAN_AUDIT is OK. Also Amir's comment about fanotify_init()
> flag should be reflected. But I'd really like to understand why design like
> this was chosen before merging the change.

Sure. I'll add that into v2 of the patch.

Thanks,
-Steve
