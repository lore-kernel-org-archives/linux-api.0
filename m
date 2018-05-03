From: Dave Hansen <dave.hansen@intel.com>
Subject: Re: [RFC PATCH] Add /proc/<pid>/numa_vamaps for numa node information
Date: Thu, 3 May 2018 15:26:53 -0700
Message-ID: <8569dabb-4930-aa20-6249-72457e2df51e@intel.com>
References: <1525240686-13335-1-git-send-email-prakash.sangappa@oracle.com>
 <20180502143323.1c723ccb509c3497050a2e0a@linux-foundation.org>
 <2ce01d91-5fba-b1b7-2956-c8cc1853536d@intel.com>
 <33f96879-351f-674a-ca23-43f233f4eb1d@linux.vnet.ibm.com>
 <82d2b35c-272a-ad02-692f-2c109aacdfb6@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <82d2b35c-272a-ad02-692f-2c109aacdfb6@oracle.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: prakash.sangappa@oracle.com, Anshuman Khandual <khandual@linux.vnet.ibm.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-api@vger.kernel.org, mhocko@suse.com, kirill.shutemov@linux.intel.com, n-horiguchi@ah.jp.nec.com, drepper@gmail.com, rientjes@google.com, Naoya Horiguchi <nao.horiguchi@gmail.com>
List-Id: linux-api@vger.kernel.org

On 05/03/2018 03:27 PM, prakash.sangappa wrote:
>>
> If each consecutive page comes from different node, yes in
> the extreme case is this file will have a lot of lines. All the lines
> are generated at the time file is read. The amount of data read will be
> limited to the user read buffer size used in the read.
> 
> /proc/<pid>/pagemap also has kind of  similar issue. There is 1 64
> bit value for each user page.
But nobody reads it sequentially.  Everybody lseek()s because it has a
fixed block size.  You can't do that in text.
