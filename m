From: Javier Martinez Canillas <javier-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: Re: [PATCH RFC] [media] Postpone the addition of MEDIA_IOC_G_TOPOLOGY
Date: Mon, 28 Dec 2015 11:15:46 -0300
Message-ID: <56814412.4000903@osg.samsung.com>
References: <d029047c76d6d3e5e6a531080ede83f6e063f7db.1451311244.git.mchehab@osg.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <d029047c76d6d3e5e6a531080ede83f6e063f7db.1451311244.git.mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Linux Media Mailing List <linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Mauro Carvalho Chehab <mchehab-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Hans Verkuil <hverkuil-qWit8jRvyhVmR6Xm/wNWPw@public.gmane.org>, Laurent Pinchart <laurent.pinchart-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org>, Sakari Ailus <sakari.ailus-X3B1VOXEql0@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hello Mauro,

On 12/28/2015 11:03 AM, Mauro Carvalho Chehab wrote:
> There are a few discussions left with regards to this ioctl:
> 
> 1) the name of the new structs will contain _v2_ on it?
> 2) what's the best alternative to avoid compat32 issues?
> 
> Due to that, let's postpone the addition of this new ioctl to
> the next Kernel version, to give people more time to discuss it.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
> ---
>

I agree that leaving the IOCTL out for now is the most sensible thing to
do since as you said, we didn't have time due holidays season to finish
the discussion about the struct media_v2_topology layout.

Best regards,
-- 
Javier Martinez Canillas
Open Source Group
Samsung Research America
