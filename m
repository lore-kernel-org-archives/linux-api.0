From: Wu Hao <hao.wu@intel.com>
Subject: Re: [PATCH v6 0/2] add performance reporting support to FPGA DFL
 drivers
Date: Mon, 25 Nov 2019 16:08:39 +0800
Message-ID: <20191125080839.GA6227@hao-dev>
References: <1573622695-25607-1-git-send-email-hao.wu@intel.com>
 <20191125033412.GB890@hao-dev>
 <20191125080127.GC1809@willie-the-truck>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20191125080127.GC1809@willie-the-truck>
Sender: linux-kernel-owner@vger.kernel.org
To: Will Deacon <will@kernel.org>
Cc: mdf@kernel.org, mark.rutland@arm.com, linux-fpga@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, atull@kernel.org, gregkh@linuxfoundation.org
List-Id: linux-api@vger.kernel.org

On Mon, Nov 25, 2019 at 08:01:28AM +0000, Will Deacon wrote:
> On Mon, Nov 25, 2019 at 11:34:12AM +0800, Wu Hao wrote:
> > Hi Will and Mark,
> > 
> > Could you please help us on review this patchset? as this patchset mainly 
> > introduced a new perf driver following the similar way as drivers/perf/*.
> 
> Why is it not under drivers/perf/, then?

Hi Will

Thanks for the quick response. This is one sub feature for DFL based FPGAs,
and we plan to put this sub feature together with others, including related
documentation. It only registers a standard perf pmu for its userspace
interfaces.

> 
> > This patchset has been submitted for a long time but didn't receive any
> > comment after v4. we appreciate any review comments! thanks in advance. :)
> 
> Hmm, not sure I saw the previous versions. Guessing I wasn't on cc?

We switched to perf API from v4, and started ccing you and Mark from v5. :)

Thanks
Hao

> 
> Will
