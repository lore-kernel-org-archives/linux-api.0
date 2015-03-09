From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH v4 00/14] Add kdbus implementation
Date: Mon,  9 Mar 2015 14:09:06 +0100
Message-ID: <1425906560-13798-1-git-send-email-gregkh@linuxfoundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: arnd@arndb.de, ebiederm@xmission.com, gnomes@lxorguk.ukuu.org.uk, teg@jklm.no, jkosina@suse.cz, luto@amacapital.net, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: daniel@zonque.org, dh.herrmann@gmail.com, tixxdz@opendz.org
List-Id: linux-api@vger.kernel.org

kdbus is a kernel-level IPC implementation that aims for resemblance to
the the protocol layer with the existing userspace D-Bus daemon while
enabling some features that couldn't be implemented before in userspace.

The documentation in the first patch in this series explains the
protocol and the API details.

This is v4 of the kdbus series for inclusion into the mainline kernel.
Changes since v3 are:

 * Drop KDBUS_FLAG_KERNEL and the 'kernel_flags' member from all
   struct kdbus_cmd_*, and introduce a new KDBUS_FLAGS_NEGOTIATE
   instead. Requested by Michael Kerrisk.

 * Transform kdbus.txt into DocBook man-pages for better readablity,
   and extend the documentation significantly. Requested by Michael
   Kerrisk and Christoph Hellwig.

 * Add a walk-through example for using the low-level ioctl API from
   userspace.

 * Consolidate some 'struct kdbus_cmd_*' types to make the API
   interface easier to grasp.

 * Drop 'struct kdbus_item_list'. The information stored in this
   struct was redundant as all ioctls report the returned size
   in the command struct already.

 * KDBUS_CMD_NAME_ACQUIRE now returns the KDBUS_NAME_IN_QUEUE flag
   in cmd->return_flags rather than modifying cmd->flags.

 * Get rid of the need for a 2nd pool slice at install time. This
   avoids pool fragmentation, message memory footprint and complexity.

 * Separate flags from attach_flags in struct kdbus_cmd_info.

 * Fix handling of messages with file descriptors with regard to
   monitor connections that don't accept file descriptors.

 * Revisited and reimplemented the quota logic. 50% are now always
   kept reserved for the connection to receive notification etc,
   and the rest is accounted per remote peer to avoid denial of
   service attacks.

 * Make use of new functions introduced with 4.0-rc1
   (vfs_iter_write(), {kstrdup,kfree}_const())

 * Some internal restructuring and cleanups.


Reasons why this should be done in the kernel, instead of userspace as
it is currently done today include the following:

 * Performance: Fewer process context switches, fewer copies, fewer
   syscalls, larger memory chunks via memfd.  This is really important
   for a whole class of userspace programs that are ported from other
   operating systems that are run on tiny ARM systems that rely on
   hundreds of thousands of messages passed at boot time, and at
   "critical" times in their user interaction loops. DBus is not used
   for performance sensitive applications because DBus is slow.
   We want to make it fast so we can finally use it for low-latency,
   high-throughput applications. A simple DBus method-call+reply takes
   200us on an up-to-date test machine, with kdbus it takes 8us (with
   UDS about 2us). If the packet size is increased from 8k to 128k,
   kdbus even beats UDS due to single-copy transfers.

 * Security: The peers which communicate do not have to trust each
   other, as the only trustworthy component in the game is the kernel
   which adds metadata and ensures that all data passed as payload is
   either copied or sealed, so that the receiver can parse the data
   without having to protect against changing memory while parsing
   buffers. Also, all the data transfer is controlled by the kernel,
   so that LSMs can track and control what is going on, without
   involving userspace. Because of the LSM issue, security people are
   much happier with this model than the current scheme of having to
   hook into dbus to mediate things.

 * More types of metadata can be attached to messages than in userspace

 * Semantics for apps with heavy data payloads (media apps, for
   instance) with optinal priority message dequeuing, and global
   message ordering. Some "crazy" people are playing with using kdbus
   for audio data in the system.  I'm not saying that this is the best
   model for this, but until now, there wasn't any other way to do this
   without having to create custom "buses", one for each application
   library.

 * Being in the kernel closes a lot of races which can't be fixed with
   the current userspace solutions.  For example, with kdbus, there is a
   way a client can disconnect from a bus, but do so only if no further
   messages present in its queue, which is crucial for implementing
   race-free "exit-on-idle" services

 * Eavesdropping on the kernel level, so privileged users can hook into
   the message stream without hacking support for that into their
   userspace processes

 * A number of smaller benefits: for example kdbus learned a way to peek
   full messages without dequeing them, which is really useful for
   logging metadata when handling bus-activation requests.

 * dbus-daemon is not available during early-boot or shutdown.

DBus marshaling is the de-facto standard in all major(!) Linux desktop
systems. It is well established and accepted by many DEs. It also
solves many other problems, including: policy, authentication /
authorization, well-known name registry, efficient broadcasts /
multicasts, peer discovery, bus discovery, metadata transmission, and
more.

It is a shame that we cannot use this well-established protocol for
low-latency applications. We, effectively, have to duplicate all this
code on custom UDS and other transports just because DBus is too slow.
kdbus tries to unify those efforts, so that we don't need multiple
policy implementations, name registries and peer discovery mechanisms.
Furthermore, kdbus implements comprehensive, yet optional, metadata
transmission that allows to identify and authenticate peers in a
race-free manner (which is *not* possible with UDS).

Also, kdbus provides a single transport bus with sequential message
numbering. If you use multiple channels, you cannot give any ordering
guarantees across peers (for instance, regarding parallel name-registry
changes).

Of course, some of the bits above could be implemented in userspace
alone, for example with more sophisticated memory management APIs, but
this is usually done by losing out on the other details.  For example,
for many of the memory management APIs, it's hard to not require the
communicating peers to fully trust each other.  And we _really_ don't
want peers to have to trust each other.

Another benefit of having this in the kernel, rather than as a userspace
daemon, is that you can now easily use the bus from the initrd, or up to
the very end when the system shuts down.  On current userspace D-Bus,
this is not really possible, as this requires passing the bus instance
around between initrd and the "real" system.  Such a transition of all
fds also requires keeping full state of what has already been read from
the connection fds.  kdbus makes this much simpler, as we can change the
ownership of the bus, just by passing one fd over from one part to the
other.

Given the theoretical advantages above, here are some real-world
examples:

 * The Tizen developers have been complaining about the high latency
   of DBus for polkit'ish policy queries. That's why their
   authentication framework uses custom UDS sockets (called 'Cynara').
   If a UI-interaction needs multiple authentication-queries, you don't
   want it to take multiple milliseconds, given that you usually want
   to render the result in the same frame.

 * PulseAudio doesn't use DBus for data transmission. They had to
   implement their own marshaling code, transport layer and so on, just
   because DBus1-latency is horrible. With kdbus, we can basically drop
   this code-duplication and unify the IPC layer. Same is true for
   Wayland, btw.

 * By moving broadcast-transmission into the kernel, we can use the
   time-slices of the sender to perform heavy operations. This is also
   true for policy decisions, etc. With a userspace daemon, we cannot
   perform operations in a time-slice of the caller. This makes DoS
   attacks much harder.

 * With priority-inheritance, we can do synchronous calls into trusted
   peers and let them optionally use our time-slice to perform the
   action. This allows syscall-like/binder-like method-calls into other
   processes. Without priority-inheritance, this is not possible in a
   secure manner (see 'priority-inheritance').

 * Logging-daemons often want to attach metadata to log-messages so
   debugging/filtering gets easier. If short-lived programs send
   log-messages, the destination peer might not be able to read such
   metadata from /proc, as the process might no longer be available at
   that time. Same is true for policy-decisions like polkit does. You
   cannot send off method-calls and exit. You have to wait for a reply,
   even though you might not even care for it. If you don't wait, the
   other side might not be able to verify your identity and as such
   reject the request.

 * Even though the dbus traffic on idle-systems might be low, this
   doesn't mean it's not significant at boot-times or under high-load.
   If you run a dbus-monitor of your choice, you will see there is an
   significant number of messages exchanged during VT-switches, startup,
   shutdown, suspend, wakeup, hotplugging and similar situations where
   lots of control-messages are exchanged. We don't want to spend
   hundreds of ms just to transmit those messages.


These patches can also be found in a git tree, the kdbus branch of
char-misc.git at:
        https://git.kernel.org/cgit/linux/kernel/git/gregkh/char-misc.git/


Daniel Mack (14):
  kdbus: add documentation
  kdbus: add uapi header file
  kdbus: add driver skeleton, ioctl entry points and utility functions
  kdbus: add connection pool implementation
  kdbus: add connection, queue handling and message validation code
  kdbus: add node and filesystem implementation
  kdbus: add code to gather metadata
  kdbus: add code for notifications and matches
  kdbus: add code for buses, domains and endpoints
  kdbus: add name registry implementation
  kdbus: add policy database implementation
  kdbus: add Makefile, Kconfig and MAINTAINERS entry
  kdbus: add walk-through user space example
  kdbus: add selftests

 Documentation/Makefile                            |    2 +-
 Documentation/ioctl/ioctl-number.txt              |    1 +
 Documentation/kdbus/Makefile                      |   30 +
 Documentation/kdbus/kdbus.bus.xml                 |  360 ++++
 Documentation/kdbus/kdbus.connection.xml          | 1252 ++++++++++++
 Documentation/kdbus/kdbus.endpoint.xml            |  436 ++++
 Documentation/kdbus/kdbus.fs.xml                  |  124 ++
 Documentation/kdbus/kdbus.item.xml                |  840 ++++++++
 Documentation/kdbus/kdbus.match.xml               |  553 +++++
 Documentation/kdbus/kdbus.message.xml             | 1277 ++++++++++++
 Documentation/kdbus/kdbus.name.xml                |  711 +++++++
 Documentation/kdbus/kdbus.policy.xml              |  406 ++++
 Documentation/kdbus/kdbus.pool.xml                |  320 +++
 Documentation/kdbus/kdbus.xml                     | 1012 ++++++++++
 Documentation/kdbus/stylesheet.xsl                |   16 +
 MAINTAINERS                                       |   13 +
 Makefile                                          |    1 +
 include/uapi/linux/Kbuild                         |    1 +
 include/uapi/linux/kdbus.h                        |  979 +++++++++
 include/uapi/linux/magic.h                        |    2 +
 init/Kconfig                                      |   12 +
 ipc/Makefile                                      |    2 +-
 ipc/kdbus/Makefile                                |   22 +
 ipc/kdbus/bus.c                                   |  560 ++++++
 ipc/kdbus/bus.h                                   |  101 +
 ipc/kdbus/connection.c                            | 2215 +++++++++++++++++++++
 ipc/kdbus/connection.h                            |  257 +++
 ipc/kdbus/domain.c                                |  296 +++
 ipc/kdbus/domain.h                                |   77 +
 ipc/kdbus/endpoint.c                              |  275 +++
 ipc/kdbus/endpoint.h                              |   67 +
 ipc/kdbus/fs.c                                    |  510 +++++
 ipc/kdbus/fs.h                                    |   28 +
 ipc/kdbus/handle.c                                |  617 ++++++
 ipc/kdbus/handle.h                                |   85 +
 ipc/kdbus/item.c                                  |  339 ++++
 ipc/kdbus/item.h                                  |   64 +
 ipc/kdbus/limits.h                                |   64 +
 ipc/kdbus/main.c                                  |  125 ++
 ipc/kdbus/match.c                                 |  559 ++++++
 ipc/kdbus/match.h                                 |   35 +
 ipc/kdbus/message.c                               |  616 ++++++
 ipc/kdbus/message.h                               |  133 ++
 ipc/kdbus/metadata.c                              | 1164 +++++++++++
 ipc/kdbus/metadata.h                              |   57 +
 ipc/kdbus/names.c                                 |  772 +++++++
 ipc/kdbus/names.h                                 |   74 +
 ipc/kdbus/node.c                                  |  910 +++++++++
 ipc/kdbus/node.h                                  |   84 +
 ipc/kdbus/notify.c                                |  248 +++
 ipc/kdbus/notify.h                                |   30 +
 ipc/kdbus/policy.c                                |  489 +++++
 ipc/kdbus/policy.h                                |   51 +
 ipc/kdbus/pool.c                                  |  728 +++++++
 ipc/kdbus/pool.h                                  |   46 +
 ipc/kdbus/queue.c                                 |  678 +++++++
 ipc/kdbus/queue.h                                 |   92 +
 ipc/kdbus/reply.c                                 |  259 +++
 ipc/kdbus/reply.h                                 |   68 +
 ipc/kdbus/util.c                                  |  201 ++
 ipc/kdbus/util.h                                  |   74 +
 samples/Makefile                                  |    3 +-
 samples/kdbus/.gitignore                          |    1 +
 samples/kdbus/Makefile                            |   10 +
 samples/kdbus/kdbus-api.h                         |  114 ++
 samples/kdbus/kdbus-workers.c                     | 1327 ++++++++++++
 tools/testing/selftests/Makefile                  |    1 +
 tools/testing/selftests/kdbus/.gitignore          |    3 +
 tools/testing/selftests/kdbus/Makefile            |   46 +
 tools/testing/selftests/kdbus/kdbus-enum.c        |   94 +
 tools/testing/selftests/kdbus/kdbus-enum.h        |   14 +
 tools/testing/selftests/kdbus/kdbus-test.c        |  923 +++++++++
 tools/testing/selftests/kdbus/kdbus-test.h        |   85 +
 tools/testing/selftests/kdbus/kdbus-util.c        | 1615 +++++++++++++++
 tools/testing/selftests/kdbus/kdbus-util.h        |  222 +++
 tools/testing/selftests/kdbus/test-activator.c    |  318 +++
 tools/testing/selftests/kdbus/test-attach-flags.c |  750 +++++++
 tools/testing/selftests/kdbus/test-benchmark.c    |  451 +++++
 tools/testing/selftests/kdbus/test-bus.c          |  175 ++
 tools/testing/selftests/kdbus/test-chat.c         |  122 ++
 tools/testing/selftests/kdbus/test-connection.c   |  616 ++++++
 tools/testing/selftests/kdbus/test-daemon.c       |   65 +
 tools/testing/selftests/kdbus/test-endpoint.c     |  341 ++++
 tools/testing/selftests/kdbus/test-fd.c           |  789 ++++++++
 tools/testing/selftests/kdbus/test-free.c         |   64 +
 tools/testing/selftests/kdbus/test-match.c        |  441 ++++
 tools/testing/selftests/kdbus/test-message.c      |  731 +++++++
 tools/testing/selftests/kdbus/test-metadata-ns.c  |  506 +++++
 tools/testing/selftests/kdbus/test-monitor.c      |  176 ++
 tools/testing/selftests/kdbus/test-names.c        |  194 ++
 tools/testing/selftests/kdbus/test-policy-ns.c    |  632 ++++++
 tools/testing/selftests/kdbus/test-policy-priv.c  | 1269 ++++++++++++
 tools/testing/selftests/kdbus/test-policy.c       |   80 +
 tools/testing/selftests/kdbus/test-sync.c         |  369 ++++
 tools/testing/selftests/kdbus/test-timeout.c      |   99 +
 95 files changed, 34063 insertions(+), 3 deletions(-)
 create mode 100644 Documentation/kdbus/Makefile
 create mode 100644 Documentation/kdbus/kdbus.bus.xml
 create mode 100644 Documentation/kdbus/kdbus.connection.xml
 create mode 100644 Documentation/kdbus/kdbus.endpoint.xml
 create mode 100644 Documentation/kdbus/kdbus.fs.xml
 create mode 100644 Documentation/kdbus/kdbus.item.xml
 create mode 100644 Documentation/kdbus/kdbus.match.xml
 create mode 100644 Documentation/kdbus/kdbus.message.xml
 create mode 100644 Documentation/kdbus/kdbus.name.xml
 create mode 100644 Documentation/kdbus/kdbus.policy.xml
 create mode 100644 Documentation/kdbus/kdbus.pool.xml
 create mode 100644 Documentation/kdbus/kdbus.xml
 create mode 100644 Documentation/kdbus/stylesheet.xsl
 create mode 100644 include/uapi/linux/kdbus.h
 create mode 100644 ipc/kdbus/Makefile
 create mode 100644 ipc/kdbus/bus.c
 create mode 100644 ipc/kdbus/bus.h
 create mode 100644 ipc/kdbus/connection.c
 create mode 100644 ipc/kdbus/connection.h
 create mode 100644 ipc/kdbus/domain.c
 create mode 100644 ipc/kdbus/domain.h
 create mode 100644 ipc/kdbus/endpoint.c
 create mode 100644 ipc/kdbus/endpoint.h
 create mode 100644 ipc/kdbus/fs.c
 create mode 100644 ipc/kdbus/fs.h
 create mode 100644 ipc/kdbus/handle.c
 create mode 100644 ipc/kdbus/handle.h
 create mode 100644 ipc/kdbus/item.c
 create mode 100644 ipc/kdbus/item.h
 create mode 100644 ipc/kdbus/limits.h
 create mode 100644 ipc/kdbus/main.c
 create mode 100644 ipc/kdbus/match.c
 create mode 100644 ipc/kdbus/match.h
 create mode 100644 ipc/kdbus/message.c
 create mode 100644 ipc/kdbus/message.h
 create mode 100644 ipc/kdbus/metadata.c
 create mode 100644 ipc/kdbus/metadata.h
 create mode 100644 ipc/kdbus/names.c
 create mode 100644 ipc/kdbus/names.h
 create mode 100644 ipc/kdbus/node.c
 create mode 100644 ipc/kdbus/node.h
 create mode 100644 ipc/kdbus/notify.c
 create mode 100644 ipc/kdbus/notify.h
 create mode 100644 ipc/kdbus/policy.c
 create mode 100644 ipc/kdbus/policy.h
 create mode 100644 ipc/kdbus/pool.c
 create mode 100644 ipc/kdbus/pool.h
 create mode 100644 ipc/kdbus/queue.c
 create mode 100644 ipc/kdbus/queue.h
 create mode 100644 ipc/kdbus/reply.c
 create mode 100644 ipc/kdbus/reply.h
 create mode 100644 ipc/kdbus/util.c
 create mode 100644 ipc/kdbus/util.h
 create mode 100644 samples/kdbus/.gitignore
 create mode 100644 samples/kdbus/Makefile
 create mode 100644 samples/kdbus/kdbus-api.h
 create mode 100644 samples/kdbus/kdbus-workers.c
 create mode 100644 tools/testing/selftests/kdbus/.gitignore
 create mode 100644 tools/testing/selftests/kdbus/Makefile
 create mode 100644 tools/testing/selftests/kdbus/kdbus-enum.c
 create mode 100644 tools/testing/selftests/kdbus/kdbus-enum.h
 create mode 100644 tools/testing/selftests/kdbus/kdbus-test.c
 create mode 100644 tools/testing/selftests/kdbus/kdbus-test.h
 create mode 100644 tools/testing/selftests/kdbus/kdbus-util.c
 create mode 100644 tools/testing/selftests/kdbus/kdbus-util.h
 create mode 100644 tools/testing/selftests/kdbus/test-activator.c
 create mode 100644 tools/testing/selftests/kdbus/test-attach-flags.c
 create mode 100644 tools/testing/selftests/kdbus/test-benchmark.c
 create mode 100644 tools/testing/selftests/kdbus/test-bus.c
 create mode 100644 tools/testing/selftests/kdbus/test-chat.c
 create mode 100644 tools/testing/selftests/kdbus/test-connection.c
 create mode 100644 tools/testing/selftests/kdbus/test-daemon.c
 create mode 100644 tools/testing/selftests/kdbus/test-endpoint.c
 create mode 100644 tools/testing/selftests/kdbus/test-fd.c
 create mode 100644 tools/testing/selftests/kdbus/test-free.c
 create mode 100644 tools/testing/selftests/kdbus/test-match.c
 create mode 100644 tools/testing/selftests/kdbus/test-message.c
 create mode 100644 tools/testing/selftests/kdbus/test-metadata-ns.c
 create mode 100644 tools/testing/selftests/kdbus/test-monitor.c
 create mode 100644 tools/testing/selftests/kdbus/test-names.c
 create mode 100644 tools/testing/selftests/kdbus/test-policy-ns.c
 create mode 100644 tools/testing/selftests/kdbus/test-policy-priv.c
 create mode 100644 tools/testing/selftests/kdbus/test-policy.c
 create mode 100644 tools/testing/selftests/kdbus/test-sync.c
 create mode 100644 tools/testing/selftests/kdbus/test-timeout.c
