From: Nikhilesh Reddy <reddyn-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: Re: [PATCH v5] fuse: Add support for passthrough read/write
Date: Wed, 03 Feb 2016 11:05:57 -0800
Message-ID: <56B24F95.9040702@codeaurora.org>
References: <56AFAA5B.3000006@codeaurora.org> <20160202081035.GA18246@pc.thejh.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160202081035.GA18246-J1fxOzX/cBvk1uMJSBkQmQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jann Horn <jann-XZ1E9jl8jIdeoWH0uzbU5w@public.gmane.org>
Cc: torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, Miklos Szeredi <miklos-sUDqSbJrdHQHWmgEVkV9KA@public.gmane.org>, fuse-devel <fuse-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, jack-AlSwsSmVLrQ@public.gmane.org, Antonio SJ Musumeci <trapexit-wGTF+nt6ur047o9RxwvyTQ@public.gmane.org>, sven.utcke-Mmb7MZpHnFY@public.gmane.org, Nikolaus Rath <nikolaus-BTH8mxji4b0@public.gmane.org>, Jann Horn <jannhorn-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>, Mike Shal <marfey-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi
Thanks for your review again :)
>
> Uh... how do you know at this point that the file is actually writable?
> Normally, e.g. vfs_write() will ensure that the file is writable, and
> e.g. generic_file_write_iter() won't check for writability as far as I
> can tell. This might allow someone to use the passthrough mechanism to
> overwrite a file he is only allowed to read, but not write, like
> /etc/passwd.

I considered adding the checks ( the same ones that VFS does)  but not 
sure if we need to.
So the user will need to construct a fuse filesystem ( that opens for 
O_READONLY even though the user asks for a O_RDWR from the FUSE open) 
and then mount it , with CAP_SYS_ADMIN  for which you need to be root 
but  once he has that he should be able to easily get to the files 
without needing to go through FUSE  right using CAP_DAC_OVERRIDE?

Am i missing something? Please do help me understand.

But yes if really needed I can add additional checks once i understand it


>
> Also, I think this might bypass mandatory locks, the
> security_file_permission hook (which seems like a bad idea anyway
> though), inotify/fsnotify and sb_start_write.
>
Can you please elaborate/clarify further? I am am not sure what you mean.


Again thanks for your reviews :)
Appreciate your help
-- 
Thanks
Nikhilesh Reddy

Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project.
