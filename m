From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: kdbus: add code to gather metadata
Date: Sat, 1 Nov 2014 09:19:48 -0700
Message-ID: <CALCETrXxx4juUGA3mwOxq0BtErM0kj7_THxiO5LwCVLzCXnd2A@mail.gmail.com>
References: <1414620056-6675-1-git-send-email-gregkh@linuxfoundation.org>
 <1414620056-6675-7-git-send-email-gregkh@linuxfoundation.org>
 <CALCETrWqbpxk83L0k0_78JZCO+ntZhx_hHMcRu=vxs6VE2f5JQ@mail.gmail.com>
 <CALCETrVkuKxMMEw3HBEOZoFUuw8PndXtB13+bLWmcp_E34SaFw@mail.gmail.com>
 <5451FA9B.8070501@zonque.org> <CALCETrWjOS0AHF33zN0Vy1NC1441To7AgNPge3sKCz8bn2d8gg@mail.gmail.com>
 <54525F32.3040502@zonque.org> <CALCETrV6MLYUQN6mqZbH=FrLyrETVoemtdC05po8+X=6SKQ70A@mail.gmail.com>
 <5454BE6E.5040507@zonque.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5454BE6E.5040507-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Marcel Holtmann <marcel-kz+m5ild9QBg9hUCZPvPmw@public.gmane.org>, Ryan Lortie <desrt-0xnayjDhYQY@public.gmane.org>, Bastien Nocera <hadess-0MeiytkfxGOsTnJN9+BGXg@public.gmane.org>, David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Djalal Harouni <tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org>, Simon McVittie <simon.mcvittie-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org>, "alban.crequy" <alban.crequy-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org>, Javier Martinez Canillas <javier.martinez-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org>, Tom Gundersen <teg-B22kvLQNl6c@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Sat, Nov 1, 2014 at 4:05 AM, Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org> wrote:
> Hi Andy,
>
> On 10/30/2014 10:01 PM, Andy Lutomirski wrote:
>> On Thu, Oct 30, 2014 at 8:54 AM, Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org> wrote:
>
>>> We merely allow user that are connected to a bus to query the
>>> credentials of the creator of the bus they're connected to.
>>
>> Why do you allow this?  What purpose does it serve?  Is that idea that
>> each application will own one bus?  If so, what goes wrong if you only
>> capture the specific credentials that the creator of a given bus asks
>> to have captured?
>
> There are different kinds of buses. There is the system bus and a number
> of user buses. It's really useful to be able to identify the user who
> owns one of these user buses, for the sake of access control. More
> specifically, we have a compatibility service called "bus-proxy" that
> speaks the old D-Bus socket protocol on one side and translates all
> messages to kdbus messages onto the other. For that, it needs to enforce
> the old D-Bus access control semantics, which is described in XML, and
> has quite elaborate checks. In order to enforce it, it's relevant to be
> able to compare peer credentials with bus owner credentials, because
> there's usually a rule that the bus owner UID is allowed more than other
> peers.
>
> Sure, there are other ways to figure out the identity of the bus, but
> it's really nice to have similar semantics for identifying the bus
> owner. kdbus internally has that piece of information anyway, so we
> decided to export it, optionally. However, that's really a minor detail
> after all.
>

I'm sceptical about the kernel offering APIs just because it can.  I'm
not fundamentally opposed to objects (e.g. busses) having ownership
information, but I think it needs to be well-justified.

Keep in mind that the kernel *has* a concept of ownership.  It's uid,
gid, and security label.  Having the creator's full set of caps and
even *command line* as part of the ownership information is really
weird.

>>> For example, if a privileged service can reboot the system, it checks
>>> whether the asking peer has CAP_SYS_BOOT set. If it checks for uid==0
>>> instead, and it works in your tests because you happen to test as root,
>>> that just a bug in the service, right? But I might have missed your point.
>>
>> The issue is the following: if have the privilege needed to talk to
>> journald, I may want to enhance security by opening a connection to
>> journald (and capture that privilege) and then drop privilege.  I
>> should still be able to talk to journald.
>
> Hmm, this is not how D-Bus works, and kdbus stays close the design
> principles of D-Bus. There's no concept of 'opening connections to
> services'. You just connect to a bus, and then on that bus, you send
> individual messages and method calls to other services.
>
> The design of Binder and D-Bus are fundamentally different in that
> regard. On D-Bus, the focus is really about method call transaction (a
> method call message and a corresponding reply message), and there's no
> way to continuously reference a peer via the concept of a 'connection'.
>
> This is why we have this functionality of passing over the caller creds
> every time a method call is made. The focus is really on the individual
> method call transaction, each one is individually routed, dispatched and
> checked for permission. Hence, it should carry individual credential
> information from the time the call is issued.
>
> So, back to your example: you cannot 'open a connection to journald'.
> You can only connect to a bus and send messages to journald.

But you can open a kdbus fd.  IMO there should be some actual thought
as to what should happen if that credentials change after the fd is
opened.  The default answer in UNIX is that credentials are only
checked at open time.  Violating that should have a good reason.

>
>> Alternatively, if the privilege needed to reboot is CAP_SYS_BOOT, then
>> clients should send that capability bit.  Capturing extra information
>> to try to give daemons the flexibility to change their authorization
>> conditions later on just moves the problem if you need to change
>> policy down the line.
>
> This would be similar to changing the Linux kernel so that each system
> call gets a set of capabilities passed in explicitly. RPC calls are very
> much comparable to syscalls, though they don't transition into kernel
> space, but simply into another process.

That would be a fantastic idea, and, in fact, it would have been
vastly better if syscalls had always worked that way.  It's how
anything on a network *has* to work, it's how object capability
systems work (and object capability systems are much less prone to
security bugs caused by overcomplicated implicit checks), and it's how
Capsicum (which builds on POSIX!) works.

>
> We've been augmenting what syscalls check on for access control ever
> since. Initially, it check was UID based, then became capability based,
> and nowadays we have a concept of MACs, that are actually different on
> every system, because some systems use SElinux, some SMACK or some other
> MAC. This is why this metadata should be implicit and controlled by the
> receiver, not by the sender, because the implementation of the policy
> might change eventually, be extended with more sophisticated access
> control etc.

I agree that this is convenient, but it's a hack, and we've only
gotten away with it so far because only something that's very much in
the trusted computing base can see this information at all.  And I
strongly suspect that, if I were inclined to try to break SELinux, I
could find any number of rather fundamental holes based on the fact
that it adds checks to capabilities in places where they didn't exist
originally.

>
> But it's not only about access control, there's also auditing. In order
> to generate useful audit logs, a system service that is offering
> privileged operation to certain clients needs to know the audit
> credentials (sessionid and loginuid). Hence, this information needs to
> be implicitly appended, controlled by that service. Because if it is not
> implicitly appended, than it will more often be missing than expected
> (simply because in real-life very few people actually use auditing), and
> the system service would not be able to log about it.
>
> So, this is not a metadata leak by accident but metadata that system
> services need to know about in order to work properly. Individual
> services will require slightly different components of these
> credentials, but if you combine things, they need to know pretty much
> all of the details we currently offer as implied metadata.

Sorry, but this is bogus.  The audit system is a bit of an unstable
mess, and, to all appearances, its main design goal seems to be
regulatory compliance instead of actual security.  It seems to be
mostly harmless, but only because all of the data gathered by auditd
that should never have existed in the first place can only be
collected by an extremely privileged global daemon and is shoved in
logs that no one outside the TCB can read.

If you want a configurable-out off-by-default bolt-on system that
allows auditd (and nothing else!) to sniff kdbus busses and log
whatever random crap it wants to log (and keep it the hell out of the
part of the journal that unprivileged users can see), then do so.

>
> The system bus is about unprivileged apps asking system services for
> system operations, in which case the system services must have a way to
> know who wants them to do what. The purpose of a system bus is _not_ to
> allow unprivileged peers to talk to each other, that's actually even
> forbidden in the default policy. That's what user buses are for, and on
> those, pretty much every client will have the same privileges anyway,
> hence there's no information leak there either.

This is nonsense.  If you don't need real access control on user
busses, then *don't add any*.

Except that you *do* need real access control, because of containers,
seccomp, the Chromium sandbox, the upcoming Firefox sandbox, all of
the other little sandboxes that should exist but don't yet, remoting,
etc.  And I guarantee that your list of implicitly transmitted
credentials will fail to handle this case, and this case is the only
one that really matters.  At the end of the day, you're going to need
either crypto, something like object capabilities, or an access
broker.  And none of those benefit at all from the current proposed
model.  (And none of them check anything like implicit credentials at
the time of an RPC call, either.)

Interestingly, it sounds to be like traditional D-Bus will work
considerably better than kdbus in this scenario.

As a concrete example, Wayland takes sensitive operations like
screenshots very seriously.  Which of the kdbus metadata items would
be appropriate to use for access control for something like that?

>
>> What's the actual problem for logging?  I very much understand why a
>> logging service never wants to log an incorrect credential (and legacy
>> syslog has serious problems here because it doesn't even try to
>> capture credential), but what's wrong with having a log that shows the
>> uid for legit log messages and that reliably says "declined to state"
>> for messages that decline to state.
>
> A system's administrator should be able to gather all sorts of
> information about things that happened on a system. Trying to hide
> associated metadata is not how things are done anyway - we show it in
> numerous places, in /proc, in SCM_CREDENTIALS, by listing /tmp or /home etc.

See above.  The sysadmin != every single kdbus user.

>> (Also, I presume that cmdline is for logging.  Keep in mind that the
>> cmdline is yanked from user memory and can be freely spoofed.)
>
> Sure. But If a task did that, we want to know about it, and log it
> accordingly. Journald provides such features already today, and it's a
> great deal in detecting runtime inconsistencies between a task's real
> nature and what is displayed in 'ps'.
>

Sorry, but this is a bit off the deep end.  The kdbus logging
mechanism shouldn't be in the business of trying to do this, because
it's out of scope, and it will fail.

You can't justify logging fundamentally unverifiable things like the
command line by saying that you want to know if someone tries to play
(impossible-to-reliably-detect) games to obscure their command line.

--Andy
