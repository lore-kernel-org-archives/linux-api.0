From: Mathieu Poirier <mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v4 00/13] Support for coresight ETMv4 tracer
Date: Wed, 13 May 2015 10:34:08 -0600
Message-ID: <1431534861-24986-1-git-send-email-mathieu.poirier@linaro.org>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kaixu.xia-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, zhang.chunyan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

Please find in this patchset a driver implementation that conforms
to the coresight framework and provide support for the Embedded
Trace Macrocell version 4.

Regards,
Mathieu

---
Changes for v4:
  - Restored cell ID 0x0003b95d.
  - breakdown of multi-line output in sysfs entries.   

Mathieu Poirier (2):
  coresight-etm4x: Read only access to the main management registers
  coresight-etm4x: Read only access to the tracer's ID registers

Pratik Patel (11):
  coresight-etm4x: Adding CoreSight ETM4x driver
  coresight-etm4x: Controls pertaining to tracer configuration
  coresight-etm4x: Controls pertaining to the reset, mode, pe and events
  coresight-etm4x: Controls pertaining to various configuration options
  coresight-etm4x: Controls pertaining to the ViewInst register
  coresight-etm4x: Controls pertaining to the address comparator
    functions
  coresight-etm4x: Controls pertaining to the sequencer functions
  coresight-etm4x: Controls pertaining to the counter functions
  coresight-etm4x: Controls pertaining to the selection of resources
  coresight-etm4x: Controls pertaining to the context ID functions
  coresight-etm4x: Controls pertaining to the VM ID functions

 .../ABI/testing/sysfs-bus-coresight-devices-etm4x  |  450 ++++
 drivers/hwtracing/coresight/Kconfig                |   11 +
 drivers/hwtracing/coresight/Makefile               |    1 +
 drivers/hwtracing/coresight/coresight-etm4x.c      | 2701 ++++++++++++++++++++
 drivers/hwtracing/coresight/coresight-etm4x.h      |  391 +++
 5 files changed, 3554 insertions(+)
 create mode 100644 Documentation/ABI/testing/sysfs-bus-coresight-devices-etm4x
 create mode 100644 drivers/hwtracing/coresight/coresight-etm4x.c
 create mode 100644 drivers/hwtracing/coresight/coresight-etm4x.h

-- 
1.9.1
