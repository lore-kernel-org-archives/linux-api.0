From: Richard Cochran <richardcochran-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] Implement leftpad syscall
Date: Fri, 1 Apr 2016 08:56:39 +0200
Message-ID: <20160401065639.GA28596@localhost.localdomain>
References: <1459463613-32473-1-git-send-email-richard@nod.at>
 <1459463613-32473-2-git-send-email-richard@nod.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1459463613-32473-2-git-send-email-richard-/L3Ra7n9ekc@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Gstir <david-S6VGOU4v5edDinCvNWH78Q@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Apr 01, 2016 at 12:33:32AM +0200, Richard Weinberger wrote:
> From: David Gstir <david-S6VGOU4v5edDinCvNWH78Q@public.gmane.org>
> 
> Implement the leftpad() system call such that userspace,
> especially node.js applications, can in the near future directly
> use it and no longer depend on fragile npm packages.
> 
> Signed-off-by: David Gstir <david-S6VGOU4v5edDinCvNWH78Q@public.gmane.org>
> Signed-off-by: Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>
> ---
>  arch/x86/entry/syscalls/syscall_64.tbl |  1 +
>  include/linux/syscalls.h               |  1 +
>  kernel/sys.c                           | 35 ++++++++++++++++++++++++++++++++++
>  kernel/sys_ni.c                        |  1 +
>  4 files changed, 38 insertions(+)

This is okay as far as it goes, but you need to add the other archs
and put the relevant maintainers onto CC.

Thanks,
Richard
