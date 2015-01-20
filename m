From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: Re: [PATCH v3 00/13] Add kdbus implementation
Date: Tue, 20 Jan 2015 15:15:02 +0100
Message-ID: <54BE62E6.9030400@gmail.com>
References: <1421435777-25306-1-git-send-email-gregkh@linuxfoundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1421435777-25306-1-git-send-email-gregkh@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, arnd@arndb.de, ebiederm@xmission.com, gnomes@lxorguk.ukuu.org.uk, teg@jklm.no, jkosina@suse.cz, luto@amacapital.net, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: mtk.manpages@gmail.com, Daniel Mack <daniel@zonque.org>, dh.herrmann@gmail.com, tixxdz@opendz.org
List-Id: linux-api@vger.kernel.org

[Bother. Futzed Daniel Mack's email address. Resending]

On 01/16/2015 08:16 PM, Greg Kroah-Hartman wrote:
> kdbus is a kernel-level IPC implementation that aims for resemblance =
to
> the the protocol layer with the existing userspace D-Bus daemon while
> enabling some features that couldn't be implemented before in userspa=
ce.
>=20
> The documentation in the first patch in this series explains the
> protocol and the API details.
>=20
> Full details on what has changed from the v2 submission are at the
> bottom of this email.
>=20
> Reasons why this should be done in the kernel, instead of userspace a=
s
> it is currently done today include the following:
>=20
> - performance: fewer process context switches, fewer copies, fewer
>   syscalls, larger memory chunks via memfd.  This is really important
>   for a whole class of userspace programs that are ported from other
>   operating systems that are run on tiny ARM systems that rely on
>   hundreds of thousands of messages passed at boot time, and at
>   "critical" times in their user interaction loops.
> - security: the peers which communicate do not have to trust each oth=
er,
>   as the only trustworthy compoenent in the game is the kernel which
>   adds metadata and ensures that all data passed as payload is either
>   copied or sealed, so that the receiver can parse the data without
>   having to protect against changing memory while parsing buffers.  A=
lso,
>   all the data transfer is controlled by the kernel, so that LSMs can
>   track and control what is going on, without involving userspace.
>   Because of the LSM issue, security people are much happier with thi=
s
>   model than the current scheme of having to hook into dbus to mediat=
e
>   things.
> - more metadata can be attached to messages than in userspace
> - semantics for apps with heavy data payloads (media apps, for instan=
ce)
>   with optinal priority message dequeuing, and global message orderin=
g.
>   Some "crazy" people are playing with using kdbus for audio data in =
the
>   system.  I'm not saying that this is the best model for this, but
>   until now, there wasn't any other way to do this without having to
>   create custom "busses", one for each application library.
> - being in the kernle closes a lot of races which can't be fixed with
>   the current userspace solutions.  For example, with kdbus, there is=
 a
>   way a client can disconnect from a bus, but do so only if no furthe=
r
>   messages present in its queue, which is crucial for implementing
>   race-free "exit-on-idle" services
> - eavesdropping on the kernel level, so privileged users can hook int=
o
>   the message stream without hacking support for that into their
>   userspace processes
> - a number of smaller benefits: for example kdbus learned a way to pe=
ek
>   full messages without dequeing them, which is really useful for
>   logging metadata when handling bus-activation requests.
>=20
> Of course, some of the bits above could be implemented in userspace
> alone, for example with more sophisticated memory management APIs, bu=
t
> this is usually done by losing out on the other details.  For example=
,
> for many of the memory management APIs, it's hard to not require the
> communicating peers to fully trust each other.  And we _really_ don't
> want peers to have to trust each other.
>=20
> Another benefit of having this in the kernel, rather than as a usersp=
ace
> daemon, is that you can now easily use the bus from the initrd, or up=
 to
> the very end when the system shuts down.  On current userspace D-Bus,
> this is not really possible, as this requires passing the bus instanc=
e
> around between initrd and the "real" system.  Such a transition of al=
l
> fds also requires keeping full state of what has already been read fr=
om
> the connection fds.  kdbus makes this much simpler, as we can change =
the
> ownership of the bus, just by passing one fd over from one part to th=
e
> other.

I tend to think that much of the above should also be part of the=20
documentation file (patch 01/13).

Cheers,

Michael


=20
> Regarding binder: binder and kdbus follow very different design
> concepts.  Binder implies the use of thread-pools to dispatch incomin=
g
> method calls.  This is a very efficient scheme, and completely natura=
l
> in programming languages like Java.  On most Linux programs, however,
> there's a much stronger focus on central poll() loops that dispatch a=
ll
> sources a program cares about.  kdbus is much more usable in such
> environments, as it doesn't enforce a threading model, and it is happ=
y
> with serialized dispatching.  In fact, this major difference had an
> effect on much of the design decisions: binder does not guarantee glo=
bal
> message ordering due to the parallel dispatching in the thread-pools,
> but  kdbus does.  Moreover, there's also a difference in the way mess=
age
> handling.  In kdbus, every message is basically taken and dispatched =
as
> one blob, while in binder, continious connections to other peers are
> created, which are then used to send messages on.  Hence, the models =
are
> quite different, and they serve different needs.  I believe that the
> D-Bus/kdbus model is more compatible and friendly with how Linux
> programs are usually implemented.
>=20
> This can also be found in a git tree, the kdbus branch of char-misc.g=
it at:
>         https://git.kernel.org/cgit/linux/kernel/git/gregkh/char-misc=
=2Egit/
>=20
> Changes since v2:
>=20
>   * Add FS_USERNS_MOUNT to the file system flags, so users can mount
>     their own kdbusfs instances without being root in the parent
>     user-ns. Spotted by Andy Lutomirski.
>=20
>   * Rewrite major parts of the metadata implementation to allow for
>     per-recipient namespace translations. For this, namespaces are
>     now not pinned by domains anymore. Instead, metadata is recorded
>     in kernel scope, and exported into the currently active namespace=
s
>     at the time of message installing.
>=20
>   * Split PID and TID from KDBUS_ITEM_CREDS into KDBUS_ITEM_PIDS.
>     The starttime is there to detect re-used PIDs, so move it to that
>     new item type as well. Consequently, introduce struct kdbus_pids
>     to accommodate the information. Requested by Andy Lutomirski.
>=20
>   * Add {e,s,fs}{u,g}id to KDBUS_ITEM_CREDS, so users have a way to
>     get more fine-grained credential information.
>=20
>   * Removed KDBUS_CMD_CANCEL. The interface was not usable from
>     threaded userspace implementation due to inherent races. Instead,
>     add an item type CANCEL_FD which can be used to pass a file
>     descriptor to the CMD_SEND ioctl. When the SEND is done
>     synchronously, it will get cancelled as soon as the passed
>     FD signals POLLIN.
>=20
>   * Dropped startttime from KDBUS_ITEM_PIDS
>=20
>   * Restrict names of custom endpoints to names with a "<uid>-" prefi=
x,
>     just like we do for buses.
>=20
>   * Provide module-parameter "kdbus.attach_flags_mask" to specify the
>     a mask of metadata items that is applied on all exported items.
>=20
>   * Monitors are now entirely invisible (IOW, there won't be any
>     notification when they are created) and they don't need to instal=
l
>     filters for broadcast messages anymore.
>=20
>   * All information exposed via a connection's pool now also reports
>     the length in addition to the offset. That way, userspace
>     applications can mmap() only parts of the pool on demand.
>=20
>   * Due to the metadata rework, KDBUS_ITEM_PAYLOAD_OFF items now
>     describe the offset relative to the pool, where they used to be
>     relative to the message header.
>=20
>   * Added return_flags bitmask to all kdbus_cmd_* structs, so the
>     kernel can report details of the command processing. This is
>     mostly reserved for future extensions.
>=20
>   * Some fixes in kdbus.txt and tests, spotted by Harald Hoyer, Andy
>     Lutomirski, Michele Curti, Sergei Zviagintsev, Sheng Yong, Torste=
in
>     Huseb=C3=B8 and Hristo Venev.
>=20
>   * Fixed compiler warnings in test-message by Michele Curti
>=20
>   * Unexpected items are now rejected with -EINVAL
>=20
>   * Split signal and broadcast handling. Unicast signals are now
>     supported, and messages have a new KDBUS_MSG_SIGNAL flag.
>=20
>   * KDBUS_CMD_MSG_SEND was renamed to KDBUS_CMD_SEND, and now takes
>     a struct kdbus_cmd_send instead of a kdbus_msg.
>=20
>   * KDBUS_CMD_MSG_RECV was renamed to KDBUS_CMD_RECV.
>=20
>   * Test case memory leak plugged, and various other cleanups and
>     fixes, by Rui Miguel Silva.
>=20
>   * Build fix for s390
>=20
>   * Test case fix for 32bit archs
>=20
>   * The test framework now supports mount, pid and user namespaces.
>=20
>   * The test framework learned a --tap command line parameter to
>     format its output in the "Test Anything Protocol". This format
>     is chosen by default when "make kselftest" is invoked.
>=20
>   * Fixed buses and custom endpoints name validation, reported by
>     Andy Lutomirski.
>=20
>   * copy_from_user() return code issue fixed, reported by
>     Dan Carpenter.
>=20
>   * Avoid signed int overflow on archs without atomic_sub
>=20
>   * Avoid variable size stack items. Fixes a sparse warning in queue.=
c.
>=20
>   * New test case for kernel notification quota
>=20
>   * Switched back to enums for the list of ioctls. This has advantage=
s
>     for userspace code as gdb, for instance, is able to resolve the
>     numbers into names. Added features can easily be detected with
>     autotools, and new iotcls can get #defines as well. Having #defin=
es
>     for the initial set of ioctls is uncecessary.
>=20
> Daniel Mack (13):
>   kdbus: add documentation
>   kdbus: add header file
>   kdbus: add driver skeleton, ioctl entry points and utility function=
s
>   kdbus: add connection pool implementation
>   kdbus: add connection, queue handling and message validation code
>   kdbus: add node and filesystem implementation
>   kdbus: add code to gather metadata
>   kdbus: add code for notifications and matches
>   kdbus: add code for buses, domains and endpoints
>   kdbus: add name registry implementation
>   kdbus: add policy database implementation
>   kdbus: add Makefile, Kconfig and MAINTAINERS entry
>   kdbus: add selftests
>=20
>  Documentation/ioctl/ioctl-number.txt              |    1 +
>  Documentation/kdbus.txt                           | 2107 +++++++++++=
++++++++++
>  MAINTAINERS                                       |   12 +
>  include/uapi/linux/Kbuild                         |    1 +
>  include/uapi/linux/kdbus.h                        | 1049 ++++++++++
>  include/uapi/linux/magic.h                        |    2 +
>  init/Kconfig                                      |   12 +
>  ipc/Makefile                                      |    2 +-
>  ipc/kdbus/Makefile                                |   22 +
>  ipc/kdbus/bus.c                                   |  553 ++++++
>  ipc/kdbus/bus.h                                   |  103 +
>  ipc/kdbus/connection.c                            | 2004 +++++++++++=
+++++++++
>  ipc/kdbus/connection.h                            |  262 +++
>  ipc/kdbus/domain.c                                |  350 ++++
>  ipc/kdbus/domain.h                                |   84 +
>  ipc/kdbus/endpoint.c                              |  232 +++
>  ipc/kdbus/endpoint.h                              |   68 +
>  ipc/kdbus/fs.c                                    |  519 +++++
>  ipc/kdbus/fs.h                                    |   25 +
>  ipc/kdbus/handle.c                                | 1134 +++++++++++
>  ipc/kdbus/handle.h                                |   20 +
>  ipc/kdbus/item.c                                  |  309 +++
>  ipc/kdbus/item.h                                  |   57 +
>  ipc/kdbus/limits.h                                |   95 +
>  ipc/kdbus/main.c                                  |   72 +
>  ipc/kdbus/match.c                                 |  535 ++++++
>  ipc/kdbus/match.h                                 |   32 +
>  ipc/kdbus/message.c                               |  598 ++++++
>  ipc/kdbus/message.h                               |  133 ++
>  ipc/kdbus/metadata.c                              | 1066 +++++++++++
>  ipc/kdbus/metadata.h                              |   52 +
>  ipc/kdbus/names.c                                 |  891 +++++++++
>  ipc/kdbus/names.h                                 |   82 +
>  ipc/kdbus/node.c                                  |  910 +++++++++
>  ipc/kdbus/node.h                                  |   87 +
>  ipc/kdbus/notify.c                                |  244 +++
>  ipc/kdbus/notify.h                                |   30 +
>  ipc/kdbus/policy.c                                |  481 +++++
>  ipc/kdbus/policy.h                                |   51 +
>  ipc/kdbus/pool.c                                  |  784 ++++++++
>  ipc/kdbus/pool.h                                  |   47 +
>  ipc/kdbus/queue.c                                 |  505 +++++
>  ipc/kdbus/queue.h                                 |  108 ++
>  ipc/kdbus/reply.c                                 |  262 +++
>  ipc/kdbus/reply.h                                 |   68 +
>  ipc/kdbus/util.c                                  |  317 ++++
>  ipc/kdbus/util.h                                  |  133 ++
>  tools/testing/selftests/Makefile                  |    1 +
>  tools/testing/selftests/kdbus/.gitignore          |   11 +
>  tools/testing/selftests/kdbus/Makefile            |   46 +
>  tools/testing/selftests/kdbus/kdbus-enum.c        |   95 +
>  tools/testing/selftests/kdbus/kdbus-enum.h        |   14 +
>  tools/testing/selftests/kdbus/kdbus-test.c        |  920 +++++++++
>  tools/testing/selftests/kdbus/kdbus-test.h        |   85 +
>  tools/testing/selftests/kdbus/kdbus-util.c        | 1646 +++++++++++=
+++++
>  tools/testing/selftests/kdbus/kdbus-util.h        |  216 +++
>  tools/testing/selftests/kdbus/test-activator.c    |  319 ++++
>  tools/testing/selftests/kdbus/test-attach-flags.c |  751 ++++++++
>  tools/testing/selftests/kdbus/test-benchmark.c    |  427 +++++
>  tools/testing/selftests/kdbus/test-bus.c          |  174 ++
>  tools/testing/selftests/kdbus/test-chat.c         |  123 ++
>  tools/testing/selftests/kdbus/test-connection.c   |  611 ++++++
>  tools/testing/selftests/kdbus/test-daemon.c       |   66 +
>  tools/testing/selftests/kdbus/test-endpoint.c     |  344 ++++
>  tools/testing/selftests/kdbus/test-fd.c           |  710 +++++++
>  tools/testing/selftests/kdbus/test-free.c         |   36 +
>  tools/testing/selftests/kdbus/test-match.c        |  442 +++++
>  tools/testing/selftests/kdbus/test-message.c      |  658 +++++++
>  tools/testing/selftests/kdbus/test-metadata-ns.c  |  507 +++++
>  tools/testing/selftests/kdbus/test-monitor.c      |  158 ++
>  tools/testing/selftests/kdbus/test-names.c        |  184 ++
>  tools/testing/selftests/kdbus/test-policy-ns.c    |  633 +++++++
>  tools/testing/selftests/kdbus/test-policy-priv.c  | 1270 +++++++++++=
++
>  tools/testing/selftests/kdbus/test-policy.c       |   81 +
>  tools/testing/selftests/kdbus/test-race.c         |  313 +++
>  tools/testing/selftests/kdbus/test-sync.c         |  368 ++++
>  tools/testing/selftests/kdbus/test-timeout.c      |   99 +
>  77 files changed, 27818 insertions(+), 1 deletion(-)
>  create mode 100644 Documentation/kdbus.txt
>  create mode 100644 include/uapi/linux/kdbus.h
>  create mode 100644 ipc/kdbus/Makefile
>  create mode 100644 ipc/kdbus/bus.c
>  create mode 100644 ipc/kdbus/bus.h
>  create mode 100644 ipc/kdbus/connection.c
>  create mode 100644 ipc/kdbus/connection.h
>  create mode 100644 ipc/kdbus/domain.c
>  create mode 100644 ipc/kdbus/domain.h
>  create mode 100644 ipc/kdbus/endpoint.c
>  create mode 100644 ipc/kdbus/endpoint.h
>  create mode 100644 ipc/kdbus/fs.c
>  create mode 100644 ipc/kdbus/fs.h
>  create mode 100644 ipc/kdbus/handle.c
>  create mode 100644 ipc/kdbus/handle.h
>  create mode 100644 ipc/kdbus/item.c
>  create mode 100644 ipc/kdbus/item.h
>  create mode 100644 ipc/kdbus/limits.h
>  create mode 100644 ipc/kdbus/main.c
>  create mode 100644 ipc/kdbus/match.c
>  create mode 100644 ipc/kdbus/match.h
>  create mode 100644 ipc/kdbus/message.c
>  create mode 100644 ipc/kdbus/message.h
>  create mode 100644 ipc/kdbus/metadata.c
>  create mode 100644 ipc/kdbus/metadata.h
>  create mode 100644 ipc/kdbus/names.c
>  create mode 100644 ipc/kdbus/names.h
>  create mode 100644 ipc/kdbus/node.c
>  create mode 100644 ipc/kdbus/node.h
>  create mode 100644 ipc/kdbus/notify.c
>  create mode 100644 ipc/kdbus/notify.h
>  create mode 100644 ipc/kdbus/policy.c
>  create mode 100644 ipc/kdbus/policy.h
>  create mode 100644 ipc/kdbus/pool.c
>  create mode 100644 ipc/kdbus/pool.h
>  create mode 100644 ipc/kdbus/queue.c
>  create mode 100644 ipc/kdbus/queue.h
>  create mode 100644 ipc/kdbus/reply.c
>  create mode 100644 ipc/kdbus/reply.h
>  create mode 100644 ipc/kdbus/util.c
>  create mode 100644 ipc/kdbus/util.h
>  create mode 100644 tools/testing/selftests/kdbus/.gitignore
>  create mode 100644 tools/testing/selftests/kdbus/Makefile
>  create mode 100644 tools/testing/selftests/kdbus/kdbus-enum.c
>  create mode 100644 tools/testing/selftests/kdbus/kdbus-enum.h
>  create mode 100644 tools/testing/selftests/kdbus/kdbus-test.c
>  create mode 100644 tools/testing/selftests/kdbus/kdbus-test.h
>  create mode 100644 tools/testing/selftests/kdbus/kdbus-util.c
>  create mode 100644 tools/testing/selftests/kdbus/kdbus-util.h
>  create mode 100644 tools/testing/selftests/kdbus/test-activator.c
>  create mode 100644 tools/testing/selftests/kdbus/test-attach-flags.c
>  create mode 100644 tools/testing/selftests/kdbus/test-benchmark.c
>  create mode 100644 tools/testing/selftests/kdbus/test-bus.c
>  create mode 100644 tools/testing/selftests/kdbus/test-chat.c
>  create mode 100644 tools/testing/selftests/kdbus/test-connection.c
>  create mode 100644 tools/testing/selftests/kdbus/test-daemon.c
>  create mode 100644 tools/testing/selftests/kdbus/test-endpoint.c
>  create mode 100644 tools/testing/selftests/kdbus/test-fd.c
>  create mode 100644 tools/testing/selftests/kdbus/test-free.c
>  create mode 100644 tools/testing/selftests/kdbus/test-match.c
>  create mode 100644 tools/testing/selftests/kdbus/test-message.c
>  create mode 100644 tools/testing/selftests/kdbus/test-metadata-ns.c
>  create mode 100644 tools/testing/selftests/kdbus/test-monitor.c
>  create mode 100644 tools/testing/selftests/kdbus/test-names.c
>  create mode 100644 tools/testing/selftests/kdbus/test-policy-ns.c
>  create mode 100644 tools/testing/selftests/kdbus/test-policy-priv.c
>  create mode 100644 tools/testing/selftests/kdbus/test-policy.c
>  create mode 100644 tools/testing/selftests/kdbus/test-race.c
>  create mode 100644 tools/testing/selftests/kdbus/test-sync.c
>  create mode 100644 tools/testing/selftests/kdbus/test-timeout.c
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-api" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--=20
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
