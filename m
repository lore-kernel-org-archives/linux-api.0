From: Sri <sjayaram-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V2] Test compaction of mlocked memory
Date: Wed, 06 May 2015 13:44:44 -0400
Message-ID: <554A530C.4050109@akamai.com>
References: <1429813301-27216-1-git-send-email-sjayaram@akamai.com> <20150423184134.GF2282@akamai.com> <20150423132323.a3bd1dcdc94a2da3ca06a30d@linux-foundation.org> <553954FC.4050700@osg.samsung.com> <554A4904.4040604@osg.samsung.com> <554A4F50.6080208@akamai.com> <554A525A.8000401@osg.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <554A525A.8000401-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Eric B Munson <emunson-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Thanks!

-Sri

On 05/06/2015 01:41 PM, Shuah Khan wrote:
> On 05/06/2015 11:28 AM, Sri wrote:
>> Hi Shuah,
>>
>> This is what I see when I check the patch against the script,
>>
>> linux-stable$ ./scripts/checkpatch.pl
>> 0001-Test-compaction-of-mlocked-memory.patch
>> WARNING: added, moved or deleted file(s), does MAINTAINERS need updating?
>> #72:
>> new file mode 100644
>>
>> total: 0 errors, 1 warnings, 256 lines checked
>>
>> 0001-Test-compaction-of-mlocked-memory.patch has style problems, please
>> review.
>>
>> If any of these errors are false positives, please report
>> them to the maintainer, see CHECKPATCH in MAINTAINERS.
>>
>>
>> That was the only warning I saw even before I submitted the patch. I'm
>> not sure how the whitespaces are introduced...
>>
> 
> Hmm. Perhaps something is odd with the 4.1 checkpatch script.
> I am not seeing any whitespace errors when I do a manual
> check on the patch file.
> 
> Applying to linux-kselftest next
> 
> -- Shuah
> 
> 
