From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [PATCH] [media] uapi/media.h: Use u32 for the number of graph objects
Date: Thu, 17 Dec 2015 14:55:11 +0100
Message-ID: <2035986.3qXU4Qokl3@wuerfel>
References: <40e950dbb6a3b7f73da52e147fa51441b762131a.1450350558.git.mchehab@osg.samsung.com> <5672A69F.7020505@xs4all.nl> <20151217104556.70d4f0f8@recife.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151217104556.70d4f0f8-+RedX5hVuTR+urZeOPWqwQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Cc: Hans Verkuil <hverkuil-qWit8jRvyhVmR6Xm/wNWPw@public.gmane.org>, Linux Media Mailing List <linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mauro Carvalho Chehab <mchehab-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Javier Martinez Canillas <javier-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thursday 17 December 2015 10:45:56 Mauro Carvalho Chehab wrote:
> If I understood well, he's proposing to do is:
> 
> struct media_v2_topology {
>         __u64 topology_version;
> 
>         __u32 num_entities;
>         __u32 num_interfaces;
>         __u32 num_pads;
>         __u32 num_links;
> 
>         __u64 ptr_entities;
>         __u64 ptr_interfaces;
>         __u64 ptr_pads;
>         __u64 ptr_links;
> };
> 
> The problem is that, if we latter need to extend it to add a new type
> the extension will not be too nice. For example, I did some experimental
> patches adding graph groups:
> 

Can you clarify how the 'topology_version' is used here? Is that
the version of the structure layout that decides how we interpret the
rest, or is it a number that is runtime dependent?

If this is an API version, I think the answer can simply be to drop
the topology_version field entirely, and use a new ioctl command code
whenever the API changes. This is the preferred method anyway.

	Arnd
