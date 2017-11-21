From: Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH] [man-pages] adjtimex.2: document clock_adjtime
Date: Mon, 20 Nov 2017 19:05:00 -0800
Message-ID: <20171121030459.swng4eyke34uf3sv@localhost>
References: <20171120225302.3379657-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171120225302.3379657-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Stephen Boyd <sboyd@codeaurora.org>
List-Id: linux-api@vger.kernel.org

On Mon, Nov 20, 2017 at 11:53:02PM +0100, Arnd Bergmann wrote:
>  .B EINVAL
> +The
> +.I clk_id
> +specified is not supported on this system.

We return EINVAL when the clockid is not valid.  That can mean two
things.  Either the SYS-V style hard coded positive clockid is out of
range, or the dynamic negative clockid does not refer to a valid
instance of a clock object.

Dynamic clocks might also return ENODEV in case a hot-plugable device
(like USB) has disappeared after its character device was opened.

Thanks,
Richard
