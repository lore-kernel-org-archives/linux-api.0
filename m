From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v2 00/11] FPGA DFL updates
Date: Wed, 10 Jul 2019 07:54:17 +0200
Message-ID: <20190710055417.GA5778@kroah.com>
References: <1562286238-11413-1-git-send-email-hao.wu@intel.com>
 <20190710050746.GA28620@hao-dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190710050746.GA28620@hao-dev>
Sender: linux-kernel-owner@vger.kernel.org
To: Wu Hao <hao.wu@intel.com>
Cc: mdf@kernel.org, linux-fpga@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, atull@kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, Jul 10, 2019 at 01:07:46PM +0800, Wu Hao wrote:
> On Fri, Jul 05, 2019 at 08:23:47AM +0800, Wu Hao wrote:
> > Hi Greg / Moritz
> > 
> > This is v2 patchset which adds more features to FPGA DFL. This patchset
> > is made on top of patch[1] and char-misc-next tree. Documentation patch
> > for DFL is dropped from this patchset, and will resubmit it later to
> > avoid conflict.
> 
> Hi Greg,
> 
> Did you get a chance to take a look at this new version to see if these
> patches are good to take?
> 
> Hope we can catch up with the merge window.

You sent them last Friday.  I actually tried to not do kernel work last
weekend.  The merge window opened up on Sunday.  My trees should have
been closed last week, so no, this missed this merge window, I'll
review these patches once 5.3-rc1 is out.

thanks

greg k-h
