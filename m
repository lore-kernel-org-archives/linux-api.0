From: Octavian Purdila <octavian.purdila-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [RFC PATCH 0/3] iio: export mounting matrix
Date: Mon, 27 Apr 2015 18:01:45 +0300
Message-ID: <1430146908-27919-1-git-send-email-octavian.purdila@intel.com>
Return-path: <linux-iio-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-iio-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jic23-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: lars-Qo5EllUWu/uELgA04lAiVw@public.gmane.org, pmeerw-jW+XmwGofnusTnJN9+BGXg@public.gmane.org, robert.moore-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, rafael.j.wysocki-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, lenb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-iio-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Octavian Purdila <octavian.purdila-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

This is a RFC patch series that exports information about the way the
sensors are connected to the system so that userspace can correct
readings.

It is inspired by the way MPU6050 exports this information via the
in_{gyro,accel,magn}_matrix sysfs entries.

Octavian Purdila (3):
  iio: export mounting matrix information
  ACPICA: Add _PLD front and back panel constants
  iio: derive the mounting matrix from ACPI _PLD objects

 Documentation/ABI/testing/sysfs-bus-iio | 11 ++++
 drivers/iio/industrialio-core.c         | 93 +++++++++++++++++++++++++++++++++
 include/acpi/acbuffer.h                 |  5 ++
 include/linux/iio/iio.h                 | 55 +++++++++++++++++++
 4 files changed, 164 insertions(+)

-- 
1.9.1
