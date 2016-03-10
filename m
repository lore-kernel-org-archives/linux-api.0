From: Brian Norris <computersforpeace-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v4 00/52] mtd: rework ECC layout definition
Date: Thu, 10 Mar 2016 11:06:01 -0800
Message-ID: <20160310190601.GC2545@google.com>
References: <1457344062-11633-1-git-send-email-boris.brezillon@free-electrons.com>
Reply-To: computersforpeace-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-sunxi+bncBCZ6PSPVXMNBBHMLQ63QKGQEH76NM6Q-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1457344062-11633-1-git-send-email-boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
List-Post: <https://groups.google.com/group/linux-sunxi/post>, <mailto:linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <https://groups.google.com/support/>, <mailto:linux-sunxi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <https://groups.google.com/group/linux-sunxi
Sender: linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Subscribe: <https://groups.google.com/group/linux-sunxi/subscribe>, <mailto:linux-sunxi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+1076902468213+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <https://groups.google.com/group/linux-sunxi/subscribe>
To: Boris Brezillon <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
Cc: David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>, Haojian Zhuang <haojian.zhuang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Robert Jarzmik <robert.jarzmik-GANU6spQydw@public.gmane.org>, Kukjin Kim <kgene-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Krzysztof Kozlowski <k.kozlowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, linux-samsung-soc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Ralf Baechle <ralf-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org>, linux-mips-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org, Nicolas Ferre <nicolas.ferre-AIFe0yeh4nAAvxtiuMwx3w@public.gmane.org>, Jean-Christophe Plagniol-Villard <plagnioj-sclMFOaUSTBWk0Htik3J/w@public.gmane.org>, Alexandre Belloni <alexandre.belloni-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, Wenyou Yang <wenyou.yang-AIFe0yeh4nAAvxtiuMwx3w@public.gmane.org>, Josh Wu <rainyfeeling-1ViLX0X+lBJBDgjK7y7TUQ@public.gmane.org>, Ezequiel Garcia <ezequiel.garcia-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, Maxime Ripard <maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, Chen-Yu Tsai <wens-jdAy2FN1RRM@public.gmane.org>, linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, Stefan Agner <stefan-XLVq0VzYD2Y@public.gmane.org>, Kyungmin Park <kyungmin.park-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Greg
List-Id: linux-api@vger.kernel.org

On Mon, Mar 07, 2016 at 10:46:50AM +0100, Boris Brezillon wrote:
> Hello,
> 
> This patchset aims at getting rid of the nand_ecclayout limitations.
> struct nand_ecclayout is defining fixed eccpos and oobfree arrays which
> can only be increased by modifying the MTD_MAX_ECCPOS_ENTRIES_LARGE and
> MTD_MAX_OOBFREE_ENTRIES_LARGE macros.
> This approach forces us to modify the macro values each time we add a
> new NAND chip with a bigger OOB area, and increasing these arrays also
> penalize all platforms, even those who only support small NAND devices
> (with small OOB area).
> 
> The idea to overcome this limitation, is to define the ECC/OOB layout
> by the mean of two functions: ->ecc() and ->free(), which will
> basically return the same information has those stored in the
> nand_ecclayout struct.
> 
> Another advantage of this solution is that ECC layouts are usually
> following a repetitive pattern (i.e. leave X bytes free and put Y bytes
> of ECC per ECC chunk), which allows one to implement the ->ecc()
> and ->free() functions with a simple logic that can be applied
> to any size of OOB.
> 
> Patches 1 to 4 are just cleanups or trivial fixes that can be taken
> independently.
> 
> Also note that the last two commits are removing the nand_ecclayout
> definition, thus preventing any new driver to use this structure.
> Of course, this step can be delayed if some of the previous patches
> are not accepted.
> 
> All those changes are available here [1].
> 
> Best Regards,
> 
> Boris
> 
> [1]https://github.com/bbrezillon/linux-0day/tree/nand/ecclayout

FYI, I've pushed patches 1-4 to l2-mtd.git. I'll take another look at
them this week I hope (or your new fellow, Richard, can!), then you can
queue them up for the next cycle.

Brian
