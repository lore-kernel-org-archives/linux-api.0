From: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: Re: [PATCH 2/9] selftests: Add install target
Date: Wed, 11 Mar 2015 07:19:02 -0600
Message-ID: <550040C6.8030702@osg.samsung.com>
References: <1425358302-16680-1-git-send-email-mpe@ellerman.id.au> <1425358302-16680-2-git-send-email-mpe@ellerman.id.au> <20150305185326.GA30620@codemonkey.org.uk> <54FDAC4A.9080703@osg.samsung.com> <54FE1EC0.6000201@osg.samsung.com> <54FF098D.7020106@osg.samsung.com> <1426044019.23148.2.camel@ellerman.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1426044019.23148.2.camel-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dave Jones <davej-rdkfGonbjUTCLXcRTR1eJlpr/1R2p/CL@public.gmane.org>, mmarek-AlSwsSmVLrQ@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 03/10/2015 09:20 PM, Michael Ellerman wrote:
> On Tue, 2015-03-10 at 09:11 -0600, Shuah Khan wrote:
>> On 03/09/2015 04:29 PM, Shuah Khan wrote:
>>> On 03/09/2015 08:20 AM, Shuah Khan wrote:
>>>> On 03/05/2015 11:53 AM, Dave Jones wrote:
>>>>> On Tue, Mar 03, 2015 at 03:51:35PM +1100, Michael Ellerman wrote:
>>>>>  > This adds make install support to selftests. The basic usage is:
>>>>>  > 
>>>>>  > $ cd tools/testing/selftests
>>>>>  > $ make install
>>>>>  > 
>>>>>  > That installs into tools/testing/selftests/install, which can then be
>>>>>  > copied where ever necessary.
>>>>>  > 
>>>>>  > The install destination is also configurable using eg:
>>>>>  > 
>>>>>  > $ INSTALL_PATH=/mnt/selftests make install
>>>>>
>>>>>  ...
>>>>>
>>>>>  > +	@# Ask all targets to emit their test scripts
>>>>>  > +	echo "#!/bin/bash\n\n" > $(ALL_SCRIPT)
>>>>>
>>>>> $ ./all.sh 
>>>>> -bash: ./all.sh: /bin/bash\n\n: bad interpreter: No such file or directory
>>>>>
>>>>> Removing the \n\n fixes it.
>>>>>
>>>>>  > +		echo "cd \$$ROOT\n" >> $(ALL_SCRIPT); \
>>>>>
>>>>> ditto
>>>>>
>>>>> 	Dave
>>>>
>>>> Michael,
>>>>
>>>> Could you please fix these problems and send the patch.
>>>>
>>>
>>> Michael,
>>>
>>> Did you happen to run run_kselftest.sh from the install
>>> directory to make sure all the dependent executables
>>> are installed? You are missing a few required dependencies.
>>> efivars test for example.
>>>
>>> Please run kselftest_install.sh I sent out for review and
>>> compare the following:
>>>
>>> - contents of install directory created with your patch vs.
>>>   my kselftest_install.sh tool
>>> - Compare your run_kselftest.sh run with the one that gets
>>>   generated with my kselftest_install.sh tool
>>>
>>> General rule is all tests that get run when run_tests target
>>> is run should run from the install directory using the
>>> run_kselftest.sh generated during install.
>>>
>>
>> Couple more things. Please change the install directory name
>> to kselftest
>>
>> tools/testing/selftests/kselftest
>> instead of
>> tools/testing/selftests/install
> 
> I prefer install, that's what it is after all. I don't know why you're so
> obsessed with the "kselftest" name.

It is the overall user-interface. I want to be able to call
install wrapper script and have the right directory generated.
If user passes in /tmp for example as a main directory, install
is so generic and doesn't make sense. I see that you sent the
patch v4 still with install and please change it to kselftest
> 
>> Also please flatten the directory structure under the install
>> directory. I don't see any value in creating directory for each
>> test for install. Also it is makes it cumbersome for users
>> to navigate and work with after the install. This would mean cpu
>> and memory hot-plug scripts need unique names.
> 
> That's not a good idea. To start with different tests might the same name, as
> already happens with the memory & cpu hot-plug tests. They may also have data
> files that would clobber each other. We'd need to make sure all files used in
> all tests have different names, that would be a total mess.

No I want the just one container directory for the tests. Again I am
looking at the bigger picture user-interface angle. Please flatten it,
and resend it.

I responded to your patch v4. Please re-do the patch to address my
comments if you want your patch to be included.

thanks,
-- Shuah


-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org | (970) 217-8978
