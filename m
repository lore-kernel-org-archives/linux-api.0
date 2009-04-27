From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [RFC 00/17] asm-generic ABI files for microblaze
Date: Mon, 27 Apr 2009 17:15:32 +0200
Message-ID: <200904271715.33676.arnd@arndb.de>
References: <200904271640.44445.arnd@arndb.de> <20090427151241.GA10558@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20090427151241.GA10558-QabhHTsIXMSnlFQ6Q1D1Y0B+6BGkLq7r@public.gmane.org>
Content-Disposition: inline
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sam Ravnborg <sam-uyr5N9Q2VtJg9hUCZPvPmw@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, john.williams-g5w7nrANp4BDPfheJLI6IQ@public.gmane.org, monstr-pSz03upnqPeHXe+LvDLADg@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, liqin.chen-+XGAvkf1AAHby3iVrkZq2A@public.gmane.org, Remis Lima Baima <remis.developer-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Monday 27 April 2009, Sam Ravnborg wrote:
> The submission is seriously broken.
> - subject is missing
> - reply-to-all is broken
> 
> Can you resend with this fixed, then it makes review easier.
> 

Sure, I have already done this and identified the problem: I had
an extra '>' character in the description file I entered in quilt
mail. For some reason, kmail still showed the patches correctly,
by they got corrupted on the way out anyway. I'll look into
using git-send-email in the future.

	Arnd <><
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
