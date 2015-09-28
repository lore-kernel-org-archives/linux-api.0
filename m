From: Andreas Dannenberg <dannenberg-l0cyMroinI0@public.gmane.org>
Subject: Re: [PATCH v7 14/15] power: bq24257: Add platform data based
 initialization
Date: Mon, 28 Sep 2015 17:50:55 -0500
Message-ID: <20150928225054.GA8797@beast>
References: <1443196460-26156-1-git-send-email-dannenberg@ti.com>
 <1443196460-26156-15-git-send-email-dannenberg@ti.com>
 <20150928175811.GG3660@earth>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150928175811.GG3660@earth>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sebastian Reichel <sre-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Dmitry Eremin-Solenikov <dbaryshkov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Laurentiu Palcu <laurentiu.palcu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Krzysztof Kozlowski <k.kozlowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Ramakrishna Pallala <ramakrishna.pallala-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, Sep 28, 2015 at 07:58:12PM +0200, Sebastian Reichel wrote:
> Hi,
> 
> On Fri, Sep 25, 2015 at 10:54:19AM -0500, Andreas Dannenberg wrote:
> > The patch adds a way to setup and initialize the device through the use
> > of platform data with configuration options equivalent to when using
> > device firmware (DT or ACPI) for systems where this is not available.
> 
> Which board is this btw? Looks like most arm board code is going
> away in the next few kernel releases, so I wonder if this patch
> will just increase maintainence without any proper user.

There is no particular board I'm targeting this for however platform
data support has been tested with a board file that I created for one of
the TI devices (don't worry I won't try to upstream that one :)

>From a silicon vendor POV I want to make sure to make it easy to use
these devices for the largest audience possible hence the added pdata
support as there are still archs out there that don't support DT/ACPI.

With the changes based on your suggestion to use the gpiod interface
also for pdata this patch has become almost trivial and so should be the
effort removing this support should it ever become necessary.

Regards,

--
Andreas Dannenberg
Texas Instruments Inc
