From: Khalid Aziz <khalid.aziz@oracle.com>
Subject: Re: [PATCH v3] sched/fair: Add advisory flag for borrowing a timeslice
Date: Tue, 25 Nov 2014 07:52:25 -0700
Message-ID: <547497A9.1080800@oracle.com>
References: <1416862595-24513-1-git-send-email-khalid.aziz@oracle.com> <5473E388.6000605@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5473E388.6000605@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Rik van Riel <riel@redhat.com>, tglx@linutronix.de, corbet@lwn.net, mingo@redhat.com, hpa@zytor.com, peterz@infradead.org, akpm@linux-foundation.org, rientjes@google.com, ak@linux.intel.com, mgorman@suse.de, liwanp@linux.vnet.ibm.com, raistlin@linux.it, kirill.shutemov@linux.intel.com, atomlin@redhat.com, avagin@openvz.org, gorcunov@openvz.org, serge.hallyn@canonical.com, athorlton@sgi.com, oleg@redhat.com, vdavydov@parallels.com, daeseok.youn@gmail.com, keescook@chromium.org, yangds.fnst@cn.fujitsu.com, sbauer@eng.utah.edu, vishnu.ps@samsung.com, axboe@fb.com, paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 11/24/2014 07:03 PM, Rik van Riel wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> On 11/24/2014 03:56 PM, Khalid Aziz wrote:
>> sched/fair: Add advisory flag for borrowing a timeslice
>>
>> This patch adds a way for a task to request to borrow one
>> timeslice from future if it is about to be preempted, so it could
>> delay preemption and complete any critical task it is in the middle
>> of.
>>
>> This feature helps with performance on databases and has been used
>> for many years on other OSs by the databases. This feature helps in
>> situation where a task acquires a lock before performing a critical
>> operation on the database and happens to get preempted
>
> Why don't the other tasks that want the lock sleep on the
> lock?
>
> I can see this "solution" help mostly with userspace spinlocks,
> which are relics of a past era that need to die. There is no
> way userspace spinlocks will not fail miserably on virtual
> machines, and it is time to get rid of them.

This solution indeed is for userspace spinlocks. Database code has been 
written with all critical locking implemented in userspace (as I have 
been told by database folks. I am not a database guy).

--
Khalid
