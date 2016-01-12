From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 09/13] aio: add support for async openat()
Date: Tue, 12 Jan 2016 10:53:19 +0100
Message-ID: <20160112095319.GA20597@gmail.com>
References: <cover.1452549431.git.bcrl@kvack.org>
 <150a0b4905f1d7274b4c2c7f5e3f4d8df5dda1d7.1452549431.git.bcrl@kvack.org>
 <CA+55aFw8j_3Vkb=HVoMwWTPD=5ve8RpNZeL31CcKQZ+HRSbfTA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-aio@kvack.org>
Content-Disposition: inline
In-Reply-To: <CA+55aFw8j_3Vkb=HVoMwWTPD=5ve8RpNZeL31CcKQZ+HRSbfTA@mail.gmail.com>
Sender: owner-linux-aio@kvack.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Benjamin LaHaise <bcrl@kvack.org>, linux-aio@kvack.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>
List-Id: linux-api@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> What do you think? Do you think it might be possible to aim for a generic "do 
> system call asynchronously" model instead?
> 
> I'm adding Ingo the to cc, because I think Ingo had a "run this list of system 
> calls" patch at one point - in order to avoid system call overhead. I don't 
> think that was very interesting (because system call overhead is seldom all that 
> noticeable for any interesting system calls), but with the "let's do the list 
> asynchronously" addition it might be much more intriguing. Ingo, do I remember 
> correctly that it was you? I might be confused about who wrote that patch, and I 
> can't find it now.

Yeah, it was the whole 'syslets' and 'threadlets' stuff - I had both implemented 
and prototyped into a 'list directory entries asynchronously' testcase.

Threadlets was pretty close to what you are suggesting now. Here's a very good (as 
usual!) writeup from LWN:

  https://lwn.net/Articles/223899/

Thanks,

	Ingo

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
