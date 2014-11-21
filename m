From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: kdbus: add documentation
Date: Fri, 21 Nov 2014 09:12:39 -0800
Message-ID: <CALCETrWUekPq6pquuiVperBihQHgcvCF=WzVJTZziHhUJYsh4Q@mail.gmail.com>
References: <1416546149-24799-1-git-send-email-gregkh@linuxfoundation.org> <1416546149-24799-2-git-send-email-gregkh@linuxfoundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1416546149-24799-2-git-send-email-gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, One Thousand Gnomes <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Tom Gundersen <teg-B22kvLQNl6c@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>, David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Djalal Harouni <tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Nov 20, 2014 at 9:02 PM, Greg Kroah-Hartman
<gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org> wrote:
> From: Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>
>
> kdbus is a system for low-latency, low-overhead, easy to use
> interprocess communication (IPC).
>
> The interface to all functions in this driver is implemented through
> ioctls on files exposed through the mount point of a kdbusfs.  This
> patch adds detailed documentation about the kernel level API design.
>
> Signed-off-by: Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>
> Signed-off-by: David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Djalal Harouni <tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
> ---

> +  Pool:
> +    Each connection allocates a piece of shmem-backed memory that is used
> +    to receive messages and answers to ioctl command from the kernel. It is
> +    never used to send anything to the kernel. In order to access that memory,
> +    userspace must mmap() it into its task.
> +    See section 12 for more details.

At the risk of opening a can of worms, wouldn't this be much more
useful if you could share a pool between multiple connections?


> +
> +
> +4. Items
> +===============================================================================
> +
> +To flexibly augment transport structures used by kdbus, data blobs of type
> +struct kdbus_item are used. An item has a fixed-sized header that only stores
> +the type of the item and the overall size. The total size is variable and is
> +in some cases defined by the item type, in other cases, they can be of
> +arbitrary length (for instance, a string).
> +
> +In the external kernel API, items are used for many ioctls to transport
> +optional information from userspace to kernelspace. They are also used for
> +information stored in a connection's pool, such as messages, name lists or
> +requested connection information.
> +
> +In all such occasions where items are used as part of the kdbus kernel API,
> +they are embedded in structs that have an overall size of their own, so there
> +can be many of them.
> +
> +The kernel expects all items to be aligned to 8-byte boundaries.
> +
> +A simple iterator in userspace would iterate over the items until the items
> +have reached the embedding structure's overall size. An example implementation
> +of such an iterator can be found in tools/testing/selftests/kdbus/kdbus-util.h.

It looks like many (all?) item consumers ignore unknown items.  This
seems like a compatbility problem.

Would it be better to have a bit in each item that toggles between
"ignore me if you don't recognize me" and "error out if you don't
recognize me"?

> +KDBUS_CMD_BUS_MAKE, and KDBUS_CMD_ENDPOINT_MAKE take a
> +struct kdbus_cmd_make argument.
> +
> +struct kdbus_cmd_make {
> +  __u64 size;
> +    The overall size of the struct, including its items.
> +
> +  __u64 flags;
> +    The flags for creation.
> +
> +    KDBUS_MAKE_ACCESS_GROUP
> +      Make the device file group-accessible
> +
> +    KDBUS_MAKE_ACCESS_WORLD
> +      Make the device file world-accessible

This thing is a file.  What's wrong with using a normal POSIX mode?
(And what to the read, write, and exec modes do?)

> +
> +
> +6.2 Creating connections
> +------------------------
> +
> +A connection to a bus is created by opening an endpoint file of a bus and
> +becoming an active client with the KDBUS_CMD_HELLO ioctl. Every connected client
> +connection has a unique identifier on the bus and can address messages to every
> +other connection on the same bus by using the peer's connection id as the
> +destination.
> +
> +The KDBUS_CMD_HELLO ioctl takes the following struct as argument.
> +
> +struct kdbus_cmd_hello {
> +  __u64 size;
> +    The overall size of the struct, including all attached items.
> +
> +  __u64 conn_flags;
> +    Flags to apply to this connection:
> +
> +    KDBUS_HELLO_ACCEPT_FD
> +      When this flag is set, the connection can be sent file descriptors
> +      as message payload. If it's not set, any attempt of doing so will
> +      result in -ECOMM on the sender's side.
> +
> +    KDBUS_HELLO_ACTIVATOR
> +      Make this connection an activator (see below). With this bit set,
> +      an item of type KDBUS_ITEM_NAME has to be attached which describes
> +      the well-known name this connection should be an activator for.
> +
> +    KDBUS_HELLO_POLICY_HOLDER
> +      Make this connection a policy holder (see below). With this bit set,
> +      an item of type KDBUS_ITEM_NAME has to be attached which describes
> +      the well-known name this connection should hold a policy for.
> +
> +    KDBUS_HELLO_MONITOR
> +      Make this connection an eaves-dropping connection that receives all
> +      unicast messages sent on the bus. To also receive broadcast messages,
> +      the connection has to upload appropriate matches as well.
> +      This flag is only valid for privileged bus connections.
> +
> +  __u64 attach_flags_send;
> +      Set the bits for metadata this connection permits to be sent to the
> +      receiving peer. Only metadata items that are both allowed to be sent by
> +      the sender and that are requested by the receiver will effectively be
> +      attached to the message eventually. Note, however, that the bus may
> +      optionally enforce some of those bits to be set. If the match fails,
> +      -ECONNREFUSED will be returned. In either case, this field will be set
> +      to the mask of metadata items that are enforced by the bus. The
> +      KDBUS_FLAGS_KERNEL bit will as well be set.
> +
> +  __u64 attach_flags_recv;
> +      Request the attachment of metadata for each message received by this
> +      connection. The metadata actually attached may actually augment the list
> +      of requested items. See section 13 for more details.
> +
> +  __u64 bus_flags;
> +      Upon successful completion of the ioctl, this member will contain the
> +      flags of the bus it connected to.
> +
> +  __u64 id;
> +      Upon successful completion of the ioctl, this member will contain the
> +      id of the new connection.
> +
> +  __u64 pool_size;
> +      The size of the communication pool, in bytes. The pool can be accessed
> +      by calling mmap() on the file descriptor that was used to issue the
> +      KDBUS_CMD_HELLO ioctl.
> +
> +  struct kdbus_bloom_parameter bloom;
> +      Bloom filter parameter (see below).
> +
> +  __u8 id128[16];
> +      Upon successful completion of the ioctl, this member will contain the
> +      128 bit wide UUID of the connected bus.
> +
> +  struct kdbus_item items[0];
> +      Variable list of items to add optional additional information. The
> +      following items are currently expected/valid:
> +
> +      KDBUS_ITEM_CONN_DESCRIPTION
> +        Contains a string to describes this connection's name, so it can be
> +        identified later.
> +
> +      KDBUS_ITEM_NAME
> +      KDBUS_ITEM_POLICY_ACCESS
> +        For activators and policy holders only, combinations of these two
> +        items describe policy access entries (see section about policy).
> +
> +      KDBUS_ITEM_CREDS
> +      KDBUS_ITEM_SECLABEL
> +        Privileged bus users may submit these types in order to create
> +        connections with faked credentials. The only real use case for this
> +        is a proxy service which acts on behalf of some other tasks. For a
> +        connection that runs in that mode, the message's metadata items will
> +        be limited to what's specified here. See section 13 for more
> +        information.

This is still confusing.  There are multiple places in which metadata
is attached.  Which does this apply to?  And why are only creds and
seclabel listed?


> +
> +6.4 Retrieving information on a connection
> +------------------------------------------
> +
> +The KDBUS_CMD_CONN_INFO ioctl can be used to retrieve credentials and
> +properties of the initial creator of a connection. This ioctl uses the
> +following struct:
> +
> +struct kdbus_cmd_info {
> +  __u64 size;
> +    The overall size of the struct, including the name with its 0-byte string
> +    terminator.
> +
> +  __u64 flags;
> +    Specify which metadata items should be attached to the answer.
> +    See section 13 for more details.
> +
> +    After the ioctl returns, this field will contain the current metadata
> +    attach flags of the connection.
> +
> +  __u64 kernel_flags;
> +    Valid flags for this command, returned by the kernel upon each call.
> +
> +  __u64 id;
> +    The connection's numerical ID to retrieve information for. If set to
> +    non-zero value, the 'name' field is ignored.
> +
> +  __u64 offset;
> +    When the ioctl returns, this value will yield the offset of the connection
> +    information inside the caller's pool.
> +
> +  struct kdbus_item items[0];
> +    The optional item list, containing the well-known name to look up as
> +    a KDBUS_ITEM_OWNED_NAME. Only required if the 'id' field is set to 0.
> +    All other items are currently ignored.
> +};
> +
> +After the ioctl returns, the following struct will be stored in the caller's
> +pool at 'offset'.
> +
> +struct kdbus_info {
> +  __u64 size;
> +    The overall size of the struct, including all its items.
> +
> +  __u64 id;
> +    The connection's unique ID.
> +
> +  __u64 flags;
> +    The connection's flags as specified when it was created.
> +
> +  __u64 kernel_flags;
> +    Valid flags for this command, returned by the kernel upon each call.
> +
> +  struct kdbus_item items[0];
> +    Depending on the 'flags' field in struct kdbus_cmd_info, items of
> +    types KDBUS_ITEM_OWNED_NAME and KDBUS_ITEM_CONN_DESCRIPTION are followed
> +    here.
> +};
> +
> +Once the caller is finished with parsing the return buffer, it needs to call
> +KDBUS_CMD_FREE for the offset.
> +
> +
> +6.5 Getting information about a connection's bus creator
> +--------------------------------------------------------
> +
> +The KDBUS_CMD_BUS_CREATOR_INFO ioctl takes the same struct as
> +KDBUS_CMD_CONN_INFO but is used to retrieve information about the creator of
> +the bus the connection is attached to. The metadata returned by this call is
> +collected during the creation of the bus and is never altered afterwards, so
> +it provides pristine information on the task that created the bus, at the
> +moment when it did so.

What's this for?  I understand the need for the creator of busses to
be authenticated, but doing it like this mean that anyone who will
*fail* authentication can DoS the authentic creator.

> +
> +7.3 Passing of Payload Data
> +---------------------------
> +
> +When connecting to the bus, receivers request a memory pool of a given size,
> +large enough to carry all backlog of data enqueued for the connection. The
> +pool is internally backed by a shared memory file which can be mmap()ed by
> +the receiver.
> +
> +KDBUS_MSG_PAYLOAD_VEC:
> +  Messages are directly copied by the sending process into the receiver's pool,
> +  that way two peers can exchange data by effectively doing a single-copy from
> +  one process to another, the kernel will not buffer the data anywhere else.
> +
> +KDBUS_MSG_PAYLOAD_MEMFD:
> +  Messages can reference memfd files which contain the data.
> +  memfd files are tmpfs-backed files that allow sealing of the content of the
> +  file, which prevents all writable access to the file content.
> +  Only sealed memfd files are accepted as payload data, which enforces
> +  reliable passing of data; the receiver can assume that neither the sender nor
> +  anyone else can alter the content after the message is sent.

This should specify *which* seals are checked.

> +
> +Apart from the sender filling-in the content into memfd files, the data will
> +be passed as zero-copy from one process to another, read-only, shared between
> +the peers.
> +
> +
> +7.4 Receiving messages
> +----------------------
> +
> +Messages are received by the client with the KDBUS_CMD_MSG_RECV ioctl. The
> +endpoint file of the bus supports poll() to wake up the receiving process when
> +new messages are queued up to be received.
> +
> +With the KDBUS_CMD_MSG_RECV ioctl, a struct kdbus_cmd_recv is used.
> +
> +struct kdbus_cmd_recv {
> +  __u64 flags;
> +    Flags to control the receive command.
> +
> +    KDBUS_RECV_PEEK
> +      Just return the location of the next message. Do not install file
> +      descriptors or anything else. This is usually used to determine the
> +      sender of the next queued message.
> +
> +    KDBUS_RECV_DROP
> +      Drop the next message without doing anything else with it, and free the
> +      pool slice. This a short-cut for KDBUS_RECV_PEEK and KDBUS_CMD_FREE.
> +
> +    KDBUS_RECV_USE_PRIORITY
> +      Use the priority field (see below).
> +
> +  __u64 kernel_flags;
> +    Valid flags for this command, returned by the kernel upon each call.
> +
> +  __s64 priority;
> +      With KDBUS_RECV_USE_PRIORITY set in flags, receive the next message in
> +      the queue with at least the given priority. If no such message is waiting
> +      in the queue, -ENOMSG is returned.
> +
> +  __u64 offset;
> +      Upon return of the ioctl, this field contains the offset in the
> +      receiver's memory pool.
> +};
> +
> +Unless KDBUS_RECV_DROP was passed, and given that the ioctl succeeded, the
> +offset field contains the location of the new message inside the receiver's
> +pool. The message is stored as struct kdbus_msg at this offset, and can be
> +interpreted with the semantics described above.

I'm confused here.  Is sent data written to the pool when send is
called or when recv is called?

If the former, what prevents DoS, especially DoS due to sending too many fds?

If the latter, where is the data buffered in the mean time?

> +
> +Also, if the connection allowed for file descriptor to be passed
> +(KDBUS_HELLO_ACCEPT_FD), and if the message contained any, they will be
> +installed into the receiving process after the KDBUS_CMD_MSG_RECV ioctl
> +returns. The receiving task is obliged to close all of them appropriately.

This makes it sound like fds are installed at receive time.  What
prevents resource exhaustion due to having excessive numbers of fds in
transit (that are presumably not accounted to anyone)?

> +
> +7.5 Canceling messages synchronously waiting for replies
> +--------------------------------------------------------
> +
> +When a connection sends a message with KDBUS_MSG_FLAGS_SYNC_REPLY and
> +blocks while waiting for the reply, the KDBUS_CMD_MSG_CANCEL ioctl can be
> +used on the same file descriptor to cancel the message, based on its cookie.
> +If there are multiple messages with the same cookie that are all synchronously
> +waiting for a reply, all of them will be canceled. Obviously, this is only
> +possible in multi-threaded applications.

What does "cancel the message" mean?  Does it just mean that the wait
for the reply is cancelled?

> +11. Policy
> +===============================================================================
> +
> +A policy databases restrict the possibilities of connections to own, see and
> +talk to well-known names. It can be associated with a bus (through a policy
> +holder connection) or a custom endpoint.

ISTM metadata items on bus names should be replaced with policy that
applies to the domain as a whole and governs bus creation.

> +A set of policy rules is described by a name and multiple access rules, defined
> +by the following struct.
> +
> +struct kdbus_policy_access {
> +  __u64 type;  /* USER, GROUP, WORLD */
> +    One of the following.
> +
> +    KDBUS_POLICY_ACCESS_USER
> +      Grant access to a user with the uid stored in the 'id' field.
> +
> +    KDBUS_POLICY_ACCESS_GROUP
> +      Grant access to a user with the gid stored in the 'id' field.
> +
> +    KDBUS_POLICY_ACCESS_WORLD
> +      Grant access to everyone. The 'id' field is ignored.
> +
> +  __u64 access;        /* OWN, TALK, SEE */
> +    The access to grant.
> +
> +    KDBUS_POLICY_SEE
> +      Allow the name to be seen.
> +
> +    KDBUS_POLICY_TALK
> +      Allow the name to be talked to.
> +
> +    KDBUS_POLICY_OWN
> +      Allow the name to be owned.
> +
> +  __u64 id;
> +    For KDBUS_POLICY_ACCESS_USER, stores the uid.
> +    For KDBUS_POLICY_ACCESS_GROUP, stores the gid.
> +};


What happens if there are multiple matches?


> +
> +11.4 TALK access and multiple well-known names per connection
> +-------------------------------------------------------------
> +
> +Note that TALK access is checked against all names of a connection.
> +For example, if a connection owns both 'org.foo.bar' and 'org.blah.baz', and
> +the policy database allows 'org.blah.baz' to be talked to by WORLD, then this
> +permission is also granted to 'org.foo.bar'. That might sound illogical, but
> +after all, we allow messages to be directed to either the name or a well-known
> +name, and policy is applied to the connection, not the name. In other words,
> +the effective TALK policy for a connection is the most permissive of all names
> +the connection owns.

This does seem illogical.  Does the recipient at least know which
well-known name was addressed?

> +11.5 Implicit policies
> +----------------------
> +
> +Depending on the type of the endpoint, a set of implicit rules might be
> +enforced. On default endpoints, the following set is enforced:
> +

How do these rules interact with installed policy?

> +  * Privileged connections always override any installed policy. Those
> +    connections could easily install their own policies, so there is no
> +    reason to enforce installed policies.
> +  * Connections can always talk to connections of the same user. This
> +    includes broadcast messages.

Why?  If anyone ever strengthens the concept of identity to include
things other than users (hmm -- there are already groups), this could
be very limiting.

> +  * Connections that own names might send broadcast messages to other
> +    connections that belong to a different user, but only if that
> +    destination connection does not own any name.
> +

This is weird.  It is also differently illogical than the "illogical"
thing above.

How about restricting access per name and making sure that the
receivers check what name was addressed before taking any action?

> +12. Pool
> +===============================================================================
> +
> +A pool for data received from the kernel is installed for every connection of
> +the bus, and is sized according to kdbus_cmd_hello.pool_size. It is accessed
> +when one of the following ioctls is issued:
> +
> +  * KDBUS_CMD_MSG_RECV, to receive a message
> +  * KDBUS_CMD_NAME_LIST, to dump the name registry
> +  * KDBUS_CMD_CONN_INFO, to retrieve information on a connection
> +
> +Internally, the pool is organized in slices, stored in an rb-tree. The offsets
> +returned by either one of the aforementioned ioctls describe offsets inside the
> +pool. In order to make the slice available for subsequent calls, KDBUS_CMD_FREE
> +has to be called on the offset.

Why are you documenting that the slices are stored in an rb-tree?
That's just an implementation details, right?

> +
> +To access the memory, the caller is expected to mmap() it to its task, like
> +this:
> +
> +  /*
> +   * POOL_SIZE has to be a multiple of PAGE_SIZE, and it must match the
> +   * value that was previously passed in the .pool_size field of struct
> +   * kdbus_cmd_hello.
> +   */
> +
> +  buf = mmap(NULL, POOL_SIZE, PROT_READ, MAP_PRIVATE, conn_fd, 0);
> +

Will mapping with PROT_WRITE fail?  What about MAP_SHARED?

And why are you suggesting MAP_PRIVATE?  That's just strange.

> +
> +13. Metadata
> +===============================================================================
> +
> +When a message is delivered to a receiver connection, it is augmented by
> +metadata items in accordance to the destination's current attach flags. The
> +information stored in those metadata items refer to the sender task at the
> +time of sending the message, so even if any detail of the sender task has
> +already changed upon message reception (or if the sender task does not exist
> +anymore), the information is still preserved and won't be modfied until the
> +message is freed.
> +
> +Note that there are two exceptions to the above rules:
> +
> +  a) Kernel generated messages don't have a source connection, so they won't be
> +     augmented.
> +
> +  b) If a connection was created with faked credentials (see section 6.2),
> +     the only attached metadata items are the ones provided by the connection
> +     itself. Other bits in the destination's attach_flags_recv won't have any
> +     effect in such cases.
> +
> +Also, there are two things to be considered by userspace programs regarding
> +those metadata items:
> +
> +  a) Userspace must cope with the fact that it might get more metadata than
> +     they requested. That happens, for example, when a broadcast message is
> +     sent and receivers have different attach flags. Items that haven't been
> +     requested should hence be silently ignored.
> +
> +  b) Userspace might not always get all requested metadata items that it
> +     requested. That is because some of those items are only added if a
> +     corresponding kernel feature has been enabled. Also, the two exceptions
> +     described above will as well lead to less items be attached than
> +     requested.
> +
> +
> +13.1 Known item types
> +---------------------
> +
> +The following attach flags are currently supported.
> +
> +  KDBUS_ATTACH_TIMESTAMP
> +    Attaches an item of type KDBUS_ITEM_TIMESTAMP which contains both the
> +    monotonic and the realtime timestamp, taken when the message was
> +    processed on the kernel side.
> +
> +  KDBUS_ATTACH_CREDS
> +    Attaches an item of type KDBUS_ITEM_CREDS, containing credentials as
> +    described in kdbus_creds: the uid, gid, pid, tid and starttime of the task.
> +

As mentioned last time, please remove or justify starttime.

> +  KDBUS_ATTACH_AUXGROUPS
> +    Attaches an item of type KDBUS_ITEM_AUXGROUPS, containing a dynamic
> +    number of auxiliary groups the sending task was a member of.
> +
> +  KDBUS_ATTACH_NAMES
> +    Attaches items of type KDBUS_ITEM_OWNED_NAME, one for each name the sending
> +    connection currently owns. The name and flags are stored in kdbus_item.name
> +    for each of them.
> +

That's interesting.  What's it for?

> +  KDBUS_ATTACH_TID_COMM
> +    Attaches an items of type KDBUS_ITEM_TID_COMM, transporting the sending
> +    task's 'comm', for the tid.  The string is stored in kdbus_item.str.
> +
> +  KDBUS_ATTACH_PID_COMM
> +    Attaches an items of type KDBUS_ITEM_PID_COMM, transporting the sending
> +    task's 'comm', for the pid.  The string is stored in kdbus_item.str.
> +
> +  KDBUS_ATTACH_EXE
> +    Attaches an item of type KDBUS_ITEM_EXE, containing the path to the
> +    executable of the sending task, stored in kdbus_item.str.
> +
> +  KDBUS_ATTACH_CMDLINE
> +    Attaches an item of type KDBUS_ITEM_CMDLINE, containing the command line
> +    arguments of the sending task, as an array of strings, stored in
> +    kdbus_item.str.

Please remove these four items.  They are genuinely useless.  Anything
that uses them for anything is either buggy or should have asked the
sender to put the value in the payload (and immediately wondered why
it was doing that).

> +
> +  KDBUS_ATTACH_CGROUP
> +    Attaches an item of type KDBUS_ITEM_CGROUP with the task's cgroup path.
> +
> +  KDBUS_ATTACH_CAPS
> +    Attaches an item of type KDBUS_ITEM_CAPS, carrying sets of capabilities
> +    that should be accessed via kdbus_item.caps.caps. Also, userspace should
> +    be written in a way that it takes kdbus_item.caps.last_cap into account,
> +    and derive the number of sets and rows from the item size and the reported
> +    number of valid capability bits.
> +

Please remove this, too, or justify its use.

> +  KDBUS_ATTACH_SECLABEL
> +    Attaches an item of type KDBUS_ITEM_SECLABEL, which contains the SELinux
> +    security label of the sending task. Access via kdbus_item->str.
> +

This one, too, and please justify why code that uses it will work in
containers an on non-selinux systems.

> +  KDBUS_ATTACH_AUDIT
> +    Attaches an item of type KDBUS_ITEM_AUDIT, which contains the audio label
> +    of the sending taskj. Access via kdbus_item->str.
> +

I will NAK the hell out of this until, at the very least, someone
documents what this means, how to parse it, what its stability rules
are, who is allowed to see the value it contains, why that value will
never evolve to become *more* security sensitive than it is now, etc.

Audit gets to do crazy sh*t because it's restricted to privileged
receivers.  This isn't restricted like that, so it doesn't deserve the
same dispensation.  (And, honestly, I'm not sure that audit really
deserves its free pass on making sense.)

> +  KDBUS_ATTACH_CONN_DESCRIPTION
> +    Attaches an item of type KDBUS_ITEM_CONN_DESCRIPTION that contains the
> +    sender connection's current name in kdbus_item.str.
> +

Which name?  Can't there be several?

> +
> +13.1 Metadata and namespaces
> +----------------------------
> +
> +Metadata such as PIDs, UIDs or GIDs are automatically translated to the
> +namespaces of the domain that is used to send a message over. The namespaces
> +of a domain are pinned at creation time, which is when the filesystem has been
> +mounted.
> +
> +Metadata items that cannot be translated are dropped.

What if the receiver said that the item was mandatory?


Thanks,
Andy
