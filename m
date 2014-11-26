From: David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: kdbus: add documentation
Date: Wed, 26 Nov 2014 12:55:33 +0100
Message-ID: <CANq1E4TOe5SNmAvnjs1LCx9EGrGWxqX8qPUy26n8RzGo2kvThg@mail.gmail.com>
References: <1416546149-24799-1-git-send-email-gregkh@linuxfoundation.org>
	<1416546149-24799-2-git-send-email-gregkh@linuxfoundation.org>
	<CALCETrWUekPq6pquuiVperBihQHgcvCF=WzVJTZziHhUJYsh4Q@mail.gmail.com>
	<CANq1E4QA53-L8vPOWJfjhzXaYVQnNvgvR6AcYev0EaP6SfOjQQ@mail.gmail.com>
	<CALCETrUfNG=YwwM2m78Ua4fUr9daE1omQwOSJQMKC6CTCa28fQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALCETrUfNG=YwwM2m78Ua4fUr9daE1omQwOSJQMKC6CTCa28fQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, One Thousand Gnomes <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Tom Gundersen <teg-B22kvLQNl6c@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>, Djalal Harouni <tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi

On Mon, Nov 24, 2014 at 9:57 PM, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> wrote:
> On Mon, Nov 24, 2014 at 12:16 PM, David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> [snip]
>>>> +6.5 Getting information about a connection's bus creator
>>>> +--------------------------------------------------------
>>>> +
>>>> +The KDBUS_CMD_BUS_CREATOR_INFO ioctl takes the same struct as
>>>> +KDBUS_CMD_CONN_INFO but is used to retrieve information about the creator of
>>>> +the bus the connection is attached to. The metadata returned by this call is
>>>> +collected during the creation of the bus and is never altered afterwards, so
>>>> +it provides pristine information on the task that created the bus, at the
>>>> +moment when it did so.
>>>
>>> What's this for?  I understand the need for the creator of busses to
>>> be authenticated, but doing it like this mean that anyone who will
>>> *fail* authentication can DoS the authentic creator.
>>
>> This returns information on a bus owner, to determine whether a
>> connection is connected to a system, user or session bus. Note that
>> the bus-creator itself is not a valid peer on the bus, so you cannot
>> send messages to them. Which kind of DoS do you have in mind?
>
> I assume that the logic is something like:
>
> connect to bus
> request bus metadata
> if (bus metadata matches expectations) {
>   great, trust the bus!
> } else {
>   oh crap!
> }

Uh, no, this is really not the logic that should be assumed. It's more
for code where you want to simply pass a bus fd, and the code knows
nothing about it. Now, the code can derive some information from the
bus fd, like for example who owns it. Then, depending on some of the
creds returned it can determine whether to read configuration file set
A or B and so on. This is particularly useful for all kinds of
unprivileged bus services that end up running on any kind of bus and
need to be able to figure out what they are actually operating on.

> If I'm understanding it right, then user code only really has two
> outcomes: the good case and the "oh crap!" case.  The problem is that
> "oh crap!" isn't a clean failure -- if it happens, then the
> application has just been DoSed, because in that case, one of two
> things happened:
>
> 1. Some policy mismatch means that the legitimate bus owner did create
> the bus, but the user application is confused.  This will result in
> difficult-to-diagnose failures.
>
> 2. A malicious or confused program created the bus.  This is a DoS --
> even the legitimate bus creator can't actually create the bus now.
>
> So I think that the policy should be applied at the time that the bus
> name is claimed, not at the time that someone else tries to use the
> bus.  IOW, the way that you verify you're talking to the system bus
> should be by checking that the bus is called "system", not by checking
> that UID 0 created the bus.
>

[snip]

>>>> +
>>>> +Also, if the connection allowed for file descriptor to be passed
>>>> +(KDBUS_HELLO_ACCEPT_FD), and if the message contained any, they will be
>>>> +installed into the receiving process after the KDBUS_CMD_MSG_RECV ioctl
>>>> +returns. The receiving task is obliged to close all of them appropriately.
>>>
>>> This makes it sound like fds are installed at receive time.  What
>>> prevents resource exhaustion due to having excessive numbers of fds in
>>> transit (that are presumably not accounted to anyone)?
>>
>> We have a per-user message accounting for undelivered messages, as
>> well as a maximum number of pending messages per connection on the
>> receiving end. These limits are accounted on a "user<->user" basis, so
>> the limit of a user A will not affect two other users (B and C)
>> talking.
>
> But you can shove tons of fds in a message, and you can have lots of
> messages, and some of the fds can be fds of unix sockets that have fds
> queued up in them, and one of those fds could be the fd to the kdbus
> connection that sent the fd...

You cannot send kdbus-fds or unix-fds over kdbus, right now. We have
people working on the AF_UNIX gc to make it more generic and include
external types. Until then, we simply prevent recursive fd passing.

> This is not advice as to what to do about it, but I think that it will
> be a problem at some point.
>
>
>>>> +11. Policy
>>>> +===============================================================================
>>>> +
>>>> +A policy databases restrict the possibilities of connections to own, see and
>>>> +talk to well-known names. It can be associated with a bus (through a policy
>>>> +holder connection) or a custom endpoint.
>>>
>>> ISTM metadata items on bus names should be replaced with policy that
>>> applies to the domain as a whole and governs bus creation.
>>
>> No, well-known names are bound to buses, so a bus is really the right
>> place to hold policy about which process is allowed to claim them.
>> Every user is allowed to create a bus of its own, there's no policy
>> for that, and there shouldn't be.
>>
>> It has nothing to do with metadata items.
>
> But it does -- the creator of the bus binds metadata to that bus at
> creation time.
>
> I think that a better solution would be to have a global policy that
> says, for example, "to create the bus called 'system', the creator
> must have selinux label xyz" or "to create a user bus called
> uid-1000-privileged-ui-bus the creator must have some cgroup" or
> whatever.
>
> Although maybe a better solution would leave this in the kernel but
> allow any cgroup to create a bus with a same that indicates the
> creating cgroup.  Then I could have my desktop shell create a
> "/cgroup/path/to/desktop" for per-user privileged things.

We enforce the UID as first entity of the bus name. Again, this is our
default policy because we rely on user-based access control. If we
want more fine-grained access-control, we can introduce other policies
at any time. For instance, we could enforce "cg-<cgroup>-<busname>"
later on, where the kernel requires the caller to prefix the bus with
"cg-<cgroup>-", where <cgroup> is the cgroup-path encoded in some way.

We provide one policy as default, and we have a use-case for it.
Further policies are always welcome as extensions later on. I don't
see why we should provide all those right from the beginning without
any users right now.

>>
>>>> +A set of policy rules is described by a name and multiple access rules, defined
>>>> +by the following struct.
>>>> +
>>>> +struct kdbus_policy_access {
>>>> +  __u64 type;  /* USER, GROUP, WORLD */
>>>> +    One of the following.
>>>> +
>>>> +    KDBUS_POLICY_ACCESS_USER
>>>> +      Grant access to a user with the uid stored in the 'id' field.
>>>> +
>>>> +    KDBUS_POLICY_ACCESS_GROUP
>>>> +      Grant access to a user with the gid stored in the 'id' field.
>>>> +
>>>> +    KDBUS_POLICY_ACCESS_WORLD
>>>> +      Grant access to everyone. The 'id' field is ignored.
>>>> +
>>>> +  __u64 access;        /* OWN, TALK, SEE */
>>>> +    The access to grant.
>>>> +
>>>> +    KDBUS_POLICY_SEE
>>>> +      Allow the name to be seen.
>>>> +
>>>> +    KDBUS_POLICY_TALK
>>>> +      Allow the name to be talked to.
>>>> +
>>>> +    KDBUS_POLICY_OWN
>>>> +      Allow the name to be owned.
>>>> +
>>>> +  __u64 id;
>>>> +    For KDBUS_POLICY_ACCESS_USER, stores the uid.
>>>> +    For KDBUS_POLICY_ACCESS_GROUP, stores the gid.
>>>> +};
>>>
>>>
>>> What happens if there are multiple matches?
>>
>> We only have _granting_ policy entries. We search through the
>> policy-db until we find an entry that grants access. We do _not_ stop
>> on the first item that matches.
>
> Yay!  Can you document that more clearly?

Sure!

>>
>>>
>>>> +
>>>> +11.4 TALK access and multiple well-known names per connection
>>>> +-------------------------------------------------------------
>>>> +
>>>> +Note that TALK access is checked against all names of a connection.
>>>> +For example, if a connection owns both 'org.foo.bar' and 'org.blah.baz', and
>>>> +the policy database allows 'org.blah.baz' to be talked to by WORLD, then this
>>>> +permission is also granted to 'org.foo.bar'. That might sound illogical, but
>>>> +after all, we allow messages to be directed to either the name or a well-known
>>>> +name, and policy is applied to the connection, not the name. In other words,
>>>> +the effective TALK policy for a connection is the most permissive of all names
>>>> +the connection owns.
>>>
>>> This does seem illogical.  Does the recipient at least know which
>>> well-known name was addressed?
>>
>> If the sender addressed it to a well-known name, yes. If the sender
>> addressed the message to a unique-ID, there will be no such name, of
>> course. Still, the policy applies to such transactions either way
>> (standard D-Bus behavior).
>>
>> Note however that dbus1 will not pass along the destination well-known
>> name, hence most userspace libraries will ignore this information too,
>> even if they run on kdbus which might pass this information around.
>> The right way for services that carry multiple service names to
>> discern which actual service is being talked to is having separate
>> object paths for the different functionality to hide between the
>> services.
>
> It seems unfortunate to keep around this really weird behavior for the
> benefit of legacy applications.  Could there perhaps be a flag that a
> connection can set to indicate that it understands per-destination
> access control and therefore wants stricter policy enforcement?

We actually think that it's a good idea not to use the destination
name for doing different things, to make things more transparent. For
example, we have tools that can explore the bus, introspect things
(like d-bus), and they should show the same objects regardless by
which name you access a service. It's more transparent then, and
really just reduces names to some labels that make addressing things
easier, but that are actually completely unnecessary for actual method
invocations.

This behaviour is also relied on by a number of current bindings. For
example GLib's implementation usually caches the unique name of a
peer, and uses that for talking to remote objects (rather than always
using the well-known name), in order to get an error back when a name
becomes unavailable (maybe because a service died) or is moved to a
different peer. If daemons would always take the destination name into
account this kind of logic could never work.

It does take some time to get used to the fact that names are
exclusively used for message routing and policies, not as
target-entity of actual method calls. But the current dbus1 behaviour
makes a ton of sense, and is really something we want to keep. It
improves how clients can do life-cycle tracking of remote objects.

Note that D-Bus modeled unique-names and well-known-names after IP
addresses and DNS names. It's a very similar model, and, like DNS
names, well-known names have no effect on the routing of messages.

>>
>>>> +11.5 Implicit policies
>>>> +----------------------
>>>> +
>>>> +Depending on the type of the endpoint, a set of implicit rules might be
>>>> +enforced. On default endpoints, the following set is enforced:
>>>> +
>>>
>>> How do these rules interact with installed policy?
>>
>> As said before, all policy entries _grant_ access. We look through all
>> entries until we find one that grants access.
>>
>>>> +  * Privileged connections always override any installed policy. Those
>>>> +    connections could easily install their own policies, so there is no
>>>> +    reason to enforce installed policies.
>>>> +  * Connections can always talk to connections of the same user. This
>>>> +    includes broadcast messages.
>>>
>>> Why?
>>
>> All limits on buses are enforced on a user<->user basis. We don't want
>> to provide policies that are more fine-grained than our accounting.
>
> This seems completely at odds with all the fine-grained metadata
> stuff.  Also, anything that relies on this may get very confused when
> the LSM hooks go in, because I'm reasonably sure that the intent is
> for them to *not* follow this principle.

User-based accounting has always been the default, right? We are open
to extend the API to support any other accounting scheme (LSM,
cgroup-based, ...). But like bus-name-policies, I think it's fine to
keep this as future extension. If you think the current design
precludes LSM-based accounting, lemme know and we can fix it. But we
have talked to LSM people before (and there have been patches on
LKML), and they seemed fine with it.

>>
>>> If anyone ever strengthens the concept of identity to include
>>> things other than users (hmm -- there are already groups), this could
>>> be very limiting.
>>
>> If user-based accounting is not suitable, you can create custom
>> endpoints. Future extensions to that are always welcome. So far, the
>> default user-based accounting was enough. And I think it's suitable as
>> default.
>>
>>>> +  * Connections that own names might send broadcast messages to other
>>>> +    connections that belong to a different user, but only if that
>>>> +    destination connection does not own any name.
>>>> +
>
> (Also, what does "might" mean here?)
>
>>>
>>> This is weird.  It is also differently illogical than the "illogical"
>>> thing above.
>>
>> Actually it follows the same model described above. If two connections
>> are running under the same user then broadcasts are allowed, but if
>> they are running under different users *and* if the destination owns a
>> well-known name, then broadcasts are subject to TALK policy checks
>> since that destination may own a restricted well-known name that is
>> not interested in broadcasts. So this implicit policy is just
>> fast-path for the common case where the target is subscribed to a
>> broadcast and does not own any name.
>
> Huh?
>
> Say I have two users, "Sender" and "Receiver", each with a single
> connection.  If Receiver owns no well-known names, then Sender can
> send to it.  If Receiver owns one well-known name, then Sender needs
> to pass a TALK check on that name.  If Reciever owns two well-known
> names, then Sender only needs to pass a TALK check on one of them.
>
> Am I understanding this right?  If I am, then I think this is in the
> category of baroque and inconsistent security rules which everyone
> will screw up and therefore introduce security vulnerabilities.
>
> Can you really not enforce the much simpler rule that, to send to a
> name, you must have permission to send to *that* name?  If legacy
> dbus1 receivers register two names and don't validate everything
> correctly, then only the legacy receivers have problems.

Sorry, I got confused here. That implicit policy is now dropped.

>>
>>>> +
>>>> +13. Metadata
>>>> +===============================================================================
>> [snip]
>>>> +13.1 Known item types
>>>> +---------------------
>>>> +
>>>> +The following attach flags are currently supported.
>>>> +
>>>> +  KDBUS_ATTACH_TIMESTAMP
>>>> +    Attaches an item of type KDBUS_ITEM_TIMESTAMP which contains both the
>>>> +    monotonic and the realtime timestamp, taken when the message was
>>>> +    processed on the kernel side.
>>>> +
>>>> +  KDBUS_ATTACH_CREDS
>>>> +    Attaches an item of type KDBUS_ITEM_CREDS, containing credentials as
>>>> +    described in kdbus_creds: the uid, gid, pid, tid and starttime of the task.
>>>> +
>>>
>>> As mentioned last time, please remove or justify starttime.
>>
>> starttime allows detecting PID overflows. Exposing the process
>> starttime is useful to detect when a PID is getting reused.
>> Unfortunately, we don't have 64bit pids, so we need the pid+time
>> combination to avoid ambiguity.
>
> NAK, I think.
>
> I agree that PID overflow is a real issue and should be addressed
> somehow.  But please address it for real instead of adding Yet Another
> Hack (tm).  In the mean time, leave that hack out, please.
>
> I would *love* to see PIDs have extra high bits at the end, done in a
> way that supports CRIU and that guarantees no reuse unless something
> privileged intentionally mis-programs it.  But starttime isn't that
> mechanism.

The starttime logic sufficiently fixes the issue. If one great day in
the future somebody invents some completely new concept for making
this problem go away, we can look into that, but even then the field
is still valuable for informational purposes. I mean, the kernel
tracks this and exposes this in /proc for a reason...

In the meantime, we don't have any other way of solving this problem,
so we'll leave this in.

>>
>>>> +  KDBUS_ATTACH_AUXGROUPS
>>>> +    Attaches an item of type KDBUS_ITEM_AUXGROUPS, containing a dynamic
>>>> +    number of auxiliary groups the sending task was a member of.
>>>> +
>>>> +  KDBUS_ATTACH_NAMES
>>>> +    Attaches items of type KDBUS_ITEM_OWNED_NAME, one for each name the sending
>>>> +    connection currently owns. The name and flags are stored in kdbus_item.name
>>>> +    for each of them.
>>>> +
>>>
>>> That's interesting.  What's it for?
>>
>> It a valuable piece of information for receivers to know which bus
>> names a sender has claimed. For instance, we need this information for
>> the D-Bus proxy service, because we have to apply D-Bus1 policy in
>> that case, and we need to get a list of owned names in a race-free
>> manner to check the policy against.
>
> But if you change the rule to the sensible one where you need
> permission to TALK to the name that you're talking to, this goes away,
> right?

This does not work if a message is directed at a unique-name, as
explained above (or, think broadcasts).

>>
>>>> +  KDBUS_ATTACH_TID_COMM
>>>> +    Attaches an items of type KDBUS_ITEM_TID_COMM, transporting the sending
>>>> +    task's 'comm', for the tid.  The string is stored in kdbus_item.str.
>>>> +
>>>> +  KDBUS_ATTACH_PID_COMM
>>>> +    Attaches an items of type KDBUS_ITEM_PID_COMM, transporting the sending
>>>> +    task's 'comm', for the pid.  The string is stored in kdbus_item.str.
>>>> +
>>>> +  KDBUS_ATTACH_EXE
>>>> +    Attaches an item of type KDBUS_ITEM_EXE, containing the path to the
>>>> +    executable of the sending task, stored in kdbus_item.str.
>>>> +
>>>> +  KDBUS_ATTACH_CMDLINE
>>>> +    Attaches an item of type KDBUS_ITEM_CMDLINE, containing the command line
>>>> +    arguments of the sending task, as an array of strings, stored in
>>>> +    kdbus_item.str.
>>>
>>> Please remove these four items.  They are genuinely useless.  Anything
>>> that uses them for anything is either buggy or should have asked the
>>> sender to put the value in the payload (and immediately wondered why
>>> it was doing that).
>>
>> We use them for logging, debugging and monitoring. With our wireshark
>> extension it's pretty useful to know the comm-name of a process when
>> monitoring a bus. As we explained last time, this is not about
>> security. We're aware that a process can modify them. We use them only
>> as additional meta-data for logging and debugging.
>
> Use the PID.  Really.  Your wireshark extention can look this crap up
> in /proc and, if it fails due to a race, big frickin' deal.

I see no reason for leaving it up to the client to do this extra work
if it can as well be attached by the kernel, really.

We use the PID on dbus1 systems for cases like this. But it's actually
too racy to be useful. For example, in systemd we ship a tiny binary
that is used as cgroup agent, which just pushes a message about the
fact it just got called for a cgroup onto the bus and then exits.
Since it only runs for a very very short time, any peer which then
tries to read the metadata off it is pretty likely to fail. And there
are quite a number of processes like that, that just do one thing and
die, especially in the early boot process. For none of them we
currently can generate useful log metadata, because all we have is a
PID that we have barely any useful information about.
This is a real race we get lots of bug-reports for. With kdbus we want
to fix this, by optionally attaching this useful data to the message,
so that the receiver can get the information when it wants to.

>>
>> If we put those items into the payload, we have to transmit this data
>> even if the destination process is not interested in this.
>> Furthermore, each caller has to run multiple syscalls on each message
>> to retrieve those values.
>>
>> We use these items heavily for filtering and debugging, regardless of
>> the payload protocol that is transmitted on the bus.
>>
>> To give another specific use-case here: dbus supports bus activation,
>> where a message sent to a non-running service causes it to be spawned
>> implicitly without losing the message. Now, with such a scheme it is
>> incredibly useful to be able to log which client caused a service to
>> be triggered, hence we want to know the cmdline/exe/comm of the
>> client. Not knowing this is a major pita when trying to trace the boot
>> process and figuring out why a specific service got activated.
>
> Again, use the PID for tracing, please.

No. It's racy. Processes can die too quickly. And this is not a race
that would be about security, but it's a real-life race that is just
awful to run into when you try to trace what's going on on your
system.

> At the very least, make it impossible to specify these fields in the
> "must be received" set and rename them to something like
> KDBUS_INSTALL_UNRELIABLE_CMDLINE, etc, because they're unreliable
>
> Finally, this stuff should only be readable by privileged users.  And
> using the PID accomplishes that.
>
>>
>> Also note that since v2 of the patch there's actually a per-sender
>> mask for meta-data like this, hence a peer which doesn't want to pass
>> its exec/cmdline/comm along can do that. Of course, this will
>> seriously hamper debuggability and transparency...
>
> Transparency is a terrible thing here.
>
> How many users put passwords into things on the command line?  Yes,
> it's a bad idea (for reasons that are entirely stupid), but now those
> passwords get *logged*.
>
> If this is in the kernel, and someone complains that sensitive data is
> showing up on ten different logs on their system, they'll *correctly*
> blame the kernel.  If you at least use the PID and restrict it to the
> logging code, then at least the bug report will go to the logging
> daemon, which will be *correctly* accused of doing something daft, and
> it can be fixed.

Hmm? Not following here. This information is visible via /proc too. If
you hide it from /proc via the hide_pid logic, then it is also gone
from the kdbus meta-data. Also, note again that clients that don't
want this information to be passed to services can declare that now
with their sender creds mask, introduced with v2.

>>
>>>> +
>>>> +  KDBUS_ATTACH_CGROUP
>>>> +    Attaches an item of type KDBUS_ITEM_CGROUP with the task's cgroup path.
>>>> +
>>>> +  KDBUS_ATTACH_CAPS
>>>> +    Attaches an item of type KDBUS_ITEM_CAPS, carrying sets of capabilities
>>>> +    that should be accessed via kdbus_item.caps.caps. Also, userspace should
>>>> +    be written in a way that it takes kdbus_item.caps.last_cap into account,
>>>> +    and derive the number of sets and rows from the item size and the reported
>>>> +    number of valid capability bits.
>>>> +
>>>
>>> Please remove this, too, or justify its use.
>>
>> cgroup information tells us which service is doing a bus request. This
>> is useful for a variety of things. For example, the bus activation
>> logging item above benefits from it. In general, if some message shall
>> be logged about any client it is useful to know its service name.
>>
>> Capabilities are useful to authenticate specific method calls. For
>> example, when a client asks systemd to reboot, without this concept we
>> can only check for UID==0 to decide whether to allow this. Breaking
>> this down to capabilities in a race-free way has the benefit of
>> allowing systemd to bind this to CAP_SYS_BOOT instead. There is no
>> reason to deny a process with CAP_SYS_BOOT to reboot via bus-APIs, as
>> they could just enforce it via syscalls, anyway.
>
> With all due respect, BS.
>
> I admit that there is probably no reason to deny systemd-based reboot
> to a CAP_SYS_BOOT-capable process, but there is absolutely no reason
> to give processes that are supposed to reboot using systemd the
> CAP_SYS_BOOT capability.

No, and this is not how this works. Note that for unpriviliged clients
systemd checks PolicyKit in order to identify whether to allow certain
priviliged operations. However, PolicyKit requires bus chatte, is slow
and quite complex, hence the code shortcuts things if it knows that
the client is priviliged anyway, and doesn't even bother with
PolicyKit at all. This is where the caps come into play, since this
shortcutting really should *NOT* be done for every single client, but
only for those with the rights to do the operation anyway.

Hence, this is really not about overloading capabilities with new
meanings. Instead it is about shortcutting policykit for priviliged
clients. And this shortcutting should be as restricted as possible.

> In any event, I suspect you'll have a hard time justifying this for
> anything other than CAP_SYS_BOOT.  Just because CAP_SYS_ADMIN users
> can probably do whatever they want doesn't mean that systemd should
> make that a built-in policy.

Well, the other option for these APIs is to use the euid, which is
hardly any better.

systemd-timedated shortcuts policykit if the client has CAP_SYS_TIME
and tries to change the system clock. Similar, if a process asks
logind to kill a session, we bypass pk if the client has CAP_KILL.

> Also, wtf is the bounding set and such for?  At the very least this
> should only be the effective set.

Yes, the code that makes use of this for shortcutting pk uses the
effective set only. The other ones we allow sending across for
enhancing logging of security operations.

In general: all creds we collect at the very least are incredibly
useful for generating log records in a race-free fashion. As pointed
out above the "race-free" bit alone solves real-world issues that are
highly annoying if we don't have it.

>>
>> We think it's a useful and reliable authentication method. Why should
>> we remove it?
>
> Because the implementation is buggy and therefore it's insecure?
> Remember that caps are namespaced in an interesting way.

Yes, we are well aware of the fact that we currently have no good way
to translate a full set of capabilities from one user-ns to another.
Hence, the only sane thing to do in such situations is to drop the
entire item, which is what we do. Once we have a reliable way of
translating things, we can add that to our code. Note that a set
capability flag will only gain you more access level, so if caps are
missing from a message, a user might only have *less* privileges, not
more.

>>
>> Anyway, these items are  just optional. The sender can refuse the
>> reveal them, and the item is only transmitted if the receiver opted in
>> for it, too. So there's no need to drop any item type from the
>> protocol.
>
> No.
>
> Because if receivers opt in to most of these, *they're doing it
> wrong*, and the kernel shouldn't be in the business of helping them.

No, they are not doing it "wrong". The services would do things wrong
if they'd make security decisions on bits that cannot be acquired in a
race-free way. And services do things in a dirty way if they'd
generated logging data in a race-ful way (like you suggest), by
reading things from /proc.

Thanks
David
