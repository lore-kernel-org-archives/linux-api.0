From: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: [PATCH v2 00/13] Add kdbus implementation
Date: Thu, 20 Nov 2014 21:02:16 -0800
Message-ID: <1416546149-24799-1-git-send-email-gregkh@linuxfoundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: arnd-r2nGTMty4D4@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org, teg-B22kvLQNl6c@public.gmane.org, jkosina-AlSwsSmVLrQ@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org, dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

kdbus is a kernel-level IPC implementation that aims for resemblance to
the the protocol layer with the existing userspace D-Bus daemon while
enabling some features that couldn't be implemented before in userspace=
=2E

The documentation in the first patch in this series explains the
protocol and the API details.

This version has changed a lot since the first submission, based on the
review comments received, many thanks to everyone who took the time to
review the code and make suggestions.  Full details are below:

Reasons why this should be done in the kernel, instead of userspace as
it is currently done today include the following:

- performance: fewer process context switches, fewer copies, fewer
  syscalls, larger memory chunks via memfd.  This is really important
  for a whole class of userspace programs that are ported from other
  operating systems that are run on tiny ARM systems that rely on
  hundreds of thousands of messages passed at boot time, and at
  "critical" times in their user interaction loops.
- security: the peers which communicate do not have to trust each other=
,
  as the only trustworthy compoenent in the game is the kernel which
  adds metadata and ensures that all data passed as payload is either
  copied or sealed, so that the receiver can parse the data without
  having to protect against changing memory while parsing buffers.  Als=
o,
  all the data transfer is controlled by the kernel, so that LSMs can
  track and control what is going on, without involving userspace.
  Because of the LSM issue, security people are much happier with this
  model than the current scheme of having to hook into dbus to mediate
  things.
- more metadata can be attached to messages than in userspace
- semantics for apps with heavy data payloads (media apps, for instance=
)
  with optinal priority message dequeuing, and global message ordering.
  Some "crazy" people are playing with using kdbus for audio data in th=
e
  system.  I'm not saying that this is the best model for this, but
  until now, there wasn't any other way to do this without having to
  create custom "busses", one for each application library.
- being in the kernle closes a lot of races which can't be fixed with
  the current userspace solutions.  For example, with kdbus, there is a
  way a client can disconnect from a bus, but do so only if no further
  messages present in its queue, which is crucial for implementing
  race-free "exit-on-idle" services
- eavesdropping on the kernel level, so privileged users can hook into
  the message stream without hacking support for that into their
  userspace processes
- a number of smaller benefits: for example kdbus learned a way to peek
  full messages without dequeing them, which is really useful for
  logging metadata when handling bus-activation requests.

Of course, some of the bits above could be implemented in userspace
alone, for example with more sophisticated memory management APIs, but
this is usually done by losing out on the other details.  For example,
for many of the memory management APIs, it's hard to not require the
communicating peers to fully trust each other.  And we _really_ don't
want peers to have to trust each other.

Another benefit of having this in the kernel, rather than as a userspac=
e
daemon, is that you can now easily use the bus from the initrd, or up t=
o
the very end when the system shuts down.  On current userspace D-Bus,
this is not really possible, as this requires passing the bus instance
around between initrd and the "real" system.  Such a transition of all
fds also requires keeping full state of what has already been read from
the connection fds.  kdbus makes this much simpler, as we can change th=
e
ownership of the bus, just by passing one fd over from one part to the
other.

Regarding binder: binder and kdbus follow very different design
concepts.  Binder implies the use of thread-pools to dispatch incoming
method calls.  This is a very efficient scheme, and completely natural
in programming languages like Java.  On most Linux programs, however,
there's a much stronger focus on central poll() loops that dispatch all
sources a program cares about.  kdbus is much more usable in such
environments, as it doesn't enforce a threading model, and it is happy
with serialized dispatching.  In fact, this major difference had an
effect on much of the design decisions: binder does not guarantee globa=
l
message ordering due to the parallel dispatching in the thread-pools,
but  kdbus does.  Moreover, there's also a difference in the way messag=
e
handling.  In kdbus, every message is basically taken and dispatched as
one blob, while in binder, continious connections to other peers are
created, which are then used to send messages on.  Hence, the models ar=
e
quite different, and they serve different needs.  I believe that the
D-Bus/kdbus model is more compatible and friendly with how Linux
programs are usually implemented.

This can also be found in a git tree, the kdbus branch of char-misc.git=
 at:
        https://git.kernel.org/cgit/linux/kernel/git/gregkh/char-misc.g=
it/

Changes since RFC v1:

  * Most notably, kdbus exposes its control files, buses and endpoints
    via an own file system now, called kdbusfs.

     * Each time a file system of this type is mounted, a new kdbus
       domain is created.

     * By default, kdbus is expected to be mounted in /sys/fs/kdbus

     * The layout inside each mount point is the same as before, except
       that domains are not hierarchically nested anymore.

     * Domains are therefore also unnamed now.

     * Unmounting a kdbusfs will automatically also destroy the
       associated domain.

     * Hence, the action of creating a kdbus domain is now as
       privileged as mounting a file system.

     * This way, we can get around creating dev nodes for everything,
       which is last but not least something that is not limited by
       20-bit minor numbers.

  * Rework the metadata attachment logic to address concerns raised by
    Andy Lutomirsky and Alan Cox:

     * Split the attach_flags in kdbus_cmd_hello into two parts,
       attach_flags_send and attach_flags_recv. Also, split the
       existing KDBUS_ITEM_ATTACH_FLAGS into
       KDBUS_ITEM_ATTACH_FLAGS_SEND and KDBUS_ITEM_ATTACH_FLAGS_RECV,
       and allow updating both connection details through
       KDBUS_CMD_CONN_UPDATE.

     * Only attach metadata to the final message in the receiver's pool
       if both the sender's attach_flags_send and the receiver's
       attach_flags_recv bit are set.

     * Add an optional metadata mask to the bus during its creation, so
       bus owners can denote their minimal requirements of metadata to
       be attached by connections of the bus.

  * Namespaces are now pinned by a domain at its creation time, and
    metadata items are automatically translated into these namespaces.
    Unless that cannot be done (currently only capabilities), in which
    case the items are dropped. For hide_pid enabled domains, drop all
    items except for such not revealing anything about the task.

  * Capabilities are now only checked at open() time, and the
    information is cached for the lifetime of a file descriptor.
    Reported by Eric W. Biederman, Andy Lutomirski and Thomas Gleixner.

  * Make functions that create new objects return the newly allocated
    memory directly, rather than in a referenced function arguments.
    That implies using ERR_PTR/PTR_ERR logic in many areas. Requested b=
y
    Al Viro.

  * Rename two details in kdbus.h to not overload the term 'name' too
    much:

     KDBUS_ITEM_CONN_NAME	=E2=86=92 KDBUS_ITEM_CONN_DESCRIPTION
     KDBUS_ATTACH_CONN_NAME	=E2=86=92 KDBUS_ATTACH_CONN_DESCRIPTION

  * Documentation fixes, by Peter Meerwald and others.

  * Some memory leaks plugged, and another match test added, by
    Rui Miguel Silva

  * Per-user message count quota logic fixed, and new test added.
    By John de la Garza.

  * More test code for CONN_INFO ioctl

  * Added a kdbus_node object embedded by domains, endpoints and buses
    to track children in a generic way. A kdbus_node is always exposed
    as inode in kdbusfs.

  * Add a new attach flags constant called _KDBUS_ATTACH_ANY (~0)
    which automatically degrades to _KDBUS_ATTACH_ALL in the kernel.
    That way, old clients can opt-in for whethever newer kernels might
    offer to send.

  * Use #defines rather than an enum for the ioctl signatures, so when
    new ones are added, usespace can use #ifdeffery to determine the
    function set at compile time. Suggested by Arnd Bergmann.

  * Moved the driver to ipc/kdbus, as suggested by Arnd Bergmann.

Daniel Mack (13):
  kdbus: add documentation
  kdbus: add header file
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
  kdbus: add selftests

 Documentation/ioctl/ioctl-number.txt             |    1 +
 Documentation/kdbus.txt                          | 1837 ++++++++++++++=
+++++++
 MAINTAINERS                                      |   12 +
 include/uapi/linux/Kbuild                        |    1 +
 include/uapi/linux/kdbus.h                       |  933 +++++++++++
 include/uapi/linux/magic.h                       |    1 +
 init/Kconfig                                     |   12 +
 ipc/Makefile                                     |    2 +-
 ipc/kdbus/Makefile                               |   21 +
 ipc/kdbus/bus.c                                  |  459 ++++++
 ipc/kdbus/bus.h                                  |   98 ++
 ipc/kdbus/connection.c                           | 1838 ++++++++++++++=
++++++++
 ipc/kdbus/connection.h                           |  188 +++
 ipc/kdbus/domain.c                               |  349 ++++
 ipc/kdbus/domain.h                               |   84 +
 ipc/kdbus/endpoint.c                             |  497 ++++++
 ipc/kdbus/endpoint.h                             |   91 ++
 ipc/kdbus/fs.c                                   |  417 +++++
 ipc/kdbus/fs.h                                   |   22 +
 ipc/kdbus/handle.c                               |  993 ++++++++++++
 ipc/kdbus/handle.h                               |   20 +
 ipc/kdbus/item.c                                 |  258 +++
 ipc/kdbus/item.h                                 |   41 +
 ipc/kdbus/limits.h                               |   77 +
 ipc/kdbus/main.c                                 |   59 +
 ipc/kdbus/match.c                                |  524 ++++++
 ipc/kdbus/match.h                                |   31 +
 ipc/kdbus/message.c                              |  444 ++++++
 ipc/kdbus/message.h                              |   75 +
 ipc/kdbus/metadata.c                             |  698 ++++++++
 ipc/kdbus/metadata.h                             |   38 +
 ipc/kdbus/names.c                                |  921 +++++++++++
 ipc/kdbus/names.h                                |   81 +
 ipc/kdbus/node.c                                 |  872 ++++++++++
 ipc/kdbus/node.h                                 |   86 +
 ipc/kdbus/notify.c                               |  235 +++
 ipc/kdbus/notify.h                               |   29 +
 ipc/kdbus/policy.c                               |  629 ++++++++
 ipc/kdbus/policy.h                               |   61 +
 ipc/kdbus/pool.c                                 |  722 +++++++++
 ipc/kdbus/pool.h                                 |   44 +
 ipc/kdbus/queue.c                                |  608 +++++++
 ipc/kdbus/queue.h                                |   93 ++
 ipc/kdbus/util.c                                 |  166 ++
 ipc/kdbus/util.h                                 |  103 ++
 tools/testing/selftests/Makefile                 |    1 +
 tools/testing/selftests/kdbus/.gitignore         |   11 +
 tools/testing/selftests/kdbus/Makefile           |   45 +
 tools/testing/selftests/kdbus/kdbus-enum.c       |   94 ++
 tools/testing/selftests/kdbus/kdbus-enum.h       |   14 +
 tools/testing/selftests/kdbus/kdbus-test.c       |  546 +++++++
 tools/testing/selftests/kdbus/kdbus-test.h       |   81 +
 tools/testing/selftests/kdbus/kdbus-util.c       | 1240 ++++++++++++++=
+
 tools/testing/selftests/kdbus/kdbus-util.h       |  143 ++
 tools/testing/selftests/kdbus/test-activator.c   |  317 ++++
 tools/testing/selftests/kdbus/test-benchmark.c   |  409 +++++
 tools/testing/selftests/kdbus/test-bus.c         |  130 ++
 tools/testing/selftests/kdbus/test-chat.c        |  123 ++
 tools/testing/selftests/kdbus/test-connection.c  |  501 ++++++
 tools/testing/selftests/kdbus/test-daemon.c      |   66 +
 tools/testing/selftests/kdbus/test-endpoint.c    |  221 +++
 tools/testing/selftests/kdbus/test-fd.c          |  664 ++++++++
 tools/testing/selftests/kdbus/test-free.c        |   34 +
 tools/testing/selftests/kdbus/test-match.c       |  437 +++++
 tools/testing/selftests/kdbus/test-message.c     |  371 +++++
 tools/testing/selftests/kdbus/test-metadata-ns.c |  258 +++
 tools/testing/selftests/kdbus/test-monitor.c     |  156 ++
 tools/testing/selftests/kdbus/test-names.c       |  184 +++
 tools/testing/selftests/kdbus/test-policy-ns.c   |  622 ++++++++
 tools/testing/selftests/kdbus/test-policy-priv.c | 1168 ++++++++++++++
 tools/testing/selftests/kdbus/test-policy.c      |   81 +
 tools/testing/selftests/kdbus/test-race.c        |  313 ++++
 tools/testing/selftests/kdbus/test-sync.c        |  241 +++
 tools/testing/selftests/kdbus/test-timeout.c     |   97 ++
 74 files changed, 23338 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/kdbus.txt
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
 create mode 100644 ipc/kdbus/util.c
 create mode 100644 ipc/kdbus/util.h
 create mode 100644 tools/testing/selftests/kdbus/.gitignore
 create mode 100644 tools/testing/selftests/kdbus/Makefile
 create mode 100644 tools/testing/selftests/kdbus/kdbus-enum.c
 create mode 100644 tools/testing/selftests/kdbus/kdbus-enum.h
 create mode 100644 tools/testing/selftests/kdbus/kdbus-test.c
 create mode 100644 tools/testing/selftests/kdbus/kdbus-test.h
 create mode 100644 tools/testing/selftests/kdbus/kdbus-util.c
 create mode 100644 tools/testing/selftests/kdbus/kdbus-util.h
 create mode 100644 tools/testing/selftests/kdbus/test-activator.c
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
 create mode 100644 tools/testing/selftests/kdbus/test-race.c
 create mode 100644 tools/testing/selftests/kdbus/test-sync.c
 create mode 100644 tools/testing/selftests/kdbus/test-timeout.c
