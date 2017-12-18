From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] [man-pages] adjtimex.2: document clock_adjtime
Date: Mon, 18 Dec 2017 20:19:42 +0100
Message-ID: <436eb61b-0fe2-41c8-0992-e21614fd3657@gmail.com>
References: <20171120225302.3379657-1-arnd@arndb.de>
 <20171121030459.swng4eyke34uf3sv@localhost>
 <CAK8P3a1TFPNE+A5Gf=cgsxiqi2VQOzfRLUgirjNtb6Tdei0Ovg@mail.gmail.com>
 <20171121160601.2xti5ho5pul2v7tm@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171121160601.2xti5ho5pul2v7tm@localhost>
Content-Language: en-US
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Richard Cochran <richardcochran-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Stephen Boyd <sboyd-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Richard,

On 11/21/2017 05:06 PM, Richard Cochran wrote:
> On Tue, Nov 21, 2017 at 09:06:37AM +0100, Arnd Bergmann wrote:
>>
>> I copied that line from clock_gettime() man page. I suppose we want to
>> fix change this in both pages, right? Any suggestions for a good way to
>> express your explanation in the man page? I suppose we don't want to
>> go into details of the implementation there but still capture the possible
>> corner cases.
> 
> Dynamic clockids are a Linux specific extension.  This should be
> explained with a paragraph or two on the gettime man page, along with
> an example using the macros.
> 
> 	#define CLOCKFD 3
> 	#define FD_TO_CLOCKID(fd)	((~(clockid_t) (fd) << 3) | CLOCKFD)
> 	#define CLOCKID_TO_FD(clk)	((unsigned int) ~((clk) >> 3))
> 
> Then, the adjtimex page can say, see gettime.
> 
> Let me try to come up with a text over the (USA) holiday weekend.

Might you have a chance to look at this still?

Cheers,

Michael



-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
