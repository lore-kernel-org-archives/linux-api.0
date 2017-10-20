From: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH] mmap.2: Add description of MAP_SHARED_VALIDATE and
 MAP_SYNC
Date: Fri, 20 Oct 2017 15:47:53 -0600
Message-ID: <20171020214753.GA15733@linux.intel.com>
References: <20171019125817.11580-1-jack@suse.cz>
 <20171019125817.11580-19-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171019125817.11580-19-jack-AlSwsSmVLrQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, Oct 19, 2017 at 02:58:17PM +0200, Jan Kara wrote:
> Signed-off-by: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
> ---
>  man2/mmap.2 | 30 ++++++++++++++++++++++++++++++
>  1 file changed, 30 insertions(+)
> 
> diff --git a/man2/mmap.2 b/man2/mmap.2
> index 47c3148653be..598ff0c64f7f 100644
> --- a/man2/mmap.2
> +++ b/man2/mmap.2
> @@ -125,6 +125,21 @@ are carried through to the underlying file.
>  to the underlying file requires the use of
>  .BR msync (2).)
>  .TP
> +.B MAP_SHARED_VALIDATE
> +The same as
> +.B MAP_SHARED
> +except that
> +.B MAP_SHARED
> +mappings ignore unknown flags in
> +.IR flags .
> +In contrast when creating mapping of
> +.B MAP_SHARED_VALIDATE
> +mapping type, the kernel verifies all passed flags are known and fails the
> +mapping with
> +.BR EOPNOTSUPP
> +otherwise. This mapping type is also required to be able to use some mapping
> +flags.
> +.TP

Some small nits:

I think you should maybe include a "(since Linux 4.15)" type note after the
MAP_SHARED_VALIDATE header.  You also need to update the following line:

       Both of these flags are described in POSIX.1-2001 and POSIX.1-2008.

Which used to refer to MAP_SYNC and MAP_PRIVATE.
