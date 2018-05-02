From: Dave Hansen <dave.hansen@intel.com>
Subject: Re: [RFC PATCH] Add /proc/<pid>/numa_vamaps for numa node information
Date: Wed, 2 May 2018 15:28:59 -0700
Message-ID: <2ce01d91-5fba-b1b7-2956-c8cc1853536d@intel.com>
References: <1525240686-13335-1-git-send-email-prakash.sangappa@oracle.com>
 <20180502143323.1c723ccb509c3497050a2e0a@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180502143323.1c723ccb509c3497050a2e0a@linux-foundation.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Prakash Sangappa <prakash.sangappa@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-api@vger.kernel.org, mhocko@suse.com, kirill.shutemov@linux.intel.com, n-horiguchi@ah.jp.nec.com, drepper@gmail.com, rientjes@google.com, Naoya Horiguchi <nao.horiguchi@gmail.com>
List-Id: linux-api@vger.kernel.org

On 05/02/2018 02:33 PM, Andrew Morton wrote:
> On Tue,  1 May 2018 22:58:06 -0700 Prakash Sangappa <prakash.sangappa@oracle.com> wrote:
>> For analysis purpose it is useful to have numa node information
>> corresponding mapped address ranges of the process. Currently
>> /proc/<pid>/numa_maps provides list of numa nodes from where pages are
>> allocated per VMA of the process. This is not useful if an user needs to
>> determine which numa node the mapped pages are allocated from for a
>> particular address range. It would have helped if the numa node information
>> presented in /proc/<pid>/numa_maps was broken down by VA ranges showing the
>> exact numa node from where the pages have been allocated.

I'm finding myself a little lost in figuring out what this does.  Today,
numa_maps might us that a 3-page VMA has 1 page from Node 0 and 2 pages
from Node 1.  We group *entirely* by VMA:

1000-4000 N0=1 N1=2

We don't want that.  We want to tell exactly where each node's memory is
despite if they are in the same VMA, like this:

1000-2000 N1=1
2000-3000 N0=1
3000-4000 N1=1

So that no line of output ever has more than one node's memory.  It
*appears* in this new file as if each contiguous range of memory from a
given node has its own VMA.  Right?

This sounds interesting, but I've never found myself wanting this
information a single time that I can recall.  I'd love to hear more.

Is this for debugging?  Are apps actually going to *parse* this file?

How hard did you try to share code with numa_maps?  Are you sure we
can't just replace numa_maps?  VMAs are a kernel-internal thing and we
never promised to represent them 1:1 in our ABI.

Are we going to continue creating new files in /proc every time a tiny
new niche pops up? :)
