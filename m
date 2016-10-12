From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: Re: [PATCH v3 0/1] man/set_mempolicy.2,mbind.2: add MPOL_LOCAL NUMA
 memory policy documentation
Date: Wed, 12 Oct 2016 09:55:16 +0200
Message-ID: <4d816fee-4690-2ed7-7faa-c437e67cfbf5@gmail.com>
References: <alpine.DEB.2.20.1610100854001.27158@east.gentwo.org>
 <20161010162310.2463-1-kwapulinski.piotr@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20161010162310.2463-1-kwapulinski.piotr@gmail.com>
Sender: owner-linux-mm@kvack.org
To: Piotr Kwapulinski <kwapulinski.piotr@gmail.com>
Cc: mtk.manpages@gmail.com, kirill.shutemov@linux.intel.com, vbabka@suse.cz, rientjes@google.com, mhocko@kernel.org, mgorman@techsingularity.net, liangchen.linux@gmail.com, nzimmer@sgi.com, a.p.zijlstra@chello.nl, cl@linux.com, riel@redhat.com, lee.schermerhorn@hp.com, jmarchan@redhat.com, joe@perches.com, corbet@lwn.net, iamyooon@gmail.com, n-horiguchi@ah.jp.nec.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-man@vger.kernel.org, akpm@linux-foundation.org, linux-doc@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Hello Piotr,

On 10/10/2016 06:23 PM, Piotr Kwapulinski wrote:
> The MPOL_LOCAL mode has been implemented by
> Peter Zijlstra <a.p.zijlstra@chello.nl>
> (commit: 479e2802d09f1e18a97262c4c6f8f17ae5884bd8).
> Add the documentation for this mode.

Thanks. I've applied this patch. I have a question below.

> Signed-off-by: Piotr Kwapulinski <kwapulinski.piotr@gmail.com>
> ---
> This version fixes grammar
> ---
>  man2/mbind.2         | 28 ++++++++++++++++++++++++----
>  man2/set_mempolicy.2 | 19 ++++++++++++++++++-
>  2 files changed, 42 insertions(+), 5 deletions(-)
> 
> diff --git a/man2/mbind.2 b/man2/mbind.2
> index 3ea24f6..854580c 100644
> --- a/man2/mbind.2
> +++ b/man2/mbind.2
> @@ -130,8 +130,9 @@ argument must specify one of
>  .BR MPOL_DEFAULT ,
>  .BR MPOL_BIND ,
>  .BR MPOL_INTERLEAVE ,
> +.BR MPOL_PREFERRED ,
>  or
> -.BR MPOL_PREFERRED .
> +.BR MPOL_LOCAL .
>  All policy modes except
>  .B MPOL_DEFAULT
>  require the caller to specify via the
> @@ -258,9 +259,26 @@ and
>  .I maxnode
>  arguments specify the empty set, then the memory is allocated on
>  the node of the CPU that triggered the allocation.
> -This is the only way to specify "local allocation" for a
> -range of memory via
> -.BR mbind ().
> +
> +.B MPOL_LOCAL
> +specifies the "local allocation", the memory is allocated on
> +the node of the CPU that triggered the allocation, "local node".
> +The
> +.I nodemask
> +and
> +.I maxnode
> +arguments must specify the empty set. If the "local node" is low
> +on free memory the kernel will try to allocate memory from other
> +nodes. The kernel will allocate memory from the "local node"
> +whenever memory for this node is available. If the "local node"
> +is not allowed by the process's current cpuset context the kernel
> +will try to allocate memory from other nodes. The kernel will
> +allocate memory from the "local node" whenever it becomes allowed
> +by the process's current cpuset context. In contrast
> +.B MPOL_DEFAULT
> +reverts to the policy of the process which may have been set with
> +.BR set_mempolicy (2).
> +It may not be the "local allocation".

What is the sense of "may not be" here? (And repeated below).
Is the meaning "this could be something other than"?
Presumably the answer is yes, in which case I'll clarify
the wording there. Let me know.

Cheers,

Michael


>  
>  If
>  .B MPOL_MF_STRICT
> @@ -440,6 +458,8 @@ To select explicit "local allocation" for a memory range,
>  specify a
>  .I mode
>  of
> +.B MPOL_LOCAL
> +or
>  .B MPOL_PREFERRED
>  with an empty set of nodes.
>  This method will work for
> diff --git a/man2/set_mempolicy.2 b/man2/set_mempolicy.2
> index 1f02037..22b0f7c 100644
> --- a/man2/set_mempolicy.2
> +++ b/man2/set_mempolicy.2
> @@ -79,8 +79,9 @@ argument must specify one of
>  .BR MPOL_DEFAULT ,
>  .BR MPOL_BIND ,
>  .BR MPOL_INTERLEAVE ,
> +.BR MPOL_PREFERRED ,
>  or
> -.BR MPOL_PREFERRED .
> +.BR MPOL_LOCAL .
>  All modes except
>  .B MPOL_DEFAULT
>  require the caller to specify via the
> @@ -211,6 +212,22 @@ arguments specify the empty set, then the policy
>  specifies "local allocation"
>  (like the system default policy discussed above).
>  
> +.B MPOL_LOCAL
> +specifies the "local allocation", the memory is allocated on
> +the node of the CPU that triggered the allocation, "local node".
> +The
> +.I nodemask
> +and
> +.I maxnode
> +arguments must specify the empty set. If the "local node" is low
> +on free memory the kernel will try to allocate memory from other
> +nodes. The kernel will allocate memory from the "local node"
> +whenever memory for this node is available. If the "local node"
> +is not allowed by the process's current cpuset context the kernel
> +will try to allocate memory from other nodes. The kernel will
> +allocate memory from the "local node" whenever it becomes allowed
> +by the process's current cpuset context.
> +
>  The thread memory policy is preserved across an
>  .BR execve (2),
>  and is inherited by child threads created using
> 


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
