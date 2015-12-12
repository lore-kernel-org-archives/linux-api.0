From: Simon Arlott <simon@fire.lp0.eu>
Subject: Re: [PATCH linux-next (v3) 1/3] MIPS: bcm963xx: Add Broadcom BCM963xx
 board nvram data structure
Date: Sat, 12 Dec 2015 13:16:52 +0000
Message-ID: <566C1E44.3010506@simon.arlott.org.uk>
References: <566B460F.1040603@simon.arlott.org.uk>
 <CAOiHx=m3cXTePDjH04Yoz3wQO9Ta9jSn=JrkfNgphoPcQVaGXg@mail.gmail.com>
 <566B4D34.9040707@simon.arlott.org.uk>
 <CAOiHx=nrZdvezkyLi0kfvZ6Rp3YtechtP=J2orpUsVkXvA_6HQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-mips-bounce@linux-mips.org>
In-Reply-To: <CAOiHx=nrZdvezkyLi0kfvZ6Rp3YtechtP=J2orpUsVkXvA_6HQ@mail.gmail.com>
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

On 11/12/15 23:29, Jonas Gorski wrote:
> On Fri, Dec 11, 2015 at 11:24 PM, Simon Arlott <simon@fire.lp0.eu> wrote:
>> On 11/12/15 22:02, Jonas Gorski wrote:
>>> On Fri, Dec 11, 2015 at 10:54 PM, Simon Arlott <simon@fire.lp0.eu> wrote:
>>>> Broadcom BCM963xx boards have multiple nvram variants across different
>>>> SoCs with additional checksum fields added whenever the size of the
>>>> nvram was extended.
>>>>
>>>> Add this structure as a header file so that multiple drivers and userspace
>>>> can use it.
>>>>
>>>> Signed-off-by: Simon Arlott <simon@fire.lp0.eu>
>>>> ---
>>>> v3: Fix includes/type names, add comments explaining the nvram struct.
>>>>
>>>> v2: Use external struct bcm963xx_nvram definition for bcm963268part.
...
>>>> diff --git a/include/uapi/linux/bcm963xx_nvram.h b/include/uapi/linux/bcm963xx_nvram.h
>>>> new file mode 100644
>>>> index 0000000..2dcb307
>>>> --- /dev/null
>>>> +++ b/include/uapi/linux/bcm963xx_nvram.h
>>>
>>> Why uapi? The nvram layout isn't really enforced to be that way, and
>>> at least Huawei uses a modified one on some devices (in case you
>>> wondered why bcm63xx doesn't fail a crc32-"broken" one), so IMHO it
>>> should be kept for in-kernel use only.
>>
>> Because Florian suggested include/uapi/linux/bcm963xx_nvram.h; I could
>> move it to include/linux/ instead if this is preferred.
...
>>>> + * Do not use the __reserved fields, especially not as an offset for CRC
>>>> + * calculations (use BCM963XX_NVRAM_*_SIZE instead). These may be removed or
>>>> + * repositioned.
> 
> Because I just saw that: Nobody will read that. ;p

I'll move this to include/linux/bcm963xx_nvram.h and omit the linux-api
mailing list when I next send the patch series.

-- 
Simon Arlott
