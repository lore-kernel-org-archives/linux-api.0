From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [RFC v2 23/24] m68k/mac: Fix PRAM accessors
Date: Thu, 18 Jun 2015 14:49:15 +1000 (AEST)
Message-ID: <alpine.LNX.2.00.1506181417260.30499@nippy.intranet>
References: <20150614074607.242676098@telegraphics.com.au> <20150614074613.054681242@telegraphics.com.au> <CAMuHMdWzKvWjAE3u54E4xewEDX+zJqEDEvRmO2twpeD2vmBzog@mail.gmail.com> <alpine.LNX.2.00.1506152213340.12762@nippy.intranet>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.00.1506152213340.12762@nippy.intranet>
Sender: linux-m68k-owner@vger.kernel.org
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux/m68k <linux-m68k@vger.kernel.org>, "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org


Hi Geert,

Further to my previous email,

On Tue, 16 Jun 2015, in which I wrote:

> 
> On Mon, 15 Jun 2015, Geert Uytterhoeven wrote:
> 
> > 
> > More magic values...
> 
> [...] The only useful RTC documentation I've ever come across is this: 
> http://mac.linux-m68k.org/devel/plushw.php

This document appears to be Inside Macintosh vol. III ch. 2. It describes 
the early RTC chip that lacks two-byte operations and XPRAM, and pre-dates 
all Mac hardware supported in mainline Linux. But it does offer some 
useful data, though not enough to answer all of your criticisms (as I 
said).

> [...] I think they should be applied across the entire file, and in a 
> different patch. Inconsistent use of such macros would be undesirable 
> IMHO.

So, unless you have other ideas, I will revise this patch and insert an 
earlier patch to address existing code, and codify what little reliable 
chip data we have.

-- 
