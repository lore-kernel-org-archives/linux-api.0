From: arnd-r2nGTMty4D4@public.gmane.org
Subject: [RFC 00/17] asm-generic ABI files for microblaze
Date: Mon, 27 Apr 2009 17:01:14 +0200
Message-ID: <20090427142010.587518220@arndb.de>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: john.williams-g5w7nrANp4BDPfheJLI6IQ@public.gmane.org, monstr-pSz03upnqPeHXe+LvDLADg@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, liqin.chen-+XGAvkf1AAHby3iVrkZq2A@public.gmane.org, Sam Ravnborg <sam-uyr5N9Q2VtJg9hUCZPvPmw@public.gmane.org>, Remis Lima Baima <remis.developer-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
List-Id: linux-api@vger.kernel.org

This is my attempt to do a generic system call ABI for
all new architectures, including a port for microblaze,
which has recently been merged into 2.6.30. The next
architecture that is about to get merged will be score,
so it would be good if they can move to the same ABI.

Please review the files and (in case of microblaze
and score maintainers) test them on your architecture.

The one part I'm not yet completely happy with is signal
handling, I had to massage the microblaze code quite a
bit to get the old-style siginfo out of it, which may
not yet work.

Sam also mentioned that it might be good to consistently
use the __u32 and similar types everywhere in asm-generic
exported headers, which I might be doing as a next step
(including the existing files).

Special thanks to Remis Baima, who has done some significant
work cleaning up my patches.
Sorry for spamming everyone with the broken mail headers.
I hope this resend does fly better.

	Arnd <><

--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
