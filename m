From: Florian Weimer <fweimer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [patch] mremap.2: Add description of old_size == 0 functionality
Date: Mon, 18 Sep 2017 15:45:37 +0200
Message-ID: <fb013ae6-6f47-248b-db8b-a0abae530377@redhat.com>
References: <20170915213745.6821-1-mike.kravetz@oracle.com>
 <a6e59a7f-fd15-9e49-356e-ed439f17e9df@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <a6e59a7f-fd15-9e49-356e-ed439f17e9df-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Kravetz <mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Kirill A . Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Anshuman Khandual <khandual-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 09/15/2017 11:53 PM, Mike Kravetz wrote:
> +If the value of \fIold_size\fP is zero, and \fIold_address\fP refers to
> +a private anonymous mapping, then
> +.BR mremap ()
> +will create a new mapping of the same pages. \fInew_size\fP
> +will be the size of the new mapping and the location of the new mapping
> +may be specified with \fInew_address\fP, see the description of
> +.B MREMAP_FIXED
> +below.  If a new mapping is requested via this method, then the
> +.B MREMAP_MAYMOVE
> +flag must also be specified.  This functionality is deprecated, and no
> +new code should be written to use this feature.  A better method of
> +obtaining multiple mappings of the same private anonymous memory is via the
> +.BR memfd_create()
> +system call.

Is there any particular reason to deprecate this?

In glibc, we cannot use memfd_create and keep the file descriptor around 
because the application can close descriptors beneath us.

(We might want to use alias mappings to avoid run-time code generation 
for PLT-less LD_AUDIT interceptors.)

Thanks,
Florian
--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
