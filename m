From: Jason Baron <jbaron@akamai.com>
Subject: Re: [RFC 0/3] fs,epoll: Add ability to call kcmp to find target files
Date: Tue, 21 Feb 2017 15:32:21 -0500
Message-ID: <39a65773-a58e-032b-1448-5e03bf78d763@akamai.com>
References: <20170221165944.180372636@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20170221165944.180372636@openvz.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Cyrill Gorcunov <gorcunov@openvz.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, akpm@linuxfoundation.org, avagin@virtuozzo.com, xemul@virtuozzo.com, mtk.manpages@gmail.com, kir@openvz.org, luto@amacapital.net
List-Id: linux-api@vger.kernel.org

On 02/21/2017 11:59 AM, Cyrill Gorcunov wrote:
> Hi! In previous series EPOLL_CTL_DUP operation has been discussed
> but considered as potentially scary. So here is an another approach:
>
>  - extend fdinfo of epoll files with inode, device and file position
>    for every target, which allow the reader to gather targets with
>    this bundle as a key for primary sorting
>
>  - extent kcmp to check if some particular file is matching one
>    sitting inside epoll queue (duplicate numbers are resolved with
>    offset parameter)
>

Hi,

Since an epoll fd can be added to another epoll fd, I'm wondering if you 
have enough data here to figure that out. The inode is the 
'anon_inode_inode', so I'm wondering if that is sufficient to 
distinguish it from other anonymous inodes, or if an extra bit is 
required to indicate if the target file is in fact and epoll fd.

Thanks,

-Jason

> Please take a look once time permit. Note that I did only basic
> testing (without CRIU) but it should fit our needs because we
> sort and lookup regualr files by same scheme. So I'm about to
> implemet full criu support for this new kernel features in
> a couple of days thus any comments are *higly* appreciated.
>
> NB: Initially I added
>
> 	if (file_ns_capable(epi->ffd.file, ns, CAP_SYS_ADMIN))
>
> into fdinfo output to check if caller is allowed to see
> target ino/dev/pos but dropped it later because if process
> is added file descriptor into epoll queue it mean fdstat
> and such already can be called and this information is
> already obtained, so I don't this it's information
> disclosure.
>
> 	Cyrill
>
