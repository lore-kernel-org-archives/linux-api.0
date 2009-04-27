From: Sam Ravnborg <sam-uyr5N9Q2VtJg9hUCZPvPmw@public.gmane.org>
Subject: Re: [RFC 00/17] asm-generic ABI files for microblaze
Date: Mon, 27 Apr 2009 17:12:41 +0200
Message-ID: <20090427151241.GA10558@uranus.ravnborg.org>
References: <200904271640.44445.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <200904271640.44445.arnd-r2nGTMty4D4@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, john.williams-g5w7nrANp4BDPfheJLI6IQ@public.gmane.org, monstr-pSz03upnqPeHXe+LvDLADg@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, liqin.chen-+XGAvkf1AAHby3iVrkZq2A@public.gmane.org, Remis Lima Baima <remis.developer-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Apr 27, 2009 at 04:40:43PM +0200, Arnd Bergmann wrote:
> This is my attempt to do a generic system call ABI for
> all new architectures, including a port for microblaze,
> which has recently been merged into 2.6.30. The next
> architecture that is about to get merged will be score,
> so it would be good if they can move to the same ABI.
> 
> Please review the files and (in case of microblaze
> and score maintainers) test them on your architecture.

The submission is seriously broken.
- subject is missing
- reply-to-all is broken

Can you resend with this fixed, then it makes review easier.

	Sam
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
