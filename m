From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [PATCH v3] scsi: ufs: add ioctl interface for query request
Date: Sun, 11 Oct 2015 21:14:22 +0200
Message-ID: <4997819.aH6H7EmMIs@wuerfel>
References: <1444302569-30740-1-git-send-email-ygardi@codeaurora.org> <5970981.84uI3QIcdF@wuerfel> <96a76c637a4772997c149276632ed80d.squirrel@www.codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <96a76c637a4772997c149276632ed80d.squirrel-mMfbam+mt9083fI46fginR2eb7JE58TQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: ygardi-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org
Cc: james.bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-msm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, santoshsy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-scsi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, subhashj-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, gbroner-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, draviv-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, Noa Rubens <noag-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Raviv Shvili <rshvili-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Vinayak Holikatti <vinholikatti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "James E.J. Bottomley" <jbottomley-wo1vFcy6AUs@public.gmane.org>, "open list:ABI/API" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Sunday 11 October 2015 11:02:34 ygardi-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org wrote:
> >
> > no need for the #ifdef here.
> 
> in include\scsi\scsi_host.h
> the hook - compat_ioctl is defined inside #ifdef CONFIG_COMPAT
> 
> #ifdef CONFIG_COMPAT
>         int (* compat_ioctl)(struct scsi_device *dev, int cmd, void __user *arg);
> #endif
> 
> 
> 

Ah, sorry about that. I saw your v4 before I saw this reply here, and
you are right. This is different from the normal file_operations
compat_ioctl method that doesn't need the #ifdef.

	Arnd
