From: Boris BREZILLON <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH 0/5] video: describe data bus formats
Date: Tue, 12 Aug 2014 13:02:37 +0200
Message-ID: <20140812130237.36ec613e@bbrezillon>
References: <1406031827-12432-1-git-send-email-boris.brezillon@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1406031827-12432-1-git-send-email-boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Boris BREZILLON <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
Cc: Thierry Reding <thierry.reding-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Laurent Pinchart <laurent.pinchart-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org>, David Airlie <airlied-cv59FeDIM0c@public.gmane.org>, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mauro Carvalho Chehab <m.chehab-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi,

On Tue, 22 Jul 2014 14:23:42 +0200
Boris BREZILLON <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org> wrote:

> Hello,
> 
> This patch series is a proposal to describe the different data formats used
> by HW components to connect with each other.
> 
> This is just a copy of the existing V4L2_MBUS_FMT defintions with a neutral
> name so that it can be used by V4L2 and DRM/KMS subsystem.
> 
> This series also makes use of this video_bus_format enum in the DRM/KMS
> subsystem to define the data fomats supported on the connector <-> device
> link.
> 
> The video bus formats are not documented yet (and I don't know where this doc
> should be stored), but I'm pretty sure this version won't be the last one ;-).

Laurent, Thierry (and other DRM/KMS folks), any comments on this
series ?

I'd really like to get the HLCDC driver mainlined for 3.18 and it
depends on this series now...

Best Regards,

Boris
-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
