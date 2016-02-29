From: Harvey Hunt <harvey.hunt-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 07/52] mtd: nand: core: use
 mtd_ooblayout_xxx() helpers where appropriate
Date: Mon, 29 Feb 2016 10:33:49 +0000
Message-ID: <56D41E8D.1010901@imgtec.com>
References: <1456448280-27788-1-git-send-email-boris.brezillon@free-electrons.com>
 <1456448280-27788-8-git-send-email-boris.brezillon@free-electrons.com>
 <56D0629C.9080805@imgtec.com> <20160226161054.3477cd4b@bbrezillon>
 <56D06C88.9080608@imgtec.com> <20160226193325.2d84a8c8@bbrezillon>
Reply-To: harvey.hunt-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Return-path: <linux-sunxi+bncBDG6R4VLYILBBD552C3AKGQE4M47SEQ-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
In-Reply-To: <20160226193325.2d84a8c8@bbrezillon>
List-Post: <https://groups.google.com/group/linux-sunxi/post>, <mailto:linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <https://groups.google.com/support/>, <mailto:linux-sunxi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <https://groups.google.com/group/linux-sunxi
Sender: linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Subscribe: <https://groups.google.com/group/linux-sunxi/subscribe>, <mailto:linux-sunxi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+1076902468213+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <https://groups.google.com/group/linux-sunxi/subscribe>
To: Boris Brezillon <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
Cc: David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Brian Norris <computersforpeace-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>, Haojian Zhuang <haojian.zhuang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Robert
 Jarzmik <robert.jarzmik-GANU6spQydw@public.gmane.org>, Kukjin Kim <kgene-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Krzysztof
 Kozlowski <k.kozlowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, linux-samsung-soc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Ralf Baechle <ralf-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org>, linux-mips-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org, Nicolas Ferre <nicolas.ferre-AIFe0yeh4nAAvxtiuMwx3w@public.gmane.org>, Jean-Christophe Plagniol-Villard <plagnioj-sclMFOaUSTBWk0Htik3J/w@public.gmane.org>, Alexandre Belloni <alexandre.belloni-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, Wenyou Yang <wenyou.yang-AIFe0yeh4nAAvxtiuMwx3w@public.gmane.org>, Josh Wu <rainyfeeling-1ViLX0X+lBJBDgjK7y7TUQ@public.gmane.org>, Ezequiel Garcia <ezequiel.garcia-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, Maxime Ripard <maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, Chen-Yu Tsai <wens-jdAy2FN1RRM@public.gmane.org>, linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, Stefan Agner <stefan-XLVq0VzYD2Y@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Boris,

On 26/02/16 18:33, Boris Brezillon wrote:
> Hi Harvey,
>
> On Fri, 26 Feb 2016 15:17:28 +0000
> Harvey Hunt <harvey.hunt-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org> wrote:
>
>> Hi Boris,
>>
>> On 26/02/16 15:10, Boris Brezillon wrote:
>>> Hi Harvey,
>>>
>>> On Fri, 26 Feb 2016 14:35:08 +0000
>>> Harvey Hunt <harvey.hunt-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org> wrote:
>>>
>>>> [...]
>>>> I'll look into this more later today, but wanted to run it by you in
>>>> case you have any thoughts.
>>>
>>> Can you apply this patch [1], and let me know if you see the additional
>>> trace?
>>
>> I applied the patch, the following is the (unchanged) output:
>>
>> [    0.256375] nand: device found, Manufacturer ID: 0x2c, Chip ID: 0x88
>> [    0.262887] nand: Micron MT29F64G08CBAAAWP
>> [    0.266995] nand: 8192 MiB, MLC, erase size: 2048 KiB, page size:
>> 8192, OOB size: 448
>> [    0.274881] jz4780-nand 1b000000.nand-controller: using hardware BCH
>> (strength 24, size 1024, bytes 42)
>> [    0.289046] Bad block table not found for chip 0
>> [    0.297769] Bad block table not found for chip 0
>> [    0.302425] Scanning device for bad blocks
>> [    0.320239] Bad eraseblock 90 at 0x00000b400000
>> [    0.324934] Bad eraseblock 91 at 0x00000b600000
>> [    0.931054] Bad eraseblock 4092 at 0x0001ff800000
>> [    0.935917] Bad eraseblock 4093 at 0x0001ffa00000
>> [    0.944660] nand_bbt: error while writing bad block table -34
>> [    0.950448] jz4780-nand: probe of 1b000000.nand-controller failed
>> with error -34
>> [    0.958079] UBI error: cannot open mtd 3, error -19
>> [    0.962788] UBI error: cannot open mtd 4, error -19[    0.970229]
>> clk: Not disabling unused clocks
>>
>
> Can you test with this one [1]?
>
> [1]http://code.bulix.org/36oytz-91960

With that patch applied, my Ci20 successfully boots again.

Thanks for looking into it :-)

Harvey
