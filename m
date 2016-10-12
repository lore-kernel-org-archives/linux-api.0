From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: Re: [PATCH v3 0/1] man/set_mempolicy.2,mbind.2: add MPOL_LOCAL NUMA
 memory policy documentation
Date: Wed, 12 Oct 2016 16:35:26 +0200
Message-ID: <CAKgNAkjLLLkyU1-H_ur802o=mNnpOC0XAb_3TPRSc-RuRNYZFg@mail.gmail.com>
References: <alpine.DEB.2.20.1610100854001.27158@east.gentwo.org>
 <20161010162310.2463-1-kwapulinski.piotr@gmail.com> <4d816fee-4690-2ed7-7faa-c437e67cfbf5@gmail.com>
 <alpine.DEB.2.20.1610120906150.14274@east.gentwo.org>
Reply-To: mtk.manpages@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <alpine.DEB.2.20.1610120906150.14274@east.gentwo.org>
Sender: owner-linux-mm@kvack.org
To: Christoph Lameter <cl@linux.com>
Cc: Piotr Kwapulinski <kwapulinski.piotr@gmail.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Vlastimil Babka <vbabka@suse.cz>, David Rientjes <rientjes@google.com>, mhocko@kernel.org, mgorman@techsingularity.net, Liang Chen <liangchen.linux@gmail.com>, nzimmer@sgi.com, Peter Zijlstra <a.p.zijlstra@chello.nl>, Rik van Riel <riel@redhat.com>, Lee Schermerhorn <lee.schermerhorn@hp.com>, jmarchan@redhat.com, Joe Perches <joe@perches.com>, Jonathan Corbet <corbet@lwn.net>, SeokHoon Yoon <iamyooon@gmail.com>, n-horiguchi@ah.jp.nec.com, "linux-mm@kvack.org" <linux-mm@kvack.org>, lkml <linux-kernel@vger.kernel.org>, linux-man <linux-man@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, linux-doc@vger.kernel.org, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Hi Christoph,

On 12 October 2016 at 16:08, Christoph Lameter <cl@linux.com> wrote:
> On Wed, 12 Oct 2016, Michael Kerrisk (man-pages) wrote:
>
>> > +arguments must specify the empty set. If the "local node" is low
>> > +on free memory the kernel will try to allocate memory from other
>> > +nodes. The kernel will allocate memory from the "local node"
>> > +whenever memory for this node is available. If the "local node"
>> > +is not allowed by the process's current cpuset context the kernel
>> > +will try to allocate memory from other nodes. The kernel will
>> > +allocate memory from the "local node" whenever it becomes allowed
>> > +by the process's current cpuset context. In contrast
>> > +.B MPOL_DEFAULT
>> > +reverts to the policy of the process which may have been set with
>> > +.BR set_mempolicy (2).
>> > +It may not be the "local allocation".
>>
>> What is the sense of "may not be" here? (And repeated below).
>> Is the meaning "this could be something other than"?
>> Presumably the answer is yes, in which case I'll clarify
>> the wording there. Let me know.
>
> Someone may have set for example a round robin policy with numactl
> --interleave before starting the process? Then allocations will go through
> all nodes.

So the sense is then "this could be something other than", right?

Cheers,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
