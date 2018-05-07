From: Christopher Lameter <cl@linux.com>
Subject: Re: [RFC PATCH] Add /proc/<pid>/numa_vamaps for numa node
 information
Date: Mon, 7 May 2018 09:47:17 -0500 (CDT)
Message-ID: <alpine.DEB.2.21.1805070945200.21162@nuc-kabylake>
References: <1525240686-13335-1-git-send-email-prakash.sangappa@oracle.com> <alpine.DEB.2.21.1805031259210.7831@nuc-kabylake> <c80ee329-084b-367f-1937-3175c178e978@oracle.com> <alpine.DEB.2.21.1805040955550.10847@nuc-kabylake>
 <98e34010-d55a-5f2d-7d98-cba424de2e74@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="8323329-764230289-1525704437=:21162"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <98e34010-d55a-5f2d-7d98-cba424de2e74@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Prakash Sangappa <prakash.sangappa@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-api@vger.kernel.org, akpm@linux-foundation.org, mhocko@suse.com, kirill.shutemov@linux.intel.com, n-horiguchi@ah.jp.nec.com, drepper@gmail.com, rientjes@google.com
List-Id: linux-api@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-764230289-1525704437=:21162
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Fri, 4 May 2018, Prakash Sangappa wrote:
> Currently 'numa_maps' gives a list of numa nodes, memory is allocated per
> VMA.
> Ex. we get something like from numa_maps.
>
> 04000  N0=1,N2=2 kernelpagesize_KB=4
>
> First is the start address of a VMA. This VMA could be much larger then 3 4k
> pages.
> It does not say which address in the VMA has the pages mapped.

Not precise. First the address is there as you already said. That is the
virtual address of the beginning of the VMA. What is missing? You need
each address for each page? Length of the VMA segment?
Physical address?

--8323329-764230289-1525704437=:21162--
