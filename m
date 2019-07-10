From: Wu Hao <hao.wu@intel.com>
Subject: Re: [PATCH v2 00/11] FPGA DFL updates
Date: Wed, 10 Jul 2019 13:07:46 +0800
Message-ID: <20190710050746.GA28620@hao-dev>
References: <1562286238-11413-1-git-send-email-hao.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1562286238-11413-1-git-send-email-hao.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: gregkh@linuxfoundation.org, mdf@kernel.org, linux-fpga@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, atull@kernel.org
List-Id: linux-api@vger.kernel.org

On Fri, Jul 05, 2019 at 08:23:47AM +0800, Wu Hao wrote:
> Hi Greg / Moritz
> 
> This is v2 patchset which adds more features to FPGA DFL. This patchset
> is made on top of patch[1] and char-misc-next tree. Documentation patch
> for DFL is dropped from this patchset, and will resubmit it later to
> avoid conflict.

Hi Greg,

Did you get a chance to take a look at this new version to see if these
patches are good to take?

Hope we can catch up with the merge window.

Thanks
Hao

> 
> Main changes from v1:
>   - remove DRV/MODULE_VERSION modifications. (patch #1, #3, #4, #6)
>   - remove argsz from new ioctls. (patch #2)
>   - replace sysfs_create/remove_* with device_add/remove_* for sysfs entries.
>     (patch #5, #8, #11)
> 
> [1] [PATCH] fpga: dfl: use driver core functions, not sysfs ones.
>     https://lkml.org/lkml/2019/7/4/36
> 
> Wu Hao (11):
>   fpga: dfl: fme: support 512bit data width PR
>   fpga: dfl: fme: add DFL_FPGA_FME_PORT_RELEASE/ASSIGN ioctl support.
>   fpga: dfl: pci: enable SRIOV support.
>   fpga: dfl: afu: add AFU state related sysfs interfaces
>   fpga: dfl: afu: add userclock sysfs interfaces.
>   fpga: dfl: add id_table for dfl private feature driver
>   fpga: dfl: afu: export __port_enable/disable function.
>   fpga: dfl: afu: add error reporting support.
>   fpga: dfl: afu: add STP (SignalTap) support
>   fpga: dfl: fme: add capability sysfs interfaces
>   fpga: dfl: fme: add global error reporting support
> 
>  Documentation/ABI/testing/sysfs-platform-dfl-fme  |  98 ++++++
>  Documentation/ABI/testing/sysfs-platform-dfl-port | 104 ++++++
>  drivers/fpga/Makefile                             |   3 +-
>  drivers/fpga/dfl-afu-error.c                      | 225 +++++++++++++
>  drivers/fpga/dfl-afu-main.c                       | 328 +++++++++++++++++-
>  drivers/fpga/dfl-afu.h                            |   7 +
>  drivers/fpga/dfl-fme-error.c                      | 385 ++++++++++++++++++++++
>  drivers/fpga/dfl-fme-main.c                       |  93 +++++-
>  drivers/fpga/dfl-fme-mgr.c                        | 110 ++++++-
>  drivers/fpga/dfl-fme-pr.c                         |  50 ++-
>  drivers/fpga/dfl-fme.h                            |   7 +-
>  drivers/fpga/dfl-pci.c                            |  39 +++
>  drivers/fpga/dfl.c                                | 166 +++++++++-
>  drivers/fpga/dfl.h                                |  54 ++-
>  include/uapi/linux/fpga-dfl.h                     |  19 ++
>  15 files changed, 1617 insertions(+), 71 deletions(-)
>  create mode 100644 drivers/fpga/dfl-afu-error.c
>  create mode 100644 drivers/fpga/dfl-fme-error.c
> 
> -- 
> 1.8.3.1
