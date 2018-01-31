From: Alan Tull <atull-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 15/21] fpga: dfl: add fpga bridge platform driver for FME
Date: Wed, 31 Jan 2018 09:16:58 -0600
Message-ID: <CANk1AXS-ioW2svMS3QwrQCF5TiHp_nwaongC=d2Z2MfT8BEMMw@mail.gmail.com>
References: <1511764948-20972-1-git-send-email-hao.wu@intel.com> <1511764948-20972-16-git-send-email-hao.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1511764948-20972-16-git-send-email-hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Moritz Fischer <mdf-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-fpga-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Kang, Luwei" <luwei.kang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Zhang, Yi Z" <yi.z.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tim Whisonant <tim.whisonant-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Enno Luebbers <enno.luebbers-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Shiva Rao <shiva.rao-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Christopher Rauer <christopher.rauer-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Nov 27, 2017 at 12:42 AM, Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:

Hi Hao,

One fix below.  Besides that, please add my ack.

> This patch adds fpga bridge platform driver for FPGA Management Engine.
> It implements the enable_set call back for fpga bridge.
>
> Signed-off-by: Tim Whisonant <tim.whisonant-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Enno Luebbers <enno.luebbers-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Shiva Rao <shiva.rao-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Christopher Rauer <christopher.rauer-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Acked-by: Alan Tull <atull-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

> diff --git a/drivers/fpga/fpga-dfl-fme-br.c b/drivers/fpga/fpga-dfl-fme-br.c
> new file mode 100644
> index 0000000..db2603b
> --- /dev/null
> +++ b/drivers/fpga/fpga-dfl-fme-br.c
> @@ -0,0 +1,87 @@
> +/*
> + * FPGA Bridge Driver for FPGA Management Engine (FME)
> + *
> + * Copyright (C) 2017 Intel Corporation, Inc.
> + *
> + * Authors:
> + *   Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> + *   Joseph Grecco <joe.grecco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> + *   Enno Luebbers <enno.luebbers-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> + *   Tim Whisonant <tim.whisonant-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> + *   Ananda Ravuri <ananda.ravuri-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> + *   Henry Mitchel <henry.mitchel-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> + *
> + * This work is licensed under the terms of the GNU GPL version 2.

If we're using the SPDX, then please get rid of the above line.

> + * SPDX-License-Identifier: GPL-2.0
> + */

The SPDX line should be the first line of the file with a // (for .c
files), please see:

https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/tree/Documentation/process/license-rules.rst

Same thing for other files.

Alan
