From: Octavian Purdila <octavian.purdila-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [RFC PATCH 0/3] allow better control for flushing the hardware fifo
Date: Wed, 29 Apr 2015 14:18:57 +0300
Message-ID: <1430306340-5026-1-git-send-email-octavian.purdila@intel.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jic23-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: knaack.h-Mmb7MZpHnFY@public.gmane.org, lars-Qo5EllUWu/uELgA04lAiVw@public.gmane.org, pmeerw-jW+XmwGofnusTnJN9+BGXg@public.gmane.org, linux-iio-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, adriana.reus-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Octavian Purdila <octavian.purdila-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Jonathan,

The first patch is a small enhancement that makes it easier to add
hwfifo support in drivers.

The other two are adding new ABIs to allow on demand trigger of a
hardware fifo flush operation and to signal when the flush operation
has been completed. The user for this interface is Android's sensor
HAL.

Thanks,
Tavi

Octavian Purdila (3):
  iio: add hwfifo attributes helpers
  iio: allow better control for flushing the hardware fifo
  iio: accel: bmc150: add support for hwfifo_flush and flush events

 Documentation/ABI/testing/sysfs-bus-iio | 11 +++++
 drivers/iio/accel/bmc150-accel.c        | 71 +++++++++++++++++++++++----------
 include/linux/iio/sysfs.h               | 15 +++++++
 include/uapi/linux/iio/types.h          |  1 +
 4 files changed, 78 insertions(+), 20 deletions(-)

-- 
1.9.1
