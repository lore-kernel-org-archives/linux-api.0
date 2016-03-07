From: Dave Hansen <dave.hansen@intel.com>
Subject: Re: [PATCH v2] sparc64: Add support for Application Data Integrity
 (ADI)
Date: Mon, 7 Mar 2016 09:32:08 -0800
Message-ID: <56DDBB18.6030505@intel.com>
References: <1456951177-23579-1-git-send-email-khalid.aziz@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <1456951177-23579-1-git-send-email-khalid.aziz@oracle.com>
Sender: linux-arch-owner@vger.kernel.org
To: Khalid Aziz <khalid.aziz@oracle.com>, davem@davemloft.net, corbet@lwn.net, akpm@linux-foundation.org, dingel@linux.vnet.ibm.com, zhenzhang.zhang@huawei.com, bob.picco@oracle.com, kirill.shutemov@linux.intel.com, aneesh.kumar@linux.vnet.ibm.com, aarcange@redhat.com, arnd@arndb.de, sparclinux@vger.kernel.org
Cc: rob.gardner@oracle.com, mhocko@suse.cz, chris.hyser@oracle.com, richard@nod.at, vbabka@suse.cz, koct9i@gmail.com, oleg@redhat.com, gthelen@google.com, jack@suse.cz, xiexiuqi@huawei.com, Vineet.Gupta1@synopsys.com, luto@kernel.org, ebiederm@xmission.com, bsegall@google.com, geert@linux-m68k.org, dave@stgolabs.net, adobriyan@gmail.com, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 03/02/2016 12:39 PM, Khalid Aziz wrote:
> --- a/include/uapi/asm-generic/siginfo.h
> +++ b/include/uapi/asm-generic/siginfo.h
> @@ -206,7 +206,10 @@ typedef struct siginfo {
>  #define SEGV_MAPERR	(__SI_FAULT|1)	/* address not mapped to object */
>  #define SEGV_ACCERR	(__SI_FAULT|2)	/* invalid permissions for mapped object */
>  #define SEGV_BNDERR	(__SI_FAULT|3)  /* failed address bound checks */
> -#define NSIGSEGV	3
> +#define SEGV_ACCADI	(__SI_FAULT|4)	/* ADI not enabled for mapped object */
> +#define SEGV_ADIDERR	(__SI_FAULT|5)	/* Disrupting MCD error */
> +#define SEGV_ADIPERR	(__SI_FAULT|6)	/* Precise MCD exception */
> +#define NSIGSEGV	6

FYI, this will conflict with code in -tip right now:

> http://git.kernel.org/cgit/linux/kernel/git/tip/tip.git/commit/?h=mm/pkeys&id=cd0ea35ff5511cde299a61c21a95889b4a71464e

It's not a big deal to resolve, of course.
