From: Josh Poimboeuf <jpoimboe@redhat.com>
Subject: Re: [PATCH v5 5/6] samples: livepatch: mark as livepatch module
Date: Mon, 21 Mar 2016 10:54:40 -0500
Message-ID: <20160321155440.etril3oddnqwnval@treble.redhat.com>
References: <1458157628-8264-1-git-send-email-jeyu@redhat.com>
 <1458157628-8264-6-git-send-email-jeyu@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1458157628-8264-6-git-send-email-jeyu@redhat.com>
Sender: linux-doc-owner@vger.kernel.org
To: Jessica Yu <jeyu@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Petr Mladek <pmladek@suse.com>, Jiri Kosina <jikos@kernel.org>, Jonathan Corbet <corbet@lwn.net>, Miroslav Benes <mbenes@suse.cz>, linux-api@vger.kernel.org, live-patching@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org, linux-doc@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, Mar 16, 2016 at 03:47:07PM -0400, Jessica Yu wrote:
> Mark the module as a livepatch module so that the module loader can
> appropriately identify and initialize it.
> 
> Signed-off-by: Jessica Yu <jeyu@redhat.com>
> ---
>  samples/livepatch/livepatch-sample.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/samples/livepatch/livepatch-sample.c b/samples/livepatch/livepatch-sample.c
> index fb8c861..e34f871 100644
> --- a/samples/livepatch/livepatch-sample.c
> +++ b/samples/livepatch/livepatch-sample.c
> @@ -89,3 +89,4 @@ static void livepatch_exit(void)
>  module_init(livepatch_init);
>  module_exit(livepatch_exit);
>  MODULE_LICENSE("GPL");
> +MODULE_INFO(livepatch, "Y");

This patch should probably either be before the previous patch in the
series, or just squashed into it.  Otherwise the sample module could
fail to work between the two commits and could break bisectability.

-- 
Josh
