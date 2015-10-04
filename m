From: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [PATCH v2] scsi: dpt: remove i2o header in uapi
Date: Sun, 4 Oct 2015 13:12:25 +0100
Message-ID: <20151004121225.GA12863@kroah.com>
References: <1443712510-6714-1-git-send-email-gabriel@lse.epita.fr>
 <1443914571-19312-1-git-send-email-gabriel@lse.epita.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1443914571-19312-1-git-send-email-gabriel-tU7rkvAWjlwhT4uAktR2oQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Gabriel Laskar <gabriel-tU7rkvAWjlwhT4uAktR2oQ@public.gmane.org>
Cc: Adaptec OEM Raid Solutions <aacraid-ugMvIWC9OiRBDgjK7y7TUQ@public.gmane.org>, "James E.J. Bottomley" <JBottomley-wo1vFcy6AUs@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Hans Verkuil <hans.verkuil-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Masahiro Yamada <yamada.m-NAum8xwdG0+S7A1Ibl2khg@public.gmane.org>, stephen hemminger <stephen-OTpzqLSitTUnbdJkjeBofR2eb7JE58TQ@public.gmane.org>, Nicolas Dichtel <nicolas.dichtel-pdR9zngts4EAvxtiuMwx3w@public.gmane.org>, "open list:DPT_I2O SCSI RAID DRIVER" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:ABI/API" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Sun, Oct 04, 2015 at 01:22:50AM +0200, Gabriel Laskar wrote:
> The i2o subsystem was removed by
> commit 4a72a7af462d ("staging: remove i2o subsystem") but the header was
> still used by drivers/scsi/dpt_i2o.c driver.
> 
> This patch moves the structures used from the header into dpti_i2o.h.
> 
> CC: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
> CC: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
> Signed-off-by: Gabriel Laskar <gabriel-tU7rkvAWjlwhT4uAktR2oQ@public.gmane.org>
> ---
>  drivers/scsi/dpt/dpti_i2o.h  | 134 +++++++++++++-
>  include/uapi/linux/Kbuild    |   1 -
>  include/uapi/linux/i2o-dev.h | 421 -------------------------------------------
>  3 files changed, 132 insertions(+), 424 deletions(-)
>  delete mode 100644 include/uapi/linux/i2o-dev.h

Acked-by: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
