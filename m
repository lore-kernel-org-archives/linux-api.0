From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: RFC: reject unknown open flags
Date: Thu, 30 Mar 2017 20:26:20 +0200
Message-ID: <20170330182620.GA25251@lst.de>
References: <20170330163327.23920-1-hch@lst.de> <CA+55aFw92r4h4sNW41ifs31ixdZpNmaxY23KthB9R-LXNm7p-w@mail.gmail.com> <20170330172159.GA24139@lst.de> <CA+55aFyg5sXb2vjW9Wt45asoveV7E1scqmph6Op6ZFYdGNwsEg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CA+55aFyg5sXb2vjW9Wt45asoveV7E1scqmph6Op6ZFYdGNwsEg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, libc-alpha <libc-alpha-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Mar 30, 2017 at 11:19:53AM -0700, Linus Torvalds wrote:
> So quite frankly, I'd much rather see that people who really want to
> check would instead just
> 
>      fd = open(... O_ATOMIC);
>      if (fd < 0)
>           .. regular error handling ..
> 
>      /* Did we actually get O_ATOMIC? */
>      if (!(O_ATOMIC & fnctl(fd, F_GETFL, NULL)))
>           .. warn about lack of O_ATOMIC ..
> 
> because I suspect that you will find users that might *want* atomic
> behavior, but in the absence of atomicity guarantees will want to
> still be able to do IO.

That would be nice, but still won't work as we blindly copy f_flags
into F_GETFL, not even masking our internal FMODE_ bits.
