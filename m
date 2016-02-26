From: Harvey Hunt <harvey.hunt@imgtec.com>
Subject: Re: [PATCH v3 07/52] mtd: nand: core: use mtd_ooblayout_xxx() helpers
 where appropriate
Date: Fri, 26 Feb 2016 15:17:28 +0000
Message-ID: <56D06C88.9080608@imgtec.com>
References: <1456448280-27788-1-git-send-email-boris.brezillon@free-electrons.com>
 <1456448280-27788-8-git-send-email-boris.brezillon@free-electrons.com>
 <56D0629C.9080805@imgtec.com> <20160226161054.3477cd4b@bbrezillon>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-samsung-soc-owner@vger.kernel.org>
In-Reply-To: <20160226161054.3477cd4b@bbrezillon>
Sender: linux-samsung-soc-owner@vger.kernel.org
To: Boris Brezillon <boris.brezillon@free-electrons.com>
Cc: David Woodhouse <dwmw2@infradead.org>, Brian Norris <computersforpeace@gmail.com>, linux-mtd@lists.infradead.org, Daniel Mack <daniel@zonque.org>, Haojian Zhuang <haojian.zhuang@gmail.com>, Robert Jarzmik <robert.jarzmik@free.fr>, Kukjin Kim <kgene@kernel.org>, Krzysztof Kozlowski <k.kozlowski@samsung.com>, linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org, Nicolas Ferre <nicolas.ferre@atmel.com>, Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>, Alexandre Belloni <alexandre.belloni@free-electrons.com>, Wenyou Yang <wenyou.yang@atmel.com>, Josh Wu <rainyfeeling@outlook.com>, Ezequiel Garcia <ezequiel.garcia@free-electrons.com>, Maxime Ripard <maxime.ripard@free-electrons.com>, Chen-Yu Tsai <wens@csie.org>, linux-sunxi@googlegroups.com, Stefan Agner <stefan@agn>
List-Id: linux-api@vger.kernel.org

Hi Boris,

On 26/02/16 15:10, Boris Brezillon wrote:
> Hi Harvey,
>
> On Fri, 26 Feb 2016 14:35:08 +0000
> Harvey Hunt <harvey.hunt@imgtec.com> wrote:
>
>> [...]
>> I'll look into this more later today, but wanted to run it by you in
>> case you have any thoughts.
>
> Can you apply this patch [1], and let me know if you see the additional
> trace?

I applied the patch, the following is the (unchanged) output:

[    0.256375] nand: device found, Manufacturer ID: 0x2c, Chip ID: 0x88
[    0.262887] nand: Micron MT29F64G08CBAAAWP
[    0.266995] nand: 8192 MiB, MLC, erase size: 2048 KiB, page size: 
8192, OOB size: 448
[    0.274881] jz4780-nand 1b000000.nand-controller: using hardware BCH 
(strength 24, size 1024, bytes 42)
[    0.289046] Bad block table not found for chip 0
[    0.297769] Bad block table not found for chip 0
[    0.302425] Scanning device for bad blocks
[    0.320239] Bad eraseblock 90 at 0x00000b400000
[    0.324934] Bad eraseblock 91 at 0x00000b600000
[    0.931054] Bad eraseblock 4092 at 0x0001ff800000
[    0.935917] Bad eraseblock 4093 at 0x0001ffa00000
[    0.944660] nand_bbt: error while writing bad block table -34
[    0.950448] jz4780-nand: probe of 1b000000.nand-controller failed 
with error -34
[    0.958079] UBI error: cannot open mtd 3, error -19
[    0.962788] UBI error: cannot open mtd 4, error -19[    0.970229] 
clk: Not disabling unused clocks

>
> Thanks,
>
> Boris
>
> [1]http://code.bulix.org/l2hkl1-91947
>

Thanks,

Harvey
