From: Alan Tull <atull@kernel.org>
Subject: Re: [PATCH v5 28/28] fpga: dfl: afu: add DFL_FPGA_PORT_DMA_MAP/UNMAP
 ioctls support
Date: Wed, 6 Jun 2018 11:09:23 -0500
Message-ID: <CANk1AXQnvRW9JpRs3w5uBq+hJW3sBTv0FP080uX_+u7VYy-ofw@mail.gmail.com>
References: <1525229431-3087-1-git-send-email-hao.wu@intel.com> <1525229431-3087-29-git-send-email-hao.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1525229431-3087-29-git-send-email-hao.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Wu Hao <hao.wu@intel.com>
Cc: Moritz Fischer <mdf@kernel.org>, linux-fpga@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, "Kang, Luwei" <luwei.kang@intel.com>, "Zhang, Yi Z" <yi.z.zhang@intel.com>, Tim Whisonant <tim.whisonant@intel.com>, Enno Luebbers <enno.luebbers@intel.com>, Shiva Rao <shiva.rao@intel.com>, Christopher Rauer <christopher.rauer@intel.com>, Xiao Guangrong <guangrong.xiao@linux.intel.com>
List-Id: linux-api@vger.kernel.org

On Tue, May 1, 2018 at 9:50 PM, Wu Hao <hao.wu@intel.com> wrote:

Hi Hao,

> DMA memory regions are required for Accelerated Function Unit (AFU) usage.
> These two ioctls allow user space applications to map user memory regions
> for dma, and unmap them after use. Iova is returned from driver to user
> space application via DFL_FPGA_PORT_DMA_MAP ioctl. Application needs to unmap
> it after use, otherwise, driver will unmap them in device file release
> operation.
>
> Each AFU has its own rb tree to keep track of its mapped DMA regions.
>
> Ioctl interfaces:
> * DFL_FPGA_PORT_DMA_MAP
>   Do the dma mapping per user_addr and length which provided by user.
>   Return iova in provided struct dfl_fpga_port_dma_map.
>
> * DFL_FPGA_PORT_DMA_UNMAP
>   Unmap the dma region per iova provided by user.
>
> Signed-off-by: Tim Whisonant <tim.whisonant@intel.com>
> Signed-off-by: Enno Luebbers <enno.luebbers@intel.com>
> Signed-off-by: Shiva Rao <shiva.rao@intel.com>
> Signed-off-by: Christopher Rauer <christopher.rauer@intel.com>
> Signed-off-by: Xiao Guangrong <guangrong.xiao@linux.intel.com>
> Signed-off-by: Wu Hao <hao.wu@intel.com>

Acked-by: Alan Tull <atull@kernel.org>
