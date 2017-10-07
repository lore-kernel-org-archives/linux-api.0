From: Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] Userfaultfd: Add description for UFFD_FEATURE_SIGBUS
Date: Sat, 7 Oct 2017 16:44:15 +0200
Message-ID: <20171007144415.GG16918@redhat.com>
References: <1507344740-21993-1-git-send-email-prakash.sangappa@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1507344740-21993-1-git-send-email-prakash.sangappa-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Prakash Sangappa <prakash.sangappa-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, rppt-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, mhocko-IBi9RG/b67k@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hello Prakash,

On Fri, Oct 06, 2017 at 07:52:20PM -0700, Prakash Sangappa wrote:
> Userfaultfd feature UFFD_FEATURE_SIGBUS was merged recently and should
> be available in Linux 4.14 release. This patch is for the manpage
> changes documenting this API.
> 
> Documents the following commit:
> 
> commit 2d6d6f5a09a96cc1fec7ed992b825e05f64cb50e
> Author: Prakash Sangappa <prakash.sangappa-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Date: Wed Sep 6 16:23:39 2017 -0700
> 
>     mm: userfaultfd: add feature to request for a signal delivery
> 
> Signed-off-by: Prakash Sangappa <prakash.sangappa-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---
>  man2/ioctl_userfaultfd.2 |  9 +++++++++
>  man2/userfaultfd.2       | 17 +++++++++++++++++
>  2 files changed, 26 insertions(+)
> 
> diff --git a/man2/ioctl_userfaultfd.2 b/man2/ioctl_userfaultfd.2
> index 60fd29b..cfc65ae 100644
> --- a/man2/ioctl_userfaultfd.2
> +++ b/man2/ioctl_userfaultfd.2
> @@ -196,6 +196,15 @@ with the
>  flag set,
>  .BR memfd_create (2),
>  and so on.
> +.TP
> +.B UFFD_FEATURE_SIGBUS
> +Since Linux 4.14, If this feature bit is set, no page-fault events(

space after events?

> +.B UFFD_EVENT_PAGEFAULT
> +) will be delivered, instead a
> +.B SIGBUS
> +signal will be sent to the faulting process. Applications using this
> +feature will not require the use of a userfaultfd monitor for handling
> +page-fault events.
>  .IP
>  The returned
>  .I ioctls
> diff --git a/man2/userfaultfd.2 b/man2/userfaultfd.2
> index 1741ee3..a033742 100644
> --- a/man2/userfaultfd.2
> +++ b/man2/userfaultfd.2
> @@ -172,6 +172,23 @@ or
>  .BR ioctl (2)
>  operations to resolve the page fault.
>  .PP
> +Starting from Linux 4.14, if application sets
> +.B UFFD_FEATURE_SIGBUS
> +feature bit using
> +.B UFFDIO_API
> +.BR ioctl (2)
> +, no page fault notification will be forwarded to
> +the user-space, instead a
> +.B SIGBUS
> +signal is delivered to the faulting process. With this feature,
> +userfaultfd can be used for robustness purpose to simply catch
> +any access to areas within the registered address range that do not
> +have pages allocated, without having to deal with page-fault events.

",without having to listen to userfaultfd events." may be more clear.

> +No userfaultd monitor will be required for handling page faults. For
               ^
typo: userfaultfd

> +example, this feature can be useful for applications that want to
> +prevent the kernel from automatically allocating pages and filling
> +holes in sparse files when the hole is accessed thru mapped address.
> +.PP

Maybe also mention that "The UFFD_FEATURE_SIGBUS feature is implicitly
inherited through fork() if used in combination with
UFFD_FEATURE_FORK."
--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
