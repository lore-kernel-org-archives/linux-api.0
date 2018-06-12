From: Alan Tull <atull@kernel.org>
Subject: Re: [PATCH v6 07/29] fpga: dfl: add chardev support for feature devices
Date: Tue, 12 Jun 2018 10:55:00 -0500
Message-ID: <CANk1AXQVFD-CATaGtjPAPf9tA86rRh1DtHx6_U7W1Wk-CRBA2A@mail.gmail.com>
References: <1528798243-2029-1-git-send-email-hao.wu@intel.com> <1528798243-2029-8-git-send-email-hao.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1528798243-2029-8-git-send-email-hao.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Wu Hao <hao.wu@intel.com>
Cc: Moritz Fischer <mdf@kernel.org>, linux-fpga@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, "Kang, Luwei" <luwei.kang@intel.com>, "Zhang, Yi Z" <yi.z.zhang@intel.com>, Tim Whisonant <tim.whisonant@intel.com>, Enno Luebbers <enno.luebbers@intel.com>, Shiva Rao <shiva.rao@intel.com>, Christopher Rauer <christopher.rauer@intel.com>, Xiao Guangrong <guangrong.xiao@linux.intel.com>
List-Id: linux-api@vger.kernel.org

On Tue, Jun 12, 2018 at 5:10 AM, Wu Hao <hao.wu@intel.com> wrote:
> For feature devices drivers, both the FPGA Management Engine (FME) and
> Accelerated Function Unit (AFU) driver need to expose user interfaces via
> the device file, for example, mmap and ioctls.
>
> This patch adds chardev support in the dfl driver for feature devices,
> FME and AFU. It reserves the chardev regions for FME and AFU, and provide
> interfaces for FME and AFU driver to register their device file operations.
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
> v2: rebased
> v3: move chardev support to fpga-dfl framework
> v4: rebase, and add more comments in code.
> v5: rebase, and add dfl_ prefix to APIs and data structures.
> v6: add index in dfl_devs to link to dfl_chrdevs.
>     improve naming on APIs.
