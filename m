From: "Ivan.khoronzhuk" <ivan.khoronzhuk@globallogic.com>
Subject: Re: [Patch 1/3] firmware: dmi_scan: rename dmi_table to dmi_decode_table
Date: Thu, 16 Apr 2015 23:16:59 +0300
Message-ID: <553018BB.1080903@globallogic.com>
References: <1427979423-22767-1-git-send-email-ivan.khoronzhuk@globallogic.com>	<1427979423-22767-2-git-send-email-ivan.khoronzhuk@globallogic.com>	<20150415143530.GF4804@codeblueprint.co.uk> <20150416103511.55927ccc@endymion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20150416103511.55927ccc@endymion.delvare>
Sender: linux-doc-owner@vger.kernel.org
To: Jean Delvare <jdelvare@suse.de>, Matt Fleming <matt@codeblueprint.co.uk>
Cc: linux-kernel@vger.kernel.org, matt.fleming@intel.com, ard.biesheuvel@linaro.org, grant.likely@linaro.org, linux-api@vger.kernel.org, linux-doc@vger.kernel.org, mikew@google.com, dmidecode-devel@nongnu.org, leif.lindholm@linaro.org, msalter@redhat.com, roy.franz@linaro.org
List-Id: linux-api@vger.kernel.org

Hi Jean,

On 16.04.15 11:35, Jean Delvare wrote:
> Hi Matt,
>
> On Wed, 15 Apr 2015 15:35:30 +0100, Matt Fleming wrote:
>> On Thu, 02 Apr, at 03:57:01PM, Ivan Khoronzhuk wrote:
>>> The "dmi_table" function looks like data instance, but it does DMI
>>> table decode. This patch renames it to "dmi_decode_table" name as
>>> more appropriate. That allows us to use "dmi_table" name for correct
>>> purposes.
>>>
>>> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@globallogic.com>
>>> ---
>>>   drivers/firmware/dmi_scan.c | 10 +++++-----
>>>   1 file changed, 5 insertions(+), 5 deletions(-)
>> Looks good to me.
>>
>> Jean, do you want me to pick this patch up or are you going to?
> Good question, we need to agree on a strategy.
>
> There are 3 patch sets to consider here.
>
> 1* My patch fixing the UUID ordering bug. It must go in first and
>     immediately, as it fixes a regression and will have to be backported
>     to stable branches.

||
V

>
> 2* 2 older patches from Ivan which are currently in your efi-next tree
>     if I'm not mistaken. Both were based on an old tree so they do not
>     apply cleanly on kernel v4.0, I had to fix them up manually. I have

They are in master tree already.

>     no idea if git would be able to merge them properly, as the fix
>     above changed the context even more.

Current efi-next already merged, so you should base your patches on
top of last changes.

>
> 3* The 3 new patches from Ivan which I am reviewing now, which are not
>     applied in any public tree AFAIK.

It shouldn't happen,
I've been verifying just now once again.
They are applied on top of linux_next cleanly.
Equal as on efi/next.

>
> I don't really care who picks these patches up and sends them to Linus,
> but I think they should all follow the same route so that Linus has as
> little merge work to do as possible. So either you pick them all, or I
> do. If I do, you'll have to drop the 2 patches you have in efi-next.
> Again I'm fine either way, so please let me know what makes your life
> easier and let's do that.
>
> Thanks,

Jean,
I'm going to base my series
"firmware: dmi_scan: add SBMIOS entry point and DMI tables"
on top of linux next unless you have already your tree to pick up changes.
Please let me know, if you have one.


-- 
Regards,
Ivan Khoronzhuk

