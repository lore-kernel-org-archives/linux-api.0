From: Chunyan Zhang <zhang.chunyan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH V4 0/4] Introduce CoreSight STM support
Date: Tue,  1 Mar 2016 14:35:05 +0800
Message-ID: <1456814109-21311-1-git-send-email-zhang.chunyan@linaro.org>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, alexander.shishkin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org
Cc: mike.leach-5wv7dgnIgG8@public.gmane.org, Michael.Williams-5wv7dgnIgG8@public.gmane.org, al.grant-5wv7dgnIgG8@public.gmane.org, tor-l0cyMroinI0@public.gmane.org, nicolas.guion-qxv4g6HH51o@public.gmane.org, pratikp-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, zhang.lyra-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

This patchset adds support for the CoreSight STM IP block.

In this fourth version, comments from various people have been
addressed.  Representing configurations where channels are shared
between multiple masterIDs has been kept unchanged from the previous
version because a viable alternative hasn't been suggested.

Changes from V3:
 - Removed ioctl get_options interface from the generic STM code and CoreSight STM driver.
 - Removed 'write_max' from the structure 'stm_drvdata', and changed 'write_64bit' to 'write_bytes'.
 - Revised stm_fundamental_data_size() to return the fundamental data size instead of 0/1.
 - Removed stm_remove() from the driver.
 - Revised the return value of ::packet() callback function according to [2].
 - Modified stm_send() to send one STP packet at a time.
 - Added comments to invariant/guaranteed CoreSight STM transaction mode.

Changes from V2:
 - Changed to return -EFAULT if failed on the command STP_GET_OPTIONS.
 - Used Alex's patch [1] instead of the last 2/6.
 - Removed the while loop from stm_send(), since the packet size passed
   to it isn't larger than 4 bytes on 32-bit system and 8 bytes on
   64-bit system.
 - Removed stm_send_64bit(), since the process of packets on 64-bit
   CS-STM should be basically the same with on 32-bit system, except the 
   maximum length of writing STM at a time.
 - Removed the support of writing 64-bit to CoreSight STM buffer at a time
   on 32-bit ARM architecture according to an ARM engineer suggestion.  As
   he said that the STM might receive a 64-bit write, or might receive a
   pair of 32-bit writes to the two addressed words in either order.
   So 64-bit write isn't guaranteed to work on the ARM 32-bit architecture.

Changes from v1:
 - Added a definition of coresight_simple_func() in CS-STM driver to
   avoid the kbuild test robot error for the time being.  This
   modification will be removed when merging the code in which the
   coresight_simple_func() has been moved to the header file.
 - Calculate the channel number according to the channel memory space size.


Thanks,
Chunyan

[1] https://lkml.org/lkml/2016/2/4/652
[2] https://lkml.org/lkml/2016/2/12/397

Chunyan Zhang (1):
  Documentations: Add explanations of the case for non-configurable
    masters

Mathieu Poirier (2):
  stm class: provision for statically assigned masterIDs
  coresight-stm: Bindings for System Trace Macrocell

Pratik Patel (1):
  coresight-stm: adding driver for CoreSight STM component

 .../ABI/testing/sysfs-bus-coresight-devices-stm    |  53 ++
 .../devicetree/bindings/arm/coresight.txt          |  28 +
 Documentation/trace/coresight.txt                  |  37 +-
 Documentation/trace/stm.txt                        |   6 +
 drivers/hwtracing/coresight/Kconfig                |  11 +
 drivers/hwtracing/coresight/Makefile               |   1 +
 drivers/hwtracing/coresight/coresight-stm.c        | 890 +++++++++++++++++++++
 drivers/hwtracing/stm/core.c                       |  18 +-
 drivers/hwtracing/stm/policy.c                     |  18 +-
 include/linux/coresight-stm.h                      |   6 +
 include/linux/stm.h                                |   8 +
 include/uapi/linux/coresight-stm.h                 |  21 +
 12 files changed, 1091 insertions(+), 6 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-bus-coresight-devices-stm
 create mode 100644 drivers/hwtracing/coresight/coresight-stm.c
 create mode 100644 include/linux/coresight-stm.h
 create mode 100644 include/uapi/linux/coresight-stm.h

-- 
1.9.1
