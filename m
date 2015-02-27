From: Vitaly Kuznetsov <vkuznets-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH RFC 0/3] Drivers: hv: utils: re-implement the kernel/userspace communication layer
Date: Fri, 27 Feb 2015 17:14:22 +0100
Message-ID: <1425053665-635-1-git-send-email-vkuznets@redhat.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "K. Y. Srinivasan" <kys-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, devel-tBiZLqfeLfOHmIFyCCdPziST3g8Odh+X@public.gmane.org
Cc: Haiyang Zhang <haiyangz-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dexuan Cui <decui-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

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

RFC: I'm a bit puzzled on how to split commits 1 and 2 avoiding breakages.
Commit 3 can definitely be split, however, it is consistent with commits 1 and
2 at this moment and I'm not sure such split will simplify the review.

Vitaly Kuznetsov (3):
  Drivers: hv: kvp: convert userspace/kernel communication to using char
    device
  Drivers: hv: vss: convert userspace/kernel communication to using char
    device
  Drivers: hv: fcopy: make it consistent with vss/kvp

 drivers/hv/hv_fcopy.c       | 395 +++++++++++++++++++++++++------------------
 drivers/hv/hv_kvp.c         | 396 +++++++++++++++++++++++++++-----------------
 drivers/hv/hv_snapshot.c    | 335 +++++++++++++++++++++++++++----------
 include/uapi/linux/hyperv.h |  10 ++
 tools/hv/hv_fcopy_daemon.c  |  48 ++++--
 tools/hv/hv_kvp_daemon.c    | 187 ++++-----------------
 tools/hv/hv_vss_daemon.c    | 141 +++-------------
 7 files changed, 824 insertions(+), 688 deletions(-)

-- 
1.9.3
