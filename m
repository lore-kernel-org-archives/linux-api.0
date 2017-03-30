From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH 2/2] fs: reject unknown open flags
Date: Thu, 30 Mar 2017 10:03:24 -0700
Message-ID: <CA+55aFzB0kK173qJMkMqjtdqWmxq-LnhT0C3FJvfKs2YgmkcqQ@mail.gmail.com>
References: <20170330163327.23920-1-hch@lst.de> <20170330163327.23920-3-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170330163327.23920-3-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, libc-alpha <libc-alpha-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Mar 30, 2017 at 9:33 AM, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org> wrote:
> This way userspace can probe for actually supported flags.

No. Not this way.

First off, since we've never checked the flags, it really is likely
that somebody just by mistake passes in garbage.

So it might cause a regression, which means we might need to revert
it, which in turn means that we sure as hell do *not* want to
encourage _other_ people to then use this to "probe" the accepted
flags.

Secondly, since we know old kernels don't test the flags, it is
*doubly* stupid to then talk about "probing accepted flags".

So the whole concept of probing is pure and utter f*cking garbage.

So get that idiotic idea out of your head.

What might be acceptable is to say "we should have not accepted random
flags to begin with", and add this error case, but realize that
probing for those flags is completely idiotic and moronic.

Once you do that, you can then say "to make it easier to see if
somebody might have passed in garbage that just happened to work, we
can add a WARN_ON_ONCE()" for this case. That has the added advantage
that it hopefully makes people understand just how stipid that idiotic
"probe flags" idea was.

Anyway, big NAK on this idiotic patch series, since as is the whole
concept and reasoning for it is crazy crap.

People, you need to really understand and INTERNALIZE that backwards
compatibility is important.

You need to understand it so well that you go "wow, this whole idea
about probing was obviously shit".

Really.

                  Linus
