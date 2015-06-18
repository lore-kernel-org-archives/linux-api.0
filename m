From: Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH] HID: roccat: Removing all modules except Kone
Date: Thu, 18 Jun 2015 11:42:19 +0200 (CEST)
Message-ID: <alpine.LNX.2.00.1506181141150.12753@pobox.suse.cz>
References: <1429202372.2351.6.camel@neuromancer.tessier-ashpool>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1429202372.2351.6.camel-/ZsuMndpQpv+LLWKTYdlgUWBcfzl8p5a/AviwAImx+Y@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stefan Achatz <erazor_de-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-input-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, 16 Apr 2015, Stefan Achatz wrote:

> This patch removes all roccat hid modules except the one for the first Kone.
> 
> Package roccat-tools is the only known user of these modules. Starting with
> roccat-tools-2.2.0, released 7 months ago, I'm not using these modules
> anymore. All functionality has been moved to userspace using hidraw.

7 months means 2 or 3 major kernel releases, and no depreciation process 
has happened.

Could you please work on more user-friendly depreciation plan for these 
drivers?

Thanks,

-- 
Jiri Kosina
SUSE Labs
