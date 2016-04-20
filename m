From: Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: Re: [PATCH V5 0/4] Introduce CoreSight STM support
Date: Wed, 20 Apr 2016 09:06:02 -0600
Message-ID: <CANLsYkwtHeXRwM98J3GQDpKwPcqAKXUFW6OWE5TJ6P_Og4RLZA@mail.gmail.com>
References: <1459997479-19431-1-git-send-email-zhang.chunyan@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <1459997479-19431-1-git-send-email-zhang.chunyan@linaro.org>
Sender: linux-doc-owner@vger.kernel.org
To: Chunyan Zhang <zhang.chunyan@linaro.org>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>, Mike Leach <mike.leach@arm.com>, Michael Williams <Michael.Williams@arm.com>, Al Grant <al.grant@arm.com>, "Jeremiassen, Tor" <tor@ti.com>, Nicolas GUION <nicolas.guion@st.com>, Pratik Patel <pratikp@codeaurora.org>, Lyra Zhang <zhang.lyra@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, linux-api@vger.kernel.org, linux-doc@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 6 April 2016 at 20:51, Chunyan Zhang <zhang.chunyan@linaro.org> wrote:
> This patchset adds support for the CoreSight STM IP block.

This has been out there long enough - I'm picking this up.

Alex, I'll have 1/4 go through my tree.  Get back to me if you want to
proceed differently.

Thanks,
Mathieu

>
> Changes from V4:
>  - Rebased the whole patch set onto [4] (v4.6-rc1).
>  - Made a few minor modifications according to the code changes since v4.5.
>  - Replaced the original 1/4 with a new patch the Alex provided.
>  - Another new patch 2/4 in this set is for storing path from CS-STM to sink.
>  - Addressed comments from V4.
>  - Removed coresight_simple_func() from CS-STM driver, used the common definition instead.
>  - Modified STM tracer-id from an arbitrary value 0x20 to 0x1.
>  - Replaced module_amba_driver() with builtin_amba_driver() according to [5].
>  - Used driver->suppress_bind_attr to prevent CS-STM being unbound from the driver.
>  - Updated the kernel version (4.7) and month in sysfs-bus-coresight-devices-stm.
>  - Replaced 'mshared' with 'hw_override' in CS-STM driver.
>  - Initialized sw_start and sw_end with 1.
>  - Returned a size of '1' after processing FLAG packets.
>  - Removed pre-compile option 'CONFIG_64BIT' for the packet size of 8.
>  - Added Michael Williams's Reviewed-by in 4/4.
>
> Changes from V3:
>  - Removed ioctl get_options interface from the generic STM code and CoreSight STM driver.
>  - Removed 'write_max' from the structure 'stm_drvdata', and changed 'write_64bit' to 'write_bytes'.
>  - Revised stm_fundamental_data_size() to return the fundamental data size instead of 0/1.
>  - Removed stm_remove() from the driver.
>  - Revised the return value of ::packet() callback function according to [2].
>  - Modified stm_send() to send one STP packet at a time.
>  - Added comments to invariant/guaranteed CoreSight STM transaction mode.
>
> Changes from V2:
>  - Changed to return -EFAULT if failed on the command STP_GET_OPTIONS.
>  - Used Alex's patch [1] instead of the last 2/6.
>  - Removed the while loop from stm_send(), since the packet size passed
>    to it isn't larger than 4 bytes on 32-bit system and 8 bytes on
>    64-bit system.
>  - Removed stm_send_64bit(), since the process of packets on 64-bit
>    CS-STM should be basically the same with on 32-bit system, except the
>    maximum length of writing STM at a time.
>  - Removed the support of writing 64-bit to CoreSight STM buffer at a time
>    on 32-bit ARM architecture according to an ARM engineer suggestion.  As
>    he said that the STM might receive a 64-bit write, or might receive a
>    pair of 32-bit writes to the two addressed words in either order.
>    So 64-bit write isn't guaranteed to work on the ARM 32-bit architecture.
>
> Changes from v1:
>  - Added a definition of coresight_simple_func() in CS-STM driver to
>    avoid the kbuild test robot error for the time being.  This
>    modification will be removed when merging the code in which the
>    coresight_simple_func() has been moved to the header file.
>  - Calculate the channel number according to the channel memory space size.
>
>
> Thanks,
> Chunyan
>
> [1] https://lkml.org/lkml/2016/2/4/652
> [2] https://lkml.org/lkml/2016/2/12/397
> [3] https://lkml.org/lkml/2015/12/22/348
> [4] https://git.linaro.org/kernel/coresight.git/shortlog/refs/heads/next
> [5] http://www.spinics.net/lists/kernel/msg2187320.html
>
> Alexander Shishkin (1):
>   stm class: Support devices that override software assigned masters
>
> Mathieu Poirier (2):
>   coresight: adding path for STM device
>   coresight-stm: Bindings for System Trace Macrocell
>
> Pratik Patel (1):
>   coresight-stm: adding driver for CoreSight STM component
>
>  .../ABI/testing/sysfs-bus-coresight-devices-stm    |  53 ++
>  Documentation/ABI/testing/sysfs-class-stm          |  10 +
>  .../devicetree/bindings/arm/coresight.txt          |  28 +
>  Documentation/trace/coresight.txt                  |  37 +-
>  drivers/hwtracing/coresight/Kconfig                |  11 +
>  drivers/hwtracing/coresight/Makefile               |   1 +
>  drivers/hwtracing/coresight/coresight-stm.c        | 918 +++++++++++++++++++++
>  drivers/hwtracing/coresight/coresight.c            | 106 ++-
>  drivers/hwtracing/stm/core.c                       |  15 +
>  include/linux/coresight-stm.h                      |   6 +
>  include/linux/stm.h                                |   3 +
>  include/uapi/linux/coresight-stm.h                 |  21 +
>  12 files changed, 1183 insertions(+), 26 deletions(-)
>  create mode 100644 Documentation/ABI/testing/sysfs-bus-coresight-devices-stm
>  create mode 100644 drivers/hwtracing/coresight/coresight-stm.c
>  create mode 100644 include/linux/coresight-stm.h
>  create mode 100644 include/uapi/linux/coresight-stm.h
>
> --
> 1.9.1
>
