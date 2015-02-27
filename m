From: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH RFC 1/3] Drivers: hv: kvp: convert userspace/kernel
 communication to using char device
Date: Fri, 27 Feb 2015 21:27:15 +0100
Message-ID: <20150227202715.GF2034@potion.brq.redhat.com>
References: <1425053665-635-1-git-send-email-vkuznets@redhat.com>
 <1425053665-635-2-git-send-email-vkuznets@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1425053665-635-2-git-send-email-vkuznets-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vitaly Kuznetsov <vkuznets-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "K. Y. Srinivasan" <kys-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, devel-tBiZLqfeLfOHmIFyCCdPziST3g8Odh+X@public.gmane.org, Haiyang Zhang <haiyangz-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dexuan Cui <decui-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

2015-02-27 17:14+0100, Vitaly Kuznetsov:
> Re-implement the communication using misc char device. Use ioctl to do
> kernel/userspace version negotiation (doesn't make much sense at this moment
> as we're breaking backwards compatibility but can be used in future).

The main question is whether we want to abolish backward compatibility;
kernel rules are usually against breakages and it's hard to prove that
the bundled daemon is a sole user and gets updated at the same time.
(Note: I'd gladly break anything.)

The ioctl is used too creatively for my liking: as an out-of-band
communication that is required after the main channel has been opened.
It would be simpler to inject the version into first x bytes of the
stream, making a read() after open() mandatory.

(I've only done a high level overview so far.)
