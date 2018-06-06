From: Alan Tull <atull@kernel.org>
Subject: Re: [PATCH v5 27/28] fpga: dfl: afu: add afu sub feature support
Date: Wed, 6 Jun 2018 11:04:15 -0500
Message-ID: <CANk1AXRVdZp7zCfY+YCBVubQa1iWYNq00xv=aQ=G3nwR-_vePg@mail.gmail.com>
References: <1525229431-3087-1-git-send-email-hao.wu@intel.com> <1525229431-3087-28-git-send-email-hao.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1525229431-3087-28-git-send-email-hao.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Wu Hao <hao.wu@intel.com>
Cc: Moritz Fischer <mdf@kernel.org>, linux-fpga@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, "Kang, Luwei" <luwei.kang@intel.com>, "Zhang, Yi Z" <yi.z.zhang@intel.com>, Xiao Guangrong <guangrong.xiao@linux.intel.com>, Tim Whisonant <tim.whisonant@intel.com>, Enno Luebbers <enno.luebbers@intel.com>, Shiva Rao <shiva.rao@intel.com>, Christopher Rauer <christopher.rauer@intel.com>
List-Id: linux-api@vger.kernel.org

On Tue, May 1, 2018 at 9:50 PM, Wu Hao <hao.wu@intel.com> wrote:

Hi Hao,

> From: Xiao Guangrong <guangrong.xiao@linux.intel.com>
>
> User Accelerated Function Unit sub feature exposes the MMIO region of
> the AFU. After valid PR bitstream is programmed and the port is enabled,
> then this MMIO region could be accessed.
>
> This patch adds support to enumerate the AFU MMIO region and expose it
> to userspace via mmap file operation. Below interfaces are exposed to user:
>
> Sysfs interface:
> * /sys/class/fpga_region/<regionX>/<dfl-port.x>/afu_id
>   Read-only. Indicate which PR bitstream is programmed to this AFU.
>
> Ioctl interfaces:
> * DFL_FPGA_PORT_GET_INFO
>   Provide info to userspace on the number of supported region.
>   Only UAFU region is supported now.
>
> * DFL_FPGA_PORT_GET_REGION_INFO
>   Provide region information, including access permission, region size,
>   offset from the start of device fd.
>
> Signed-off-by: Tim Whisonant <tim.whisonant@intel.com>
> Signed-off-by: Enno Luebbers <enno.luebbers@intel.com>
> Signed-off-by: Shiva Rao <shiva.rao@intel.com>
> Signed-off-by: Christopher Rauer <christopher.rauer@intel.com>
> Signed-off-by: Xiao Guangrong <guangrong.xiao@linux.intel.com>
> Signed-off-by: Wu Hao <hao.wu@intel.com>
Acked-by: Alan Tull <atull@kernel.org>
