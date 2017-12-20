From: Alan Tull <atull-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 01/21] docs: fpga: add a document for Intel FPGA driver overview
Date: Wed, 20 Dec 2017 16:31:15 -0600
Message-ID: <CANk1AXTLBWXGUozXJdKRThJwLiHJ==B--DkkE+YRjveA2YvifQ@mail.gmail.com>
References: <1511764948-20972-1-git-send-email-hao.wu@intel.com> <1511764948-20972-2-git-send-email-hao.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1511764948-20972-2-git-send-email-hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Moritz Fischer <mdf-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-fpga-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Kang, Luwei" <luwei.kang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Zhang, Yi Z" <yi.z.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Enno Luebbers <enno.luebbers-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Xiao Guangrong <guangrong.xiao-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Nov 27, 2017 at 12:42 AM, Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> +
> +PORT
> +====
> +A port represents the interface between the static FPGA fabric (the "blue
> +bitstream") and a partially reconfigurable region containing an AFU (the "green
> +bitstream"). It controls the communication from SW to the accelerator and
> +exposes features such as reset and debug.

Hi Hao,

If I remember correctly, reset means that the accelerator gets reset
and this is something that is desirable to do between jobs.  I've
asked for some documentation about the port reset function, partly
because the idea of being able to reset hardware from userspace
somehow scares me.  So please find a good logical place to explain
what a port reset does and how it is safe for userspace to request it
at some arbitrary time and how it won't crash the kernel.  We
discussed this in v2, I grepped v3 for it, maybe I missed it, but I
don't see it in v3.  My understanding is that disabling and reenabling
the port bridge causes the accelerator in its FPGA region to get
reset.

Alan

> +
> +A PCIe device may have several ports and each port can be released from PF by
> +FPGA_FME_PORT_RELEASE ioctl on FME, and exposed through a VF via PCIe sriov
> +sysfs interface.
> +
