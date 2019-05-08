From: Alan Tull <atull@kernel.org>
Subject: Re: [PATCH v2 02/18] fpga: dfl: fme: remove copy_to_user() in ioctl
 for PR
Date: Wed, 8 May 2019 12:58:59 -0500
Message-ID: <CANk1AXQW-BhHgaYkvYKU3tHRiFvj9_O3xteTh9cmfna2JKYauQ@mail.gmail.com>
References: <1556528151-17221-1-git-send-email-hao.wu@intel.com>
 <1556528151-17221-3-git-send-email-hao.wu@intel.com> <20190507172545.GA26690@archbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190507172545.GA26690@archbox>
Sender: linux-kernel-owner@vger.kernel.org
To: Moritz Fischer <mdf@kernel.org>
Cc: Wu Hao <hao.wu@intel.com>, linux-fpga@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, Xu Yilun <yilun.xu@intel.com>
List-Id: linux-api@vger.kernel.org

On Tue, May 7, 2019 at 12:26 PM Moritz Fischer <mdf@kernel.org> wrote:
>
> On Mon, Apr 29, 2019 at 04:55:35PM +0800, Wu Hao wrote:
> > This patch removes copy_to_user() code in partial reconfiguration
> > ioctl, as it's useless as user never needs to read the data
> > structure after ioctl.
> >
> > Signed-off-by: Xu Yilun <yilun.xu@intel.com>
> > Signed-off-by: Wu Hao <hao.wu@intel.com>
> Acked-by: Moritz Fischer <mdf@kernel.org>

Acked-by: Alan Tull <atull@kernel.org>

Alan

> > ---
> > v2: clean up code split from patch 2 in v1 patchset.
> > ---
> >  drivers/fpga/dfl-fme-pr.c | 3 ---
> >  1 file changed, 3 deletions(-)
> >
> > diff --git a/drivers/fpga/dfl-fme-pr.c b/drivers/fpga/dfl-fme-pr.c
> > index d9ca955..6ec0f09 100644
> > --- a/drivers/fpga/dfl-fme-pr.c
> > +++ b/drivers/fpga/dfl-fme-pr.c
> > @@ -159,9 +159,6 @@ static int fme_pr(struct platform_device *pdev, unsigned long arg)
> >       mutex_unlock(&pdata->lock);
> >  free_exit:
> >       vfree(buf);
> > -     if (copy_to_user((void __user *)arg, &port_pr, minsz))
> > -             return -EFAULT;
> > -
> >       return ret;
> >  }
> >
> > --
> > 1.8.3.1
> >
