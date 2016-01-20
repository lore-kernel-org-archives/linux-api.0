From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 07/13] aio: enabled thread based async fsync
Date: Tue, 19 Jan 2016 19:59:35 -0800
Message-ID: <CA+55aFzRo3yztEBBvJ4CMCvVHAo6qEDhTHTc_LGyqmxbcFyNYw@mail.gmail.com>
References: <cover.1452549431.git.bcrl@kvack.org>
	<80934665e0dd2360e2583522c7c7569e5a92be0e.1452549431.git.bcrl@kvack.org>
	<20160112011128.GC6033@dastard>
	<CA+55aFxtvMqHgHmHCcszV_QKQ2BY0wzenmrvc6BYN+tLFxesMA@mail.gmail.com>
	<20160112022548.GD6033@dastard>
	<CA+55aFzxSrLhOyV3VtO=Cv_J+npD8ubEP74CCF+rdt=CRipzxA@mail.gmail.com>
	<20160112033708.GE6033@dastard>
	<CA+55aFyLb8scNSYb19rK4iT_Vx5=hKxqPwRHVnETzAhEev0aHw@mail.gmail.com>
	<CA+55aFxCM-xWVR4jC=q2wSk+-WC1Xuf+nZLoud8JwKZopnR_dQ@mail.gmail.com>
	<20160115202131.GH6330@kvack.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <20160115202131.GH6330@kvack.org>
Sender: owner-linux-aio@kvack.org
To: Benjamin LaHaise <bcrl@kvack.org>
Cc: Dave Chinner <david@fromorbit.com>, linux-aio@kvack.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>
List-Id: linux-api@vger.kernel.org

On Fri, Jan 15, 2016 at 12:21 PM, Benjamin LaHaise <bcrl@kvack.org> wrote:
>>
>> I'll have to think about this some more.
>
> Any further thoughts on this after a few days worth of pondering?

Sorry about the delay, with the merge window and me being sick for a
couple of days I didn't get around to this.

After thinking it over some more, I guess I'm ok with your approach.
The table-driven patch makes me a bit happier, and I guess not very
many people end up ever wanting to do async system calls anyway.

Are there other users outside of Solace? It would be good to get comments..

            Linus

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
