From: Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH] mmap.2: describe the 5level paging hack
Date: Fri, 15 Feb 2019 20:13:02 +1100
Message-ID: <87sgwpct41.fsf@concordia.ellerman.id.au>
References: <20190211163653.97742-1-jannh@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20190211163653.97742-1-jannh@google.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Jann Horn <jannh@google.com>, mtk.manpages@gmail.comjannh@google.com
Cc: linux-arch@vger.kernel.org, linux-man@vger.kernel.org, linux-mm@kvack.org, Peter Zijlstra <peterz@infradead.org>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>, Will Deacon <will.deacon@arm.com>, linuxppc-dev@lists.ozlabs.org, Andy Lutomirski <luto@amacapital.net>, Dave Hansen <dave.hansen@intel.com>, Paul Mackerras <paulus@samba.org>, linux-arm-kernel@lists.infradead.org, Catalin Marinas <catalin.marinas@arm.com>, Andrew Morton <akpm@linux-foundation.org>, linux-api@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
List-Id: linux-api@vger.kernel.org

Jann Horn <jannh@google.com> writes:

> The manpage is missing information about the compatibility hack for
> 5-level paging that went in in 4.14, around commit ee00f4a32a76 ("x86/mm:
> Allow userspace have mappings above 47-bit"). Add some information about
> that.

Thanks for doing this.

> While I don't think any hardware supporting this is shipping yet (?), I
> think it's useful to try to write a manpage for this API, partly to
> figure out how usable that API actually is, and partly because when this
> hardware does ship, it'd be nice if distro manpages had information about
> how to use it.
>
> Signed-off-by: Jann Horn <jannh@google.com>
> ---
> This patch goes on top of the patch "[PATCH] mmap.2: fix description of
> treatment of the hint" that I just sent, but I'm not sending them in a
> series because I want the first one to go in, and I think this one might
> be a bit more controversial.
>
> It would be nice if the architecture maintainers and mm folks could have
> a look at this and check that what I wrote is right - I only looked at
> the source for this, I haven't tried it.
>
>  man2/mmap.2 | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
>
> diff --git a/man2/mmap.2 b/man2/mmap.2
> index 8556bbfeb..977782fa8 100644
> --- a/man2/mmap.2
> +++ b/man2/mmap.2
> @@ -67,6 +67,8 @@ is NULL,
>  then the kernel chooses the (page-aligned) address
>  at which to create the mapping;
>  this is the most portable method of creating a new mapping.
> +On Linux, in this case, the kernel may limit the maximum address that can be
> +used for allocations to a legacy limit for compatibility reasons.
>  If
>  .I addr
>  is not NULL,
> @@ -77,6 +79,19 @@ or equal to the value specified by
>  and attempt to create the mapping there.
>  If another mapping already exists there, the kernel picks a new
>  address, independent of the hint.
> +However, if a hint above the architecture's legacy address limit is provided
> +(on x86-64: above 0x7ffffffff000, on arm64: above 0x1000000000000, on ppc64 with
> +book3s: above 0x7fffffffffff or 0x3fffffffffff, depending on page size), the

It doesn't depend on page size for ppc64(le). With 4K pages the user VM
is always 64TB.

So the only boundary for us is at 128T when using 64K pages.

cheers
