From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH 1/2] vfs: add flags parameter to ->mmap() in 'struct
        file_operations'
Date: Thu, 31 Aug 2017 12:02:01 +0200
Message-ID: <20170831100201.GC21443@lst.de>
References: <150413449482.5923.1348069619036923853.stgit@dwillia2-desk3.amr.corp.intel.com> <150413450036.5923.13851061508172314879.stgit@dwillia2-desk3.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <150413450036.5923.13851061508172314879.stgit-p8uTFz9XbKj2zm6wflaqv1nYeNYlB/vhral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, David Airlie <airlied-cv59FeDIM0c@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Takashi Iwai <tiwai-IBi9RG/b67k@public.gmane.org>, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, Julia Lawall <julia.lawall-L2FTfq7BK8M@public.gmane.org>, luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Daniel Vetter <daniel.vetter-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org
List-Id: linux-api@vger.kernel.org

> -static int ecryptfs_mmap(struct file *file, struct vm_area_struct *vma)
> +static int ecryptfs_mmap(struct file *file, struct vm_area_struct *vma,
> +			 unsigned long map_flags)
>  {
>  	struct file *lower_file = ecryptfs_file_to_lower(file);
>  	/*
> @@ -179,7 +180,7 @@ static int ecryptfs_mmap(struct file *file, struct vm_area_struct *vma)
>  	 */
>  	if (!lower_file->f_op->mmap)
>  		return -ENODEV;
> -	return generic_file_mmap(file, vma);
> +	return generic_file_mmap(file, vma, 0);

Shouldn't ecryptfs pass on the flags?  Same for coda_file_mmap and
shm_mmap.

> -static inline int call_mmap(struct file *file, struct vm_area_struct *vma)
> +static inline int call_mmap(struct file *file, struct vm_area_struct *vma,
> +			    unsigned long flags)
>  {
> -	return file->f_op->mmap(file, vma);
> +	return file->f_op->mmap(file, vma, flags);
>  }

It would be great to kill this pointless wrapper while we're at it.
