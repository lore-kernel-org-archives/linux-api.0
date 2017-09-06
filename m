From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/1] audit: Record fanotify access control decisions
Date: Wed, 6 Sep 2017 18:48:21 +0200
Message-ID: <20170906164821.GA10018@quack2.suse.cz>
References: <1970763.eSnnJ2BxMO@x2>
 <20170906091822.GB27916@quack2.suse.cz>
 <5434938.YfYYiuuLFk@x2>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5434938.YfYYiuuLFk@x2>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Steve Grubb <sgrubb@redhat.com>
Cc: Jan Kara <jack@suse.cz>, fsdevel <linux-fsdevel@vger.kernel.org>, Linux Audit <linux-audit@redhat.com>, Paul Moore <pmoore@redhat.com>, Amir Goldstein <amir73il@gmail.com>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed 06-09-17 10:35:32, Steve Grubb wrote:
> On Wednesday, September 6, 2017 5:18:22 AM EDT Jan Kara wrote:
> > On Tue 05-09-17 14:32:07, Steve Grubb wrote:
> > > The fanotify interface allows user space daemons to make access
> > > 
> > >  control decisions. Under common criteria requirements, we need to
> > >  optionally record decisions based on policy. This patch adds a bit mask,
> > >  FAN_AUDIT, that a user space daemon can 'or' into the response decision
> > >  which will tell the kernel that it made a decision and record it.
> > 
> > [Since this is API change, added linux-api to CC, also added Amir since he
> > works with fanotify]
> > 
> > Hum, probably I'm missing something here but why an application responding
> > to fanotify event should need to know about audit?
> 
> Common Criteria rules are that if anything can prevent a flow of information, 
> then you must be able to selectively audit. Selectively audit means under 
> admin direction only when they want it. Meaning they may want some denials or 
> approvals but not other ones.

OK, thanks for explanation.

> > Or is it that for CCrequirements you have to implement some deamon which
> > will arbitrate access using fanotify and you need to have decisions logged
> > using kernel audit interface?
> 
> Yes. And even virus scanners would probably want to allow admins to pick when 
> they record something being blocked.

But then if I understand it correctly, you would need to patch each and
every user of fanotify permission events to know about FAN_AUDIT to meet
those CC requirements? That seems pretty hard to do to me and even it done,
it sounds like quite a bit of duplication?

So wouldn't it be better design to pipe all fanotify access decisions to
audit subsystem which would based on policy decide whether the event should
be logged or not? I assume something like this must be working when access
is denied e.g. because of file permissions? And again I appologize for my
total ignorance of how audit works...

> > > +void __audit_fanotify(unsigned int response)
> > > +{
> > > +	audit_log(current->audit_context, GFP_ATOMIC,
> > > +		AUDIT_FANOTIFY,	"resp=%u", response);
> > > +}
> > 
> > Heh, GFP_ATOMIC looks pretty crude and it can fail more often than you'd
> > think. In fact fanotify uses GFP_KERNEL for allocation of new event and I
> > don't see a reason why __audit_fanotify() couldn't use the same.
> 
> Sure, that's easy enough to change. Is that the only change needed? Is
> the choice of 0x80 for the FAN_AUDIT bit OK? I wanted to leave some room
> for other numbers if there ever was a new use. The number is arbitrary
> and could be anything.

Yeah, 0x80 for FAN_AUDIT is OK. Also Amir's comment about fanotify_init()
flag should be reflected. But I'd really like to understand why design like
this was chosen before merging the change.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
