From: Octavian Purdila <octavian.purdila-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATH v3 0/4] i2c: show and change bus frequency via sysfs
Date: Wed, 15 Oct 2014 23:03:27 +0300
Message-ID: <1413403411-8895-1-git-send-email-octavian.purdila@intel.com>
Return-path: <linux-i2c-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-i2c-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: wsa-z923LK4zBo2bacvFa/9K2g@public.gmane.org
Cc: linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org, johan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-i2c-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Octavian Purdila <octavian.purdila-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

This patch series adds support to show and change the bus frequency
via sysfs, by exposing files to show the minimum, maximum and current
frequency as well as allowing the frequency to be changed. This allows
the user to view or change the bus frequency on a per bus level.

Changes since v3:

 * use DEVICE_ATTR_RO and make i2c_adapter_visible_attr static
 
 * implement sysfs bus frequency support for the diolan u2c bus

Octavian Purdila (4):
  i2c: document the existing i2c sysfs ABI
  i2c: document struct i2c_adapter
  i2c: show and change bus frequency via sysfs
  i2c: i2c-diolan-u2c: sysfs bus frequency support

 Documentation/ABI/testing/sysfs-bus-i2c | 75 +++++++++++++++++++++++++++
 drivers/i2c/busses/i2c-diolan-u2c.c     | 49 ++++++++++++------
 drivers/i2c/i2c-core.c                  | 90 +++++++++++++++++++++++++++++++++
 include/linux/i2c.h                     | 32 ++++++++++--
 4 files changed, 228 insertions(+), 18 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-bus-i2c

-- 
1.9.1
