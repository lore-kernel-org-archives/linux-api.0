From: Cristina Moraru <cristina.moraru09-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 0/5] iio: hmc5843: Fix issues and move out of staging
Date: Mon,  8 Feb 2016 00:21:46 +0200
Message-ID: <1454883711-15489-1-git-send-email-cristina.moraru09@gmail.com>
Return-path: <linux-iio-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-iio-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jic23-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, knaack.h-Mmb7MZpHnFY@public.gmane.org, lars-Qo5EllUWu/uELgA04lAiVw@public.gmane.org, pmeerw-jW+XmwGofnusTnJN9+BGXg@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, cristina.opriceana-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, marek-xXXSsgcRVICgSpxsJD1C4w@public.gmane.org, sdliyong-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-iio-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tolga.ceylan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, k.kozlowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, javier-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org, irina.tirdea-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, daniel.baluta-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, octavia.purdila-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: Cristina Moraru <cristina.moraru09-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Fix driver issues and add completions.
Add custom attribute to display available values for bias
current, add documentation for undocumented custom attributes,
swap implementation of two functions that have been inversed,
fix checkpatch warnings and, move the driver from the staging
directory to drivers/iio/magnetometer updating corresponding
Makefile and Kconfig files.

Cristina Moraru (5):
  iio: hmc5843: Add attribute for available measurement config
  iio: hmc5843: Swap suspend and resume implementations
  iio: hmc5843: Add ABI documentation file for hmc5843
  iio: hmc5843: Fix comment style warnings
  iio: hmc5843: Move hmc5843 out of staging

 .../ABI/testing/sysfs-bus-iio-magnetometer-hmc5843 |  15 +
 drivers/iio/magnetometer/Kconfig                   |  33 +
 drivers/iio/magnetometer/Makefile                  |   4 +
 drivers/iio/magnetometer/hmc5843.h                 |  66 ++
 drivers/iio/magnetometer/hmc5843_core.c            | 693 +++++++++++++++++++++
 drivers/iio/magnetometer/hmc5843_i2c.c             | 104 ++++
 drivers/iio/magnetometer/hmc5843_spi.c             | 102 +++
 drivers/staging/iio/magnetometer/Kconfig           |  32 -
 drivers/staging/iio/magnetometer/Makefile          |   4 +-
 drivers/staging/iio/magnetometer/hmc5843.h         |  66 --
 drivers/staging/iio/magnetometer/hmc5843_core.c    | 646 -------------------
 drivers/staging/iio/magnetometer/hmc5843_i2c.c     | 104 ----
 drivers/staging/iio/magnetometer/hmc5843_spi.c     | 102 ---
 13 files changed, 1018 insertions(+), 953 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-bus-iio-magnetometer-hmc5843
 create mode 100644 drivers/iio/magnetometer/hmc5843.h
 create mode 100644 drivers/iio/magnetometer/hmc5843_core.c
 create mode 100644 drivers/iio/magnetometer/hmc5843_i2c.c
 create mode 100644 drivers/iio/magnetometer/hmc5843_spi.c
 delete mode 100644 drivers/staging/iio/magnetometer/hmc5843.h
 delete mode 100644 drivers/staging/iio/magnetometer/hmc5843_core.c
 delete mode 100644 drivers/staging/iio/magnetometer/hmc5843_i2c.c
 delete mode 100644 drivers/staging/iio/magnetometer/hmc5843_spi.c

-- 
1.9.1
