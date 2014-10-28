From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: Re: Re: [PATCH V4] kernel, add bug_on_warn
Date: Tue, 28 Oct 2014 14:41:41 +0900
Message-ID: <544F2C95.7060806@hitachi.com>
References: <1414155207-29839-1-git-send-email-prarit@redhat.com> <544E8985.50203@akamai.com> <544E8BB8.8000707@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <544E8BB8.8000707@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Prarit Bhargava <prarit@redhat.com>
Cc: Jason Baron <jbaron@akamai.com>, linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, Andrew Morton <akpm@linux-foundation.org>, Rusty Russell <rusty@rustcorp.com.au>, "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@linux.intel.com>, Fabian Frederick <fabf@skynet.be>, vgoyal@redhat.com, isimatu.yasuaki@jp.fujitsu.com, linux-doc@vger.kernel.org, kexec@lists.infradead.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

(2014/10/28 3:15), Prarit Bhargava wrote:
> 
> 
> On 10/27/2014 02:05 PM, Jason Baron wrote:
>> Hi Prarit,
>>
>> On 10/24/2014 08:53 AM, Prarit Bhargava wrote:
>>> There have been several times where I have had to rebuild a kernel to
>>> cause a panic when hitting a WARN() in the code in order to get a crash
>>> dump from a system.  Sometimes this is easy to do, other times (such as
>>> in the case of a remote admin) it is not trivial to send new images to the
>>> user.panic_on_stackoverflow
>>>
>>> A much easier method would be a switch to change the WARN() over to a
>>> BUG().  This makes debugging easier in that I can now test the actual
>>> image the WARN() was seen on and I do not have to engage in remote
>>> debugging.
>>>
>>> This patch adds a bug_on_warn kernel parameter and
>>> /proc/sys/kernel/bug_on_warn calls BUG() in the warn_slowpath_common()
>>> path.  The function will still print out the location of the warning.
>>>
>>> An example of the bug_on_warn output:
>>>
>>> The first line below is from the WARN_ON() to output the WARN_ON()'s location.
>>> After that the new BUG() call is displayed.
>>>
>>>  WARNING: CPU: 27 PID: 3204 at
>>> /home/rhel7/redhat/debug/dummy-module/dummy-module.c:25 init_dummy+0x28/0x30
>>> [dummy_module]()
>>>  bug_on_warn set, calling BUG()...
>>>  ------------[ cut here ]------------
>>>  kernel BUG at kernel/panic.c:434!
>>
>> Seems reasonable-I'm wondering why you just don't call panic() in this
>> case. The BUG() call at line '434' doesn't at anything since its just being
>> called from panic.c.

+1, I like calling panic() instead of BUG() :)

Thank you,

> 
> Hmm ... I didn't even think about that.
> 
>>
>> So something like 'panic_on_warn' would seem to be more appropriate
>> in keeping with things like 'panic_on_oops' or 'panic_on_stackoverflow'.
> 
> I like it a lot better that way too :)  I'm changing it to panic_on_warn unless
> anyone has any strenuous objections.
> 
> P.
> 
>>
>> Thanks,
>>
>> -Jason
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
