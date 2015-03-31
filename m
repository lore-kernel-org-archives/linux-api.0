From: Shuah Khan <shuahkh@osg.samsung.com>
Subject: Re: [GIT PULL] selftest: Add futex functional tests
Date: Tue, 31 Mar 2015 10:37:51 -0600
Message-ID: <551ACD5F.8010003@osg.samsung.com>
References: <cover.1427493640.git.dvhart@linux.intel.com> <551ABE00.9050003@osg.samsung.com> <D14017F7.C46F0%dvhart@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <D14017F7.C46F0%dvhart@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Darren Hart <dvhart@linux.intel.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: linux-api@vger.kernel.org, Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, Davidlohr Bueso <dave@stgolabs.net>, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, greg Kroah-Hartman <gregkh@linuxfoundation.org>, fengguang.wu@intel.com, Michael Ellerman <mpe@ellerman.id.au>
List-Id: linux-api@vger.kernel.org

On 03/31/2015 10:24 AM, Darren Hart wrote:
> On 3/31/15, 8:32 AM, "Shuah Khan" <shuahkh@osg.samsung.com> wrote:
> 
>> Hi Daren,
>>
>> On 03/27/2015 04:17 PM, Darren Hart wrote:
>>> Hi Shuah,
>>>
>>> This series begins the process of migrating my futextest tests into
>>> kselftest.
>>> I've started with only the functional tests, as the performance and
>>> stress may
>>> not be appropriate for kselftest as they stand.
>>>
>>> I cleaned up various complaints from checkpatch, but I ignored others
>>> that would
>>> require significant rework of the testcases, such as not using volatile
>>> and not
>>> creating new typedefs.
>>>
>>> The patches will follow, but I'm providing a pull request for your
>>> convenience
>>> as well.
>>
>> Thanks for acting on this so quickly after we talked about it at ELC.
>> Just a quick note that I am going to get to this soon once I get the
>> 4.1 content wrapped up. We can plan upon getting these into 4.2.
> 
> OK. Michael E. provided some feedback which I can either incorporate and
> respin, or I can send as a follow-on to your -next after you merge these.
> Which do you prefer?
> 

Working through my email. Yes I see Michael had comments on install.
I would have the same ones. Please re-do the patch 2/5 to use shared
logic and install framework in lib.mk. This need to be done to
facilitate test install. If you were to create a script for running
tests, please make it non-generic and unique. For example, run.sh
is a very generic name.

[PATCH 2/5] selftest/futex: Update Makefile to use lib.mk

I took a quick look at the exit code discussion. If you would
like improve what is in kselftest.h, please re-do that patch.

[PATCH 5/5] kselftest: Add exit code defines

You can wait to re-do patches. I am planning to review the
patch set later on this week. That way you can avoid re-spin
just in case, I have other comments.

thanks,
-- Shuah

-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
