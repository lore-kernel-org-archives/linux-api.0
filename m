From: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: Re: [PATCH] selftests: Change memory on-off-test.sh name to be unique
Date: Wed, 01 Apr 2015 07:06:15 -0600
Message-ID: <551BED47.6030303@osg.samsung.com>
References: <1427847059-9353-1-git-send-email-shuahkh@osg.samsung.com> <20150401120400.GA3218@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150401120400.GA3218-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 04/01/2015 06:04 AM, Greg KH wrote:
> On Tue, Mar 31, 2015 at 06:10:59PM -0600, Shuah Khan wrote:
>> cpu and memory hotplug scripts use the same name. Change
>> memory on-off-test.sh to mem-on-off-test.sh.
>>
>> Signed-off-by: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
>> ---
>>  tools/testing/selftests/memory-hotplug/Makefile    |   6 +-
>>  .../selftests/memory-hotplug/mem-on-off-test.sh    | 238 +++++++++++++++++++++
>>  .../selftests/memory-hotplug/on-off-test.sh        | 238 ---------------------
>>  3 files changed, 241 insertions(+), 241 deletions(-)
>>  create mode 100755 tools/testing/selftests/memory-hotplug/mem-on-off-test.sh
>>  delete mode 100755 tools/testing/selftests/memory-hotplug/on-off-test.sh
> 
> Hint, when making patches that rename files, use '-M' as a git diff
> output, it will show the move much easier than adding and removing the
> file.

Thanks for the tip. That would have made it easier to review.

> 
> Anyway, I have no problem with this:
> 
> Acked-by: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
> 

thanks,
-- Shuah

-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org | (970) 217-8978
