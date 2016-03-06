From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH v2] sparc64: Add support for Application Data Integrity
 (ADI)
Date: Sat, 05 Mar 2016 23:07:02 -0500 (EST)
Message-ID: <20160305.230702.1325379875282120281.davem@davemloft.net>
References: <1456951177-23579-1-git-send-email-khalid.aziz@oracle.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1456951177-23579-1-git-send-email-khalid.aziz@oracle.com>
Sender: owner-linux-mm@kvack.org
To: khalid.aziz@oracle.com
Cc: corbet@lwn.net, akpm@linux-foundation.org, dingel@linux.vnet.ibm.com, zhenzhang.zhang@huawei.com, bob.picco@oracle.com, kirill.shutemov@linux.intel.com, aneesh.kumar@linux.vnet.ibm.com, aarcange@redhat.com, arnd@arndb.de, sparclinux@vger.kernel.org, rob.gardner@oracle.com, mhocko@suse.cz, chris.hyser@oracle.com, richard@nod.at, vbabka@suse.cz, koct9i@gmail.com, oleg@redhat.com, gthelen@google.com, jack@suse.cz, xiexiuqi@huawei.com, Vineet.Gupta1@synopsys.com, luto@kernel.org, ebiederm@xmission.com, bsegall@google.com, geert@linux-m68k.org, dave@stgolabs.net, adobriyan@gmail.com, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

From: Khalid Aziz <khalid.aziz@oracle.com>
Date: Wed,  2 Mar 2016 13:39:37 -0700

> 	In this
> 	first implementation I am enabling ADI for hugepages only
> 	since these pages are locked in memory and hence avoid the
> 	issue of saving and restoring tags.

This makes the feature almost entire useless.

Non-hugepages must be in the initial implementation.

> +	PR_ENABLE_SPARC_ADI - Enable ADI checking in all pages in the address
> +		range specified. The pages in the range must be already
> +		locked. This operation enables the TTE.mcd bit for the
> +		pages specified. arg2 is the starting address for address
> +		range and must be page aligned. arg3 is the length of
> +		memory address range and must be a multiple of page size.

I strongly dislike this interface, and it makes the prtctl cases look
extremely ugly and hide to the casual reader what the code is actually
doing.

This is an mprotect() operation, so add a new flag bit and implement
this via mprotect please.

Then since you are guarenteed to have a consistent ADI setting for
every single VMA region, you never "lose" the ADI state when you swap
out.  It's implicit in the VMA itself, because you'll store in the VMA
that this is an ADI region.

I also want this enabled unconditionally, without any Kconfig knobs.

Thanks.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
