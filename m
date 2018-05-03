From: "prakash.sangappa" <prakash.sangappa@oracle.com>
Subject: Re: [RFC PATCH] Add /proc/<pid>/numa_vamaps for numa node information
Date: Thu, 3 May 2018 15:39:49 -0700
Message-ID: <c80ee329-084b-367f-1937-3175c178e978@oracle.com>
References: <1525240686-13335-1-git-send-email-prakash.sangappa@oracle.com>
 <alpine.DEB.2.21.1805031259210.7831@nuc-kabylake>
Reply-To: prakash.sangappa@oracle.com
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.21.1805031259210.7831@nuc-kabylake>
Sender: linux-kernel-owner@vger.kernel.org
To: Christopher Lameter <cl@linux.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-api@vger.kernel.org, akpm@linux-foundation.org, mhocko@suse.com, kirill.shutemov@linux.intel.com, n-horiguchi@ah.jp.nec.com, drepper@gmail.com, rientjes@google.com
List-Id: linux-api@vger.kernel.org



On 05/03/2018 11:03 AM, Christopher Lameter wrote:
> On Tue, 1 May 2018, Prakash Sangappa wrote:
>
>> For analysis purpose it is useful to have numa node information
>> corresponding mapped address ranges of the process. Currently
>> /proc/<pid>/numa_maps provides list of numa nodes from where pages are
>> allocated per VMA of the process. This is not useful if an user needs to
>> determine which numa node the mapped pages are allocated from for a
>> particular address range. It would have helped if the numa node information
>> presented in /proc/<pid>/numa_maps was broken down by VA ranges showing the
>> exact numa node from where the pages have been allocated.
> Cant you write a small script that scans the information in numa_maps and
> then displays the total pages per NUMA node and then a list of which
> ranges have how many pages on a particular node?

Don't think we can determine which numa node a given user process
address range has pages from, based on the existing 'numa_maps' file.

>> reading this file will not be restricted(i.e requiring CAP_SYS_ADMIN).
> So a prime motivator here is security restricted access to numa_maps?
No it is the opposite. A regular user should be able to determine
numa node information.
