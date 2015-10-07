From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [PATCH v2] scsi: ufs: add ioctl interface for query request
Date: Wed, 07 Oct 2015 14:37:35 +0200
Message-ID: <7161690.NZs9VETTEZ@wuerfel>
References: <1444204457-14935-1-git-send-email-ygardi@codeaurora.org> <14797522.dgtjTj5niW@wuerfel> <c154d3ff11646f056401afd4fa348d1b.squirrel@www.codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <c154d3ff11646f056401afd4fa348d1b.squirrel-mMfbam+mt9083fI46fginR2eb7JE58TQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: ygardi-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org
Cc: james.bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-msm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, santoshsy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-scsi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, subhashj-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, gbroner-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, draviv-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, Noa Rubens <noag-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Raviv Shvili <rshvili-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Vinayak Holikatti <vinholikatti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "James E.J. Bottomley" <jbottomley-wo1vFcy6AUs@public.gmane.org>, "open list:ABI/API" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wednesday 07 October 2015 12:27:54 ygardi-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org wrote:
> 
> >> +
> >> +/*
> >> + *  IOCTL opcode for ufs queries has the following opcode after
> >> + *  SCSI_IOCTL_GET_PCI
> >> + */
> >> +#define UFS_IOCTL_QUERY                     0x5388
> >
> > Use _IOWR() to define that number with the correct argument length
> 
> i'd rather leave it as is, to be compatible with the SCSI_IOCTL
> opcodes that are defined in scsi_ioctl.h

Do you mean you require this code to work on SunOS? ;-)

If not, better use the normal conventions that Linux and BSD have for
new ioctls.

Note that the 0x53xx ioctl command numbers are also used by
include/uapi/linux/cdrom.h, this one would be right in the middle
of that.

	Arnd
