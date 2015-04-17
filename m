From: "Ivan.khoronzhuk" <ivan.khoronzhuk@globallogic.com>
Subject: Re: [Patch 1/3] firmware: dmi_scan: rename dmi_table to dmi_decode_table
Date: Fri, 17 Apr 2015 13:11:13 +0300
Message-ID: <5530DC41.3050700@globallogic.com>
References: <1427979423-22767-1-git-send-email-ivan.khoronzhuk@globallogic.com>	<1427979423-22767-2-git-send-email-ivan.khoronzhuk@globallogic.com>	<20150415143530.GF4804@codeblueprint.co.uk>	<20150416103511.55927ccc@endymion.delvare>	<553018BB.1080903@globallogic.com> <20150417105454.1c52f430@endymion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20150417105454.1c52f430@endymion.delvare>
Sender: linux-doc-owner@vger.kernel.org
To: Jean Delvare <jdelvare@suse.de>
Cc: Matt Fleming <matt@codeblueprint.co.uk>, linux-kernel@vger.kernel.org, matt.fleming@intel.com, ard.biesheuvel@linaro.org, grant.likely@linaro.org, linux-api@vger.kernel.org, linux-doc@vger.kernel.org, mikew@google.com, dmidecode-devel@nongnu.org, leif.lindholm@linaro.org, msalter@redhat.com, roy.franz@linaro.org
List-Id: linux-api@vger.kernel.org



On 17.04.15 11:54, Jean Delvare wrote:
> Hi Ivan,
>
> On Thu, 16 Apr 2015 23:16:59 +0300, Ivan.khoronzhuk wrote:
>> On 16.04.15 11:35, Jean Delvare wrote:
>>> On Wed, 15 Apr 2015 15:35:30 +0100, Matt Fleming wrote:
>>>> Jean, do you want me to pick this patch up or are you going to?
>>> Good question, we need to agree on a strategy.
>>>
>>> There are 3 patch sets to consider here.
>>>
>>> 1* My patch fixing the UUID ordering bug. It must go in first and
>>>      immediately, as it fixes a regression and will have to be backported
>>>      to stable branches.
>> ||
>> V
>>
>>> 2* 2 older patches from Ivan which are currently in your efi-next tree
>>>      if I'm not mistaken. Both were based on an old tree so they do not
>>>      apply cleanly on kernel v4.0, I had to fix them up manually. I have
>> They are in master tree already.
>>
>>>      no idea if git would be able to merge them properly, as the fix
>>>      above changed the context even more.
>> Current efi-next already merged, so you should base your patches on
>> top of last changes.
> Correct. I looked at the result and the merge looks correct. I'll turn
> my objections into fixup patches to apply on top, where still worth it.
> In particular I'll start with the ".x" revert, as it will make
> backporting the bug fix easier.
>
>>> 3* The 3 new patches from Ivan which I am reviewing now, which are not
>>>      applied in any public tree AFAIK.
>> It shouldn't happen,
>> I've been verifying just now once again.
>> They are applied on top of linux_next cleanly.
>> Equal as on efi/next.
> I can't see them at
> http://git.kernel.org/cgit/linux/kernel/git/mfleming/efi.git/log/?h=next
>
> To clarify: I do not claim that they can't be applied, I'm only saying
> they're not there yet (which is OK as they were still pending my
> review.) They do apply just fine, no problem with this.
>
>>> I don't really care who picks these patches up and sends them to Linus,
>>> but I think they should all follow the same route so that Linus has as
>>> little merge work to do as possible. So either you pick them all, or I
>>> do. If I do, you'll have to drop the 2 patches you have in efi-next.
>>> Again I'm fine either way, so please let me know what makes your life
>>> easier and let's do that.
>> I'm going to base my series
>> "firmware: dmi_scan: add SBMIOS entry point and DMI tables"
>> on top of linux next unless you have already your tree to pick up changes.
>> Please let me know, if you have one.
> I have no formal tree yet, but my current patch set can be seen at:
> http://jdelvare.nerim.net/devel/linux-3/jdelvare-dmi/
>
> First 2 patches from you are already upstream. You should rebase your
> updated patch series on top of upstream + patches 03 and 04, as they
> will go in first.
>
> Thanks,

Not sure that's a good idea to base on patches that doesn't path any 
review and
no one cannot apply. At least it be good you send them that I can point 
on them in
commit message.

-- 
Regards,
Ivan Khoronzhuk

