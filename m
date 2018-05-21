From: Wu Hao <hao.wu@intel.com>
Subject: Re: [PATCH v5 04/28] fpga: mgr: add compat_id support
Date: Mon, 21 May 2018 11:03:07 +0800
Message-ID: <20180521030307.GA26500@hao-dev>
References: <1525229431-3087-1-git-send-email-hao.wu@intel.com>
 <1525229431-3087-5-git-send-email-hao.wu@intel.com>
 <CANk1AXRsWsd++wjWH44CCWN+cmscy_WjLJhaGGgxmmNe-u1OLw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CANk1AXRsWsd++wjWH44CCWN+cmscy_WjLJhaGGgxmmNe-u1OLw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Alan Tull <atull@kernel.org>
Cc: Moritz Fischer <mdf@kernel.org>, linux-fpga@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, "Kang, Luwei" <luwei.kang@intel.com>, "Zhang, Yi Z" <yi.z.zhang@intel.com>, song.liu@intel.com
List-Id: linux-api@vger.kernel.org

On Mon, May 07, 2018 at 04:09:06PM -0500, Alan Tull wrote:
> On Tue, May 1, 2018 at 9:50 PM, Wu Hao <hao.wu@intel.com> wrote:
> 
> Hi Hao,
> 
> Looks good!
> 
> > This patch introduces compat_id support to fpga manager, it adds
> > a fpga_compat_id pointer to fpga manager data structure to allow
> > fpga manager drivers to save the compatibility id. This compat_id
> > could be used for compatibility checking before doing partial
> > reconfiguration to associated fpga regions.
> >
> > Signed-off-by: Wu Hao <hao.wu@intel.com>
> Acked-by: Alan Tull <atull@kernel.org>

Hi Alan

Thanks a lot for the acked-by.

Did you get a chance to look into other patches?

Thanks
Hao
