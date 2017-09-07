From: Steve Grubb <sgrubb@redhat.com>
Subject: Re: [PATCH 1/1] audit: Record fanotify access control decisions
Date: Thu, 07 Sep 2017 11:47:35 -0400
Message-ID: <1667585.mjpkScgXOW@x2>
References: <1970763.eSnnJ2BxMO@x2> <5301085.IFoDo9S5Tc@x2> <20170907101805.GB12167@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20170907101805.GB12167@quack2.suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Cc: fsdevel <linux-fsdevel@vger.kernel.org>, Linux Audit <linux-audit@redhat.com>, Paul Moore <pmoore@redhat.com>, Amir Goldstein <amir73il@gmail.com>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Hello Jan,

> > On Thursday, September 7, 2017 6:18:05 AM EDT Jan Kara wrote:
> On Wed 06-09-17 13:34:32, Steve Grubb wrote:
> > On Wednesday, September 6, 2017 12:48:21 PM EDT Jan Kara wrote:
> > > On Wed 06-09-17 10:35:32, Steve Grubb wrote:
> > > > On Wednesday, September 6, 2017 5:18:22 AM EDT Jan Kara wrote:
> > > > > Or is it that for CCrequirements you have to implement some deamon
> > > > > which will arbitrate access using fanotify and you need to have
> > > > > decisions logged using kernel audit interface?
> > > > 
> > > > Yes. And even virus scanners would probably want to allow admins to
> > > > pick when they record something being blocked.
> > > 
> > > But then if I understand it correctly, you would need to patch each and
> > > every user of fanotify permission events to know about FAN_AUDIT to meet
> > > those CC requirements?
> > 
> > Not really. For CC, the mechanism just needs to be available.
> > 
> > > That seems pretty hard to do to me and even it done, it sounds like
> > > quite a bit of duplication?
> > 
> > AFAIK, there is only one that needs to get patched. It's totally opt in.
> 
> I see. Thanks for explanation. But still, for this feature to make a real
> difference, you'll have to implement FAN_AUDIT (and corresponding
> filtering) in all programs using fanotify permission events on your system,
> won't you? 

In real life, perhaps. For common criteria, the developer defines a baseline 
of applications that make up the Target Of Evaluation. One would normally make 
sure all applications that make up the TOE correctly implement the security 
features and demonstrate this with a test suite. So, in this case, I know of 
only one application that needs patching.

Out of curiosity, what other applications would need patching that you know 
of?

> Otherwise decisions from those programs won't get logged and
> you'll have incomplete information which presumably breaks audit
> requirements.

Usually systems can be defined where everything is consistent. For example, 
passwd and shadow-utils are patched for auditing and libuser is not.


> > > So wouldn't it be better design to pipe all fanotify access decisions to
> > > audit subsystem which would based on policy decide whether the event
> > > should be logged or not?
> > 
> > There can be a lot of information to wade through. Normally, we don't
> > parse events in the kernel or user space. They are in a race to keep
> > events flowing so that the kernel stays fast and responsive. There are
> > buffer limits where if we too far behind we start losing events. The
> > decision to log should be rare. So, if we get lots of events that don't
> > need to be logged, it will slow down the whole kernel.
> > 
> > But besides the performance side of it, the audit subsystem has part of
> > the information to make a decision on whether or not this one should be
> > logged. It doesn't know the same information as the daemon that is
> > deciding to grant access. Only the daemon granting access knows if this
> > one file alone should get an audit record. And based on the fanotify API
> > there is no way to pass along additional information that could be taken
> > into account by the audit subsystem for its decision.
> 
> Ok, I think I'm starting to understand this. The audit event about fanotify
> refusing the access is generally a supplemental information to another
> event informing about access being denied, isn't it? So you want to log it
> if and only if denied access event will be logged. Am I getting it right?

No, it could be when an access is granted, too. Some people are paranoid and 
may want information on approvals and denials for specific kinds of files or 
users. Again, its not a blanket policy where everything denied must be 
recorded. We should leave that decision to the admin to determine what he 
wants recorded.


> So the application handling fanotify permission events would parse audit
> rules in /etc/audit.rules, decide whether its decision would lead to event
> being logged and if yes, it would set FAN_AUDIT in its response so that
> supplemental information is also logged. Right?

I wouldn't imagine it like that. The way I see it, the daemon that determines 
access has its own set of rules. In those rules there would be some syntax 
about attributes of the file to match against and then what to do if it 
matches. It could either be deny, approve, deny with audit, or approve with 
audit. In the case of a virus scanner, the rule is implicit any signature 
match is denial.

In this way, the daemon and audit system do not need to know anything about 
each other. AppArmor and Selinux are the same way. They have their own rules 
and they decide whether or not an audit event should be generated.

 
> > > I assume something like this must be working when access
> > > is denied e.g. because of file permissions? And again I appologize for
> > > my total ignorance of how audit works...
> > 
> > We have control over that, too. You can audit all EPERM events or you can
> > be selective about getting them from a specific directory, application,
> > user, or MAC label. To get this kind of granularity would mean making
> > another filter in the kernel and loading a set of rules which duplicates,
> > for the most part, the rules the access daemon has. Then we'd still need
> > the identifier saying the event originated from the fanotify subsystem.
> > This leads to a lot more complexity.
> 
> OK, understood. But with FAN_AUDIT design, you still have to duplicate this
> functionality - in each application using fanotify permission events which
> wants to be conformant to CC criteria if I understand things right. Sure it
> is different from duplicating in the kernel, you can have shared libraries
> helping with this etc. But still it doesn't look like an ideal situation?

To add this capability to other apps should be small effort. I really don't 
like the audit all denies, because it removes the selectivity from the admin. 
They can't decide based on storage requirements how much they want to audit. 
So, I really advocate keeping the decision to audit in the rules of the 
application granting or denying access.


> One idea I had was: Couldn't we store fanotify decision in audit_context
> and then if we find event needs to be emitted, we also additionally emit
> the fact that fanotify is the reason?

That is kind of how the patch works. When the user space daemon sees an access 
that the admin thought was important, it tags the decision wit an audit bit 
which in turn causes a call into the audit code to add an auxiliary record to 
the context and if the event has not be determined to be of interest to the 
audit system to override that and saying this is of interest generate the 
event on syscall exit.

> > As it stands, the patch set adds 24 lines of code. So, its much more
> > minimalistic and places the decision in the only thing that truly knows if
> > an event is needed. But let's examine that a bit.
> > 
> > The user space daemon could also directly log an event through the user
> > space API. But, it would need to gather a lot of information to fully
> > identify the subject and objects in the event. There is a size limit on
> > how big an event could be. So, if we have a file that is at PATH_MAX and
> > has control characters in it, we would need 8192 bytes to log the
> > filename. Add in the MAC labels and other house keeping and we have less
> > than 100 bytes to log information.
> > 
> > This also means we need to make new parsers and design reporting to make
> > sense of this new record format. So, due to these size limits, it more
> > robust to generate the record in the kernel and coopt all the reporting
> > mechanisms that are already in place.
> > 
> > So, to sum it up, doing it this was is better performance for the kernel,
> > only needs 24 or so additional lines of code in the kernel, only 4 lines
> > in the user space daemon, and 4 lines in the user space audit code. Its
> > the simplest approach with the best targeting of events.
> > 
> > Does this help?
> 
> Thanks for detailed explanation! So I'm not at all concerned about
> complexity of the kernel patch - you are right it is trivial. My concern is
> more that this adds userspace visible API so once we add it, we have to
> maintain it forever. So I'd like to get the API right (so that we don't
> have to add new API for the same thing in a few years) - filesystem
> notification interfaces are an area where we particularly suffer from API
> design mistakes - even the third incarnation of the API (fanotify) is not
> ideal...

OK. I have some more ideas on improvements that I'll share in time.


> I understand the difficulty of associating fanotify response with the
> object (and thus other audit events) from userspace. So I agree that
> doesn't look like an easier way to go. On the other hand bear in mind there
> can be several processes mediating access through fanotify and you can end
> up with supplemental messages like (expanding your example):
> 
> type=FANOTIFY msg=audit(1504310584.332:290): resp=1
> type=FANOTIFY msg=audit(1504310584.332:290): resp=1
> type=FANOTIFY msg=audit(1504310584.332:290): resp=1
> type=FANOTIFY msg=audit(1504310584.332:290): resp=2
> 
> (or possibly without the FAN_ALLOW messages - do we want to log those?) and
> you have no way to determine which process actually denied the access. I'm
> not sure whether this matters or not but I can imagine some users
> complaining about this so I wanted to point that out.

I was also thinking about that and I think we can add that to the event 
easily. One other thing that I think could be helpful is if the daemon could 
also write a reason code or something like the rule number that its enforcing. 
Would that be something useful? (I could imagine a security officer wanting 
the rule association.) If so, then maybe we can carve out more bits of the 
response to be used by the daemon for a reason code?

-Steve
