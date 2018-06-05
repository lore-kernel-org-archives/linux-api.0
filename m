From: Alan Tull <atull@kernel.org>
Subject: Re: [PATCH v5 11/28] fpga: dfl: add dfl_fpga_check_port_id function.
Date: Tue, 5 Jun 2018 16:25:05 -0500
Message-ID: <CANk1AXRhsTKHJfVBPQL5PwXQF=Tvb_y+V3uE8AicgFrzKZse3A@mail.gmail.com>
References: <1525229431-3087-1-git-send-email-hao.wu@intel.com> <1525229431-3087-12-git-send-email-hao.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1525229431-3087-12-git-send-email-hao.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Wu Hao <hao.wu@intel.com>
Cc: Moritz Fischer <mdf@kernel.org>, linux-fpga@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, "Kang, Luwei" <luwei.kang@intel.com>, "Zhang, Yi Z" <yi.z.zhang@intel.com>
List-Id: linux-api@vger.kernel.org

On Tue, May 1, 2018 at 9:50 PM, Wu Hao <hao.wu@intel.com> wrote:

Hi Hao,

> This patch adds one common function in DFL framework. It uses
> port_ops get_id callback to get port id and compare it with given
> value. This function could be used as match function of the
> dfl_fpga_cdev_find_port function.
>
> Signed-off-by: Wu Hao <hao.wu@intel.com>
Acked-by: Alan Tull <atull@kernel.org>
