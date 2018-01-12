From: Florian Weimer <fweimer@redhat.com>
Subject: Re: [REGRESSION] testing/selftests/x86/ pkeys build failures
Date: Fri, 12 Jan 2018 14:15:32 +0100
Message-ID: <063ba398-88e6-8650-2905-c378ee1fb8b2@redhat.com>
References: <360ef254-48bc-aee6-70f9-858f773b8693@redhat.com>
 <20180112125537.bdl376ziiaqp664o@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20180112125537.bdl376ziiaqp664o@gmail.com>
Content-Language: en-US
Sender: owner-linux-mm@kvack.org
To: Ingo Molnar <mingo@kernel.org>, Shuah Khan <shuahkh@osg.samsung.com>, Dave Hansen <dave.hansen@linux.intel.com>
Cc: linux-mm <linux-mm@kvack.org>, linux-arch <linux-arch@vger.kernel.org>, linux-x86_64@vger.kernel.org, Linux API <linux-api@vger.kernel.org>, x86@kernel.org, Dave Hansen <dave.hansen@intel.com>, Ram Pai <linuxram@us.ibm.com>
List-Id: linux-api@vger.kernel.org

On 01/12/2018 01:55 PM, Ingo Molnar wrote:
> 
> * Florian Weimer <fweimer@redhat.com> wrote:
> 
>> This patch is based on the previous discussion (pkeys: Support setting
>> access rights for signal handlers):
>>
>>    https://marc.info/?t=151285426000001
>>
>> It aligns the signal semantics of the x86 implementation with the upcoming
>> POWER implementation, and defines a new flag, so that applications can
>> detect which semantics the kernel uses.
>>
>> A change in this area is needed to make memory protection keys usable for
>> protecting the GOT in the dynamic linker.
>>
>> (Feel free to replace the trigraphs in the commit message before committing,
>> or to remove the program altogether.)
> 
> Could you please send patches not as MIME attachments?

My mail infrastructure corrupts patches not sent as attachments, sorry.

> Also, the protection keys testcase first need to be fixed, before we complicate
> them - for example on a pretty regular Ubuntu x86-64 installation they fail to
> build with the build errors attached further below.

I can fix things up so that they build on Fedora 26, Debian stretch, and 
Red Hat Enterprise Linux 7.  Would that be sufficient?

Fedora 23 is out of support and I'd prefer not invest any work into it.

Note that I find it strange to make this a precondition for even looking 
at the patch.

Thanks,
Florian

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
