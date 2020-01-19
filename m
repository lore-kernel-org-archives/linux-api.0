From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org>
Subject: [PATCH v29 09/12] LRNG - add Jitter RNG fast noise source
Date: Sun, 19 Jan 2020 22:18:04 +0100
Message-ID: <4639457.SCQOsVujqT@positron.chronox.de>
References: <6157374.ptSnyUpaCn@positron.chronox.de> <5951792.lmNsirYsPE@positron.chronox.de> <1967138.dxe05VgvIB@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1967138.dxe05VgvIB-jJGQKZiSfeo1haGO/jJMPxvVK+yQ3ZXh@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, "Alexander E. Patrakov" <patrakov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Ahmed S. Darwish" <darwish.07-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Theodore Y. Ts'o" <tytso-3s7WtUTddSA@public.gmane.org>, Willy Tarreau <w@1wt.eu>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Vito Caputo <vcaputo-IiWei5kqaphBDgjK7y7TUQ@public.gmane.org>, Andreas Dilger <adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Ray Strode <rstrode-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, William Jon McCann <mccann-4GNroTWusrE@public.gmane.org>, zhangjs <zachary-+jQ8zvd9CV5SzTKKI/wJ2A@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Florian Weimer <fweimer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Lennart Poettering <mzxreary-uLTowLwuiw4b1SvskN2V4Q@public.gmane.org>, Nicolai Stange <nstange-l3A5Bk7waGM@public.gmane.org>, "Peter, Matthias" <matth>
List-Id: linux-api@vger.kernel.org

The Jitter RNG fast noise source implemented as part of the kernel
crypto API is queried for 256 bits of entropy at the time the seed
buffer managed by the LRNG is about to be filled.

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
 drivers/char/lrng/Kconfig     | 12 +++++
 drivers/char/lrng/Makefile    |  1 +
 drivers/char/lrng/lrng_jent.c | 88 +++++++++++++++++++++++++++++++++++
 3 files changed, 101 insertions(+)
 create mode 100644 drivers/char/lrng/lrng_jent.c

diff --git a/drivers/char/lrng/Kconfig b/drivers/char/lrng/Kconfig
index 7afc965a4d52..4684e838f011 100644
=2D-- a/drivers/char/lrng/Kconfig
+++ b/drivers/char/lrng/Kconfig
@@ -94,4 +94,16 @@ config LRNG_KCAPI
 	  provided by the selected kernel crypto API RNG.
 endif # LRNG_DRNG_SWITCH
=20
+config LRNG_JENT
+	bool "Enable Jitter RNG as LRNG Seed Source"
+	depends on CRYPTO
+	select CRYPTO_JITTERENTROPY
+	help
+	  The Linux RNG may use the Jitter RNG as noise source. Enabling
+	  this option enables the use of the Jitter RNG. Its default
+	  entropy level is 16 bits of entropy per 256 data bits delivered
+	  by the Jitter RNG. This entropy level can be changed at boot
+	  time or at runtime with the lrng_base.jitterrng configuration
+	  variable.
+
 endif # LRNG
diff --git a/drivers/char/lrng/Makefile b/drivers/char/lrng/Makefile
index 94b2dfb2dfdb..4f5b6f38f0c4 100644
=2D-- a/drivers/char/lrng/Makefile
+++ b/drivers/char/lrng/Makefile
@@ -13,3 +13,4 @@ obj-$(CONFIG_SYSCTL)		+=3D lrng_proc.o
 obj-$(CONFIG_LRNG_DRNG_SWITCH)	+=3D lrng_switch.o
 obj-$(CONFIG_LRNG_DRBG)		+=3D lrng_drbg.o
 obj-$(CONFIG_LRNG_KCAPI)	+=3D lrng_kcapi.o
+obj-$(CONFIG_LRNG_JENT)		+=3D lrng_jent.o
diff --git a/drivers/char/lrng/lrng_jent.c b/drivers/char/lrng/lrng_jent.c
new file mode 100644
index 000000000000..225505271fcb
=2D-- /dev/null
+++ b/drivers/char/lrng/lrng_jent.c
@@ -0,0 +1,88 @@
+// SPDX-License-Identifier: GPL-2.0 OR BSD-2-Clause
+/*
+ * LRNG Fast Noise Source: Jitter RNG
+ *
+ * Copyright (C) 2016 - 2020, Stephan Mueller <smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org>
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/types.h>
+#include <crypto/internal/jitterentropy.h>
+
+#include "lrng_internal.h"
+
+/*
+ * Estimated entropy of data is a 16th of LRNG_DRNG_SECURITY_STRENGTH_BITS.
+ * Albeit a full entropy assessment is provided for the noise source indic=
ating
+ * that it provides high entropy rates and considering that it deactivates
+ * when it detects insufficient hardware, the chosen under estimation of
+ * entropy is considered to be acceptable to all reviewers.
+ */
+static u32 jitterrng =3D LRNG_DRNG_SECURITY_STRENGTH_BITS>>4;
+module_param(jitterrng, uint, 0644);
+MODULE_PARM_DESC(jitterrng, "Entropy in bits of 256 data bits from Jitter =
RNG noise source");
+
+/**
+ * lrng_get_jent() - Get Jitter RNG entropy
+ *
+ * @outbuf: buffer to store entropy
+ * @outbuflen: length of buffer
+ *
+ * Return:
+ * * > 0 on success where value provides the added entropy in bits
+ * * 0 if no fast source was available
+ */
+static struct rand_data *lrng_jent_state;
+
+u32 lrng_get_jent(u8 *outbuf, unsigned int outbuflen)
+{
+	int ret;
+	u32 ent_bits =3D jitterrng;
+	unsigned long flags;
+	static DEFINE_SPINLOCK(lrng_jent_lock);
+	static int lrng_jent_initialized =3D 0;
+
+	spin_lock_irqsave(&lrng_jent_lock, flags);
+
+	if (!ent_bits || (lrng_jent_initialized =3D=3D -1)) {
+		spin_unlock_irqrestore(&lrng_jent_lock, flags);
+		return 0;
+	}
+
+	if (!lrng_jent_initialized) {
+		lrng_jent_state =3D jent_lrng_entropy_collector();
+		if (!lrng_jent_state) {
+			jitterrng =3D 0;
+			lrng_jent_initialized =3D -1;
+			spin_unlock_irqrestore(&lrng_jent_lock, flags);
+			pr_info("Jitter RNG unusable on current system\n");
+			return 0;
+		}
+		lrng_jent_initialized =3D 1;
+		pr_debug("Jitter RNG working on current system\n");
+	}
+	ret =3D jent_read_entropy(lrng_jent_state, outbuf, outbuflen);
+	spin_unlock_irqrestore(&lrng_jent_lock, flags);
+
+	if (ret) {
+		pr_debug("Jitter RNG failed with %d\n", ret);
+		return 0;
+	}
+
+	/* Obtain entropy statement */
+	if (outbuflen !=3D LRNG_DRNG_SECURITY_STRENGTH_BYTES)
+		ent_bits =3D (ent_bits * outbuflen<<3) /
+			   LRNG_DRNG_SECURITY_STRENGTH_BITS;
+	/* Cap entropy to buffer size in bits */
+	ent_bits =3D min_t(u32, ent_bits, outbuflen<<3);
+	pr_debug("obtained %u bits of entropy from Jitter RNG noise source\n",
+		 ent_bits);
+
+	return ent_bits;
+}
+
+u32 lrng_jent_entropylevel(void)
+{
+	return min_t(u32, jitterrng, LRNG_DRNG_SECURITY_STRENGTH_BITS);
+}
=2D-=20
2.24.1
