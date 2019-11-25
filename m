From: Wu Hao <hao.wu@intel.com>
Subject: Re: [PATCH v6 0/2] add performance reporting support to FPGA DFL
 drivers
Date: Mon, 25 Nov 2019 11:34:12 +0800
Message-ID: <20191125033412.GB890@hao-dev>
References: <1573622695-25607-1-git-send-email-hao.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1573622695-25607-1-git-send-email-hao.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: mdf@kernel.org, will@kernel.org, mark.rutland@arm.com, linux-fpga@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, atull@kernel.org, gregkh@linuxfoundation.org, hao.wu@intel.com
List-Id: linux-api@vger.kernel.org

On Wed, Nov 13, 2019 at 01:24:53PM +0800, Wu Hao wrote:
> Hi Moritz and all,

Hi Will and Mark,

Could you please help us on review this patchset? as this patchset mainly 
introduced a new perf driver following the similar way as drivers/perf/*.

Hi Moritz,

Could you please help us on review the other parts?

This patchset has been submitted for a long time but didn't receive any
comment after v4. we appreciate any review comments! thanks in advance. :)


Hao

> 
> This patchset adds performance reporting support for FPGA DFL drivers. It
> introduces one pmu to expose userspace interfaces via standard perf API.
> User could use standard perf tool to access perf events exposed via pmu.
> 
> This patchset is generated based on fpga/for-next branch.
> 
> Main changes from v5:
>  - use dev_ext_attribute instead of fme_perf_event_attr.
>  - use is_visible function to decide which events to expose per
>    hardware capability, and add event_init checking for all events.
> 
> Main changes from v4:
>  - rebase and clean up.
>  - update Kconfig for PERF_EVENTS dependency.
> 
> Main changes from v3:
>  - add more descriptions in doc, including how to use perf tool for these
>    hardware counters. (patch #1)
>  - use standard perf API instead of sysfs entries. (patch #2)
> 
> Wu Hao (1):
>   fpga: dfl: fme: add performance reporting support
> 
> Xu Yilun (1):
>   Documentation: fpga: dfl: add description for performance reporting
>     support
> 
>  Documentation/fpga/dfl.rst  |  83 ++++
>  drivers/fpga/Makefile       |   1 +
>  drivers/fpga/dfl-fme-main.c |   4 +
>  drivers/fpga/dfl-fme-perf.c | 943 ++++++++++++++++++++++++++++++++++++++++++++
>  drivers/fpga/dfl-fme.h      |   2 +
>  drivers/fpga/dfl.h          |   2 +
>  6 files changed, 1035 insertions(+)
>  create mode 100644 drivers/fpga/dfl-fme-perf.c
> 
> -- 
> 1.8.3.1
