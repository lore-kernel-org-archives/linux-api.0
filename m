From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH v2] sparc64: Add support for Application Data Integrity
 (ADI)
Date: Tue, 08 Mar 2016 14:57:48 -0500 (EST)
Message-ID: <20160308.145748.1648298790157991002.davem@davemloft.net>
References: <56DDA6FD.4040404@oracle.com>
	<56DDBE68.6080709@linux.intel.com>
	<56DDED63.8010302@oracle.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <56DDED63.8010302@oracle.com>
Sender: linux-arch-owner@vger.kernel.org
To: khalid.aziz@oracle.com
Cc: dave.hansen@linux.intel.com, luto@amacapital.net, rob.gardner@oracle.com, corbet@lwn.net, akpm@linux-foundation.org, dingel@linux.vnet.ibm.com, zhenzhang.zhang@huawei.com, bob.picco@oracle.com, kirill.shutemov@linux.intel.com, aneesh.kumar@linux.vnet.ibm.com, aarcange@redhat.com, arnd@arndb.de, sparclinux@vger.kernel.org, mhocko@suse.cz, chris.hyser@oracle.com, richard@nod.at, vbabka@suse.cz, koct9i@gmail.com, oleg@redhat.com, gthelen@google.com, jack@suse.cz, xiexiuqi@huawei.com, Vineet.Gupta1@synopsys.com, luto@kernel.org, ebiederm@xmission.com, bsegall@google.com, geert@linux-m68k.org, dave@stgolabs.net, adobriyan@gmail.com, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

From: Khalid Aziz <khalid.aziz@oracle.com>
Date: Mon, 7 Mar 2016 14:06:43 -0700

> Good questions. Isn't set of valid VAs already constrained by VA_BITS
> (set to 44 in arch/sparc/include/asm/processor_64.h)? As I see it we
> are already not using the top 4 bits. Please correct me if I am wrong.

Another limiting constraint is the number of address bits coverable by
the 4-level page tables we use.  And this is sign extended so we have
a top-half and a bottom-half with a "hole" in the center of the VA
space.

I want some clarification on the top bits during ADI accesses.

If ADI is enabled, then the top bits of the virtual address are
intepreted as tag bits.  Once "verified" with the ADI settings, what
happense to these tag bits?  Are they dropped from the virtual address
before being passed down the TLB et al. for translations?

If not, then this means you have to map ADI memory to the correct
location so that the tags match up.

And if that's the case, if you really wanted to mix tags within a
single page, you'd have to map that page several times, once for each
and every cacheline granular tag you'd like to use within that page.
