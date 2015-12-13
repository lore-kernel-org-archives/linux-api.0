From: Simon Arlott <simon@fire.lp0.eu>
Subject: Re: [PATCH linux-next (v3) 3/3] mtd: part: Add BCM962368 CFE
 partitioning support
Date: Sun, 13 Dec 2015 20:26:57 +0000
Message-ID: <566DD491.4030902@simon.arlott.org.uk>
References: <566B460F.1040603@simon.arlott.org.uk>
 <566B47D9.8020105@simon.arlott.org.uk>
 <CAOiHx==GSwCxWmaQfmHHumGu_ye6waf-DA_5+m8_Ukc1hVeBYg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-mips-bounce@linux-mips.org>
In-Reply-To: <CAOiHx==GSwCxWmaQfmHHumGu_ye6waf-DA_5+m8_Ukc1hVeBYg@mail.gmail.com>
Sender: linux-mips-bounce@linux-mips.org
Errors-to: linux-mips-bounce@linux-mips.org
List-help: <mailto:ecartis@linux-mips.org?Subject=help>
List-unsubscribe: <mailto:ecartis@linux-mips.org?subject=unsubscribe%20linux-mips>
List-software: Ecartis version 1.0.0
List-subscribe: <mailto:ecartis@linux-mips.org?subject=subscribe%20linux-mips>
List-owner: <mailto:ralf@linux-mips.org>
List-post: <mailto:linux-mips@linux-mips.org>
List-archive: <http://www.linux-mips.org/archives/linux-mips/>
To: Jonas Gorski <jogo@openwrt.org>
Cc: David Woodhouse <dwmw2@infradead.org>, Brian Norris <computersforpeace@gmail.com>, Florian Fainelli <f.fainelli@gmail.com>, Ralf Baechle <ralf@linux-mips.org>, Kevin Cernekee <cernekee@gmail.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, MTD Maling List <linux-mtd@lists.infradead.org>, bcm-kernel-feedback-list <bcm-kernel-feedback-list@broadcom.com>, MIPS Mailing List <linux-mips@linux-mips.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 11/12/15 23:12, Jonas Gorski wrote:
> On Fri, Dec 11, 2015 at 11:02 PM, Simon Arlott <simon@fire.lp0.eu> wrote:
>> +#define BCM63XX_CFE_MAGIC_OFFSET       0x4e0
>> +#define BCM963XX_CFE_VERSION_OFFSET    0x570
>> +#define BCM963XX_NVRAM_OFFSET          0x580
> 
> You should decide whether you want to call it BCM63XX (the SoC) or
> BCM963XX (the Board using the SoC). Also probably better served in
> bcm963xx_nvram.h

I'm going to name the CFE locations, nvram and anything that is a
property of the flash layout BCM963XX_*, as a theoretical board using
BCM63XX with no flash wouldn't use these. The parser is still called
bcm63xxpart so that's currently an anomaly.

I'm working on making it support both NOR and NAND flash layouts.

-- 
Simon Arlott
