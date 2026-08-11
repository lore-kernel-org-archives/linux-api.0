Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC6B7353EEB;
	Tue, 11 Aug 2026 08:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786437113; cv=none; b=Mue3GupeApYbMn6ComP0cJeyJZ93FnjZhDXa8bfVgVhWAgCjHHeEm6miIJphERQadHR6XlAosTx/m2mvyjYaUivo0FTM12hXAHuhWJWPhZi8htrgVold/SO8sndykA5prAHvnxKJEHOuSzK7EC6/YL7XKehzMhuUfuMzimab+HY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786437113; c=relaxed/simple;
	bh=XxtMQMa3DWnbUEYiKI1HexTjUOrCLDNv+gFPU+EiYrs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sa8wlVzxLRvfmo3OmAguz3Yjj6ykHToU7uXlk27cZf+I4pUqPnjZ6uSgUKYLAt+BJkUXrarGwvyA6Z6mQvlBanSxZHS2NozlXGqACxE5QIcnAmhNdrqwwpGE7/DJnU8pdkz5b9QT+EbCqx+4W2leWK9NYRlEPy2DmhIrBdqlvqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NulNofAE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NulNofAE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C4031F000E9;
	Tue, 11 Aug 2026 08:31:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786437111;
	bh=q24FXb5XSOw6meqa4O771D1hDFpcGicSkaNFYx4f7GE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=NulNofAEBo2BnsIahUe5aGazyJKkC0SgBOdgAVDsoSNMobanFRaE8E+EoW2C9jKuD
	 iKSxpbpfe3CjNblRam6RUx4joDPwI7d2pZoSmxJooJ/xyheIFXFcsdec7rPIQUgGq5
	 ZW6IjiEnVBHtYqKZ6nN3e3fgzpSl5ha+0EY+JemW6VtQYWHvbjIG06uvP7AJWNGplV
	 t6T6CHt/xLzUf2mTjOXFXEJi/xwoMTS89mA/ngSo3Ee0iGtWE2Ph7pZF+GHbkDHex1
	 xrdkppSPfC0XSfqHNUILQiLiERLHsgh++8/r+AoxJ4hxUfNV3TltJ6Q+8oCSxEQA7U
	 PCkGHcIqZO5GA==
Date: Tue, 11 Aug 2026 10:31:47 +0200
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Saravanakrishnan Krishnamoorthy <skrishnamoorthy@rambus.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>, 
	Alex Ousherovitch <aousherovitch@rambus.com>, Conor Dooley <conor+dt@kernel.org>, 
	"David S. Miller" <davem@davemloft.net>, Herbert Xu <herbert@gondor.apana.org.au>, 
	Jonathan Corbet <corbet@lwn.net>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>, Rob Herring <robh@kernel.org>, 
	Shuah Khan <shuah@kernel.org>, Alexandre Ghiti <alex@ghiti.fr>, devicetree@vger.kernel.org, 
	Joel Wittenauer <Joel.Wittenauer@cryptography.com>, linux-api@vger.kernel.org, linux-crypto@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-riscv@lists.infradead.org, Shuah Khan <skhan@linuxfoundation.org>, 
	Thi Nguyen <thin@rambus.com>
Subject: Re: [PATCH v3 02/19] crypto: cmh - add core platform driver
Message-ID: <20260811-meerkat-of-excellent-satiation-d4c32f@quoll>
References: <20260806195519.2703224-1-skrishnamoorthy@rambus.com>
 <20260806195519.2703224-3-skrishnamoorthy@rambus.com>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260806195519.2703224-3-skrishnamoorthy@rambus.com>

On Thu, Aug 06, 2026 at 12:55:01PM -0700, Saravanakrishnan Krishnamoorthy wrote:
> These are the single-block cipher API used for software-fallback paths:
> CCM empty-input tag computation (2 ECB encryptions + XOR) and XCBC(SM4)
> empty-message workaround (3 ECB encryptions + XOR).  No public wrapper
> exists; this is the same pattern used by in-tree crypto/ccm.c,
> crypto/cmac.c, and crypto/xcbc.c.
> 
> Co-developed-by: Saravanakrishnan Krishnamoorthy <skrishnamoorthy@rambus.com>
> Signed-off-by: Saravanakrishnan Krishnamoorthy <skrishnamoorthy@rambus.com>
> Signed-off-by: Alex Ousherovitch <aousherovitch@rambus.com>
> Reviewed-by: Joel Wittenauer <Joel.Wittenauer@cryptography.com>
> Reviewed-by: Thi Nguyen <thin@rambus.com>

These two reviews did not happen, drop the tags. The code has trivial
mistakes from downstream code. Internal review would point these trivial
issues, so I do not believe you received valid, meaningful internal
review which would justify the tags.

> +#include <linux/module.h>
> +#include <linux/kernel.h>
> +#include <linux/slab.h>
> +#include <linux/io.h>
> +#include <linux/clk.h>
> +#include <linux/gpio/consumer.h>
> +#include <linux/dma-mapping.h>
> +#include <linux/platform_device.h>
> +#include <linux/of.h>
> +
> +#include "cmh.h"
> +#include "cmh_dma.h"
> +#include "cmh_mqi.h"
> +#include "cmh_txn.h"
> +#include "cmh_rh.h"
> +#include "cmh_registers.h"
> +#include "cmh_debugfs.h"
> +#include "cmh_sysfs.h"
> +
> +#include <linux/iopoll.h>
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Alex Ousherovitch <aousherovitch@rambus.com>");
> +MODULE_AUTHOR("Saravanakrishnan Krishnamoorthy <skrishnamoorthy@rambus.com>");
> +MODULE_AUTHOR("Joel Wittenauer <Joel.Wittenauer@cryptography.com>");
> +MODULE_DESCRIPTION("Rambus CryptoManager Hub (CMH) hardware crypto accelerator");
> +MODULE_ALIAS("platform:cmh");

Why?

> +MODULE_IMPORT_NS("CRYPTO_INTERNAL");

Why all this is in completely odd place, not next to the module init
code?

> +
> +#ifdef CONFIG_CRYPTO_DEV_CMH_DEBUG
> +static bool skip_fw_check;
> +module_param(skip_fw_check, bool, 0444);
> +MODULE_PARM_DESC(skip_fw_check,
> +		 "[debug] Skip eSW boot status check at probe (default: false)");
> +#else
> +#define skip_fw_check false
> +#endif
> +
> +/* Global device state (single-instance module) */
> +
> +static struct cmh_device *g_cmh_dev;

Eh, no. Don't implement singletons.

> +
> +/* SIC Sanity Check */
> +
> +static int cmh_check_sic(struct cmh_config *cfg)
> +{
> +	const u32 ready = SIC_SW_BOOT_STATUS_MISSION |
> +			  SIC_SW_BOOT_STATUS_MISSION2;
> +	u32 boot_status;
> +	u32 hw_version;
> +	u32 sw_boot;
> +	int ret;
> +
> +	boot_status = cmh_reg_read32(cfg->sic_mapped, R_SIC_BOOT_STATUS);
> +	hw_version  = cmh_reg_read32(cfg->sic_mapped, R_SIC_HW_VERSION0);
> +
> +	dev_info(cmh_dev(), "SIC boot_status=0x%08x hw_version=0x%08x\n",
> +		 boot_status, hw_version);
> +
> +	if ((boot_status & SIC_BOOT_STATUS_MASK) != SIC_BOOT_STATUS_PASS) {
> +		dev_err(cmh_dev(), "SIC boot status check failed (0x%02x != 0x%02x)\n",
> +			boot_status & SIC_BOOT_STATUS_MASK, SIC_BOOT_STATUS_PASS);
> +		return -EIO;
> +	}
> +
> +	/*
> +	 * Wait for eSW readiness: MISSION signals the primary VCQ engine,
> +	 * MISSION2 the sidecar engine (set asynchronously).  The driver
> +	 * uses both, so require both bits.
> +	 */
> +	ret = read_poll_timeout(ioread32, sw_boot,
> +				(sw_boot & ready) == ready,
> +				1000,
> +				(unsigned long)cfg->fw_ready_timeout_ms * 1000UL,
> +				false,
> +				cfg->sic_mapped + R_SIC_SW_BOOT_STATUS);
> +	if (ret) {
> +		sw_boot = cmh_reg_read32(cfg->sic_mapped, R_SIC_SW_BOOT_STATUS);
> +		dev_err(cmh_dev(), "CMH eSW not ready (sw_boot_status=0x%08x, timeout=%ums)\n",
> +			sw_boot, cfg->fw_ready_timeout_ms);
> +		return -ETIMEDOUT;
> +	}
> +
> +	dev_info(cmh_dev(), "CMH eSW fully operational (sw_boot_status=0x%08x)\n",
> +		 sw_boot);

Drop

> +
> +	return 0;
> +}
> +
> +/* Module Init -- platform driver probe */
> +
> +static int cmh_probe(struct platform_device *pdev)
> +{
> +	struct cmh_device *dev;
> +	struct cmh_config *cfg;
> +	struct clk_bulk_data *clks;
> +	struct gpio_desc *reset;
> +	unsigned int i;
> +	int ret;
> +
> +	/* Single-instance guard: reject if already probed */
> +	if (g_cmh_dev)
> +		return -EBUSY;

NAK

> +
> +	dev_info(&pdev->dev, "loading v%s\n", CMH_VERSION);

NAK and internal review should tell you that

> +
> +	dev = devm_kzalloc(&pdev->dev, sizeof(*dev), GFP_KERNEL);
> +	if (!dev)
> +		return -ENOMEM;
> +
> +	dev->dev = &pdev->dev;
> +	cfg = &dev->config;
> +
> +	/* Declare DMA addressing capability */
> +	ret = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
> +	if (ret) {
> +		dev_err(&pdev->dev, "dma_set_mask_and_coherent failed (rc=%d)\n",
> +			ret);
> +		goto err_free_dev;
> +	}
> +
> +	/* Initialize DMA backend (standard API or FPGA pool) */
> +	ret = cmh_dma_init(pdev);
> +	if (ret) {
> +		dev_err(&pdev->dev, "DMA init failed (rc=%d)\n", ret);
> +		goto err_free_dev;
> +	}
> +
> +	/* Step 1: Parse and validate configuration (DT + module params) */
> +	ret = cmh_config_init(cfg, pdev);
> +	if (ret)
> +		goto err_dma_init;
> +
> +	dev_info(cmh_dev(), "sic_base=0x%llx size=0x%zx mbx_count=%u\n",
> +		 (unsigned long long)cfg->sic_base, cfg->sic_size,
> +		 cfg->mbx_count);

How many dev_info are you going to print?

> +
> +	/*
> +	 * Enable functional clocks and release reset.  Both are optional --
> +	 * integrations where a separate management/power controller owns the
> +	 * clock and reset lines describe neither, and these calls are
> +	 * no-ops.  The hub gates its clocks internally, but
> +	 * clk_disable_unused() would otherwise gate an always-on input the
> +	 * driver never claimed, so the driver enables whatever clocks the
> +	 * device tree provides.  Clocks come up before reset is released (a
> +	 * hard reset requires an active clock) and before any SIC register
> +	 * access.  The reset line is acquired already deasserted; the driver
> +	 * does not drive a reset pulse -- the eSW boots independently and its
> +	 * mission-mode readiness is verified separately below, and no in-tree
> +	 * platform wires this line for a reset sequence to be exercised.
> +	 * devm unwinds both on remove or probe error.
> +	 */
> +	ret = devm_clk_bulk_get_all_enabled(&pdev->dev, &clks);
> +	if (ret < 0) {
> +		dev_err(cmh_dev(), "failed to enable clocks (rc=%d)\n", ret);
> +		goto err_dma_init;
> +	}
> +	if (ret > 0)
> +		dev_info(cmh_dev(), "enabled %d clock(s)\n", ret);

Again?

> +
> +	reset = devm_gpiod_get_optional(&pdev->dev, "reset", GPIOD_OUT_LOW);
> +	if (IS_ERR(reset)) {
> +		ret = PTR_ERR(reset);
> +		dev_err(cmh_dev(), "failed to acquire reset GPIO (rc=%d)\n",
> +			ret);

Syntax is ret = dev_err_probe and internal review should tell you that.

> +		goto err_dma_init;
> +	}
> +
> +	/* Step 2: ioremap the SIC region */
> +	cfg->sic_mapped = devm_platform_ioremap_resource(pdev, 0);
> +	if (IS_ERR(cfg->sic_mapped)) {
> +		ret = PTR_ERR(cfg->sic_mapped);
> +		cfg->sic_mapped = NULL;
> +		dev_err(cmh_dev(), "ioremap failed for SIC region (rc=%d)\n",
> +			ret);
> +		goto err_dma_init;
> +	}
> +
> +	/* Step 3: Verify CMH is alive */
> +	if (skip_fw_check) {
> +		dev_info(cmh_dev(), "skipping eSW boot check (skip_fw_check=1)\n");
> +	} else {
> +		ret = cmh_check_sic(cfg);
> +		if (ret)
> +			goto err_dma_init;
> +	}
> +
> +	/* Step 3.5: Discover crypto cores from the SIC CORE_ENABLE register */
> +	ret = cmh_config_discover_cores(cfg);
> +	if (ret)
> +		goto err_dma_init;
> +
> +	/* Step 4: Compute per-instance register bases */
> +	for (i = 0; i < cfg->mbx_count; i++) {
> +		struct cmh_mbx_config *m = &cfg->mailboxes[i];
> +
> +		m->reg_base = cmh_mbx_instance_base(cfg->sic_mapped,
> +						    m->instance);
> +
> +		dev_dbg(cmh_dev(), "mbx[%u] instance=%u reg_base=%p\n",
> +			i, m->instance, m->reg_base);
> +	}
> +
> +	(void)cmh_debugfs_init(cfg);

Why the cast?

> +
> +	/* Initialise mailbox queue interface */
> +	ret = cmh_mqi_init(cfg);
> +	if (ret)
> +		goto err_mqi_init;
> +
> +	/* Initialise transaction manager */
> +	ret = cmh_tm_init(cfg);
> +	if (ret)
> +		goto err_tm_init;
> +
> +	/* Initialise response handler */
> +	ret = cmh_rh_init(cfg);
> +	if (ret)
> +		goto err_rh_init;
> +
> +	g_cmh_dev = dev;

Nope (and we do not call things "g" from globals)

> +	platform_set_drvdata(pdev, dev);
> +
> +	dev_info(cmh_dev(), "initialized successfully\n");

NAK

> +	return 0;
> +
> +err_rh_init:
> +	cmh_tm_cleanup();
> +err_tm_init:
> +	cmh_mqi_cleanup(cfg);
> +err_mqi_init:
> +	cmh_debugfs_cleanup();
> +err_dma_init:
> +	cmh_dma_cleanup();
> +err_free_dev:
> +	return ret;
> +}
> +
> +/* Module Exit -- platform driver remove */
> +
> +static void cmh_remove(struct platform_device *pdev)
> +{
> +	struct cmh_device *dev = platform_get_drvdata(pdev);
> +	struct cmh_config *cfg;
> +
> +	if (!dev)
> +		return;
> +
> +	cfg = &dev->config;
> +
> +	cmh_rh_cleanup(cfg);
> +	cmh_tm_cleanup();
> +	cmh_mqi_cleanup(cfg);
> +	cmh_debugfs_cleanup();
> +	cmh_dma_cleanup();
> +
> +	dev_info(&pdev->dev, "unloaded successfully\n");

NAK

> +
> +	g_cmh_dev = NULL;
> +}
> +
> +static const struct of_device_id cmh_of_match[] = {
> +	{ .compatible = "rambus,cmh-v1030" },
> +	{ /* sentinel */ }
> +};
> +MODULE_DEVICE_TABLE(of, cmh_of_match);
> +
> +/*
> + * PM suspend/resume.
> + *
> + * Suspend: drain the TM first (while the RH is still active and can
> + * deliver completions for in-flight transactions), then quiesce the
> + * RH (cancel watchdog, mask HW interrupts).  This ordering ensures
> + * the drain_timeout_ms wait in cmh_tm_quiesce() can actually succeed
> + * -- if we suspended RH first, no completions would be delivered and
> + * the drain would always hit the force-cancel path.
> + *
> + * IRQ handlers remain registered (standard PM pattern: the kernel
> + * disables the IRQ lines during suspend, no need to free/re-request).
> + *
> + * Resume: re-check the SIC/SW boot status, re-synchronise the RH
> + * with hardware (head positions, interrupt masks, watchdog), then
> + * restart the TM kthread.
> + */
> +
> +static int cmh_suspend(struct device *dev)
> +{
> +	struct cmh_device *cmh = dev_get_drvdata(dev);
> +
> +	if (!cmh)
> +		return 0;
> +
> +	dev_info(dev, "suspending\n");

Really, how many dev_info do you intend to have?

> +	cmh_tm_quiesce();
> +	cmh_rh_suspend(&cmh->config);
> +	return 0;
> +}
> +
> +static int cmh_resume(struct device *dev)
> +{
> +	struct cmh_device *cmh = dev_get_drvdata(dev);
> +	int ret;
> +
> +	if (!cmh)
> +		return 0;
> +
> +	ret = cmh_check_sic(&cmh->config);
> +	if (ret) {
> +		dev_err(dev, "resume: CMH eSW health check failed (%d)\n",
> +			ret);
> +		return ret;
> +	}
> +
> +	/*
> +	 * cmh_rh_resume() is void: it only re-syncs MMIO head pointers,
> +	 * clears stale interrupt status bits (W1C), re-enables interrupt
> +	 * masks, and re-arms the watchdog timer -- none of which can fail
> +	 * after the SIC health check above has confirmed HW accessibility.
> +	 */
> +	cmh_rh_resume(&cmh->config);
> +
> +	ret = cmh_tm_resume();
> +	if (ret) {
> +		dev_err(dev, "resume: TM restart failed (%d)\n", ret);
> +		return ret;
> +	}
> +	dev_info(dev, "resumed successfully\n");

NAK

> +	return 0;
> +}
> +
> +static DEFINE_SIMPLE_DEV_PM_OPS(cmh_pm_ops,
> +				cmh_suspend,
> +				cmh_resume);
> +
> +/*
> + * Runtime PM is intentionally not implemented.  The CMH hardware does
> + * not expose HLOS-accessible clock gates or power domains -- the eSW
> + * firmware manages HW power state independently.  There is no mechanism
> + * for the kernel to idle, gate clocks, or power down the accelerator
> + * block from HLOS.  If a future platform variant exposes power control
> + * to HLOS (e.g. via a SCMI power domain), runtime PM support can be
> + * added at that time using SET_RUNTIME_PM_OPS and pm_runtime_get/put
> + * around VCQ submission paths.
> + *
> + * System sleep (suspend/resume) is supported via DEFINE_SIMPLE_DEV_PM_OPS
> + * above: suspend quiesces the TM and masks IRQs; resume re-verifies
> + * eSW health (SIC status) and restarts the TM thread.
> + */
> +
> +static struct platform_driver cmh_driver = {
> +	.probe      = cmh_probe,
> +	.remove     = cmh_remove,
> +	.driver = {
> +		.name           = CMH_DRV_NAME,

Use name directly.

> +		.of_match_table = cmh_of_match,
> +		.dev_groups     = cmh_sysfs_groups,
> +		.pm             = pm_sleep_ptr(&cmh_pm_ops),
> +	},
> +};
> +
> +static int __init cmh_init(void)
> +{
> +	/*
> +	 * Register the platform driver and let the driver core drive
> +	 * probing.  Probe failures are logged by probe() itself; a probe
> +	 * that returns -EPROBE_DEFER (e.g. its interrupt controller is not
> +	 * yet ready) is retried by the core.  Do not gate module load on
> +	 * g_cmh_dev -- that would defeat deferred probe.
> +	 */

Why do you need this? Why your driver is done differently than all
others?

> +	return platform_driver_register(&cmh_driver);
> +}
> +
> +static void __exit cmh_exit(void)
> +{
> +	platform_driver_unregister(&cmh_driver);
> +}
> +
> +module_init(cmh_init);
> +module_exit(cmh_exit);

And this is not module_platform_driver because...?

> diff --git a/drivers/crypto/cmh/cmh_mqi.c b/drivers/crypto/cmh/cmh_mqi.c
> new file mode 100644
> index 000000000000..99ba44695d3c
> --- /dev/null
> +++ b/drivers/crypto/cmh/cmh_mqi.c
> @@ -0,0 +1,347 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (c) 2026 Cryptography Research, Inc. (CRI).
> + * CMH LKM -- Mailbox Queue Initializer
> + *
> + * Responsibilities:
> + *   - Allocate queue buffers for each configured mailbox
> + *   - Execute the MBX lock/setup/enable register sequence
> + *   - Readback-verify all critical register writes
> + *   - Hold lock for MBX lifetime (CMH eSW requires it for host access)
> + *   - Clean up (flush + unlock + free) on exit or error
> + *
> + * Register sequence per instance (per CMH MBX hardware specification):
> + *   1. Read R_MBX_LOCK -> non-zero = ownership token acquired
> + *   2. W1C stale R_MBX_INTERRUPT bits (avoids spurious error cascade)
> + *   3. Set R_MBX_INTERRUPT_MASK = MBX_IRQ_MASK
> + *   4. Write QUEUE_LO/HI, SLOTS, STRIDE (queue address + geometry)
> + *   5. Sync TAIL = HEAD (CMH eSW owns HEAD; avoids stale-queue parse)
> + *   6. Readback verify QUEUE_LO/HI/SLOTS/STRIDE
> + *   7. Write COMMAND = MBX_COMMAND_RUN
> + *   8. Lock stays held -- released only in teardown
> + */
> +
> +#include <linux/module.h>
> +#include <linux/kernel.h>
> +#include <linux/slab.h>
> +#include <linux/delay.h>
> +#include <linux/jiffies.h>
> +#include <linux/io.h>
> +#include <linux/iopoll.h>


...


> +/**
> + * cmh_mqi_init() - Initialize all mailbox queues
> + * @cfg: CMH configuration describing the mailboxes to set up
> + *
> + * Allocates DMA queue buffers for each configured mailbox, then executes
> + * the MBX lock/setup/enable register sequence.  On failure, all
> + * successfully initialized mailboxes are torn down and buffers freed.
> + *
> + * Return: 0 on success, negative errno on failure.
> + */
> +int cmh_mqi_init(struct cmh_config *cfg)
> +{
> +	unsigned int i, j;
> +	int ret;
> +
> +	/* Allocate queue buffers */
> +	for (i = 0; i < cfg->mbx_count; i++) {
> +		struct cmh_mbx_config *m = &cfg->mailboxes[i];
> +
> +		m->virt_addr = cmh_dma_alloc(m->queue_size, &m->dma_handle,
> +					     GFP_KERNEL);
> +		if (!m->virt_addr) {
> +			ret = -ENOMEM;
> +			goto err_free_bufs;
> +		}
> +
> +		dev_dbg(cmh_dev(), "mqi[%u] alloc %zu bytes @ virt=%pK dma=%pad\n",
> +			i, m->queue_size, m->virt_addr, &m->dma_handle);
> +	}
> +
> +	/* Lock/setup/enable each mailbox */
> +	for (i = 0; i < cfg->mbx_count; i++) {
> +		ret = cmh_mbx_setup_one(&cfg->mailboxes[i]);
> +		if (ret) {
> +			dev_err(cmh_dev(), "mqi[%u] setup failed (rc=%d)\n",
> +				i, ret);
> +			goto err_teardown;
> +		}
> +	}
> +
> +	dev_info(cmh_dev(), "MQI init complete (%u mailboxes)\n", cfg->mbx_count);

NAK

> +	return 0;
> +
> +err_teardown:
> +	for (j = 0; j < i; j++)
> +		cmh_mbx_teardown_one(&cfg->mailboxes[j]);
> +err_free_bufs:
> +	for (j = 0; j < cfg->mbx_count; j++) {
> +		if (cfg->mailboxes[j].virt_addr)
> +			cmh_dma_free(cfg->mailboxes[j].queue_size,
> +				     cfg->mailboxes[j].virt_addr,
> +				     cfg->mailboxes[j].dma_handle);
> +		cfg->mailboxes[j].virt_addr = NULL;
> +		cfg->mailboxes[j].dma_handle = 0;
> +	}
> +	return ret;
> +}
> +
> +/**
> + * cmh_mqi_cleanup() - Clean up all mailbox queues
> + * @cfg: CMH configuration describing the mailboxes to tear down
> + *
> + * Tears down each mailbox (flush + unlock) and frees the DMA queue
> + * buffers allocated by cmh_mqi_init().
> + */
> +void cmh_mqi_cleanup(struct cmh_config *cfg)
> +{
> +	unsigned int i;
> +
> +	for (i = 0; i < cfg->mbx_count; i++) {
> +		struct cmh_mbx_config *m = &cfg->mailboxes[i];
> +
> +		cmh_mbx_teardown_one(m);
> +
> +		if (m->virt_addr)
> +			cmh_dma_free(m->queue_size, m->virt_addr,
> +				     m->dma_handle);
> +		m->virt_addr = NULL;
> +		m->dma_handle = 0;
> +	}
> +
> +	dev_info(cmh_dev(), "MQI cleanup complete\n");

NAK

...

> +
> +/*
> + * Resolve per-MBX Linux virqs for the CMH interrupt lines.
> + *
> + * Each mailbox declares its own completion interrupt in its device-tree
> + * child node; cmh_config_init() resolves these to Linux virqs and stores
> + * them in cfg->mailboxes[i].irq (-1 when the mailbox has no interrupt).
> + * IRQ mode requires every configured mailbox to have an interrupt; if
> + * none do (or only some), the response handler uses watchdog polling.
> + *
> + * Populates rh.irqs[] and rh.nirqs.  Returns 0 on success, or a
> + * negative errno if no IRQs could be resolved (polling-only mode).
> + */
> +static int cmh_rh_resolve_irqs(struct cmh_config *cfg)
> +{
> +	u32 i, nwith = 0;
> +
> +	rh.nirqs = 0;
> +
> +	for (i = 0; i < cfg->mbx_count; i++)
> +		if (cfg->mailboxes[i].irq >= 0)
> +			nwith++;
> +
> +	if (nwith == 0) {
> +		dev_info(cmh_dev(), "rh: no mailbox IRQs -- polling mode\n");

So a warning or info?

> +		return -ENODEV;
> +	}
> +
> +	if (nwith != cfg->mbx_count) {
> +		dev_warn(cmh_dev(),
> +			 "rh: only %u/%u mailboxes have IRQs -- falling back to polling\n",
> +			 nwith, cfg->mbx_count);
> +		return -ENODEV;
> +	}
> +
> +	for (i = 0; i < cfg->mbx_count; i++) {
> +		rh.irqs[i] = cfg->mailboxes[i].irq;
> +		dev_dbg(cmh_dev(), "rh: MBX%u -> IRQ %d\n", i, rh.irqs[i]);
> +	}
> +
> +	rh.nirqs = cfg->mbx_count;
> +	return 0;
> +}
> +
> +/**
> + * cmh_rh_init() - Initialize the response handler
> + * @cfg: Device configuration (mailbox count, MMIO bases, IRQ info)
> + *
> + * Resolve per-mailbox IRQs from the device tree (or module parameter
> + * override), register threaded IRQ handlers (hardirq + kthread), and
> + * arm the missed-IRQ software watchdog timer.  If no IRQs can be
> + * resolved, falls back to watchdog-only polling mode.
> + *
> + * Return: 0 on success, negative errno on failure.
> + */
> +int cmh_rh_init(struct cmh_config *cfg)
> +{
> +	int ret;
> +	u32 i;
> +
> +	rh.cfg = cfg;
> +	rh.nirqs = 0;
> +	rh.active = false;
> +	atomic_set(&rh.irq_count, 0);
> +
> +	/* Allocate per-MBX tracking */
> +	rh.mbx = kcalloc(cfg->mbx_count, sizeof(*rh.mbx), GFP_KERNEL);
> +	if (!rh.mbx)
> +		return -ENOMEM;
> +
> +	/* Resolve per-MBX IRQs */
> +	if (cmh_rh_resolve_irqs(cfg) < 0) {
> +		/*
> +		 * No IRQs available.  The watchdog timer provides
> +		 * a polling fallback: it reads MBX head registers
> +		 * periodically and processes completions.  This is
> +		 * slower than IRQ-driven completion but functional.
> +		 *
> +		 * Completion latency in polling-only mode is bounded
> +		 * by the watchdog interval (default 200 ms, tunable
> +		 * via debugfs config/watchdog_ms).
> +		 */
> +		dev_warn(cmh_dev(),
> +			 "rh: no IRQs -- using watchdog polling (interval %u ms)\n",
> +			 watchdog_ms);

And here it is a warning?

> +
> +		/* Seed last_head from HW before first watchdog tick */
> +		for (i = 0; i < cfg->mbx_count; i++)
> +			rh.mbx[i].last_head =
> +				cmh_reg_read32(cfg->mailboxes[i].reg_base,
> +					       R_MBX_QUEUE_HEAD);
> +
> +		rh.active = true;
> +		timer_setup(&rh_watchdog, cmh_rh_watchdog_fn, 0);
> +		mod_timer(&rh_watchdog, jiffies +
> +			  msecs_to_jiffies(max(watchdog_ms,
> +					       CMH_RH_WATCHDOG_MS_MIN)));
> +		return 0;
> +	}
> +
> +	/* Initialize per-MBX state: read current head positions */
> +	for (i = 0; i < cfg->mbx_count; i++)
> +		rh.mbx[i].last_head = cmh_reg_read32(rh.cfg->mailboxes[i].reg_base,
> +						     R_MBX_QUEUE_HEAD);
> +
> +	/*
> +	 * Register threaded IRQ handlers.
> +	 *
> +	 * DT per-MBX path: one distinct virq per MBX, nirqs == mbx_count.
> +	 * DT single-IRQ path: one shared IRQ, nirqs == 1.  The handler
> +	 * scans all mailboxes unconditionally, so a single registration
> +	 * suffices.
> +	 *
> +	 * Use IRQF_SHARED only for the single-IRQ path where one line
> +	 * is shared across all MBXes.  Dedicated per-MBX virqs need no
> +	 * sharing flag.
> +	 */
> +	{

What is with this indentation?

> +		unsigned long irqflags = (rh.nirqs == 1 && cfg->mbx_count > 1)
> +					  ? IRQF_SHARED : 0;
> +
> +		for (i = 0; i < rh.nirqs; i++) {
> +			ret = request_threaded_irq(rh.irqs[i],
> +						   cmh_rh_hardirq,
> +						   cmh_rh_thread,
> +						   irqflags,
> +						   "cmh", cfg);
> +			if (ret) {
> +				dev_err(cmh_dev(), "rh: request_threaded_irq(%d) for MBX%u failed (rc=%d)\n",
> +					rh.irqs[i], i, ret);
> +				/* Unwind previously registered IRQs */
> +				while (i--)
> +					free_irq(rh.irqs[i], cfg);
> +				rh.nirqs = 0;
> +				kfree(rh.mbx);
> +				rh.mbx = NULL;
> +				return ret;
> +			}
> +		}
> +	}
> +
> +	rh.active = true;
> +
> +	/* Enable MBX completion interrupts (DONE + ERROR) */
> +	for (i = 0; i < cfg->mbx_count; i++) {
> +		u32 stale;
> +
> +		/*
> +		 * W1C any interrupt bits that accumulated between
> +		 * MQI setup and now (e.g. CMH eSW processing stale
> +		 * commands) before enabling the mask.
> +		 */
> +		stale = cmh_reg_read32(cfg->mailboxes[i].reg_base,
> +				       R_MBX_INTERRUPT);
> +		if (stale)
> +			cmh_reg_write32(stale, cfg->mailboxes[i].reg_base,
> +					R_MBX_INTERRUPT);
> +
> +		cmh_reg_write32(MBX_IRQ_MASK,
> +				cfg->mailboxes[i].reg_base,
> +				R_MBX_INTERRUPT_MASK);
> +	}
> +
> +	dev_info(cmh_dev(), "rh: initialized (%u IRQs, %u mailboxes, watchdog %u ms)\n",
> +		 rh.nirqs, cfg->mbx_count, watchdog_ms);

One more dev_info....


> +
> +	/* Arm missed-IRQ watchdog timer */
> +	timer_setup(&rh_watchdog, cmh_rh_watchdog_fn, 0);
> +	mod_timer(&rh_watchdog, jiffies +
> +		  msecs_to_jiffies(max(watchdog_ms,
> +				       CMH_RH_WATCHDOG_MS_MIN)));
> +
> +	return 0;
> +}
> +
> +/**
> + * cmh_rh_suspend() - Suspend the response handler
> + * @cfg: Device configuration
> + *
> + * Stop the watchdog timer and mask mailbox interrupts at the hardware
> + * level.  The IRQ handlers remain registered so that resume can
> + * re-enable them without re-requesting.
> + */
> +void cmh_rh_suspend(struct cmh_config *cfg)
> +{
> +	u32 i;
> +
> +	if (!rh.active)
> +		return;
> +
> +	/* Stop the watchdog before masking HW interrupts */
> +	timer_delete_sync(&rh_watchdog);
> +
> +	/* Mask MBX interrupts at the hardware level */
> +	for (i = 0; i < cfg->mbx_count; i++)
> +		cmh_reg_write32(0, cfg->mailboxes[i].reg_base,
> +				R_MBX_INTERRUPT_MASK);
> +
> +	/*
> +	 * Ensure no threaded IRQ handler is still in-flight.
> +	 * After masking, a handler may already have been scheduled.
> +	 * synchronize_irq() waits for it to complete before we
> +	 * proceed with suspend (which tears down TM state).
> +	 */
> +	for (i = 0; i < rh.nirqs; i++)
> +		synchronize_irq(rh.irqs[i]);
> +
> +	rh.active = false;
> +	dev_dbg(cmh_dev(), "rh: suspended\n");

No, you cannot have even debug messages which re-implement and
duplicated standard tracing and standard debugging code.


...


> +static unsigned int cmq_max_depth = 256;
> +module_param(cmq_max_depth, uint, 0444);
> +MODULE_PARM_DESC(cmq_max_depth,
> +		 "Max pending commands in the Command Message Queue (default: 256)");
> +
> +static unsigned int backlog_max_depth = 1024;
> +module_param(backlog_max_depth, uint, 0444);

Drop all module params, not really right way to do things.

> +MODULE_PARM_DESC(backlog_max_depth,
> +		 "Max pending commands in the backlog queue (0 = disable backlog, default: 1024)");
> +
> +static unsigned int async_timeout_ms = 2000;
> +
> +#define CMH_TM_BACKOFF_MIN_US   100  /* queue-full backoff range (us) */
> +#define CMH_TM_BACKOFF_MAX_US   500
> +static unsigned int cmq_depth;       /* current CMQ depth, protected by tm.cmq_lock */

...


> diff --git a/drivers/crypto/cmh/include/cmh.h b/drivers/crypto/cmh/include/cmh.h
> new file mode 100644
> index 000000000000..18150ba39129
> --- /dev/null
> +++ b/drivers/crypto/cmh/include/cmh.h
> @@ -0,0 +1,27 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Copyright (c) 2026 Cryptography Research, Inc. (CRI).
> + * CMH LKM -- Top-level Device Structure
> + */
> +
> +#ifndef CMH_H
> +#define CMH_H
> +
> +#include <linux/device.h>
> +
> +#include "cmh_config.h"
> +
> +#define CMH_DRV_NAME   "cmh"
> +#define CMH_VERSION    "1.0.0"

NAK, this is not allowed in Linux kernel code. Do you see drivers
(except complete junk from AMD) doing this?

Best regards,
Krzysztof

