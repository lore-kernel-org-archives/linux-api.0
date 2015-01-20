From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 01/13] kdbus: add documentation
Date: Tue, 20 Jan 2015 14:58:55 +0100
Message-ID: <54BE5F1F.8070703@gmail.com>
References: <1421435777-25306-1-git-send-email-gregkh@linuxfoundation.org> <1421435777-25306-2-git-send-email-gregkh@linuxfoundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1421435777-25306-2-git-send-email-gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, arnd-r2nGTMty4D4@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org, teg-B22kvLQNl6c@public.gmane.org, jkosina-AlSwsSmVLrQ@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, daniel-cYrQPVfZooxQFI55V6+gNQ@public.gmane.org, dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org, Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 01/16/2015 08:16 PM, Greg Kroah-Hartman wrote:
> From: Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>
>=20
> kdbus is a system for low-latency, low-overhead, easy to use
> interprocess communication (IPC).
>=20
> The interface to all functions in this driver is implemented via ioct=
ls
> on files exposed through a filesystem called 'kdbusfs'. The default
> mount point of kdbusfs is /sys/fs/kdbus. This patch adds detailed
> documentation about the kernel level API design.

And now the details feedback.

Please note that for the various points I raise below, even in
cases where I don't suggest/request a fix, the fact that I've
needed to answer a question probably suggests a deficiency in=20
the documentation that probably needs to be remedied.

Many of my comments below are wording and typo fixes. While
these may sem trivial, the existence of various wording problems
and typos is a significant distraction, especially while trying
to grok a document of this size.

I've marked one or two notable questions about the API with "###".

> Signed-off-by: Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>
> Signed-off-by: David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Djalal Harouni <tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
> ---
>  Documentation/kdbus.txt | 2107 +++++++++++++++++++++++++++++++++++++=
++++++++++
>  1 file changed, 2107 insertions(+)
>  create mode 100644 Documentation/kdbus.txt
>=20
> diff --git a/Documentation/kdbus.txt b/Documentation/kdbus.txt
> new file mode 100644
> index 000000000000..2592a7e37079
> --- /dev/null
> +++ b/Documentation/kdbus.txt
> @@ -0,0 +1,2107 @@
> +D-Bus is a system for powerful, easy to use interprocess communicati=
on (IPC).
> +
> +The focus of this document is an overview of the low-level, native k=
ernel D-Bus
> +transport called kdbus. Kdbus exposes its functionality via files in=
 a
> +filesystem called 'kdbusfs'. All communication between processes tak=
es place
> +via ioctls on files exposed through the mount point of a kdbusfs. Th=
e default
> +mount point of kdbusfs is /sys/fs/kdbus.
> +
> +Please note that kdbus was designed as transport layer for D-Bus, bu=
t is in no
> +way limited, nor controlled by the D-Bus protocol specification. The=
 D-Bus
> +protocol is one possible application layer on top of kdbus.
> +
> +For the general D-Bus protocol specification, the payload format, th=
e
> +marshaling, and the communication semantics, please refer to:
> +  http://dbus.freedesktop.org/doc/dbus-specification.html
> +
> +For a kdbus specific userspace library implementation please refer t=
o:
> +  http://cgit.freedesktop.org/systemd/systemd/tree/src/systemd/sd-bu=
s.h
> +
> +Articles about D-Bus and kdbus:
> +  http://lwn.net/Articles/580194/
> +
> +
> +1. Terminology
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +  Domain:
> +    A domain is created each time a kdbusfs is mounted. Each process=
 that is
> +    capable to mount a new instance of a kdbusfs will have its own k=
dbus

s/is capable to mount/mounts/

> +    hierarchy. Each domain (ie, each mount point) offers its own "co=
ntrol"
> +    file to create new buses. Domains have no connection to each oth=
er and
> +    cannot see nor talk to each other. See section 5 for more detail=
s.

Smoother would be:

    s/cannot see nor talk/can neither see nor talk/

> +
> +  Bus:
> +    A bus is a named object inside a domain. Clients exchange messag=
es
> +    over a bus. Multiple buses themselves have no connection to each=
 other;
> +    messages can only be exchanged on the same bus. The default endp=
oint of
> +    a bus, where clients establish the connection to, is the "bus" f=
ile

Maybe:

where clients establish the connection to
=3D=3D>
to which clients establish connections
?

> +    /sys/fs/kdbus/<bus name>/bus.
> +    Common operating system setups create one "system bus" per syste=
m, and one
> +    "user bus" for every logged-in user. Applications or services ma=
y create

At the kdbus level is there any difference between such system and user=
 buses?
If not, it would perhaps be good to insert a parenthetical aside to say=
=20
that.

> +    their own private buses.  See section 5 for more details.
> +
> +  Endpoint:
> +    An endpoint provides a file to talk to a bus. Opening an endpoin=
t
> +    creates a new connection to the bus to which the endpoint belong=
s. All
> +    endpoints have unique names and are accessible as files undernea=
th the
> +    directory of a bus, e.g., /sys/fs/kdbus/<bus>/<endpoint>
> +    Every bus has a default endpoint called "bus". A bus can optiona=
lly offer
> +    additional endpoints with custom names to provide restricted acc=
ess to the
> +    bus. Custom endpoints carry additional policy which can be used =
to create
> +    sandboxes with locked-down, limited, filtered access to a bus.  =
See
> +    section 5 for more details.
> +
> +  Connection:
> +    A connection to a bus is created by opening an endpoint file of =
a bus and
> +    becoming an active client with the HELLO exchange. Every ordinar=
y client
> +    connection has a unique identifier on the bus and can address me=
ssages to
> +    every other connection on the same bus by using the peer's conne=
ction id
> +    as the destination.  See section 6 for more details.
> +
> +  Pool:
> +    Each connection allocates a piece of shmem-backed memory that is=
 used
> +    to receive messages and answers to ioctl commands from the kerne=
l. It is
> +    never used to send anything to the kernel. In order to access th=
at memory,
> +    userspace must mmap() it into its address space.

s/userspace/a userspace application/

> +    See section 12 for more details.
> +
> +  Well-known Name:
> +    A connection can, in addition to its implicit unique connection =
id, request
> +    the ownership of a textual well-known name. Well-known names are=
 noted in
> +    reverse-domain notation, such as com.example.service1. Connectio=
ns offering
> +    a service on a bus are usually reached by its well-known name. T=
he analogy

Noun/pronoun number disagreement at "Connections... its".
=3D=3D>
    A connection that offers a service on a bus is usually reached by i=
ts=20
    well-known name.

> +    of connection id and well-known name is an IP address and a DNS =
name

Doing s/id/ID/ throughout the doc would help readability. (The doc=20
already uses "ID" in some places, so consistency is a further argument=20
for this change.)

> +    associated with that address.
> +
> +  Message:
> +    Connections can exchange messages with other connections by addr=
essing
> +    the peers with their connection id or well-known name. A message=
 consists
> +    of a message header with kernel-specific information on how to r=
oute the

What does "kernel-specific" mean here? Something needs explaining (or r=
emoving).

> +    message, and the message payload, which is a logical byte stream=
 of
> +    arbitrary size. Messages can carry additional file descriptors t=
o be passed

So, this is FD passing like UNIX domain sockets? If yes, it would be he=
lpful
here to mention that analogy.

> +    from one connection to another. Every connection can specify whi=
ch set of
> +    metadata the kernel should attach to the message when it is deli=
vered
> +    to the receiving connection. Metadata contains information like:=
 system
> +    timestamps, uid, gid, tid, proc-starttime, well-known-names, pro=
cess comm,

s/well-known-names/well-known names/

See the note on "ID" above. I think UID, GID, TID throughout would help=
=20
readability.

> +    process exe, process argv, cgroup, capabilities, seclabel, audit=
 session,
> +    loginuid and the connection's human-readable name.
> +    See section 7 and 13 for more details.
> +
> +  Item:
> +    The API of kdbus implements a notion of items, submitted through=
 and

s/a notion/the notion/

> +    returned by most ioctls, and stored inside data structures in th=
e
> +    connection's pool. See section 4 for more details.
> +
> +  Broadcast and Match:
> +    Broadcast messages are potentially sent to all connections of a =
bus. By
> +    default, the connections will not actually receive any of the se=
nt
> +    broadcast messages; only after installing a match for specific m=
essage
> +    properties, a broadcast message passes this filter.

"Filter" suddenly gets mentioned here without previously being defined.=
 I suspect=20
the last piece should read more like:

  a connection will receive a broadcast message only after it installs =
a filter
  that matches the specific message properties of the broadcast message=
=2E

> +    See section 10 for more details.
> +
> +  Policy:
> +    A policy is a set of rules that define which connections can see=
, talk to,
> +    or register a well-know name on the bus. A policy is attached to=
 buses and

s/know/know/

> +    custom endpoints, and modified by policy holder connections or o=
wners of
> +    custom endpoints. See section 11 for more details.
> +    See section 11 for more details.

Repeated last sentence.

> +  Privileged bus users:
> +    A user connecting to the bus is considered privileged if it is e=
ither the
> +    creator of the bus, or if it has the CAP_IPC_OWNER capability fl=
ag set.
> +
> +
> +2. Control Files Layout
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +The kdbus interface is exposed through files in its kdbusfs mount po=
int
> +(defaults to /sys/fs/kdbus):
> +
> +  /sys/fs/kdbus                 (mount point of kdbusfs)
> +  |-- control                   (domain control-file)
> +  |-- 0-system                  (bus of user uid=3D0)
> +  |   |-- bus                   (default endpoint of bus '0-system')
> +  |   `-- ep.apache             (custom endpoint of bus '0-system')
> +  |-- 1000-user                 (bus of user uid=3D1000)
> +  |   `-- bus                   (default endpoint of bus '1000-user'=
)
> +  `-- 2702-user                 (bus of user uid=3D2702)
> +      |-- bus                   (default endpoint of bus '2702-user'=
)
> +      `-- ep.app                (custom endpoint of bus '2702-user')
> +
> +
> +3. Data Structures and flags
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +3.1 Data structures and interconnections
> +----------------------------------------
> +
> +  +-----------------------------------------------------------------=
---------+
> +  | Domain (Mount Point)                                            =
         |
> +  | /sys/fs/kdbus/control                                           =
         |
> +  | +---------------------------------------------------------------=
-------+ |
> +  | | Bus (System Bus)                                              =
       | |
> +  | | /sys/fs/kdbus/0-system/                                       =
       | |
> +  | | +-------------------------------+ +---------------------------=
-----+ | |
> +  | | | Endpoint                      | | Endpoint                  =
     | | |
> +  | | | /sys/fs/kdbus/0-system/bus    | | /sys/fs/kdbus/0-system/ep.=
app  | | |
> +  | | +-------------------------------+ +---------------------------=
-----+ | |
> +  | | +--------------+ +--------------+ +--------------+ +----------=
-----+ | |
> +  | | | Connection   | | Connection   | | Connection   | | Connectio=
n    | | |
> +  | | | :1.22        | | :1.25        | | :1.55        | | :1.81    =
     | | |
> +  | | +--------------+ +--------------+ +--------------+ +----------=
-----+ | |
> +  | +---------------------------------------------------------------=
-------+ |
> +  |                                                                 =
         |
> +  | +---------------------------------------------------------------=
-------+ |
> +  | | Bus (User Bus for UID 2702)                                   =
       | |
> +  | | /sys/fs/kdbus/2702-user/                                      =
       | |
> +  | | +-------------------------------+ +---------------------------=
-----+ | |
> +  | | | Endpoint                      | | Endpoint                  =
     | | |
> +  | | | /sys/fs/kdbus/2702-user/bus   | | /sys/fs/kdbus/2702-user/ep=
=2Eapp | | |
> +  | | +-------------------------------+ +---------------------------=
-----+ | |
> +  | | +--------------+ +--------------+ +--------------+ +----------=
-----+ | |
> +  | | | Connection   | | Connection   | | Connection   | | Connectio=
n    | | |
> +  | | | :1.22        | | :1.25        | | :1.55        | | :1.81    =
     | | |
> +  | | +--------------+ +--------------+ +---------------------------=
-----+ | |
> +  | +---------------------------------------------------------------=
-------+ |
> +  +-----------------------------------------------------------------=
---------+
> +
> +The above description uses the D-Bus notation of unique connection n=
ames that
> +adds a ":1." prefix to the connection's unique ID. kdbus itself does=
n't
> +use that notation, neither internally nor externally. However, libra=
ries and
> +other userspace code that aims for compatibility to D-Bus might.

s/compatibility to/compatibility with/

> +
> +3.2 Flags
> +---------
> +
> +All ioctls used in the communication with the driver contain three 6=
4-bit
> +fields: 'flags', 'kernel_flags' and 'return_flags'. All of them are =
specific
> +to the ioctl used.
> +
> +In 'flags', the behavior of the command can be tweaked. All bits tha=
t are not
> +recognized by the kernel in this field are rejected, and the ioctl f=
ails with
> +-EINVAL.
> +
> +In 'kernel_flags', the kernel driver writes back the mask of support=
ed bits
> +upon each call, and sets the KDBUS_FLAGS_KERNEL bit. This is a way t=
o probe
> +possible kernel features and make userspace code forward and backwar=
d
> +compatible.

So, is "kernel_flags' a bounding superset of what the caller may specif=
y=20
in 'flags'? If yes, please make that clearer.

> +
> +In 'return_flags', the kernel can return results of the command, in =
addition
> +to the actual return value. This is mostly to inform userspace about=
 non-fatal
> +conditions that occurred during the execution of the command.
> +
> +
> +4. Items
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +To flexibly augment transport structures, data blobs of type struct =
kdbus_item
> +can be attached to the structs passed into the ioctls. Some ioctls m=
ake items
> +of certain types mandatory, others are optional. Unsupported items w=
ill cause
> +the ioctl to fail -EINVAL.
> +
> +The total size of an item is variable and is in some cases defined b=
y the item
> +type. In other cases, they can be of arbitrary length (for instance,=
 a string).
> +
> +Items are also used for information stored in a connection's pool, s=
uch as
> +received messages, name lists or requested connection or bus owner i=
nformation.
> +
> +Whenever items are used as part of the kdbus kernel API, they are em=
bedded in
> +structs that have an overall size of their own, so there can be mult=
iple items

"have an overall size of their own" as hard to grok. I think you mean

    ... are embedded insides structs that themselves include a size fie=
ld
    containing the overall size of the structure. This allows multiple=20
    items per ioctl.

> +per ioctl.
> +
> +The kernel expects all items to be aligned to 8-byte boundaries. Una=
ligned
> +items or such that are unsupported by the ioctl are rejected.

s/such/items/?
(Or otherwise replace "such" with whatever it actually means.)

> +A simple iterator in userspace would iterate over the items until th=
e items
> +have reached the embedding structure's overall size. An example impl=
ementation
> +of such an iterator can be found in tools/testing/selftests/kdbus/kd=
bus-util.h.
> +
> +
> +5. Creation of new domains, buses and endpoints
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +
> +5.1 Domains
> +-----------
> +
> +A domain is a container of buses. Domains themselves do not provide =
any IPC
> +functionality. Their sole purpose is to manage buses allocated in th=
eir
> +domain. Each time kdbusfs is mounted, a new kdbus domain is created,=
 with its
> +own 'control' file. The lifetime of the domain ends once the user ha=
s unmounted
> +the kdbusfs. If you mount kdbusfs multiple times, each will have its=
 own kdbus
> +domain internally.=20

What does that last sentence mean? Somehow it needs to be reworded to b=
etter
convey whatever sense it is trying to convey.

> Operations performed on one domain do not affect any
> +other domain.
> +
> +The full kdbusfs hierarchy, any sub-directory, or file can be bind-m=
ounted to
> +an external mount point and will remain fully functional. The kdbus =
domain and
> +any linked resources stay available until the original mount and all=
 subsequent
> +bind-mounts have been unmounted.
> +
> +During creation, domains pin the user-namespace of the creator and u=
se
> +it as controlling user-namespace for this domain. Any user accountin=
g is done

s/as/as the/

> +relative to that user-namespace.
> +
> +Newly created kdbus domains do not have any bus pre-created. The onl=
y resource
> +available is a 'control' file, which is used to manage kdbus domains=
=2E
> +Currently, 'control' files are exclusively used to create buses via

s/exclusively used/used exclusively/

> +KDBUS_CMD_BUS_MAKE, but further ioctls might be added in the future.
> +
> +
> +5.2 Buses
> +---------
> +
> +A bus is a shared resource between connections to transmit messages.=
 Each bus

=3D=3D> A bus is a resource that is shared between connections in order=
 to=20
    transmit messages

> +is independent and operations on the bus will not have any effect on=
 other
> +buses. A bus is a management entity, that controls the addresses of =
its

s/,//

> +connections, their policies and message transactions performed via t=
his bus.
> +
> +Each bus is bound to the domain it was created on. It has a custom n=
ame that is
> +unique across all buses of a domain. In kdbusfs, a bus is presented =
as a
> +directory. No operations can be performed on the bus itself, instead=
 you need

s/,/;/

> +to perform those on an endpoint associated with the bus. Endpoints a=
re

s/those/operations/

> +accessible as files underneath the bus directory. A default endpoint=
 called
> +"bus" is provided on each bus.
> +
> +Bus names may be chosen freely except for one restriction: the name
> +must be prefixed with the numeric UID of the creator and a dash. Thi=
s

s/UID/effective  UID/=20
(I assume it's the effective UID...)

> +is required to avoid namespace clashes between different users. When
> +creating a bus the name must be passed in properly formatted, or the

the name must be passed in properly formatted
=3D=3D>
that name that is passed in must be properly formatted

> +kernel will refuse creation of the bus. Example: "1047-foobar" is an
> +OK name for a bus registered by a user with UID 1047. However,

s/OK/acceptable/

> +"1024-foobar" is not, and neither is "foobar".
> +The UID must be provided in the user-namespace of the parent domain.
> +
> +To create a new bus, you need to open the control file of a domain a=
nd run the

s/run/employ/ (One doesn't "run" a system call.)

> +KDBUS_CMD_BUS_MAKE ioctl. The control file descriptor that was used =
to issue
> +KDBUS_CMD_BUS_MAKE must not have been used for any other control-ioc=
tl before

Maybe better:

have been used for any other control-ioctl before
=3D=3D>
previously have been used for any other control-ioctl

> +and needs to be kept open for the entire life-time of the created bu=
s. Closing

s/needs/must/ (just reads smoother)

> +it will immediately cleanup the entire bus and all its associated re=
sources and
> +endpoints. Every control file descriptor can only be used to create =
a single
> +new bus; from that point on, it is not used for any further communic=
ation until
> +the final close().
> +
> +Each bus will generate a random, 128-bit UUID upon creation. It will=
 be

/It/This UUID/

> +returned to creators of connections through kdbus_cmd_hello.id128 an=
d can
> +be used by userspace to uniquely identify buses, even across differe=
nt machines
> +or containers. The UUID will have its variant bits set to 'DCE', and=
 denote
> +version 4 (random).

I find that last sentence rather difficult to grasp. I think more detai=
l
needs to be added.

> +When creating buses, a variable list of items that must be passed in
> +the items array is expected otherwise bus creation will fail.

What does "a variable list of items that must be passed in
the items array" mean? Something needs fixing, I think.

> +
> +5.3 Endpoints
> +-------------
> +
> +Endpoints are entry points to a bus. By default, each bus has a defa=
ult
> +endpoint called 'bus'. The bus owner has the ability to create custo=
m
> +endpoints with specific names, permissions, and policy databases (se=
e below).
> +An endpoint is presented as file underneath the directory of the par=
ent bus.
> +
> +To create a custom endpoint, open the default endpoint ('bus') and u=
se the
> +KDBUS_CMD_ENDPOINT_MAKE ioctl with "struct kdbus_cmd_make". Custom e=
ndpoints
> +always have a policy database that, by default, forbids any operatio=
n. You have
> +to explicitly install policy entries to allow any operation on this =
endpoint.
> +Once KDBUS_CMD_ENDPOINT_MAKE succeeded, this file descriptor will ma=
nage the
> +newly created endpoint resource. It cannot be used to manage further=
 resources.
> +
> +Endpoint names may be chosen freely except for one restriction: the =
name
> +must be prefixed with the numeric UID of the creator and a dash. Thi=
s

s/UID/effective UID/

> +is required to avoid namespace clashes between different users. When
> +creating an endpoint the name must be passed in properly formatted, =
or the

creating an endpoint the name must be passed in properly formatted
=3D=3D>
creating an endpoint, the name that is passed in must be properly forma=
tted

> +kernel will refuse creation of the endpoint. Example: "1047-foobar" =
is an
> +OK name for an endpoint registered by a user with UID 1047. However,

s/OK/acceptable/

> +"1024-foobar" is not, and neither is "foobar".

Because this text reads almost exactly as the bus text in 5.2, I did=20
a double take here. I suggest making the text more distinct in each cas=
e.

So, for example:

    Example: "1047-my-endpoint" is an OK name for an endpoint registere=
d=20
    by a user with UID 1047. However, "1024-my-endpoint" is not, and=20
    neither is "my-endpoint".

(And you could do similar in the bus text in section 5.2.)

> +The UID must be provided in the user-namespace of the parent domain.
> +
> +To create connections to a bus, you use KDBUS_CMD_HELLO. See section=
 6 for
> +details. Note that once KDBUS_CMD_HELLO succeeded, this file descrip=
tor manages

Note that once KDBUS_CMD_HELLO succeeded,
=3D=3D>
Note that after a successful KDBUS_CMD_HELLO,

> +the newly created connection resource. It cannot be used to manage f=
urther
> +resources.
> +
> +
> +5.4 Creating buses and endpoints
> +--------------------------------
> +
> +KDBUS_CMD_BUS_MAKE, and KDBUS_CMD_ENDPOINT_MAKE take a

s/,//

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
> +      Make the bus or endpoint file group-accessible
> +
> +    KDBUS_MAKE_ACCESS_WORLD
> +      Make the bus or endpoint file world-accessible
> +
> +  __u64 kernel_flags;
> +    Valid flags for this command, returned by the kernel upon each c=
all.
> +
> +  __u64 return_flags;
> +    Flags returned by the kernel. Currently unused.

And, so presumably always returned as 0?  Best to note that.

> +
> +  struct kdbus_item items[0];
> +    A list of items that has specific meanings for KDBUS_CMD_BUS_MAK=
E

s/has/have/

> +    and KDBUS_CMD_ENDPOINT_MAKE (see above).
> +
> +    Following items are expected for KDBUS_CMD_BUS_MAKE:
> +    KDBUS_ITEM_MAKE_NAME
> +      Contains a string to identify the bus name.

So, up to here, I've seen no definition of 'kdbus_item', which leaves m=
e=20
asking questions like: what subfield is KDBUS_ITEM_MAKE_NAME stored in?
which subfield holds the pointer to the string?

Somewhere earlier,  kdbus_item needs to be exaplained in more detail,=20
I think.

> +
> +    KDBUS_ITEM_BLOOM_PARAMETER
> +      Bus-wide bloom parameters passed in a dbus_bloom_parameter str=
uct
> +
> +    KDBUS_ITEM_ATTACH_FLAGS_RECV
> +      An optional item that contains a set of required attach flags
> +      that connections must allow. This item is used as a negotiatio=
n
> +      measure during connection creation. If connections do not sati=
sfy
> +      the bus requirements, they are not allowed on the bus.
> +      If not set, the bus does not require any metadata to be attach=
ed,

s/,/;/

> +      in this case connections are free to set their own attach flag=
s.
> +
> +    KDBUS_ITEM_ATTACH_FLAGS_SEND
> +      An optional item that contains a set of attach flags that are
> +      returned to connections when they query the bus creator metada=
ta.
> +      If not set, no metadata is returned.
> +
> +    Unrecognized items are rejected, and the ioctl will fail with -E=
INVAL.
> +};
> +
> +
> +6. Connections
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +
> +6.1 Connection IDs and well-known connection names
> +--------------------------------------------------
> +
> +Connections are identified by their connection id, internally implem=
ented as a
> +uint64_t counter. The IDs of every newly created bus start at 1, and=
 every new
> +connection will increment the counter by 1. The ids are not reused.

Again, please change "ids" to IDs" throughout.

> +
> +In higher level tools, the user visible representation of a connecti=
on is
> +defined by the D-Bus protocol specification as ":1.<id>".
> +
> +Messages with a specific uint64_t destination id are directly delive=
red to
> +the connection with the corresponding id. Messages with the special =
destination
> +id KDBUS_DST_ID_BROADCAST are broadcast messages and are potentially=
 delivered
> +to all known connections on the bus; clients interested in broadcast=
 messages
> +need to subscribe to the specific messages they are interested, thou=
gh before
> +any broadcast message reaches them.

The piece following the semicolon would be better as this separate sent=
ence,=20
I think:

    However, in order to receive any broadcast messages, clients must
    to subscribe to the specific messages in which they are interested.

> +
> +Messages synthesized and sent directly by the kernel will carry the =
special
> +source id KDBUS_SRC_ID_KERNEL (0).
> +
> +In addition to the unique uint64_t connection id, established connec=
tions can
> +request the ownership of well-known names, under which they can be f=
ound and
> +addressed by other bus clients. A well-known name is associated with=
 one and
> +only one connection at a time. See section 8 on name acquisition and=
 the
> +name registry, and the validity of names.
> +
> +Messages can specify the special destination id 0 and carry a well-k=
nown name
> +in the message data. Such a message is delivered to the destination =
connection
> +which owns that well-known name.
> +
> +  +-----------------------------------------------------------------=
--------+
> +  | +---------------+     +---------------------------+             =
        |
> +  | | Connection    |     | Message                   | ------------=
-----+  |
> +  | | :1.22         | --> | src: 22                   |             =
     |  |
> +  | |               |     | dst: 25                   |             =
     |  |
> +  | |               |     |                           |             =
     |  |
> +  | |               |     |                           |             =
     |  |
> +  | |               |     +---------------------------+             =
     |  |
> +  | |               |                                               =
     |  |
> +  | |               | <--------------------------------------+      =
     |  |
> +  | +---------------+                                        |      =
     |  |
> +  |                                                          |      =
     |  |
> +  | +---------------+     +---------------------------+      |      =
     |  |
> +  | | Connection    |     | Message                   | -----+      =
     |  |
> +  | | :1.25         | --> | src: 25                   |             =
     |  |
> +  | |               |     | dst: 0xffffffffffffffff   | ------------=
-+   |  |
> +  | |               |     |  (KDBUS_DST_ID_BROADCAST) |             =
 |   |  |
> +  | |               |     |                           | ---------+  =
 |   |  |
> +  | |               |     +---------------------------+          |  =
 |   |  |
> +  | |               |                                            |  =
 |   |  |
> +  | |               | <---------------------------------------------=
-----+  |
> +  | +---------------+                                            |  =
 |      |
> +  |                                                              |  =
 |      |
> +  | +---------------+     +---------------------------+          |  =
 |      |
> +  | | Connection    |     | Message                   | --+      |  =
 |      |
> +  | | :1.55         | --> | src: 55                   |   |      |  =
 |      |
> +  | |               |     | dst: 0 / org.foo.bar      |   |      |  =
 |      |
> +  | |               |     |                           |   |      |  =
 |      |
> +  | |               |     |                           |   |      |  =
 |      |
> +  | |               |     +---------------------------+   |      |  =
 |      |
> +  | |               |                                     |      |  =
 |      |
> +  | |               | <------------------------------------------+  =
 |      |
> +  | +---------------+                                     |         =
 |      |
> +  |                                                       |         =
 |      |
> +  | +---------------+                                     |         =
 |      |
> +  | | Connection    |                                     |         =
 |      |
> +  | | :1.81         |                                     |         =
 |      |
> +  | | org.foo.bar   |                                     |         =
 |      |
> +  | |               |                                     |         =
 |      |
> +  | |               |                                     |         =
 |      |
> +  | |               | <-----------------------------------+         =
 |      |
> +  | |               |                                               =
 |      |
> +  | |               | <---------------------------------------------=
-+      |
> +  | +---------------+                                               =
        |
> +  +-----------------------------------------------------------------=
--------+
> +
> +
> +6.2 Creating connections
> +------------------------
> +
> +A connection to a bus is created by opening an endpoint file of a bu=
s and
> +becoming an active client with the KDBUS_CMD_HELLO ioctl. Every conn=
ected client
> +connection has a unique identifier on the bus and can address messag=
es to every
> +other connection on the same bus by using the peer's connection id a=
s the
> +destination.
> +
> +The KDBUS_CMD_HELLO ioctl takes the following struct as argument.
> +
> +struct kdbus_cmd_hello {
> +  __u64 size;
> +    The overall size of the struct, including all attached items.
> +
> +  __u64 flags;
> +    Flags to apply to this connection:
> +
> +    KDBUS_HELLO_ACCEPT_FD
> +      When this flag is set, the connection can be sent file descrip=
tors
> +      as message payload. If it's not set, any attempt of doing so w=
ill

s/any attempt of doing so/an attempt to send file descriptors/

> +      result in -ECOMM on the sender's side.
> +
> +    KDBUS_HELLO_ACTIVATOR
> +      Make this connection an activator (see below). With this bit s=
et,
> +      an item of type KDBUS_ITEM_NAME has to be attached which descr=
ibes

s/attached which describes/attached. This item describes/

> +      the well-known name this connection should be an activator for=
=2E
> +
> +    KDBUS_HELLO_POLICY_HOLDER
> +      Make this connection a policy holder (see below). With this bi=
t set,
> +      an item of type KDBUS_ITEM_NAME has to be attached which descr=
ibes

s/attached which describes/attached. This item describes/

> +      the well-known name this connection should hold a policy for.
> +
> +    KDBUS_HELLO_MONITOR
> +      Make this connection an eaves-dropping connection. See section=
 6.8 for

s/eaves-dropping/eavesdropping/

> +      more information.
> +
> +To also receive broadcast messages,
   ^
Indentation error.

> +      the connection has to upload appropriate matches as well.
> +      This flag is only valid for privileged bus connections.
> +
> +  __u64 kernel_flags;
> +    Valid flags for this command, returned by the kernel upon each c=
all.
> +
> +  __u64 return_flags;
> +    Flags returned by the kernel. Currently unused.

And, so presumably always returned as 0?  Best to note that.

> +
> +  __u64 attach_flags_send;
> +      Set the bits for metadata this connection permits to be sent t=
o the
> +      receiving peer. Only metadata items that are both allowed to b=
e sent by
> +      the sender and that are requested by the receiver will effecti=
vely be
> +      attached to the message eventually. Note, however, that the bu=
s may

What does "eventually" mean here?

> +      optionally enforce some of those bits to be set. If the match =
fails,

s/enforce/require/ ?

> +      -ECONNREFUSED will be returned. In either case, this field wil=
l be set
> +      to the mask of metadata items that are enforced by the bus. Th=
e
> +      KDBUS_FLAGS_KERNEL bit will as well be set.
> +
> +  __u64 attach_flags_recv;
> +      Request the attachment of metadata for each message received b=
y this
> +      connection. The metadata actually attached may actually augmen=
t the list

Seems like two "actually" in the previous line is one too many.

> +      of requested items. See section 13 for more details.
> +
> +  __u64 bus_flags;
> +      Upon successful completion of the ioctl, this member will cont=
ain the
> +      flags of the bus it connected to.
> +
> +  __u64 id;
> +      Upon successful completion of the ioctl, this member will cont=
ain the
> +      id of the new connection.
> +
> +  __u64 pool_size;
> +      The size of the communication pool, in bytes. The pool can be =
accessed
> +      by calling mmap() on the file descriptor that was used to issu=
e the
> +      KDBUS_CMD_HELLO ioctl.
> +
> +  __u64 offset;
> +      The kernel will return the offset in the pool where returned d=
etails
> +      will be stored.
> +
> +  __u8 id128[16];
> +      Upon successful completion of the ioctl, this member will cont=
ain the
> +      128 bit wide UUID of the connected bus.

s/128 bit wide/128-bit/

> +
> +  struct kdbus_item items[0];
> +      Variable list of items to add optional additional information.=
 The

s/to add optional additional/containing optional additional/

> +      following items are currently expected/valid:
> +
> +      KDBUS_ITEM_CONN_DESCRIPTION
> +        Contains a string to describes this connection's name, so it=
 can be

s/to/that/

> +        identified later.
> +
> +      KDBUS_ITEM_NAME
> +      KDBUS_ITEM_POLICY_ACCESS
> +        For activators and policy holders only, combinations of thes=
e two
> +        items describe policy access entries (see section about poli=
cy).
> +
> +      KDBUS_ITEM_CREDS
> +      KDBUS_ITEM_PIDS
> +      KDBUS_ITEM_SECLABEL
> +        Privileged bus users may submit these types in order to crea=
te
> +        connections with faked credentials. This information will be=
 returned
> +        when peer information is queried by KDBUS_CMD_CONN_INFO. See=
 section
> +        13 for more information.
> +
> +      Items of other types are rejected, and the ioctl will fail wit=
h -EINVAL.
> +};
> +
> +At the offset returned in the 'offset' field of struct kdbus_cmd_hel=
lo, the
> +kernel will store items of the following types:
> +
> +  KDBUS_ITEM_BLOOM_PARAMETER
> +      Bloom filter parameter as defined by the bus creator (see belo=
w).
> +
> +The offset in the pool has to be freed with the KDBUS_CMD_FREE ioctl=
=2E

As far as I can tell, KDBUS_CMD_FREE detailed anywhere in this file. It
needs a detailed description soemwhere.

> +
> +6.3 Activator and policy holder connection
> +------------------------------------------
> +
> +An activator connection is a placeholder for a well-known name. Mess=
ages sent
> +to such a connection can be used by userspace to start an implemente=
r
> +connection, which will then get all the messages from the activator =
copied
> +over. An activator connection cannot be used to send any message.
> +
> +A policy holder connection only installs a policy for one or more na=
mes.
> +These policy entries are kept active as long as the connection is al=
ive, and
> +are removed once it terminates. Such a policy connection type can be=
 used to
> +deploy restrictions for names that are not yet active on the bus. A =
policy
> +holder connection cannot be used to send any message.
> +
> +The creation of activator, policy holder or monitor connections is a=
n operation

What is a "monitor connection"? That term springs up unannounced. Is it
an "eavesdropping connection" as described above? Either define the ter=
m
"monitor connection" or use consistent terminology. (Actually, further =
down
in the document, it is clarified that "monitor connection" =3D=3D "eave=
sdropper".
But that is not clear at THIS point in the document. It needs to be cle=
arer.)

> +restricted to privileged users on the bus (see section "Terminology"=
).
> +
> +
> +6.4 Retrieving information on a connection
> +------------------------------------------
> +
> +The KDBUS_CMD_CONN_INFO ioctl can be used to retrieve credentials an=
d
> +properties of the initial creator of a connection. This ioctl uses t=
he
> +following struct:
> +
> +struct kdbus_cmd_info {
> +  __u64 size;
> +    The overall size of the struct, including the name with its 0-by=
te string
> +    terminator.

"0-byte string terminator" reads strangely. I assume you mean "terminat=
ing=20
null byte" / "null-terminated string" Best to use those more standard t=
erms.

So, maybe:

    including the name with its terminating null byte

or:

    including the null-terminated 'name' string
   =20

There are multiple other instances of 0-byte in the doc, and I think th=
ey=20
should also be fixed in a similar fashion.

> +
> +  __u64 flags;
> +    Specify which metadata items should be attached to the answer.

s/Specify/Specifies/

> +    See section 13 for more details.
> +
> +  __u64 kernel_flags;
> +    Valid flags for this command, returned by the kernel upon each c=
all.
> +
> +  __u64 return_flags;
> +    Flags returned by the kernel. Currently unused.

And, so presumably always returned as 0?  Best to note that.

> +
> +  __u64 id;
> +    The connection's numerical ID to retrieve information for. If se=
t to

Hard to parse sentence.

=3D=3D> The numerical ID of the connection for which information is to=20
    be retrieved.

> +    non-zero value, the 'name' field is ignored.

s/non-zero value/a non-zero value/

> +
> +  __u64 offset;
> +    When the ioctl returns, this value will yield the offset of the =
connection

s/value will yield/field will contain/

> +    information inside the caller's pool.
> +
> +  __u64 info_size;
> +    The kernel will return the size of the returned information, so =
applications
> +    can optionally mmap specific parts of the pool.
> +
> +  struct kdbus_item items[0];
> +    The optional item list, containing the well-known name to look u=
p as
> +    a KDBUS_ITEM_OWNED_NAME. Only required if the 'id' field is set =
to 0.
> +    Items of other types are rejected, and the ioctl will fail with =
-EINVAL.
> +};
> +
> +After the ioctl returns, the following struct will be stored in the =
caller's
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
> +  struct kdbus_item items[0];
> +    Depending on the 'flags' field in struct kdbus_cmd_info, items o=
f
> +    types KDBUS_ITEM_OWNED_NAME and KDBUS_ITEM_CONN_DESCRIPTION are =
followed

s/are followed/follow/

> +    here.
> +};
> +
> +Once the caller is finished with parsing the return buffer, it needs=
 to call
> +KDBUS_CMD_FREE for the offset.
> +
> +
> +6.5 Getting information about a connection's bus creator
> +--------------------------------------------------------
> +
> +The KDBUS_CMD_BUS_CREATOR_INFO ioctl takes the same struct as
> +KDBUS_CMD_CONN_INFO but is used to retrieve information about the cr=
eator of
> +the bus the connection is attached to. The metadata returned by this=
 call is
> +collected during the creation of the bus and is never altered afterw=
ards, so
> +it provides pristine information on the task that created the bus, a=
t the
> +moment when it did so.
> +
> +In response to this call, a slice in the connection's pool is alloca=
ted and
> +filled with an object of type struct kdbus_info, pointed to by the i=
octl's
> +'offset' field.
> +
> +struct kdbus_info {
> +  __u64 size;
> +    The overall size of the struct, including all its items.
> +
> +  __u64 id;
> +    The bus ID
> +
> +  __u64 flags;
> +    The bus flags as specified when it was created.

s/it/the bus/

> +
> +  __u64 kernel_flags;
> +    Valid flags for this command, returned by the kernel upon each c=
all.
> +
> +  struct kdbus_item items[0];
> +    Metadata information is stored in items here. The item list cont=
ains
> +    a KDBUS_ITEM_MAKE_NAME item that indicates the bus name of the
> +    calling connection.
> +};
> +
> +Once the caller is finished with parsing the return buffer, it needs=
 to call
> +KDBUS_CMD_FREE for the offset.
> +
> +
> +6.6 Updating connection details
> +-------------------------------
> +
> +Some of a connection's details can be updated with the KDBUS_CMD_CON=
N_UPDATE
> +ioctl, using the file descriptor that was used to create the connect=
ion.
> +The update command uses the following struct.
> +
> +struct kdbus_cmd_update {
> +  __u64 size;
> +    The overall size of the struct, including all its items.
> +
> +  __u64 flags;
> +    Currently no flags are supported. Reserved for future use.

> +  __u64 kernel_flags;
> +    Valid flags for this command, returned by the kernel upon each c=
all.
> +
> +  __u64 return_flags;
> +    Flags returned by the kernel. Currently unused.

And, so presumably always returned as 0?  Best to note that.

> +
> +  struct kdbus_item items[0];
> +    Items to describe the connection details to be updated. The foll=
owing item
> +    types are supported:
> +
> +    KDBUS_ITEM_ATTACH_FLAGS_SEND
> +      Supply a new set of items that this connection permits to be s=
ent along
> +      with messages.
> +
> +    KDBUS_ITEM_ATTACH_FLAGS_RECV
> +      Supply a new set of items to be attached to each message.
> +
> +    KDBUS_ITEM_NAME
> +    KDBUS_ITEM_POLICY_ACCESS
> +      Policy holder connections may supply a new set of policy infor=
mation
> +      with these items. For other connection types, -EOPNOTSUPP is r=
eturned.
> +
> +    Items of other types are rejected, and the ioctl will fail with =
-EINVAL.
> +};
> +
> +
> +6.7 Termination
> +---------------
> +
> +A connection can be terminated by simply closing its file descriptor=
=2E All
> +pending incoming messages will be discarded, and the memory in the p=
ool will
> +be freed.
> +
> +An alternative way of closing down a connection is calling the KDBUS=
_CMD_BYEBYE
> +ioctl on it, which will only succeed if the message queue of the con=
nection is
> +empty at the time of closing, otherwise, -EBUSY is returned.

The preceding is a little hard to parse. I suggest:

    An alternative way of closing down a connection is via the KDBUS_CM=
D_BYEBYE
    ioctl. This ioctly will succeed only if the message queue of the co=
nnection is
    empty at the time of closing; otherwise, -EBUSY is returned.

> +
> +When this ioctl returns successfully, the connection has been termin=
ated and
> +won't accept any new messages from remote peers. This way, a connect=
ion can
> +be terminated race-free, without losing any messages.
> +
> +
> +6.8 Monitor connections ('eavesdropper')
> +----------------------------------------
> +
> +Eavesdropping connections are created by setting the KDBUS_HELLO_MON=
ITOR flag
> +in struct kdbus_hello.flags. Such connections have all properties of=
 any other,
> +regular connection, except for the following details:
> +
> +  * They will get every message sent over the bus, both unicasts and=
 broadcasts
> +
> +  * Installing matches for broadcast messages is neither necessary n=
or allowed
> +
> +  * They cannot send messages or be directly addressed as receiver
> +
> +  * Their creation and destruction will not cause KDBUS_ITEM_ID_{ADD=
,REMOVE}
> +    notifications to be generated, so other connections cannot detec=
t the
> +    presence of an eavesdropper.
> +
> +
> +7. Messages
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +Messages consist of a fixed-size header followed directly by a list =
of
> +variable-sized data 'items'. The overall message size is specified i=
n the
> +header of the message. The chain of data items can contain well-defi=
ned
> +message metadata fields, raw data, references to data, or file descr=
iptors.
> +
> +
> +7.1 Sending messages
> +--------------------
> +
> +Messages are passed to the kernel with the KDBUS_CMD_SEND ioctl. Dep=
ending
> +on the destination address of the message, the kernel delivers the m=
essage to
> +the specific destination connection or to all connections on the sam=
e bus.
> +Sending messages across buses is not possible. Messages are always q=
ueued in
> +the memory pool of the destination connection (see below).
> +
> +The KDBUS_CMD_SEND ioctl uses struct kdbus_cmd_send to describe the =
message
> +transfer.
> +
> +struct kdbus_cmd_send {
> +  __u64 size;
> +    The overall size of the struct, including the attached items.
> +
> +  __u64 flags;
> +    Flags for message delivery:
> +
> +    KDBUS_SEND_SYNC_REPLY
> +      By default, all calls to kdbus are considered asynchronous,
> +      non-blocking. However, as there are many use cases that need t=
o wait
> +      for a remote peer to answer a method call, there's a way to se=
nd a
> +      message and wait for a reply in a synchronous fashion. This is=
 what
> +      the KDBUS_MSG_SYNC_REPLY controls. The KDBUS_CMD_SEND ioctl wi=
ll block
> +      until the reply has arrived, the timeout limit is reached, in =
case the
> +      remote connection was shut down, or if interrupted by a signal=
 before
> +      any reply; see signal(7).
> +
> +      The offset of the reply message in the sender's pool is stored=
 in in
> +      'offset_reply' when the ioctl has returned without error. Henc=
e, there
> +      is no need for another KDBUS_CMD_RECV ioctl or anything else t=
o receive
> +      the reply.
> +
> +  __u64 kernel_flags;
> +    Valid flags for this command, returned by the kernel upon each c=
all of
> +    KDBUS_CMD_SEND.
> +
> +  __u64 kernel_msg_flags;
> +    Valid bits for message flags, returned by the kernel upon each c=
all of
> +    KDBUS_CMD_SEND.
> +
> +  __u64 return_flags;
> +    Kernel-provided flags, returning non-fatal errors that occurred =
during
> +    send. Currently unused.

And, so presumably always returned as 0?  Best to note that.

> +
> +  __u64 msg_address;
> +    Userspace has to provide a pointer to a message (struct kdbus_ms=
g) to send.
> +
> +  struct kdbus_msg_info reply;
> +    Only used for synchronous replies. See description of struct kdb=
us_cmd_recv
> +    for more details.
> +
> +  struct kdbus_item items[0];
> +    The following items are currently recognized:
> +
> +    KDBUS_ITEM_CANCEL_FD
> +      When this optional item is passed in, and the call is executed=
 as SYNC
> +      call, the passed in file descriptor can be used as alternative
> +      cancellation point. The kernel will call poll() on this file d=
escriptor,
> +      and if it reports any incoming bytes, the blocking send operat=
ion will
> +      be canceled, and the call will return -ECANCELED. Any type of =
file
> +      descriptor that implements poll() can be used as payload to th=
is item.
> +      For asynchronous message sending, this item is accepted but ig=
nored.
> +
> +    All other items are rejected, and the ioctl will fail with -EINV=
AL.
> +};
> +
> +The message referenced by 'msg_address' above has the following layo=
ut.
> +
> +struct kdbus_msg {
> +  __u64 size;
> +    The overall size of the struct, including the attached items.
> +
> +  __u64 flags;
> +    KDBUS_MSG_EXPECT_REPLY
> +      Expect a reply from the remote peer to this message. With this=
 bit set,

s/from the remote peer to this message/to this message from the remote =
peer/

> +      the timeout_ns field must be set to a non-zero number of nanos=
econds in
> +      which the receiving peer is expected to reply. If such a reply=
 is not
> +      received in time, the sender will be notified with a timeout m=
essage
> +      (see below). The value must be an absolute value, in nanosecon=
ds and
> +      based on CLOCK_MONOTONIC.

Why is the option of a relative timeout not available?

> +      For a message to be accepted as reply, it must be a direct mes=
sage to
> +      the original sender (not a broadcast), and its kdbus_msg.reply=
_cookie
> +      must match the previous message's kdbus_msg.cookie.
> +
> +      Expected replies also temporarily open the policy of the sendi=
ng
> +      connection, so the other peer is allowed to respond within the=
 given
> +      time window.
> +
> +    KDBUS_MSG_NO_AUTO_START
> +      By default, when a message is sent to an activator connection,=
 the
> +      activator notified and will start an implementer. This flag in=
hibits
> +      that behavior. With this bit set, and the remote being an acti=
vator,
> +      -EADDRNOTAVAIL is returned from the ioctl.
> +
> +  __s64 priority;
> +    The priority of this message. Receiving messages (see below) may
> +    optionally be constrained to messages of a minimal priority. Thi=
s
> +    allows for use cases where timing critical data is interleaved w=
ith
> +    control data on the same connection. If unused, the priority sho=
uld be
> +    set to zero.
> +
> +  __u64 dst_id;
> +    The numeric ID of the destination connection, or KDBUS_DST_ID_BR=
OADCAST
> +    (~0ULL) to address every peer on the bus, or KDBUS_DST_ID_NAME (=
0) to look
> +    it up dynamically from the bus' name registry. In the latter cas=
e, an item
> +    of type KDBUS_ITEM_DST_NAME is mandatory.
> +
> +  __u64 src_id;
> +    Upon return of the ioctl, this member will contain the sending
> +    connection's numerical ID. Should be 0 at send time.
> +
> +  __u64 payload_type;
> +    Type of the payload in the actual data records. Currently, only
> +    KDBUS_PAYLOAD_DBUS is accepted as input value of this field. Whe=
n
> +    receiving messages that are generated by the kernel (notificatio=
ns),
> +    this field will yield KDBUS_PAYLOAD_KERNEL.

s/yield/cointain/ ?

> +
> +  __u64 cookie;
> +    Cookie of this message, for later recognition. Also, when replyi=
ng
> +    to a message (see above), the cookie_reply field must match this=
 value.
> +
> +  __u64 timeout_ns;
> +    If the message sent requires a reply from the remote peer (see a=
bove),
> +    this field contains the timeout in absolute nanoseconds based on
> +    CLOCK_MONOTONIC.
> +
> +  __u64 cookie_reply;
> +    If the message sent is a reply to another message, this field mu=
st
> +    match the cookie of the formerly received message.
> +
> +  struct kdbus_item items[0];
> +    A dynamically sized list of items to contain additional informat=
ion.
> +    The following items are expected/valid:
> +
> +    KDBUS_ITEM_PAYLOAD_VEC
> +    KDBUS_ITEM_PAYLOAD_MEMFD
> +    KDBUS_ITEM_FDS
> +      Actual data records containing the payload. See section "Passi=
ng of
> +      Payload Data".
> +
> +    KDBUS_ITEM_BLOOM_FILTER
> +      Bloom filter for matches (see below).
> +
> +    KDBUS_ITEM_DST_NAME
> +      Well-known name to send this message to. Required if dst_id is=
 set
> +      to KDBUS_DST_ID_NAME. If a connection holding the given name c=
an't
> +      be found, -ESRCH is returned.
> +      For messages to a unique name (ID), this item is optional. If =
present,
> +      the kernel will make sure the name owner matches the given uni=
que name.
> +      This allows userspace tie the message sending to the condition=
 that a
> +      name is currently owned by a certain unique name.
> +};
> +
> +The message will be augmented by the requested metadata items when q=
ueued into
> +the receiver's pool. See also section 13.2 ("Metadata and namespaces=
").
> +
> +
> +7.2 Message layout
> +------------------
> +
> +The layout of a message is shown below.
> +
> +  +-----------------------------------------------------------------=
--------+
> +  | Message                                                         =
        |
> +  | +---------------------------------------------------------------=
------+ |
> +  | | Header                                                        =
      | |
> +  | | size:          overall message size, including the data record=
s     | |
> +  | | destination:   connection id of the receiver                  =
      | |
> +  | | source:        connection id of the sender (set by kernel)    =
      | |
> +  | | payload_type:  "DBusDBus" textual identifier stored as uint64_=
t     | |
> +  | +---------------------------------------------------------------=
------+ |
> +  | +---------------------------------------------------------------=
------+ |
> +  | | Data Record                                                   =
      | |
> +  | | size:  overall record size (without padding)                  =
      | |
> +  | | type:  type of data                                           =
      | |
> +  | | data:  reference to data (address or file descriptor)         =
      | |
> +  | +---------------------------------------------------------------=
------+ |
> +  | +---------------------------------------------------------------=
------+ |
> +  | | padding bytes to the next 8 byte alignment                    =
      | |
> +  | +---------------------------------------------------------------=
------+ |
> +  | +---------------------------------------------------------------=
------+ |
> +  | | Data Record                                                   =
      | |
> +  | | size:  overall record size (without padding)                  =
      | |
> +  | | ...                                                           =
      | |
> +  | +---------------------------------------------------------------=
------+ |
> +  | +---------------------------------------------------------------=
------+ |
> +  | | padding bytes to the next 8 byte alignment                    =
      | |
> +  | +---------------------------------------------------------------=
------+ |
> +  | +---------------------------------------------------------------=
------+ |
> +  | | Data Record                                                   =
      | |
> +  | | size:  overall record size                                    =
      | |
> +  | | ...                                                           =
      | |
> +  | +---------------------------------------------------------------=
------+ |
> +  |   ... further data records ...                                  =
        |
> +  +-----------------------------------------------------------------=
--------+
> +
> +
> +7.3 Passing of Payload Data
> +---------------------------
> +
> +When connecting to the bus, receivers request a memory pool of a giv=
en size,
> +large enough to carry all backlog of data enqueued for the connectio=
n. The
> +pool is internally backed by a shared memory file which can be mmap(=
)ed by
> +the receiver.
> +
> +KDBUS_MSG_PAYLOAD_VEC:
> +  Messages are directly copied by the sending process into the recei=
ver's pool,

s/,/./ and then start a new sentence.

> +  that way two peers can exchange data by effectively doing a single=
-copy from
> +  one process to another, the kernel will not buffer the data anywhe=
re else.
s/,/;/

> +
> +KDBUS_MSG_PAYLOAD_MEMFD:
> +  Messages can reference memfd files which contain the data.
> +  memfd files are tmpfs-backed files that allow sealing of the conte=
nt of the
> +  file, which prevents all writable access to the file content.
> +  Only memfds that have (F_SEAL_SHRINK|F_SEAL_GROW|F_SEAL_WRITE|F_SE=
AL_SEAL) set
> +  are accepted as payload data, which enforces reliable passing of d=
ata.
> +  The receiver can assume that neither the sender nor anyone else ca=
n alter the
> +  content after the message is sent.
> +  Apart from the sender filling-in the content into memfd files, the=
 data will
> +  be passed as zero-copy from one process to another, read-only, sha=
red between
> +  the peers.
> +
> +The sender must not make any assumptions on the type how data is rec=
eived by the

Wording error at "the type how". Some fix is needed.

> +remote peer. The kernel is free to re-pack multiple VEC and MEMFD pa=
yloads. For
> +instance, the kernel may decide to merge multiple VECs into a single=
 VEC, inline
> +MEMFD payloads into memory or merge all passed VECs into a single ME=
MFD.
> +However, the kernel preserves the order of passed data. This means, =
the order of

s/,//

> +all VEC and MEMFD items is not changed in respect to each other.

s/in/with/

> +
> +In other words: All passed VEC and MEMFD data payloads are treated a=
s a single
> +stream of data that may be received by the remote peer in a differen=
t set of
> +hunks than it was sent as.
> +
> +
> +7.4 Receiving messages
> +----------------------
> +
> +Messages are received by the client with the KDBUS_CMD_RECV ioctl. T=
he endpoint
> +file of the bus supports poll() to wake up the receiving process whe=
n new

s%poll()%poll/select()/epoll%  ?

> +messages are queued up to be received.
> +
> +With the KDBUS_CMD_RECV ioctl, a struct kdbus_cmd_recv is used.
> +
> +struct kdbus_cmd_recv {
> +  __u64 size;
> +    The overall size of the struct, including the attached items.
> +
> +  __u64 flags;
> +    Flags to control the receive command.
> +
> +    KDBUS_RECV_PEEK
> +      Just return the location of the next message. Do not install f=
ile
> +      descriptors or anything else. This is usually used to determin=
e the
> +      sender of the next queued message.
> +
> +    KDBUS_RECV_DROP
> +      Drop the next message without doing anything else with it, and=
 free the
> +      pool slice. This a short-cut for KDBUS_RECV_PEEK and KDBUS_CMD=
_FREE.
> +
> +    KDBUS_RECV_USE_PRIORITY
> +      Use the priority field (see below).
> +
> +  __u64 kernel_flags;
> +    Valid flags for this command, returned by the kernel upon each c=
all.
> +
> +  __u64 return_flags;
> +    Kernel-provided flags, returning non-fatal errors that occurred =
during
> +    send. Currently unused.

And, so presumably always returned as 0?  Best to note that.

> +
> +  __s64 priority;
> +    With KDBUS_RECV_USE_PRIORITY set in flags, receive the next mess=
age in
> +    the queue with at least the given priority. If no such message i=
s waiting
> +    in the queue, -ENOMSG is returned.

###
How do I simply select the highest priority message, without knowing wh=
at=20
its priority is?

> +
> +  __u64 dropped_msgs;
> +    If the CMD_RECV ioctl fails with EOVERFLOW, this field is filled=
 by
> +    the kernel with the number of messages that couldn't be transmit=
ted to
> +    this connection. In that case, the @offset member must not be ac=
cessed.
> +
> +  struct kdbus_msg_info msg;
> +   Embedded struct to be filled when the command succeeded (see belo=
w).
> +
> +  struct kdbus_item items[0];
> +    Items to specify further details for the receive command. Curren=
tly unused.
> +};
> +
> +Both 'struct kdbus_cmd_recv' and 'struct kdbus_cmd_send' embed 'stru=
ct
> +kdbus_msg_info'. For the SEND ioctl, it is used to catch synchronous=
 replies,
> +if one was requested, and is unused otherwise.
> +
> +struct kdbus_msg_info {
> +  __u64 offset;
> +    Upon return of the ioctl, this field contains the offset in the =
receiver's
> +    memory pool. The memory must be freed with KDBUS_CMD_FREE.
> +
> +  __u64 msg_size;
> +    Upon successful return of the ioctl, this field contains the siz=
e of the
> +    allocated slice at offset @offset. It is the combination of the =
size of
> +    the stored kdbus_msg object plus all appended VECs. You can use =
it in
> +    combination with @offset to map a single message, instead of map=
ping the
> +    whole pool.
> +
> +  __u64 return_flags;
> +    Kernel-provided return flags. Currently, the following flags are=
 defined.
> +
> +      KDBUS_RECV_RETURN_INCOMPLETE_FDS
> +        The message contained file descriptors which couldn't be ins=
talled
> +        into the receiver's task. Most probably that happened becaus=
e the
> +        maximum number of file descriptors for that task were exceed=
ed.
> +        The message is still delivered, so this is not a fatal condi=
tion.
> +        File descriptors inside the KDBUS_ITEM_FDS item that could n=
ot be
> +        installed will be set to -1.
> +};
> +
> +Unless KDBUS_RECV_DROP was passed, and given that the ioctl succeede=
d, the

s/and given that the ioctl succeeded/after a successful KDBUS_CMD_RECV =
ioctl/

> +offset field contains the location of the new message inside the rec=
eiver's
> +pool. The message is stored as struct kdbus_msg at this offset, and =
can be
> +interpreted with the semantics described above.
> +
> +Also, if the connection allowed for file descriptor to be passed
> +(KDBUS_HELLO_ACCEPT_FD), and if the message contained any, they will=
 be
> +installed into the receiving process after the KDBUS_CMD_RECV ioctl =
returns.

###
"after"??? When exactly?

> +The receiving task is obliged to close all of them appropriately. If
> +KDBUS_RECV_PEEK is set, no file descriptors are installed. This allo=
ws for
> +peeking at a message and dropping it via KDBUS_RECV_DROP, without in=
stalling
> +the passed file descriptors into the receiving process.
> +
> +The caller is obliged to call KDBUS_CMD_FREE with the returned offse=
t when
> +the memory is no longer needed.
> +
> +
> +8. Name registry
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +Each bus instantiates a name registry to resolve well-known names in=
to unique
> +connection IDs for message delivery. The registry will be queried wh=
en a
> +message is sent with kdbus_msg.dst_id set to KDBUS_DST_ID_NAME, or w=
hen a
> +registry dump is requested.
> +
> +All of the below is subject to policy rules for SEE and OWN permissi=
ons.
> +
> +
> +8.1 Name validity
> +-----------------
> +
> +A name has to comply to the following rules to be considered valid:

s/comply to/comply with/

> +
> + - The name has two or more elements separated by a period ('.') cha=
racter
> + - All elements must contain at least one character
> + - Each element must only contain the ASCII characters "[A-Z][a-z][0=
-9]_"
> +   and must not begin with a digit
> + - The name must contain at least one '.' (period) character
> +   (and thus at least two elements)
> + - The name must not begin with a '.' (period) character
> + - The name must not exceed KDBUS_NAME_MAX_LEN (255)
> +
> +
> +8.2 Acquiring a name
> +--------------------
> +
> +To acquire a name, a client uses the KDBUS_CMD_NAME_ACQUIRE ioctl wi=
th the
> +following data structure.
> +
> +struct kdbus_cmd_name {
> +  __u64 size;
> +    The overall size of this struct, including the name with its 0-b=
yte string
> +    terminator.
> +
> +  __u64 flags;
> +    Flags to control details in the name acquisition.
> +
> +    KDBUS_NAME_REPLACE_EXISTING
> +      Acquiring a name that is already present usually fails, unless=
 this flag
> +      is set in the call, and KDBUS_NAME_ALLOW_REPLACEMENT or (see b=
elow) was
> +      set when the current owner of the name acquired it, or if the =
current
> +      owner is an activator connection (see below).
> +
> +    KDBUS_NAME_ALLOW_REPLACEMENT
> +      Allow other connections to take over this name. When this happ=
ens, the
> +      former owner of the connection will be notified of the name lo=
ss.
> +
> +    KDBUS_NAME_QUEUE (acquire)
> +      A name that is already acquired by a connection, and which was=
n't
> +      requested with the KDBUS_NAME_ALLOW_REPLACEMENT flag set can n=
ot be
> +      acquired again. However, a connection can put itself in a queu=
e of
> +      connections waiting for the name to be released. Once that hap=
pens, the
> +      first connection in that queue becomes the new owner and is no=
tified
> +      accordingly.
> +
> +  __u64 kernel_flags;
> +    Valid flags for this command, returned by the kernel upon each c=
all.
> +
> +  __u64 return_flags;
> +    Flags returned by the kernel. Currently unused.

And, so presumably always returned as 0?  Best to note that.

> +
> +  struct kdbus_item items[0];
> +    Items to submit the name. Currently, one item of type KDBUS_ITEM=
_NAME is
> +    expected and allowed, and the contained string must be a valid b=
us name.
> +    Items of other types are rejected, and the ioctl will fail with =
-EINVAL.
> +};
> +
> +
> +8.3 Releasing a name
> +--------------------
> +
> +A connection may release a name explicitly with the KDBUS_CMD_NAME_R=
ELEASE
> +ioctl. If the connection was an implementer of an activatable name, =
its
> +pending messages are moved back to the activator. If there are any c=
onnections
> +queued up as waiters for the name, the oldest one of them will becom=
e the new
> +owner. The same happens implicitly for all names once a connection t=
erminates.
> +
> +The KDBUS_CMD_NAME_RELEASE ioctl uses the same data structure as the
> +acquisition call, but with slightly different field usage.
> +
> +struct kdbus_cmd_name {
> +  __u64 size;
> +    The overall size of this struct, including the name with its 0-b=
yte string
> +    terminator.
> +
> +  __u64 flags;
> +    Flags to the command. Currently unused.

And, so presumably must be 0?  Best to note that.

> +
> +  __u64 kernel_flags;
> +    Valid flags for this command, returned by the kernel upon each c=
all.
> +
> +  __u64 return_flags;
> +    Flags returned by the kernel. Currently unused.

And, so presumably always returned as 0?  Best to note that.

> +  struct kdbus_item items[0];
> +    Items to submit the name. Currently, one item of type KDBUS_ITEM=
_NAME is
> +    expected and allowed, and the contained string must be a valid b=
us name.
> +};
> +
> +
> +8.4 Dumping the name registry
> +-----------------------------
> +
> +A connection may request a complete or filtered dump of currently ac=
tive bus
> +names with the KDBUS_CMD_NAME_LIST ioctl, which takes a struct
> +kdbus_cmd_name_list as argument.
> +
> +struct kdbus_cmd_name_list {
> +  __u64 flags;
> +    Any combination of flags to specify which names should be dumped=
=2E
> +
> +    KDBUS_NAME_LIST_UNIQUE
> +      List the unique (numeric) IDs of the connection, whether it ow=
ns a name
> +      or not.
> +
> +    KDBUS_NAME_LIST_NAMES
> +      List well-known names stored in the database which are activel=
y owned by
> +      a real connection (not an activator).
> +
> +    KDBUS_NAME_LIST_ACTIVATORS
> +      List names that are owned by an activator.
> +
> +    KDBUS_NAME_LIST_QUEUED
> +      List connections that are not yet owning a name but are waitin=
g for it
> +      to become available.
> +
> +  __u64 kernel_flags;
> +    Valid flags for this command, returned by the kernel upon each c=
all.
> +
> +  __u64 return_flags;
> +    Flags returned by the kernel. Currently unused.

And, so presumably always returned as 0?  Best to note that.

> +
> +  __u64 offset;
> +    When the ioctl returns successfully, the offset to the name regi=
stry dump
> +    inside the connection's pool will be stored in this field.
> +};
> +
> +The returned list of names is stored in a struct kdbus_name_list tha=
t in turn
> +contains a dynamic number of struct kdbus_cmd_name that carry the ac=
tual
> +information. The fields inside that struct kdbus_cmd_name is describ=
ed next.
> +
> +struct kdbus_name_info {
> +  __u64 size;
> +    The overall size of this struct, including the name with its 0-b=
yte string
> +    terminator.
> +
> +  __u64 owner_id;
> +    The owning connection's unique ID.
> +
> +  __u64 conn_flags;
> +    The flags of the owning connection.
> +
> +  struct kdbus_item items[0];
> +    Items containing the actual name. Currently, one item of type
> +    KDBUS_ITEM_OWNED_NAME will be attached, including the name's fla=
gs. In that
> +    item, the flags field of the name may carry the following bits:
> +
> +    KDBUS_NAME_ALLOW_REPLACEMENT
> +      Other connections are allowed to take over this name from the
> +      connection that owns it.
> +
> +    KDBUS_NAME_IN_QUEUE (list)
> +      When retrieving a list of currently acquired name in the regis=
try, this
> +      flag indicates whether the connection actually owns the name o=
r is
> +      currently waiting for it to become available.
> +
> +    KDBUS_NAME_ACTIVATOR (list)
> +      An activator connection owns a name as a placeholder for an im=
plementer,
> +      which is started on demand as soon as the first message arrive=
s. There's
> +      some more information on this topic below. In contrast to
> +      KDBUS_NAME_REPLACE_EXISTING, when a name is taken over from an=
 activator
> +      connection, all the messages that have been queued in the acti=
vator
> +      connection will be moved over to the new owner. The activator =
connection
> +      will still be tracked for the name and will take control again=
 if the
> +      implementer connection terminates.
> +      This flag can not be used when acquiring a name, but is implic=
itly set
> +      through KDBUS_CMD_HELLO with KDBUS_HELLO_ACTIVATOR set in
> +      kdbus_cmd_hello.conn_flags.
> +};
> +
> +The returned buffer must be freed with the KDBUS_CMD_FREE ioctl when=
 the user
> +is finished with it.
> +
> +
> +9. Notifications
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +The kernel will notify its users of the following events.
> +
> +  * When connection A is terminated while connection B is waiting fo=
r a reply
> +    from it, connection B is notified with a message with an item of=
 type
> +    KDBUS_ITEM_REPLY_DEAD.
> +
> +  * When connection A does not receive a reply from connection B wit=
hin the
> +    specified timeout window, connection A will receive a message wi=
th an item
> +    of type KDBUS_ITEM_REPLY_TIMEOUT.
> +
> +  * When an ordinary connection (not a monitor) is created on or rem=
oved from
> +    a bus, messages with an item of type KDBUS_ITEM_ID_ADD or
> +    KDBUS_ITEM_ID_REMOVE, respectively, are sent to all bus members =
that match
> +    these messages through their match database. Eavesdroppers (moni=
tor
> +    connections) do not cause such notifications to be sent. They ar=
e invisible
> +    on the bus.
> +
> +  * When a connection gains or loses ownership of a name, messages w=
ith an item
> +    of type KDBUS_ITEM_NAME_ADD, KDBUS_ITEM_NAME_REMOVE or
> +    KDBUS_ITEM_NAME_CHANGE are sent to all bus members that match th=
ese
> +    messages through their match database.
> +
> +A kernel notification is a regular kdbus message with the following =
details.
> +
> +  * kdbus_msg.src_id =3D=3D KDBUS_SRC_ID_KERNEL
> +  * kdbus_msg.dst_id =3D=3D KDBUS_DST_ID_BROADCAST
> +  * kdbus_msg.payload_type =3D=3D KDBUS_PAYLOAD_KERNEL
> +  * Has exactly one of the aforementioned items attached
> +
> +Kernel notifications have an item of type KDBUS_ITEM_TIMESTAMP attac=
hed.
> +
> +
> +10. Message Matching, Bloom filters
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +10.1 Matches for broadcast messages from other connections
> +----------------------------------------------------------
> +
> +A message addressed at the connection ID KDBUS_DST_ID_BROADCAST (~0U=
LL) is a
> +broadcast message, delivered to all connected peers which installed =
a rule to
> +match certain properties of the message. Without any rules installed=
 in the
> +connection, no broadcast message or kernel-side notifications will b=
e delivered
> +to the connection. Broadcast messages are subject to policy rules an=
d TALK
> +access checks.
> +
> +See section 11 for details on policies, and section 11.5 for more
> +details on implicit policies.
> +
> +Matches for messages from other connections (not kernel notification=
s) are
> +implemented as bloom filters. The sender adds certain properties of =
the message
> +as elements to a bloom filter bit field, and sends that along with t=
he
> +broadcast message.
> +
> +The connection adds the message properties it is interested as eleme=
nts to a
> +bloom mask bit field, and uploads the mask to the match rules of the
> +connection.
> +
> +The kernel will match the broadcast message's bloom filter against t=
he
> +connections bloom mask (simply by &-ing it), and decide whether the =
message
> +should be delivered to the connection.
> +
> +The kernel has no notion of any specific properties of the message, =
all it
> +sees are the bit fields of the bloom filter and mask to match agains=
t. The
> +use of bloom filters allows simple and efficient matching, without e=
xposing
> +any message properties or internals to the kernel side. Clients need=
 to deal
> +with the fact that they might receive broadcasts which they did not =
subscribe
> +to, as the bloom filter might allow false-positives to pass the filt=
er.
> +
> +To allow the future extension of the set of elements in the bloom fi=
lter, the
> +filter specifies a "generation" number. A later generation must alwa=
ys contain
> +all elements of the set of the previous generation, but can add new =
elements
> +to the set. The match rules mask can carry an array with all previou=
s
> +generations of masks individually stored. When the filter and mask a=
re matched
> +by the kernel, the mask with the closest matching "generation" is se=
lected
> +as the index into the mask array.
> +
> +
> +10.2 Matches for kernel notifications
> +------------------------------------
> +
> +To receive kernel generated notifications (see section 9), a connect=
ion must
> +install special match rules that are different from the bloom filter=
 matches
> +described in the section above. They can be filtered by a sender con=
nection's
> +ID, by one of the name the sender connection owns at the time of sen=
ding the
> +message, or by type of the notification (id/name add/remove/change).

s/type/the type/

> +
> +10.3 Adding a match
> +-------------------
> +
> +To add a match, the KDBUS_CMD_MATCH_ADD ioctl is used, which takes a=
 struct
> +of the struct described below.
> +
> +Note that each of the items attached to this command will internally=
 create
> +one match 'rule', and the collection of them, which is submitted as =
one block
> +via the ioctl is called a 'match'. To allow a message to pass, all r=
ules of a

s/ioctl/ioctl,/

> +match have to be satisfied. Hence, adding more items to the command =
will only
> +narrow the possibility of a match to effectively let the message pas=
s, and will
> +cause the connection's user space process to wake up less likely.

Make that last line

decrease the chance that the connection's userspace process wil be woke=
n up

> +
> +Multiple matches can be installed per connection. As long as one of =
it has a

s/it/them/ ?
(If that change is not correct, then the sentence is quite confused.)

> +set of rules which allows the message to pass, this one will be deci=
sive.
> +
> +struct kdbus_cmd_match {
> +  __u64 size;
> +    The overall size of the struct, including its items.
> +
> +  __u64 cookie;
> +    A cookie which identifies the match, so it can be referred to at=
 removal
> +    time.
> +
> +  __u64 flags;
> +    Flags to control the behavior of the ioctl.
> +
> +    KDBUS_MATCH_REPLACE:
> +      Remove all entries with the given cookie before installing the=
 new one.
> +      This allows for race-free replacement of matches.
> +
> +  __u64 kernel_flags;
> +    Valid flags for this command, returned by the kernel upon each c=
all.
> +
> +  __u64 return_flags;
> +    Flags returned by the kernel. Currently unused.

And, so presumably always returned as 0?  Best to note that.

> +
> +  struct kdbus_item items[0];
> +    Items to define the actual rules of the matches. The following i=
tem types
> +    are expected. Each item will cause one new match rule to be crea=
ted.
> +
> +    KDBUS_ITEM_BLOOM_MASK
> +      An item that carries the bloom filter mask to match against in=
 its
> +      data field. The payload size must match the bloom filter size =
that
> +      was specified when the bus was created.
> +      See section 10.4 for more information.
> +
> +    KDBUS_ITEM_NAME
> +      Specify a name that a sending connection must own at a time of=
 sending

s/a time/the time/

> +      a broadcast message in order to match this rule.
> +
> +    KDBUS_ITEM_ID
> +      Specify a sender connection's ID that will match this rule.
> +
> +    KDBUS_ITEM_NAME_ADD
> +    KDBUS_ITEM_NAME_REMOVE
> +    KDBUS_ITEM_NAME_CHANGE
> +      These items request delivery of broadcast messages that descri=
be a name
> +      acquisition, loss, or change. The details are stored in the it=
em's
> +      kdbus_notify_name_change member. All information specified mus=
t be
> +      matched in order to make the message pass. Use KDBUS_MATCH_ID_=
ANY to
> +      match against any unique connection ID.
> +
> +    KDBUS_ITEM_ID_ADD
> +    KDBUS_ITEM_ID_REMOVE
> +      These items request delivery of broadcast messages that are ge=
nerated
> +      when a connection is created or terminated. struct kdbus_notif=
y_id_change
> +      is used to store the actual match information. This item can b=
e used to
> +      monitor one particular connection ID, or, when the id field is=
 set to
> +      KDBUS_MATCH_ID_ANY, all of them.
> +
> +    Items of other types are rejected, and the ioctl will fail with =
-EINVAL.
> +};
> +
> +
> +10.4 Bloom filters
> +------------------
> +
> +Bloom filters allow checking whether a given word is present in a di=
ctionary.
> +This allows connections to set up a mask for information it is inter=
ested in,
> +and will be delivered signal messages that have a matching filter.
> +
> +For general information on bloom filters, see
> +
> +  https://en.wikipedia.org/wiki/Bloom_filter
> +
> +The size of the bloom filter is defined per bus when it is created, =
in
> +kdbus_bloom_parameter.size. All bloom filters attached to signals on=
 the bus
> +must match this size, and all bloom filter matches uploaded by conne=
ctions must
> +also match the size, or a multiple thereof (see below).
> +
> +The calculation of the mask has to be done on the userspace side. Th=
e kernel
> +just checks the bitmasks to decide whether or not to let the message=
 pass. All
> +bits in the mask must match the filter in and bit-wise AND logic, bu=
t the

Parse error at "in and bit-wise AND logic". I am not sure what you are =
meaning=20
there, buth something needs fixing.

> +mask may have more bits set than the filter. Consequently, false pos=
itive
> +matches are expected to happen, and userspace must deal with that fa=
ct.
> +
> +Masks are entities that are always passed to the kernel as part of a=
 match
> +(with an item of type KDBUS_ITEM_BLOOM_MASK), and filters can be att=
ached to
> +signals, with an item of type KDBUS_ITEM_BLOOM_FILTER.
> +
> +For a filter to match, all its bits have to be set in the match mask=
 as well.
> +For example, consider a bus has a bloom size of 8 bytes, and the fol=
lowing

s/has/that has/

> +mask/filter combinations:
> +
> +    filter  0x0101010101010101
> +    mask    0x0101010101010101
> +            -> matches
> +
> +    filter  0x0303030303030303
> +    mask    0x0101010101010101
> +            -> doesn't match
> +
> +    filter  0x0101010101010101
> +    mask    0x0303030303030303
> +            -> matches
> +
> +Hence, in order to catch all messages, a mask filled with 0xff bytes=
 can be
> +installed as a wildcard match rule.
> +
> +Uploaded matches may contain multiple masks, each of which in the si=
ze of the

Parse error at "each of which in the size of"
s/in/is/?

> +bloom size defined by the bus. Each block of a mask is called a 'gen=
eration',
> +starting at index 0.
> +
> +At match time, when a signal is about to be delivered, a bloom mask =
generation
> +is passed, which denotes which of the bloom masks the filter should =
be matched
> +against. This allows userspace to provide backward compatible masks =
at upload
> +time, while older clients can still match against older versions of =
filters.
> +
> +
> +10.5 Removing a match
> +--------------------
> +
> +Matches can be removed through the KDBUS_CMD_MATCH_REMOVE ioctl, whi=
ch again
> +takes struct kdbus_cmd_match as argument, but its fields are used sl=
ightly
> +differently.
> +
> +struct kdbus_cmd_match {
> +  __u64 size;
> +    The overall size of the struct. As it has no items in this use c=
ase, the
> +    value should yield 16.

s/yield/contain/ ?
> +
> +  __u64 cookie;
> +    The cookie of the match, as it was passed when the match was add=
ed.
> +    All matches that have this cookie will be removed.
> +
> +  __u64 flags;
> +    Unused for this use case,
> +
> +  __u64 kernel_flags;
> +    Valid flags for this command, returned by the kernel upon each c=
all.
> +
> +  __u64 return_flags;
> +    Flags returned by the kernel. Currently unused.

And, so presumably always returned as 0?  Best to note that.

> +
> +  struct kdbus_item items[0];
> +    Unused und not allowed for this use case.
> +};
> +
> +
> +11. Policy
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +A policy databases restrict the possibilities of connections to own,=
 see and
> +talk to well-known names. It can be associated with a bus (through a=
 policy

s/It/A policy/

> +holder connection) or a custom endpoint.
> +
> +See section 8.1 for more details on the validity of well-known names=
=2E
> +
> +Default endpoints of buses always have a policy database. The defaul=
t
> +policy is to deny all operations except for operations that are cove=
red by
> +implicit policies. Custom endpoints always have a policy, and by def=
ault,
> +a policy database is empty. Therefore, unless policy rules are added=
, all

s/a policy database/the policy database/

> +operations will also be denied by default.
> +
> +See section 11.5 for more details on implicit policies.
> +
> +A set of policy rules is described by a name and multiple access rul=
es, defined
> +by the following struct.
> +
> +struct kdbus_policy_access {
> +  __u64 type;	/* USER, GROUP, WORLD */
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
> +  __u64 access;	/* OWN, TALK, SEE */
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
> +
> +Policies are set through KDBUS_CMD_HELLO (when creating a policy hol=
der
> +connection), KDBUS_CMD_CONN_UPDATE (when updating a policy holder co=
nnection),
> +KDBUS_CMD_ENDPOINT_MAKE (creating a custom endpoint) or
> +KDBUS_CMD_ENDPOINT_UPDATE (updating a custom endpoint). In all cases=
, the name
> +and policy access information is stored in items of type KDBUS_ITEM_=
NAME and
> +KDBUS_ITEM_POLICY_ACCESS. For this transport, the following rules ap=
ply.
> +
> +  * An item of type KDBUS_ITEM_NAME must be followed by at least one
> +    KDBUS_ITEM_POLICY_ACCESS item
> +  * An item of type KDBUS_ITEM_NAME can be followed by an arbitrary =
number of
> +    KDBUS_ITEM_POLICY_ACCESS items
> +  * An arbitrary number of groups of names and access levels can be =
passed
> +
> +uids and gids are internally always stored in the kernel's view of g=
lobal ids,
> +and are translated back and forth on the ioctl level accordingly.
> +
> +
> +11.2 Wildcard names
> +-------------------
> +
> +Policy holder connections may upload names that contain the wild car=
d suffix

s/wild card/wildcard/

> +(".*"). That way, a policy can be uploaded that is effective for eve=
ry
> +well-known name that extends the provided name by exactly one more l=
evel.
> +
> +For example, if an item of a set up uploaded policy rules contains t=
he name

I find that last line very difficult to parse. Someehting is broken.=20
What are you trying to say?

> +"foo.bar.*", both "foo.bar.baz" and "foo.bar.bazbaz" are valid, but

s/both/then both/ to help parsing.

> +"foo.bar.baz.baz" is not.
> +
> +This allows connections to take control over multiple names that the=
 policy
> +holder doesn't need to know about when uploading the policy.
> +
> +Such wildcard entries are not allowed for custom endpoints.
> +
> +
> +11.3 Policy example
> +-------------------
> +
> +For example, a set of policy rules may look like this:
> +
> +  KDBUS_ITEM_NAME: str=3D'org.foo.bar'
> +  KDBUS_ITEM_POLICY_ACCESS: type=3DUSER, access=3DOWN, id=3D1000
> +  KDBUS_ITEM_POLICY_ACCESS: type=3DUSER, access=3DTALK, id=3D1001
> +  KDBUS_ITEM_POLICY_ACCESS: type=3DWORLD, access=3DSEE
> +  KDBUS_ITEM_NAME: str=3D'org.blah.baz'
> +  KDBUS_ITEM_POLICY_ACCESS: type=3DUSER, access=3DOWN, id=3D0
> +  KDBUS_ITEM_POLICY_ACCESS: type=3DWORLD, access=3DTALK
> +
> +That means that 'org.foo.bar' may only be owned by uid 1000, but eve=
ry user on
> +the bus is allowed to see the name. However, only uid 1001 may actua=
lly send
> +a message to the connection and receive a reply from it.
> +
> +The second rule allows 'org.blah.baz' to be owned by uid 0 only, but=
 every user
> +may talk to it.
> +
> +
> +11.4 TALK access and multiple well-known names per connection
> +-------------------------------------------------------------
> +
> +Note that TALK access is checked against all names of a connection.
> +For example, if a connection owns both 'org.foo.bar' and 'org.blah.b=
az', and
> +the policy database allows 'org.blah.baz' to be talked to by WORLD, =
then this
> +permission is also granted to 'org.foo.bar'. That might sound illogi=
cal, but
> +after all, we allow messages to be directed to either the ID or a we=
ll-known
> +name, and policy is applied to the connection, not the name. In othe=
r words,
> +the effective TALK policy for a connection is the most permissive of=
 all names
> +the connection owns.
> +
> +For broadcast messages, the receiver needs TALK permissions to the s=
ender to
> +receive the broadcast.
> +
> +If a policy database exists for a bus (because a policy holder creat=
ed one on
> +demand) or for a custom endpoint (which always has one), each one is=
 consulted

By "created one on demand" do you mean "explicitly created one"? If so
please use the latter wording, since its clearer.

> +during name registry listing, name owning or message delivery. If ei=
ther one

What is "name owning". I think this could be worded better.

> +fails, the operation is failed with -EPERM.
> +
> +For best practices, connections that own names with a restricted TAL=
K
> +access should not install matches. This avoids cases where the sent
> +message may pass the bloom filter due to false-positives and may als=
o
> +satisfy the policy rules.
> +
> +
> +11.5 Implicit policies
> +----------------------
> +
> +Depending on the type of the endpoint, a set of implicit rules that
> +override installed policies might be enforced.
> +
> +On default endpoints, the following set is enforced and checked befo=
re
> +any user-supplied policy is checked.
> +
> +  * Privileged connections always override any installed policy. Tho=
se
> +    connections could easily install their own policies, so there is=
 no
> +    reason to enforce installed policies.
> +  * Connections can always talk to connections of the same user. Thi=
s
> +    includes broadcast messages.
> +
> +Custom endpoints have stricter policies. The following rules apply:
> +
> +  * Policy rules are always enforced, even if the connection is a pr=
ivileged
> +    connection.
> +  * Policy rules are always enforced for TALK access, even if both e=
nds are
> +    running under the same user. This includes broadcast messages.
> +  * To restrict the set of names that can be seen, endpoint policies=
 can
> +    install "SEE" policies.
> +
> +
> +12. Pool
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +A pool for data received from the kernel is installed for every conn=
ection of
> +the bus, and is sized according to the information stored in the
> +KDBUS_ITEM_BLOOM_PARAMETER item that is returned by KDBUS_CMD_HELLO.
> +
> +The pool is written to by the kernel when one of the following ioctl=
s is issued:
> +
> +  * KDBUS_CMD_HELLO, to receive details about the bus the connection=
 was made to
> +  * KDBUS_CMD_RECV, to receive a message
> +  * KDBUS_CMD_NAME_LIST, to dump the name registry
> +  * KDBUS_CMD_CONN_INFO, to retrieve information on a connection
> +
> +The offsets returned by either one of the aforementioned ioctls desc=
ribe offsets
> +inside the pool. In order to make the slice available for subsequent=
 calls,
> +KDBUS_CMD_FREE has to be called on the offset.
> +
> +To access the memory, the caller is expected to mmap() it to its tas=
k, like

s/to its task//

> +this:
> +
> +  /*
> +   * POOL_SIZE has to be a multiple of PAGE_SIZE, and it must match =
the
> +   * value that was previously returned through the KDBUS_ITEM_BLOOM=
_PARAMETER
> +   * item field when the KDBUS_CMD_HELLO ioctl returned.
> +   */
> +
> +  buf =3D mmap(NULL, POOL_SIZE, PROT_READ, MAP_SHARED, conn_fd, 0);
> +
> +Alternatively, instead of mapping the entire pool buffer, only parts=
 of it can
> +be mapped. The length of the response is returned by the kernel alon=
g with the
> +offset for each of the ioctls listed above.
> +
> +
> +13. Metadata
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +kdbus records data about the system in certain situations. Such meta=
data can
> +refer to the currently active process (creds, PIDs, current user gro=
ups, process
> +names and its executable path, cgroup membership, capabilities, secu=
rity label
> +and audit information), connection information (description string, =
currently
> +owned names) and the timestamp.
> +
> +Metadata is collected in the following circumstances:
> +
> +  * When a bus is created (KDBUS_CMD_MAKE), information about the ca=
lling task
> +    is collected. This data is returned by the kernel via the
> +    KDBUS_CMD_BUS_CREATOR_INFO call-

s/-/./

> +
> +  * When a connection is created (KDBUS_CMD_HELLO), information abou=
t the
> +    calling task is collected. Alternatively, a privileged connectio=
n may
> +    provide 'faked' information about credentials, PIDs and a securi=
ty labels

s/a security/security/

> +    which will be taken instead. This data is returned by the kernel=
 as
> +    information on a connection (KDBUS_CMD_CONN_INFO).
> +
> +  * When a message is sent (KDBUS_CMD_SEND), information about the s=
ending task
> +    and the sending connection are collected. This metadata will be =
attached
> +    to the message when it arrives in the receiver's pool. If the co=
nnection
> +    sending the message installed faked credentials (see above), the=
 message
> +    will not be augmented by any information about the currently sen=
ding task.
> +
> +Which metadata items are actually delivered depends on the following=
 sets and
> +masks:
> +
> +    (a) the system-wide kmod creds mask (module parameter 'attach_fl=
ags_mask')
> +    (b) the per-connection send creds mask, set by the connecting cl=
ient
> +    (c) the per-connection receive creds mask, set by the connecting=
 client
> +    (d) the per-bus minimal creds mask, set by the bus creator
> +    (e) the per-bus owner creds mask, set by the bus creator
> +    (f) the mask specified when querying creds of a bus peer
> +    (g) the mask specified when querying creds of a bus owner
> +
> +With the following rules:
> +
> +    [1] The creds attached to messages are determined as (a & b & c)=
=2E
> +    [2] When connecting to a bus (KDBUS_CMD_HELLO), and (~b & d) !=3D=
 0, the call
> +        will fail, the connection is refused.
> +    [3] When querying creds of a bus peer, the creds returned are  (=
a & b & f)
> +    [4] When querying creds of a bus owner, the creds returned are (=
a & e & g)
> +    [5] When creating a new bus, and (d & ~a) !=3D 0, then bus creat=
ion will fail
> +
> +Hence, userspace might not always get all requested metadata items t=
hat it
> +requested. Code must be written so that it can cope with this fact.
> +
> +
> +13.1 Known item types
> +---------------------
> +
> +The following attach flags are currently supported.
> +
> +  KDBUS_ATTACH_TIMESTAMP
> +    Attaches an item of type KDBUS_ITEM_TIMESTAMP which contains bot=
h the
> +    monotonic and the realtime timestamp, taken when the message was
> +    processed on the kernel side.
> +
> +  KDBUS_ATTACH_CREDS
> +    Attaches an item of type KDBUS_ITEM_CREDS, containing credential=
s as
> +    described in struct kdbus_creds: the user and group IDs in the u=
sual four
> +    flavors: real, effective, saved and file-system related.
> +
> +  KDBUS_ATTACH_PIDS
> +    Attaches an item of type KDBUS_ITEM_PIDS, containing information=
 on the
> +    process. In particular, the PID (process ID), TID (thread ID), a=
nd PPID
> +    (PID of the parent process).
> +
> +  KDBUS_ATTACH_AUXGROUPS
> +    Attaches an item of type KDBUS_ITEM_AUXGROUPS, containing a dyna=
mic
> +    number of auxiliary groups the sending task was a member of.
> +
> +  KDBUS_ATTACH_NAMES
> +    Attaches items of type KDBUS_ITEM_OWNED_NAME, one for each name =
the sending
> +    connection currently owns. The name and flags are stored in kdbu=
s_item.name
> +    for each of them.
> +
> +  KDBUS_ATTACH_TID_COMM [*]
> +    Attaches an items of type KDBUS_ITEM_TID_COMM, transporting the =
sending
> +    task's 'comm', for the tid.  The string is stored in kdbus_item.=
str.
> +
> +  KDBUS_ATTACH_PID_COMM [*]
> +    Attaches an items of type KDBUS_ITEM_PID_COMM, transporting the =
sending
> +    task's 'comm', for the pid.  The string is stored in kdbus_item.=
str.
> +
> +  KDBUS_ATTACH_EXE [*]
> +    Attaches an item of type KDBUS_ITEM_EXE, containing the path to =
the
> +    executable of the sending task, stored in kdbus_item.str.
> +
> +  KDBUS_ATTACH_CMDLINE [*]
> +    Attaches an item of type KDBUS_ITEM_CMDLINE, containing the comm=
and line
> +    arguments of the sending task, as an array of strings, stored in
> +    kdbus_item.str.
> +
> +  KDBUS_ATTACH_CGROUP
> +    Attaches an item of type KDBUS_ITEM_CGROUP with the task's cgrou=
p path.
> +
> +  KDBUS_ATTACH_CAPS
> +    Attaches an item of type KDBUS_ITEM_CAPS, carrying sets of capab=
ilities
> +    that should be accessed via kdbus_item.caps.caps. Also, userspac=
e should
> +    be written in a way that it takes kdbus_item.caps.last_cap into =
account,
> +    and derive the number of sets and rows from the item size and th=
e reported
> +    number of valid capability bits.
> +
> +  KDBUS_ATTACH_SECLABEL
> +    Attaches an item of type KDBUS_ITEM_SECLABEL, which contains the=
 SELinux
> +    security label of the sending task. SELinux and other MACs might=
 want to
> +    do additional per-service security checks. For example, a servic=
e manager
> +    might want to check the security label of a service file against=
 the
> +    security label of the client process checking the SELinux databa=
se before
> +    allowing access.  The label can be accessed via kdbus_item->str.
> +
> +  KDBUS_ATTACH_AUDIT
> +    Attaches an item of type KDBUS_ITEM_AUDIT, which contains the au=
dit
> +    sessionid and loginuid of the sending task. Access via kdbus_ite=
m->audit.
> +
> +  KDBUS_ATTACH_CONN_DESCRIPTION
> +    Attaches an item of type KDBUS_ITEM_CONN_DESCRIPTION that contai=
ns a
> +    descriptive string of the sending peer. That string can be suppl=
ied
> +    during HELLO by attaching an item of type KDBUS_ITEM_CONN_DESCRI=
PTION.
> +
> +
> +[*] Note that the content stored in these items can easily be tamper=
ed by
> +    the sending tasks. Therefore, they should NOT be used for any so=
rt of
> +    security relevant assumptions. The only reason why they are tran=
smitted is
> +    to let receivers know about details that were set when metadata =
was
> +    collected, even though the task they were collected from is not =
active any
> +    longer when the items are received.
> +
> +
> +13.2 Metadata and namespaces
> +----------------------------
> +
> +Metadata such as PIDs, UIDs or GIDs are automatically translated to =
the
> +namespaces of the task that receives them.
> +
> +
> +14. Error codes
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +Below is a list of error codes that might be returned by the individ=
ual
> +ioctl commands. The list focuses on the return values from kdbus cod=
e itself,
> +and might not cover those of all kernel internal functions.
> +
> +For all ioctls:
> +
> +  -ENOMEM	The kernel memory is exhausted
> +  -ENOTTY	Illegal ioctl command issued for the file descriptor

Why ENOTTY here, rather than EINVAL? The latter is, I beleive, the usua=
l=20
ioctl() error for invalid commands, I believe (If you keep ENOTTY, add =
an
explanation in this document.)

> +  -ENOSYS	The requested functionality is not available

Maybe add here an explanation or examples of why the functionality is=20
not available?

> +  -EINVAL	Unsupported item attached to command
> +
> +For all ioctls that carry a struct as payload:
> +
> +  -EFAULT	The supplied data pointer was not 64-bit aligned, or was
> +		inaccessible from the kernel side.
> +  -EINVAL	The size inside the supplied struct was smaller than expec=
ted
> +  -EMSGSIZE	The size inside the supplied struct was bigger than expe=
cted

Why two different errors for smaller and larger than expected? (If you =
keep things this
way, pelase explain the reason in this document.)

> +  -ENAMETOOLONG	A supplied name is larger than the allowed maximum s=
ize
> +
> +For KDBUS_CMD_BUS_MAKE:
> +
> +  -EINVAL	The flags supplied in the kdbus_cmd_make struct are invali=
d or
> +		the supplied name does not start with the current uid and a '-'
> +  -EEXIST	A bus of that name already exists
> +  -ESHUTDOWN	The domain for the bus is already shut down
> +  -EMFILE	The maximum number of buses for the current user is exhaus=
ted
> +
> +For KDBUS_CMD_ENDPOINT_MAKE:
> +
> +  -EPERM	The calling user is not privileged (see Terminology)
> +  -EINVAL	The flags supplied in the kdbus_cmd_make struct are invali=
d
> +  -EEXIST	An endpoint of that name already exists
> +
> +For KDBUS_CMD_HELLO:
> +
> +  -EFAULT	The supplied pool size was 0 or not a multiple of the page=
 size
> +  -EINVAL	The flags supplied in the kdbus_cmd_make struct are invali=
d, or
> +		an illegal combination of KDBUS_HELLO_MONITOR,
> +		KDBUS_HELLO_ACTIVATOR and KDBUS_HELLO_POLICY_HOLDER was passed
> +		in the flags, or an invalid set of items was supplied
> +  -ECONNREFUSED	The attach_flags_send field did not satisfy the requ=
irements of
> +		the bus
> +  -EPERM	An KDBUS_ITEM_CREDS items was supplied, but the current use=
r is
> +		not privileged
> +  -ESHUTDOWN	The bus has already been shut down
> +  -EMFILE	The maximum number of connection on the bus has been reach=
ed

s/connection/connections/

> +  -EOPNOTSUPP	The endpoint does not support the connection flags
> +		supplied in the kdbus_cmd_hello struct
> +
> +For KDBUS_CMD_BYEBYE:
> +
> +  -EALREADY	The connection has already been shut down
> +  -EBUSY	There are still messages queued up in the connection's pool
> +
> +For KDBUS_CMD_SEND:
> +
> +  -EOPNOTSUPP	The connection is not an ordinary connection, or the p=
assed
> +		file descriptors are either kdbus handles or unix domain
> +		sockets. Both are currently unsupported
> +  -EINVAL	The submitted payload type is KDBUS_PAYLOAD_KERNEL,
> +		KDBUS_MSG_EXPECT_REPLY was set without timeout or cookie
> +		values, KDBUS_MSG_SYNC_REPLY was set without
> +		KDBUS_MSG_EXPECT_REPLY, an invalid item was supplied,
> +		src_id was !=3D 0 and different from the current connection's ID,

s/src_id was !=3D 0 and different/src_id was nonzero and was different/

> +		a supplied memfd had a size of 0, a string was not properly
> +		null-terminated
> +  -ENOTUNIQ	The supplied destination is KDBUS_DST_ID_BROADCAST, a fi=
le
> +		descriptor was passed, KDBUS_MSG_EXPECT_REPLY was set,
> +		or a timeout was given for a broadcast message
> +  -E2BIG	Too many items
> +  -EMSGSIZE	The size of the message header and items or the payload =
vector
> +		is too big.
> +  -EEXIST	Multiple KDBUS_ITEM_FDS, KDBUS_ITEM_BLOOM_FILTER or
> +		KDBUS_ITEM_DST_NAME items were supplied
> +  -EBADF	The supplied KDBUS_ITEM_FDS or KDBUS_MSG_PAYLOAD_MEMFD item=
s
> +		contained an illegal file descriptor
> +  -EMEDIUMTYPE	The supplied memfd is not a sealed kdbus memfd
> +  -EMFILE	Too many file descriptors inside a KDBUS_ITEM_FDS
> +  -EBADMSG	An item had illegal size, both a dst_id and a
> +		KDBUS_ITEM_DST_NAME was given, or both a name and a bloom
> +		filter was given
> +  -ETXTBSY	The supplied kdbus memfd file cannot be sealed or the sea=
l
> +		was removed, because it is shared with other processes or
> +		still mmap()ed
> +  -ECOMM	A peer does not accept the file descriptors addressed to it
> +  -EFAULT	The supplied bloom filter size was not 64-bit aligned
> +  -EDOM		The supplied bloom filter size did not match the bloom filt=
er
> +		size of the bus
> +  -EDESTADDRREQ	dst_id was set to KDBUS_DST_ID_NAME, but no KDBUS_IT=
EM_DST_NAME
> +		was attached
> +  -ESRCH	The name to look up was not found in the name registry
> +  -EADDRNOTAVAIL KDBUS_MSG_NO_AUTO_START was given but the destinati=
on
> +		 connection is an activator.
> +  -ENXIO	The passed numeric destination connection ID couldn't be fo=
und,
> +		or is not connected
> +  -ECONNRESET	The destination connection is no longer active
> +  -ETIMEDOUT	Timeout while synchronously waiting for a reply
> +  -EINTR	System call interrupted while synchronously waiting for a r=
eply
> +  -EPIPE	When sending a message, a synchronous reply from the receiv=
ing
> +		connection was expected but the connection died before
> +		answering
> +  -ENOBUFS	Too many pending messages on the receiver side
> +  -EREMCHG	Both a well-known name and a unique name (ID) was given, =
but
> +		the name is not currently owned by that connection.
> +  -EXFULL	The memory pool of the receiver is full
> +  -EREMOTEIO	While synchronously waiting for a reply, the remote pee=
r
> +		failed with an I/O error.
> +
> +For KDBUS_CMD_RECV:
> +
> +  -EINVAL	Invalid flags or offset
> +  -EAGAIN	No message found in the queue
> +  -ENOMSG	No message of the requested priority found
> +  -EOVERFLOW	Broadcast messages have been lost
> +
> +For KDBUS_CMD_FREE:
> +
> +  -ENXIO	No pool slice found at given offset
> +  -EINVAL	Invalid flags provided, the offset is valid, but the user =
is
> +		not allowed to free the slice. This happens, for example, if
> +		the offset was retrieved with KDBUS_RECV_PEEK.

It would be easier to read if this was written to clarify that there ar=
e=20
two distinct error cases:

  -EINVAL	Invalid flags provided.
  -EINVAL       The offset is valid, but the user is
		not allowed to free the slice. This happens, for example, if
		the offset was retrieved with KDBUS_RECV_PEEK.

> +For KDBUS_CMD_NAME_ACQUIRE:
> +
> +  -EINVAL	Illegal command flags, illegal name provided, or an activa=
tor
> +		tried to acquire a second name
> +  -EPERM	Policy prohibited name ownership
> +  -EALREADY	Connection already owns that name
> +  -EEXIST	The name already exists and can not be taken over
> +  -E2BIG	The maximum number of well-known names per connection
> +		is exhausted
> +  -ECONNRESET	The connection was reset during the call
> +
> +For KDBUS_CMD_NAME_RELEASE:
> +
> +  -EINVAL	Invalid command flags, or invalid name provided
> +  -ESRCH	Name is not found found in the registry
> +  -EADDRINUSE	Name is owned by a different connection and can't be r=
eleased
> +
> +For KDBUS_CMD_NAME_LIST:
> +
> +  -EINVAL	Invalid flags
> +  -ENOBUFS	No available memory in the connection's pool.
> +
> +For KDBUS_CMD_CONN_INFO:
> +
> +  -EINVAL	Invalid flags, or neither an ID nor a name was provided,
> +		or the name is invalid.
> +  -ESRCH	Connection lookup by name failed
> +  -ENXIO	No connection with the provided connection ID found
> +
> +For KDBUS_CMD_CONN_UPDATE:
> +
> +  -EINVAL	Illegal flags or items
> +  -EOPNOTSUPP	Operation not supported by connection.
> +  -E2BIG	Too many policy items attached
> +  -EINVAL	Wildcards submitted in policy entries, or illegal sequence
> +		of policy items
> +
> +For KDBUS_CMD_ENDPOINT_UPDATE:
> +
> +  -E2BIG	Too many policy items attached
> +  -EINVAL	Invalid flags, or wildcards submitted in policy entries,
> +		or illegal sequence of policy items
> +
> +For KDBUS_CMD_MATCH_ADD:
> +
> +  -EINVAL	Illegal flags or items
> +  -EDOM		Illegal bloom filter size
> +  -EMFILE	Too many matches for this connection
> +
> +For KDBUS_CMD_MATCH_REMOVE:
> +
> +  -EINVAL	Illegal flags
> +  -ENOENT	A match entry with the given cookie could not be found.
> +
> +
> +15. Internal object relations
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +This is a simplified outline of the internal kdbus object relations,=
 for
> +those interested in the inner life of the driver implementation.
> +
> +From the a mount point's (domain's) perspective:
> +
> +struct kdbus_domain
> +  |=C2=BB struct kdbus_domain_user *user (many, owned)
> +  '=C2=BB struct kdbus_node node (embedded)
> +      |=C2=BB struct kdbus_node children (many, referenced)
> +      |=C2=BB struct kdbus_node *parent (pinned)
> +      '=C2=BB struct kdbus_bus (many, pinned)
> +          |=C2=BB struct kdbus_node node (embedded)
> +          '=C2=BB struct kdbus_ep (many, pinned)
> +              |=C2=BB struct kdbus_node node (embedded)
> +              |=C2=BB struct kdbus_bus *bus (pinned)
> +              |=C2=BB struct kdbus_conn conn_list (many, pinned)
> +              |   |=C2=BB struct kdbus_ep *ep (pinned)
> +              |   |=C2=BB struct kdbus_name_entry *activator_of (own=
ed)
> +              |   |=C2=BB struct kdbus_match_db *match_db (owned)
> +              |   |=C2=BB struct kdbus_meta *meta (owned)
> +              |   |=C2=BB struct kdbus_match_db *match_db (owned)
> +              |   |    '=C2=BB struct kdbus_match_entry (many, owned=
)
> +              |   |
> +              |   |=C2=BB struct kdbus_pool *pool (owned)
> +              |   |    '=C2=BB struct kdbus_pool_slice *slices (many=
, owned)
> +              |   |       '=C2=BB struct kdbus_pool *pool (pinned)
> +              |   |
> +              |   |=C2=BB struct kdbus_domain_user *user (pinned)
> +              |   `=C2=BB struct kdbus_queue_entry entries (many, em=
bedded)
> +              |        |=C2=BB struct kdbus_pool_slice *slice (pinne=
d)
> +              |        |=C2=BB struct kdbus_conn_reply *reply (owned=
)
> +              |        '=C2=BB struct kdbus_domain_user *user (pinne=
d)
> +              |
> +              '=C2=BB struct kdbus_domain_user *user (pinned)
> +                  '=C2=BB struct kdbus_policy_db policy_db (embedded=
)
> +                       |=C2=BB struct kdbus_policy_db_entry (many, o=
wned)
> +                       |   |=C2=BB struct kdbus_conn (pinned)
> +                       |   '=C2=BB struct kdbus_ep (pinned)
> +                       |
> +                       '=C2=BB struct kdbus_policy_db_cache_entry (m=
any, owned)
> +                           '=C2=BB struct kdbus_conn (pinned)
> +
> +
> +For the life-time of a file descriptor derived from calling open() o=
n a file
> +inside the mount point:
> +
> +struct kdbus_handle
> +  |=C2=BB struct kdbus_meta *meta (owned)
> +  |=C2=BB struct kdbus_ep *ep (pinned)
> +  |=C2=BB struct kdbus_conn *conn (owned)
> +  '=C2=BB struct kdbus_ep *ep (owned)

Thanks,

Michael


--=20
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
