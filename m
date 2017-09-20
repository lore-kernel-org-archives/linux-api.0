From: Steve Grubb <sgrubb@redhat.com>
Subject: Re: [PATCH 1/1] audit: Record fanotify access control decisions
Date: Wed, 20 Sep 2017 18:47:06 -0400
Message-ID: <1682056.acYO5bKGhE@x2>
References: <1970763.eSnnJ2BxMO@x2> <1667585.mjpkScgXOW@x2> <20170908105545.GB30332@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20170908105545.GB30332@quack2.suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Cc: fsdevel <linux-fsdevel@vger.kernel.org>, Linux Audit <linux-audit@redhat.com>, Paul Moore <pmoore@redhat.com>, Amir Goldstein <amir73il@gmail.com>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Hello Jan,

On Friday, September 8, 2017 6:55:45 AM EDT Jan Kara wrote:
> Hello Steve,
> 
> On Thu 07-09-17 11:47:35, Steve Grubb wrote:
> > > > On Thursday, September 7, 2017 6:18:05 AM EDT Jan Kara wrote:
> > > On Wed 06-09-17 13:34:32, Steve Grubb wrote:
> > > > On Wednesday, September 6, 2017 12:48:21 PM EDT Jan Kara wrote:
> > > > > On Wed 06-09-17 10:35:32, Steve Grubb wrote:
> > > > > > On Wednesday, September 6, 2017 5:18:22 AM EDT Jan Kara wrote:
> > > > > > > Or is it that for CCrequirements you have to implement some
> > > > > > > deamon which will arbitrate access using fanotify and you need
> > > > > > > to have decisions logged using kernel audit interface?
> > > > > > 
> > > > > > Yes. And even virus scanners would probably want to allow admins
> > > > > > to pick when they record something being blocked.
> > > > > 
> > > > > But then if I understand it correctly, you would need to patch each
> > > > > and every user of fanotify permission events to know about FAN_AUDIT
> > > > > to meet those CC requirements?
> > > > 
> > > > Not really. For CC, the mechanism just needs to be available.
> > > > 
> > > > > That seems pretty hard to do to me and even it done, it sounds like
> > > > > quite a bit of duplication?
> > > > 
> > > > AFAIK, there is only one that needs to get patched. It's totally opt
> > > > in.
> > > 
> > > I see. Thanks for explanation. But still, for this feature to make a
> > > real difference, you'll have to implement FAN_AUDIT (and corresponding
> > > filtering) in all programs using fanotify permission events on your
> > > system, won't you?
> > 
> > In real life, perhaps. For common criteria, the developer defines a
> > baseline of applications that make up the Target Of Evaluation. One would
> > normally make sure all applications that make up the TOE correctly
> > implement the security features and demonstrate this with a test suite.
> > So, in this case, I know of only one application that needs patching.
> > 
> > Out of curiosity, what other applications would need patching that you
> > know of?
> 
> I've never used Audit for security certifications so I don't really know.
> But I've used it several times for debugging system behavior and there it
> would be handy to have all applications supported. But we have ftrace for
> that these days.
> 
> I can only imagine paranoid admin wanting to know whether his $favourite
> virus scanner refused some access. And it would be nice if all such
> scanners were automatically supported instead to having to add support for
> each of them.

But to set the flag on, the virus scanner software has to call fanotify_init 
and ask for it. So, I don't think there is a magic bullet. I'm not proposing a 
sysctl, so there is no one place for an admin to turn it on. I think that we 
can make the facility available and they (virus scanner developers) can opt in 
on their next product update.


> > > > > So wouldn't it be better design to pipe all fanotify access
> > > > > decisions to audit subsystem which would based on policy decide
> > > > > whether the event should be logged or not?
> > > > 
> > > > There can be a lot of information to wade through. Normally, we don't
> > > > parse events in the kernel or user space. They are in a race to keep
> > > > events flowing so that the kernel stays fast and responsive. There are
> > > > buffer limits where if we too far behind we start losing events. The
> > > > decision to log should be rare. So, if we get lots of events that
> > > > don't need to be logged, it will slow down the whole kernel.
> > > > 
> > > > But besides the performance side of it, the audit subsystem has part
> > > > of the information to make a decision on whether or not this one
> > > > should be logged. It doesn't know the same information as the daemon
> > > > that is deciding to grant access. Only the daemon granting access
> > > > knows if this one file alone should get an audit record. And based on
> > > > the fanotify API there is no way to pass along additional information
> > > > that could be taken into account by the audit subsystem for its
> > > > decision.
> > > 
> > > Ok, I think I'm starting to understand this. The audit event about
> > > fanotify refusing the access is generally a supplemental information to
> > > another event informing about access being denied, isn't it? So you want
> > > to log it if and only if denied access event will be logged. Am I 
> > > getting it right?
> > 
> > No, it could be when an access is granted, too. Some people are paranoid
> > and may want information on approvals and denials for specific kinds of
> > files or users. Again, its not a blanket policy where everything denied
> > must be recorded. We should leave that decision to the admin to determine
> > what he wants recorded.
> > 
> > > So the application handling fanotify permission events would parse audit
> > > rules in /etc/audit.rules, decide whether its decision would lead to
> > > event being logged and if yes, it would set FAN_AUDIT in its response so
> > > that supplemental information is also logged. Right?
> > 
> > I wouldn't imagine it like that. The way I see it, the daemon that
> > determines access has its own set of rules. In those rules there would be
> > some syntax about attributes of the file to match against and then what
> > to do if it matches. It could either be deny, approve, deny with audit,
> > or approve with audit. In the case of a virus scanner, the rule is
> > implicit any signature match is denial.
> > 
> > In this way, the daemon and audit system do not need to know anything
> > about each other. AppArmor and Selinux are the same way. They have their
> > own rules and they decide whether or not an audit event should be
> > generated.
>
> OK, I can see why this is interesting. But then the audit event should have
> enough information to be useful on its own, shouldn't it? Because currently
> it is only context-id and response, which is useless on its own...

Agreed. Way back in the original email, I gave the event that is triggered:

type=PATH msg=audit(1504310584.332:290): item=0 name="./evil-ls"
inode=1319561 dev=fc:03 mode=0100755 ouid=1000 ogid=1000 rdev=00:00
obj=unconfined_u:object_r:user_home_t:s0 nametype=NORMAL
type=CWD msg=audit(1504310584.332:290): cwd="/home/sgrubb"
type=SYSCALL msg=audit(1504310584.332:290): arch=c000003e syscall=2
success=no exit=-1 a0=32cb3fca90 a1=0 a2=43 a3=8 items=1 ppid=901
pid=959 auid=1000 uid=1000 gid=1000 euid=1000 suid=1000
fsuid=1000 egid=1000 sgid=1000 fsgid=1000 tty=pts1 ses=3 comm="bash"
exe="/usr/bin/bash" subj=unconfined_u:unconfined_r:unconfined_t:
s0-s0:c0.c1023 key=(null)
type=FANOTIFY msg=audit(1504310584.332:290): resp=2

This ^^^ is complete information. You have the user, program, file, devvice, 
inode, security labels, modes, owners, tty, login session, and a record 
indicating this is the result of fanotify.
 
> > > One idea I had was: Couldn't we store fanotify decision in audit_context
> > > and then if we find event needs to be emitted, we also additionally emit
> > > the fact that fanotify is the reason?
> > 
> > That is kind of how the patch works. When the user space daemon sees an
> > access that the admin thought was important, it tags the decision wit an
> > audit bit which in turn causes a call into the audit code to add an
> > auxiliary record to the context and if the event has not be determined to
> > be of interest to the audit system to override that and saying this is of
> > interest generate the event on syscall exit.
> 
> OK, understood. So the only place where we differ is whether the process
> processing fanotify permission events decide about logging the event or
> whether kernel should decide about logging on its own. My though was that
> we could have something like another filesystem event type - currently we
> can decide about logging reads, writes, execute, ... now we could also
> decide about logging of fanotify decisions but I'm not sure whether this
> would reasonably tie into audit philosophy.

I don't think so. What I've got above is complete information. Wrt to logging 
it always, there really can be a lot of normal system activity.

> So I'm still not 100% convinced putting decision about logging the event
> into application is a great idea (after all we don't put burden of logging
> denied access due to permissions e.g. to FUSE daemon which denied the
> access) but I'm now less opposed to it ;)

Hmm. That is something I haven't looked into yet. But if anything makes 
information flow control decisions, it is subject to needing to be auditable. 
One of these days I need to visit policyKit and see about adding audit there.


> > > I understand the difficulty of associating fanotify response with the
> > > object (and thus other audit events) from userspace. So I agree that
> > > doesn't look like an easier way to go. On the other hand bear in mind
> > > there can be several processes mediating access through fanotify and you
> > > can end up with supplemental messages like (expanding your example):
> > > 
> > > type=FANOTIFY msg=audit(1504310584.332:290): resp=1
> > > type=FANOTIFY msg=audit(1504310584.332:290): resp=1
> > > type=FANOTIFY msg=audit(1504310584.332:290): resp=1
> > > type=FANOTIFY msg=audit(1504310584.332:290): resp=2
> > > 
> > > (or possibly without the FAN_ALLOW messages - do we want to log those?)
> > > and you have no way to determine which process actually denied the
> > > access. I'm not sure whether this matters or not but I can imagine some
> > > users complaining about this so I wanted to point that out.
> > 
> > I was also thinking about that and I think we can add that to the event
> > easily. One other thing that I think could be helpful is if the daemon
> > could
>
> So it is easy to add inode / file where the event happened (which would be
> IMHO useful if the events should be mostly standalone), adding PID of the
> process whose access is mediated is easy as well (that's just the running
> process in whose context we generate the event). Adding PID of the process
> which decided about access is more difficult (we have only file descriptor
> where we send event) however we could attach that information internally to
> fanotify_event() in process_access_response() and then pick it up when
> generating audit event.

That would be helpful for other reasons and is along the lines of some other 
suggestions that I would like to make in the near future.


> > also write a reason code or something like the rule number that its
> > enforcing. Would that be something useful? (I could imagine a security
> > officer wanting the rule association.) If so, then maybe we can carve out
> > more bits of the response to be used by the daemon for a reason code?
> 
> I'd be wary of adding blanket "reason code". Without a clear meaning there
> would be inconsistencies among applications and so it would be useless. If
> you have more concrete proposal, we can talk about it.

I'll think about it and if I come up with something that could be widely 
applicable, I'll mention it. So, let's punt that one for another time.

To sum things up, I think you suggested changing the memory allocation and 
making a flag that is passed so that the program can detect that this is 
supported or not. Let me know if we have a general agreement and I'll send an 
updated patch.

Best Regards,
-Steve
