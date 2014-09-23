From: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: Re: [PATCH v2 5/7] selftests/mount: change test to use ksft framework
Date: Tue, 23 Sep 2014 17:18:59 -0600
Message-ID: <5421FFE3.8060402@osg.samsung.com>
References: <cover.1411506121.git.shuahkh@osg.samsung.com> <cover.1411506121.git.shuahkh@osg.samsung.com> <969f0780734a04763f2b54063603b93380244d0c.1411506121.git.shuahkh@osg.samsung.com> <87d2am2c4v.fsf@x220.int.ebiederm.org> <5421FA8A.9050209@osg.samsung.com> <8761geylzj.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <8761geylzj.fsf-JOvCrm2gF+uungPnsOpG7nhyD016LWXt@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org, dbueso-l3A5Bk7waGM@public.gmane.org, serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org, thierry-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 09/23/2014 05:07 PM, Eric W. Biederman wrote:
> Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org> writes:
> 
>> On 09/23/2014 04:41 PM, Eric W. Biederman wrote:
>>> Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org> writes:
>>>
>>>> Change mount test to use kselftest framework to report
>>>> test results.
>>>
>>> Nacked-by: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
>>>
>>> I am curious did you even run these tests?   I can't possibly see how
>>> the tests would have passed with this change.  At the very least you
>>> have taken this test from linear to exponential time complexity.
>>>
>>
>> Oops. I meant to drop this commit from the series. Sorry for the
>> noise.
> 
> No problem.  Except for the unnecessary semantic change the rest of the
> change looked fine.  I just wanted to make certain you didn't break my
> test by accident.
> 

Thanks for catching it. The results didn't look right and I meant
to delay this change for later after another round of testing.
I will fix it without the unnecessary change and send it out
separately.

thanks,
-- Shuah

-- 
Shuah Khan
Sr. Linux Kernel Developer
Samsung Research America (Silicon Valley)
shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org | (970) 217-8978
