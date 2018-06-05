From: Alan Tull <atull@kernel.org>
Subject: Re: [PATCH v5 10/28] fpga: dfl: add dfl_fpga_port_ops support.
Date: Tue, 5 Jun 2018 16:24:26 -0500
Message-ID: <CANk1AXTezwLOZOy3E=herSatYRm9mATdqO8WFcbEbRGpfK5mRQ@mail.gmail.com>
References: <1525229431-3087-1-git-send-email-hao.wu@intel.com> <1525229431-3087-11-git-send-email-hao.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1525229431-3087-11-git-send-email-hao.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Wu Hao <hao.wu@intel.com>
Cc: Moritz Fischer <mdf@kernel.org>, linux-fpga@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, "Kang, Luwei" <luwei.kang@intel.com>, "Zhang, Yi Z" <yi.z.zhang@intel.com>
List-Id: linux-api@vger.kernel.org

On Tue, May 1, 2018 at 9:50 PM, Wu Hao <hao.wu@intel.com> wrote:

Hi Hao,

> In some cases, other DFL driver modules may need to access some port
> operations, e.g disable / enable port for partial reconfiguration in
> FME module. In order to avoid dependency between port and FME modules,
> this patch introduces the dfl_fpga_port_ops support in DFL framework.
> A global dfl_fpga_port_ops list is added in the DFL framework, and
> it allows other DFL modules to use these port operations registered
> to this list, even in virtualization case, the port platform device
> is turned into VF / guest VM and hidden in host, the registered
> port_ops is still usable. It resolves the dependency issues between
> modules, but once get port ops API returns a valid port ops, that
> means related port driver module has been module_get to prevent from
> unexpected unload, and put port ops API must be invoked after use.
>
> These APIs introduced by this patch is listed below:
>  * dfl_fpga_add_port_ops
>    add one port ops to the global list.
>
>  * dfl_fpga_del_port_ops
>    del one port ops from the global list.
>
>  * dfl_fpga_get_port_ops / dfl_fpga_put_port_ops
>    get/put the port ops before/after use.
>
> Signed-off-by: Wu Hao <hao.wu@intel.com>
Acked-by: Alan Tull <atull@kernel.org>
> ---
>  drivers/fpga/dfl.c | 67 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  drivers/fpga/dfl.h | 21 +++++++++++++++++
>  2 files changed, 88 insertions(+)
>
