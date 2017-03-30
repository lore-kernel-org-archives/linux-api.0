From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: RFC: reject unknown open flags
Date: Thu, 30 Mar 2017 11:45:32 -0700
Message-ID: <CA+55aFyhH0924xwS4q8sJ=F-HZyoSQZJaQ6cWgTCAj4PjrZt8g@mail.gmail.com>
References: <20170330163327.23920-1-hch@lst.de> <CA+55aFw92r4h4sNW41ifs31ixdZpNmaxY23KthB9R-LXNm7p-w@mail.gmail.com>
 <20170330172159.GA24139@lst.de> <CA+55aFyg5sXb2vjW9Wt45asoveV7E1scqmph6Op6ZFYdGNwsEg@mail.gmail.com>
 <20170330182620.GA25251@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170330182620.GA25251-jcswGhMUV9g@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, libc-alpha <libc-alpha-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Mar 30, 2017 at 11:26 AM, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org> wrote:
>
> That would be nice, but still won't work as we blindly copy f_flags
> into F_GETFL, not even masking our internal FMODE_ bits.

Ok, *that* is just silly of us, and we could try to just fix, and even backport.

There's no possible valid use I could see where that should break
(famous last words - user code does some damn odd things at times).

Of course, that won't fix old kernels that are out there, but then
neither would your original patch...

Side note: I think you *can* detect the O_ATOMIC support by using
F_SETFL, because F_SETFL only allows you to change flags that we
recognize. So somebody who really wants to *guarantee* that O_ATOMIC
is there and honored even with old kernels could presumable do
something like

   fd = open(..); // *no* O_ATOMIC
   fcnt(fd, F_SETFL, O_ATOMIC);
   if (fcnt(fd, F_GETFL, NULL) & O_ATOMIC)
        // Yay! We actually got it
   else
        // I guess we need to fall back on old behavior

although I agree that that is ridiculously inconvenient and not a
great thing, and it's worth trying to aim for some better model.

                    Linus
