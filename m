From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] statx: Kill fd-with-NULL-path support in favour of AT_EMPTY_PATH
Date: Thu, 27 Apr 2017 13:53:47 +0200
Message-ID: <CAKgNAkhBa6yiwY3unzxnK6TZ5umZUNTWxpXt1C9odHXfpcBuJg@mail.gmail.com>
References: <149324135581.24512.17200609423997054366.stgit@warthog.procyon.org.uk>
 <CA+55aFwUwQCJQFur67_FF3=5L1-q5P32JTm+TwPadKYnOo1B-A@mail.gmail.com>
Reply-To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CA+55aFwUwQCJQFur67_FF3=5L1-q5P32JTm+TwPadKYnOo1B-A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, linux-man <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Eric Sandeen <sandeen-+82itfer+wXR7s880joybQ@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, fstests <fstests-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 27 April 2017 at 00:03, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:
> On Wed, Apr 26, 2017 at 2:15 PM, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>> [!] NOTE: This breaks UAPI introduced in 4.11-rc1.
>
> Ugh.
>
> I'm, applying this now, so that we don't end up with a released kernel
> that supports the NULL filename thing.
>
> I'm not happy about the timing though. And I hope nobody started using
> statx() outside of tests.

Agreed on the timing. Late review on my part didn't help.

But, also, David's fix is not quite right. I will send a patch.

Cheers,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
