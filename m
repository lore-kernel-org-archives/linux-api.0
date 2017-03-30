From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: RFC: reject unknown open flags
Date: Thu, 30 Mar 2017 11:19:53 -0700
Message-ID: <CA+55aFyg5sXb2vjW9Wt45asoveV7E1scqmph6Op6ZFYdGNwsEg@mail.gmail.com>
References: <20170330163327.23920-1-hch@lst.de> <CA+55aFw92r4h4sNW41ifs31ixdZpNmaxY23KthB9R-LXNm7p-w@mail.gmail.com>
 <20170330172159.GA24139@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170330172159.GA24139-jcswGhMUV9g@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, libc-alpha <libc-alpha-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Mar 30, 2017 at 10:21 AM, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org> wrote:
>
> Failure atomic file updates, aka O_ATOMIC:
>
>         https://lwn.net/Articles/573092/
>
> Currently the way to probe for it is a new ioctl to check if atomicy
> is offered.  This should work, but it's rather fragile..

So quite frankly, I'd much rather see that people who really want to
check would instead just

     fd = open(... O_ATOMIC);
     if (fd < 0)
          .. regular error handling ..

     /* Did we actually get O_ATOMIC? */
     if (!(O_ATOMIC & fnctl(fd, F_GETFL, NULL)))
          .. warn about lack of O_ATOMIC ..

because I suspect that you will find users that might *want* atomic
behavior, but in the absence of atomicity guarantees will want to
still be able to do IO.

The above kind of model seems much more straightforward, and has no
backwards/forwards compatibility issues I can see.

I'm assuming you'd also possible want to be able to use F_SETFL to set
O_ATOMIC after the fact (independently of the open - I could see tools
like "dd" growing an atomic flag and setting it on stdout), so the
F_GETFL interface seems natural for that reason too.

              Linus
