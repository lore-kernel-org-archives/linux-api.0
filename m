From: Dave Martin <Dave.Martin-5wv7dgnIgG8@public.gmane.org>
Subject: Signal frame / ucontext growth and ABI breaks
Date: Tue, 26 Sep 2017 17:03:38 +0100
Message-ID: <20170926160338.GC17434@e103592.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi all,

I recently presented some slides [1] at Plumbers about the
challenge of growing the signal frame, and why we need to grow it
on arm64 and (seemingly) other architectures.

I didn't get any controversial feedback there, but this topic is
relevant to linux-api too.

Does anyone have a view on the AT_MINSIGSTKSZ and ucontext
proposals outlined in the slides?


SVE itself requires a fair number of arm64-specific ABI additions --
there's a documentation patch [3] outlining everything.  (The
patches are not merged yet, but see [2] for the most recent
version of the series.)

If anyone has any comments on the design, I'd like to hear them.

Thanks
---Dave


[1] Growing CPU register state without breaking ABI (much)
https://linuxplumbersconf.org/2017/ocw//system/presentations/4671/original/plumbers-dm-2017.pdf

[2] [PATCH v2 00/28] ARM Scalable Vector Extension (SVE)
http://lists.infradead.org/pipermail/linux-arm-kernel/2017-August/529575.html

[3] [PATCH v2 26/28] arm64/sve: Add documentation
http://lists.infradead.org/pipermail/linux-arm-kernel/2017-August/529595.html
