From: Alan Tull <atull@kernel.org>
Subject: Re: [PATCH 02/17] fpga: dfl: fme: align PR buffer size per PR datawidth
Date: Thu, 28 Mar 2019 13:50:11 -0500
Message-ID: <CANk1AXRZWgZFrShr=AVeoW2SP8zGA_Gv4eOw4Dvko_hXi_ivHQ@mail.gmail.com>
References: <1553483264-5379-1-git-send-email-hao.wu@intel.com>
 <1553483264-5379-3-git-send-email-hao.wu@intel.com> <CANk1AXSUMkfQu8QnN-T0B5qeA4vaGxDTvGur9EGyLbGsBFBeKQ@mail.gmail.com>
 <20190326002852.GA2901@hao-dev>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190326002852.GA2901@hao-dev>
Sender: linux-kernel-owner@vger.kernel.org
To: Wu Hao <hao.wu@intel.com>
Cc: Moritz Fischer <mdf@kernel.org>, linux-fpga@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, Xu Yilun <yilun.xu@intel.com>
List-Id: linux-api@vger.kernel.org

On Mon, Mar 25, 2019 at 7:44 PM Wu Hao <hao.wu@intel.com> wrote:
>
> On Mon, Mar 25, 2019 at 12:50:40PM -0500, Alan Tull wrote:
> > On Sun, Mar 24, 2019 at 10:23 PM Wu Hao <hao.wu@intel.com> wrote:
> >
> > Hi Hao,
> >
> > Looks good, one question below.
> >
> > >
> > > Current driver checks if input bitstream file size is aligned or
> > > not per PR data width (default 32bits). It requires one additional
> > > step for end user when they generate the bitstream file, padding
> > > extra zeros to bitstream file to align its size per PR data width,
> > > but they don't have to as hardware will drop extra padding bytes
> > > automatically.
> > >
> > > In order to simplify the user steps, this patch aligns PR buffer
> > > size per PR data width in driver, to allow user to pass unaligned
> > > size bitstream files to driver.
> > >
> > > Signed-off-by: Xu Yilun <yilun.xu@intel.com>
> > > Signed-off-by: Wu Hao <hao.wu@intel.com>

Acked-by: Alan Tull <atull@kernel.org>

Thanks,
Alan
