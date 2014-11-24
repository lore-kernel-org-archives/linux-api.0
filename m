From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: kdbus: add documentation
Date: Mon, 24 Nov 2014 12:57:15 -0800
Message-ID: <CALCETrUfNG=YwwM2m78Ua4fUr9daE1omQwOSJQMKC6CTCa28fQ@mail.gmail.com>
References: <1416546149-24799-1-git-send-email-gregkh@linuxfoundation.org>
 <1416546149-24799-2-git-send-email-gregkh@linuxfoundation.org>
 <CALCETrWUekPq6pquuiVperBihQHgcvCF=WzVJTZziHhUJYsh4Q@mail.gmail.com> <CANq1E4QA53-L8vPOWJfjhzXaYVQnNvgvR6AcYev0EaP6SfOjQQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CANq1E4QA53-L8vPOWJfjhzXaYVQnNvgvR6AcYev0EaP6SfOjQQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: David Herrmann <dh.herrmann@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Arnd Bergmann <arnd@arndb.de>, "Eric W. Biederman" <ebiederm@xmission.com>, One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>, Tom Gundersen <teg@jklm.no>, Jiri Kosina <jkosina@suse.cz>, Linux API <linux-api@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Daniel Mack <daniel@zonque.org>, Djalal Harouni <tixxdz@opendz.org>
List-Id: linux-api@vger.kernel.org

On Mon, Nov 24, 2014 at 12:16 PM, David Herrmann <dh.herrmann@gmail.com> wrote:
> Hi Andy!
>
> On Fri, Nov 21, 2014 at 6:12 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>> On Thu, Nov 20, 2014 at 9:02 PM, Greg Kroah-Hartman
>> <gregkh@linuxfoundation.org> wrote:
>>> From: Daniel Mack <daniel@zonque.org>
>>>
>>> kdbus is a system for low-latency, low-overhead, easy to use
>>> interprocess communication (IPC).
>>>
>>> The interface to all functions in this driver is implemented through
>>> ioctls on files exposed through the mount point of a kdbusfs.  This
>>> patch adds detailed documentation about the kernel level API design.
>>>
>>> Signed-off-by: Daniel Mack <daniel@zonque.org>
>>> Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
>>> Signed-off-by: Djalal Harouni <tixxdz@opendz.org>
>>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>> ---
>>
>>> +  Pool:
>>> +    Each connection allocates a piece of shmem-backed memory that is used
>>> +    to receive messages and answers to ioctl command from the kernel. It is
>>> +    never used to send anything to the kernel. In order to access that memory,
>>> +    userspace must mmap() it into its task.
>>> +    See section 12 for more details.
>>
>> At the risk of opening a can of worms, wouldn't this be much more
>> useful if you could share a pool between multiple connections?
>
> Within a process it could theoretically be possible to share the same
> memory pool between multiple connections made by the process. However,
> note that normally a process only has a single connection to the bus
> open (possibly two, if it opens a connection to both the system and
> the user bus). Now, sharing the receiver buffer could certainly be
> considered an optimization, but it would have no effect on
> "usefulness", though, as just allocating space from a single shared
> per-process receiver won't give you any new possibilities...
>
> We have thought about this, but decided to delay it for now. Shared
> pools can easily be added as an extension later on.
>
> [snip]
>>> +KDBUS_CMD_BUS_MAKE, and KDBUS_CMD_ENDPOINT_MAKE take a
>>> +struct kdbus_cmd_make argument.
>>> +
>>> +struct kdbus_cmd_make {
>>> +  __u64 size;
>>> +    The overall size of the struct, including its items.
>>> +
>>> +  __u64 flags;
>>> +    The flags for creation.
>>> +
>>> +    KDBUS_MAKE_ACCESS_GROUP
>>> +      Make the device file group-accessible
>>> +
>>> +    KDBUS_MAKE_ACCESS_WORLD
>>> +      Make the device file world-accessible
>>
>> This thing is a file.  What's wrong with using a normal POSIX mode?
>> (And what to the read, write, and exec modes do?)
>
> Domains and buses are directories, endpoints are files. Domains also
> create control-files implicitly.
>
> For kdbus clients there is just access or no access, but not
> distinction between read, write and execute access. Due to that we
> just break this down to per-group and world access bits, since doing
> more is pointless, and we shouldn't allow shoehorning more stuff into
> the access mode.
>
> [snip]
>>> +      KDBUS_ITEM_CREDS
>>> +      KDBUS_ITEM_SECLABEL
>>> +        Privileged bus users may submit these types in order to create
>>> +        connections with faked credentials. The only real use case for this
>>> +        is a proxy service which acts on behalf of some other tasks. For a
>>> +        connection that runs in that mode, the message's metadata items will
>>> +        be limited to what's specified here. See section 13 for more
>>> +        information.
>>
>> This is still confusing.  There are multiple places in which metadata
>> is attached.  Which does this apply to?  And why are only creds and
>> seclabel listed?
>
> Yes, and there are multiple places where metadata is *gathered*. This
> ioctl creates connections, so only the items that are actually
> *gathered* by that ioctl are documented here. These items are not part
> of any messages, but are used as identification of the connection
> owner (and in this particular case, to allow privileged proxies to
> overwrite the items so they can properly proxy a legacy-dbus peer
> connection).

But don't proxies need to override the per-message metadata, too?
This is why I'm confused (and my confusion about what's happening goes
down into the code, too).  IMO it would be great if all the variables
were named things like message_metadata, conn_metadata, bus_metadata,
etc.

>
> [snip]
>>> +6.5 Getting information about a connection's bus creator
>>> +--------------------------------------------------------
>>> +
>>> +The KDBUS_CMD_BUS_CREATOR_INFO ioctl takes the same struct as
>>> +KDBUS_CMD_CONN_INFO but is used to retrieve information about the creator of
>>> +the bus the connection is attached to. The metadata returned by this call is
>>> +collected during the creation of the bus and is never altered afterwards, so
>>> +it provides pristine information on the task that created the bus, at the
>>> +moment when it did so.
>>
>> What's this for?  I understand the need for the creator of busses to
>> be authenticated, but doing it like this mean that anyone who will
>> *fail* authentication can DoS the authentic creator.
>
> This returns information on a bus owner, to determine whether a
> connection is connected to a system, user or session bus. Note that
> the bus-creator itself is not a valid peer on the bus, so you cannot
> send messages to them. Which kind of DoS do you have in mind?

I assume that the logic is something like:

connect to bus
request bus metadata
if (bus metadata matches expectations) {
  great, trust the bus!
} else {
  oh crap!
}

If I'm understanding it right, then user code only really has two
outcomes: the good case and the "oh crap!" case.  The problem is that
"oh crap!" isn't a clean failure -- if it happens, then the
application has just been DoSed, because in that case, one of two
things happened:

1. Some policy mismatch means that the legitimate bus owner did create
the bus, but the user application is confused.  This will result in
difficult-to-diagnose failures.

2. A malicious or confused program created the bus.  This is a DoS --
even the legitimate bus creator can't actually create the bus now.

So I think that the policy should be applied at the time that the bus
name is claimed, not at the time that someone else tries to use the
bus.  IOW, the way that you verify you're talking to the system bus
should be by checking that the bus is called "system", not by checking
that UID 0 created the bus.

>
>>> +
>>> +7.3 Passing of Payload Data
>>> +---------------------------
>>> +
>>> +When connecting to the bus, receivers request a memory pool of a given size,
>>> +large enough to carry all backlog of data enqueued for the connection. The
>>> +pool is internally backed by a shared memory file which can be mmap()ed by
>>> +the receiver.
>>> +
>>> +KDBUS_MSG_PAYLOAD_VEC:
>>> +  Messages are directly copied by the sending process into the receiver's pool,
>>> +  that way two peers can exchange data by effectively doing a single-copy from
>>> +  one process to another, the kernel will not buffer the data anywhere else.
>>> +
>>> +KDBUS_MSG_PAYLOAD_MEMFD:
>>> +  Messages can reference memfd files which contain the data.
>>> +  memfd files are tmpfs-backed files that allow sealing of the content of the
>>> +  file, which prevents all writable access to the file content.
>>> +  Only sealed memfd files are accepted as payload data, which enforces
>>> +  reliable passing of data; the receiver can assume that neither the sender nor
>>> +  anyone else can alter the content after the message is sent.
>>
>> This should specify *which* seals are checked.
>
> True. Will be added to the documentation. For the record, it's the
> full set of seals right now, so
> F_SEAL_SHRINK|F_SEAL_GROW|F_SEAL_WRITE|F_SEAL_SEAL.

Makes sense.

>
>>> +
>>> +Apart from the sender filling-in the content into memfd files, the data will
>>> +be passed as zero-copy from one process to another, read-only, shared between
>>> +the peers.
>>> +
>>> +
>>> +7.4 Receiving messages
>>> +----------------------
>>> +
>>> +Messages are received by the client with the KDBUS_CMD_MSG_RECV ioctl. The
>>> +endpoint file of the bus supports poll() to wake up the receiving process when
>>> +new messages are queued up to be received.
>>> +
>>> +With the KDBUS_CMD_MSG_RECV ioctl, a struct kdbus_cmd_recv is used.
>>> +
>>> +struct kdbus_cmd_recv {
>>> +  __u64 flags;
>>> +    Flags to control the receive command.
>>> +
>>> +    KDBUS_RECV_PEEK
>>> +      Just return the location of the next message. Do not install file
>>> +      descriptors or anything else. This is usually used to determine the
>>> +      sender of the next queued message.
>>> +
>>> +    KDBUS_RECV_DROP
>>> +      Drop the next message without doing anything else with it, and free the
>>> +      pool slice. This a short-cut for KDBUS_RECV_PEEK and KDBUS_CMD_FREE.
>>> +
>>> +    KDBUS_RECV_USE_PRIORITY
>>> +      Use the priority field (see below).
>>> +
>>> +  __u64 kernel_flags;
>>> +    Valid flags for this command, returned by the kernel upon each call.
>>> +
>>> +  __s64 priority;
>>> +      With KDBUS_RECV_USE_PRIORITY set in flags, receive the next message in
>>> +      the queue with at least the given priority. If no such message is waiting
>>> +      in the queue, -ENOMSG is returned.
>>> +
>>> +  __u64 offset;
>>> +      Upon return of the ioctl, this field contains the offset in the
>>> +      receiver's memory pool.
>>> +};
>>> +
>>> +Unless KDBUS_RECV_DROP was passed, and given that the ioctl succeeded, the
>>> +offset field contains the location of the new message inside the receiver's
>>> +pool. The message is stored as struct kdbus_msg at this offset, and can be
>>> +interpreted with the semantics described above.
>>
>> I'm confused here.  Is sent data written to the pool when send is
>> called or when recv is called?
>
> When send is called.
>
>> If the former, what prevents DoS, especially DoS due to sending too many fds?
>
> FDs are installed into the task only when the receiver issues
> CMD_RECV, so a task won't explode unless it issues that ioctl. Plus,
> receiving FDs is already a per-connection opt-in. Furthermore, you can
> CMD_PEEK messages which allows you to look at the full message
> _without_ installing FDs. If you don't want the FDs, you can CMD_DROP
> the message.
>
>> If the latter, where is the data buffered in the mean time?
>>
>>> +
>>> +Also, if the connection allowed for file descriptor to be passed
>>> +(KDBUS_HELLO_ACCEPT_FD), and if the message contained any, they will be
>>> +installed into the receiving process after the KDBUS_CMD_MSG_RECV ioctl
>>> +returns. The receiving task is obliged to close all of them appropriately.
>>
>> This makes it sound like fds are installed at receive time.  What
>> prevents resource exhaustion due to having excessive numbers of fds in
>> transit (that are presumably not accounted to anyone)?
>
> We have a per-user message accounting for undelivered messages, as
> well as a maximum number of pending messages per connection on the
> receiving end. These limits are accounted on a "user<->user" basis, so
> the limit of a user A will not affect two other users (B and C)
> talking.

But you can shove tons of fds in a message, and you can have lots of
messages, and some of the fds can be fds of unix sockets that have fds
queued up in them, and one of those fds could be the fd to the kdbus
connection that sent the fd...

This is not advice as to what to do about it, but I think that it will
be a problem at some point.


>>> +11. Policy
>>> +===============================================================================
>>> +
>>> +A policy databases restrict the possibilities of connections to own, see and
>>> +talk to well-known names. It can be associated with a bus (through a policy
>>> +holder connection) or a custom endpoint.
>>
>> ISTM metadata items on bus names should be replaced with policy that
>> applies to the domain as a whole and governs bus creation.
>
> No, well-known names are bound to buses, so a bus is really the right
> place to hold policy about which process is allowed to claim them.
> Every user is allowed to create a bus of its own, there's no policy
> for that, and there shouldn't be.
>
> It has nothing to do with metadata items.

But it does -- the creator of the bus binds metadata to that bus at
creation time.

I think that a better solution would be to have a global policy that
says, for example, "to create the bus called 'system', the creator
must have selinux label xyz" or "to create a user bus called
uid-1000-privileged-ui-bus the creator must have some cgroup" or
whatever.

Although maybe a better solution would leave this in the kernel but
allow any cgroup to create a bus with a same that indicates the
creating cgroup.  Then I could have my desktop shell create a
"/cgroup/path/to/desktop" for per-user privileged things.

>
>>> +A set of policy rules is described by a name and multiple access rules, defined
>>> +by the following struct.
>>> +
>>> +struct kdbus_policy_access {
>>> +  __u64 type;  /* USER, GROUP, WORLD */
>>> +    One of the following.
>>> +
>>> +    KDBUS_POLICY_ACCESS_USER
>>> +      Grant access to a user with the uid stored in the 'id' field.
>>> +
>>> +    KDBUS_POLICY_ACCESS_GROUP
>>> +      Grant access to a user with the gid stored in the 'id' field.
>>> +
>>> +    KDBUS_POLICY_ACCESS_WORLD
>>> +      Grant access to everyone. The 'id' field is ignored.
>>> +
>>> +  __u64 access;        /* OWN, TALK, SEE */
>>> +    The access to grant.
>>> +
>>> +    KDBUS_POLICY_SEE
>>> +      Allow the name to be seen.
>>> +
>>> +    KDBUS_POLICY_TALK
>>> +      Allow the name to be talked to.
>>> +
>>> +    KDBUS_POLICY_OWN
>>> +      Allow the name to be owned.
>>> +
>>> +  __u64 id;
>>> +    For KDBUS_POLICY_ACCESS_USER, stores the uid.
>>> +    For KDBUS_POLICY_ACCESS_GROUP, stores the gid.
>>> +};
>>
>>
>> What happens if there are multiple matches?
>
> We only have _granting_ policy entries. We search through the
> policy-db until we find an entry that grants access. We do _not_ stop
> on the first item that matches.

Yay!  Can you document that more clearly?

>
>>
>>> +
>>> +11.4 TALK access and multiple well-known names per connection
>>> +-------------------------------------------------------------
>>> +
>>> +Note that TALK access is checked against all names of a connection.
>>> +For example, if a connection owns both 'org.foo.bar' and 'org.blah.baz', and
>>> +the policy database allows 'org.blah.baz' to be talked to by WORLD, then this
>>> +permission is also granted to 'org.foo.bar'. That might sound illogical, but
>>> +after all, we allow messages to be directed to either the name or a well-known
>>> +name, and policy is applied to the connection, not the name. In other words,
>>> +the effective TALK policy for a connection is the most permissive of all names
>>> +the connection owns.
>>
>> This does seem illogical.  Does the recipient at least know which
>> well-known name was addressed?
>
> If the sender addressed it to a well-known name, yes. If the sender
> addressed the message to a unique-ID, there will be no such name, of
> course. Still, the policy applies to such transactions either way
> (standard D-Bus behavior).
>
> Note however that dbus1 will not pass along the destination well-known
> name, hence most userspace libraries will ignore this information too,
> even if they run on kdbus which might pass this information around.
> The right way for services that carry multiple service names to
> discern which actual service is being talked to is having separate
> object paths for the different functionality to hide between the
> services.

It seems unfortunate to keep around this really weird behavior for the
benefit of legacy applications.  Could there perhaps be a flag that a
connection can set to indicate that it understands per-destination
access control and therefore wants stricter policy enforcement?

>
>>> +11.5 Implicit policies
>>> +----------------------
>>> +
>>> +Depending on the type of the endpoint, a set of implicit rules might be
>>> +enforced. On default endpoints, the following set is enforced:
>>> +
>>
>> How do these rules interact with installed policy?
>
> As said before, all policy entries _grant_ access. We look through all
> entries until we find one that grants access.
>
>>> +  * Privileged connections always override any installed policy. Those
>>> +    connections could easily install their own policies, so there is no
>>> +    reason to enforce installed policies.
>>> +  * Connections can always talk to connections of the same user. This
>>> +    includes broadcast messages.
>>
>> Why?
>
> All limits on buses are enforced on a user<->user basis. We don't want
> to provide policies that are more fine-grained than our accounting.

This seems completely at odds with all the fine-grained metadata
stuff.  Also, anything that relies on this may get very confused when
the LSM hooks go in, because I'm reasonably sure that the intent is
for them to *not* follow this principle.

>
>> If anyone ever strengthens the concept of identity to include
>> things other than users (hmm -- there are already groups), this could
>> be very limiting.
>
> If user-based accounting is not suitable, you can create custom
> endpoints. Future extensions to that are always welcome. So far, the
> default user-based accounting was enough. And I think it's suitable as
> default.
>
>>> +  * Connections that own names might send broadcast messages to other
>>> +    connections that belong to a different user, but only if that
>>> +    destination connection does not own any name.
>>> +

(Also, what does "might" mean here?)

>>
>> This is weird.  It is also differently illogical than the "illogical"
>> thing above.
>
> Actually it follows the same model described above. If two connections
> are running under the same user then broadcasts are allowed, but if
> they are running under different users *and* if the destination owns a
> well-known name, then broadcasts are subject to TALK policy checks
> since that destination may own a restricted well-known name that is
> not interested in broadcasts. So this implicit policy is just
> fast-path for the common case where the target is subscribed to a
> broadcast and does not own any name.

Huh?

Say I have two users, "Sender" and "Receiver", each with a single
connection.  If Receiver owns no well-known names, then Sender can
send to it.  If Receiver owns one well-known name, then Sender needs
to pass a TALK check on that name.  If Reciever owns two well-known
names, then Sender only needs to pass a TALK check on one of them.

Am I understanding this right?  If I am, then I think this is in the
category of baroque and inconsistent security rules which everyone
will screw up and therefore introduce security vulnerabilities.

Can you really not enforce the much simpler rule that, to send to a
name, you must have permission to send to *that* name?  If legacy
dbus1 receivers register two names and don't validate everything
correctly, then only the legacy receivers have problems.

>>> +
>>> +To access the memory, the caller is expected to mmap() it to its task, like
>>> +this:
>>> +
>>> +  /*
>>> +   * POOL_SIZE has to be a multiple of PAGE_SIZE, and it must match the
>>> +   * value that was previously passed in the .pool_size field of struct
>>> +   * kdbus_cmd_hello.
>>> +   */
>>> +
>>> +  buf = mmap(NULL, POOL_SIZE, PROT_READ, MAP_PRIVATE, conn_fd, 0);
>>> +
>>
>> Will mapping with PROT_WRITE fail?  What about MAP_SHARED?
>
> PROT_WRITE will fail and VM_MAYWRITE is cleared.
>
>> And why are you suggesting MAP_PRIVATE?  That's just strange.
>
> This was a leftover from pre-3.17. memfds require you to use
> MAP_PRIVATE if SEAL_WRITE is set (which is a linux-specific behavior,
> where MAP_SHARED is always accounted as writable mapping as
> mprotect(VM_WRITE) can be called any time). I fixed this up.

Thanks.  (I assume that memfd has nothing to do with this directly,
since these are pools, not memfds.)

>
>>> +
>>> +13. Metadata
>>> +===============================================================================
> [snip]
>>> +13.1 Known item types
>>> +---------------------
>>> +
>>> +The following attach flags are currently supported.
>>> +
>>> +  KDBUS_ATTACH_TIMESTAMP
>>> +    Attaches an item of type KDBUS_ITEM_TIMESTAMP which contains both the
>>> +    monotonic and the realtime timestamp, taken when the message was
>>> +    processed on the kernel side.
>>> +
>>> +  KDBUS_ATTACH_CREDS
>>> +    Attaches an item of type KDBUS_ITEM_CREDS, containing credentials as
>>> +    described in kdbus_creds: the uid, gid, pid, tid and starttime of the task.
>>> +
>>
>> As mentioned last time, please remove or justify starttime.
>
> starttime allows detecting PID overflows. Exposing the process
> starttime is useful to detect when a PID is getting reused.
> Unfortunately, we don't have 64bit pids, so we need the pid+time
> combination to avoid ambiguity.

NAK, I think.

I agree that PID overflow is a real issue and should be addressed
somehow.  But please address it for real instead of adding Yet Another
Hack (tm).  In the mean time, leave that hack out, please.

I would *love* to see PIDs have extra high bits at the end, done in a
way that supports CRIU and that guarantees no reuse unless something
privileged intentionally mis-programs it.  But starttime isn't that
mechanism.

>
>>> +  KDBUS_ATTACH_AUXGROUPS
>>> +    Attaches an item of type KDBUS_ITEM_AUXGROUPS, containing a dynamic
>>> +    number of auxiliary groups the sending task was a member of.
>>> +
>>> +  KDBUS_ATTACH_NAMES
>>> +    Attaches items of type KDBUS_ITEM_OWNED_NAME, one for each name the sending
>>> +    connection currently owns. The name and flags are stored in kdbus_item.name
>>> +    for each of them.
>>> +
>>
>> That's interesting.  What's it for?
>
> It a valuable piece of information for receivers to know which bus
> names a sender has claimed. For instance, we need this information for
> the D-Bus proxy service, because we have to apply D-Bus1 policy in
> that case, and we need to get a list of owned names in a race-free
> manner to check the policy against.

But if you change the rule to the sensible one where you need
permission to TALK to the name that you're talking to, this goes away,
right?

>
>>> +  KDBUS_ATTACH_TID_COMM
>>> +    Attaches an items of type KDBUS_ITEM_TID_COMM, transporting the sending
>>> +    task's 'comm', for the tid.  The string is stored in kdbus_item.str.
>>> +
>>> +  KDBUS_ATTACH_PID_COMM
>>> +    Attaches an items of type KDBUS_ITEM_PID_COMM, transporting the sending
>>> +    task's 'comm', for the pid.  The string is stored in kdbus_item.str.
>>> +
>>> +  KDBUS_ATTACH_EXE
>>> +    Attaches an item of type KDBUS_ITEM_EXE, containing the path to the
>>> +    executable of the sending task, stored in kdbus_item.str.
>>> +
>>> +  KDBUS_ATTACH_CMDLINE
>>> +    Attaches an item of type KDBUS_ITEM_CMDLINE, containing the command line
>>> +    arguments of the sending task, as an array of strings, stored in
>>> +    kdbus_item.str.
>>
>> Please remove these four items.  They are genuinely useless.  Anything
>> that uses them for anything is either buggy or should have asked the
>> sender to put the value in the payload (and immediately wondered why
>> it was doing that).
>
> We use them for logging, debugging and monitoring. With our wireshark
> extension it's pretty useful to know the comm-name of a process when
> monitoring a bus. As we explained last time, this is not about
> security. We're aware that a process can modify them. We use them only
> as additional meta-data for logging and debugging.

Use the PID.  Really.  Your wireshark extention can look this crap up
in /proc and, if it fails due to a race, big frickin' deal.

>
> If we put those items into the payload, we have to transmit this data
> even if the destination process is not interested in this.
> Furthermore, each caller has to run multiple syscalls on each message
> to retrieve those values.
>
> We use these items heavily for filtering and debugging, regardless of
> the payload protocol that is transmitted on the bus.
>
> To give another specific use-case here: dbus supports bus activation,
> where a message sent to a non-running service causes it to be spawned
> implicitly without losing the message. Now, with such a scheme it is
> incredibly useful to be able to log which client caused a service to
> be triggered, hence we want to know the cmdline/exe/comm of the
> client. Not knowing this is a major pita when trying to trace the boot
> process and figuring out why a specific service got activated.

Again, use the PID for tracing, please.

At the very least, make it impossible to specify these fields in the
"must be received" set and rename them to something like
KDBUS_INSTALL_UNRELIABLE_CMDLINE, etc, because they're unreliable

Finally, this stuff should only be readable by privileged users.  And
using the PID accomplishes that.

>
> Also note that since v2 of the patch there's actually a per-sender
> mask for meta-data like this, hence a peer which doesn't want to pass
> its exec/cmdline/comm along can do that. Of course, this will
> seriously hamper debuggability and transparency...

Transparency is a terrible thing here.

How many users put passwords into things on the command line?  Yes,
it's a bad idea (for reasons that are entirely stupid), but now those
passwords get *logged*.

If this is in the kernel, and someone complains that sensitive data is
showing up on ten different logs on their system, they'll *correctly*
blame the kernel.  If you at least use the PID and restrict it to the
logging code, then at least the bug report will go to the logging
daemon, which will be *correctly* accused of doing something daft, and
it can be fixed.

>
>>> +
>>> +  KDBUS_ATTACH_CGROUP
>>> +    Attaches an item of type KDBUS_ITEM_CGROUP with the task's cgroup path.
>>> +
>>> +  KDBUS_ATTACH_CAPS
>>> +    Attaches an item of type KDBUS_ITEM_CAPS, carrying sets of capabilities
>>> +    that should be accessed via kdbus_item.caps.caps. Also, userspace should
>>> +    be written in a way that it takes kdbus_item.caps.last_cap into account,
>>> +    and derive the number of sets and rows from the item size and the reported
>>> +    number of valid capability bits.
>>> +
>>
>> Please remove this, too, or justify its use.
>
> cgroup information tells us which service is doing a bus request. This
> is useful for a variety of things. For example, the bus activation
> logging item above benefits from it. In general, if some message shall
> be logged about any client it is useful to know its service name.
>
> Capabilities are useful to authenticate specific method calls. For
> example, when a client asks systemd to reboot, without this concept we
> can only check for UID==0 to decide whether to allow this. Breaking
> this down to capabilities in a race-free way has the benefit of
> allowing systemd to bind this to CAP_SYS_BOOT instead. There is no
> reason to deny a process with CAP_SYS_BOOT to reboot via bus-APIs, as
> they could just enforce it via syscalls, anyway.

With all due respect, BS.

I admit that there is probably no reason to deny systemd-based reboot
to a CAP_SYS_BOOT-capable process, but there is absolutely no reason
to give processes that are supposed to reboot using systemd the
CAP_SYS_BOOT capability.

In any event, I suspect you'll have a hard time justifying this for
anything other than CAP_SYS_BOOT.  Just because CAP_SYS_ADMIN users
can probably do whatever they want doesn't mean that systemd should
make that a built-in policy.

Also, wtf is the bounding set and such for?  At the very least this
should only be the effective set.

>
> We think it's a useful and reliable authentication method. Why should
> we remove it?

Because the implementation is buggy and therefore it's insecure?
Remember that caps are namespaced in an interesting way.

>
> Anyway, these items are  just optional. The sender can refuse the
> reveal them, and the item is only transmitted if the receiver opted in
> for it, too. So there's no need to drop any item type from the
> protocol.

No.

Because if receivers opt in to most of these, *they're doing it
wrong*, and the kernel shouldn't be in the business of helping them.

>
>>> +  KDBUS_ATTACH_SECLABEL
>>> +    Attaches an item of type KDBUS_ITEM_SECLABEL, which contains the SELinux
>>> +    security label of the sending task. Access via kdbus_item->str.
>>> +
>>
>> This one, too, and please justify why code that uses it will work in
>> containers an on non-selinux systems.
>
> This maps to SCM_PEERSEC on AF_UNIX sockets. This is actually heavily
> used already on dbus1. For example, systemd actually uses this
> information about a bus peer to check whether certain operations are
> allowed, on top of the normal policy. To give an explicit example:
> when starting a service systemd gets the client's peer label from
> AF_UNIX via SCM_PEERSEC, reads the security label of the service file
> in question, and then checks the selinux database (via one of
> libselinux APIs) whether to allow this change.
>
> Note that this is really nothing we came up with, it's code from the
> SELinux folks, it's simple enough, and has been exposed and used that
> way since ages in dbus1. libselinux offers all the right APIs to make
> use of this, and kdbus really needs to provide the same functionality
> as dbus1 in this regard here.
>
> Let met stress that checking the selinux database here is alway *on
> top* of the normal UID/caps based security checks services do. This is
> exactly how selinux enforces checks on files on top of UID/caps
> checks, or on process or anything else that is selinux-managed.

But I thought that the LSM hooks were going to replace all of that.

Can you get a selinux person to confirm that this is actually necessary?

>
>>> +  KDBUS_ATTACH_AUDIT
>>> +    Attaches an item of type KDBUS_ITEM_AUDIT, which contains the audio label
>>> +    of the sending taskj. Access via kdbus_item->str.
>>> +
>>
>> I will NAK the hell out of this until, at the very least, someone
>> documents what this means, how to parse it, what its stability rules
>> are, who is allowed to see the value it contains, why that value will
>> never evolve to become *more* security sensitive than it is now, etc.
>>
>> Audit gets to do crazy sh*t because it's restricted to privileged
>> receivers.  This isn't restricted like that, so it doesn't deserve the
>> same dispensation.  (And, honestly, I'm not sure that audit really
>> deserves its free pass on making sense.)
>
> This was based on a misunderstanding, so I will ignore it here. Lets
> discuss this on the metadata-patch, in case it's still unclear.

Yeah, I think you're right about this.

If I'm understanding this right, then I think it just needs a
documentation change and possibly a renaming of the metadata item
name.

>
>>> +  KDBUS_ATTACH_CONN_DESCRIPTION
>>> +    Attaches an item of type KDBUS_ITEM_CONN_DESCRIPTION that contains the
>>> +    sender connection's current name in kdbus_item.str.
>>> +
>>
>> Which name?  Can't there be several?
>
> No. There is only one connection description string, copied verbatim
> from what the connection supplied during HELLO.
>
> Note that this is really just about debugging, since in some cases
> processes might end up with multiple kdbus fds, and it is useful in
> tools like "busctl" to know which one is which.

Fair enough.

>
>>> +
>>> +13.1 Metadata and namespaces
>>> +----------------------------
>>> +
>>> +Metadata such as PIDs, UIDs or GIDs are automatically translated to the
>>> +namespaces of the domain that is used to send a message over. The namespaces
>>> +of a domain are pinned at creation time, which is when the filesystem has been
>>> +mounted.
>>> +
>>> +Metadata items that cannot be translated are dropped.
>>
>> What if the receiver said that the item was mandatory?
>
> It is still dropped. It's the responsibility of the receiver to reject
> messages that lack required metadata.

Thanks,
Andy
