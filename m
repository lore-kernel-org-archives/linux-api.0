From: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Subject: Re: [patch 2/2] mm, selftests: test return value of munmap for
 MAP_HUGETLB memory
Date: Fri, 27 Mar 2015 10:52:16 +1100
Message-ID: <1427413936.23142.4.camel@ellerman.id.au>
References: <alpine.DEB.2.10.1503261621570.20009@chino.kir.corp.google.com>
	 <alpine.DEB.2.10.1503261623280.20009@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.10.1503261623280.20009-X6Q0R45D7oAcqpCFd4KODRPsWskHk0ljAL8bYrjMMd8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Davide Libenzi <davidel-AhlLAIvw+VEjIGhXcJzhZg@public.gmane.org>, Luiz Capitulino <lcapitulino-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Joern Engel <joern-PCqxUs/MD9bYtjvyW6yDsg@public.gmane.org>, Jianguo Wu <wujianguo-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Eric B Munson <emunson-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, 2015-03-26 at 16:23 -0700, David Rientjes wrote:
> When MAP_HUGETLB memory is unmapped, the length must be hugepage aligned,
> otherwise it fails with -EINVAL.
> 
> All tests currently behave correctly, but it's better to explcitly test
> the return value for completeness and document the requirement,
> especially if users copy map_hugetlb.c as a sample implementation.
> 
> Signed-off-by: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> ---
>  tools/testing/selftests/powerpc/mm/hugetlb_vs_thp_test.c | 8 ++++++--
> 
> diff --git a/tools/testing/selftests/powerpc/mm/hugetlb_vs_thp_test.c b/tools/testing/selftests/powerpc/mm/hugetlb_vs_thp_test.c
> --- a/tools/testing/selftests/powerpc/mm/hugetlb_vs_thp_test.c
> +++ b/tools/testing/selftests/powerpc/mm/hugetlb_vs_thp_test.c
> @@ -21,9 +21,13 @@ static int test_body(void)
>  		 * Typically the mmap will fail because no huge pages are
>  		 * allocated on the system. But if there are huge pages
>  		 * allocated the mmap will succeed. That's fine too, we just
> -		 * munmap here before continuing.
> +		 * munmap here before continuing.  munmap() length of
> +		 * MAP_HUGETLB memory must be hugepage aligned.
>  		 */
> -		munmap(addr, SIZE);
> +		if (munmap(addr, SIZE)) {
> +			perror("munmap");
> +			return 1;
> +		}
>  	}
>  
>  	p = mmap(addr, SIZE, PROT_READ | PROT_WRITE,

Acked-by: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>

cheers
