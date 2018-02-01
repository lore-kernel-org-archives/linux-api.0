From: Wu Hao <hao.wu@intel.com>
Subject: Re: [PATCH v3 02/21] fpga: mgr: add region_id to fpga_image_info
Date: Thu, 1 Feb 2018 13:05:02 +0800
Message-ID: <20180201050502.GA10273@hao-dev>
References: <1511764948-20972-1-git-send-email-hao.wu@intel.com>
 <1511764948-20972-3-git-send-email-hao.wu@intel.com>
 <20171129061107.w62q5tk5dplq2zmr@us-aus-ras-130-164-29-6.amer.corp.natinst.com>
 <CANk1AXTbrD3w=VEzXqTRfebgTYSRNGANthwN_PLVz8WWtxb7CA@mail.gmail.com>
 <20171205033611.GB19730@hao-dev>
 <CANk1AXT=6yNsMs4jDhwYonJ0FoLQjbTSWEjsa8Sjw+qOLXVCtw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CANk1AXT=6yNsMs4jDhwYonJ0FoLQjbTSWEjsa8Sjw+qOLXVCtw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Alan Tull <atull@kernel.org>
Cc: Moritz Fischer <mdf@kernel.org>, linux-fpga@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, "Kang, Luwei" <luwei.kang@intel.com>, "Zhang, Yi Z" <yi.z.zhang@intel.com>
List-Id: linux-api@vger.kernel.org

On Wed, Jan 31, 2018 at 09:35:20AM -0600, Alan Tull wrote:
> On Mon, Dec 4, 2017 at 9:36 PM, Wu Hao <hao.wu@intel.com> wrote:
> > On Mon, Dec 04, 2017 at 02:26:14PM -0600, Alan Tull wrote:
> >> On Wed, Nov 29, 2017 at 12:11 AM, Moritz Fischer <mdf@kernel.org> wrote:
> >> > Hi Hao,
> >> >
> >> > On Mon, Nov 27, 2017 at 02:42:09PM +0800, Wu Hao wrote:
> >> >> This patch adds region_id to fpga_image_info data structure, it
> >> >> allows driver to pass region id information to fpga-mgr via
> >> >> fpga_image_info for fpga reconfiguration function.
> >> >>
> >> >> Signed-off-by: Wu Hao <hao.wu@intel.com>
> >> > Acked-by: Moritz Fischer <mdf@kernel.org>
> >>
> >> Acked-by: Alan Tull <atull@kernel.org>
> >
> > Hi Alan / Moritz
> >
> > Thanks for the review. :)
> 
> Just to be clear, when you post the next version, keep the Acks that
> have been added.

Sure, I will keep the Acks in the next version.

Thanks
Hao
