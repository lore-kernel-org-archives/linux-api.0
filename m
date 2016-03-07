From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH v2] sparc64: Add support for Application Data Integrity
 (ADI)
Date: Mon, 07 Mar 2016 11:45:21 -0500 (EST)
Message-ID: <20160307.114521.1646726145228714690.davem@davemloft.net>
References: <1456951177-23579-1-git-send-email-khalid.aziz@oracle.com>
	<20160305.230702.1325379875282120281.davem@davemloft.net>
	<56DD9949.1000106@oracle.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <56DD9949.1000106@oracle.com>
Sender: linux-arch-owner@vger.kernel.org
To: khalid.aziz@oracle.com
Cc: corbet@lwn.net, akpm@linux-foundation.org, dingel@linux.vnet.ibm.com, zhenzhang.zhang@huawei.com, bob.picco@oracle.com, kirill.shutemov@linux.intel.com, aneesh.kumar@linux.vnet.ibm.com, aarcange@redhat.com, arnd@arndb.de, sparclinux@vger.kernel.org, rob.gardner@oracle.com, mhocko@suse.cz, chris.hyser@oracle.com, richard@nod.at, vbabka@suse.cz, koct9i@gmail.com, oleg@redhat.com, gthelen@google.com, jack@suse.cz, xiexiuqi@huawei.com, Vineet.Gupta1@synopsys.com, luto@kernel.org, ebiederm@xmission.com, bsegall@google.com, geert@linux-m68k.org, dave@stgolabs.net, adobriyan@gmail.com, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

From: Khalid Aziz <khalid.aziz@oracle.com>
Date: Mon, 7 Mar 2016 08:07:53 -0700

> I can remove CONFIG_SPARC_ADI. It does mean this code will be built
> into 32-bit kernels as well but it will be inactive code.

The code should be built only into obj-$(CONFIG_SPARC64) just like the
rest of the 64-bit specific code.  I don't know why in the world you
would build it into the 32-bit kernel.
