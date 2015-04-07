From: Greg Kurz <gkurz-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: [PATCH v3 0/7] vhost: support for cross endian guests
Date: Tue, 07 Apr 2015 14:09:29 +0200
Message-ID: <20150407120929.4213.8225.stgit@bahia.lab.toulouse-stg.fr.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, virtualization-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi,

This patchset allows vhost to be used with legacy virtio when guest and host
have a different endianness.

Patches 1-6 remain the same as the previous post. Patch 7 was heavily changed
according to MST's comments.

---

Greg Kurz (7):
      virtio: introduce virtio_is_little_endian() helper
      tun: add tun_is_little_endian() helper
      macvtap: introduce macvtap_is_little_endian() helper
      vringh: introduce vringh_is_little_endian() helper
      vhost: introduce vhost_is_little_endian() helper
      virtio: add explicit big-endian support to memory accessors
      vhost: feature to set the vring endianness


 drivers/net/macvtap.c            |   11 ++++++--
 drivers/net/tun.c                |   11 ++++++--
 drivers/vhost/Kconfig            |   10 +++++++
 drivers/vhost/vhost.c            |   55 ++++++++++++++++++++++++++++++++++++++
 drivers/vhost/vhost.h            |   34 +++++++++++++++++++----
 include/linux/virtio_byteorder.h |   24 ++++++++++-------
 include/linux/virtio_config.h    |   19 +++++++++----
 include/linux/vringh.h           |   19 +++++++++----
 include/uapi/linux/vhost.h       |    5 +++
 9 files changed, 156 insertions(+), 32 deletions(-)

--
Greg
