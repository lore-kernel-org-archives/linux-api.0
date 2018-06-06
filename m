From: Alan Tull <atull@kernel.org>
Subject: Re: [PATCH v5 24/28] fpga: dfl: afu: add port ops support
Date: Wed, 6 Jun 2018 10:57:43 -0500
Message-ID: <CANk1AXSVe7xudu0Tw6jrJZcVZBg98QMJnPBWJ5bqf09p6vwOqw@mail.gmail.com>
References: <1525229431-3087-1-git-send-email-hao.wu@intel.com> <1525229431-3087-25-git-send-email-hao.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1525229431-3087-25-git-send-email-hao.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Wu Hao <hao.wu@intel.com>
Cc: Moritz Fischer <mdf@kernel.org>, linux-fpga@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, "Kang, Luwei" <luwei.kang@intel.com>, "Zhang, Yi Z" <yi.z.zhang@intel.com>
List-Id: linux-api@vger.kernel.org

On Tue, May 1, 2018 at 9:50 PM, Wu Hao <hao.wu@intel.com> wrote:

Hi Hao,

> This patch registers the port ops into the global list in the DFL
> framework, and it allows other modules to use the port ops. And
> This patch includes the implementation of the get_id and enable_set
> ops too.
>
> Signed-off-by: Wu Hao <hao.wu@intel.com>
Acked-by: Alan Tull <atull@kernel.org>

> ---
>  drivers/fpga/dfl-afu-main.c | 122 +++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 121 insertions(+), 1 deletion(-)
