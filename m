From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH V4][for-next]mm: add a new vector based madvise syscall
Date: Thu, 18 Feb 2016 13:38:16 +0100
Message-ID: <CAKgNAkhBp8FmqRKe4a5fzmqOgSE7sTEJd95WPg0L5W-uCuAv6Q@mail.gmail.com>
References: <d01698140a51cf9b2ce233c7574c2ece9f6fa241.1449791762.git.shli@fb.com>
 <20160216160802.50ceaf10aa16588e18b3d2c5@linux-foundation.org> <20160217174654.GA3505386@devbig084.prn1.facebook.com>
Reply-To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160217174654.GA3505386-tb7CFzD8y5b7E6g3fPdp/g2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shaohua Li <shli-b10kYP2dOMg@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kernel-team-b10kYP2dOMg@public.gmane.org, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Jason Evans <je-b10kYP2dOMg@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hello Shaohua Li,

On 17 February 2016 at 18:47, Shaohua Li <shli-b10kYP2dOMg@public.gmane.org> wrote:
> On Tue, Feb 16, 2016 at 04:08:02PM -0800, Andrew Morton wrote:
>> On Thu, 10 Dec 2015 16:03:37 -0800 Shaohua Li <shli-b10kYP2dOMg@public.gmane.org> wrote:

[...]

>> It would be good for us to have a look at the manpage before going too
>> far with the patch - this helps reviewers to think about the proposed
>> interface and behaviour.
>>
>> I'll queue this up for a bit of testing, although it won't get tested
>> much.  The syscall fuzzers will presumably hit on it.

Please don't forget the other piece. A patch, or a suitable piece of
text for the madvise.2 man page please!

Cheers,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
