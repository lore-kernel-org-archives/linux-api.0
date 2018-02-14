From: Alan Tull <atull-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v4 11/24] fpga: dfl: fme: add header sub feature support
Date: Wed, 14 Feb 2018 10:36:26 -0600
Message-ID: <CANk1AXTDC2YROkdFyhnnAn28nwrv7UHt5_saFGDn4-8VRqS7Sw@mail.gmail.com>
References: <1518513893-4719-1-git-send-email-hao.wu@intel.com> <1518513893-4719-12-git-send-email-hao.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1518513893-4719-12-git-send-email-hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Moritz Fischer <mdf-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-fpga-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Kang, Luwei" <luwei.kang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Zhang, Yi Z" <yi.z.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tim Whisonant <tim.whisonant-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Enno Luebbers <enno.luebbers-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Shiva Rao <shiva.rao-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Christopher Rauer <christopher.rauer-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Xiao Guangrong <guangrong.xiao-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Feb 13, 2018 at 3:24 AM, Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:

Hi Hao,

Looks good.

> From: Kang Luwei <luwei.kang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>
> The Header Register set is always present for FPGA Management Engine (FME),
> this patch implements init and uinit function for header sub feature and
> introduce several read-only sysfs interfaces for the capability and status.
>
> Sysfs interfaces:
> * /sys/class/fpga_region/<regionX>/<dfl-fme.x>/ports_num
>   Read-only. Number of ports implemented
>
> * /sys/class/fpga_region/<regionX>/<dfl-fme.x>/bitstream_id
>   Read-only. Blue Bitstream (static FPGA region) identifier number. It contains
>   the detailed version and other information of this static FPGA region.
>
> * /sys/class/fpga_region/<regionX>/<dfl-fme.x>/bitstream_metadata
>   Read-only. Blue Bitstream (static FPGA region) meta data. It contains the
>   synthesis date, seed and other information of this static FPGA region.
>
> Signed-off-by: Tim Whisonant <tim.whisonant-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Enno Luebbers <enno.luebbers-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Shiva Rao <shiva.rao-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Christopher Rauer <christopher.rauer-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Kang Luwei <luwei.kang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Xiao Guangrong <guangrong.xiao-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> Signed-off-by: Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Acked-by: Alan Tull <atull-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Thanks,
Alan
