From: Jiri Slaby <jslaby@suse.cz>
Subject: Re: [RFC PATCH 3/5] livepatch: reuse module loader code to write
 relocations
Date: Tue, 10 Nov 2015 09:13:27 +0100
Message-ID: <5641A727.6020708@suse.cz>
References: <1447130755-17383-1-git-send-email-jeyu@redhat.com>
 <1447130755-17383-4-git-send-email-jeyu@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1447130755-17383-4-git-send-email-jeyu@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jessica Yu <jeyu@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>, Josh Poimboeuf <jpoimboe@redhat.com>, Seth Jennings <sjenning@redhat.com>, Jiri Kosina <jikos@kernel.org>, Vojtech Pavlik <vojtech@suse.com>, Miroslav Benes <mbenes@suse.cz>
Cc: linux-api@vger.kernel.org, live-patching@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 11/10/2015, 05:45 AM, Jessica Yu wrote:
> @@ -95,7 +95,7 @@ struct klp_reloc {
>  struct klp_object {
>  	/* external */
>  	const char *name;
> -	struct klp_reloc *relocs;
> +	struct list_head reloc_secs;

Too early to proper review the code, but you seem you never call
INIT_LIST_HEAD for this guy.

thanks,
-- 
js
suse labs
