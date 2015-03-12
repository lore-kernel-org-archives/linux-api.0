From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [PATCH 41/45] include/uapi/sound/emu10k1.h: hide gpr_valid, tram_valid and code_valid in userspace
Date: Thu, 12 Mar 2015 09:45:42 +0100
Message-ID: <38157374.ndif9EAmZu@wuerfel>
References: <1424127948-22484-1-git-send-email-mikko.rapeli@iki.fi> <2168807.4Yxh5gl11Q@wuerfel> <s5hr3sun3rv.wl-tiwai@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <s5hr3sun3rv.wl-tiwai-l3A5Bk7waGM@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Takashi Iwai <tiwai-l3A5Bk7waGM@public.gmane.org>
Cc: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jaroslav Kysela <perex-/Fr2/VpizcU@public.gmane.org>, alsa-devel-K7yf7f+aM1XWsZ/bQMPhNw@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thursday 12 March 2015 07:11:48 Takashi Iwai wrote:
> At Wed, 11 Mar 2015 10:46:29 +0100,
> Arnd Bergmann wrote:
> > 
> > On Wednesday 11 March 2015 07:11:18 Takashi Iwai wrote:
> > > At Wed, 11 Mar 2015 03:22:04 +0200,
> > > 
> > > Are there any other headers like that?  If this is the only one, leave
> > > it as is.  The only program that reads this are some alsa-tools ones
> > > and they have already own DECLARE_BITMAP() definition.  Adding the
> > > extra definition here will even break the compilation out of sudden.
> > 
> > I think it's a worthy goal to have the header files be compilable
> > standalone,
> 
> In general yes, but this case is very minor issue:
> - the file in question is for a hardware device-specific data
>   definition,
> - there are only two programs read this file, both can be built
>   properly,
> - and the device and the programs are very old, modifying such need
>   extra care.

Right, we should only do it if the goal is to have all uapi headers
includable standalone. For a particular header file there is very
little benefit as you say, but it would be useful if we can automatically
test for regressions with new or modified headers.

	Arnd
