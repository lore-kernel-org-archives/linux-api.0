From: Vitaly Kuznetsov <vkuznets-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 03/21] Drivers: hv: kvp: move poll_channel() to hyperv_vmbus.h
Date: Mon, 13 Apr 2015 10:36:30 +0200
Message-ID: <87r3rotofl.fsf@vitty.brq.redhat.com>
References: <1428568730-6030-1-git-send-email-vkuznets@redhat.com>
	<1428568730-6030-4-git-send-email-vkuznets@redhat.com>
	<20150410182742.GQ10964@mwanda>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150410182742.GQ10964@mwanda> (Dan Carpenter's message of "Fri,
	10 Apr 2015 21:27:42 +0300")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: "K. Y. Srinivasan" <kys-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, devel-tBiZLqfeLfOHmIFyCCdPziST3g8Odh+X@public.gmane.org, Radim Krcmar <rkrcmar-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Haiyang Zhang <haiyangz-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> writes:

> On Thu, Apr 09, 2015 at 10:38:32AM +0200, Vitaly Kuznetsov wrote:
>> ..., make it inline and rename it to hv_poll_channel() so it can be reused
>> in other hv_util modules.
>> 
>
> The "...," is fine in the git log but I noticed recently that if you're
> reading patches in a web archive then often the subject and the body are
> several lines apart.
>
> http://marc.info/?l=linux-api&m=142856917031730&w=2
>
> It's awkward to follow.
>

Oh, yea, I see... I'll try eliminating this practice for myself in
future, but it seems many other contributors never saw their commits
with '...' in a web archive as well..

> regards,
> dan carpenter

-- 
  Vitaly
