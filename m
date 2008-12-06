From: "Edward Estabrook" <edward.estabrook.lkml-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/1] Userspace I/O (UIO): Add support for userspace DMA (corrected)
Date: Fri, 5 Dec 2008 16:16:00 -0800
Message-ID: <208aa0f00812051616w79a593e8lc264260ccd26111e@mail.gmail.com>
References: <208aa0f00812031751n27a75d21h8747054651639463@mail.gmail.com>
	 <20081204194041.GC3079@local>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20081204194041.GC3079@local>
Content-Disposition: inline
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hans J. Koch" <hjk-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gregkh-l3A5Bk7waGM@public.gmane.org, edward.estabrook-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, edward_estabrook-+2HdxjxtzLdBDgjK7y7TUQ@public.gmane.org
List-Id: linux-api@vger.kernel.org

> What I don't understand is why you want to allocate memory in the UIO core.
> In the current UIO concept, this is the driver's task. Of course we can have
> (exported) functions in the core that can help a driver doing this.
>

There are several compelling reasons to allocate memory in UIO core.
1)
I have a requirement to *dynamically* allocate the DMA regions.
The statically mapped regions contain a variable-sized ring buffer.
I use UIO driver to allocate several thousand 4k DMA regions.
If I need more during program execution I can grow the ring-buffer.

The existing infrastructure requires that you decide at driver-stub registration
how many mappings needed, period.  Yes, we could add a flag to determine that
some mappings are to be allocated for DMA, but this does not facilitate the
*dynamic* allocation that is required.

(You and others are absolutely correct that if I only required static DMA maps
that could be gracefully handled in the driver stub and mapped 'traditionally',
but that is not the case here).

2)
Given that I need to add dynamic DMA allocation it seemed best to reuse as
much of the memory region-finding and mapping code in the UIO core.  Had I
written the whole thing in the driver stub I would have to implement another
userspace <-> kernel communication mechanism and I'd have to copy and paste
a lot of the UIO cores mmap functionality and would lose the default handling
of the traditional static mappings.

3)
By implementing this in the UIO core other folks who need such capability in
the future can do so without duplicating this effort.

4)
I'm using the same driver stub to control several different 'devices', not all
of which have DMA.  These devices can change configuration on the fly via FPGA
download.  I am trying to keep as much of the device logic in userspace
as possible.


>> -#define MAX_UIO_MAPS 5
>> +/* Increased to accomodate many logical memory regions per BAR. */
>> +#define MAX_UIO_MAPS 100
>
> Isn't 100 a bit much? Note that uio_info.mem[] is an array with this size.
>

Yes, 100 is overkill.  I'm using 2 bars with potentially 20 mappings
each to logically
separate functionality.  I got 100 by scaling this to more 5 BARs.
But 40 would be sufficient for my purposes.

Would you agree the 'best' way to do this would be eliminate the
static list, pass in a size,
and use the linked-list-based search for both DMA and static maps.


>> +     /*
>> +      * Always register 'maps' even if there are no static
>> +      * memory regions so it's ready for dynamic DMA maps
>> +      */
>
> That's a change to an existing userspace API. It would be better if the
> driver already fills a mem[] struct and maybe marks it with a flag.
> After all, each driver has to decide whether it wants to offer DMA
> memory or not.

As commented above, the driver stub does not actually determine how much
DMA memory is required.

>> +             /* Iterate thru looking for entry in which vm_pgoff matches
>> +              * index. Yes, this is slow, but it's only for test & debug
>> +              * access anyway.
>> +              */
>> +             list_for_each_entry(umem, &idev->info->dma_mem, list) {
>> +                     if (umem->index == vma->vm_pgoff)
>> +                             return umem;
>
> Huh? It's for any access to DMA memory, isn't it?
>

The 'normal' way to use the the DMA region is to call mmap with the magic number
and just go ahead and use the returned region.  The beauty of overloading mmap
is you get immediate O(1) access to the memory.  If memory were statically
mapped by the driver stub one would have to search for each region.

You can still use the search-for-index technique but this is O(N^2) and won't
scale well to the thousands of regions I need.  You'd only need to access the
sysfs and do the search-by-index approach if you needed multiple processes to
access the same DMA region.  (For example, a debug process or command
line tool).


>> +static int uio_mem_create_dma_region(struct uio_mem **umem,
>> +                                  unsigned long size,
>> +                                  struct uio_device *idev)
>
> If you exported this function, a UIO driver could use it to setup
> its mem struct. Looks cleaner to me.
>

Exporting this might prove useful to other driver-stub writers and this is
a valid suggestion, but exporting this isn't sufficient

>> +{
>> +     int ret = 0;
>> +     unsigned long *addr;
>> +
>> +     *umem = kzalloc(sizeof(struct uio_mem), GFP_KERNEL);
>> +     if (!*umem) {
>> +             dev_err(idev->dev,
>> +                     "Unable to allocate uio_mem structure.\n");
>> +             return -ENOMEM;
>> +     }
>> +
>> +     /* Allocate DMA-capable buffer */
>> +     addr = dma_alloc_coherent(idev->dev->parent, size,
>> +                     (dma_addr_t *) &(*umem)->internal_addr,
>> +                     GFP_KERNEL);
>> +     if (!addr) {
>> +             dev_warn(idev->dev, "Unable to allocate requested DMA-capable"
>> +                     " block of size 0x%lx (%lu) during mmap in uio.\n",
>> +                     size, size);
>> +             ret = -ENOMEM;
>> +             goto err_free_umem;
>> +     }
>> +
>> +     /* Store the physical address and index as the
>> +      * first two long words for userspace access */
>> +     (*umem)->addr = (unsigned long) addr;
>> +     addr[0] = (unsigned long) (*umem)->internal_addr;
>> +     (*umem)->memtype = UIO_MEM_LOGICAL;
>> +     (*umem)->size = size;
>> +     (*umem)->index = idev->info->dma_mem_size + UIO_DMA_MEM_BASE_INDEX;
>> +     addr[1] = (unsigned long) (*umem)->index;
>> +
>> +     /* Register the mapping in sysfs */
>> +     ret = uio_mem_add_attribute(idev, *umem);
>> +     if (ret) {
>> +             dev_err(idev->dev, "Unable to register sysfs entry for "
>> +                             "DMA mapping (%d) in uio.\n", ret);
>> +             goto err_free_addr;
>> +     }
>> +
>> +     idev->info->dma_mem_size++;
>> +     list_add_tail(&((*umem)->list), &(idev->info->dma_mem));
>> +
>> +     return 0;
>> +
>> +err_free_addr:
>> +     dma_free_coherent(idev->dev->parent, size, addr,
>> +                     (dma_addr_t) (*umem)->internal_addr);
>> +err_free_umem:
>> +     kfree(*umem);
>> +     *umem = 0;
>> +     return ret;
>> +}
>> +
>> +/**
>> + * uio_mem_destroy_dma_region - destroy dynamically created DMA region
>> + * @umem:      UIO memory region to destroy
>> + * @idev:      the UIO device this region belongs to
>> + *
>> + */
>> +static void uio_mem_destroy_dma_region(struct uio_mem *umem,
>> +                                    struct uio_device *idev)
>> +{
>> +     /* Remove sysfs attributes */
>> +     struct uio_map *map = umem->map;
>> +     kobject_put(&map->kobj);
>> +
>> +     /* Free the buffer itself */
>> +     dma_free_coherent(idev->dev->parent, umem->size, (void *) umem->addr,
>> +                     (dma_addr_t) umem->internal_addr);
>> +     list_del(&(umem->list));
>> +
>> +     kfree(umem);
>> +}
>> +
>>  static int uio_mmap(struct file *filep, struct vm_area_struct *vma)
>>  {
>>       struct uio_listener *listener = filep->private_data;
>>       struct uio_device *idev = listener->dev;
>> -     int mi;
>> +     struct uio_mem *umem = 0;
>>       unsigned long requested_pages, actual_pages;
>> +     unsigned long requested_size;
>>       int ret = 0;
>>
>>       if (vma->vm_end < vma->vm_start)
>> @@ -556,12 +690,24 @@ static int uio_mmap(struct file *filep,
>>
>>       vma->vm_private_data = idev;
>>
>> -     mi = uio_find_mem_index(vma);
>> -     if (mi < 0)
>> -             return -EINVAL;
>> +     requested_size = vma->vm_end - vma->vm_start;
>> +     requested_pages = requested_size >> PAGE_SHIFT;
>> +
>> +     if (vma->vm_pgoff == UIO_DMA_MEM_ALLOCATE_VM_PGOFF_MAGIC) {
>
> If you had a flag like I suggested above, this could be handled much
> simpler. Something like
>
> if (vma->vm_pgoff & UIO_DMA_MEM_FLAG)
>        vma->vm_pgoff &= UIO_MEM_INDEX_MASK;
>
>
>> +             /* Create a memory region and change
>> +              * vm_pgoff to the newly created index */
>> +             ret = uio_mem_create_dma_region(&umem, requested_size, idev);
>> +             if (ret)
>> +                     return ret;
>> +
>> +             vma->vm_pgoff = umem->index;
>
> Then you wouldn't need this index.
>
>> +     } else {
>> +             umem = uio_find_mem_region(vma);
>> +             if (!umem)
>> +                     return -EINVAL;
>> +     }
>>
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
