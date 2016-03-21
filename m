From: Josh Poimboeuf <jpoimboe@redhat.com>
Subject: Re: livepatch: reuse module loader code to write relocations
Date: Mon, 21 Mar 2016 16:34:45 -0500
Message-ID: <20160321213445.e64jic2uoc7tdtbl@treble.redhat.com>
References: <1458157628-8264-1-git-send-email-jeyu@redhat.com>
 <1458157628-8264-5-git-send-email-jeyu@redhat.com>
 <alpine.LNX.2.00.1603211449240.12175@pobox.suse.cz>
 <20160321191832.GC12357@packer-debian-8-amd64.digitalocean.com>
 <alpine.LNX.2.00.1603212213340.3656@cbobk.fhfr.pm>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1603212213340.3656@cbobk.fhfr.pm>
Sender: linux-doc-owner@vger.kernel.org
To: Jiri Kosina <jikos@kernel.org>
Cc: Jessica Yu <jeyu@redhat.com>, Miroslav Benes <mbenes@suse.cz>, Rusty Russell <rusty@rustcorp.com.au>, Petr Mladek <pmladek@suse.com>, Jonathan Corbet <corbet@lwn.net>, linux-api@vger.kernel.org, live-patching@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org, linux-doc@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon, Mar 21, 2016 at 10:16:17PM +0100, Jiri Kosina wrote:
> On Mon, 21 Mar 2016, Jessica Yu wrote:
> 
> > Yes, this is a concern and I'm not sure what the best way to fix it
> > is. If both MODULE_NAME_LEN and KSYM_NAME_LEN were straight up
> > constants, then I think Josh's stringify approach would have worked
> > perfectly. However since MODULE_NAME_LEN translates to an expression
> > (64 - sizeof(unsigned long)), which the preprocessor cannot evaluate,
> > we will need another approach. Building the format strings at run time
> > might be messier than we'd like. Alternatively we could just go the
> > simple route and simply be a bit more aggressive on the upper bound
> > for the format width; though the size of long varies on different
> > architectures, afaik the max size it could ever be on any arch is 8
> > bytes, so perhaps 64 - 8 = 56 (then - 1 to make room for \0) might be
> > an appropriate field width. This would deserve a comment as well.
> 
> So how about actually modifying MAX_PARAM_PREFIX_LEN so 
> that it's actually properly evaluable at preprocessing time, 
> i.e. something along the lines of
> 
> diff --git a/include/linux/moduleparam.h b/include/linux/moduleparam.h
> index 52666d9..954dae9 100644
> --- a/include/linux/moduleparam.h
> +++ b/include/linux/moduleparam.h
> @@ -14,7 +14,7 @@
>  #endif
>  
>  /* Chosen so that structs with an unsigned long line up. */
> -#define MAX_PARAM_PREFIX_LEN (64 - sizeof(unsigned long))
> +#define MAX_PARAM_PREFIX_LEN (64 - __SIZEOF_LONG__)
>  
>  #ifdef MODULE
>  #define __MODULE_INFO(tag, name, info)					  \

According to my test that still results in the literal value of
"(64 - 8)".

-- 
Josh
