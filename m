From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org>
Subject: [PATCH v28 04/12] LRNG - add switchable DRNG support
Date: Wed, 15 Jan 2020 11:32:55 +0100
Message-ID: <18210082.uQRsEe3XHB@positron.chronox.de>
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

The DRNG switch support allows replacing the DRNG mechanism of the
LRNG. The switching support rests on the interface definition of
include/linux/lrng.h. A new DRNG is implemented by filling in the
interface defined in this header file.

In addition to the DRNG, the extension also has to provide a hash
implementation that is used to hash the entropy pool for random number
extraction.

Note: It is permissible to implement a DRNG whose operations may sleep.
However, the hash function must not sleep.

The switchable DRNG support allows replacing the DRNG at runtime.
However, only one DRNG extension is allowed to be loaded at any given
time. Before replacing it with another DRNG implementation, the possibly
existing DRNG extension must be unloaded.

The switchable DRNG extension activates the new DRNG during load time.
It is expected, however, that such a DRNG switch would be done only once
by an administrator to load the intended DRNG implementation.

It is permissible to compile DRNG extensions either as kernel modules or
statically. The initialization of the DRNG extension should be performed
with a late_initcall to ensure the extension is available when user
space starts but after all other initialization completed.
The initialization is performed by registering the function call data
structure with the lrng_set_drng_cb function. In order to unload the
DRNG extension, lrng_set_drng_cb must be invoked with the NULL
parameter.

The DRNG extension should always provide a security strength that is at
least as strong as LRNG_DRNG_SECURITY_STRENGTH_BITS.

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
 drivers/char/lrng/Kconfig       |   7 ++
 drivers/char/lrng/Makefile      |   1 +
 drivers/char/lrng/lrng_switch.c | 183 ++++++++++++++++++++++++++++++++
 3 files changed, 191 insertions(+)
 create mode 100644 drivers/char/lrng/lrng_switch.c

diff --git a/drivers/char/lrng/Kconfig b/drivers/char/lrng/Kconfig
index 56f13efd3592..cb701bb0b8b6 100644
=2D-- a/drivers/char/lrng/Kconfig
+++ b/drivers/char/lrng/Kconfig
@@ -64,4 +64,11 @@ config LRNG_POOL_SIZE
 	default 7 if LRNG_POOL_SIZE_65536
 	default 8 if LRNG_POOL_SIZE_131072
=20
+menuconfig LRNG_DRNG_SWITCH
+	bool "Support DRNG runtime switching"
+	help
+	  The Linux RNG per default uses a ChaCha20 DRNG that is
+	  accessible via the external interfaces. With this configuration
+	  option other DRNGs can be selected and loaded at runtime.
+
 endif # LRNG
diff --git a/drivers/char/lrng/Makefile b/drivers/char/lrng/Makefile
index e69c176f0161..31cfe87c999e 100644
=2D-- a/drivers/char/lrng/Makefile
+++ b/drivers/char/lrng/Makefile
@@ -10,3 +10,4 @@ obj-y				+=3D lrng_pool.o lrng_aux.o \
=20
 obj-$(CONFIG_NUMA)		+=3D lrng_numa.o
 obj-$(CONFIG_SYSCTL)		+=3D lrng_proc.o
+obj-$(CONFIG_LRNG_DRNG_SWITCH)	+=3D lrng_switch.o
diff --git a/drivers/char/lrng/lrng_switch.c b/drivers/char/lrng/lrng_switc=
h.c
new file mode 100644
index 000000000000..48c9a364aecf
=2D-- /dev/null
+++ b/drivers/char/lrng/lrng_switch.c
@@ -0,0 +1,183 @@
+// SPDX-License-Identifier: GPL-2.0 OR BSD-2-Clause
+/*
+ * LRNG DRNG switching support
+ *
+ * Copyright (C) 2016 - 2020, Stephan Mueller <smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org>
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/lrng.h>
+
+#include "lrng_internal.h"
+
+static int lrng_drng_switch(struct lrng_drng *drng_store,
+			    const struct lrng_crypto_cb *cb, int node)
+{
+	const struct lrng_crypto_cb *old_cb;
+	unsigned long flags =3D 0;
+	int ret;
+	u8 seed[LRNG_DRNG_SECURITY_STRENGTH_BYTES];
+	void *new_drng =3D cb->lrng_drng_alloc(LRNG_DRNG_SECURITY_STRENGTH_BYTES);
+	void *old_drng, *new_hash, *old_hash;
+	bool sl =3D false, reset_drng =3D !lrng_get_available();
+
+	if (IS_ERR(new_drng)) {
+		pr_warn("could not allocate new DRNG for NUMA node %d (%ld)\n",
+			node, PTR_ERR(new_drng));
+		return PTR_ERR(new_drng);
+	}
+
+	new_hash =3D cb->lrng_hash_alloc(seed, sizeof(seed));
+	if (IS_ERR(new_hash)) {
+		pr_warn("could not allocate new LRNG pool hash (%ld)\n",
+			PTR_ERR(new_hash));
+		cb->lrng_drng_dealloc(new_drng);
+		return PTR_ERR(new_hash);
+	}
+
+	lrng_drng_lock(drng_store, &flags);
+
+	/*
+	 * Pull from existing DRNG to seed new DRNG regardless of seed status
+	 * of old DRNG -- the entropy state for the DRNG is left unchanged which
+	 * implies that als the new DRNG is reseeded when deemed necessary. This
+	 * seeding of the new DRNG shall only ensure that the new DRNG has the
+	 * same entropy as the old DRNG.
+	 */
+	ret =3D drng_store->crypto_cb->lrng_drng_generate_helper(
+				drng_store->drng, seed, sizeof(seed));
+	lrng_drng_unlock(drng_store, &flags);
+
+	if (ret < 0) {
+		reset_drng =3D true;
+		pr_warn("getting random data from DRNG failed for NUMA node %d "
+			"(%d)\n", node, ret);
+	} else {
+		/* seed new DRNG with data */
+		ret =3D cb->lrng_drng_seed_helper(new_drng, seed, ret);
+		if (ret < 0) {
+			reset_drng =3D true;
+			pr_warn("seeding of new DRNG failed for NUMA node %d "
+				"(%d)\n", node, ret);
+		} else {
+			pr_debug("seeded new DRNG of NUMA node %d instance "
+				 "from old DRNG instance\n", node);
+		}
+	}
+
+	mutex_lock(&drng_store->lock);
+	/*
+	 * If we switch the DRNG from the initial ChaCha20 DRNG to something
+	 * else, there is a lock transition from spin lock to mutex (see
+	 * lrng_drng_is_atomic and how the lock is taken in lrng_drng_lock).
+	 * Thus, we need to take both locks during the transition phase.
+	 */
+	if (lrng_drng_is_atomic(drng_store)) {
+		spin_lock_irqsave(&drng_store->spin_lock, flags);
+		sl =3D true;
+	}
+
+	if (reset_drng)
+		lrng_drng_reset(drng_store);
+
+	old_drng =3D drng_store->drng;
+	old_cb =3D drng_store->crypto_cb;
+	drng_store->drng =3D new_drng;
+	drng_store->crypto_cb =3D cb;
+
+	old_hash =3D drng_store->hash;
+	drng_store->hash =3D new_hash;
+	pr_info("Entropy pool read-hash allocated for DRNG for NUMA node %d\n",
+		node);
+
+	if (sl)
+		spin_unlock_irqrestore(&drng_store->spin_lock, flags);
+	mutex_unlock(&drng_store->lock);
+
+	/* ChaCha20 serves as atomic instance left untouched. */
+	if (old_drng !=3D &chacha20) {
+		old_cb->lrng_drng_dealloc(old_drng);
+		old_cb->lrng_hash_dealloc(old_hash);
+	}
+
+	pr_info("DRNG of NUMA node %d switched\n", node);
+
+	return 0;
+}
+
+/*
+ * Switch the existing DRNG instances with new using the new crypto callba=
cks.
+ * The caller must hold the lrng_crypto_cb_update lock.
+ */
+static int lrng_drngs_switch(const struct lrng_crypto_cb *cb)
+{
+	struct lrng_drng **lrng_drng =3D lrng_drng_instances();
+	struct lrng_drng *lrng_drng_init =3D lrng_drng_init_instance();
+	int ret =3D 0;
+
+	/* Update DRNG */
+	if (lrng_drng) {
+		u32 node;
+
+		for_each_online_node(node) {
+			if (lrng_drng[node])
+				ret =3D lrng_drng_switch(lrng_drng[node], cb,
+						       node);
+		}
+	} else {
+		ret =3D lrng_drng_switch(lrng_drng_init, cb, 0);
+	}
+
+	if (!ret)
+		lrng_set_available();
+
+	return 0;
+}
+
+/**
+ * lrng_set_drng_cb - Register new cryptographic callback functions for DR=
NG
+ * The registering implies that all old DRNG states are replaced with new
+ * DRNG states.
+ *
+ * @cb: Callback functions to be registered -- if NULL, use the default
+ *	callbacks pointing to the ChaCha20 DRNG.
+ *
+ * Return:
+ * * 0 on success
+ * * < 0 on error
+ */
+int lrng_set_drng_cb(const struct lrng_crypto_cb *cb)
+{
+	struct lrng_drng *lrng_drng_init =3D lrng_drng_init_instance();
+	int ret;
+
+	if (!cb)
+		cb =3D &lrng_cc20_crypto_cb;
+
+	mutex_lock(&lrng_crypto_cb_update);
+
+	/*
+	 * If a callback other than the default is set, allow it only to be
+	 * set back to the default callback. This ensures that multiple
+	 * different callbacks can be registered at the same time. If a
+	 * callback different from the current callback and the default
+	 * callback shall be set, the current callback must be deregistered
+	 * (e.g. the kernel module providing it must be unloaded) and the new
+	 * implementation can be registered.
+	 */
+	if ((cb !=3D &lrng_cc20_crypto_cb) &&
+	    (lrng_drng_init->crypto_cb !=3D &lrng_cc20_crypto_cb)) {
+		pr_warn("disallow setting new cipher callbacks, unload the old "
+			"callbacks first!\n");
+		ret =3D -EINVAL;
+		goto out;
+	}
+
+	ret =3D lrng_drngs_switch(cb);
+
+out:
+	mutex_unlock(&lrng_crypto_cb_update);
+	return ret;
+}
+EXPORT_SYMBOL(lrng_set_drng_cb);
=2D-=20
2.24.1
