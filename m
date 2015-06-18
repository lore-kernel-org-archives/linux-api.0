From: Andreas Schwab <schwab-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>
Subject: Re: [RFC v2 23/24] m68k/mac: Fix PRAM accessors
Date: Thu, 18 Jun 2015 18:52:44 +0200
Message-ID: <87a8vxarhf.fsf@igel.home>
References: <20150614074607.242676098@telegraphics.com.au>
	<20150614074613.054681242@telegraphics.com.au>
	<CAMuHMdWzKvWjAE3u54E4xewEDX+zJqEDEvRmO2twpeD2vmBzog@mail.gmail.com>
	<alpine.LNX.2.00.1506152213340.12762@nippy.intranet>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.LNX.2.00.1506152213340.12762-i19888lE8tflDoPlx7XIcw@public.gmane.org> (Finn
	Thain's message of "Tue, 16 Jun 2015 13:10:29 +1000 (AEST)")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Finn Thain <fthain-PnMVE5gNl/W9dxLkCovUHLpzq4S04n8Q@public.gmane.org>
Cc: Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>, "linux-kernel@vger.kernel.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux/m68k <linux-m68k-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org>, "linux-api@vger.kernel.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Finn Thain <fthain-PnMVE5gNl/W9dxLkCovUHLpzq4S04n8Q@public.gmane.org> writes:

> When I have reliable documentation I always define macros. So I agree that 
> "command" bytes like 0x34 and 0x3800 should have names but what are the 
> correct names? Are we constructing an opcode containing RTC register file 
> addresses or are we issuing read/write accesses to chip registers?

Any name will do as long as the magic constant is not duplicated.  It is
more important to document the relation between two uses than to have a
correct name (which can trivially be updated later).

Andreas.

-- 
Andreas Schwab, schwab-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
