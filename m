From: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH RFC 0/3] Drivers: hv: utils: re-implement the
 kernel/userspace communication layer
Date: Fri, 27 Feb 2015 22:07:44 +0100
Message-ID: <20150227210744.GA11904@potion.brq.redhat.com>
References: <1425053665-635-1-git-send-email-vkuznets@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1425053665-635-1-git-send-email-vkuznets-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vitaly Kuznetsov <vkuznets-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "K. Y. Srinivasan" <kys-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, devel-tBiZLqfeLfOHmIFyCCdPziST3g8Odh+X@public.gmane.org, Haiyang Zhang <haiyangz-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dexuan Cui <decui-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

2015-02-27 17:14+0100, Vitaly Kuznetsov:
> This series converts kvp/vss daemons to use misc char devices instead of
> netlink for userspace/kernel communication and then updates fcopy to be
> consistent with kvp/vss.
> 
> Userspace/kernel communication via netlink has a number of issues:
> - It is hard for userspace to figure out if the kernel part was loaded or not
>   and this fact can change as there is a way to enable/disable the service from
>   host side.

(Hm, this should be just a message to the userspace daemon, but netlink
 probably makes it complicated anyway.)

>              Racy daemon startup is also a problem.

(Is it significantly worse than what we need to protect devices?)

> - When the userspace daemon restarts/dies kernel part doesn't receive a
>   notification.

(True, we could use a other-side-closed callback.)

> - Netlink communication is not stable under heavy load.

(The message order changes?)

> RFC: I'm a bit puzzled on how to split commits 1 and 2 avoiding breakages.

Split the userspace part -- it won't break bisects.

And then, you could refactor drivers first ... the way we communicate
with userspace should have little impact on what the rest does (or how).
At first sight, there are three units, apart from glue,
 1) communication with host
 2) communication with userspace
 3) repacking of data between first two

With an API for userspace communication, the amount of code to replace
netlink could be lower and resulting patches definitely easier to
review.  (And with extra work, both ABIs could even live side-by-side ;)
