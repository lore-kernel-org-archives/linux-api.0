From: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: Re: [PATCH 2/9] selftests: Add install target
Date: Tue, 10 Mar 2015 09:11:09 -0600
Message-ID: <54FF098D.7020106@osg.samsung.com>
References: <1425358302-16680-1-git-send-email-mpe@ellerman.id.au> <1425358302-16680-2-git-send-email-mpe@ellerman.id.au> <20150305185326.GA30620@codemonkey.org.uk> <54FDAC4A.9080703@osg.samsung.com> <54FE1EC0.6000201@osg.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54FE1EC0.6000201-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Dave Jones <davej-rdkfGonbjUTCLXcRTR1eJlpr/1R2p/CL@public.gmane.org>, mmarek-AlSwsSmVLrQ@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 03/09/2015 04:29 PM, Shuah Khan wrote:
> On 03/09/2015 08:20 AM, Shuah Khan wrote:
>> On 03/05/2015 11:53 AM, Dave Jones wrote:
>>> On Tue, Mar 03, 2015 at 03:51:35PM +1100, Michael Ellerman wrote:
>>>  > This adds make install support to selftests. The basic usage is:
>>>  > 
>>>  > $ cd tools/testing/selftests
>>>  > $ make install
>>>  > 
>>>  > That installs into tools/testing/selftests/install, which can then be
>>>  > copied where ever necessary.
>>>  > 
>>>  > The install destination is also configurable using eg:
>>>  > 
>>>  > $ INSTALL_PATH=/mnt/selftests make install
>>>
>>>  ...
>>>
>>>  > +	@# Ask all targets to emit their test scripts
>>>  > +	echo "#!/bin/bash\n\n" > $(ALL_SCRIPT)
>>>
>>> $ ./all.sh 
>>> -bash: ./all.sh: /bin/bash\n\n: bad interpreter: No such file or directory
>>>
>>> Removing the \n\n fixes it.
>>>
>>>  > +		echo "cd \$$ROOT\n" >> $(ALL_SCRIPT); \
>>>
>>> ditto
>>>
>>> 	Dave
>>
>> Michael,
>>
>> Could you please fix these problems and send the patch.
>>
> 
> Michael,
> 
> Did you happen to run run_kselftest.sh from the install
> directory to make sure all the dependent executables
> are installed? You are missing a few required dependencies.
> efivars test for example.
> 
> Please run kselftest_install.sh I sent out for review and
> compare the following:
> 
> - contents of install directory created with your patch vs.
>   my kselftest_install.sh tool
> - Compare your run_kselftest.sh run with the one that gets
>   generated with my kselftest_install.sh tool
> 
> General rule is all tests that get run when run_tests target
> is run should run from the install directory using the
> run_kselftest.sh generated during install.
> 

Couple more things. Please change the install directory name
to kselftest

tools/testing/selftests/kselftest
instead of
tools/testing/selftests/install

Also please flatten the directory structure under the install
directory. I don't see any value in creating directory for each
test for install. Also it is makes it cumbersome for users
to navigate and work with after the install. This would mean cpu
and memory hot-plug scripts need unique names.

thanks,
-- Shuah


-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org | (970) 217-8978
