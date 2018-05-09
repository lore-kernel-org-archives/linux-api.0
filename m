From: Dave Hansen <dave.hansen@intel.com>
Subject: Re: [RFC PATCH] Add /proc/<pid>/numa_vamaps for numa node information
Date: Wed, 9 May 2018 16:31:22 -0700
Message-ID: <aaca3180-7510-c008-3e12-8bbe92344ef4@intel.com>
References: <1525240686-13335-1-git-send-email-prakash.sangappa@oracle.com>
 <20180502143323.1c723ccb509c3497050a2e0a@linux-foundation.org>
 <2ce01d91-5fba-b1b7-2956-c8cc1853536d@intel.com>
 <33f96879-351f-674a-ca23-43f233f4eb1d@linux.vnet.ibm.com>
 <82d2b35c-272a-ad02-692f-2c109aacdfb6@oracle.com>
 <8569dabb-4930-aa20-6249-72457e2df51e@intel.com>
 <51145ccb-fc0d-0281-9757-fb8a5112ec24@oracle.com>
 <c72fea44-59f3-b106-8311-b5eae2d254e7@intel.com>
 <addeaadc-5ab2-f0c9-2194-dd100ae90f3a@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <addeaadc-5ab2-f0c9-2194-dd100ae90f3a@oracle.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: prakash.sangappa@oracle.com, Anshuman Khandual <khandual@linux.vnet.ibm.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-api@vger.kernel.org, mhocko@suse.com, kirill.shutemov@linux.intel.com, n-horiguchi@ah.jp.nec.com, drepper@gmail.com, rientjes@google.com, Naoya Horiguchi <nao.horiguchi@gmail.com>
List-Id: linux-api@vger.kernel.org

On 05/07/2018 06:16 PM, prakash.sangappa wrote:
> It will be /proc/<pid>/numa_vamaps. Yes, the behavior will be
> different with respect to seeking. Output will still be text and
> the format will be same.
> 
> I want to get feedback on this approach.

I think it would be really great if you can write down a list of the
things you actually want to accomplish.  Dare I say: you need a
requirements list.

The numa_vamaps approach continues down the path of an ever-growing list
of highly-specialized /proc/<pid> files.  I don't think that is
sustainable, even if it has been our trajectory for many years.

Pagemap wasn't exactly a shining example of us getting new ABIs right,
but it sounds like something along those is what we need.
