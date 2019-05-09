From: Alan Tull <atull@kernel.org>
Subject: Re: [PATCH v2 12/18] fpga: dfl: afu: add error reporting support.
Date: Thu, 9 May 2019 09:41:18 -0500
Message-ID: <CANk1AXQ6mcQ2td02j2g=n5cxOri--bp3yV5t7OCgK5Rc3QVHMQ@mail.gmail.com>
References: <1556528151-17221-1-git-send-email-hao.wu@intel.com> <1556528151-17221-13-git-send-email-hao.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1556528151-17221-13-git-send-email-hao.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Wu Hao <hao.wu@intel.com>
Cc: Moritz Fischer <mdf@kernel.org>, linux-fpga@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, Xu Yilun <yilun.xu@intel.com>
List-Id: linux-api@vger.kernel.org

On Mon, Apr 29, 2019 at 4:12 AM Wu Hao <hao.wu@intel.com> wrote:
>
> Error reporting is one important private feature, it reports error
> detected on port and accelerated function unit (AFU). It introduces
> several sysfs interfaces to allow userspace to check and clear
> errors detected by hardware.
>
> Signed-off-by: Xu Yilun <yilun.xu@intel.com>
> Signed-off-by: Wu Hao <hao.wu@intel.com>

Acked-by: Alan Tull <atull@kernel.org>

Thanks!
Alan

> ---
> v2: add more error code description for error clear sysfs in doc.
>     return -EINVAL instead of -EBUSY when input error code doesn't
>     match in error clear sysfs.
> ---
>  Documentation/ABI/testing/sysfs-platform-dfl-port |  39 ++++
>  drivers/fpga/Makefile                             |   1 +
>  drivers/fpga/dfl-afu-error.c                      | 225 ++++++++++++++++++++++
>  drivers/fpga/dfl-afu-main.c                       |   4 +
>  drivers/fpga/dfl-afu.h                            |   4 +
>  5 files changed, 273 insertions(+)
>  create mode 100644 drivers/fpga/dfl-afu-error.c
