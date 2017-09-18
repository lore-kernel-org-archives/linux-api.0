From: Jann Horn <jannh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [patch] mremap.2: Add description of old_size == 0 functionality
Date: Sun, 17 Sep 2017 18:52:46 -0700
Message-ID: <CAG48ez0AAtzdQJPdW8sqj+mvYLdZezDe3x-_XgSvaN3ZwE=5GQ@mail.gmail.com>
References: <20170915213745.6821-1-mike.kravetz@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170915213745.6821-1-mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Kravetz <mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Michael Kerrisk-manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Kirill A . Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Anshuman Khandual <khandual-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Fri, Sep 15, 2017 at 2:37 PM, Mike Kravetz <mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
[...]
> A recent change was made to mremap so that an attempt to create a
> duplicate a private mapping will fail.
>
> commit dba58d3b8c5045ad89c1c95d33d01451e3964db7
> Author: Mike Kravetz <mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Date:   Wed Sep 6 16:20:55 2017 -0700
>
>     mm/mremap: fail map duplication attempts for private mappings
>
> This return code is also documented here.
[...]
> diff --git a/man2/mremap.2 b/man2/mremap.2
[...]
> @@ -174,7 +189,12 @@ and
>  or
>  .B MREMAP_FIXED
>  was specified without also specifying
> -.BR MREMAP_MAYMOVE .
> +.BR MREMAP_MAYMOVE ;
> +or \fIold_size\fP was zero and \fIold_address\fP does not refer to a
> +private anonymous mapping;

Shouldn't this be the other way around? "or old_size was zero and
old_address refers to a private anonymous mapping"?
--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
