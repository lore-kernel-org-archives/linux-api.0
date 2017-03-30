From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: RFC: reject unknown open flags
Date: Thu, 30 Mar 2017 10:08:10 -0700
Message-ID: <CA+55aFw92r4h4sNW41ifs31ixdZpNmaxY23KthB9R-LXNm7p-w@mail.gmail.com>
References: <20170330163327.23920-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170330163327.23920-1-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, libc-alpha <libc-alpha-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Mar 30, 2017 at 9:33 AM, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org> wrote:
  This really harms
> when adding new flags, because applications can't just probe for the
> flag to actually work.

Side note: this whole argument is also incredibly idiotic from the
very beginning, regardless of the backwards compatibility issue.

But probing for flags is why we *could* add things like O_NOATIME etc
- exactly because it "just worked" with old kernels, and people could
just use the new flags knowing that it was a no-op on old kernels.

The whole concept of "probing for supported features" is very suspect.
It's a bad bad idea. Don't do it.

What kind of new flag did you even have in mind that would have such
broken semantics that it would completely change the other flags?
Becuase now I'm starting to think that the whole series has an even
deeper bug: stupid new features that were badly thought out and not
even described.

             Linus
