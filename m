From: "Edward Estabrook" <edward.estabrook.lkml-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/1] Userspace I/O (UIO): Add support for userspace DMA (corrected)
Date: Wed, 3 Dec 2008 17:51:30 -0800
Message-ID: <208aa0f00812031751n27a75d21h8747054651639463@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hjk-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, gregkh-l3A5Bk7waGM@public.gmane.org, edward.estabrook-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, edward_estabrook-+2HdxjxtzLdBDgjK7y7TUQ@public.gmane.org
List-Id: linux-api@vger.kernel.org

From: Edward Estabrook <Edward_Estabrook-+2HdxjxtzLdBDgjK7y7TUQ@public.gmane.org>

Here is a patch that adds the ability to dynamically allocate and use
coherent DMA
from userspace by extending the Userspace IO driver.  This patch applies against
2.6.28-rc6.

The gist of this implementation is to overload uio's mmap
functionality to allocate
and map a new DMA region on demand.  The bus-specific DMA address as returned by
dma_alloc_coherent is made available to userspace in the 1st long word
of the newly
created region (as well as through the conventional 'addr' file in sysfs).

The kernel-api change is that passing an offset value of 0xFFFFF000UL
to the a uio
device's mmap operation will dynamically allocate a DMA region.  This
cannot change/
break existing behavior as the previous UIO code only allowed a maximum of 5
mappings.

To allocate a DMA region you use the following:
/* Pass this magic number to mmap as offset to dynamically allocate a
chunk of memory */
#define DMA_MEM_ALLOCATE_MMAP_OFFSET 0xFFFFF000UL

void* memory = mmap (NULL, size, PROT_READ | PROT_WRITE , MAP_SHARED,
fd, DMA_MEM_ALLOCATE_MMAP_OFFSET);
u_int64_t *addr = *(u_int64_t *) memory;

where 'size' is the size in bytes of the region you want and fd is the
opened /dev/uioN file.

Allocation occurs in page sized pieces by design to ensure that
buffers are page-aligned.

Memory is released when the uio_unregister_device() is called.

Signed-off-by: Edward Estabrook <Edward_Estabrook-+2HdxjxtzLdBDgjK7y7TUQ@public.gmane.org>
---
--- linux-2.6.28-rc6/include/linux/uio_driver.h.orig	2008-12-02
09:39:34.000000000 -0800
+++ linux-2.6.28-rc6/include/linux/uio_driver.h	2008-12-02
10:55:01.000000000 -0800
@@ -5,6 +5,7 @@
  * Copyright(C) 2005, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
  * Copyright(C) 2006, Hans J. Koch <hjk-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
  * Copyright(C) 2006, Greg Kroah-Hartman <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
+ * Copyright(C) 2008, Edward Estabrook <edward_estabrook-+2HdxjxtzLdBDgjK7y7TUQ@public.gmane.org>
  *
  * Userspace IO driver.
  *
@@ -26,7 +27,11 @@ struct uio_map;
  * @size:		size of IO
  * @memtype:		type of memory addr points to
  * @internal_addr:	ioremap-ped version of addr, for driver internal use
- * @map:		for use by the UIO core only.
+ * 			(for DMA memory regions the dma_handle is stored here)
+ * @map:		for use by the UIO core only
+ * @list:		DMA-capable buffers ; undefined if not a DMA buffer
+ * @index:		index number associated with this DMA-capable mapping
+ * 			(undefined if not a DMA buffer)
  */
 struct uio_mem {
 	unsigned long		addr;
@@ -34,9 +39,12 @@ struct uio_mem {
 	int			memtype;
 	void __iomem		*internal_addr;
 	struct uio_map		*map;
+	struct list_head	list;
+	unsigned		index;
 };

-#define MAX_UIO_MAPS	5
+/* Increased to accomodate many logical memory regions per BAR. */
+#define MAX_UIO_MAPS	100

 struct uio_device;

@@ -46,6 +54,8 @@ struct uio_device;
  * @name:		device name
  * @version:		device driver version
  * @mem:		list of mappable memory regions, size==0 for end of list
+ * @dma_mem_head	list of dynamically allocated DMA-capable memory regions
+ * @dma_mem_size	number of entries in dma_mem_head (used to speed up insertion)
  * @irq:		interrupt number or UIO_IRQ_CUSTOM
  * @irq_flags:		flags for request_irq()
  * @priv:		optional private data
@@ -60,6 +70,8 @@ struct uio_info {
 	char			*name;
 	char			*version;
 	struct uio_mem		mem[MAX_UIO_MAPS];
+	struct list_head	dma_mem;
+	unsigned		dma_mem_size;
 	long			irq;
 	unsigned long		irq_flags;
 	void			*priv;
@@ -82,6 +94,16 @@ static inline int __must_check
 extern void uio_unregister_device(struct uio_info *info);
 extern void uio_event_notify(struct uio_info *info);

+/* uio_dev_get_name - return the name associated with this uio device */
+extern char *uio_dev_get_name(struct uio_device *idev);
+
+/* Starting index assigned to dynamically allocated regions. */
+#define UIO_DMA_MEM_BASE_INDEX 1000
+
+/* mmap dynamically allocates a DMA memory block if
+ * its offset parameter matches this value. */
+#define UIO_DMA_MEM_ALLOCATE_VM_PGOFF_MAGIC 0xFFFFFUL
+
 /* defines for uio_info->irq */
 #define UIO_IRQ_CUSTOM	-1
 #define UIO_IRQ_NONE	-2
--- linux-2.6.28-rc6/drivers/uio/uio.c.orig	2008-12-03 02:01:16.000000000 -0800
+++ linux-2.6.28-rc6/drivers/uio/uio.c	2008-12-03 02:14:08.000000000 -0800
@@ -5,6 +5,7 @@
  * Copyright(C) 2005, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
  * Copyright(C) 2006, Hans J. Koch <hjk-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
  * Copyright(C) 2006, Greg Kroah-Hartman <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
+ * Copyright(C) 2008, Edward Estabrook <edward_estabrook-+2HdxjxtzLdBDgjK7y7TUQ@public.gmane.org>
  *
  * Userspace IO
  *
@@ -21,6 +22,7 @@
 #include <linux/idr.h>
 #include <linux/string.h>
 #include <linux/kobject.h>
+#include <linux/dma-mapping.h>
 #include <linux/uio_driver.h>

 #define UIO_MAX_DEVICES 255
@@ -62,7 +64,10 @@ struct uio_map {

 static ssize_t map_addr_show(struct uio_mem *mem, char *buf)
 {
-	return sprintf(buf, "0x%lx\n", mem->addr);
+	if (mem->index < UIO_DMA_MEM_BASE_INDEX)
+		return sprintf(buf, "0x%lx\n", mem->addr);
+	else
+		return sprintf(buf, "0x%p\n", mem->internal_addr);
 }

 static ssize_t map_size_show(struct uio_mem *mem, char *buf)
@@ -171,14 +176,38 @@ static struct attribute_group uio_attr_g
 	.attrs = uio_attrs,
 };

+static int uio_mem_add_attribute(struct uio_device *idev, struct uio_mem *umem)
+{
+	struct uio_map *map = kzalloc(sizeof(*map), GFP_KERNEL);
+	int ret = 0;
+	if (!map)
+		return -ENOMEM;
+
+	kobject_init(&map->kobj, &map_attr_type);
+	map->mem = umem;
+	umem->map = map;
+	ret = kobject_add(&map->kobj, idev->map_dir, "map%d", umem->index);
+	if (ret)
+		return ret;
+	return kobject_uevent(&map->kobj, KOBJ_ADD);
+}
+
+
 /*
  * device functions
  */
+
+/* uio_dev_get_name - return the name associated with this uio device */
+char *uio_dev_get_name(struct uio_device *idev)
+{
+	return idev->dev->bus_id;
+}
+EXPORT_SYMBOL_GPL(uio_dev_get_name);
+
 static int uio_dev_add_attributes(struct uio_device *idev)
 {
 	int ret;
 	int mi;
-	int map_found = 0;
 	struct uio_mem *mem;
 	struct uio_map *map;

@@ -186,27 +215,21 @@ static int uio_dev_add_attributes(struct
 	if (ret)
 		goto err_group;

+	/*
+	 * Always register 'maps' even if there are no static
+	 * memory regions so it's ready for dynamic DMA maps
+	 */
+	idev->map_dir = kobject_create_and_add("maps", &idev->dev->kobj);
+	if (!idev->map_dir)
+		goto err_remove_group;
+
 	for (mi = 0; mi < MAX_UIO_MAPS; mi++) {
 		mem = &idev->info->mem[mi];
 		if (mem->size == 0)
 			break;
-		if (!map_found) {
-			map_found = 1;
-			idev->map_dir = kobject_create_and_add("maps",
-							&idev->dev->kobj);
-			if (!idev->map_dir)
-				goto err;
-		}
-		map = kzalloc(sizeof(*map), GFP_KERNEL);
-		if (!map)
-			goto err;
-		kobject_init(&map->kobj, &map_attr_type);
-		map->mem = mem;
-		mem->map = map;
-		ret = kobject_add(&map->kobj, idev->map_dir, "map%d", mi);
-		if (ret)
-			goto err;
-		ret = kobject_uevent(&map->kobj, KOBJ_ADD);
+		mem->index = mi;
+
+		ret = uio_mem_add_attribute(idev, mem);
 		if (ret)
 			goto err;
 	}
@@ -214,12 +237,13 @@ static int uio_dev_add_attributes(struct
 	return 0;

 err:
-	for (mi--; mi>=0; mi--) {
+	for (mi--; mi >= 0; mi--) {
 		mem = &idev->info->mem[mi];
 		map = mem->map;
 		kobject_put(&map->kobj);
 	}
 	kobject_put(idev->map_dir);
+err_remove_group:
 	sysfs_remove_group(&idev->dev->kobj, &uio_attr_grp);
 err_group:
 	dev_err(idev->dev, "error creating sysfs files (%d)\n", ret);
@@ -230,12 +254,16 @@ static void uio_dev_del_attributes(struc
 {
 	int mi;
 	struct uio_mem *mem;
+
+	/* Unregister static maps */
 	for (mi = 0; mi < MAX_UIO_MAPS; mi++) {
 		mem = &idev->info->mem[mi];
 		if (mem->size == 0)
 			break;
 		kobject_put(&mem->map->kobj);
 	}
+
+	/* Unregister containers */
 	kobject_put(idev->map_dir);
 	sysfs_remove_group(&idev->dev->kobj, &uio_attr_grp);
 }
@@ -459,18 +487,39 @@ static ssize_t uio_write(struct file *fi
 	return retval ? retval : sizeof(s32);
 }

-static int uio_find_mem_index(struct vm_area_struct *vma)
+
+/**
+ * uio_find_mem_region - return the memory region identified by vm->vm_pgoff
+ * @vma: vma descriptor as passed to mmap.
+ *
+ * returns memory region from either mem array or dma_mem list.
+ */
+static struct uio_mem *uio_find_mem_region(struct vm_area_struct *vma)
 {
-	int mi;
 	struct uio_device *idev = vma->vm_private_data;
+	struct uio_mem *umem;

-	for (mi = 0; mi < MAX_UIO_MAPS; mi++) {
-		if (idev->info->mem[mi].size == 0)
-			return -1;
-		if (vma->vm_pgoff == mi)
-			return mi;
+
+	if (vma->vm_pgoff < UIO_DMA_MEM_BASE_INDEX) {
+		if (vma->vm_pgoff < MAX_UIO_MAPS
+				&& idev->info->mem[vma->vm_pgoff].size != 0)
+			return &(idev->info->mem[vma->vm_pgoff]);
+	} else {
+		if (vma->vm_pgoff >= idev->info->dma_mem_size
+				+ UIO_DMA_MEM_BASE_INDEX)
+			return 0; /* Too big: fail automatically */
+
+		/* Iterate thru looking for entry in which vm_pgoff matches
+		 * index. Yes, this is slow, but it's only for test & debug
+		 * access anyway.
+		 */
+		list_for_each_entry(umem, &idev->info->dma_mem, list) {
+			if (umem->index == vma->vm_pgoff)
+				return umem;
+		}
 	}
-	return -1;
+
+	return 0;
 }

 static void uio_vma_open(struct vm_area_struct *vma)
@@ -487,25 +536,24 @@ static void uio_vma_close(struct vm_area

 static int uio_vma_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
-	struct uio_device *idev = vma->vm_private_data;
 	struct page *page;
 	unsigned long offset;

-	int mi = uio_find_mem_index(vma);
-	if (mi < 0)
+	struct uio_mem *umem = uio_find_mem_region(vma);
+	if (!umem)
 		return VM_FAULT_SIGBUS;

 	/*
 	 * We need to subtract mi because userspace uses offset = N*PAGE_SIZE
 	 * to use mem[N].
 	 */
-	offset = (vmf->pgoff - mi) << PAGE_SHIFT;
+	offset = (vmf->pgoff - umem->index) << PAGE_SHIFT;

-	if (idev->info->mem[mi].memtype == UIO_MEM_LOGICAL)
-		page = virt_to_page(idev->info->mem[mi].addr + offset);
+	if (umem->memtype == UIO_MEM_LOGICAL)
+		page = virt_to_page(umem->addr + offset);
 	else
-		page = vmalloc_to_page((void *)idev->info->mem[mi].addr
-							+ offset);
+		page = vmalloc_to_page((void *)umem->addr + offset);
+
 	get_page(page);
 	vmf->page = page;
 	return 0;
@@ -519,9 +567,8 @@ static struct vm_operations_struct uio_v

 static int uio_mmap_physical(struct vm_area_struct *vma)
 {
-	struct uio_device *idev = vma->vm_private_data;
-	int mi = uio_find_mem_index(vma);
-	if (mi < 0)
+	struct uio_mem *umem = uio_find_mem_region(vma);
+	if (!umem)
 		return -EINVAL;

 	vma->vm_flags |= VM_IO | VM_RESERVED;
@@ -530,7 +577,7 @@ static int uio_mmap_physical(struct vm_a

 	return remap_pfn_range(vma,
 			       vma->vm_start,
-			       idev->info->mem[mi].addr >> PAGE_SHIFT,
+			       umem->addr >> PAGE_SHIFT,
 			       vma->vm_end - vma->vm_start,
 			       vma->vm_page_prot);
 }
@@ -543,12 +590,99 @@ static int uio_mmap_logical(struct vm_ar
 	return 0;
 }

+/**
+ * uio_mem_create_dma_region - allocate a DMA region of size bytes
+ * @umem:     the newly allocated uio_mem structure is returned here
+ * @size:     the number of bytes to allocate
+ * @idev:     the UIO device this region belongs to
+ *
+ * return 0 if success or negative error code on failure
+ */
+static int uio_mem_create_dma_region(struct uio_mem **umem,
+				     unsigned long size,
+				     struct uio_device *idev)
+{
+	int ret = 0;
+	unsigned long *addr;
+
+	*umem = kzalloc(sizeof(struct uio_mem), GFP_KERNEL);
+	if (!*umem) {
+		dev_err(idev->dev,
+			"Unable to allocate uio_mem structure.\n");
+		return -ENOMEM;
+	}
+
+	/* Allocate DMA-capable buffer */
+	addr = dma_alloc_coherent(idev->dev->parent, size,
+			(dma_addr_t *) &(*umem)->internal_addr,
+			GFP_KERNEL);
+	if (!addr) {
+		dev_warn(idev->dev, "Unable to allocate requested DMA-capable"
+			" block of size 0x%lx (%lu) during mmap in uio.\n",
+			size, size);
+		ret = -ENOMEM;
+		goto err_free_umem;
+	}
+
+	/* Store the physical address and index as the
+	 * first two long words for userspace access */
+	(*umem)->addr = (unsigned long) addr;
+	addr[0] = (unsigned long) (*umem)->internal_addr;
+	(*umem)->memtype = UIO_MEM_LOGICAL;
+	(*umem)->size = size;
+	(*umem)->index = idev->info->dma_mem_size + UIO_DMA_MEM_BASE_INDEX;
+	addr[1] = (unsigned long) (*umem)->index;
+
+	/* Register the mapping in sysfs */
+	ret = uio_mem_add_attribute(idev, *umem);
+	if (ret) {
+		dev_err(idev->dev, "Unable to register sysfs entry for "
+				"DMA mapping (%d) in uio.\n", ret);
+		goto err_free_addr;
+	}
+
+	idev->info->dma_mem_size++;
+	list_add_tail(&((*umem)->list), &(idev->info->dma_mem));
+
+	return 0;
+
+err_free_addr:
+	dma_free_coherent(idev->dev->parent, size, addr,
+			(dma_addr_t) (*umem)->internal_addr);
+err_free_umem:
+	kfree(*umem);
+	*umem = 0;
+	return ret;
+}
+
+/**
+ * uio_mem_destroy_dma_region - destroy dynamically created DMA region
+ * @umem:      UIO memory region to destroy
+ * @idev:      the UIO device this region belongs to
+ *
+ */
+static void uio_mem_destroy_dma_region(struct uio_mem *umem,
+				       struct uio_device *idev)
+{
+	/* Remove sysfs attributes */
+	struct uio_map *map = umem->map;
+	kobject_put(&map->kobj);
+
+	/* Free the buffer itself */
+	dma_free_coherent(idev->dev->parent, umem->size, (void *) umem->addr,
+			(dma_addr_t) umem->internal_addr);
+	list_del(&(umem->list));
+
+	kfree(umem);
+}
+
 static int uio_mmap(struct file *filep, struct vm_area_struct *vma)
 {
 	struct uio_listener *listener = filep->private_data;
 	struct uio_device *idev = listener->dev;
-	int mi;
+	struct uio_mem *umem = 0;
 	unsigned long requested_pages, actual_pages;
+	unsigned long requested_size;
 	int ret = 0;

 	if (vma->vm_end < vma->vm_start)
@@ -556,12 +690,24 @@ static int uio_mmap(struct file *filep,

 	vma->vm_private_data = idev;

-	mi = uio_find_mem_index(vma);
-	if (mi < 0)
-		return -EINVAL;
+	requested_size = vma->vm_end - vma->vm_start;
+	requested_pages = requested_size >> PAGE_SHIFT;
+
+	if (vma->vm_pgoff == UIO_DMA_MEM_ALLOCATE_VM_PGOFF_MAGIC) {
+		/* Create a memory region and change
+		 * vm_pgoff to the newly created index */
+		ret = uio_mem_create_dma_region(&umem, requested_size, idev);
+		if (ret)
+			return ret;
+
+		vma->vm_pgoff = umem->index;
+	} else {
+		umem = uio_find_mem_region(vma);
+		if (!umem)
+			return -EINVAL;
+	}

-	requested_pages = (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
-	actual_pages = (idev->info->mem[mi].size + PAGE_SIZE -1) >> PAGE_SHIFT;
+	actual_pages = (umem->size + PAGE_SIZE - 1) >> PAGE_SHIFT;
 	if (requested_pages > actual_pages)
 		return -EINVAL;

@@ -570,14 +716,14 @@ static int uio_mmap(struct file *filep,
 		return ret;
 	}

-	switch (idev->info->mem[mi].memtype) {
-		case UIO_MEM_PHYS:
-			return uio_mmap_physical(vma);
-		case UIO_MEM_LOGICAL:
-		case UIO_MEM_VIRTUAL:
-			return uio_mmap_logical(vma);
-		default:
-			return -EINVAL;
+	switch (umem->memtype) {
+	case UIO_MEM_PHYS:
+		return uio_mmap_physical(vma);
+	case UIO_MEM_LOGICAL:
+	case UIO_MEM_VIRTUAL:
+		return uio_mmap_logical(vma);
+	default:
+		return -EINVAL;
 	}
 }

@@ -658,6 +804,50 @@ static void uio_class_destroy(void)
 		kref_put(&uio_class->kref, release_uio_class);
 }

+void uio_remove_all_dma_regions(struct uio_info *info)
+{
+	struct uio_mem *mem, *pos;
+
+	list_for_each_entry_safe(pos, mem, &info->dma_mem, list) {
+		uio_mem_destroy_dma_region(pos, info->uio_dev);
+	}
+}
+
+/**
+ * uio_validate_mem - ensure memory regions are page-aligned
+ * 		      and unused regions are zeroed
+ * @idev: The UIO device containing memory regions to check
+ *
+ * returns 0 on success or -EINVAL if misaligned.
+ */
+static int uio_validate_mem(struct uio_device *idev)
+{
+	int ret;
+	int mi;
+	struct uio_mem *mem;
+
+	for (mi = 0; mi < MAX_UIO_MAPS && idev->info->mem[mi].size != 0; mi++) {
+		mem = &idev->info->mem[mi];
+
+		if ((mem->addr & PAGE_MASK) != mem->addr) {
+			ret = -EINVAL;
+			goto err_misaligned;
+		}
+	}
+
+	/* zero out mem->size for unused regions for faster/safer lookup */
+	for (; mi < MAX_UIO_MAPS; mi++)
+		idev->info->mem[mi].size = 0;
+
+	return 0;
+err_misaligned:
+	dev_err(
+		idev->dev,
+		"mapable memory regions must be page-aligned (%d)\n",
+		ret);
+	return ret;
+}
+
 /**
  * uio_register_device - register a new userspace IO device
  * @owner:	module that creates the new device
@@ -677,6 +867,8 @@ int __uio_register_device(struct module
 		return -EINVAL;

 	info->uio_dev = NULL;
+	INIT_LIST_HEAD(&info->dma_mem);
+	info->dma_mem_size = 0;

 	ret = init_uio_class();
 	if (ret)
@@ -706,6 +898,10 @@ int __uio_register_device(struct module
 		goto err_device_create;
 	}

+	ret = uio_validate_mem(idev);
+	if (ret)
+		goto err_validate_mem;
+
 	ret = uio_dev_add_attributes(idev);
 	if (ret)
 		goto err_uio_dev_add_attributes;
@@ -714,7 +910,8 @@ int __uio_register_device(struct module

 	if (idev->info->irq >= 0) {
 		ret = request_irq(idev->info->irq, uio_interrupt,
-				  idev->info->irq_flags, idev->info->name, idev);
+				  idev->info->irq_flags, idev->info->name,
+				  idev);
 		if (ret)
 			goto err_request_irq;
 	}
@@ -723,6 +920,7 @@ int __uio_register_device(struct module

 err_request_irq:
 	uio_dev_del_attributes(idev);
+err_validate_mem:
 err_uio_dev_add_attributes:
 	device_destroy(uio_class->class, MKDEV(uio_major, idev->minor));
 err_device_create:
@@ -754,6 +952,8 @@ void uio_unregister_device(struct uio_in
 	if (info->irq >= 0)
 		free_irq(info->irq, idev);

+	uio_remove_all_dma_regions(info);
+
 	uio_dev_del_attributes(idev);

 	dev_set_drvdata(idev->dev, NULL);
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
