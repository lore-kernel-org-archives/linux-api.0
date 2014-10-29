From: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: [PATCH 00/12] Add kdbus implementation
Date: Wed, 29 Oct 2014 15:00:44 -0700
Message-ID: <1414620056-6675-1-git-send-email-gregkh@linuxfoundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, marcel-kz+m5ild9QBg9hUCZPvPmw@public.gmane.org, desrt-0xnayjDhYQY@public.gmane.org, hadess-0MeiytkfxGOsTnJN9+BGXg@public.gmane.org, dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, simon.mcvittie-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org, daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org, alban.crequy-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org, javier.martinez-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org, teg-B22kvLQNl6c@public.gmane.org
List-Id: linux-api@vger.kernel.org

kdbus is a kernel-level IPC implementation that aims for resemblance to
the the protocol layer with the existing userspace D-Bus daemon while
enabling some features that couldn't be implemented before in userspace=
=2E

The documentation added by the first patch in this series is meant to
explain all protocol and API details comprehensively, but here's a ters=
e
list of the kdbus key features:

 * Implemented as a char driver, which creates devices on demand when
   they are created.

 * Message transfer over shared memory areas in each of the peer's
   task to avoid unnecessary extra data copies during message exchanges=
=2E

 * Optional passing of file descriptors and sealed memfds along with
   messages.

 * No demarshalling of any message content from inside the kernel;
   the driver stays entirely agnostic to the transported payload.

 * Support for multiple domains, completely separated from each other,
   allowing multiple virtualized instances to be used at the same time.

 * Support for peer-to-peer unicast and multicast messages.

 * Attachment of trustable metadata to each message on demand, such as
   the sending peer's timestamp, creds, auxgroups, comm, exe, cmdline,
   cgroup path, capabilities, security label, audit information, etc,
   each taken at the time the sender issued the ioctl to send the
   message. Which of those are actually recorded and attached is
   controlled by the receiving peer.

 * Bloom filters as measure to pre-filter broadcast messages and to
   mitigate unnecessary task wakeups. On the side kernel, however, this
   is just a cheap &-operation, hash functions are left to be
   implemented by userspace.

 * Optional message dequeuing by priority, allowing multiple types of
   payloads of different priorities to be transported over the same
   connection.

 * Global, domain-wide guaranteed message ordering.

 * Eavesdropping for buses for debugging

 * Adressing of remote peers by their numerical unique ID, or by a
   well-known name.

 * Built-in name registry for atomic name ownership lookups, claims,
   releases and take-overs from one peer to another.

 * Simple policy database to restrict peers from seeing or talking to
   each other, and to control name ownership.

 * Custom bus endpoints in addition to the default ones. Those allow
   to upload extra policy rules, and can act as a protocol-filtering
   bus firewall.

 * Kernel-generated notifications on connected and disconnected peers,
   claimed and released well-known-names, and exceeded reply timeouts.

This is the first submission of kdbus by the kernel community.  It was
developed in its own repository for well more than a year, and has been
tested on x64-64, i686 and ARM architectures in various use cases. The
driver is totally non-intrusive and doesn't touch a single line of
existing kernel code.

kdbus has been worked on collaboratively by many people contributing
code and suggestions during its development. Below is a list of all
involved individuals, in alphabetical order.

  Alban Crequy, Arnd Bergmann, Christian S., Daniel Kowalski,
  Daniel Mack, David Herrmann, Djalal Harouni, Govindarajulu
  Varadarajan, Greg Kroah-Hartman, Harald Hoyer, Hristo Venev,
  Ingo van Lil, Jacek Janczyk, Jason A. Donenfeld, John de
  la Garza, Kay Sievers, Lennart Poettering, Lukasz Skalski,
  Maciej Wereski, Marc-Antoine Perennou, Marcel Holtmann,
  Michal Eljasiewicz, Michele Curti, Przemyslaw Kedzierski,
  Radoslaw Pajak, Ryan Lortie, Simon McVittie, Simon Peeters,
  Stefan Beller, Ted Feng, Tejun Heo, Tero Roponen, Thomas
  Andersen, Torstein Huseb=C3=B8, Vasiliy Balyasnyy.

Some statistics: the driver itself has a little more than 11k lines,
with ~25% of the lines being comments. Our test suite weights in for
another 6k lines, and the API documentation file currently has >1800
lines. The loaded kernel module has ~70kB of text size.

Patches #3 to #10 carry the driver implementation in digestable bites,
but only #11 adds the Makefile to actually compile them. That division
can of course be changed, and the patches be squashed and reordered
later.

The rest should be pretty much self-explanatory - the individual commit
logs and Documentation/kdbus.txt contain detailed information on the
driver's inner life.

While we consider the kernel API/ABI mostly stable at this point, we're
still in the process of fixing up some ends in userspace, such as
compatibility layers and the D-Bus spec, but that shouldn't affect the
kernel side much anymore.

As for maintainership, Daniel Mack, David Herrmann, Djalal Harouni and
myself would be taking care for it in the future.

I'll also be keeping this in a git tree, the kdbus branch of
char-misc.git at:
	https://git.kernel.org/cgit/linux/kernel/git/gregkh/char-misc.git/

thanks,

greg k-h

Daniel Mack (12):
  kdbus: add documentation
  kdbus: add header file
  kdbus: add driver skeleton, ioctl entry points and utility functions
  kdbus: add connection pool implementation
  kdbus: add connection, queue handling and message validation code
  kdbus: add code to gather metadata
  kdbus: add code for notifications and matches
  kdbus: add code for buses, domains and endpoints
  kdbus: add name registry implementation
  kdbus: add policy database implementation
  kdbus: add Makefile, Kconfig and MAINTAINERS entry
  kdbus: add selftests

 Documentation/ioctl/ioctl-number.txt             |    1 +
 Documentation/kdbus.txt                          | 1815 ++++++++++++++=
++++++++
 MAINTAINERS                                      |   12 +
 drivers/misc/Kconfig                             |    1 +
 drivers/misc/Makefile                            |    1 +
 drivers/misc/kdbus/Kconfig                       |   11 +
 drivers/misc/kdbus/Makefile                      |   19 +
 drivers/misc/kdbus/bus.c                         |  450 ++++++
 drivers/misc/kdbus/bus.h                         |  107 ++
 drivers/misc/kdbus/connection.c                  | 1751 ++++++++++++++=
+++++++
 drivers/misc/kdbus/connection.h                  |  177 +++
 drivers/misc/kdbus/domain.c                      |  477 ++++++
 drivers/misc/kdbus/domain.h                      |  105 ++
 drivers/misc/kdbus/endpoint.c                    |  567 +++++++
 drivers/misc/kdbus/endpoint.h                    |   94 ++
 drivers/misc/kdbus/handle.c                      | 1221 ++++++++++++++=
+
 drivers/misc/kdbus/handle.h                      |   46 +
 drivers/misc/kdbus/item.c                        |  256 +++
 drivers/misc/kdbus/item.h                        |   40 +
 drivers/misc/kdbus/limits.h                      |   77 +
 drivers/misc/kdbus/main.c                        |   70 +
 drivers/misc/kdbus/match.c                       |  521 +++++++
 drivers/misc/kdbus/match.h                       |   30 +
 drivers/misc/kdbus/message.c                     |  420 +++++
 drivers/misc/kdbus/message.h                     |   72 +
 drivers/misc/kdbus/metadata.c                    |  626 ++++++++
 drivers/misc/kdbus/metadata.h                    |   51 +
 drivers/misc/kdbus/names.c                       |  920 +++++++++++
 drivers/misc/kdbus/names.h                       |   81 +
 drivers/misc/kdbus/notify.c                      |  235 +++
 drivers/misc/kdbus/notify.h                      |   28 +
 drivers/misc/kdbus/policy.c                      |  617 ++++++++
 drivers/misc/kdbus/policy.h                      |   60 +
 drivers/misc/kdbus/pool.c                        |  728 +++++++++
 drivers/misc/kdbus/pool.h                        |   43 +
 drivers/misc/kdbus/queue.c                       |  602 +++++++
 drivers/misc/kdbus/queue.h                       |   82 +
 drivers/misc/kdbus/util.c                        |  108 ++
 drivers/misc/kdbus/util.h                        |   94 ++
 include/uapi/linux/kdbus.h                       |  918 +++++++++++
 tools/testing/selftests/Makefile                 |    1 +
 tools/testing/selftests/kdbus/.gitignore         |   11 +
 tools/testing/selftests/kdbus/Makefile           |   46 +
 tools/testing/selftests/kdbus/kdbus-enum.c       |   90 ++
 tools/testing/selftests/kdbus/kdbus-enum.h       |   14 +
 tools/testing/selftests/kdbus/kdbus-test.c       |  474 ++++++
 tools/testing/selftests/kdbus/kdbus-test.h       |   79 +
 tools/testing/selftests/kdbus/kdbus-util.c       | 1173 ++++++++++++++
 tools/testing/selftests/kdbus/kdbus-util.h       |  139 ++
 tools/testing/selftests/kdbus/test-activator.c   |  317 ++++
 tools/testing/selftests/kdbus/test-benchmark.c   |  417 +++++
 tools/testing/selftests/kdbus/test-bus.c         |  117 ++
 tools/testing/selftests/kdbus/test-chat.c        |  123 ++
 tools/testing/selftests/kdbus/test-connection.c  |  258 +++
 tools/testing/selftests/kdbus/test-daemon.c      |   66 +
 tools/testing/selftests/kdbus/test-domain.c      |   65 +
 tools/testing/selftests/kdbus/test-endpoint.c    |  221 +++
 tools/testing/selftests/kdbus/test-fd.c          |  473 ++++++
 tools/testing/selftests/kdbus/test-free.c        |   34 +
 tools/testing/selftests/kdbus/test-match.c       |  385 +++++
 tools/testing/selftests/kdbus/test-message.c     |  126 ++
 tools/testing/selftests/kdbus/test-metadata-ns.c |  236 +++
 tools/testing/selftests/kdbus/test-monitor.c     |  156 ++
 tools/testing/selftests/kdbus/test-names.c       |  184 +++
 tools/testing/selftests/kdbus/test-policy-ns.c   |  578 +++++++
 tools/testing/selftests/kdbus/test-policy-priv.c | 1168 ++++++++++++++
 tools/testing/selftests/kdbus/test-policy.c      |   81 +
 tools/testing/selftests/kdbus/test-race.c        |  313 ++++
 tools/testing/selftests/kdbus/test-sync.c        |  241 +++
 tools/testing/selftests/kdbus/test-timeout.c     |   97 ++
 70 files changed, 21217 insertions(+)
 create mode 100644 Documentation/kdbus.txt
 create mode 100644 drivers/misc/kdbus/Kconfig
 create mode 100644 drivers/misc/kdbus/Makefile
 create mode 100644 drivers/misc/kdbus/bus.c
 create mode 100644 drivers/misc/kdbus/bus.h
 create mode 100644 drivers/misc/kdbus/connection.c
 create mode 100644 drivers/misc/kdbus/connection.h
 create mode 100644 drivers/misc/kdbus/domain.c
 create mode 100644 drivers/misc/kdbus/domain.h
 create mode 100644 drivers/misc/kdbus/endpoint.c
 create mode 100644 drivers/misc/kdbus/endpoint.h
 create mode 100644 drivers/misc/kdbus/handle.c
 create mode 100644 drivers/misc/kdbus/handle.h
 create mode 100644 drivers/misc/kdbus/item.c
 create mode 100644 drivers/misc/kdbus/item.h
 create mode 100644 drivers/misc/kdbus/limits.h
 create mode 100644 drivers/misc/kdbus/main.c
 create mode 100644 drivers/misc/kdbus/match.c
 create mode 100644 drivers/misc/kdbus/match.h
 create mode 100644 drivers/misc/kdbus/message.c
 create mode 100644 drivers/misc/kdbus/message.h
 create mode 100644 drivers/misc/kdbus/metadata.c
 create mode 100644 drivers/misc/kdbus/metadata.h
 create mode 100644 drivers/misc/kdbus/names.c
 create mode 100644 drivers/misc/kdbus/names.h
 create mode 100644 drivers/misc/kdbus/notify.c
 create mode 100644 drivers/misc/kdbus/notify.h
 create mode 100644 drivers/misc/kdbus/policy.c
 create mode 100644 drivers/misc/kdbus/policy.h
 create mode 100644 drivers/misc/kdbus/pool.c
 create mode 100644 drivers/misc/kdbus/pool.h
 create mode 100644 drivers/misc/kdbus/queue.c
 create mode 100644 drivers/misc/kdbus/queue.h
 create mode 100644 drivers/misc/kdbus/util.c
 create mode 100644 drivers/misc/kdbus/util.h
 create mode 100644 include/uapi/linux/kdbus.h
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
 create mode 100644 tools/testing/selftests/kdbus/test-domain.c
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

--=20
2.1.0
