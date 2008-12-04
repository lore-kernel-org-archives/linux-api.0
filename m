From: "Edward Estabrook" <edward.estabrook.lkml-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/1] Userspace I/O (UIO): Documentatin for userspace DMA support
Date: Wed, 3 Dec 2008 20:53:27 -0800
Message-ID: <208aa0f00812032053w5efb99dbk94511b0f8c1f0925@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Greg KH <gregkh-l3A5Bk7waGM@public.gmane.org>, hjk-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, edward_estabrook-+2HdxjxtzLdBDgjK7y7TUQ@public.gmane.org
List-Id: linux-api@vger.kernel.org

From: Edward Estabrook <Edward_Estabrook-+2HdxjxtzLdBDgjK7y7TUQ@public.gmane.org>

Here is a patch updating the Userspace IO documentation to
detail support to dynamically allocate and use coherent DMA
from userspace.  This patch applies against 2.6.28-rc6.

The gist of this implementation is to overload uio's mmap
functionality to allocate
and map a new DMA region on demand.  The bus-specific DMA address as returned by
dma_alloc_coherent() is made available to userspace in the 1st long
word of the newly
created region (as well as through the conventional 'addr' file in sysfs).

The kernel-api change is that passing an offset value of 0xFFFFF000UL to a uio
device's mmap() operation will dynamically allocate a DMA region.  This cannot
break existing code as the previous UIO code only allowed a maximum of 5
mappings.

To allocate a DMA region you use the following:
/* Pass this magic number to mmap as offset to
 * dynamically allocate a chunk of memory */
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
--- linux-2.6.28-rc6/Documentation/DocBook/uio-howto.tmpl.orig	2008-12-03
12:03:43.000000000 -0800
+++ linux-2.6.28-rc6/Documentation/DocBook/uio-howto.tmpl	2008-12-03
13:11:53.000000000 -0800
@@ -42,6 +42,12 @@ GPL version 2.

 <revhistory>
 	<revision>
+	<revnumber>0.6</revnumber>
+	<date>2008-12-03</date>
+	<authorinitials>ee</authorinitials>
+	<revremark>Added description of DMA control.</revremark>
+	</revision>
+	<revision>
 	<revnumber>0.5</revnumber>
 	<date>2008-05-22</date>
 	<authorinitials>hjk</authorinitials>
@@ -284,11 +290,17 @@ interested in translating it, please ema
 	require access to more than one PCI memory region in a driver.
 </para>
 <para>
+	Each UIO device can also dynamically allocate coherent DMA
+	memory regions and map these to userspace.  Once created they
+	can be mapped like any other UIO memory region.
+</para>
+<para>
 	Each mapping has its own directory in sysfs, the first mapping
 	appears as <filename>/sys/class/uio/uioX/maps/map0/</filename>.
 	Subsequent mappings create directories <filename>map1/</filename>,
-	<filename>map2/</filename>, and so on. These directories will only
-	appear if the size of the mapping is not 0.
+	<filename>map2/</filename>, and so on. These directories will
+	appear even if the size of the mapping is 0 to accommodate dynamically
+	created DMA mappings.
 </para>
 <para>
 	Each <filename>mapX/</filename> directory contains two read-only files
@@ -318,6 +330,24 @@ interested in translating it, please ema
 offset = N * getpagesize();
 </programlisting>

+<para>
+	From userspace a DMA region may be dynamically allocated and mapped
+	via the <function>mmap()</function> call by specifying the size of the
+	region in bytes in the <varname>length</varname> parameter and setting
+	<varname>offset = 0xFFFFF000</varname>.
+</para>
+<para>
+	The bus-specific DMA address as required to configure hardware DMA
+	registers will be stored in the first long word of the resulting mapped
+	region.
+</para>
+<programlisting format="linespecific">
+#define DMA_MEM_ALLOCATE_MMAP_OFFSET 0xFFFFF000UL
+void* memory = mmap (NULL, size, PROT_READ | PROT_WRITE , MAP_SHARED,
+		     fd, DMA_MEM_ALLOCATE_MMAP_OFFSET);
+u_int64_t *addr = *(u_int64_t *) memory;
+</programlisting>
+
 </sect1>
 </chapter>

@@ -572,6 +602,50 @@ to set up sysfs files for this mapping.
 	</para>
 </sect1>

+<sect1 id="dma_region_mmap">
+<title>Allocating DMA region with mmap()</title>
+	<para>
+	To allocate and map a DMA memory region you use
+	use <function>mmap()</function>.  You may create as
+	many regions as system resources allow by repeated use of
+	<function>mmap()</function>.
+	</para>
+	<para>
+	Specify the size of the desired region, in bytes, in the
+	<varname>length</varname> parameter and set
+	<varname>offset = 0xFFFFF000</varname>.  The region size will
+	be rounded up to a multiple of page size to ensure proper
+	alignment.
+	</para>
+	<para>
+	The bus-specific DMA address is stored in the first long word of the
+	resulting mapped region.  The newly assigned memory index N is
+	returned in the second long word of the resulting mapped region.  This
+	index is only required if the userspace driver needs to unmap and
+	then later remap the DMA region as the single call to
+	<function>mmap()</function> is sufficient to both allocate and map the
+	region.
+	</para>
+	<para>
+	Since every memory mapping has its own directory in sysfs
+	<filename>/sys/class/uio/uioX/maps/mapN/</filename> will be created
+	where N is the dynamically generated index of the mapping just
+	allocated.
+	</para>
+	<para>
+	Dynamically allocated DMA regions remain available for use
+	until <function>uio_unregister_device()</function> is called, at
+	which point the memory is released.
+	</para>
+<programlisting format="linespecific">
+	#define DMA_MEM_ALLOCATE_MMAP_OFFSET 0xFFFFF000UL
+	void* memory = mmap (NULL, size, PROT_READ | PROT_WRITE , MAP_SHARED,
+			     fd, DMA_MEM_ALLOCATE_MMAP_OFFSET);
+	u_int64_t *addr = *(u_int64_t *) memory;
+</programlisting>
+
+</sect1>
+
 <sect1 id="wait_for_interrupts">
 <title>Waiting for interrupts</title>
 	<para>
@@ -583,7 +657,7 @@ to set up sysfs files for this mapping.
 	attention because an error occured.
 	</para>
 	<para>
-	<filename>/dev/uioX</filename> is a read-only file. A
+	<filename>/dev/uioX</filename> is a read-write file. A
 	<function>read()</function> will always block until an
 	interrupt occurs. There is only one legal value for the
 	<varname>count</varname> parameter of
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
