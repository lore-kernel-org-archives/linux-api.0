From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] [man-pages] adjtimex.2: document clock_adjtime
Date: Tue, 21 Nov 2017 09:06:37 +0100
Message-ID: <CAK8P3a1TFPNE+A5Gf=cgsxiqi2VQOzfRLUgirjNtb6Tdei0Ovg@mail.gmail.com>
References: <20171120225302.3379657-1-arnd@arndb.de> <20171121030459.swng4eyke34uf3sv@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171121030459.swng4eyke34uf3sv@localhost>
Sender: linux-kernel-owner@vger.kernel.org
To: Richard Cochran <richardcochran@gmail.com>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Stephen Boyd <sboyd@codeaurora.org>
List-Id: linux-api@vger.kernel.org

On Tue, Nov 21, 2017 at 4:05 AM, Richard Cochran
<richardcochran@gmail.com> wrote:
> On Mon, Nov 20, 2017 at 11:53:02PM +0100, Arnd Bergmann wrote:
>>  .B EINVAL
>> +The
>> +.I clk_id
>> +specified is not supported on this system.
>
> We return EINVAL when the clockid is not valid.  That can mean two
> things.  Either the SYS-V style hard coded positive clockid is out of
> range, or the dynamic negative clockid does not refer to a valid
> instance of a clock object.
>
> Dynamic clocks might also return ENODEV in case a hot-plugable device
> (like USB) has disappeared after its character device was opened.

I copied that line from clock_gettime() man page. I suppose we want to
fix change this in both pages, right? Any suggestions for a good way to
express your explanation in the man page? I suppose we don't want to
go into details of the implementation there but still capture the possible
corner cases.

       Arnd
