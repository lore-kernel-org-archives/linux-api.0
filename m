From: Octavian Purdila <octavian.purdila-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [RFC PATCH v2 0/3] i2c: show and change bus frequency via sysfs
Date: Tue, 14 Oct 2014 17:48:11 +0300
Message-ID: <1413298094-9276-1-git-send-email-octavian.purdila@intel.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: wsa-z923LK4zBo2bacvFa/9K2g@public.gmane.org
Cc: linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org, johan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-i2c-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Octavian Purdila <octavian.purdila-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

This second version gets rid of the frequency table and introduces a
min and max range. It also changes the ABI to allow the driver to
round the given frequency to one that is supported, since many drivers
seems to work this way (i2c-stu300, i2c-s3c2410, i2c-kempld).

Octavian Purdila (3):
  i2c: document the existing i2c sysfs ABI
  i2c: document struct i2c_adapter
  i2c: show and change bus frequency via sysfs

 Documentation/ABI/testing/sysfs-bus-i2c | 75 ++++++++++++++++++++++++++
 drivers/i2c/i2c-core.c                  | 94 +++++++++++++++++++++++++++++++++
 include/linux/i2c.h                     | 32 +++++++++--
 3 files changed, 198 insertions(+), 3 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-bus-i2c

-- 
1.9.1
