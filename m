From: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: Re: [PATCH v4 4/9] selftests: Add install target
Date: Wed, 11 Mar 2015 10:03:38 -0600
Message-ID: <5500675A.1000700@osg.samsung.com>
References: <1426046765-19289-1-git-send-email-mpe@ellerman.id.au> <1426046765-19289-4-git-send-email-mpe@ellerman.id.au> <5500408B.2070604@osg.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5500408B.2070604-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, davej-rdkfGonbjUTCLXcRTR1eJlpr/1R2p/CL@public.gmane.org, mmarek-AlSwsSmVLrQ@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 03/11/2015 07:18 AM, Shuah Khan wrote:
> On 03/10/2015 10:06 PM, Michael Ellerman wrote:
>> This adds make install support to selftests. The basic usage is:
>>
>> $ cd tools/testing/selftests
>> $ make install
>>
>> That installs into tools/testing/selftests/install, which can then be
>> copied where ever necessary.
>>
>> The install destination is also configurable using eg:
>>
>> $ INSTALL_PATH=/mnt/selftests make install
>>
>> The implementation uses two targets in the child makefiles. The first
>> "install" is expected to install all files into $(INSTALL_PATH).
>>
>> The second, "emit_tests", is expected to emit the test instructions (ie.
>> bash script) on stdout. Separating this from install means the child
>> makefiles need no knowledge of the location of the test script.
>>
>> Signed-off-by: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
>> ---
>>
>> v3: Rebase onto 4.0-rc2.
>>     Rename all.sh to run_kselftest.sh.
>>     Add --no-print-directory to emit_tests invocation.
>> v4: Rebase onto 4.0-rc3, add TEST_FILES to efivars and vm tests, remove
>>     newlines from echoes.
> 
> I don't see my comments addressed. If you want me to take
> this work, please address the following comments:
> 
> - Name install directory kselftest. It should work with the
>   the use-case.
> 
>   make INSTALL_PATH=/tmp make install
>   The install directory should be /tmp/kselftest
> 
> - Flatten the directory with all tests under /tmp/kselftest
> 

Yes. There is the issue of duplicate executable names and data
file to be concerned about. It is a name-space problem. It is
not unique to this case, example /usr/bin. This problem is better
solved without adding the complexity of hierarchical directory
structure.

1. Individual test Makefiles ensure unique names for their
   executables and data files. This can be done as a process
   when new tests are accepted.
2. Install process makes sure they are unique - this patch is
   solving the problem by creating a directory hierarchy. A simpler
   way to do it is by adding pre-fix to when there is name space
   conflict.

The problem with directory hierarchy is for one thing:

1. It is complex and way too many directories get created during
   install and this problem will mushroom as more and more tests
   get added.

2. User won't be able to define a simple path variable to invoke
   individual tests. This is a user experience problem.

Please find a way to solve the name-space problem without the
complexity of directory hierarchy.

thanks,
-- Shuah

-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org | (970) 217-8978
