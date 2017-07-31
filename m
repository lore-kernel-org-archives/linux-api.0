From: Prakash Sangappa <prakash.sangappa@oracle.com>
Subject: Re: [PATCH v2 2/2] userfaultfd: selftest: Add tests for
 UFFD_FEATURE_SIGBUS feature
Date: Sun, 30 Jul 2017 23:32:53 -0700
Message-ID: <faa9fea7-f089-64aa-72e8-69f17ce1f48c@oracle.com>
References: <1501208320-200277-1-git-send-email-prakash.sangappa@oracle.com>
 <20170730070749.GB22926@rapoport-lnx>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20170730070749.GB22926@rapoport-lnx>
Sender: owner-linux-mm@kvack.org
To: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-api@vger.kernel.org, aarcange@redhat.com, akpm@linux-foundation.org, mike.kravetz@oracle.com
List-Id: linux-api@vger.kernel.org



On 7/30/17 12:07 AM, Mike Rapoport wrote:
> On Thu, Jul 27, 2017 at 10:18:40PM -0400, Prakash Sangappa wrote:
>> This patch adds tests for UFFD_FEATURE_SIGBUS feature. The
>> tests will verify signal delivery instead of userfault events.
>> Also, test use of UFFDIO_COPY to allocate memory and retry
>> accessing monitored area after signal delivery.
>>
>> This patch also fixes a bug in uffd_poll_thread() where 'uffd'
>> is leaked.
>>
>> Signed-off-by: Prakash Sangappa <prakash.sangappa@oracle.com>
>> ---
>> Change log
>>
>> v2:
>>    - Added comments to explain the tests.
>>    - Fixed test to fail immediately if signal repeats.
>>    - Addressed other review comments.
>>
>> v1: https://lkml.org/lkml/2017/7/26/101
>> ---
> Overall looks good to me, just small nitpick below.
[...]
>>   	for (nr = 0; nr < split_nr_pages; nr++) {
>> +		if (signal_test) {
>> +			if (sigsetjmp(*sigbuf, 1) != 0) {
>> +				if (nr == lastnr) {
>> +					sig_repeats++;
> You can simply 'return 1' here, then sig_repeats variable can be dropped
> and the return statement for signal_test can be simplified.

Ok, sent v3 patch with this change.

Thanks,
-Prakash.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
