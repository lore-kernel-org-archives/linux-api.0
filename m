Received: from out28-100.mail.aliyun.com (out28-100.mail.aliyun.com [115.124.28.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA8713E4107;
	Fri,  9 Oct 2026 08:31:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.28.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791534667; cv=none; b=aktcQ1iF7ByUQVosOIXtTP7GK0+dFFQm3uS/9WVcZVFnck10qb5FztVHR0geO2R5GbyQ984ZiBP97ZbhiYthqtRNNScVRxC3jPBZPy97zP9L7L+UDBtF0atB+fl9+rPNrZNyqoQfCtviEVJeGzPuU83cMB3j++C1CTHD9VKbSe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791534667; c=relaxed/simple;
	bh=NREzAvOybk82jmak5nyZ+tRqSbWlfKIasOaN+dQMwfo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=p9mxnEBM3Ibkv3s8zB7wsYRfYdk1+7QUK28tHA+8jOB2aw+dA2j/6KvuaJyoZNZ/alXf6seNdeIK+rtHod2+BUJmJ+7uWeOp0v5GQ2op/UrOYritzPuhUj5qr5VTj537frAVkCfDPcXEp0AhXN0r0jf+713jv7aGOr+OOzgwR1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=edatec.cn; spf=pass smtp.mailfrom=edatec.cn; arc=none smtp.client-ip=115.124.28.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=edatec.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=edatec.cn
X-Alimail-AntiSpam:AC=CONTINUE;BC=0.07437662|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_system_inform|0.0254022-4.13009e-05-0.974557;FP=2698362186331905460|0|0|0|0|-1|-1|-1;HT=maildocker-contentspam033032062159;MF=zjzhao@edatec.cn;NM=1;PH=DS;RN=12;RT=12;SR=0;TI=SMTPD_---.jXaSeit_1791534329;
Received: from LAPTOP-VQRD5F43.hs.edatec.cn(mailfrom:zjzhao@edatec.cn fp:SMTPD_---.jXaSeit_1791534329 cluster:ay29)
          by smtp.aliyun-inc.com;
          Fri, 09 Oct 2026 16:25:30 +0800
From: zjzhao@edatec.cn
To: gregkh@linuxfoundation.org,
	jirislaby@kernel.org
Cc: robh@kernel.org,
	krzk+dt@kernel.org,
	conor+dt@kernel.org,
	hugo@hugovil.com,
	hy@wkmic.com,
	linux-serial@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-api@vger.kernel.org,
	Zi Jie Zhao <zjzhao@edatec.cn>
Subject: [PATCH v5 0/2] WK2xxx SPI to UART bridge driver
Date: Fri,  9 Oct 2026 16:24:06 +0800
Message-ID: <cover.20261009.wk2xxx.v5@edatec.cn>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Zi Jie Zhao <zjzhao@edatec.cn>

Add support for the WK2xxx SPI to UART bridge ICs from Chengdu Weikai
Microelectronics (WKmic): WK2124, WK2132, WK2168, WK2212 and WK2204.

The public v4 series used WK2202 by mistake. The WK2202 name in the public
reference driver is a typo; the correct model is WK2212. The v5 binding and
driver use WK2212 consistently. It is a two-channel model with hardware
flow control and RS-485 support.

Huang Yang <hy@wkmic.com> is listed as the primary maintainer of the driver
and binding from v5 onward. He will lead follow-up code changes and
reviewer replies, with Zi Jie Zhao providing transition support.

Changes in v5:

- Rebase onto 9b87fdc9af2f (Linux 7.3-rc3 based master);
- correct WK2202 to WK2212 in compatible data and documentation;
- list Huang Yang as the binding and driver maintainer;
- align per-compatible flow-control and RS-485 flags with the product data;
- size DMA-safe SPI buffers independently of cacheline size;
- synchronize TX snapshots with flush without doing SPI under the
  port lock;
- make tx_empty() non-sleeping and maintain its state asynchronously;
- report each FIFO-level RX overrun once;
- clear queued IER configuration during shutdown after cancelling work;
- complete shutdown cleanup on SPI errors and synchronize IRQ/work
  teardown;
- release all serial child-node references;
- remove the arbitrary 200-byte TX cap and replace the 200-iteration poll;
- apply Hugo Villeneuve's naming, comment, whitespace and line-width
  feedback;
- explain why direct SPI and explicit IRQ ownership are retained;
- use WK2204 in the binding example because it enables RS-485.

Conor Dooley's v4 Reviewed-by tag is not carried forward: v5 changes the
compatible and binding maintainer. Please review the updated binding.

Validation performed for the candidate:

- ARM (multi_v7_defconfig, module), ARM64 (defconfig, module and built-in),
  and m68k (multi_defconfig, module) driver builds pass;
- dt_binding_check passes and compiles the binding example; optional
  yamllint was skipped because it is not installed;
- checkpatch reports no errors or checks; patch 2 has one generic warning
  that MAINTAINERS may need updating, and patch 1 adds Huang Yang;
- sparse was not completed because the available sparse 0.6.4 does not support
  the __typeof_unqual__ probe required by this kernel version;
- on the SBC2300/WK2204 CM4 profile, all four ports registered and pairwise
  loopback passed byte-for-byte at 9600, 115200 and 230400 baud;
- the shutdown cleanup passed a four-port 512-byte bidirectional smoke test
  in 10/10 runs on a matched overlay and 3/3 runs after reboot with
  the formal v5 overlay;
- on the v5 candidate, three closed-port module unload/reload cycles and
  post-reload loopback passed;
- on the IPC1200/WK2132 CM4 profile, boot and TX smoke tests passed.

The hardware checks above were performed on Raspberry Pi CM4 systems
running 6.18.34 and 6.18.39 downstream kernels. RS-485 electrical behavior
was not tested.

Zi Jie Zhao (2):
  dt-bindings: serial: Document WK2xxx SPI UART
  serial: wk2xxx: Add WK2xxx SPI UART driver

 .../bindings/serial/wkmic,wk2124.yaml         |  119 ++
 .../devicetree/bindings/vendor-prefixes.yaml  |    2 +
 MAINTAINERS                                   |    7 +
 drivers/tty/serial/Kconfig                    |   17 +
 drivers/tty/serial/Makefile                   |    1 +
 drivers/tty/serial/wk2xxx.c                   | 1527 +++++++++++++++++
 include/uapi/linux/serial_core.h              |    3 +
 7 files changed, 1676 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/serial/wkmic,wk2124.yaml
 create mode 100644 drivers/tty/serial/wk2xxx.c

base-commit: 9b87fdc9af2fbfcdb5c24a64139685ef80f6573f

-- 
2.43.0

