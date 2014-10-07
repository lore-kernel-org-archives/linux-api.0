From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH v2 4/7] tpm: TPM 2.0 commands
Date: Tue,  7 Oct 2014 20:01:14 +0300
Message-ID: <1412701277-27794-5-git-send-email-jarkko.sakkinen@linux.intel.com>
References: <1412701277-27794-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1412701277-27794-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Huewe <peterhuewe@gmx.de>, Ashley Lai <ashley@ashleylai.com>, Marcel Selhorst <tpmdd@selhorst.net>
Cc: tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Will Arthur <will.c.arthur@intel.com>
List-Id: linux-api@vger.kernel.org

This patch contains the following internal helper functions for
tpm.ko:

- tpm2_get_random()
- tpm2_get_tpm_pt()
- tpm2_pcr_extend()
- tpm2_pcr_read()
- tpm2_startup()

and the following exported functions for implementing new device
drivers:

- tpm2_do_selftest()
- tpm2_calc_ordinal_durations()
- tpm2_gen_interrupt()

Functions that are defined in include/linux/tpm.h and tpm_transmit()
use TPM2 commands for TPM2 chips.

Added a new field "flags" to struct tpm_chip and enum tpm_chip_flags.
TPM2 chips can set TPM_CHIP_FLAG_TPM2 after tpm_chip_alloc() to
enable TPM2 commands.

The code for tpm2_calc_ordinal_duration() and tpm2_startup() is
derived from the code originally made by Will Arthur.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Signed-off-by: Will Arthur <will.c.arthur@intel.com>
---
 drivers/char/tpm/Makefile        |   2 +-
 drivers/char/tpm/tpm-interface.c |  24 +-
 drivers/char/tpm/tpm.h           |  66 +++++
 drivers/char/tpm/tpm2-cmd.c      | 543 +++++++++++++++++++++++++++++++++++++++
 4 files changed, 631 insertions(+), 4 deletions(-)
 create mode 100644 drivers/char/tpm/tpm2-cmd.c

diff --git a/drivers/char/tpm/Makefile b/drivers/char/tpm/Makefile
index 837da04..ae56af9 100644
--- a/drivers/char/tpm/Makefile
+++ b/drivers/char/tpm/Makefile
@@ -2,7 +2,7 @@
 # Makefile for the kernel tpm device drivers.
 #
 obj-$(CONFIG_TCG_TPM) += tpm.o
-tpm-y := tpm-interface.o tpm-dev.o tpm-sysfs.o tpm-chip.o
+tpm-y := tpm-interface.o tpm-dev.o tpm-sysfs.o tpm-chip.o tpm2-cmd.o
 tpm-$(CONFIG_ACPI) += tpm_ppi.o
 
 ifdef CONFIG_ACPI
diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index 1ce3ad3..ec28b5f 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -360,7 +360,10 @@ static ssize_t tpm_transmit(struct tpm_chip *chip, const char *buf,
 	if (chip->vendor.irq)
 		goto out_recv;
 
-	stop = jiffies + tpm_calc_ordinal_duration(chip, ordinal);
+	if (chip->flags & TPM_CHIP_FLAG_TPM2)
+		stop = jiffies + tpm2_calc_ordinal_duration(chip, ordinal);
+	else
+		stop = jiffies + tpm_calc_ordinal_duration(chip, ordinal);
 	do {
 		u8 status = chip->ops->status(chip);
 		if ((status & chip->ops->req_complete_mask) ==
@@ -482,7 +485,7 @@ static const struct tpm_input_header tpm_startup_header = {
 static int tpm_startup(struct tpm_chip *chip, __be16 startup_type)
 {
 	struct tpm_cmd_t start_cmd;
-	start_cmd.header.in = tpm_startup_header;
+
 	start_cmd.params.startup_in.startup_type = startup_type;
 	return tpm_transmit_cmd(chip, &start_cmd, TPM_INTERNAL_RESULT_SIZE,
 				"attempting to start the TPM");
@@ -679,7 +682,10 @@ int tpm_pcr_read(u32 chip_num, int pcr_idx, u8 *res_buf)
 	chip = tpm_chip_find_get(chip_num);
 	if (chip == NULL)
 		return -ENODEV;
-	rc = tpm_pcr_read_dev(chip, pcr_idx, res_buf);
+	if (chip->flags & TPM_CHIP_FLAG_TPM2)
+		rc = tpm2_pcr_read(chip, pcr_idx, res_buf);
+	else
+		rc = tpm_pcr_read_dev(chip, pcr_idx, res_buf);
 	tpm_chip_put(chip);
 	return rc;
 }
@@ -713,6 +719,12 @@ int tpm_pcr_extend(u32 chip_num, int pcr_idx, const u8 *hash)
 	if (chip == NULL)
 		return -ENODEV;
 
+	if (chip->flags & TPM_CHIP_FLAG_TPM2) {
+		rc = tpm2_pcr_extend(chip, pcr_idx, hash);
+		tpm_chip_put(chip);
+		return rc;
+	}
+
 	cmd.header.in = pcrextend_header;
 	cmd.params.pcrextend_in.pcr_idx = cpu_to_be32(pcr_idx);
 	memcpy(cmd.params.pcrextend_in.hash, hash, TPM_DIGEST_SIZE);
@@ -986,6 +998,12 @@ int tpm_get_random(u32 chip_num, u8 *out, size_t max)
 	if (chip == NULL)
 		return -ENODEV;
 
+	if (chip->flags & TPM_CHIP_FLAG_TPM2) {
+		err = tpm2_get_random(chip, out, max);
+		tpm_chip_put(chip);
+		return err;
+	}
+
 	do {
 		tpm_cmd.header.in = tpm_getrandom_header;
 		tpm_cmd.params.getrandom_in.num_bytes = cpu_to_be32(num_bytes);
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 5eb89897..d141639 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -61,6 +61,57 @@ enum tpm_duration {
 #define TPM_ERR_INVALID_POSTINIT 38
 
 #define TPM_HEADER_SIZE		10
+
+enum tpm2_const {
+	TPM2_PLATFORM_PCR	= 24,
+	TPM2_PCR_SELECT_MIN	= ((TPM2_PLATFORM_PCR + 7) / 8),
+	TPM2_TIMEOUT_A		= 750 * 1000,
+	TPM2_TIMEOUT_B		= 2000 * 1000,
+	TPM2_TIMEOUT_C		= 200 * 1000,
+	TPM2_TIMEOUT_D		= 30 * 1000,
+	TPM2_DURATION_SHORT	= 20 * 1000,
+	TPM2_DURATION_MEDIUM	= 750 * 1000,
+	TPM2_DURATION_LONG	= 2000 * 1000,
+};
+
+enum tpm2_structures {
+	TPM2_ST_NO_SESSIONS	= 0x8001,
+	TPM2_ST_SESSIONS	= 0x8002,
+};
+
+enum tpm2_return_codes {
+	TPM2_RC_TESTING		= 0x090A,
+	TPM2_RC_DISABLED	= 0x0120,
+};
+
+enum tpm2_algorithms {
+	TPM2_ALG_SHA1		= 0x0004,
+};
+
+enum tpm2_command_codes {
+	TPM2_CC_FIRST		= 0x011F,
+	TPM2_CC_SELF_TEST	= 0x0143,
+	TPM2_CC_STARTUP		= 0x0144,
+	TPM2_CC_GET_CAPABILITY	= 0x017A,
+	TPM2_CC_GET_RANDOM	= 0x017B,
+	TPM2_CC_PCR_READ	= 0x017E,
+	TPM2_CC_PCR_EXTEND	= 0x0182,
+	TPM2_CC_LAST		= 0x018F,
+};
+
+enum tpm2_permanent_handles {
+	TPM2_RS_PW		= 0x40000009,
+};
+
+enum tpm2_capabilities {
+	TPM2_CAP_TPM_PROPERTIES = 6,
+};
+
+enum tpm2_startup_types {
+	TPM2_SU_CLEAR	= 0x0000,
+	TPM2_SU_STATE	= 0x0001,
+};
+
 struct tpm_chip;
 
 struct tpm_vendor_specific {
@@ -94,9 +145,14 @@ struct tpm_vendor_specific {
 #define TPM_VID_WINBOND  0x1050
 #define TPM_VID_STM      0x104A
 
+enum tpm_chip_flags {
+	TPM_CHIP_FLAG_TPM2	= BIT(0),
+};
+
 struct tpm_chip {
 	struct device *dev;	/* Device stuff */
 	const struct tpm_class_ops *ops;
+	unsigned int flags;
 
 	int dev_num;		/* /dev/tpm# */
 	char devname[7];
@@ -353,3 +409,13 @@ static inline void tpm_remove_ppi(struct kobject *parent)
 {
 }
 #endif
+
+int tpm2_startup(struct tpm_chip *chip, __be16 startup_type);
+int tpm2_pcr_read(struct tpm_chip *chip, int pcr_idx, u8 *res_buf);
+int tpm2_pcr_extend(struct tpm_chip *chip, int pcr_idx, const u8 *hash);
+int tpm2_get_random(struct tpm_chip *chip, u8 *out, size_t max);
+
+extern ssize_t tpm2_get_tpm_pt(struct tpm_chip *chip, u32 property_id,
+			       u32* value, const char *desc);
+extern unsigned long tpm2_calc_ordinal_duration(struct tpm_chip *, u32);
+extern int tpm2_do_selftest(struct tpm_chip *chip);
diff --git a/drivers/char/tpm/tpm2-cmd.c b/drivers/char/tpm/tpm2-cmd.c
new file mode 100644
index 0000000..e0c455d
--- /dev/null
+++ b/drivers/char/tpm/tpm2-cmd.c
@@ -0,0 +1,543 @@
+/*
+ * Copyright (C) 2014 Intel Corporation
+ *
+ * Authors:
+ * Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
+ *
+ * Maintained by: <tpmdd-devel@lists.sourceforge.net>
+ *
+ * This file contains TPM2 protocol implementations of the commands
+ * used by the kernel internally.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; version 2
+ * of the License.
+ */
+
+#include "tpm.h"
+
+struct tpm2_startup_in {
+	__be16	startup_type;
+} __packed;
+
+struct tpm2_self_test_in {
+	u8	full_test;
+} __packed;
+
+struct tpm2_pcr_read_in {
+	__be32	pcr_selects_cnt;
+	__be16	hash_alg;
+	u8	pcr_select_size;
+	u8	pcr_select[TPM2_PCR_SELECT_MIN];
+} __packed;
+
+struct tpm2_pcr_read_out {
+	__be32	update_cnt;
+	__be32	pcr_selects_cnt;
+	__be16	hash_alg;
+	u8	pcr_select_size;
+	u8	pcr_select[TPM2_PCR_SELECT_MIN];
+	__be32	digests_cnt;
+	__be16	digest_size;
+	u8	digest[TPM_DIGEST_SIZE];
+} __packed;
+
+struct tpm2_null_auth_area {
+	__be32			handle;
+	__be16			nonce_size;
+	u8			attributes;
+	__be16			auth_size;
+} __packed;
+
+struct tpm2_pcr_extend_in {
+	__be32				pcr_idx;
+	__be32				auth_area_size;
+	struct tpm2_null_auth_area	auth_area;
+	__be32				digest_cnt;
+	__be16				hash_alg;
+	u8				digest[TPM_DIGEST_SIZE];
+} __packed;
+
+struct tpm2_get_tpm_pt_in {
+	__be32	cap_id;
+	__be32	property_id;
+	__be32	property_cnt;
+} __packed;
+
+struct tpm2_get_tpm_pt_out {
+	u8	more_data;
+	__be32	subcap_id;
+	__be32	property_cnt;
+	__be32	property_id;
+	__be32	value;
+} __packed;
+
+struct tpm2_get_random_in {
+	__be16	size;
+} __packed;
+
+struct tpm2_get_random_out {
+	__be16	size;
+	u8	buffer[TPM_MAX_RNG_DATA];
+} __packed;
+
+union tpm2_cmd_params {
+	struct	tpm2_startup_in		startup_in;
+	struct	tpm2_self_test_in	selftest_in;
+	struct	tpm2_pcr_read_in	pcrread_in;
+	struct	tpm2_pcr_read_out	pcrread_out;
+	struct	tpm2_pcr_extend_in	pcrextend_in;
+	struct	tpm2_get_tpm_pt_in	get_tpm_pt_in;
+	struct	tpm2_get_tpm_pt_out	get_tpm_pt_out;
+	struct	tpm2_get_random_in	getrandom_in;
+	struct	tpm2_get_random_out	getrandom_out;
+};
+
+struct tpm2_cmd {
+	tpm_cmd_header		header;
+	union tpm2_cmd_params	params;
+} __packed;
+
+/*
+ * Array with one entry per ordinal defining the maximum amount
+ * of time the chip could take to return the result. The values
+ * of the SHORT, MEDIUM, and LONG durations are taken from the
+ * PC Client Profile (PTP) specification.
+ */
+static const u8 tpm2_ordinal_duration[TPM2_CC_LAST - TPM2_CC_FIRST + 1] = {
+	TPM_UNDEFINED,		/* 11F */
+	TPM_UNDEFINED,		/* 120 */
+	TPM_LONG,		/* 121 */
+	TPM_UNDEFINED,		/* 122 */
+	TPM_UNDEFINED,		/* 123 */
+	TPM_UNDEFINED,		/* 124 */
+	TPM_UNDEFINED,		/* 125 */
+	TPM_UNDEFINED,		/* 126 */
+	TPM_UNDEFINED,		/* 127 */
+	TPM_UNDEFINED,		/* 128 */
+	TPM_LONG,		/* 129 */
+	TPM_UNDEFINED,		/* 12a */
+	TPM_UNDEFINED,		/* 12b */
+	TPM_UNDEFINED,		/* 12c */
+	TPM_UNDEFINED,		/* 12d */
+	TPM_UNDEFINED,		/* 12e */
+	TPM_UNDEFINED,		/* 12f */
+	TPM_UNDEFINED,		/* 130 */
+	TPM_UNDEFINED,		/* 131 */
+	TPM_UNDEFINED,		/* 132 */
+	TPM_UNDEFINED,		/* 133 */
+	TPM_UNDEFINED,		/* 134 */
+	TPM_UNDEFINED,		/* 135 */
+	TPM_UNDEFINED,		/* 136 */
+	TPM_UNDEFINED,		/* 137 */
+	TPM_UNDEFINED,		/* 138 */
+	TPM_UNDEFINED,		/* 139 */
+	TPM_UNDEFINED,		/* 13a */
+	TPM_UNDEFINED,		/* 13b */
+	TPM_UNDEFINED,		/* 13c */
+	TPM_UNDEFINED,		/* 13d */
+	TPM_MEDIUM,		/* 13e */
+	TPM_UNDEFINED,		/* 13f */
+	TPM_UNDEFINED,		/* 140 */
+	TPM_UNDEFINED,		/* 141 */
+	TPM_UNDEFINED,		/* 142 */
+	TPM_LONG,		/* 143 */
+	TPM_MEDIUM,		/* 144 */
+	TPM_UNDEFINED,		/* 145 */
+	TPM_UNDEFINED,		/* 146 */
+	TPM_UNDEFINED,		/* 147 */
+	TPM_UNDEFINED,		/* 148 */
+	TPM_UNDEFINED,		/* 149 */
+	TPM_UNDEFINED,		/* 14a */
+	TPM_UNDEFINED,		/* 14b */
+	TPM_UNDEFINED,		/* 14c */
+	TPM_UNDEFINED,		/* 14d */
+	TPM_LONG,		/* 14e */
+	TPM_UNDEFINED,		/* 14f */
+	TPM_UNDEFINED,		/* 150 */
+	TPM_UNDEFINED,		/* 151 */
+	TPM_UNDEFINED,		/* 152 */
+	TPM_UNDEFINED,		/* 153 */
+	TPM_UNDEFINED,		/* 154 */
+	TPM_UNDEFINED,		/* 155 */
+	TPM_UNDEFINED,		/* 156 */
+	TPM_UNDEFINED,		/* 157 */
+	TPM_UNDEFINED,		/* 158 */
+	TPM_UNDEFINED,		/* 159 */
+	TPM_UNDEFINED,		/* 15a */
+	TPM_UNDEFINED,		/* 15b */
+	TPM_MEDIUM,		/* 15c */
+	TPM_UNDEFINED,		/* 15d */
+	TPM_UNDEFINED,		/* 15e */
+	TPM_UNDEFINED,		/* 15f */
+	TPM_UNDEFINED,		/* 160 */
+	TPM_UNDEFINED,		/* 161 */
+	TPM_UNDEFINED,		/* 162 */
+	TPM_UNDEFINED,		/* 163 */
+	TPM_UNDEFINED,		/* 164 */
+	TPM_UNDEFINED,		/* 165 */
+	TPM_UNDEFINED,		/* 166 */
+	TPM_UNDEFINED,		/* 167 */
+	TPM_UNDEFINED,		/* 168 */
+	TPM_UNDEFINED,		/* 169 */
+	TPM_UNDEFINED,		/* 16a */
+	TPM_UNDEFINED,		/* 16b */
+	TPM_UNDEFINED,		/* 16c */
+	TPM_UNDEFINED,		/* 16d */
+	TPM_UNDEFINED,		/* 16e */
+	TPM_UNDEFINED,		/* 16f */
+	TPM_UNDEFINED,		/* 170 */
+	TPM_UNDEFINED,		/* 171 */
+	TPM_UNDEFINED,		/* 172 */
+	TPM_UNDEFINED,		/* 173 */
+	TPM_UNDEFINED,		/* 174 */
+	TPM_UNDEFINED,		/* 175 */
+	TPM_UNDEFINED,		/* 176 */
+	TPM_LONG,		/* 177 */
+	TPM_UNDEFINED,		/* 178 */
+	TPM_UNDEFINED,		/* 179 */
+	TPM_MEDIUM,		/* 17a */
+	TPM_LONG,		/* 17b */
+	TPM_UNDEFINED,		/* 17c */
+	TPM_UNDEFINED,		/* 17d */
+	TPM_UNDEFINED,		/* 17e */
+	TPM_UNDEFINED,		/* 17f */
+	TPM_UNDEFINED,		/* 180 */
+	TPM_UNDEFINED,		/* 181 */
+	TPM_MEDIUM,		/* 182 */
+	TPM_UNDEFINED,		/* 183 */
+	TPM_UNDEFINED,		/* 184 */
+	TPM_MEDIUM,		/* 185 */
+	TPM_MEDIUM,		/* 186 */
+	TPM_UNDEFINED,		/* 187 */
+	TPM_UNDEFINED,		/* 188 */
+	TPM_UNDEFINED,		/* 189 */
+	TPM_UNDEFINED,		/* 18a */
+	TPM_UNDEFINED,		/* 18b */
+	TPM_UNDEFINED,		/* 18c */
+	TPM_UNDEFINED,		/* 18d */
+	TPM_UNDEFINED,		/* 18e */
+	TPM_UNDEFINED		/* 18f */
+};
+
+static const struct tpm_input_header tpm2_startup_header = {
+	.tag = cpu_to_be16(TPM2_ST_NO_SESSIONS),
+	.length = cpu_to_be32(12),
+	.ordinal = cpu_to_be32(TPM2_CC_STARTUP)
+};
+
+/**
+ * tpm2_startup() - send startup command to the TPM chip
+ * @chip:		TPM chip to use.
+ * @startup_type	startup type. The value is either
+ * 			TPM_SU_CLEAR or TPM_SU_STATE.
+ *
+ * 0 is returned when the operation is succesful. When a negative number is
+ * returned it remarks a POSIX error code. When a positive number is returned
+ * it remarks a TPM error.
+ */
+int tpm2_startup(struct tpm_chip *chip, __be16 startup_type)
+{
+	struct tpm2_cmd cmd;
+
+	cmd.header.in = tpm2_startup_header;
+
+	cmd.params.startup_in.startup_type = startup_type;
+	return tpm_transmit_cmd(chip, &cmd, sizeof(cmd),
+				"attempting to start the TPM");
+}
+
+#define TPM2_PCR_READ_IN_SIZE \
+	(sizeof(struct tpm_input_header) + \
+	 sizeof(struct tpm2_pcr_read_in))
+
+static const struct tpm_input_header tpm2_pcrread_header = {
+	.tag = cpu_to_be16(TPM2_ST_NO_SESSIONS),
+	.length = cpu_to_be32(TPM2_PCR_READ_IN_SIZE),
+	.ordinal = cpu_to_be32(TPM2_CC_PCR_READ)
+};
+
+/**
+ * tpm2_pcr_read() - read a PCR value
+ * @chip:	TPM chip to use.
+ * @pcr_idx:	index of the PCR to read.
+ * @ref_buf:	buffer to store the resulting hash,
+ *
+ * 0 is returned when the operation is succesful. When a negative number is
+ * returned it remarks a POSIX error code. When a positive number is returned
+ * it remarks a TPM error.
+ */
+int tpm2_pcr_read(struct tpm_chip *chip, int pcr_idx, u8 *res_buf)
+{
+	int rc;
+	struct tpm2_cmd cmd;
+	u8 *buf;
+	int i, j;
+
+	if (pcr_idx >= TPM2_PLATFORM_PCR)
+		return -EINVAL;
+
+	cmd.header.in = tpm2_pcrread_header;
+	cmd.params.pcrread_in.pcr_selects_cnt = cpu_to_be32(1);
+	cmd.params.pcrread_in.hash_alg = cpu_to_be16(TPM2_ALG_SHA1);
+	cmd.params.pcrread_in.pcr_select_size = TPM2_PCR_SELECT_MIN;
+
+	for (i = 0; i < TPM2_PCR_SELECT_MIN; i++) {
+		j = pcr_idx - i * 8;
+
+		cmd.params.pcrread_in.pcr_select[i] =
+			(j >= 0 && j < 8) ? 1 << j : 0;
+	}
+
+	rc = tpm_transmit_cmd(chip, &cmd, sizeof(cmd),
+			      "attempting to read a pcr value");
+
+	if (rc == 0) {
+		buf = cmd.params.pcrread_out.digest;
+		memcpy(res_buf, buf, TPM_DIGEST_SIZE);
+	}
+
+	return rc;
+}
+
+/**
+ * tpm2_pcr_extend() - extend a PCR value
+ * @chip:	TPM chip to use.
+ * @pcr_idx:	index of the PCR.
+ * @hash:	hash value to use for the extend operation.
+ *
+ * 0 is returned when the operation is succesful. When a negative number is
+ * returned it remarks a POSIX error code. When a positive number is returned
+ * it remarks a TPM error.
+ */
+static const struct tpm_input_header tpm2_pcrextend_header = {
+	.tag = cpu_to_be16(TPM2_ST_SESSIONS),
+	.length = cpu_to_be32(sizeof(struct tpm_input_header) +
+			      sizeof(struct tpm2_pcr_extend_in)),
+	.ordinal = cpu_to_be32(TPM2_CC_PCR_EXTEND)
+};
+
+int tpm2_pcr_extend(struct tpm_chip *chip, int pcr_idx, const u8 *hash)
+{
+	struct tpm2_cmd cmd;
+	int rc;
+
+	cmd.header.in = tpm2_pcrextend_header;
+	cmd.params.pcrextend_in.pcr_idx = cpu_to_be32(pcr_idx);
+	cmd.params.pcrextend_in.auth_area_size =
+		cpu_to_be32(sizeof(struct tpm2_null_auth_area));
+	cmd.params.pcrextend_in.auth_area.handle =
+		cpu_to_be32(TPM2_RS_PW);
+	cmd.params.pcrextend_in.auth_area.nonce_size = 0;
+	cmd.params.pcrextend_in.auth_area.attributes = 0;
+	cmd.params.pcrextend_in.auth_area.auth_size = 0;
+	cmd.params.pcrextend_in.digest_cnt = cpu_to_be32(1);
+	cmd.params.pcrextend_in.hash_alg = cpu_to_be16(TPM2_ALG_SHA1);
+	memcpy(cmd.params.pcrextend_in.digest, hash, TPM_DIGEST_SIZE);
+
+	rc = tpm_transmit_cmd(chip, &cmd, sizeof(cmd),
+			      "attempting extend a PCR value");
+
+	return rc;
+}
+
+static const struct tpm_input_header tpm2_getrandom_header = {
+	.tag = cpu_to_be16(TPM2_ST_NO_SESSIONS),
+	.length = cpu_to_be32(sizeof(struct tpm_input_header) +
+			      sizeof(struct tpm2_get_random_in)),
+	.ordinal = cpu_to_be32(TPM2_CC_GET_RANDOM)
+};
+
+/**
+ * tpm2_get_random() - get random bytes from the TPM RNG
+ * @chip: TPM chip to use
+ * @out: destination buffer for the random bytes
+ * @max: the max number of bytes to write to @out
+ *
+ * 0 is returned when the operation is succesful. When a negative number is
+ * returned it remarks a POSIX error code. When a positive number is returned
+ * it remarks a TPM error.
+ */
+int tpm2_get_random(struct tpm_chip *chip, u8 *out, size_t max)
+{
+	struct tpm2_cmd cmd;
+	u32 recd, num_bytes = min_t(u32, max, TPM_MAX_RNG_DATA);
+	int err, total = 0, retries = 5;
+	u8 *dest = out;
+
+	if (!out || !num_bytes || max > TPM_MAX_RNG_DATA)
+		return -EINVAL;
+
+	do {
+		cmd.header.in = tpm2_getrandom_header;
+		cmd.params.getrandom_in.size = cpu_to_be16(num_bytes);
+
+		err = tpm_transmit_cmd(chip, &cmd, sizeof(cmd),
+				       "attempting get random");
+		if (err)
+			break;
+
+		recd = be16_to_cpu(cmd.params.getrandom_out.size);
+		memcpy(dest, cmd.params.getrandom_out.buffer, recd);
+
+		dest += recd;
+		total += recd;
+		num_bytes -= recd;
+	} while (retries-- && total < max);
+
+	return total ? total : -EIO;
+}
+
+#define TPM2_GET_TPM_PT_IN_SIZE \
+	(sizeof(struct tpm_input_header) + \
+	 sizeof(struct tpm2_get_tpm_pt_in))
+
+static const struct tpm_input_header tpm2_get_tpm_pt_header = {
+	.tag = cpu_to_be16(TPM2_ST_NO_SESSIONS),
+	.length = cpu_to_be32(TPM2_GET_TPM_PT_IN_SIZE),
+	.ordinal = cpu_to_be32(TPM2_CC_GET_CAPABILITY)
+};
+
+/**
+ * tpm2_get_tpm_pt() - get value of a TPM_CAP_TPM_PROPERTIES type property
+ * @chip:		TPM chip to use.
+ * @property_id:	property ID.
+ * @value:		output variable.
+ * @desc:		passed to tpm_transmit_cmd()
+ *
+ * 0 is returned when the operation is succesful. When a negative number is
+ * returned it remarks a POSIX error code. When a positive number is returned
+ * it remarks a TPM error.
+ */
+ssize_t tpm2_get_tpm_pt(struct tpm_chip *chip, u32 property_id,  u32* value,
+			const char *desc)
+{
+	struct tpm2_cmd cmd;
+	int rc;
+
+	cmd.header.in = tpm2_get_tpm_pt_header;
+	cmd.params.get_tpm_pt_in.cap_id = cpu_to_be32(TPM2_CAP_TPM_PROPERTIES);
+	cmd.params.get_tpm_pt_in.property_id = property_id;
+	cmd.params.get_tpm_pt_in.property_cnt = cpu_to_be32(1);
+
+	rc = tpm_transmit_cmd(chip, &cmd, sizeof(cmd), desc);
+	if (!rc)
+		*value = cmd.params.get_tpm_pt_out.value;
+
+	return rc;
+}
+EXPORT_SYMBOL_GPL(tpm2_get_tpm_pt);
+
+/*
+ * tpm2_calc_ordinal_duration() - maximum duration for a command
+ * @chip: 	TPM chip to use.
+ * @ordinal:	command code number.
+ *
+ * 0 is returned when the operation is succesful. When a negative number is
+ * returned it remarks a POSIX error code. When a positive number is returned
+ * it remarks a TPM error.
+ */
+unsigned long tpm2_calc_ordinal_duration(struct tpm_chip *chip, u32 ordinal)
+{
+	int index = TPM_UNDEFINED;
+	int duration = 0;
+
+	if (ordinal >= TPM2_CC_FIRST && ordinal <= TPM2_CC_LAST)
+		index = tpm2_ordinal_duration[ordinal - TPM2_CC_FIRST];
+
+	if (index != TPM_UNDEFINED)
+		duration = chip->vendor.duration[index];
+	if (duration <= 0)
+		return 2 * 60 * HZ;
+	else
+		return duration;
+}
+EXPORT_SYMBOL_GPL(tpm2_calc_ordinal_duration);
+
+static const struct tpm_input_header tpm2_selftest_header = {
+	.tag = cpu_to_be16(TPM2_ST_NO_SESSIONS),
+	.length = cpu_to_be32(sizeof(struct tpm_input_header) +
+			      sizeof(struct tpm2_self_test_in)),
+	.ordinal = cpu_to_be32(TPM2_CC_SELF_TEST)
+};
+
+#define TPM2_SELF_TEST_IN_SIZE \
+	(sizeof(struct tpm_input_header) + sizeof(struct tpm2_self_test_in))
+
+/**
+ * tpm2_continue_selftest() - start a self test
+ * @chip: TPM chip to use
+ * @full: test all commands instead of testing only those that were not
+ *        previously tested.
+ *
+ * 0 is returned when the operation is succesful. When a negative number is
+ * returned it remarks a POSIX error code. When a positive number is returned
+ * it remarks a TPM error.
+ */
+static int tpm2_start_selftest(struct tpm_chip *chip, bool full)
+{
+	int rc;
+	struct tpm2_cmd cmd;
+
+	cmd.header.in = tpm2_selftest_header;
+	cmd.params.selftest_in.full_test = full;
+
+	rc = tpm_transmit_cmd(chip, &cmd, TPM2_SELF_TEST_IN_SIZE,
+			      "continue selftest");
+
+	return rc;
+}
+
+/**
+ * tpm2_do_selftest() - run a full self test
+ * @chip: TPM chip to use
+ *
+ * During the self test TPM2 commands return with the error code RC_TESTING.
+ * Waiting is done by issuing PCR read until it executes succesfully.
+ *
+ * 0 is returned when the operation is succesful. When a negative number is
+ * returned it remarks a POSIX error code. When a positive number is returned
+ * it remarks a TPM error.
+ */
+int tpm2_do_selftest(struct tpm_chip *chip)
+{
+	int rc;
+	unsigned int loops;
+	unsigned int delay_msec = 100;
+	unsigned long duration;
+	struct tpm2_cmd cmd;
+	int i;
+
+	duration = tpm2_calc_ordinal_duration(chip, TPM2_CC_SELF_TEST);
+
+	loops = jiffies_to_msecs(duration) / delay_msec;
+
+	rc = tpm2_start_selftest(chip, true);
+	if (rc)
+		return rc;
+
+	for (i = 0; i < loops; i++) {
+		/* Attempt to read a PCR value */
+		cmd.header.in = tpm2_pcrread_header;
+		cmd.params.pcrread_in.pcr_selects_cnt = cpu_to_be32(1);
+		cmd.params.pcrread_in.hash_alg = cpu_to_be16(TPM2_ALG_SHA1);
+		cmd.params.pcrread_in.pcr_select_size = TPM2_PCR_SELECT_MIN;
+		cmd.params.pcrread_in.pcr_select[0] = 0x01;
+		cmd.params.pcrread_in.pcr_select[1] = 0x00;
+		cmd.params.pcrread_in.pcr_select[2] = 0x00;
+
+		rc = tpm_transmit_cmd(chip, (u8 *) &cmd, sizeof(cmd), NULL);
+		if (rc < 0)
+			break;
+
+		rc = be32_to_cpu(cmd.header.out.return_code);
+		if (rc != TPM2_RC_TESTING)
+			break;
+
+		msleep(delay_msec);
+	}
+
+	return rc;
+}
+EXPORT_SYMBOL_GPL(tpm2_do_selftest);
-- 
2.1.0
