From: Mike Waychison <mikew@google.com>
Subject: [PATCH v2 00/23] netoops support
Date: Mon, 08 Nov 2010 12:31:36 -0800
Message-ID: <20101108203120.22479.19708.stgit@crlf.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: simon.kagstrom@netinsight.net, davem@davemloft.net, nhorman@tuxdriver.com, Matt Mackall <mpm@selenic.com>
Cc: adurbin@google.com, linux-kernel@vger.kernel.org, chavey@google.com, Greg KH <greg@kroah.com>, =?utf-8?q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>, akpm@linux-foundation.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

This patchset applies to v2.6.37-rc1.

The following series implements support for 'netoops', a simple driver that
will deliver kmsg logs together with machine specifics over the network.

This driver is based on code used in Google's production server environment.
We internally call the driver 'netdump', but are planning on changing the name
to 'netoops' to follow the convention set by both the mtdoops and ramoops
drivers.  We use these facilities to gather crash data from our entire fleet of
machines in a light-weight manner.  We do things this way because it
simply isn't feasible to gather full crash data off of every machine in
the wild that decides it is time to die.

Currently, this driver only supports UDP over ipv4.

In order to handle configuration, the target support in netconsole is
fixed, seperated out, and re-used by netoops.

I'm posting these patches in an effort to eventually get this sort of
functionality mainlined.  I have tried to clean this code up internally, but
there are still several unresolved issues that would need to be worked
out as of this version.  In particular:

   * I am _NOT_ happy with the remaining userland ABIs presented in this
     patchset.  Specifically the files "net_dump_now",
     "net_dump_one_shot", "netdump_fw_version", "netdump_board_name" and
     "netdump_boot_id" should be considered.  These files have been
     cobbled together by a variety of engineers over the years, and they
     aren't very pretty.  I present them none-the-less to express the
     scope of the functionality that we would like to maintain.

   * I am _NOT_ happy with the data format of the transmitted packets.  It is
     very specific to our server environment and currently:

      * is hard-coded to support both userland provided information (that may
        not be applicable to others) and

      * only supports i386 and x86_64.

I'd like to resolve each of the above issues in subsequent versions of this
patchset.  I need help in identifying what the ABI should look like in
particular.

Patchset summary
================

Patches 1 through 4 inclusive are fixes to the existing netconsole code,
adding locking consistency, fixing races and deadlocks.

Patches 5 through 14 inclusive splits the target configuration portion
of netconsole out into a new component in net/core/netpoll_targets.c.

Patches 15 through 18 inclusive are core changes to support
functionality in the netoops driver.

Patches 19 through 23 is the netoops driver itself, with different
functional aspects broken out.

 1 - netconsole: Remove unneeded reference counting
 2 - netconsole: Introduce locking over the netpoll fields
 3 - netconsole: Introduce 'enabled' state-machine
 4 - netconsole: Call netpoll_cleanup() in process context

 5 - netconsole: Wrap the list and locking in a structure
 6 - netconsole: Push configfs_subsystem into netpoll_targets
 7 - netconsole: Move netdev_notifier into netpoll_targets
 8 - netconsole: Split out netpoll_targets init/exit
 9 - netconsole: Add pointer to netpoll_targets
10 - netconsole: Rename netconsole_target -> netpoll_target
11 - netconsole: Abstract away the subsystem name
12 - netpoll: Introduce netpoll_target configs
13 - netconsole: Move setting of default ports.
14 - netpoll: Move target code into netpoll_targets.c

15 - Oops: Pass regs to oops_exit()
16 - kmsg_dumper: Pass pt_regs along to dumpers.
17 - kmsg_dumper: Introduce a new 'SOFT' dump reason
18 - sys-rq: Add option to soft dump

19 - netoops: add core functionality
20 - netoops: Add x86 specific bits to packet headers
21 - netoops: Add user programmable fields to the netoops packet.
22 - netoops: Add one-shot mode
23 - netoops: Add an interface to trigger various types of crashes.


Diffstat
========
 arch/arm/kernel/traps.c         |    2 
 arch/parisc/kernel/traps.c      |    2 
 arch/powerpc/kernel/traps.c     |    2 
 arch/s390/kernel/traps.c        |    2 
 arch/sh/kernel/traps_32.c       |    2 
 arch/x86/kernel/dumpstack.c     |    2 
 drivers/char/ramoops.c          |    4 
 drivers/char/sysrq.c            |   14 
 drivers/mtd/mtdoops.c           |    4 
 drivers/net/Kconfig             |   26 +
 drivers/net/Makefile            |    1 
 drivers/net/netconsole.c        |  735 +--------------------------------------
 drivers/net/netoops.c           |  401 +++++++++++++++++++++
 include/linux/kernel.h          |    2 
 include/linux/kmsg_dump.h       |    9 
 include/linux/netpoll_targets.h |   76 ++++
 kernel/kexec.c                  |    5 
 kernel/panic.c                  |    6 
 kernel/printk.c                 |    5 
 net/core/Makefile               |    1 
 net/core/netpoll_targets.c      |  746 ++++++++++++++++++++++++++++++++++++++++
 21 files changed, 1309 insertions(+), 738 deletions(-)

Comparison to netconsole
========================

This driver differs from netconsole in a couple different ways.

* Network overheads:
     With the number of machines we have, streaming large amounts of consoles
     within the data center can really add up.  This gets worse when you take
     into account how reliant we are on kernel logging like OOM conditions
     (which are very regular and very verbose).  Events in the data center
     (such as application growth) tend to be temporally correlated, which
     causes large bursts of logging when we are OOM.  We aren't so interested
     in this kernel verbosity from a global collection standpoint though, and
     haven't been keen on the amount of extra un-regulated UDP traffic it would
     generate.  We are however interested in kernel oopses which occur far less
     often.

* Structured data:
     In terms of the data received, we've really benefited by having structured
     data in the payload.  We've been collecting kernel oopses since sometime
     in 2006 and have a _vast_ collection of crashes that we have indexed by
     just about anything you could ever want (registers, full dmesg text,
     backtraces, motherboards, CPU types, kernel versions, bios versions, etc).
     This has allowed us to quickly find 'big bugs' vs 'rare bugs' (similar to
     kerneloops.org) in a data center environment.

     This structured data also allows for automated labeling of oopses/panics
     using a variety of criteria.  Netconsole only provides unstructured
     streaming data, and the bits that we care about are either not present in
     the dmesg logs or they are, but is extremely difficult to parse them out
     (especially across kernel versions).  Other bits of information, like
     firmware version, are also difficult to associate with crashes with
     post-processing due to gaps in global sampling and the churn that occurs
     in the lab where versions can change quickly.

* Network reliability:
     Another area where the two approaches have differed has been in handling
     of network reliability.  Historically (though less and less now), we found
     that we had to transmit data several times.  We also used to explicitly
     space out packets with delays to handle switch chip buffer overruns.  Both
     of these functions I presume could be added to netconsole without too much
     of a problem.

* Dealing with excessive logging:
     This patchset introduces a 'one-shot' mode, which has saved our bacon
     several times in the past.  It's not totally uncommon for the kernel's
     crash path to be buggy, in turn causing the kernel to emit Oopses until
     the cows come home (or rather, until the hardware watchdogs trip).
     One-shot keeps us from emitting too much garbage on the network when this
     happens.

     As well, while console filtering of printk()ed messages is common
     practice, we would like to see *all* kernel messages, including KERN_DEBUG
     messages when investigating a kernel crash.  Using kmsg_dumper to get at
     the full ring buffer provides access to this sort of data, whereas
     netconsole would be subject to system-wide filtering policies (which also
     affect the serial console).

ChangeLog:
==========
- v2
   - Now uses the same mechanism that netconsole uses for configuring
     targets, which is also now abstracted out to
     net/core/netpoll_targets.c.
