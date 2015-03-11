From: Vitaly Kuznetsov <vkuznets-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH RFCv2 00/21] Drivers: hv: utils: re-implement the kernel/userspace communication layer
Date: Wed, 11 Mar 2015 14:29:13 +0100
Message-ID: <1426080574-9011-1-git-send-email-vkuznets@redhat.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "K. Y. Srinivasan" <kys-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, devel-tBiZLqfeLfOHmIFyCCdPziST3g8Odh+X@public.gmane.org
Cc: Haiyang Zhang <haiyangz-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dexuan Cui <decui-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, Radim Krcmar <rkrcmar-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Changes in RFCv2:
- Preserve backwards compatibility with netlink-speaking daemons. [K. Y. Srinivasan]
- Introduce transport abstraction layer. [K. Y. Srinivasan]
- Get rid of ioctls [Radim Krcmar]
- Make the series reviewable by splitting it into smaller patches.

Anatomy of the series:
Patches 01 - 07 are cleanup with minor functional change.
Patch 08 defines the state machine.
Patches 09-11 convert all 3 drivers to using the state machine.
Patch 12 fixes a bug in fcopy. This change is going away in Patch 15,
 I just want to highlight the fix.
Patch 13 introduces a transport abstraction.
Patch 14-16 convert all drivers to using the transport abstraction.
Patches 17-18 switch KVP and VSS daemon to using char devices.
Patches 19-20 convert FCOPY and VSS to hull handshake (the same we have in
 KVP). These two can be postponed till we really need to distinguish between
 different kernels in the daemon code.
Patch 21 unifies log messages on daemons connect across all drivers and moves
 these messages to debug level.

I smoke-tested this series with both old (netlink) and new (char devices)
daemons and tested the daemon upgrade procedure.

Original description:
This series converts kvp/vss daemons to use misc char devices instead of
netlink for userspace/kernel communication and then updates fcopy to be
consistent with kvp/vss.

Userspace/kernel communication via netlink has a number of issues:
- It is hard for userspace to figure out if the kernel part was loaded or not
  and this fact can change as there is a way to enable/disable the service from
  host side. Racy daemon startup is also a problem.
- When the userspace daemon restarts/dies kernel part doesn't receive a
  notification.
- Netlink communication is not stable under heavy load.
- ...

Vitaly Kuznetsov (21):
  Drivers: hv: util: move kvp/vss function declarations to
    hyperv_vmbus.h
  Drivers: hv: kvp: reset kvp_context
  Drivers: hv: kvp: move poll_channel() to hyperv_vmbus.h
  Drivers: hv: fcopy: process deferred messages when we complete the
    transaction
  Drivers: hv: vss: process deferred messages when we complete the
    transaction
  Drivers: hv: kvp: rename kvp_work -> kvp_timeout_work
  Drivers: hv: fcopy: rename fcopy_work -> fcopy_timeout_work
  Drivers: hv: util: introduce state machine for util drivers
  Drivers: hv: kvp: switch to using the hvutil_device_state state
    machine
  Drivers: hv: vss: switch to using the hvutil_device_state state
    machine
  Drivers: hv: fcopy: switch to using the hvutil_device_state state
    machine
  Drivers: hv: fcopy: set .owner reference for file operations
  Drivers: hv: util: introduce hv_utils_transport abstraction
  Drivers: hv: vss: convert to hv_utils_transport
  Drivers: hv: fcopy: convert to hv_utils_transport
  Drivers: hv: kvp: convert to hv_utils_transport
  Tools: hv: kvp: use misc char device to communicate with kernel
  Tools: hv: vss: use misc char device to communicate with kernel
  Drivers: hv: vss: full handshake support
  Drivers: hv: fcopy: full handshake support
  Drivers: hv: utils: unify driver registration reporting

 drivers/hv/Makefile             |   2 +-
 drivers/hv/hv_fcopy.c           | 287 ++++++++++++++--------------------------
 drivers/hv/hv_kvp.c             | 192 +++++++++++++--------------
 drivers/hv/hv_snapshot.c        | 168 +++++++++++++++--------
 drivers/hv/hv_utils_transport.c | 276 ++++++++++++++++++++++++++++++++++++++
 drivers/hv/hv_utils_transport.h |  51 +++++++
 drivers/hv/hyperv_vmbus.h       |  29 ++++
 include/linux/hyperv.h          |   8 --
 include/uapi/linux/hyperv.h     |   8 +-
 tools/hv/hv_fcopy_daemon.c      |  15 +++
 tools/hv/hv_kvp_daemon.c        | 166 +++++------------------
 tools/hv/hv_vss_daemon.c        | 149 ++++++---------------
 12 files changed, 752 insertions(+), 599 deletions(-)
 create mode 100644 drivers/hv/hv_utils_transport.c
 create mode 100644 drivers/hv/hv_utils_transport.h

-- 
1.9.3
