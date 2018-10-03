From: Eugene Syromiatnikov <esyr@redhat.com>
Subject: Re: [RFC PATCH v4 10/27] drm/i915/gvt: Update _PAGE_DIRTY to
 _PAGE_DIRTY_BITS
Date: Wed, 3 Oct 2018 15:19:11 +0200
Message-ID: <20181003131911.GB32759@asgard.redhat.com>
References: <20180921150351.20898-1-yu-cheng.yu@intel.com>
 <20180921150351.20898-11-yu-cheng.yu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180921150351.20898-11-yu-cheng.yu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Yu-cheng Yu <yu-cheng.yu@intel.com>
Cc: x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@amacapital.net>, Balbir Singh <bsingharora@gmail.com>, Cyrill Gorcunov <gorcunov@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Florian Weimer <fweimer@redhat.com>, "H.J. Lu" <hjl.tools@gmail.com>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Mike Kravetz <mike.kravetz@oracle.com>, Nadav Amit <nadav.amit@gmail.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Machek <pavel@ucw.cz>Peter
List-Id: linux-api@vger.kernel.org

On Fri, Sep 21, 2018 at 08:03:34AM -0700, Yu-cheng Yu wrote:
> Update _PAGE_DIRTY to _PAGE_DIRTY_BITS in split_2MB_gtt_entry().
> 
> In order to support Control Flow Enforcement (CET), _PAGE_DIRTY
> is now _PAGE_DIRTY_HW or _PAGE_DIRTY_SW.
> 
> Signed-off-by: Yu-cheng Yu <yu-cheng.yu@intel.com>
> ---
>  drivers/gpu/drm/i915/gvt/gtt.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/i915/gvt/gtt.c b/drivers/gpu/drm/i915/gvt/gtt.c
> index 00aad8164dec..2d6ba1462dd8 100644
> --- a/drivers/gpu/drm/i915/gvt/gtt.c
> +++ b/drivers/gpu/drm/i915/gvt/gtt.c
> @@ -1170,7 +1170,7 @@ static int split_2MB_gtt_entry(struct intel_vgpu *vgpu,
>  	}
>  
>  	/* Clear dirty field. */
> -	se->val64 &= ~_PAGE_DIRTY;
> +	se->val64 &= ~_PAGE_DIRTY_BITS;

_PAGE_DIRTY_BITS is defined only in "[RFC PATCH v4 11/27] x86/mm:
Introduce _PAGE_DIRTY_SW",
