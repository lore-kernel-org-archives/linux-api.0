From: Nikhilesh Reddy <reddyn@codeaurora.org>
Subject: Re: [PATCH] fuse: Add support for fuse stacked I/O
Date: Thu, 14 Jan 2016 10:57:27 -0800
Message-ID: <5697EF97.9020800@codeaurora.org>
References: <565394BE.4040506@codeaurora.org> <5696E366.2080605@codeaurora.org> <20160114045716.GB8006@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160114045716.GB8006@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, fuse-devel <fuse-devel@lists.sourceforge.net>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk, Theodore Ts'o <tytso@mit.edu>, jack@suse.cz, Antonio SJ Musumeci <trapexit@spawn.link>, sven.utcke@gmx.de, Nikolaus Rath <nikolaus@rath.org>, Richard Weinberger <richard@nod.at>
List-Id: linux-api@vger.kernel.org


>
> Your patch is line-wrapped and impossible to apply.
>
> And why cc: me?  This isn't my area of the kernel...
>
> greg k-h
>

Thanks for trying to apply the patch
and i am extremely  sorry for mangling the lines ( my config was broken)
I cc-ed you and a few other ppl to help with the review and the merge.
I am sorry if i bothered you.
But i would still be grateful for your comments


*I will send out a properly formatted patch shortly.*

To quote Nikolaus Rath
(the current maintainer of fuse userspace[libfuse]) :

[BEGIN QUOTE]
"Officially Miklos is still the maintainer, but I understand he has
almost no time for FUSE at the moment (neither kernel nor userspace). I
have taken over the userspace components, but as far as I know no one
stepped up for the kernel work.

The FUSE kernel components are maintained in the mainline Linux kernel
tree (and have been for quite some time), so nothing is being moved.

The way to get changes into the FUSE kernel module is the same procedure
as for any other kernel code: try to convince a maintainer to commit
your code. This doesn't need to be Miklos. If there's really no
maintainer available to review your patch, you can also try to send it
to Linus directly."
[END QUOTE]

I am hoping for some help from the maintainers to help get the patch 
merged. I have seen a lot of interest on the patch from the fuse 
community and would like to work with the kernel maintainers to help get 
the patch merged into the kernel.

*I will send out a properly formatted patch shortly.* sorry for the bad 
patch
-- 
Thanks
Nikhilesh Reddy

Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project.
