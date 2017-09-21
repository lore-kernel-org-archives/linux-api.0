From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: Re: [patch] memfd_create.2: Add description of MFD_HUGETLB
 (hugetlbfs) support
Date: Thu, 21 Sep 2017 15:03:35 +0200
Message-ID: <fd171d77-7ded-722d-ed3a-4e09d44fb358@gmail.com>
References: <20170915214305.7148-1-mike.kravetz@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20170915214305.7148-1-mike.kravetz@oracle.com>
Content-Language: en-US
Sender: owner-linux-mm@kvack.org
To: Mike Kravetz <mike.kravetz@oracle.com>
Cc: mtk.manpages@gmail.com, linux-man@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>, Andrea Arcangeli <aarcange@redhat.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>
List-Id: linux-api@vger.kernel.org

Hi Mike,

On 09/15/2017 11:43 PM, Mike Kravetz wrote:
> hugetlbfs support for memfd_create was recently merged by Linus and
> should be in the Linux 4.14 release.  To request hugetlbfs support
> a new memfd_create flag (MFD_HUGETLB) was added.
> 
> This patch documents the following commit:
> 
> commit 749df87bd7bee5a79cef073f5d032ddb2b211de8
> Author: Mike Kravetz <mike.kravetz@oracle.com>
> Date:   Wed Sep 6 16:24:16 2017 -0700
> 
>     mm/shmem: add hugetlbfs support to memfd_create()

Thanks! I've applied this patch.

Cheers,

Michael

> 
> Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
> ---
>  man2/memfd_create.2 | 27 +++++++++++++++++++++++++++
>  1 file changed, 27 insertions(+)
> 
> diff --git a/man2/memfd_create.2 b/man2/memfd_create.2
> index 4dfd1bb2d..b61254bb8 100644
> --- a/man2/memfd_create.2
> +++ b/man2/memfd_create.2
> @@ -100,6 +100,33 @@ If this flag is not set, the initial set of seals will be
>  meaning that no other seals can be set on the file.
>  .\" FIXME Why is the MFD_ALLOW_SEALING behavior not simply the default?
>  .\" Is it worth adding some text explaining this?
> +.TP
> +.BR MFD_HUGETLB " (since Linux 4.14)"
> +The anonymous file will be created in the hugetlbfs filesystem using
> +huge pages.  See the Linux kernel source file
> +.I Documentation/vm/hugetlbpage.txt
> +for more information about hugetlbfs.  The hugetlbfs filesystem does
> +not support file sealing operations.  Therefore, specifying both
> +.B MFD_HUGETLB
> +and
> +.B MFD_ALLOW_SEALING
> +will result in an error
> +.RB (EINVAL)
> +being returned.
> +
> +.TP
> +.BR MFD_HUGE_2MB ", " MFD_HUGE_1GB ", " "..."
> +Used in conjunction with
> +.B MFD_HUGETLB
> +to select alternative hugetlb page sizes (respectively, 2 MB, 1 GB, ...)
> +on systems that support multiple hugetlb page sizes.  Definitions for known
> +huge page sizes are included in the header file
> +.I <sys/memfd.h>.
> +
> +For details on encoding huge page sizes not included in the header file,
> +see the discussion of the similarly named constants in
> +.BR mmap (2).
> +
>  .PP
>  Unused bits in
>  .I flags
> 


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
