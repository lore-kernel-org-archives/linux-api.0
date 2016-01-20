From: Nikhilesh Reddy <reddyn-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: Re: [PATCH] fuse: Add support for fuse stacked I/O
Date: Wed, 20 Jan 2016 15:07:39 -0800
Message-ID: <56A0133B.9090501@codeaurora.org>
References: <565394BE.4040506@codeaurora.org> <5696E366.2080605@codeaurora.org> <CAK9i0=ojVmbuDiFXY_sHA12vTWgz9aKwEQuZmmYtUka3zqr=hg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAK9i0=ojVmbuDiFXY_sHA12vTWgz9aKwEQuZmmYtUka3zqr=hg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jann Horn <jannhorn-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
Cc: Miklos Szeredi <miklos-sUDqSbJrdHQHWmgEVkV9KA@public.gmane.org>, fuse-devel <fuse-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, Richard Weinberger <richard.weinberger-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, jack-AlSwsSmVLrQ@public.gmane.org, Antonio SJ Musumeci <trapexit-wGTF+nt6ur047o9RxwvyTQ@public.gmane.org>, sven.utcke-Mmb7MZpHnFY@public.gmane.org, Nikolaus Rath <nikolaus-BTH8mxji4b0@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 01/18/2016 07:07 PM, Jann Horn wrote:
> 2016-01-14 0:53 GMT+01:00 Nikhilesh Reddy <reddyn-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>:
>> Add support for filesystem stacked read/write of files
>> when enabled through a userspace init option of FUSE_STACKED_IO.
>>
>> When FUSE_STACKED_IO is enabled all the reads and writes
>> to the fuse mount point go directly to the native filesystem
>> rather than through the fuse daemon. All requests that aren't
>> read/write still go thought the userspace code.
>
> Maybe I missed it, but how does this guard against kernel stack
> overflow and how does it interact with the "sb->s_stack_depth >
> FILESYSTEM_MAX_STACK_DEPTH" stacking limit that overlayfs and ecryptfs
> use?
>
> As far as I can tell from a quick glance, someone could just stack
> lots of FUSE files on top of each other and cause kernel stack
> overflow that way, and that's nasty.
>
Hi
Thanks so much for your comment and for catching this.
I have fixed the code to prevent further stacking and will send it out 
in the updated version of the patch ( now called fuse passthrough ).

-- 
Thanks
Nikhilesh Reddy

Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project.
