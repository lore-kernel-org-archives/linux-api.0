From: Willy Tarreau <w@1wt.eu>
Subject: Re: [PATCH 4/8] pipe: fix limit checking in pipe_set_size()
Date: Sun, 21 Aug 2016 23:35:41 +0200
Message-ID: <20160821213541.GA3864@1wt.eu>
References: <67ce15aa-cf43-0c89-d079-2d966177c56d@gmail.com>
 <7f0732a9-6172-e92d-7c5b-473b769fe37e@gmail.com>
 <20160819054818.GH17944@1wt.eu>
 <60022222-ced6-85d4-77bb-bf8bf8ce668b@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <60022222-ced6-85d4-77bb-bf8bf8ce668b@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Vegard Nossum <vegard.nossum@oracle.com>, socketpair@gmail.com, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, Jens Axboe <axboe@fb.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Hi Michael,

On Mon, Aug 22, 2016 at 09:15:35AM +1200, Michael Kerrisk (man-pages) wrote:
> Hi Willy,
> 
> Might you have a chance to further review of this patch series?
> It would be great if you could, since much of it touches changes
> made by you earlier.

Well, all I did there was implementing a suggestion from Linus, but I'm
not a specialist at all there. However I've read all your series and at
least with my limited knowledge, all I've read seems to make sense at
the code matches the descriptions. I don't remember any particular trap
in this place so I'm not worried.

I remember that I noticed this inaccuracy in the accounting but I
estimated it was not important since the goal was to *limit* resource
usage with a simple patch that we could easily backport. Your approach
looks clean and possibly backportable if needed. That's all I can say
I'm afraid :-/

Cheers,
Willy
