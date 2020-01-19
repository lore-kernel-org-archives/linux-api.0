From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org>
Subject: [PATCH v29 06/12] LRNG - add SP800-90A DRBG extension
Date: Sun, 19 Jan 2020 22:16:01 +0100
Message-ID: <105345883.YUXrsyIcmA@positron.chronox.de>
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

Using the LRNG switchable DRNG support, the SP800-90A DRBG extension is
implemented.

The DRBG uses the kernel crypto API DRBG implementation. In addition, it
uses the kernel crypto API SHASH support to provide the hashing
operation.

The DRBG supports the choice of either a CTR DRBG using AES-256, HMAC
DRBG with SHA-512 core or Hash DRBG with SHA-512 core. The used core can
be selected with the module parameter lrng_drbg_type. The default is the
CTR DRBG.

When compiling the DRBG extension statically, the DRBG is loaded at
late_initcall stage which implies that with the start of user space, the
user space interfaces of getrandom(2), /dev/random and /dev/urandom
provide random data produced by an SP800-90A DRBG.

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
Reviewed-by: Roman Drahtmueller <draht-UTA6Eu5RHcbyVfKhlJ+g5A@public.gmane.org>
Tested-by: Roman Drahtm=FCller <draht-UTA6Eu5RHcbyVfKhlJ+g5A@public.gmane.org>
Tested-by: Marcelo Henrique Cerri <marcelo.cerri-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Tested-by: Neil Horman <nhorman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Stephan Mueller <smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org>
=2D--
 drivers/char/lrng/Kconfig     |  12 ++
 drivers/char/lrng/Makefile    |   1 +
 drivers/char/lrng/lrng_drbg.c | 257 ++++++++++++++++++++++++++++++++++
 3 files changed, 270 insertions(+)
 create mode 100644 drivers/char/lrng/lrng_drbg.c

diff --git a/drivers/char/lrng/Kconfig b/drivers/char/lrng/Kconfig
index cb701bb0b8b6..b32442484823 100644
=2D-- a/drivers/char/lrng/Kconfig
+++ b/drivers/char/lrng/Kconfig
@@ -71,4 +71,16 @@ menuconfig LRNG_DRNG_SWITCH
 	  accessible via the external interfaces. With this configuration
 	  option other DRNGs can be selected and loaded at runtime.
=20
+if LRNG_DRNG_SWITCH
+config LRNG_DRBG
+	tristate "SP800-90A support for the LRNG"
+	depends on CRYPTO
+	select CRYPTO_DRBG_MENU
+	select CRYPTO_CMAC if CRYPTO_DRBG_CTR
+	help
+	  Enable the SP800-90A DRBG support for the LRNG. Once the
+	  module is loaded, output from /dev/random, /dev/urandom,
+	  getrandom(2), or get_random_bytes is provided by a DRBG.
+endif # LRNG_DRNG_SWITCH
+
 endif # LRNG
diff --git a/drivers/char/lrng/Makefile b/drivers/char/lrng/Makefile
index 31cfe87c999e..0d320fcb7b9e 100644
=2D-- a/drivers/char/lrng/Makefile
+++ b/drivers/char/lrng/Makefile
@@ -11,3 +11,4 @@ obj-y				+=3D lrng_pool.o lrng_aux.o \
 obj-$(CONFIG_NUMA)		+=3D lrng_numa.o
 obj-$(CONFIG_SYSCTL)		+=3D lrng_proc.o
 obj-$(CONFIG_LRNG_DRNG_SWITCH)	+=3D lrng_switch.o
+obj-$(CONFIG_LRNG_DRBG)		+=3D lrng_drbg.o
diff --git a/drivers/char/lrng/lrng_drbg.c b/drivers/char/lrng/lrng_drbg.c
new file mode 100644
index 000000000000..f35e7b886d01
=2D-- /dev/null
+++ b/drivers/char/lrng/lrng_drbg.c
@@ -0,0 +1,257 @@
+// SPDX-License-Identifier: GPL-2.0 OR BSD-2-Clause
+/*
+ * Backend for the LRNG providing the cryptographic primitives using the
+ * kernel crypto API and its DRBG.
+ *
+ * Copyright (C) 2016 - 2020, Stephan Mueller <smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org>
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <crypto/drbg.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/lrng.h>
+
+/*
+ * Define a DRBG plus a hash / MAC used to extract data from the entropy p=
ool.
+ * For LRNG_HASH_NAME you can use a hash or a MAC (HMAC or CMAC) of your c=
hoice
+ * (Note, you should use the suggested selections below -- using SHA-1 or =
MD5
+ * is not wise). The idea is that the used cipher primitive can be selecte=
d to
+ * be the same as used for the DRBG. I.e. the LRNG only uses one cipher
+ * primitive using the same cipher implementation with the options offered=
 in
+ * the following. This means, if the CTR DRBG is selected and AES-NI is pr=
esent,
+ * both the CTR DRBG and the selected cmac(aes) use AES-NI.
+ *
+ * The security strengths of the DRBGs are all 256 bits according to
+ * SP800-57 section 5.6.1.
+ *
+ * This definition is allowed to be changed.
+ */
+#ifdef CONFIG_CRYPTO_DRBG_CTR
+static unsigned int lrng_drbg_type =3D 0;
+#elif defined CONFIG_CRYPTO_DRBG_HMAC
+static unsigned int lrng_drbg_type =3D 1;
+#elif defined CONFIG_CRYPTO_DRBG_HASH
+static unsigned int lrng_drbg_type =3D 2;
+#else
+#error "Unknown DRBG in use"
+#endif
+
+/* The parameter must be r/o in sysfs as otherwise races appear. */
+module_param(lrng_drbg_type, uint, 0444);
+MODULE_PARM_DESC(lrng_drbg_type, "DRBG type used for LRNG (0->CTR_DRBG, 1-=
>HMAC_DRBG, 2->Hash_DRBG)");
+
+struct lrng_drbg {
+	const char *hash_name;
+	const char *drbg_core;
+};
+
+static const struct lrng_drbg lrng_drbg_types[] =3D {
+	{	/* CTR_DRBG with AES-256 using derivation function */
+		.hash_name =3D "cmac(aes)",
+		.drbg_core =3D "drbg_nopr_ctr_aes256",
+	}, {	/* HMAC_DRBG with SHA-512 */
+		.hash_name =3D "sha512",
+		.drbg_core =3D "drbg_nopr_hmac_sha512",
+	}, {	/* Hash_DRBG with SHA-512 using derivation function */
+		.hash_name =3D "sha512",
+		.drbg_core =3D "drbg_nopr_sha512"
+	}
+};
+
+struct lrng_hash_info {
+	struct shash_desc shash;
+	char ctx[];
+};
+
+static int lrng_drbg_drng_seed_helper(void *drng, const u8 *inbuf, u32 inb=
uflen)
+{
+	struct drbg_state *drbg =3D (struct drbg_state *)drng;
+	LIST_HEAD(seedlist);
+	struct drbg_string data;
+	int ret;
+
+	drbg_string_fill(&data, inbuf, inbuflen);
+	list_add_tail(&data.list, &seedlist);
+	ret =3D drbg->d_ops->update(drbg, &seedlist, drbg->seeded);
+
+	if (ret >=3D 0)
+		drbg->seeded =3D true;
+
+	return ret;
+}
+
+static int lrng_drbg_drng_generate_helper(void *drng, u8 *outbuf, u32 outb=
uflen)
+{
+	struct drbg_state *drbg =3D (struct drbg_state *)drng;
+
+	return drbg->d_ops->generate(drbg, outbuf, outbuflen, NULL);
+}
+
+static void *lrng_drbg_drng_alloc(u32 sec_strength)
+{
+	struct drbg_state *drbg;
+	int coreref =3D -1;
+	bool pr =3D false;
+	int ret;
+
+	drbg_convert_tfm_core(lrng_drbg_types[lrng_drbg_type].drbg_core,
+			      &coreref, &pr);
+	if (coreref < 0)
+		return ERR_PTR(-EFAULT);
+
+	drbg =3D kzalloc(sizeof(struct drbg_state), GFP_KERNEL);
+	if (!drbg)
+		return ERR_PTR(-ENOMEM);
+
+	drbg->core =3D &drbg_cores[coreref];
+	drbg->seeded =3D false;
+	ret =3D drbg_alloc_state(drbg);
+	if (ret)
+		goto err;
+
+	if (sec_strength > drbg_sec_strength(drbg->core->flags)) {
+		pr_err("Security strength of DRBG (%u bits) lower than requested by LRNG=
 (%u bits)\n",
+			drbg_sec_strength(drbg->core->flags) * 8,
+			sec_strength * 8);
+		goto dealloc;
+	}
+
+	if (sec_strength < drbg_sec_strength(drbg->core->flags))
+		pr_warn("Security strength of DRBG (%u bits) higher than requested by LR=
NG (%u bits)\n",
+			drbg_sec_strength(drbg->core->flags) * 8,
+			sec_strength * 8);
+
+	pr_info("DRBG with %s core allocated\n", drbg->core->backend_cra_name);
+
+	return drbg;
+
+dealloc:
+	if (drbg->d_ops)
+		drbg->d_ops->crypto_fini(drbg);
+	drbg_dealloc_state(drbg);
+err:
+	kfree(drbg);
+	return ERR_PTR(-EINVAL);
+}
+
+static void lrng_drbg_drng_dealloc(void *drng)
+{
+	struct drbg_state *drbg =3D (struct drbg_state *)drng;
+
+	drbg_dealloc_state(drbg);
+	kzfree(drbg);
+	pr_info("DRBG deallocated\n");
+}
+
+static void *lrng_drbg_hash_alloc(const u8 *key, u32 keylen)
+{
+	struct lrng_hash_info *lrng_hash;
+	struct crypto_shash *tfm;
+	int size, ret;
+
+	tfm =3D crypto_alloc_shash(lrng_drbg_types[lrng_drbg_type].hash_name,
+				 0, 0);
+	if (IS_ERR(tfm)) {
+		pr_err("could not allocate hash %s\n",
+		       lrng_drbg_types[lrng_drbg_type].hash_name);
+		return ERR_CAST(tfm);
+	}
+
+	size =3D sizeof(struct lrng_hash_info) + crypto_shash_descsize(tfm);
+	lrng_hash =3D kmalloc(size, GFP_KERNEL);
+	if (!lrng_hash) {
+		crypto_free_shash(tfm);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	lrng_hash->shash.tfm =3D tfm;
+
+	/* If the used hash is no MAC, ignore the ENOSYS return code */
+	ret =3D crypto_shash_setkey(tfm, key, keylen);
+	if (ret && ret !=3D -ENOSYS) {
+		pr_err("could not set the key for MAC\n");
+		crypto_free_shash(tfm);
+		kfree(lrng_hash);
+		return ERR_PTR(ret);
+	}
+
+	pr_info("Hash %s allocated\n",
+		lrng_drbg_types[lrng_drbg_type].hash_name);
+
+	return lrng_hash;
+}
+
+static void lrng_drbg_hash_dealloc(void *hash)
+{
+	struct lrng_hash_info *lrng_hash =3D (struct lrng_hash_info *)hash;
+	struct shash_desc *shash =3D &lrng_hash->shash;
+	struct crypto_shash *tfm =3D shash->tfm;
+
+	crypto_free_shash(tfm);
+	kfree(lrng_hash);
+	pr_info("Hash deallocated\n");
+}
+
+static u32 lrng_drbg_hash_digestsize(void *hash)
+{
+	struct lrng_hash_info *lrng_hash =3D (struct lrng_hash_info *)hash;
+	struct shash_desc *shash =3D &lrng_hash->shash;
+
+	return crypto_shash_digestsize(shash->tfm);
+}
+
+static int lrng_drbg_hash_buffer(void *hash, const u8 *inbuf, u32 inbuflen,
+				 u8 *digest)
+{
+	struct lrng_hash_info *lrng_hash =3D (struct lrng_hash_info *)hash;
+	struct shash_desc *shash =3D &lrng_hash->shash;
+
+	return crypto_shash_digest(shash, inbuf, inbuflen, digest);
+}
+
+static const char *lrng_drbg_name(void)
+{
+	return lrng_drbg_types[lrng_drbg_type].drbg_core;
+}
+
+static const char *lrng_hash_name(void)
+{
+	return lrng_drbg_types[lrng_drbg_type].hash_name;
+}
+
+const static struct lrng_crypto_cb lrng_drbg_crypto_cb =3D {
+	.lrng_drng_name			=3D lrng_drbg_name,
+	.lrng_hash_name			=3D lrng_hash_name,
+	.lrng_drng_alloc		=3D lrng_drbg_drng_alloc,
+	.lrng_drng_dealloc		=3D lrng_drbg_drng_dealloc,
+	.lrng_drng_seed_helper		=3D lrng_drbg_drng_seed_helper,
+	.lrng_drng_generate_helper	=3D lrng_drbg_drng_generate_helper,
+	.lrng_hash_alloc		=3D lrng_drbg_hash_alloc,
+	.lrng_hash_dealloc		=3D lrng_drbg_hash_dealloc,
+	.lrng_hash_digestsize		=3D lrng_drbg_hash_digestsize,
+	.lrng_hash_buffer		=3D lrng_drbg_hash_buffer,
+};
+
+static int __init lrng_drbg_init(void)
+{
+	if (lrng_drbg_type >=3D ARRAY_SIZE(lrng_drbg_types)) {
+		pr_err("lrng_drbg_type parameter too large (given %u - max: %lu)",
+		       lrng_drbg_type,
+		       (unsigned long)ARRAY_SIZE(lrng_drbg_types) - 1);
+		return -EAGAIN;
+	}
+	return lrng_set_drng_cb(&lrng_drbg_crypto_cb);
+}
+
+static void __exit lrng_drbg_exit(void)
+{
+	lrng_set_drng_cb(NULL);
+}
+
+late_initcall(lrng_drbg_init);
+module_exit(lrng_drbg_exit);
+MODULE_LICENSE("Dual BSD/GPL");
+MODULE_AUTHOR("Stephan Mueller <smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org>");
+MODULE_DESCRIPTION("Linux Random Number Generator - SP800-90A DRBG backend=
");
=2D-=20
2.24.1
