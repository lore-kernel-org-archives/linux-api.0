From: Alan Tull <atull@kernel.org>
Subject: Re: [PATCH v6 06/29] fpga: add device feature list support
Date: Tue, 12 Jun 2018 10:42:21 -0500
Message-ID: <CANk1AXTnmMvLar5m7189JBsCO1qyVY71H7x5dgP0MtfDtrRr6Q@mail.gmail.com>
References: <1528798243-2029-1-git-send-email-hao.wu@intel.com> <1528798243-2029-7-git-send-email-hao.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1528798243-2029-7-git-send-email-hao.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Wu Hao <hao.wu@intel.com>
Cc: Moritz Fischer <mdf@kernel.org>, linux-fpga@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, "Kang, Luwei" <luwei.kang@intel.com>, "Zhang, Yi Z" <yi.z.zhang@intel.com>, Tim Whisonant <tim.whisonant@intel.com>, Enno Luebbers <enno.luebbers@intel.com>, Shiva Rao <shiva.rao@intel.com>, Christopher Rauer <christopher.rauer@intel.com>, Xiao Guangrong <guangrong.xiao@linux.intel.com>
List-Id: linux-api@vger.kernel.org

On Tue, Jun 12, 2018 at 5:10 AM, Wu Hao <hao.wu@intel.com> wrote:
> Device Feature List (DFL) defines a feature list structure that creates
> a link list of feature headers within the MMIO space to provide an
> extensible way of adding features. This patch introduces a kernel module
> to provide basic infrastructure to support FPGA devices which implement
> the Device Feature List.
>
> Usually there will be different features and their sub features linked into
> the DFL. This code provides common APIs for feature enumeration, it creates
> a container device (FPGA base region), walks through the DFLs and creates
> platform devices for feature devices (Currently it only supports two
> different feature devices, FPGA Management Engine (FME) and Port which
> the Accelerator Function Unit (AFU) connected to). In order to enumerate
> the DFLs, the common APIs required low level driver to provide necessary
> enumeration information (e.g address for each device feature list for
> given device) and fill it to the dfl_fpga_enum_info data structure. Please
> refer to below description for APIs added for enumeration.
>
> Functions for enumeration information preparation:
>  *dfl_fpga_enum_info_alloc
>    allocate enumeration information data structure.
>
>  *dfl_fpga_enum_info_add_dfl
>    add a device feature list to dfl_fpga_enum_info data structure.
>
>  *dfl_fpga_enum_info_free
>    free dfl_fpga_enum_info data structure and related resources.
>
> Functions for feature device enumeration:
>  *dfl_fpga_feature_devs_enumerate
>    enumerate feature devices and return container device.
>
>  *dfl_fpga_feature_devs_remove
>    remove feature devices under given container device.
>
> Signed-off-by: Tim Whisonant <tim.whisonant@intel.com>
> Signed-off-by: Enno Luebbers <enno.luebbers@intel.com>
> Signed-off-by: Shiva Rao <shiva.rao@intel.com>
> Signed-off-by: Christopher Rauer <christopher.rauer@intel.com>
> Signed-off-by: Zhang Yi <yi.z.zhang@intel.com>
> Signed-off-by: Xiao Guangrong <guangrong.xiao@linux.intel.com>
> Signed-off-by: Wu Hao <hao.wu@intel.com>
Acked-by: Alan Tull <atull@kernel.org>

> ---
> v3: split from another patch.
>     separate dfl enumeration code from original pcie driver.
>     provide common data structures and APIs for enumeration.
>     update device feature list parsing process according to latest hw.
>     add dperf/iperf/hssi sub feature placeholder according to latest hw.
>     remove build_info_add_sub_feature and other small functions.
>     replace *_feature_num function with macro.
>     remove writeq/readq.
> v4: fix SPDX license issue
>     rename files to dfl.[ch], fix typo and add more comments.
>     remove static feature_info tables for FME and Port.
>     remove check on next_afu link list as only FIU has next_afu ptr.
>     remove unused macro in header file.
>     add more comments for functions.
> v5: add "dfl_" prefix to functions and data structures.
>     remove port related functions from DFL framework.
>     use BIT_ULL for 64bit register definition.
>     save dfl_fpga_cdev in pdata for feature platform devices.
>     rebase due to fpga region api changes.
> v6: update time in copyright and improve function name.
>     introduce dfl_devs table to save feature device info.
