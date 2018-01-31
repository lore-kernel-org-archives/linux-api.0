From: Alan Tull <atull@kernel.org>
Subject: Re: [PATCH v3 16/21] fpga: dfl: add fpga region platform driver for FME
Date: Wed, 31 Jan 2018 14:46:28 -0600
Message-ID: <CANk1AXTBprjzr71xa=YD5jR77822xugVEQMboxhzAJFY8YFMxw@mail.gmail.com>
References: <1511764948-20972-1-git-send-email-hao.wu@intel.com> <1511764948-20972-17-git-send-email-hao.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1511764948-20972-17-git-send-email-hao.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Wu Hao <hao.wu@intel.com>
Cc: Moritz Fischer <mdf@kernel.org>, linux-fpga@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, "Kang, Luwei" <luwei.kang@intel.com>, "Zhang, Yi Z" <yi.z.zhang@intel.com>, Tim Whisonant <tim.whisonant@intel.com>, Enno Luebbers <enno.luebbers@intel.com>, Shiva Rao <shiva.rao@intel.com>, Christopher Rauer <christopher.rauer@intel.com>
List-Id: linux-api@vger.kernel.org

On Mon, Nov 27, 2017 at 12:42 AM, Wu Hao <hao.wu@intel.com> wrote:

Hi Hao,

Just fix the SPDX, otherwise it looks good.

> This patch adds fpga region platform driver for FPGA Management Engine.
> It register an fpga region with given fpga manager / bridge device.
>
> Signed-off-by: Tim Whisonant <tim.whisonant@intel.com>
> Signed-off-by: Enno Luebbers <enno.luebbers@intel.com>
> Signed-off-by: Shiva Rao <shiva.rao@intel.com>
> Signed-off-by: Christopher Rauer <christopher.rauer@intel.com>
> Signed-off-by: Wu Hao <hao.wu@intel.com>
Acked-by: Alan Tull <atull@kernel.org>


> diff --git a/drivers/fpga/fpga-dfl-fme-region.c b/drivers/fpga/fpga-dfl-fme-region.c
> new file mode 100644
> index 0000000..0b988ab
> --- /dev/null
> +++ b/drivers/fpga/fpga-dfl-fme-region.c
> @@ -0,0 +1,92 @@
> +/*
> + * FPGA Region Driver for FPGA Management Engine (FME)
> + *
> + * Copyright (C) 2017 Intel Corporation, Inc.
> + *
> + * Authors:
> + *   Wu Hao <hao.wu@intel.com>
> + *   Joseph Grecco <joe.grecco@intel.com>
> + *   Enno Luebbers <enno.luebbers@intel.com>
> + *   Tim Whisonant <tim.whisonant@intel.com>
> + *   Ananda Ravuri <ananda.ravuri@intel.com>
> + *   Henry Mitchel <henry.mitchel@intel.com>
> + *
> + * This work is licensed under the terms of the GNU GPL version 2.
> + * SPDX-License-Identifier: GPL-2.0
> + */
> +
> +#include <linux/module.h>

Thanks,
Alan
