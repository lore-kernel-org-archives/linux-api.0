From: Wu Hao <hao.wu@intel.com>
Subject: Re: [PATCH v4 23/24] fpga: dfl: afu: add user afu sub feature support
Date: Wed, 21 Mar 2018 11:00:38 +0800
Message-ID: <20180321030038.GB3489@hao-dev>
References: <1518513893-4719-1-git-send-email-hao.wu@intel.com>
 <1518513893-4719-24-git-send-email-hao.wu@intel.com>
 <CANk1AXQpPXhNoPt1Uj=YvbtO+jun7e2Yzvyp+wuR1ZXx6+-i8Q@mail.gmail.com>
 <20180320071037.GB31239@hao-dev>
 <CANk1AXRqfiWCDEo31-QGoKdUQ6PCjHH69LkuZdjErgGA-qxbiQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CANk1AXRqfiWCDEo31-QGoKdUQ6PCjHH69LkuZdjErgGA-qxbiQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Alan Tull <atull@kernel.org>
Cc: Moritz Fischer <mdf@kernel.org>, linux-fpga@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, "Kang, Luwei" <luwei.kang@intel.com>, "Zhang, Yi Z" <yi.z.zhang@intel.com>, Xiao Guangrong <guangrong.xiao@linux.intel.com>, Tim Whisonant <tim.whisonant@intel.com>, Enno Luebbers <enno.luebbers@intel.com>, Shiva Rao <shiva.rao@intel.com>, Christopher Rauer <christopher.rauer@intel.com>
List-Id: linux-api@vger.kernel.org

On Tue, Mar 20, 2018 at 01:17:14PM -0500, Alan Tull wrote:
> On Tue, Mar 20, 2018 at 2:10 AM, Wu Hao <hao.wu@intel.com> wrote:
> > On Mon, Mar 19, 2018 at 03:10:28PM -0500, Alan Tull wrote:
> >> On Tue, Feb 13, 2018 at 3:24 AM, Wu Hao <hao.wu@intel.com> wrote:
> >>
> >> Hi Hao,
> >>
> >> > From: Xiao Guangrong <guangrong.xiao@linux.intel.com>
> >> >
> >> > User Accelerated Function Unit sub feature exposes the MMIO region of
> >>
> >> Is it 'user accelerated'?  I think it is the Accelerator interface.
> >
> > Hi Alan,
> >
> > This is only used to emphasize this is the interface to accelerator
> > exposed to user. But looks like this causes some confusions for user
> > actually from the description. I agree with you, that I will remove
> > this UAFU from this patchset.
> >
> >>
> >> > the AFU. After valid green bitstream (GBS) is programmed and port is
> >>
> >> Would it make sense to just use "partial bitstream" or "PR bitstream"
> >> and "static bitstream" for this patchset?  I don't think that adding
> >> this terminology makes things clearer.  In any case when someone else
> >> uses this patchset, they may not be using this type of branding in
> >> their terminology.
> >
> > Sure, will update the commit message and also sysfs doc below.
> 
> Yes and dfl.txt and the rest of the patchset as well, please.

Sure, I understand that it may have different PR hardwares under this
framework, each PR hardware may have a different terminology for its own
bitstream. We should use common terminology in the common doc and code
to avoid confusion. Thanks for the reminder. I will fix this.

Thanks
Hao

> 
> Alan
