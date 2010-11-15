From: Paul Mundt <lethal-M7jkjyW5wf5g9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH RFC 0/8] Dynamic clock devices
Date: Mon, 15 Nov 2010 19:01:50 +0900
Message-ID: <20101115100150.GA25973@linux-sh.org>
References: <cover.1288897198.git.richard.cochran@omicron.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <cover.1288897198.git.richard.cochran-3mrvs1K0uXizZXS1Dc/lvw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Richard Cochran <richardcochran-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, John Stultz <johnstul-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Nov 04, 2010 at 08:26:34PM +0100, Richard Cochran wrote:
> Okay, here is a work in progress, not well tested, but I would like to
> get some feedback whether the direction is good or not.
> 
> The first patch introduces clock devices which can appear and
> disappear like usb devices (and, I suppose, hot plug PCI but I am not
> too sure that what is offered here would really work in that case).
> The subsequent patches convert the clock_ and timer_ system calls, one
> by one.
> 
Sorry to jump in late, but this only just caught my attention.

While I have no strong feelings on this series one way or the other, the
naming is a bit unfortunate. The clock device / clkdev naming is already
in use as an extension to the clock framework and is used by a wide
variety of embedded platforms already, with a pending patch to move it in
to the generic namespace (grepping for clkdev will give you an idea). The
idea behind that interface is similar in that it deals with the dynamic
creation and teardown of clocks, but is decoupled from timekeeping.

It's also reasonable to assume that devices with dynamic clocks tracked
through clkdev will wish to also use this interface in the timekeeping
case, so it would be good to settle on something less ambiguous in
advance.
