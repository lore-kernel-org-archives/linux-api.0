From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org>
Subject: [PATCH v28 02/12] LRNG - allocate one DRNG instance per NUMA node
Date: Wed, 15 Jan 2020 11:32:08 +0100
Message-ID: <3553236.0cWSpR5WBQ@positron.chronox.de>
References: <6157374.ptSnyUpaCn@positron.chronox.de> <2641155.iNH938UiKq@positron.chronox.de> <5951792.lmNsirYsPE@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5951792.lmNsirYsPE-jJGQKZiSfeo1haGO/jJMPxvVK+yQ3ZXh@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, "Alexander E. Patrakov" <patrakov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Ahmed S. Darwish" <darwish.07-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Theodore Y. Ts'o" <tytso-3s7WtUTddSA@public.gmane.org>, Willy Tarreau <w@1wt.eu>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Vito Caputo <vcaputo-IiWei5kqaphBDgjK7y7TUQ@public.gmane.org>, Andreas Dilger <adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Ray Strode <rstrode-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, William Jon McCann <mccann-4GNroTWusrE@public.gmane.org>, zhangjs <zachary-+jQ8zvd9CV5SzTKKI/wJ2A@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Florian Weimer <fweimer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Lennart Poettering <mzxreary-uLTowLwuiw4b1SvskN2V4Q@public.gmane.org>, Nicolai Stange <nstange-l3A5Bk7waGM@public.gmane.org>, "Peter, Matthias" <matth>
List-Id: linux-api@vger.kernel.org

In order to improve NUMA-locality when serving getrandom(2) requests,
allocate one DRNG instance per node.

The DRNG instance that is present right from the start of the kernel is
reused as the first per-NUMA-node DRNG. For all remaining online NUMA
nodes a new DRNG instance is allocated.

During boot time, the multiple DRNG instances are seeded sequentially.
With this, the first DRNG instance (referenced as the initial DRNG
in the code) is completely seeded with 256 bits of entropy before the
next DRNG instance is completely seeded.

When random numbers are requested, the NUMA-node-local DRNG is checked
whether it has been already fully seeded. If this is not the case, the
initial DRNG is used to serve the request.

CC: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
CC: "Alexander E. Patrakov" <patrakov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
CC: "Ahmed S. Darwish" <darwish.07-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
CC: "Theodore Y. Ts'o" <tytso-3s7WtUTddSA@public.gmane.org>
CC: Willy Tarreau <w@1wt.eu>
CC: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
CC: Vito Caputo <vcaputo-IiWei5kqaphBDgjK7y7TUQ@public.gmane.org>
CC: Andreas Dilger <adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>
CC: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
CC: Ray Strode <rstrode-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
CC: William Jon McCann <mccann-4GNroTWusrE@public.gmane.org>
CC: zhangjs <zachary-+jQ8zvd9CV5SzTKKI/wJ2A@public.gmane.org>
CC: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
CC: Florian Weimer <fweimer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
CC: Lennart Poettering <mzxreary-uLTowLwuiw4b1SvskN2V4Q@public.gmane.org>
CC: Nicolai Stange <nstange-l3A5Bk7waGM@public.gmane.org>
Reviewed-by: Marcelo Henrique Cerri <marcelo.cerri-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Reviewed-by: Roman Drahtmueller <draht-UTA6Eu5RHcbyVfKhlJ+g5A@public.gmane.org>
Tested-by: Roman Drahtm=FCller <draht-UTA6Eu5RHcbyVfKhlJ+g5A@public.gmane.org>
Tested-by: Marcelo Henrique Cerri <marcelo.cerri-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Tested-by: Neil Horman <nhorman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Stephan Mueller <smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org>
=2D--
 drivers/char/lrng/Makefile        |   2 +
 drivers/char/lrng/lrng_internal.h |   5 ++
 drivers/char/lrng/lrng_numa.c     | 101 ++++++++++++++++++++++++++++++
 3 files changed, 108 insertions(+)
 create mode 100644 drivers/char/lrng/lrng_numa.c

diff --git a/drivers/char/lrng/Makefile b/drivers/char/lrng/Makefile
index 1d2a0211973d..0a32f22c2c1a 100644
=2D-- a/drivers/char/lrng/Makefile
+++ b/drivers/char/lrng/Makefile
@@ -7,3 +7,5 @@ obj-y				+=3D lrng_pool.o lrng_aux.o \
 				   lrng_sw_noise.o lrng_archrandom.o \
 				   lrng_drng.o lrng_chacha20.o \
 				   lrng_interfaces.o \
+
+obj-$(CONFIG_NUMA)		+=3D lrng_numa.o
diff --git a/drivers/char/lrng/lrng_internal.h b/drivers/char/lrng/lrng_int=
ernal.h
index edf38121ec65..ecb0a7ad5e7e 100644
=2D-- a/drivers/char/lrng/lrng_internal.h
+++ b/drivers/char/lrng/lrng_internal.h
@@ -246,8 +246,13 @@ int lrng_drng_get_sleep(u8 *outbuf, u32 outbuflen);
 void lrng_drng_force_reseed(void);
 void lrng_drng_seed_work(struct work_struct *dummy);
=20
+#ifdef CONFIG_NUMA
+struct lrng_drng **lrng_drng_instances(void);
+void lrng_drngs_numa_alloc(void);
+#else	/* CONFIG_NUMA */
 static inline struct lrng_drng **lrng_drng_instances(void) { return NULL; }
 static inline void lrng_drngs_numa_alloc(void) { return; }
+#endif /* CONFIG_NUMA */
=20
 /************************** Health Test linking code *********************=
*****/
=20
diff --git a/drivers/char/lrng/lrng_numa.c b/drivers/char/lrng/lrng_numa.c
new file mode 100644
index 000000000000..947c5b3ed517
=2D-- /dev/null
+++ b/drivers/char/lrng/lrng_numa.c
@@ -0,0 +1,101 @@
+// SPDX-License-Identifier: GPL-2.0 OR BSD-2-Clause
+/*
+ * LRNG NUMA support
+ *
+ * Copyright (C) 2016 - 2020, Stephan Mueller <smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org>
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/lrng.h>
+#include <linux/slab.h>
+
+#include "lrng_internal.h"
+
+static struct lrng_drng **lrng_drng __read_mostly =3D NULL;
+
+struct lrng_drng **lrng_drng_instances(void)
+{
+	return lrng_drng;
+}
+
+/* Allocate the data structures for the per-NUMA node DRNGs */
+static void _lrng_drngs_numa_alloc(struct work_struct *work)
+{
+	struct lrng_drng **drngs;
+	struct lrng_drng *lrng_drng_init =3D lrng_drng_init_instance();
+	u32 node;
+	bool init_drng_used =3D false;
+
+	mutex_lock(&lrng_crypto_cb_update);
+
+	/* per-NUMA-node DRNGs are already present */
+	if (lrng_drng)
+		goto unlock;
+
+	drngs =3D kcalloc(nr_node_ids, sizeof(void *), GFP_KERNEL|__GFP_NOFAIL);
+	for_each_online_node(node) {
+		struct lrng_drng *drng;
+
+		if (!init_drng_used) {
+			drngs[node] =3D lrng_drng_init;
+			init_drng_used =3D true;
+			continue;
+		}
+
+		drng =3D kmalloc_node(sizeof(struct lrng_drng),
+				     GFP_KERNEL|__GFP_NOFAIL, node);
+		memset(drng, 0, sizeof(lrng_drng));
+
+		drng->crypto_cb =3D lrng_drng_init->crypto_cb;
+		drng->drng =3D drng->crypto_cb->lrng_drng_alloc(
+					LRNG_DRNG_SECURITY_STRENGTH_BYTES);
+		if (IS_ERR(drng->drng)) {
+			kfree(drng);
+			goto err;
+		}
+
+		mutex_init(&drng->lock);
+		spin_lock_init(&drng->spin_lock);
+
+		/*
+		 * No reseeding of NUMA DRNGs from previous DRNGs as this
+		 * would complicate the code. Let it simply reseed.
+		 */
+		lrng_drng_reset(drng);
+		drngs[node] =3D drng;
+
+		lrng_pool_inc_numa_node();
+		pr_info("DRNG for NUMA node %d allocated\n", node);
+	}
+
+	/* Ensure that all NUMA nodes receive changed memory here. */
+	mb();
+
+	if (!cmpxchg(&lrng_drng, NULL, drngs))
+		goto unlock;
+
+err:
+	for_each_online_node(node) {
+		struct lrng_drng *drng =3D drngs[node];
+
+		if (drng =3D=3D lrng_drng_init)
+			continue;
+
+		if (drng) {
+			drng->crypto_cb->lrng_drng_dealloc(drng->drng);
+			kfree(drng);
+		}
+	}
+	kfree(drngs);
+
+unlock:
+	mutex_unlock(&lrng_crypto_cb_update);
+}
+
+static DECLARE_WORK(lrng_drngs_numa_alloc_work, _lrng_drngs_numa_alloc);
+
+void lrng_drngs_numa_alloc(void)
+{
+	schedule_work(&lrng_drngs_numa_alloc_work);
+}
=2D-=20
2.24.1
