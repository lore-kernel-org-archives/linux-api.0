From: Shuah Khan <shuahkh@osg.samsung.com>
Subject: Re: [PATCH V2] Test compaction of mlocked memory
Date: Thu, 23 Apr 2015 14:24:28 -0600
Message-ID: <553954FC.4050700@osg.samsung.com>
References: <1429813301-27216-1-git-send-email-sjayaram@akamai.com> <20150423184134.GF2282@akamai.com> <20150423132323.a3bd1dcdc94a2da3ca06a30d@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150423132323.a3bd1dcdc94a2da3ca06a30d@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Eric B Munson <emunson@akamai.com>
Cc: Sri Jayaramappa <sjayaram@akamai.com>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Shuah Khan <shuahkh@osg.samsung.com>
List-Id: linux-api@vger.kernel.org

On 04/23/2015 02:23 PM, Andrew Morton wrote:
> On Thu, 23 Apr 2015 14:41:34 -0400 Eric B Munson <emunson@akamai.com> wrote:
> 
>> On Thu, 23 Apr 2015, Sri Jayaramappa wrote:
>>
>>> Commit commit 5bbe3547aa3b ("mm: allow compaction of unevictable pages")
>>> introduced a sysctl that allows userspace to enable scanning of locked
>>> pages for compaction.  This patch introduces a new test which fragments
>>> main memory and attempts to allocate a number of huge pages to exercise
>>> this compaction logic.
>>>
>>> Tested on machines with up to 32 GB RAM. With the patch a much larger
>>> number of huge pages can be allocated than on the kernel without the
>>> patch.
>>>
>>> Example output:
>>> On a machine with 16 GB RAM:
>>> sudo make run_tests vm
>>> ...
>>> -----------------------
>>> running compaction_test
>>> -----------------------
>>> No of huge pages allocated = 3834
>>> [PASS]
>>> ...
>>>
>>> Signed-off-by: Sri Jayaramappa <sjayaram@akamai.com>
>>> Cc: linux-kernel@vger.kernel.org
>>> Cc: linux-api@vger.kernel.org
>>> Cc: Andrew Morton <akpm@linux-foundation.org>
>>> Cc: Eric B Munson <emunson@akamai.com>
>>
>> Reviewed-by: Eric B Munson <emunson@akamai.com>
> 
> Acked-by: Andrew Morton <akpm@linux-foundation.org>
> 
> I'm assuming that Shuah will process this one?
> 

Yes. I will get this one after the merge window closes.

-- Shuah

-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
