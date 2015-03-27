From: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [patch][resend] MAP_HUGETLB munmap fails with size not 2MB aligned
Date: Fri, 27 Mar 2015 10:45:44 +0100
Message-ID: <551526C8.1000105@suse.cz>
References: <alpine.DEB.2.10.1410221518160.31326@davide-lnx3> <alpine.LSU.2.11.1503251708530.5592@eggly.anvils> <alpine.DEB.2.10.1503251754320.26501@davide-lnx3> <alpine.DEB.2.10.1503251938170.16714@chino.kir.corp.google.com> <alpine.DEB.2.10.1503260431290.2755@mbplnx> <alpine.DEB.2.10.1503261201440.8238@chino.kir.corp.google.com> <alpine.DEB.2.10.1503261221470.5119@davide-lnx3>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.10.1503261221470.5119@davide-lnx3>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Davide Libenzi <davidel-AhlLAIvw+VEjIGhXcJzhZg@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Joern Engel <joern-PCqxUs/MD9bYtjvyW6yDsg@public.gmane.org>, Jianguo Wu <wujianguo-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Eric B Munson <emunson-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 03/26/2015 08:39 PM, Davide Libenzi wrote:
> On Thu, 26 Mar 2015, David Rientjes wrote:
> 
>> Yes, this munmap() behavior of lengths <= hugepage_size - PAGE_SIZE for a 
>> hugetlb vma is long standing and there may be applications that break as a 
>> result of changing the behavior: a database that reserves all allocated 
>> hugetlb memory with mmap() so that it always has exclusive access to those 
>> hugepages, whether they are faulted or not, and maintains its own hugepage 
>> pool (which is common), may test the return value of munmap() and depend 
>> on it returning -EINVAL to determine if it is freeing memory that was 
>> either dynamically allocated or mapped from the hugetlb reserved pool.
> 
> You went a long way to create such a case.
> But, in your case, that application will erroneously considering hugepage 
> mmaped memory, as dynamically allocated, since it will always get EINVAL, 
> unless it passes an aligned size. Aligned size, which a fix like the one 
> posted in the patch will still leave as success.
> OTOH, an application, which might be more common than the one you posted,
> which calls munmap() to release a pointer which it validly got from a 
> previous mmap(), will leak huge pages as all the issued munmaps will fail.
> 
> 
>> If we were to go back in time and decide this when the munmap() behavior 
>> for hugetlb vmas was originally introduced, that would be valid.  The 
>> problem is that it could lead to userspace breakage and that's a 
>> non-starter.
>> 
>> What we can do is improve the documentation and man-page to clearly 
>> specify the long-standing behavior so that nobody encounters unexpected 
>> results in the future.
> 
> This way you will leave the mmap API with broken semantics.
> In any case, I am done arguing.
> I will leave to Andrew to sort it out, and to Michael Kerrisk to update 
> the mmap man pages with the new funny behaviour.

+ CC's

You know that people don't always magically CC themselves, or read all of
lkml/linux-mm? :)

> 
> 
> - Davide
> 
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo-Bw31MaZKKs0EbZ0PF+XxCw@public.gmane.org  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org"> email-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org </a>
> 
