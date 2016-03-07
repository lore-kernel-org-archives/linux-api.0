From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH v2] sparc64: Add support for Application Data Integrity
 (ADI)
Date: Mon, 07 Mar 2016 14:19:50 -0500 (EST)
Message-ID: <20160307.141950.2225098078054843052.davem@davemloft.net>
References: <CALCETrXN43nT4zq2MpO90VrgK3k+DKHjOHWf7iOhS7TSBmdCPQ@mail.gmail.com>
	<56DDC6E0.4000907@oracle.com>
	<CALCETrU5NCzh3b7We8903G0_Tm-oycgP3+gS9fG+vC_rdgTddw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <CALCETrU5NCzh3b7We8903G0_Tm-oycgP3+gS9fG+vC_rdgTddw@mail.gmail.com>
Sender: linux-arch-owner@vger.kernel.org
To: luto@amacapital.net
Cc: khalid.aziz@oracle.com, corbet@lwn.net, akpm@linux-foundation.org, dingel@linux.vnet.ibm.com, bob.picco@oracle.com, kirill.shutemov@linux.intel.com, aneesh.kumar@linux.vnet.ibm.com, aarcange@redhat.com, arnd@arndb.de, sparclinux@vger.kernel.org, rob.gardner@oracle.com, mhocko@suse.cz, chris.hyser@oracle.com, richard@nod.at, vbabka@suse.cz, koct9i@gmail.com, oleg@redhat.com, gthelen@google.com, jack@suse.cz, xiexiuqi@huawei.com, Vineet.Gupta1@synopsys.com, luto@kernel.org, ebiederm@xmission.com, bsegall@google.com, geert@linux-m68k.org, dave@stgolabs.net, adobriyan@gmail.com, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 7 Mar 2016 10:49:57 -0800

> What data structure or structures changes when this stxa instruction happens?

An internal table, maintained by the CPU and/or hypervisor, and if in physical
addresses then in a region which is only accessible by the hypervisor.

The table is not accessible by the kernel at all via loads or stores.
