From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: [PATCH v2 5/7] selftests/mount: change test to use ksft framework
Date: Tue, 23 Sep 2014 16:07:28 -0700
Message-ID: <8761geylzj.fsf@x220.int.ebiederm.org>
References: <cover.1411506121.git.shuahkh@osg.samsung.com>
	<cover.1411506121.git.shuahkh@osg.samsung.com>
	<969f0780734a04763f2b54063603b93380244d0c.1411506121.git.shuahkh@osg.samsung.com>
	<87d2am2c4v.fsf@x220.int.ebiederm.org>
	<5421FA8A.9050209@osg.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5421FA8A.9050209-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org> (Shuah Khan's message of "Tue,
	23 Sep 2014 16:56:10 -0600")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org, dbueso-l3A5Bk7waGM@public.gmane.org, serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org, thierry-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org> writes:

> On 09/23/2014 04:41 PM, Eric W. Biederman wrote:
>> Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org> writes:
>> 
>>> Change mount test to use kselftest framework to report
>>> test results.
>> 
>> Nacked-by: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
>> 
>> I am curious did you even run these tests?   I can't possibly see how
>> the tests would have passed with this change.  At the very least you
>> have taken this test from linear to exponential time complexity.
>> 
>
> Oops. I meant to drop this commit from the series. Sorry for the
> noise.

No problem.  Except for the unnecessary semantic change the rest of the
change looked fine.  I just wanted to make certain you didn't break my
test by accident.

Eric
