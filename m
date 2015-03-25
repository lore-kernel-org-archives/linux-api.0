From: Kishon Vijay Abraham I <kishon-l0cyMroinI0@public.gmane.org>
Subject: Re: [PATCH 0/5] Enhancements to twl4030 phy to support better charging
 - V2
Date: Thu, 26 Mar 2015 02:46:32 +0530
Message-ID: <551325B0.1090308@ti.com>
References: <20150322223307.21765.62974.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150322223307.21765.62974.stgit-wvvUuzkyo1EYVZTmpyfIwg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: NeilBrown <neil-+NVA1uvv1dVBDLzU/O5InQ@public.gmane.org>
Cc: Tony Lindgren <tony-4v6yS6AI5VpBDgjK7y7TUQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, GTA04 owners <gta04-owner-xXXSsgcRVICgSpxsJD1C4w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi,

On Monday 23 March 2015 04:05 AM, NeilBrown wrote:
> Hi Kishon,
>  I wonder if you could queue the following for the next merge window.
>  They allow the twl4030 phy to provide more information to the
>  twl4030 battery charger.
>  There are only minimal changes since the first version, particularly
>  documentation has been improved.

There are quite a few things in this series which use the USB PHY library
interface which is kindof deprecated. We should try and use the Generic PHY
library for all of them. It would also be better to add features to the
PHY framework if the we can't achieve something with the existing PHY
framework.

-Kishon
