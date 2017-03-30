From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: RFC: reject unknown open flags
Date: Thu, 30 Mar 2017 19:21:59 +0200
Message-ID: <20170330172159.GA24139@lst.de>
References: <20170330163327.23920-1-hch@lst.de> <CA+55aFw92r4h4sNW41ifs31ixdZpNmaxY23KthB9R-LXNm7p-w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CA+55aFw92r4h4sNW41ifs31ixdZpNmaxY23KthB9R-LXNm7p-w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, libc-alpha <libc-alpha-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Mar 30, 2017 at 10:08:10AM -0700, Linus Torvalds wrote:
> What kind of new flag did you even have in mind that would have such
> broken semantics that it would completely change the other flags?
> Becuase now I'm starting to think that the whole series has an even
> deeper bug: stupid new features that were badly thought out and not
> even described.

Failure atomic file updates, aka O_ATOMIC:

	https://lwn.net/Articles/573092/

Currently the way to probe for it is a new ioctl to check if atomicy
is offered.  This should work, but it's rather fragile..
