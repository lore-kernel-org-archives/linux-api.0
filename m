From: Miroslav Benes <mbenes@suse.cz>
Subject: Re: [PATCH v2] livepatch: old_name.number scheme in livepatch sysfs
 directory
Date: Tue, 3 Nov 2015 10:50:05 +0100 (CET)
Message-ID: <alpine.LNX.2.00.1511031043470.6257@pobox.suse.cz>
References: <20151102203241.GF27488@treble.redhat.com> <1446505187-28970-1-git-send-email-chris.j.arges@canonical.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1446505187-28970-1-git-send-email-chris.j.arges@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Chris J Arges <chris.j.arges@canonical.com>
Cc: live-patching@vger.kernel.org, jeyu@redhat.com, Josh Poimboeuf <jpoimboe@redhat.com>, Seth Jennings <sjenning@redhat.com>, Jiri Kosina <jikos@kernel.org>, Vojtech Pavlik <vojtech@suse.com>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon, 2 Nov 2015, Chris J Arges wrote:

> The following directory structure will allow for cases when the same
> function name exists in a single object.
> 	/sys/kernel/livepatch/<patch>/<object>/<function.number>

There is still a period here and in the documentation :)

> The number corresponds to the nth occurrence of the symbol name in
> kallsyms for the patched object.
> 
> An example of this issue is documented here:
> 	https://github.com/dynup/kpatch/issues/493
> 
> Signed-off-by: Chris J Arges <chris.j.arges@canonical.com>
> ---
>  Documentation/ABI/testing/sysfs-kernel-livepatch |  2 +-
>  kernel/livepatch/core.c                          | 45 ++++++++++++++++++++++--
>  2 files changed, 44 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/ABI/testing/sysfs-kernel-livepatch b/Documentation/ABI/testing/sysfs-kernel-livepatch
> index 5bf42a8..dcd36db 100644
> --- a/Documentation/ABI/testing/sysfs-kernel-livepatch
> +++ b/Documentation/ABI/testing/sysfs-kernel-livepatch
> @@ -33,7 +33,7 @@ Description:
>  		The object directory contains subdirectories for each function
>  		that is patched within the object.
>  
> -What:		/sys/kernel/livepatch/<patch>/<object>/<function>
> +What:		/sys/kernel/livepatch/<patch>/<object>/<function.number>

Dash should be here.

Since it is a documentation, could you add few words what this number is? 
I think that the sentence "The number corresponds..." from the changelog 
above would be great.

>  Date:		Nov 2014
>  KernelVersion:	3.19.0
>  Contact:	live-patching@vger.kernel.org
> diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
> index 6e53441..6bcf600 100644
> --- a/kernel/livepatch/core.c
> +++ b/kernel/livepatch/core.c
> @@ -587,7 +587,7 @@ EXPORT_SYMBOL_GPL(klp_enable_patch);
>   * /sys/kernel/livepatch/<patch>
>   * /sys/kernel/livepatch/<patch>/enabled
>   * /sys/kernel/livepatch/<patch>/<object>
> - * /sys/kernel/livepatch/<patch>/<object>/<func>
> + * /sys/kernel/livepatch/<patch>/<object>/<func.number>

And here.

The rest is fine.

Thanks a lot for the patch
Miroslav
