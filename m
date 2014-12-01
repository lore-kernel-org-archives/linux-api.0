From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [tpmdd-devel] [PATCH v7 07/10] tpm: TPM 2.0 baseline support
Date: Mon, 1 Dec 2014 19:55:18 +0200
Message-ID: <20141201175518.GD17601@intel.com>
References: <1415713513-16524-1-git-send-email-jarkko.sakkinen@linux.intel.com>
 <1415713513-16524-8-git-send-email-jarkko.sakkinen@linux.intel.com>
 <547521F1.7040209@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <547521F1.7040209-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: Peter Huewe <peterhuewe-Mmb7MZpHnFY@public.gmane.org>, Ashley Lai <ashley-fm2HMyfA2y6tG0bUXCXiUA@public.gmane.org>, Marcel Selhorst <tpmdd-yWjUBOtONefk1uMJSBkQmQ@public.gmane.org>, christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, josh.triplett-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Will Arthur <will.c.arthur-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, jason.gunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, trousers-tech-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, Nov 25, 2014 at 07:42:25PM -0500, Stefan Berger wrote:
> On 11/11/2014 08:45 AM, Jarkko Sakkinen wrote:
> >TPM 2.0 devices are separated by adding a field 'flags' to struct
> >tpm_chip and defining a flag TPM_CHIP_FLAG_TPM2 for tagging them.
> >
> >This patch adds the following internal functions:
> >
> >- tpm2_get_random()
> >- tpm2_get_tpm_pt()
> >- tpm2_pcr_extend()
> >- tpm2_pcr_read()
> >- tpm2_startup()
> >
> >Additionally, the following exported functions are implemented for
> >implementing TPM 2.0 device drivers:
> >
> >- tpm2_do_selftest()
> >- tpm2_calc_ordinal_durations()
> >- tpm2_gen_interrupt()
> >
> >The existing functions that are exported for the use for existing
> >subsystems have been changed to check the flags field in struct
> >tpm_chip and use appropriate TPM 2.0 counterpart if
> >TPM_CHIP_FLAG_TPM2 is est.
> >
> >The code for tpm2_calc_ordinal_duration() and tpm2_startup() were
> >originally written by Will Arthur.
> >
> >Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> >Signed-off-by: Will Arthur <will.c.arthur-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> >---
> >  drivers/char/tpm/Makefile        |   2 +-
> >  drivers/char/tpm/tpm-chip.c      |  21 +-
> >  drivers/char/tpm/tpm-interface.c |  24 +-
> >  drivers/char/tpm/tpm.h           |  67 +++++
> >  drivers/char/tpm/tpm2-cmd.c      | 566 +++++++++++++++++++++++++++++++++++++++
> >  5 files changed, 668 insertions(+), 12 deletions(-)
> >  create mode 100644 drivers/char/tpm/tpm2-cmd.c
> >
> >diff --git a/drivers/char/tpm/Makefile b/drivers/char/tpm/Makefile
> >index 837da04..ae56af9 100644
> >--- a/drivers/char/tpm/Makefile
> >+++ b/drivers/char/tpm/Makefile
> >@@ -2,7 +2,7 @@
> >  # Makefile for the kernel tpm device drivers.
> >  #
> >  obj-$(CONFIG_TCG_TPM) += tpm.o
> >-tpm-y := tpm-interface.o tpm-dev.o tpm-sysfs.o tpm-chip.o
> >+tpm-y := tpm-interface.o tpm-dev.o tpm-sysfs.o tpm-chip.o tpm2-cmd.o
> >  tpm-$(CONFIG_ACPI) += tpm_ppi.o
> >
> >  ifdef CONFIG_ACPI
> >diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
> >index 5d268ac..4d25b24 100644
> >--- a/drivers/char/tpm/tpm-chip.c
> >+++ b/drivers/char/tpm/tpm-chip.c
> >@@ -213,11 +213,14 @@ int tpm_chip_register(struct tpm_chip *chip)
> >  	if (rc)
> >  		return rc;
> >
> >-	rc = tpm_add_ppi(chip);
> >-	if (rc)
> >-		goto out_err;
> >+	/* Populate sysfs for TPM1 devices. */
> >+	if (!(chip->flags & TPM_CHIP_FLAG_TPM2)) {
> >+		rc = tpm_add_ppi(chip);
> >+		if (rc)
> >+			goto out_err;
> >
> >-	chip->bios_dir = tpm_bios_log_setup(chip->devname);
> >+		chip->bios_dir = tpm_bios_log_setup(chip->devname);
> >+	}
> >
> >  	/* Make the chip available. */
> >  	spin_lock(&driver_lock);
> >@@ -248,10 +251,12 @@ void tpm_chip_unregister(struct tpm_chip *chip)
> >  	spin_unlock(&driver_lock);
> >  	synchronize_rcu();
> >
> >-	tpm_remove_ppi(chip);
> >-
> >-	if (chip->bios_dir)
> >-		tpm_bios_log_teardown(chip->bios_dir);
> >+	/* Clean up sysfs for TPM1 devices. */
> >+	if (!(chip->flags & TPM_CHIP_FLAG_TPM2)) {
> >+		if (chip->bios_dir)
> >+			tpm_bios_log_teardown(chip->bios_dir);
> >+		tpm_remove_ppi(chip);
> >+	}
> >
> >  	tpm_dev_del_device(chip);
> >  }
> >diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
> >index 9e4ce4d..e62b835 100644
> >--- a/drivers/char/tpm/tpm-interface.c
> >+++ b/drivers/char/tpm/tpm-interface.c
> >@@ -360,7 +360,10 @@ ssize_t tpm_transmit(struct tpm_chip *chip, const char *buf,
> >  	if (chip->vendor.irq)
> >  		goto out_recv;
> >
> >-	stop = jiffies + tpm_calc_ordinal_duration(chip, ordinal);
> >+	if (chip->flags & TPM_CHIP_FLAG_TPM2)
> >+		stop = jiffies + tpm2_calc_ordinal_duration(chip, ordinal);
> >+	else
> >+		stop = jiffies + tpm_calc_ordinal_duration(chip, ordinal);
> >  	do {
> >  		u8 status = chip->ops->status(chip);
> >  		if ((status & chip->ops->req_complete_mask) ==
> >@@ -483,7 +486,7 @@ static const struct tpm_input_header tpm_startup_header = {
> >  static int tpm_startup(struct tpm_chip *chip, __be16 startup_type)
> >  {
> >  	struct tpm_cmd_t start_cmd;
> >-	start_cmd.header.in = tpm_startup_header;
> >+
> >  	start_cmd.params.startup_in.startup_type = startup_type;
> >  	return tpm_transmit_cmd(chip, &start_cmd, TPM_INTERNAL_RESULT_SIZE,
> >  				"attempting to start the TPM");
> >@@ -680,7 +683,10 @@ int tpm_pcr_read(u32 chip_num, int pcr_idx, u8 *res_buf)
> >  	chip = tpm_chip_find_get(chip_num);
> >  	if (chip == NULL)
> >  		return -ENODEV;
> >-	rc = tpm_pcr_read_dev(chip, pcr_idx, res_buf);
> >+	if (chip->flags & TPM_CHIP_FLAG_TPM2)
> >+		rc = tpm2_pcr_read(chip, pcr_idx, res_buf);
> >+	else
> >+		rc = tpm_pcr_read_dev(chip, pcr_idx, res_buf);
> >  	tpm_chip_put(chip);
> >  	return rc;
> >  }
> >@@ -714,6 +720,12 @@ int tpm_pcr_extend(u32 chip_num, int pcr_idx, const u8 *hash)
> >  	if (chip == NULL)
> >  		return -ENODEV;
> >
> >+	if (chip->flags & TPM_CHIP_FLAG_TPM2) {
> >+		rc = tpm2_pcr_extend(chip, pcr_idx, hash);
> >+		tpm_chip_put(chip);
> >+		return rc;
> >+	}
> >+
> >  	cmd.header.in = pcrextend_header;
> >  	cmd.params.pcrextend_in.pcr_idx = cpu_to_be32(pcr_idx);
> >  	memcpy(cmd.params.pcrextend_in.hash, hash, TPM_DIGEST_SIZE);
> >@@ -974,6 +986,12 @@ int tpm_get_random(u32 chip_num, u8 *out, size_t max)
> >  	if (chip == NULL)
> >  		return -ENODEV;
> >
> >+	if (chip->flags & TPM_CHIP_FLAG_TPM2) {
> >+		err = tpm2_get_random(chip, out, max);
> >+		tpm_chip_put(chip);
> >+		return err;
> >+	}
> >+
> >  	do {
> >  		tpm_cmd.header.in = tpm_getrandom_header;
> >  		tpm_cmd.params.getrandom_in.num_bytes = cpu_to_be32(num_bytes);
> >diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
> >index 9d062e6..8a434d2 100644
> >--- a/drivers/char/tpm/tpm.h
> >+++ b/drivers/char/tpm/tpm.h
> >@@ -62,6 +62,57 @@ enum tpm_duration {
> >  #define TPM_ERR_INVALID_POSTINIT 38
> >
> >  #define TPM_HEADER_SIZE		10
> >+
> >+enum tpm2_const {
> >+	TPM2_PLATFORM_PCR	= 24,
> >+	TPM2_PCR_SELECT_MIN	= ((TPM2_PLATFORM_PCR + 7) / 8),
> >+	TPM2_TIMEOUT_A		= 750 * 1000,
> >+	TPM2_TIMEOUT_B		= 2000 * 1000,
> >+	TPM2_TIMEOUT_C		= 200 * 1000,
> >+	TPM2_TIMEOUT_D		= 30 * 1000,
> >+	TPM2_DURATION_SHORT	= 20 * 1000,
> >+	TPM2_DURATION_MEDIUM	= 750 * 1000,
> >+	TPM2_DURATION_LONG	= 2000 * 1000,
> >+};
> >+
> >+enum tpm2_structures {
> >+	TPM2_ST_NO_SESSIONS	= 0x8001,
> >+	TPM2_ST_SESSIONS	= 0x8002,
> >+};
> >+
> >+enum tpm2_return_codes {
> >+	TPM2_RC_TESTING		= 0x090A,
> >+	TPM2_RC_DISABLED	= 0x0120,
> >+};
> >+
> >+enum tpm2_algorithms {
> >+	TPM2_ALG_SHA1		= 0x0004,
> >+};
> >+
> >+enum tpm2_command_codes {
> >+	TPM2_CC_FIRST		= 0x011F,
> >+	TPM2_CC_SELF_TEST	= 0x0143,
> >+	TPM2_CC_STARTUP		= 0x0144,
> >+	TPM2_CC_GET_CAPABILITY	= 0x017A,
> >+	TPM2_CC_GET_RANDOM	= 0x017B,
> >+	TPM2_CC_PCR_READ	= 0x017E,
> >+	TPM2_CC_PCR_EXTEND	= 0x0182,
> >+	TPM2_CC_LAST		= 0x018F,
> >+};
> >+
> >+enum tpm2_permanent_handles {
> >+	TPM2_RS_PW		= 0x40000009,
> >+};
> >+
> >+enum tpm2_capabilities {
> >+	TPM2_CAP_TPM_PROPERTIES = 6,
> >+};
> >+
> >+enum tpm2_startup_types {
> >+	TPM2_SU_CLEAR	= 0x0000,
> >+	TPM2_SU_STATE	= 0x0001,
> >+};
> >+
> >  struct tpm_chip;
> >
> >  struct tpm_vendor_specific {
> >@@ -96,12 +147,17 @@ struct tpm_vendor_specific {
> >
> >  #define TPM_PPI_VERSION_LEN		3
> >
> >+enum tpm_chip_flags {
> >+	TPM_CHIP_FLAG_TPM2	= BIT(0),
> >+};
> >+
> >  struct tpm_chip {
> >  	struct device *pdev;	/* Device stuff */
> >  	struct device dev;
> >  	struct cdev cdev;
> >
> >  	const struct tpm_class_ops *ops;
> >+	unsigned int flags;
> >
> >  	int dev_num;		/* /dev/tpm# */
> >  	char devname[7];
> >@@ -362,3 +418,14 @@ static inline void tpm_remove_ppi(struct tpm_chip *chip)
> >  {
> >  }
> >  #endif
> >+
> >+int tpm2_startup(struct tpm_chip *chip, __be16 startup_type);
> >+int tpm2_pcr_read(struct tpm_chip *chip, int pcr_idx, u8 *res_buf);
> >+int tpm2_pcr_extend(struct tpm_chip *chip, int pcr_idx, const u8 *hash);
> >+int tpm2_get_random(struct tpm_chip *chip, u8 *out, size_t max);
> >+
> >+extern ssize_t tpm2_get_tpm_pt(struct tpm_chip *chip, u32 property_id,
> >+			       u32 *value, const char *desc);
> >+extern unsigned long tpm2_calc_ordinal_duration(struct tpm_chip *, u32);
> >+extern int tpm2_do_selftest(struct tpm_chip *chip);
> >+extern int tpm2_gen_interrupt(struct tpm_chip *chip);
> >diff --git a/drivers/char/tpm/tpm2-cmd.c b/drivers/char/tpm/tpm2-cmd.c
> >new file mode 100644
> >index 0000000..458a17d
> >--- /dev/null
> >+++ b/drivers/char/tpm/tpm2-cmd.c
> >@@ -0,0 +1,566 @@
> >+/*
> >+ * Copyright (C) 2014 Intel Corporation
> >+ *
> >+ * Authors:
> >+ * Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> >+ *
> >+ * Maintained by: <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
> >+ *
> >+ * This file contains TPM2 protocol implementations of the commands
> >+ * used by the kernel internally.
> >+ *
> >+ * This program is free software; you can redistribute it and/or
> >+ * modify it under the terms of the GNU General Public License
> >+ * as published by the Free Software Foundation; version 2
> >+ * of the License.
> >+ */
> >+
> >+#include "tpm.h"
> >+
> >+struct tpm2_startup_in {
> >+	__be16	startup_type;
> >+} __packed;
> >+
> >+struct tpm2_self_test_in {
> >+	u8	full_test;
> >+} __packed;
> >+
> >+struct tpm2_pcr_read_in {
> >+	__be32	pcr_selects_cnt;
> >+	__be16	hash_alg;
> >+	u8	pcr_select_size;
> >+	u8	pcr_select[TPM2_PCR_SELECT_MIN];
> >+} __packed;
> >+
> >+struct tpm2_pcr_read_out {
> >+	__be32	update_cnt;
> >+	__be32	pcr_selects_cnt;
> >+	__be16	hash_alg;
> >+	u8	pcr_select_size;
> >+	u8	pcr_select[TPM2_PCR_SELECT_MIN];
> >+	__be32	digests_cnt;
> >+	__be16	digest_size;
> >+	u8	digest[TPM_DIGEST_SIZE];
> >+} __packed;
> >+
> >+struct tpm2_null_auth_area {
> >+	__be32			handle;
> >+	__be16			nonce_size;
> >+	u8			attributes;
> >+	__be16			auth_size;
> >+} __packed;
> >+
> >+struct tpm2_pcr_extend_in {
> >+	__be32				pcr_idx;
> >+	__be32				auth_area_size;
> >+	struct tpm2_null_auth_area	auth_area;
> >+	__be32				digest_cnt;
> >+	__be16				hash_alg;
> >+	u8				digest[TPM_DIGEST_SIZE];
> >+} __packed;
> >+
> >+struct tpm2_get_tpm_pt_in {
> >+	__be32	cap_id;
> >+	__be32	property_id;
> >+	__be32	property_cnt;
> >+} __packed;
> >+
> >+struct tpm2_get_tpm_pt_out {
> >+	u8	more_data;
> >+	__be32	subcap_id;
> >+	__be32	property_cnt;
> >+	__be32	property_id;
> >+	__be32	value;
> >+} __packed;
> >+
> >+struct tpm2_get_random_in {
> >+	__be16	size;
> >+} __packed;
> >+
> >+struct tpm2_get_random_out {
> >+	__be16	size;
> >+	u8	buffer[TPM_MAX_RNG_DATA];
> >+} __packed;
> >+
> >+union tpm2_cmd_params {
> >+	struct	tpm2_startup_in		startup_in;
> >+	struct	tpm2_self_test_in	selftest_in;
> >+	struct	tpm2_pcr_read_in	pcrread_in;
> >+	struct	tpm2_pcr_read_out	pcrread_out;
> >+	struct	tpm2_pcr_extend_in	pcrextend_in;
> >+	struct	tpm2_get_tpm_pt_in	get_tpm_pt_in;
> >+	struct	tpm2_get_tpm_pt_out	get_tpm_pt_out;
> >+	struct	tpm2_get_random_in	getrandom_in;
> >+	struct	tpm2_get_random_out	getrandom_out;
> >+};
> >+
> >+struct tpm2_cmd {
> >+	tpm_cmd_header		header;
> >+	union tpm2_cmd_params	params;
> >+} __packed;
> >+
> >+/*
> >+ * Array with one entry per ordinal defining the maximum amount
> >+ * of time the chip could take to return the result. The values
> >+ * of the SHORT, MEDIUM, and LONG durations are taken from the
> >+ * PC Client Profile (PTP) specification.
> >+ */
> >+static const u8 tpm2_ordinal_duration[TPM2_CC_LAST - TPM2_CC_FIRST + 1] = {
> >+	TPM_UNDEFINED,		/* 11F */
> >+	TPM_UNDEFINED,		/* 120 */
> >+	TPM_LONG,		/* 121 */
> >+	TPM_UNDEFINED,		/* 122 */
> >+	TPM_UNDEFINED,		/* 123 */
> >+	TPM_UNDEFINED,		/* 124 */
> >+	TPM_UNDEFINED,		/* 125 */
> >+	TPM_UNDEFINED,		/* 126 */
> >+	TPM_UNDEFINED,		/* 127 */
> >+	TPM_UNDEFINED,		/* 128 */
> >+	TPM_LONG,		/* 129 */
> >+	TPM_UNDEFINED,		/* 12a */
> >+	TPM_UNDEFINED,		/* 12b */
> >+	TPM_UNDEFINED,		/* 12c */
> >+	TPM_UNDEFINED,		/* 12d */
> >+	TPM_UNDEFINED,		/* 12e */
> >+	TPM_UNDEFINED,		/* 12f */
> >+	TPM_UNDEFINED,		/* 130 */
> >+	TPM_UNDEFINED,		/* 131 */
> >+	TPM_UNDEFINED,		/* 132 */
> >+	TPM_UNDEFINED,		/* 133 */
> >+	TPM_UNDEFINED,		/* 134 */
> >+	TPM_UNDEFINED,		/* 135 */
> >+	TPM_UNDEFINED,		/* 136 */
> >+	TPM_UNDEFINED,		/* 137 */
> >+	TPM_UNDEFINED,		/* 138 */
> >+	TPM_UNDEFINED,		/* 139 */
> >+	TPM_UNDEFINED,		/* 13a */
> >+	TPM_UNDEFINED,		/* 13b */
> >+	TPM_UNDEFINED,		/* 13c */
> >+	TPM_UNDEFINED,		/* 13d */
> >+	TPM_MEDIUM,		/* 13e */
> >+	TPM_UNDEFINED,		/* 13f */
> >+	TPM_UNDEFINED,		/* 140 */
> >+	TPM_UNDEFINED,		/* 141 */
> >+	TPM_UNDEFINED,		/* 142 */
> >+	TPM_LONG,		/* 143 */
> >+	TPM_MEDIUM,		/* 144 */
> >+	TPM_UNDEFINED,		/* 145 */
> >+	TPM_UNDEFINED,		/* 146 */
> >+	TPM_UNDEFINED,		/* 147 */
> >+	TPM_UNDEFINED,		/* 148 */
> >+	TPM_UNDEFINED,		/* 149 */
> >+	TPM_UNDEFINED,		/* 14a */
> >+	TPM_UNDEFINED,		/* 14b */
> >+	TPM_UNDEFINED,		/* 14c */
> >+	TPM_UNDEFINED,		/* 14d */
> >+	TPM_LONG,		/* 14e */
> >+	TPM_UNDEFINED,		/* 14f */
> >+	TPM_UNDEFINED,		/* 150 */
> >+	TPM_UNDEFINED,		/* 151 */
> >+	TPM_UNDEFINED,		/* 152 */
> >+	TPM_UNDEFINED,		/* 153 */
> >+	TPM_UNDEFINED,		/* 154 */
> >+	TPM_UNDEFINED,		/* 155 */
> >+	TPM_UNDEFINED,		/* 156 */
> >+	TPM_UNDEFINED,		/* 157 */
> >+	TPM_UNDEFINED,		/* 158 */
> >+	TPM_UNDEFINED,		/* 159 */
> >+	TPM_UNDEFINED,		/* 15a */
> >+	TPM_UNDEFINED,		/* 15b */
> >+	TPM_MEDIUM,		/* 15c */
> >+	TPM_UNDEFINED,		/* 15d */
> >+	TPM_UNDEFINED,		/* 15e */
> >+	TPM_UNDEFINED,		/* 15f */
> >+	TPM_UNDEFINED,		/* 160 */
> >+	TPM_UNDEFINED,		/* 161 */
> >+	TPM_UNDEFINED,		/* 162 */
> >+	TPM_UNDEFINED,		/* 163 */
> >+	TPM_UNDEFINED,		/* 164 */
> >+	TPM_UNDEFINED,		/* 165 */
> >+	TPM_UNDEFINED,		/* 166 */
> >+	TPM_UNDEFINED,		/* 167 */
> >+	TPM_UNDEFINED,		/* 168 */
> >+	TPM_UNDEFINED,		/* 169 */
> >+	TPM_UNDEFINED,		/* 16a */
> >+	TPM_UNDEFINED,		/* 16b */
> >+	TPM_UNDEFINED,		/* 16c */
> >+	TPM_UNDEFINED,		/* 16d */
> >+	TPM_UNDEFINED,		/* 16e */
> >+	TPM_UNDEFINED,		/* 16f */
> >+	TPM_UNDEFINED,		/* 170 */
> >+	TPM_UNDEFINED,		/* 171 */
> >+	TPM_UNDEFINED,		/* 172 */
> >+	TPM_UNDEFINED,		/* 173 */
> >+	TPM_UNDEFINED,		/* 174 */
> >+	TPM_UNDEFINED,		/* 175 */
> >+	TPM_UNDEFINED,		/* 176 */
> >+	TPM_LONG,		/* 177 */
> >+	TPM_UNDEFINED,		/* 178 */
> >+	TPM_UNDEFINED,		/* 179 */
> >+	TPM_MEDIUM,		/* 17a */
> >+	TPM_LONG,		/* 17b */
> >+	TPM_UNDEFINED,		/* 17c */
> >+	TPM_UNDEFINED,		/* 17d */
> >+	TPM_UNDEFINED,		/* 17e */
> >+	TPM_UNDEFINED,		/* 17f */
> >+	TPM_UNDEFINED,		/* 180 */
> >+	TPM_UNDEFINED,		/* 181 */
> >+	TPM_MEDIUM,		/* 182 */
> >+	TPM_UNDEFINED,		/* 183 */
> >+	TPM_UNDEFINED,		/* 184 */
> >+	TPM_MEDIUM,		/* 185 */
> >+	TPM_MEDIUM,		/* 186 */
> >+	TPM_UNDEFINED,		/* 187 */
> >+	TPM_UNDEFINED,		/* 188 */
> >+	TPM_UNDEFINED,		/* 189 */
> >+	TPM_UNDEFINED,		/* 18a */
> >+	TPM_UNDEFINED,		/* 18b */
> >+	TPM_UNDEFINED,		/* 18c */
> >+	TPM_UNDEFINED,		/* 18d */
> >+	TPM_UNDEFINED,		/* 18e */
> >+	TPM_UNDEFINED		/* 18f */
> >+};
> >+
> >+static const struct tpm_input_header tpm2_startup_header = {
> >+	.tag = cpu_to_be16(TPM2_ST_NO_SESSIONS),
> >+	.length = cpu_to_be32(12),
> 
> 12 -> sizeof(struct tpm_input_header) + sizeof(struct pm2_startup_in)
> 
> >+	.ordinal = cpu_to_be32(TPM2_CC_STARTUP)
> >+};
> >+
> >+/**
> >+ * tpm2_startup() - send startup command to the TPM chip
> >+ * @chip:		TPM chip to use.
> >+ * @startup_type	startup type. The value is either
> >+ *			TPM_SU_CLEAR or TPM_SU_STATE.
> >+ *
> >+ * 0 is returned when the operation is successful. When a negative number is
> >+ * returned it remarks a POSIX error code. When a positive number is returned
> >+ * it remarks a TPM error.
> 
> Replace 'When's with 'If's. (when being 'temporal')
> 
> >+ */
> >+int tpm2_startup(struct tpm_chip *chip, __be16 startup_type)
> >+{
> >+	struct tpm2_cmd cmd;
> >+
> >+	cmd.header.in = tpm2_startup_header;
> >+
> >+	cmd.params.startup_in.startup_type = startup_type;
> >+	return tpm_transmit_cmd(chip, &cmd, sizeof(cmd),
> >+				"attempting to start the TPM");
> >+}
> >+
> >+#define TPM2_PCR_READ_IN_SIZE \
> >+	(sizeof(struct tpm_input_header) + \
> >+	 sizeof(struct tpm2_pcr_read_in))
> >+
> 
> Ah! You could also use a #define above!
> 
> >+static const struct tpm_input_header tpm2_pcrread_header = {
> >+	.tag = cpu_to_be16(TPM2_ST_NO_SESSIONS),
> >+	.length = cpu_to_be32(TPM2_PCR_READ_IN_SIZE),
> >+	.ordinal = cpu_to_be32(TPM2_CC_PCR_READ)
> >+};
> >+
> >+/**
> >+ * tpm2_pcr_read() - read a PCR value
> >+ * @chip:	TPM chip to use.
> >+ * @pcr_idx:	index of the PCR to read.
> >+ * @ref_buf:	buffer to store the resulting hash,
> >+ *
> >+ * 0 is returned when the operation is successful. When a negative number is
> >+ * returned it remarks a POSIX error code. When a positive number is returned
> >+ * it remarks a TPM error.
> >+ */
> 
> Replace 'When's with 'If's. Also further below.
> 
> >+int tpm2_pcr_read(struct tpm_chip *chip, int pcr_idx, u8 *res_buf)
> >+{
> >+	int rc;
> >+	struct tpm2_cmd cmd;
> >+	u8 *buf;
> >+	int i, j;
> >+
> >+	if (pcr_idx >= TPM2_PLATFORM_PCR)
> >+		return -EINVAL;
> >+
> >+	cmd.header.in = tpm2_pcrread_header;
> >+	cmd.params.pcrread_in.pcr_selects_cnt = cpu_to_be32(1);
> >+	cmd.params.pcrread_in.hash_alg = cpu_to_be16(TPM2_ALG_SHA1);
> >+	cmd.params.pcrread_in.pcr_select_size = TPM2_PCR_SELECT_MIN;
> >+
> >+	for (i = 0; i < TPM2_PCR_SELECT_MIN; i++) {
> >+		j = pcr_idx - i * 8;
> >+
> >+		cmd.params.pcrread_in.pcr_select[i] =
> >+			(j >= 0 && j < 8) ? 1 << j : 0;
> >+	}
> 
> Umpf - what's this? You need to set the PCR index as an index in the
> bitfield?
> 
> pcr_idx >> 3  gives you the index into the array, assuming that [0] holds
> bits for PCR0 to 7.
> 
> 1 << (pcr_idx & 0x7) gives you the bit to set, assuming bit 0 is to be set
> for PCR 0
> 1 << (7- (pcr_idx & 0x7)) gives you the bit to set, assuming bit 7 is to be
> set for PCR 0.
> 
> memset(cmd.params.pcrread_in.pcr_select, 0,
> sizeof(cmd.params.pcrread_in.pcr_select));
> cmd.params.pcrread_in.pcr_select[pcr_idx >> 3] = 1 << (pcr_idx & 0x7);

Just sloppy and ugly code that nobody has commented so far and since it has
worked I haven't really give it much thought :) Will definitely clean
that mess, thanks.

/Jarkko
