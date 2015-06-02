From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v5 10/21] pmem: Dynamically allocate partition numbers
Date: Mon, 01 Jun 2015 20:15:03 -0400
Message-ID: <20150602001503.4506.10472.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20150602001134.4506.45867.stgit@dwillia2-desk3.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150602001134.4506.45867.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-nvdimm@lists.01.org
Cc: axboe@kernel.dk, sfr@canb.auug.org.au, rafael@kernel.org, neilb@suse.de, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, mingo@kernel.org, linux-acpi@vger.kernel.org, jmoyer@redhat.com, linux-api@vger.kernel.org, akpm@linux-foundation.org, hch@lst.de
List-Id: linux-api@vger.kernel.org

=46rom: Ross Zwisler <ross.zwisler@linux.intel.com>

Dynamically allocate minor numbers for partitions instead of statically
preallocating them.

It gives us a simpler minors scheme, and makes it so we get a consisten=
t
major when moving past partition 16.  Here's what happens with the
current code:

 pmem0      249:0    0 63.5G  0 rom
 =E2=94=9C=E2=94=80pmem0p1  249:1    0    1G  0 part
 =E2=94=9C=E2=94=80pmem0p2  249:2    0    1G  0 part
 =E2=94=9C=E2=94=80pmem0p3  249:3    0    1G  0 part
 =E2=94=9C=E2=94=80pmem0p4  249:4    0    1G  0 part
 =E2=94=9C=E2=94=80pmem0p5  249:5    0    1G  0 part
 =E2=94=9C=E2=94=80pmem0p6  249:6    0    1G  0 part
 =E2=94=9C=E2=94=80pmem0p7  249:7    0    1G  0 part
 =E2=94=9C=E2=94=80pmem0p8  249:8    0    1G  0 part
 =E2=94=9C=E2=94=80pmem0p9  249:9    0    1G  0 part
 =E2=94=9C=E2=94=80pmem0p10 249:10   0    1G  0 part
 =E2=94=9C=E2=94=80pmem0p11 249:11   0    1G  0 part
 =E2=94=9C=E2=94=80pmem0p12 249:12   0    1G  0 part
 =E2=94=9C=E2=94=80pmem0p13 249:13   0    1G  0 part
 =E2=94=9C=E2=94=80pmem0p14 249:14   0    1G  0 part
 =E2=94=9C=E2=94=80pmem0p15 249:15   0    1G  0 part
 =E2=94=9C=E2=94=80pmem0p16 259:0    0    1G  0 part
 =E2=94=9C=E2=94=80pmem0p17 259:1    0    1G  0 part
 =E2=94=94=E2=94=80pmem0p18 259:2    0    1G  0 part

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/pmem.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index cf5d53eda9e5..0842d27ffc8d 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -26,8 +26,6 @@
 #include <linux/nd.h>
 #include "nd.h"
=20
-#define PMEM_MINORS		16
-
 struct pmem_device {
 	struct request_queue	*pmem_queue;
 	struct gendisk		*pmem_disk;
@@ -156,12 +154,12 @@ static struct pmem_device *pmem_alloc(struct devi=
ce *dev, struct resource *res,
 	blk_queue_max_hw_sectors(pmem->pmem_queue, 1024);
 	blk_queue_bounce_limit(pmem->pmem_queue, BLK_BOUNCE_ANY);
=20
-	disk =3D alloc_disk(PMEM_MINORS);
+	disk =3D alloc_disk(0);
 	if (!disk)
 		goto out_free_queue;
=20
 	disk->major		=3D pmem_major;
-	disk->first_minor	=3D PMEM_MINORS * id;
+	disk->first_minor	=3D 0;
 	disk->fops		=3D &pmem_fops;
 	disk->private_data	=3D pmem;
 	disk->queue		=3D pmem->pmem_queue;
