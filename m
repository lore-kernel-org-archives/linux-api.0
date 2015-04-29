From: Mathieu Poirier <mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v2 00/11] Support for coresight ETMv4 tracer
Date: Wed, 29 Apr 2015 11:16:24 -0600
Message-ID: <1430327795-10710-1-git-send-email-mathieu.poirier@linaro.org>
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
Changes for v2:
- Rebased on v4.1-rc1. 
- Fixed mask in the amba_id cells.
- Fixed double pm_runtime_put() in error path. 
---

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

 .../ABI/testing/sysfs-bus-coresight-devices-etm4x  |  295 +++
 drivers/hwtracing/coresight/Kconfig                |   10 +
 drivers/hwtracing/coresight/Makefile               |    1 +
 drivers/hwtracing/coresight/coresight-etm4x.c      | 2744 ++++++++++++++++++++
 drivers/hwtracing/coresight/coresight-etm4x.h      |  391 +++
 5 files changed, 3441 insertions(+)
 create mode 100644 Documentation/ABI/testing/sysfs-bus-coresight-devices-etm4x
 create mode 100644 drivers/hwtracing/coresight/coresight-etm4x.c
 create mode 100644 drivers/hwtracing/coresight/coresight-etm4x.h

-- 
1.9.1
