From: Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v7 0/2] add performance reporting support to FPGA DFL drivers
Date: Mon, 10 Feb 2020 11:47:47 +0800
Message-ID: <1581306469-22629-1-git-send-email-hao.wu@intel.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: mdf-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, linux-fpga-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, atull-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, yilun.xu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi all,

This patchset adds performance reporting support for FPGA DFL drivers. It
introduces one pmu to expose userspace interfaces via standard perf API.
User could use standard perf tool to access perf events exposed via pmu.

This patchset is generated based on 5.6-rc1.

Main changes from v6:
 - add a new ABI/testing/ sysfs documentation in patch #2.
 - fix a warning reported by kbuild in patch #2.

Main changes from v5:
 - use dev_ext_attribute instead of fme_perf_event_attr.
 - use is_visible function to decide which events to expose per
   hardware capability, and add event_init checking for all events.

Main changes from v4:
 - rebase and clean up.
 - update Kconfig for PERF_EVENTS dependency.

Main changes from v3:
 - add more descriptions in doc, including how to use perf tool for these
   hardware counters. (patch #1)
 - use standard perf API instead of sysfs entries. (patch #2)

Wu Hao (1):
  fpga: dfl: fme: add performance reporting support

Xu Yilun (1):
  Documentation: fpga: dfl: add description for performance reporting
    support

 .../ABI/testing/sysfs-bus-event_source-devices-fme | 105 +++
 Documentation/fpga/dfl.rst                         |  83 ++
 drivers/fpga/Kconfig                               |   2 +-
 drivers/fpga/Makefile                              |   1 +
 drivers/fpga/dfl-fme-main.c                        |   4 +
 drivers/fpga/dfl-fme-perf.c                        | 943 +++++++++++++++++++++
 drivers/fpga/dfl-fme.h                             |   2 +
 drivers/fpga/dfl.h                                 |   2 +
 8 files changed, 1141 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/ABI/testing/sysfs-bus-event_source-devices-fme
 create mode 100644 drivers/fpga/dfl-fme-perf.c

-- 
1.8.3.1
