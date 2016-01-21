From: Nikhilesh Reddy <reddyn-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: Re: [PATCH v3] fuse: Add support for passthrough read/write
Date: Wed, 20 Jan 2016 16:15:52 -0800
Message-ID: <56A02338.9000001@codeaurora.org>
References: <56A01642.7030806@codeaurora.org> <20160120233841.GA16235@pc.thejh.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160120233841.GA16235-J1fxOzX/cBvk1uMJSBkQmQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jann Horn <jann-XZ1E9jl8jIdeoWH0uzbU5w@public.gmane.org>
Cc: torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, Miklos Szeredi <miklos-sUDqSbJrdHQHWmgEVkV9KA@public.gmane.org>, fuse-devel <fuse-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, Richard Weinberger <richard.weinberger-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, jack-AlSwsSmVLrQ@public.gmane.org, Antonio SJ Musumeci <trapexit-wGTF+nt6ur047o9RxwvyTQ@public.gmane.org>, sven.utcke-Mmb7MZpHnFY@public.gmane.org, Nikolaus Rath <nikolaus-BTH8mxji4b0@public.gmane.org>, Jann Horn <jannhorn-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed 20 Jan 2016 03:38:41 PM PST, Jann Horn wrote:
> On Wed, Jan 20, 2016 at 03:20:34PM -0800, Nikhilesh Reddy wrote:
>> Add support for filesystem passthrough read/write of files
>> when enabled in userspace through the option FUSE_PASSTHROUGH.
> [...]
>> +	daemon_fd = (int)open_out->passthrough_fd;
>> +	if (daemon_fd < 0)
>> +		return;
>> +
>> +	passthrough_filp = fget_raw(daemon_fd);
>> +	if (!passthrough_filp)
>> +		return;
>> +
>> +	passthrough_inode = file_inode(passthrough_filp);
>> +	passthrough_sb = passthrough_inode->i_sb;
>> +	fs_stack_depth = passthrough_sb->s_stack_depth + 1;
>> +
>> +	/* If we reached the stacking limit go through regular io */
>> +	if (fs_stack_depth > FILESYSTEM_MAX_STACK_DEPTH) {
>> +		pr_err("FUSE: maximum fs stacking depth exceeded, cannot use passthrough for this file\n");
>> +		return;
>> +	}
>
> I think this needs an fput() in the error case to prevent a refcount leak.

Whoops my bad .. forgot to commit! :(
Thanks for the catch
fixed ... sending patch v4 in a few minutes
-- 
Thanks
Nikhilesh Reddy

Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project.
