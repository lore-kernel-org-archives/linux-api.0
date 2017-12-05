From: Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 03/21] fpga: mgr: add status for fpga-manager
Date: Tue, 5 Dec 2017 12:08:24 +0800
Message-ID: <20171205040824.GD19730@hao-dev>
References: <1511764948-20972-1-git-send-email-hao.wu@intel.com>
 <1511764948-20972-4-git-send-email-hao.wu@intel.com>
 <CANk1AXSPQb3=bwaRQsysuiM5NiS6KpKRazP-WNLuus-C=UP6pg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CANk1AXSPQb3=bwaRQsysuiM5NiS6KpKRazP-WNLuus-C=UP6pg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alan Tull <atull-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Moritz Fischer <mdf-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-fpga-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Kang, Luwei" <luwei.kang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Zhang, Yi Z" <yi.z.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Dec 04, 2017 at 02:55:42PM -0600, Alan Tull wrote:
> On Mon, Nov 27, 2017 at 12:42 AM, Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> 
> Hi Hao,
> 
> mgr->status isn't used anywhere except in status_show.  So we don't
> need to add status to the fpga_manager struct.  Also don't need the
> inline function to update it.  Just read the status in status_show, if
> that ops exists.  If mops->status is NULL, return an error, as below.
> This will simplify things and make sure that status_show gets status
> that is not stale at all.

Hi Alan

You're right, this is much simpler. Will follow this to fix it in the
next version. Thanks!

Hao
