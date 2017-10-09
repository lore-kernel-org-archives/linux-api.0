From: Robin Murphy <robin.murphy-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH v8] dma-mapping: introduce dma_get_iommu_domain()
Date: Mon, 9 Oct 2017 11:37:04 +0100
Message-ID: <8161efa8-a315-3b0b-4159-9bdf3bfb98aa@arm.com>
References: <150732935473.22363.1853399637339625023.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150743420333.12880.6968831423519457797.stgit@dwillia2-desk3.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <150743420333.12880.6968831423519457797.stgit-p8uTFz9XbKj2zm6wflaqv1nYeNYlB/vhral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Ashok Raj <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Marek Szyprowski <m.szyprowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Dan,

On 08/10/17 04:45, Dan Williams wrote:
> Add a dma-mapping api helper to retrieve the generic iommu_domain for a device.
> The motivation for this interface is making RDMA transfers to DAX mappings
> safe. If the DAX file's block map changes we need to be to reliably stop
> accesses to blocks that have been freed or re-assigned to a new file.

...which is also going to require some way to force the IOMMU drivers
(on x86 at least) to do a fully-synchronous unmap, instead of just
throwing the IOVA onto a flush queue to invalidate the TLBs at some
point in the future. Assuming of course that there's an IOMMU both
present and performing DMA translation in the first place.

> With the
> iommu_domain and a callback from the DAX filesystem the kernel can safely
> revoke access to a DMA device. The process that performed the RDMA memory
> registration is also notified of this revocation event, but the kernel can not
> otherwise be in the position of waiting for userspace to quiesce the device.

OK, but why reinvent iommu_get_domain_for_dev()?

> Since PMEM+DAX is currently only enabled for x86, we only update the x86
> iommu drivers.

Note in particular that those two drivers happen to be the *only* place
this approach could work - everyone else is going to have to fall back
to the generic IOMMU API function anyway.

Robin.

> Cc: Marek Szyprowski <m.szyprowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
> Cc: Robin Murphy <robin.murphy-5wv7dgnIgG8@public.gmane.org>
> Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
> Cc: Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>
> Cc: David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
> Cc: Ashok Raj <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
> Cc: Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> Cc: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
> Cc: "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Cc: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> Signed-off-by: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
> Changes since v7:
> * retrieve the iommu_domain so that we can later pass the results of
>   dma_map_* to iommu_unmap() in advance of the actual dma_unmap_*.
> 
>  drivers/base/dma-mapping.c  |   10 ++++++++++
>  drivers/iommu/amd_iommu.c   |   10 ++++++++++
>  drivers/iommu/intel-iommu.c |   15 +++++++++++++++
>  include/linux/dma-mapping.h |    3 +++
>  4 files changed, 38 insertions(+)
> 
> diff --git a/drivers/base/dma-mapping.c b/drivers/base/dma-mapping.c
> index e584eddef0a7..fdb9764f95a4 100644
> --- a/drivers/base/dma-mapping.c
> +++ b/drivers/base/dma-mapping.c
> @@ -369,3 +369,13 @@ void dma_deconfigure(struct device *dev)
>  	of_dma_deconfigure(dev);
>  	acpi_dma_deconfigure(dev);
>  }
> +
> +struct iommu_domain *dma_get_iommu_domain(struct device *dev)
> +{
> +	const struct dma_map_ops *ops = get_dma_ops(dev);
> +
> +	if (ops && ops->get_iommu)
> +		return ops->get_iommu(dev);
> +	return NULL;
> +}
> +EXPORT_SYMBOL(dma_get_iommu_domain);
> diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
> index 51f8215877f5..c8e1a45af182 100644
> --- a/drivers/iommu/amd_iommu.c
> +++ b/drivers/iommu/amd_iommu.c
> @@ -2271,6 +2271,15 @@ static struct protection_domain *get_domain(struct device *dev)
>  	return domain;
>  }
>  
> +static struct iommu_domain *amd_dma_get_iommu(struct device *dev)
> +{
> +	struct protection_domain *domain = get_domain(dev);
> +
> +	if (IS_ERR(domain))
> +		return NULL;
> +	return &domain->domain;
> +}
> +
>  static void update_device_table(struct protection_domain *domain)
>  {
>  	struct iommu_dev_data *dev_data;
> @@ -2689,6 +2698,7 @@ static const struct dma_map_ops amd_iommu_dma_ops = {
>  	.unmap_sg	= unmap_sg,
>  	.dma_supported	= amd_iommu_dma_supported,
>  	.mapping_error	= amd_iommu_mapping_error,
> +	.get_iommu	= amd_dma_get_iommu,
>  };
>  
>  static int init_reserved_iova_ranges(void)
> diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
> index 6784a05dd6b2..f3f4939cebad 100644
> --- a/drivers/iommu/intel-iommu.c
> +++ b/drivers/iommu/intel-iommu.c
> @@ -3578,6 +3578,20 @@ static int iommu_no_mapping(struct device *dev)
>  	return 0;
>  }
>  
> +static struct iommu_domain *intel_dma_get_iommu(struct device *dev)
> +{
> +	struct dmar_domain *domain;
> +
> +	if (iommu_no_mapping(dev))
> +		return NULL;
> +
> +	domain = get_valid_domain_for_dev(dev);
> +	if (!domain)
> +		return NULL;
> +
> +	return &domain->domain;
> +}
> +
>  static dma_addr_t __intel_map_single(struct device *dev, phys_addr_t paddr,
>  				     size_t size, int dir, u64 dma_mask)
>  {
> @@ -3872,6 +3886,7 @@ const struct dma_map_ops intel_dma_ops = {
>  	.map_page = intel_map_page,
>  	.unmap_page = intel_unmap_page,
>  	.mapping_error = intel_mapping_error,
> +	.get_iommu = intel_dma_get_iommu,
>  #ifdef CONFIG_X86
>  	.dma_supported = x86_dma_supported,
>  #endif
> diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
> index 29ce9815da87..aa62df1d0d72 100644
> --- a/include/linux/dma-mapping.h
> +++ b/include/linux/dma-mapping.h
> @@ -128,6 +128,7 @@ struct dma_map_ops {
>  				   enum dma_data_direction dir);
>  	int (*mapping_error)(struct device *dev, dma_addr_t dma_addr);
>  	int (*dma_supported)(struct device *dev, u64 mask);
> +	struct iommu_domain *(*get_iommu)(struct device *dev);
>  #ifdef ARCH_HAS_DMA_GET_REQUIRED_MASK
>  	u64 (*get_required_mask)(struct device *dev);
>  #endif
> @@ -221,6 +222,8 @@ static inline const struct dma_map_ops *get_dma_ops(struct device *dev)
>  }
>  #endif
>  
> +extern struct iommu_domain *dma_get_iommu_domain(struct device *dev);
> +
>  static inline dma_addr_t dma_map_single_attrs(struct device *dev, void *ptr,
>  					      size_t size,
>  					      enum dma_data_direction dir,
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
