From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH v3 1/4] firmware: introduce sysfs driver for QEMU's
 fw_cfg device
Date: Sun, 4 Oct 2015 09:34:12 +0800
Message-ID: <201510040936.gYi4Ld9m%fengguang.wu@intel.com>
References: <1443914889-9619-2-git-send-email-somlo@cmu.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1443914889-9619-2-git-send-email-somlo@cmu.edu>
Sender: linux-kernel-owner@vger.kernel.org
To: "Gabriel L. Somlo" <somlo@cmu.edu>
Cc: kbuild-all@01.org, gregkh@linuxfoundation.org, paul@pwsan.com, galak@codeaurora.org, will.deacon@arm.com, agross@codeaurora.org, mark.rutland@arm.com, zajec5@gmail.com, hanjun.guo@linaro.org, catalin.marinas@arm.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, kernelnewbies@kernelnewbies.org, matt.fleming@intel.com, lersek@redhat.com, jordan.l.justen@intel.com, mst@redhat.com, peter.maydell@linaro.org, leif.lindholm@linaro.org, ard.biesheuvel@linaro.org, pbonzini@redhat.com, kraxel@redhat.com, qemu-devel@nongnu.org
List-Id: linux-api@vger.kernel.org

Hi Gabriel,

[auto build test results on v4.3-rc3 -- if it's inappropriate base, please ignore]

reproduce:
        # apt-get install sparse
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

   drivers/firmware/qemu_fw_cfg.c:66:25: sparse: constant 0xd00000510 is so big it is long
>> drivers/firmware/qemu_fw_cfg.c:95:39: sparse: restricted __be16 degrades to integer
>> drivers/firmware/qemu_fw_cfg.c:95:58: sparse: restricted __le16 degrades to integer
>> drivers/firmware/qemu_fw_cfg.c:111:25: sparse: cast to restricted __be32
>> drivers/firmware/qemu_fw_cfg.c:111:25: sparse: cast to restricted __be32
>> drivers/firmware/qemu_fw_cfg.c:111:25: sparse: cast to restricted __be32
>> drivers/firmware/qemu_fw_cfg.c:111:25: sparse: cast to restricted __be32
>> drivers/firmware/qemu_fw_cfg.c:111:25: sparse: cast to restricted __be32
>> drivers/firmware/qemu_fw_cfg.c:111:25: sparse: cast to restricted __be32
>> drivers/firmware/qemu_fw_cfg.c:95:39: sparse: restricted __be16 degrades to integer
>> drivers/firmware/qemu_fw_cfg.c:95:58: sparse: restricted __le16 degrades to integer
>> drivers/firmware/qemu_fw_cfg.c:95:39: sparse: restricted __be16 degrades to integer
>> drivers/firmware/qemu_fw_cfg.c:95:58: sparse: restricted __le16 degrades to integer
   drivers/firmware/qemu_fw_cfg.c:367:25: sparse: cast to restricted __be32
   drivers/firmware/qemu_fw_cfg.c:367:25: sparse: cast to restricted __be32
   drivers/firmware/qemu_fw_cfg.c:367:25: sparse: cast to restricted __be32
   drivers/firmware/qemu_fw_cfg.c:367:25: sparse: cast to restricted __be32
   drivers/firmware/qemu_fw_cfg.c:367:25: sparse: cast to restricted __be32
   drivers/firmware/qemu_fw_cfg.c:367:25: sparse: cast to restricted __be32
>> drivers/firmware/qemu_fw_cfg.c:368:27: sparse: cast to restricted __be16
>> drivers/firmware/qemu_fw_cfg.c:368:27: sparse: cast to restricted __be16
>> drivers/firmware/qemu_fw_cfg.c:368:27: sparse: cast to restricted __be16
>> drivers/firmware/qemu_fw_cfg.c:368:27: sparse: cast to restricted __be16
>> drivers/firmware/qemu_fw_cfg.c:95:39: sparse: restricted __be16 degrades to integer
>> drivers/firmware/qemu_fw_cfg.c:95:58: sparse: restricted __le16 degrades to integer
>> drivers/firmware/qemu_fw_cfg.c:420:22: sparse: cast to restricted __le32

vim +95 drivers/firmware/qemu_fw_cfg.c

    60			.size = 0x0a,
    61			.ctrl_offset = 0x08,
    62			.data_offset = 0x00,
    63			.is_mmio = true,
    64		}, {
    65			.name = "fw_cfg MMIO on sun4m",
  > 66			.base = 0xd00000510,
    67			.size = 0x03,
    68			.ctrl_offset = 0x00,
    69			.data_offset = 0x02,
    70			.is_mmio = true,
    71		}, {
    72			.name = "fw_cfg MMIO on ppc/mac",
    73			.base = 0xf0000510,
    74			.size = 0x03,
    75			.ctrl_offset = 0x00,
    76			.data_offset = 0x02,
    77			.is_mmio = true,
    78		}, { } /* END */
    79	};
    80	
    81	/* fw_cfg device i/o currently selected option set */
    82	static struct fw_cfg_access *fw_cfg_mode;
    83	
    84	/* fw_cfg device i/o register addresses */
    85	static void __iomem *fw_cfg_dev_base;
    86	static void __iomem *fw_cfg_reg_ctrl;
    87	static void __iomem *fw_cfg_reg_data;
    88	
    89	/* atomic access to fw_cfg device (potentially slow i/o, so using mutex) */
    90	static DEFINE_MUTEX(fw_cfg_dev_lock);
    91	
    92	/* pick appropriate endianness for selector key */
    93	static inline u16 fw_cfg_sel_endianness(u16 key)
    94	{
  > 95		return fw_cfg_mode->is_mmio ? cpu_to_be16(key) : cpu_to_le16(key);
    96	}
    97	
    98	/* type for fw_cfg "directory scan" visitor/callback function */
    99	typedef int (*fw_cfg_file_callback)(const struct fw_cfg_file *f);
   100	
   101	/* run a given callback on each fw_cfg directory entry */
   102	static int fw_cfg_scan_dir(fw_cfg_file_callback callback)
   103	{
   104		int ret = 0;
   105		u32 count, i;
   106		struct fw_cfg_file f;
   107	
   108		mutex_lock(&fw_cfg_dev_lock);
   109		iowrite16(fw_cfg_sel_endianness(FW_CFG_FILE_DIR), fw_cfg_reg_ctrl);
   110		ioread8_rep(fw_cfg_reg_data, &count, sizeof(count));
 > 111		for (i = 0; i < be32_to_cpu(count); i++) {
   112			ioread8_rep(fw_cfg_reg_data, &f, sizeof(f));
   113			ret = callback(&f);
   114			if (ret)

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
