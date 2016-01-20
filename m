From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 07/13] aio: enabled thread based async fsync
Date: Wed, 20 Jan 2016 12:29:32 -0800
Message-ID: <CA+55aFx4PzugV+wOKRqMEwo8XJ1QxP8r+s-mvn6H064FROnKdQ@mail.gmail.com>
References: <80934665e0dd2360e2583522c7c7569e5a92be0e.1452549431.git.bcrl@kvack.org>
	<20160112011128.GC6033@dastard>
	<CA+55aFxtvMqHgHmHCcszV_QKQ2BY0wzenmrvc6BYN+tLFxesMA@mail.gmail.com>
	<20160112022548.GD6033@dastard>
	<CA+55aFzxSrLhOyV3VtO=Cv_J+npD8ubEP74CCF+rdt=CRipzxA@mail.gmail.com>
	<20160112033708.GE6033@dastard>
	<CA+55aFyLb8scNSYb19rK4iT_Vx5=hKxqPwRHVnETzAhEev0aHw@mail.gmail.com>
	<CA+55aFxCM-xWVR4jC=q2wSk+-WC1Xuf+nZLoud8JwKZopnR_dQ@mail.gmail.com>
	<20160115202131.GH6330@kvack.org>
	<CA+55aFzRo3yztEBBvJ4CMCvVHAo6qEDhTHTc_LGyqmxbcFyNYw@mail.gmail.com>
	<20160120195957.GV6033@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20160120195957.GV6033@dastard>
Sender: owner-linux-mm@kvack.org
To: Dave Chinner <david@fromorbit.com>
Cc: Benjamin LaHaise <bcrl@kvack.org>, linux-aio@kvack.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>
List-Id: linux-api@vger.kernel.org

On Wed, Jan 20, 2016 at 11:59 AM, Dave Chinner <david@fromorbit.com> wrote:
>>
>> Are there other users outside of Solace? It would be good to get comments..
>
> I know of quite a few storage/db products that use AIO. The most
> recent high profile project that have been reporting issues with AIO
> on XFS is http://www.scylladb.com/. That project is architected
> around non-blocking AIO for scalability reasons...

I was more wondering about the new interfaces, making sure that the
feature set actually matches what people want to do..

That said, I also agree that it would be interesting to hear what the
performance impact is for existing performance-sensitive users. Could
we make that "aio_may_use_threads()" case be unconditional, making
things simpler?

          Linus

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
