From: "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
Subject: THP-enabled filesystem vs. FALLOC_FL_PUNCH_HOLE
Date: Fri, 4 Mar 2016 14:26:03 +0300
Message-ID: <20160304112603.GA9790@node.shutemov.name>
References: <1457023939-98083-1-git-send-email-kirill.shutemov@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1457023939-98083-1-git-send-email-kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Christoph Lameter <cl-gkYfJU5Cukgdnm+yROfE0A@public.gmane.org>, Naoya Horiguchi <n-horiguchi-PaJj6Psr51x8UrSeD/g0lQ@public.gmane.org>, Jerome Marchand <jmarchan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Yang Shi <yang.shi-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Sasha Levin <sasha.levin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, Mar 03, 2016 at 07:51:50PM +0300, Kirill A. Shutemov wrote:
> Truncate and punch hole that only cover part of THP range is implemented
> by zero out this part of THP.
> 
> This have visible effect on fallocate(FALLOC_FL_PUNCH_HOLE) behaviour.
> As we don't really create hole in this case, lseek(SEEK_HOLE) may have
> inconsistent results depending what pages happened to be allocated.
> Not sure if it should be considered ABI break or not.

Looks like this shouldn't be a problem. man 2 fallocate:

	Within the specified range, partial filesystem blocks are zeroed,
	and whole filesystem blocks are removed from the file.  After a
	successful call, subsequent reads from this range will return
	zeroes.

It means we effectively have 2M filesystem block size.

And I don't see any guarantee about subsequent lseek(SEEK_HOLE) beheviour.

-- 
 Kirill A. Shutemov
