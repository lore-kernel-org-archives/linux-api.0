From: Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v6 0/2] add performance reporting support to FPGA DFL
 drivers
Date: Tue, 14 Jan 2020 13:56:05 +0800
Message-ID: <20200114055605.GA13574@hao-dev>
References: <1573622695-25607-1-git-send-email-hao.wu@intel.com>
 <20191125033412.GB890@hao-dev>
 <20191125080127.GC1809@willie-the-truck>
 <20191125080839.GA6227@hao-dev>
 <20191209024527.GA22625@hao-dev>
 <20191216010104.GA32154@yilunxu-OptiPlex-7050>
 <20200106023742.GA3980@hao-dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20200106023742.GA3980@hao-dev>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: mdf-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Will Deacon <will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: mark.rutland-5wv7dgnIgG8@public.gmane.org, linux-fpga-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, atull-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, yilun.xu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, Jan 06, 2020 at 10:37:42AM +0800, Wu Hao wrote:
> On Mon, Dec 16, 2019 at 09:01:04AM +0800, Xu Yilum wrote:
> > On Mon, Dec 09, 2019 at 10:45:27AM +0800, Wu Hao wrote:
> > > On Mon, Nov 25, 2019 at 04:08:39PM +0800, Wu Hao wrote:
> > > > On Mon, Nov 25, 2019 at 08:01:28AM +0000, Will Deacon wrote:
> > > > > On Mon, Nov 25, 2019 at 11:34:12AM +0800, Wu Hao wrote:
> > > > > > Hi Will and Mark,
> > > > > > 
> > > > > > Could you please help us on review this patchset? as this patchset mainly 
> > > > > > introduced a new perf driver following the similar way as drivers/perf/*.
> > > > > 
> > > > > Why is it not under drivers/perf/, then?
> > > > 
> > > > Hi Will
> > > > 
> > > > Thanks for the quick response. This is one sub feature for DFL based FPGAs,
> > > > and we plan to put this sub feature together with others, including related
> > > > documentation. It only registers a standard perf pmu for its userspace
> > > > interfaces.
> > > > 
> > > > > 
> > > > > > This patchset has been submitted for a long time but didn't receive any
> > > > > > comment after v4. we appreciate any review comments! thanks in advance. :)
> > > > > 
> > > > > Hmm, not sure I saw the previous versions. Guessing I wasn't on cc?
> > > > 
> > > > We switched to perf API from v4, and started ccing you and Mark from v5. :)
> > > 
> > > Hi Will
> > > 
> > > Did you get a chance to look into this patchset?
> > > 
> > > Thanks
> > > Hao
> > 
> > Hi Will
> > 
> > Did you have time to look into this patchset? We have done review work
> > for FPGA part. And as a perf driver, we appreciate your comments.
> > 
> > Thanks
> > Yilun
> 
> Hi Will
> 
> Did you get a chance to look into this patchset these days? 
> 
> Actually we didn't receive any comments for a long time, if you are busy and
> don't have enough time on this, do you know if someone else could help with
> review and ack from perf driver point of view, or any other things we can do
> to speed up this? Thanks in advance! 

Hi Moritz

Looks like still no response from Will. :(

Do you know someone else could help?

Thanks
Hao

> 
> Hao
> 
> > 
> > > 
> > > > 
> > > > Thanks
> > > > Hao
> > > > 
> > > > > 
> > > > > Will
