From: Nikhilesh Reddy <reddyn-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: Re: [PATCH v5] fuse: Add support for passthrough read/write
Date: Wed, 03 Feb 2016 11:05:32 -0800
Message-ID: <56B24F7C.4060703@codeaurora.org>
References: <56AFAA5B.3000006@codeaurora.org> <20160201191555.GA3524@pc.thejh.net> <56AFB1F3.8090902@codeaurora.org> <20160201194526.GA11837@pc.thejh.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160201194526.GA11837-J1fxOzX/cBvk1uMJSBkQmQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jann Horn <jann-XZ1E9jl8jIdeoWH0uzbU5w@public.gmane.org>
Cc: torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, Miklos Szeredi <miklos-sUDqSbJrdHQHWmgEVkV9KA@public.gmane.org>, fuse-devel <fuse-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, jack-AlSwsSmVLrQ@public.gmane.org, Antonio SJ Musumeci <trapexit-wGTF+nt6ur047o9RxwvyTQ@public.gmane.org>, sven.utcke-Mmb7MZpHnFY@public.gmane.org, Nikolaus Rath <nikolaus-BTH8mxji4b0@public.gmane.org>, Jann Horn <jannhorn-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>, Mike Shal <marfey-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 02/01/2016 11:45 AM, Jann Horn wrote:
> On Mon, Feb 01, 2016 at 11:28:51AM -0800, Nikhilesh Reddy wrote:
>> On Mon 01 Feb 2016 11:15:56 AM PST, Jann Horn wrote:
>>> On Mon, Feb 01, 2016 at 10:56:27AM -0800, Nikhilesh Reddy wrote:
>>>> diff --git a/fs/fuse/passthrough.c b/fs/fuse/passthrough.c
>>> [...]
>>>> +static ssize_t fuse_passthrough_read_write_iter(struct kiocb *iocb,
>>>> +					    struct iov_iter *iter, int do_write)
>>>> +{
>>>> +	ssize_t ret_val;
>>>> +	struct fuse_file *ff;
>>>> +	struct file *fuse_file, *passthrough_filp;
>>>> +	struct inode *fuse_inode, *passthrough_inode;
>>>> +
>>>> +	ff = iocb->ki_filp->private_data;
>>>> +	fuse_file = iocb->ki_filp;
>>>> +	passthrough_filp = ff->passthrough_filp;
>>>> +
>>>> +	/* lock passthrough file to prevent it from being released */
>>>> +	get_file(passthrough_filp);
>>>> +	iocb->ki_filp = passthrough_filp;
>>>> +	fuse_inode = fuse_file->f_path.dentry->d_inode;
>>>> +	passthrough_inode = file_inode(passthrough_filp);
>>>> +
>>>> +	if (do_write) {
>>>> +		if (!passthrough_filp->f_op->write_iter)
>>>> +			return -EIO;
>>>> +		ret_val = passthrough_filp->f_op->write_iter(iocb, iter);
>>>> +
>>>> +		if (ret_val >= 0 || ret_val == -EIOCBQUEUED) {
>>>> +			fsstack_copy_inode_size(fuse_inode, passthrough_inode);
>>>> +			fsstack_copy_attr_times(fuse_inode, passthrough_inode);
>>>> +		}
>>>> +	} else {
>>>> +		if (!passthrough_filp->f_op->read_iter)
>>>> +			return -EIO;
>>>> +		ret_val = passthrough_filp->f_op->read_iter(iocb, iter);
>>>> +		if (ret_val >= 0 || ret_val == -EIOCBQUEUED)
>>>> +			fsstack_copy_attr_atime(fuse_inode, passthrough_inode);
>>>> +	}
>>>> +
>>>> +	iocb->ki_filp = fuse_file;
>>>> +
>>>> +	/* unlock passthrough file */
>>>> +	fput(passthrough_filp);
>>>
>>> Why the get_file() and fput() in this method? This doesn't look right. There
>>> is no lock you're releasing between get_file() and fput(). What are they
>>> intended for?
>>
>> Hi
>>
>> Thanks for reviewing the code.
>>
>> The passthrough file could be released under our feet say  if the userspace
>> fuse daemon crashed or was killed  ( while we are processing the read or the
>> write) causing bad things to happen.
>> The calls here are to increase the count temporarily  and then decrease it
>> so that we dont release in the middle of a write and everything is
>> gracefully handled...
>>
>> I have a comment right before the get_file call above saying the same thing.
>> Please let me know if you have any more questions.
>
> If that is the case, why can't the passthrough file be released before the
> get_file() call, e.g. while the core processing the filesystem read request
> is entering fuse_passthrough_read_write_iter()?
>
> As far as I can tell, you can drop the get_file() and fput() calls.
> fuse_setup_passthrough() already took a reference to the file for you, that
> reference can only be dropped in fuse_passthrough_release(), and the VFS
> ensures that no release call happens while a read or write is pending.
>
I just feel uncomfortable with dropping them. I thought they could be 
released ( i/o ) takes longer than the actual execution... but if i can 
be sure of it then maybe..

-- 
Thanks
Nikhilesh Reddy

Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project.
