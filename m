From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: aio openat Re: [PATCH 07/13] aio: enabled thread based async fsync
Date: Sat, 19 Mar 2016 18:20:24 -0700
Message-ID: <CA+55aFx7JJdYNWRSs6Nbm_xyQjgUVoBQh=RuNDeavKS1Jr+-ow@mail.gmail.com>
References: <CA+55aFyLb8scNSYb19rK4iT_Vx5=hKxqPwRHVnETzAhEev0aHw@mail.gmail.com>
	<CA+55aFxCM-xWVR4jC=q2wSk+-WC1Xuf+nZLoud8JwKZopnR_dQ@mail.gmail.com>
	<20160115202131.GH6330@kvack.org>
	<CA+55aFzRo3yztEBBvJ4CMCvVHAo6qEDhTHTc_LGyqmxbcFyNYw@mail.gmail.com>
	<20160120195957.GV6033@dastard>
	<CA+55aFx4PzugV+wOKRqMEwo8XJ1QxP8r+s-mvn6H064FROnKdQ@mail.gmail.com>
	<20160120204449.GC12249@kvack.org>
	<20160120214546.GX6033@dastard>
	<CA+55aFzA8cdvYyswW6QddM60EQ8yocVfT4+mYJSoKW9HHf3rHQ@mail.gmail.com>
	<20160123043922.GF6033@dastard>
	<20160314171737.GK17923@kvack.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20160314171737.GK17923@kvack.org>
Sender: owner-linux-mm@kvack.org
To: Benjamin LaHaise <bcrl@kvack.org>
Cc: Dave Chinner <david@fromorbit.com>, Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-aio@kvack.org, linux-mm <linux-mm@kvack.org>
List-Id: linux-api@vger.kernel.org

On Mon, Mar 14, 2016 at 10:17 AM, Benjamin LaHaise <bcrl@kvack.org> wrote:
>
> I had some time last week to make an aio openat do what it can in
> submit context.  The results are an improvement: when openat is handled
> in submit context it completes in about half the time it takes compared
> to the round trip via the work queue, and it's not terribly much code
> either.

This looks good to me, and I do suspect that any of these aio paths
should strive to have a synchronous vs threaded model. I think that
makes the whole thing much more interesting from a performance
standpoint.

I still think the aio interface is really nasty,  but this together
with the table-based approach you posted earlier does make me a _lot_
happier about the implementation.It just looks way less hacky, and now
it ends up exposing a rather more clever implementation too.

             Linus

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
