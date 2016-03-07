From: Dave Hansen <dave.hansen@linux.intel.com>
Subject: Re: [PATCH v2] sparc64: Add support for Application Data Integrity
 (ADI)
Date: Mon, 7 Mar 2016 14:40:57 -0800
Message-ID: <56DE0379.8020907@linux.intel.com>
References: <56DDC47C.8010206@linux.intel.com> <56DDCAD3.3090106@oracle.com>
 <CALCETrVNM7ZcN7WnmLRMDqGrcYXn9xYWJfjMVwFLdiQS63-TcA@mail.gmail.com>
 <20160307.142245.846579748692522977.davem@davemloft.net>
 <56DDDA78.2070106@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <sparclinux-owner@vger.kernel.org>
In-Reply-To: <56DDDA78.2070106@oracle.com>
Sender: sparclinux-owner@vger.kernel.org
To: Khalid Aziz <khalid.aziz@oracle.com>, David Miller <davem@davemloft.net>, luto@amacapital.net
Cc: rob.gardner@oracle.com, corbet@lwn.net, akpm@linux-foundation.org, dingel@linux.vnet.ibm.com, bob.picco@oracle.com, kirill.shutemov@linux.intel.com, aneesh.kumar@linux.vnet.ibm.com, aarcange@redhat.com, arnd@arndb.de, sparclinux@vger.kernel.org, mhocko@suse.cz, chris.hyser@oracle.com, richard@nod.at, vbabka@suse.cz, koct9i@gmail.com, oleg@redhat.com, gthelen@google.com, jack@suse.cz, xiexiuqi@huawei.com, Vineet.Gupta1@synopsys.com, luto@kernel.org, ebiederm@xmission.com, bsegall@google.com, geert@linux-m68k.org, dave@stgolabs.net, adobriyan@gmail.com, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 03/07/2016 11:46 AM, Khalid Aziz wrote:
> On 03/07/2016 12:22 PM, David Miller wrote:
>> Khalid, maybe you should share notes with the folks working on x86
>> protection keys.
> 
> Good idea. Sparc ADI feature is indeed similar to x86 protection keys
> sounds like.

There are definitely some similarities.  But protection keys doesn't
have any additional tables in which to keep metadata.  It keeps all of
its data in the page tables.  It also doesn't have an impact on the
virtual address layout.

But, it does have metadata to store in the VMA, has a special
siginfo->si_code, and it uses mprotect() (although a new pkey_mprotect()
variant that takes an extra argument).

Protection Keys are described a bit more here:

> http://git.kernel.org/cgit/linux/kernel/git/daveh/x86-pkeys.git/tree/Documentation/x86/protection-keys.txt?h=pkeys-v025&id=1b5b8a8836de8eb667027178b4820665dea5a038

MPX is another Intel feature separate from protection keys, but *it* has
some tables that it keep its metadata memory and special special
instructions to move metadata in and out of it.  It also has a prctl()
to enable/disable kernel assistance for the feature.  Unlike ADI, the
tables are exposed (and accessible) to user applications in normal
application memory.

MPX's documentation is here:

> http://git.kernel.org/cgit/linux/kernel/git/daveh/x86-pkeys.git/tree/Documentation/x86/intel_mpx.txt

Overall, I'm not seeing much overlap at all between the features, honestly.
