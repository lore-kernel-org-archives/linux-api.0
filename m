From: Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH] [man-pages] adjtimex.2: document clock_adjtime
Date: Tue, 21 Nov 2017 08:06:01 -0800
Message-ID: <20171121160601.2xti5ho5pul2v7tm@localhost>
References: <20171120225302.3379657-1-arnd@arndb.de>
 <20171121030459.swng4eyke34uf3sv@localhost>
 <CAK8P3a1TFPNE+A5Gf=cgsxiqi2VQOzfRLUgirjNtb6Tdei0Ovg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAK8P3a1TFPNE+A5Gf=cgsxiqi2VQOzfRLUgirjNtb6Tdei0Ovg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Stephen Boyd <sboyd@codeaurora.org>
List-Id: linux-api@vger.kernel.org

On Tue, Nov 21, 2017 at 09:06:37AM +0100, Arnd Bergmann wrote:
> 
> I copied that line from clock_gettime() man page. I suppose we want to
> fix change this in both pages, right? Any suggestions for a good way to
> express your explanation in the man page? I suppose we don't want to
> go into details of the implementation there but still capture the possible
> corner cases.

Dynamic clockids are a Linux specific extension.  This should be
explained with a paragraph or two on the gettime man page, along with
an example using the macros.

	#define CLOCKFD 3
	#define FD_TO_CLOCKID(fd)	((~(clockid_t) (fd) << 3) | CLOCKFD)
	#define CLOCKID_TO_FD(clk)	((unsigned int) ~((clk) >> 3))

Then, the adjtimex page can say, see gettime.

Let me try to come up with a text over the (USA) holiday weekend.

Thanks,
Richard
