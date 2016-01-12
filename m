From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 07/13] aio: enabled thread based async fsync
Date: Mon, 11 Jan 2016 18:38:15 -0800
Message-ID: <CA+55aFzxSrLhOyV3VtO=Cv_J+npD8ubEP74CCF+rdt=CRipzxA@mail.gmail.com>
References: <cover.1452549431.git.bcrl@kvack.org>
	<80934665e0dd2360e2583522c7c7569e5a92be0e.1452549431.git.bcrl@kvack.org>
	<20160112011128.GC6033@dastard>
	<CA+55aFxtvMqHgHmHCcszV_QKQ2BY0wzenmrvc6BYN+tLFxesMA@mail.gmail.com>
	<20160112022548.GD6033@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20160112022548.GD6033@dastard>
Sender: owner-linux-mm@kvack.org
To: Dave Chinner <david@fromorbit.com>
Cc: Benjamin LaHaise <bcrl@kvack.org>, linux-aio@kvack.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>
List-Id: linux-api@vger.kernel.org

On Mon, Jan 11, 2016 at 6:25 PM, Dave Chinner <david@fromorbit.com> wrote:
>
> That's a different interface.

So is openat. So is readahead.

My point is that this idiotic "let's expose special cases" must end.
It's broken. It inevitably only exposes a subset of what different
people would want.

Making "aio_read()" and friends a special interface had historical
reasons for it. But expanding willy-nilly on that model does not.

               Linus

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
