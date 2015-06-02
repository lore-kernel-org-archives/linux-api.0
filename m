From: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: Re: [RESEND PATCH 3/3] Add tests for lock on fault
Date: Tue, 02 Jun 2015 09:25:57 -0600
Message-ID: <556DCB05.1010102@osg.samsung.com>
References: <1432908808-31150-1-git-send-email-emunson@akamai.com> <1432908808-31150-4-git-send-email-emunson@akamai.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1432908808-31150-4-git-send-email-emunson-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eric B Munson <emunson-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 05/29/2015 08:13 AM, Eric B Munson wrote:
> Test the mmap() flag, the mlockall() flag, and ensure that mlock limits
> are respected.  Note that the limit test needs to be run a normal user.
> 
> Signed-off-by: Eric B Munson <emunson-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>
> Cc: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
> Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
> Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> ---
>  tools/testing/selftests/vm/Makefile         |   8 +-
>  tools/testing/selftests/vm/lock-on-fault.c  | 145 ++++++++++++++++++++++++++++
>  tools/testing/selftests/vm/on-fault-limit.c |  47 +++++++++
>  tools/testing/selftests/vm/run_vmtests      |  23 +++++
>  4 files changed, 222 insertions(+), 1 deletion(-)
>  create mode 100644 tools/testing/selftests/vm/lock-on-fault.c
>  create mode 100644 tools/testing/selftests/vm/on-fault-limit.c
> 
> diff --git a/tools/testing/selftests/vm/Makefile b/tools/testing/selftests/vm/Makefile
> index a5ce953..32f3d20 100644
> --- a/tools/testing/selftests/vm/Makefile
> +++ b/tools/testing/selftests/vm/Makefile
> @@ -1,7 +1,13 @@
>  # Makefile for vm selftests
>  
>  CFLAGS = -Wall
> -BINARIES = hugepage-mmap hugepage-shm map_hugetlb thuge-gen hugetlbfstest
> +BINARIES = hugepage-mmap
> +BINARIES += hugepage-shm
> +BINARIES += hugetlbfstest
> +BINARIES += lock-on-fault
> +BINARIES += map_hugetlb
> +BINARIES += on-fault-limit
> +BINARIES += thuge-gen
>  BINARIES += transhuge-stress
>  
>  all: $(BINARIES)
> diff --git a/tools/testing/selftests/vm/lock-on-fault.c b/tools/testing/selftests/vm/lock-on-fault.c
> new file mode 100644
> index 0000000..e6a9688

Hi Eric,

Could you please make sure make kselftest run from kernel main
Makefile works and tools/testing/selftests/kselftest_install.sh
works. For now you have to be in tools/testing/selftests to run
kselftest_install.sh

thanks,
-- Shuah


-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org | (970) 217-8978
