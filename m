From: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: Re: [PATCH v4 4/9] selftests: Add install target
Date: Wed, 18 Mar 2015 08:30:49 -0600
Message-ID: <55098C19.3000805@osg.samsung.com>
References: <1426046765-19289-1-git-send-email-mpe@ellerman.id.au> <1426046765-19289-4-git-send-email-mpe@ellerman.id.au> <55031C78.4040609@osg.samsung.com> <5503577C.9050002@osg.samsung.com> <1426475092.20210.4.camel@ellerman.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1426475092.20210.4.camel-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, davej-rdkfGonbjUTCLXcRTR1eJlpr/1R2p/CL@public.gmane.org, mmarek-AlSwsSmVLrQ@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 03/15/2015 09:04 PM, Michael Ellerman wrote:
> On Fri, 2015-03-13 at 15:32 -0600, Shuah Khan wrote:
>> On 03/13/2015 11:20 AM, Shuah Khan wrote:
>>> On 03/10/2015 10:06 PM, Michael Ellerman wrote:
>>>> This adds make install support to selftests. The basic usage is:
>>>>
>>>> $ cd tools/testing/selftests
>>>> $ make install
>>>>
>>>> That installs into tools/testing/selftests/install, which can then be
>>>> copied where ever necessary.
>>>>
>>>> The install destination is also configurable using eg:
>>>>
>>>> $ INSTALL_PATH=/mnt/selftests make install
>>>>
>>>> The implementation uses two targets in the child makefiles. The first
>>>> "install" is expected to install all files into $(INSTALL_PATH).
>>>>
>>>> The second, "emit_tests", is expected to emit the test instructions (ie.
>>>> bash script) on stdout. Separating this from install means the child
>>>> makefiles need no knowledge of the location of the test script.
>>>>
>>>> Signed-off-by: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
>>>
>>> Thanks for doing the work. This patch will be applied to next and will
>>> be queued for 4.1
>>>
>>
>> ok. linux-kselftest next has both shared logic and install patches
>> now.
> 
> Thanks, looks good to me.
> 
> Can you also apply the patch to install the powerpc tests, or was there a
> problem with it? It seems to apply cleanly for me.
> 
> https://lkml.org/lkml/2015/3/11/9
> 
> cheers

It is on my todo after the install patches are squared away.
It will be applied to next.

-- Shuah

-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org | (970) 217-8978
