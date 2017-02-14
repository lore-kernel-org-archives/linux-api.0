From: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: Re: [PATCH 1/5] selftests: Fix selftests build to just build, not run
 tests
Date: Tue, 14 Feb 2017 09:14:24 -0700
Message-ID: <c539ac89-37f8-ebee-49ca-9d80fc1ff1f1@osg.samsung.com>
References: <1486630590-9410-1-git-send-email-mpe@ellerman.id.au>
 <87shnhmsl1.fsf@concordia.ellerman.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <87shnhmsl1.fsf-W0DJWXSxmBNbyGPkN3NxC2scP1bn1w/D@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>, bamvor.zhangjian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: linuxppc-dev-mnsaURCQ41sdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 02/13/2017 07:09 PM, Michael Ellerman wrote:
> Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org> writes:
> 
>> In commit 88baa78d1f31 ("selftests: remove duplicated all and clean
>> target"), the "all" target was removed from individual Makefiles and
>> added to lib.mk.
>>
>> However the "all" target was added to lib.mk *after* the existing
>> "runtests" target. This means "runtests" becomes the first (default)
>> target for most of our Makefiles.
> ...
>>
>> Fix it by moving the "all" target to the start of lib.mk, making it the
>> default target.
>>
>> Fixes: 88baa78d1f31 ("selftests: remove duplicated all and clean target")
>> Signed-off-by: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
> 
> Hi Shuah,
> 
> Can you please merge this series into linux-next?
> 
> The selftests are badly broken otherwise.
> 
> cheers
> 

Hi Michael,

Thanks. All 5 patches are now in linux-kselftest next with Tested-by
tag from Bamvor for 1,2,3.

thank you both,
-- Shuah
