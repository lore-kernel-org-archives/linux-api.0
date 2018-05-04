From: Christopher Lameter <cl@linux.com>
Subject: Re: [RFC PATCH] Add /proc/<pid>/numa_vamaps for numa node
 information
Date: Fri, 4 May 2018 09:57:54 -0500 (CDT)
Message-ID: <alpine.DEB.2.21.1805040955550.10847@nuc-kabylake>
References: <1525240686-13335-1-git-send-email-prakash.sangappa@oracle.com> <alpine.DEB.2.21.1805031259210.7831@nuc-kabylake> <c80ee329-084b-367f-1937-3175c178e978@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <c80ee329-084b-367f-1937-3175c178e978@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "prakash.sangappa" <prakash.sangappa@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-api@vger.kernel.org, akpm@linux-foundation.org, mhocko@suse.com, kirill.shutemov@linux.intel.com, n-horiguchi@ah.jp.nec.com, drepper@gmail.com, rientjes@google.com
List-Id: linux-api@vger.kernel.org

On Thu, 3 May 2018, prakash.sangappa wrote:

> > > exact numa node from where the pages have been allocated.
> > Cant you write a small script that scans the information in numa_maps and
> > then displays the total pages per NUMA node and then a list of which
> > ranges have how many pages on a particular node?
>
> Don't think we can determine which numa node a given user process
> address range has pages from, based on the existing 'numa_maps' file.

Well the information is contained in numa_maps I thought. What is missing?

> > > reading this file will not be restricted(i.e requiring CAP_SYS_ADMIN).
> > So a prime motivator here is security restricted access to numa_maps?
> No it is the opposite. A regular user should be able to determine
> numa node information.

That used to be the case until changes were made to the permissions for
reading numa_maps.
