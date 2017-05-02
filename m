From: Miklos Szeredi <miklos-sUDqSbJrdHQHWmgEVkV9KA@public.gmane.org>
Subject: error value for "internal error"
Date: Tue, 2 May 2017 16:03:34 +0200
Message-ID: <CAJfpegv3xS_MEVVeAnd4JUvjxoJd9PQdbsEzCPXNpUeex4SxHA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-api@vger.kernel.org

I've been wondering what to return for soft asserts like this:

        if (WARN_ON(something unexpected))
                return -E????;

EINVAL doesn't fit because it means the input from userspace was
wrong.  EIO means something went bad with the hardware.

There's no "software error" or "internal error" type return code.
Would it make sense to introduce one?

Rule would be to always add more detail to dmesg (such as done by
WARN_ON) when such a code is returned.

Thanks,
Miklos
