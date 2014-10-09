From: Octavian Purdila <octavian.purdila-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [RFC PATCH 0/3] i2c: show and change bus frequency via sysfs
Date: Thu,  9 Oct 2014 23:07:12 +0300
Message-ID: <1412885235-14026-1-git-send-email-octavian.purdila@intel.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: wsa-z923LK4zBo2bacvFa/9K2g@public.gmane.org
Cc: johan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-i2c-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Octavian Purdila <octavian.purdila-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

The first two patches are just general cleanup the actual
implementation is in patch 3. If the general direction looks
acceptable, I will send a follow-up series that adds sysfs bus
frequency support to the existing drivers.

Octavian Purdila (3):
  i2c: document the existing i2c sysfs ABI
  i2c: document struct i2c_adapter
  i2c: show and change bus frequency via sysfs

 Documentation/ABI/testing/sysfs-bus-i2c | 69 +++++++++++++++++++++++++++++
 drivers/i2c/i2c-core.c                  | 77 +++++++++++++++++++++++++++++++++
 include/linux/i2c.h                     | 26 +++++++++--
 3 files changed, 169 insertions(+), 3 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-bus-i2c

-- 
1.9.1
