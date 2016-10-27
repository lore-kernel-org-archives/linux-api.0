From: Michael Kerrisk <mtk.manpages@gmail.com>
Subject: Re: [RFC v1 00/14] Bus1 Kernel Message Bus
Date: Thu, 27 Oct 2016 13:10:14 +0200
Message-ID: <CAHO5Pa0Ga9ba+si_rZxDhj05hCSJO4vDvFbP3_ttoz51046xZg@mail.gmail.com>
References: <20161026191810.12275-1-dh.herrmann@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20161026191810.12275-1-dh.herrmann@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: David Herrmann <dh.herrmann@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>, Jiri Kosina <jikos@kernel.org>, Greg KH <greg@kroah.com>, Hannes Reinecke <hare@suse.com>, Steven Rostedt <rostedt@goodmis.org>, Arnd Bergmann <arnd@arndb.de>, Tom Gundersen <teg@jklm.no>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, Linux API <linux-api@vger.kernel.org>, Michael Kerrisk <mtk.manpages@gmail.com>
List-Id: linux-api@vger.kernel.org

[CC += linuux-api]@vger.kernel.org

Hi David,

Could you please CC linux-api@ on all future iterations of this patch!

Cheers,

Michael



On Wed, Oct 26, 2016 at 9:17 PM, David Herrmann <dh.herrmann@gmail.com> wrote:
> Hi
>
> This proposal introduces bus1.ko, a kernel messaging bus. This is not a request
> for inclusion, yet. It is rather an initial draft and a Request For Comments.
>
> While bus1 emerged out of the kdbus project, bus1 was started from scratch and
> the concepts have little in common. In a nutshell, bus1 provides a
> capability-based IPC system, similar in nature to Android Binder, Cap'n Proto,
> and seL4. The module is completely generic and does neither require nor mandate
> a user-space counter-part.
>
>  o Description
>
>     Bus1 is a local IPC system, which provides a decentralized infrastructure to
>     share objects between local peers. The main building blocks are nodes and
>     handles. Nodes represent objects of a local peer, while handles represent
>     descriptors that point to a node. Nodes can be created and destroyed by any
>     peer, and they will always remain owned by their respective creator. Handles
>     on the other hand, are used to refer to nodes and can be passed around with
>     messages as auxiliary data. Whenever a handle is transferred, the receiver
>     will get its own handle allocated, pointing to the same node as the original
>     handle.
>
>     Any peer can send messages directed at one of their handles. This will
>     transfer the message to the owner of the node the handle points to. If a
>     peer does not posess a handle to a given node, it will not be able to send a
>     message to that node. That is, handles provide exclusive access management.
>     Anyone that somehow acquired a handle to a node is privileged to further
>     send this handle to other peers. As such, access management is transitive.
>     Once a peer acquired a handle, it cannot be revoked again. However, a node
>     owner can, at anytime, destroy a node. This will effectively unbind all
>     existing handles to that node on any peer, notifying each one of the
>     destruction.
>
>     Unlike nodes and handles, peers cannot be addressed directly. In fact, peers
>     are completely disconnected entities. A peer is merely an anchor of a set of
>     nodes and handles, including an incoming message queue for any of those.
>     Whether multiple nodes are all part of the same peer, or part of different
>     peers does not affect the remote view of those. Peers solely exist as
>     management entity and command dispatcher to local processes.
>
>     The set of actors on a system is completely decentralized. There is no
>     global component involved that provides a central registry or discovery
>     mechanism. Furthermore, communication between peers only involves those
>     peers, and does not affect any other peer in any way. No global
>     communication lock is taken. However, any communication is still globally
>     ordered, including unicasts, multicasts, and notifications.
>
>  o Prior Art
>
>     The concepts behind bus1 are almost identical to capability systems like
>     Android Binder, Google Mojo, Cap'n Proto, seL4, and more. Bus1 differs from
>     them by supporting Global Ordering, Multicasts, Resource Accounting, No
>     Global Locking, No Global Context.
>
>     While the bus1 UAPI does not expose all features (like soft-references as
>     supported by Binder), the in-kernel code includes support for it. Multiple
>     UAPIs can be supported on top of the in-kernel bus1 code, including support
>     for the Binder UAPI. Efforts on this are still on-going.
>
>  o Documentation
>
>     The first patch in this series provides the bus1(7) man-page. It explains
>     all concepts in bus1 in more detail. Furthermore, it describes the API that
>     is available on bus1 file descriptors. The pre-compiled man-page is
>     available at:
>
>         http://www.bus1.org/bus1.html
>
>     There is also a great bunch of in-source documentation available. All
>     cross-source-file APIs have KernelDoc annotations. Furthermore, we have an
>     introduction for each subsystem, to be found in the header files. The total
>     number in lines of code for bus1 is roughly ~4.5k. The remaining ~5k LOC
>     are comments and documentation.
>
>  o Upstream
>
>     The upstream development repository is available on github:
>
>         http://github.com/bus1/bus1
>
>     It is an out-of-tree repository that allows easy and fast development of
>     new bus1 features. The in-tree integration repository is available at:
>
>         http://github.com/bus1/linux
>
>  o Conferences
>
>     Tom and I will be attending Linux Plumbers Conf next week. Please do not
>     hesitate to contact us there in person. There will also be a presentation
>     [1] of bus1 on the last day of the conference.
>
> Thanks
> Tom & David
>
> [1] https://www.linuxplumbersconf.org/2016/ocw/proposals/3819
>
> Tom Gundersen (14):
>   bus1: add bus1(7) man-page
>   bus1: provide stub cdev /dev/bus1
>   bus1: util - active reference utility library
>   bus1: util - fixed list utility library
>   bus1: util - pool utility library
>   bus1: util - queue utility library
>   bus1: tracking user contexts
>   bus1: implement peer management context
>   bus1: provide transaction context for multicasts
>   bus1: add handle management
>   bus1: implement message transmission
>   bus1: hook up file-operations
>   bus1: limit and protect resources
>   bus1: basic user-space kselftests
>
>  Documentation/bus1/.gitignore             |    2 +
>  Documentation/bus1/Makefile               |   41 +
>  Documentation/bus1/bus1.xml               |  833 +++++++++++++++++++++
>  Documentation/bus1/stylesheet.xsl         |   16 +
>  include/uapi/linux/bus1.h                 |  138 ++++
>  init/Kconfig                              |   17 +
>  ipc/Makefile                              |    1 +
>  ipc/bus1/Makefile                         |   16 +
>  ipc/bus1/handle.c                         |  823 ++++++++++++++++++++
>  ipc/bus1/handle.h                         |  312 ++++++++
>  ipc/bus1/main.c                           |  146 ++++
>  ipc/bus1/main.h                           |   88 +++
>  ipc/bus1/message.c                        |  656 ++++++++++++++++
>  ipc/bus1/message.h                        |  171 +++++
>  ipc/bus1/peer.c                           | 1163 +++++++++++++++++++++++++++++
>  ipc/bus1/peer.h                           |  163 ++++
>  ipc/bus1/security.h                       |   45 ++
>  ipc/bus1/tests.c                          |   19 +
>  ipc/bus1/tests.h                          |   32 +
>  ipc/bus1/tx.c                             |  360 +++++++++
>  ipc/bus1/tx.h                             |  102 +++
>  ipc/bus1/user.c                           |  628 ++++++++++++++++
>  ipc/bus1/user.h                           |  140 ++++
>  ipc/bus1/util.c                           |  214 ++++++
>  ipc/bus1/util.h                           |  141 ++++
>  ipc/bus1/util/active.c                    |  419 +++++++++++
>  ipc/bus1/util/active.h                    |  154 ++++
>  ipc/bus1/util/flist.c                     |  116 +++
>  ipc/bus1/util/flist.h                     |  202 +++++
>  ipc/bus1/util/pool.c                      |  572 ++++++++++++++
>  ipc/bus1/util/pool.h                      |  164 ++++
>  ipc/bus1/util/queue.c                     |  445 +++++++++++
>  ipc/bus1/util/queue.h                     |  351 +++++++++
>  tools/testing/selftests/bus1/.gitignore   |    2 +
>  tools/testing/selftests/bus1/Makefile     |   19 +
>  tools/testing/selftests/bus1/bus1-ioctl.h |  111 +++
>  tools/testing/selftests/bus1/test-api.c   |  532 +++++++++++++
>  tools/testing/selftests/bus1/test-io.c    |  198 +++++
>  tools/testing/selftests/bus1/test.h       |  114 +++
>  39 files changed, 9666 insertions(+)
>  create mode 100644 Documentation/bus1/.gitignore
>  create mode 100644 Documentation/bus1/Makefile
>  create mode 100644 Documentation/bus1/bus1.xml
>  create mode 100644 Documentation/bus1/stylesheet.xsl
>  create mode 100644 include/uapi/linux/bus1.h
>  create mode 100644 ipc/bus1/Makefile
>  create mode 100644 ipc/bus1/handle.c
>  create mode 100644 ipc/bus1/handle.h
>  create mode 100644 ipc/bus1/main.c
>  create mode 100644 ipc/bus1/main.h
>  create mode 100644 ipc/bus1/message.c
>  create mode 100644 ipc/bus1/message.h
>  create mode 100644 ipc/bus1/peer.c
>  create mode 100644 ipc/bus1/peer.h
>  create mode 100644 ipc/bus1/security.h
>  create mode 100644 ipc/bus1/tests.c
>  create mode 100644 ipc/bus1/tests.h
>  create mode 100644 ipc/bus1/tx.c
>  create mode 100644 ipc/bus1/tx.h
>  create mode 100644 ipc/bus1/user.c
>  create mode 100644 ipc/bus1/user.h
>  create mode 100644 ipc/bus1/util.c
>  create mode 100644 ipc/bus1/util.h
>  create mode 100644 ipc/bus1/util/active.c
>  create mode 100644 ipc/bus1/util/active.h
>  create mode 100644 ipc/bus1/util/flist.c
>  create mode 100644 ipc/bus1/util/flist.h
>  create mode 100644 ipc/bus1/util/pool.c
>  create mode 100644 ipc/bus1/util/pool.h
>  create mode 100644 ipc/bus1/util/queue.c
>  create mode 100644 ipc/bus1/util/queue.h
>  create mode 100644 tools/testing/selftests/bus1/.gitignore
>  create mode 100644 tools/testing/selftests/bus1/Makefile
>  create mode 100644 tools/testing/selftests/bus1/bus1-ioctl.h
>  create mode 100644 tools/testing/selftests/bus1/test-api.c
>  create mode 100644 tools/testing/selftests/bus1/test-io.c
>  create mode 100644 tools/testing/selftests/bus1/test.h
>
> --
> 2.10.1
>



-- 
Michael Kerrisk Linux man-pages maintainer;
http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface", http://blog.man7.org/
