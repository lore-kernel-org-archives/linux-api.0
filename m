From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [REGRESSION] testing/selftests/x86/ pkeys build failures (was:
 Re: [PATCH] mm, x86: pkeys: Introduce PKEY_ALLOC_SIGNALINHERIT and change
 signal semantics)
Date: Fri, 12 Jan 2018 15:14:49 +0100
Message-ID: <20180112141449.5gmn3nxvosk6y6qs@gmail.com>
References: <360ef254-48bc-aee6-70f9-858f773b8693@redhat.com>
 <20180112125537.bdl376ziiaqp664o@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20180112125537.bdl376ziiaqp664o@gmail.com>
Sender: owner-linux-mm@kvack.org
To: Florian Weimer <fweimer@redhat.com>, Shuah Khan <shuahkh@osg.samsung.com>, Dave Hansen <dave.hansen@linux.intel.com>
Cc: linux-mm <linux-mm@kvack.org>, linux-arch <linux-arch@vger.kernel.org>, linux-x86_64@vger.kernel.org, Linux API <linux-api@vger.kernel.org>, x86@kernel.org, Dave Hansen <dave.hansen@intel.com>, Ram Pai <linuxram@us.ibm.com>
List-Id: linux-api@vger.kernel.org


* Ingo Molnar <mingo@kernel.org> wrote:

> Also, the protection keys testcase first need to be fixed, before we complicate 
> them - for example on a pretty regular Ubuntu x86-64 installation they fail to 
> build with the build errors attached further below.
> 
> On an older Fedora 23 installation, the testcases themselves don't build at all:

The Ubuntu build failure seems to have gone away after a 'make clean', what 
remains is an ugly build warning:

triton:~/tip/tools/testing/selftests/x86> make
gcc -m32 -o /home/mingo/tip/tools/testing/selftests/x86/protection_keys_32 -O2 -g -std=gnu99 -pthread -Wall -no-pie  protection_keys.c -lrt -ldl -lm
protection_keys.c: In function ‘dumpit’:
protection_keys.c:419:3: warning: ignoring return value of ‘write’, declared with attribute warn_unused_result [-Wunused-result]
   write(1, buf, nr_read);
   ^~~~~~~~~~~~~~~~~~~~~~
gcc -m64 -o /home/mingo/tip/tools/testing/selftests/x86/protection_keys_64 -O2 -g -std=gnu99 -pthread -Wall -no-pie  protection_keys.c -lrt -ldl
protection_keys.c: In function ‘dumpit’:
protection_keys.c:419:3: warning: ignoring return value of ‘write’, declared with attribute warn_unused_result [-Wunused-result]
   write(1, buf, nr_read);
   ^~~~~~~~~~~~~~~~~~~~~~

If this build warning and the Fedora build failure is fixed we can apply your 
patch too I think.

Thanks,

	Ingo

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
