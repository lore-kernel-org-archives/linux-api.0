From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [RFC PATCH] Add /proc/<pid>/numa_vamaps for numa node information
Date: Fri, 4 May 2018 13:12:11 +0200
Message-ID: <20180504111211.GO4535@dhcp22.suse.cz>
References: <1525240686-13335-1-git-send-email-prakash.sangappa@oracle.com>
 <alpine.DEB.2.21.1805031259210.7831@nuc-kabylake>
 <c80ee329-084b-367f-1937-3175c178e978@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <c80ee329-084b-367f-1937-3175c178e978@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "prakash.sangappa" <prakash.sangappa@oracle.com>
Cc: Christopher Lameter <cl@linux.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-api@vger.kernel.org, akpm@linux-foundation.org, kirill.shutemov@linux.intel.com, n-horiguchi@ah.jp.nec.com, drepper@gmail.com, rientjes@google.com
List-Id: linux-api@vger.kernel.org

On Thu 03-05-18 15:39:49, prakash.sangappa wrote:
> 
> 
> On 05/03/2018 11:03 AM, Christopher Lameter wrote:
> > On Tue, 1 May 2018, Prakash Sangappa wrote:
> > 
> > > For analysis purpose it is useful to have numa node information
> > > corresponding mapped address ranges of the process. Currently
> > > /proc/<pid>/numa_maps provides list of numa nodes from where pages are
> > > allocated per VMA of the process. This is not useful if an user needs to
> > > determine which numa node the mapped pages are allocated from for a
> > > particular address range. It would have helped if the numa node information
> > > presented in /proc/<pid>/numa_maps was broken down by VA ranges showing the
> > > exact numa node from where the pages have been allocated.
> > Cant you write a small script that scans the information in numa_maps and
> > then displays the total pages per NUMA node and then a list of which
> > ranges have how many pages on a particular node?
> 
> Don't think we can determine which numa node a given user process
> address range has pages from, based on the existing 'numa_maps' file.

yes we have. See move_pages...
 
> > > reading this file will not be restricted(i.e requiring CAP_SYS_ADMIN).
> > So a prime motivator here is security restricted access to numa_maps?
> No it is the opposite. A regular user should be able to determine
> numa node information.

Well, that breaks the layout randomization, doesn't it?
-- 
Michal Hocko
SUSE Labs
