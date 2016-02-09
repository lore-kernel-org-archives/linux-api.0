From: Petr Mladek <pmladek@suse.com>
Subject: Re: [RFC PATCH v4 0/6] (mostly) Arch-independent livepatch
Date: Tue, 9 Feb 2016 16:56:30 +0100
Message-ID: <20160209155630.GD12548@pathway.suse.cz>
References: <1454548271-24923-1-git-send-email-jeyu@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1454548271-24923-1-git-send-email-jeyu@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jessica Yu <jeyu@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Josh Poimboeuf <jpoimboe@redhat.com>, Seth Jennings <sjenning@redhat.com>, Jiri Kosina <jikos@kernel.org>, Vojtech Pavlik <vojtech@suse.com>, Jonathan Corbet <corbet@lwn.net>, Miroslav Benes <mbenes@suse.cz>, linux-api@vger.kernel.org, live-patching@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org, linux-doc@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed 2016-02-03 20:11:05, Jessica Yu wrote:
> This patchset removes livepatch's need for architecture-specific relocation
> code by leveraging existing code in the module loader to perform
> arch-dependent work. Specifically, instead of duplicating code and
> re-implementing what the apply_relocate_add() function in the module loader
> already does in livepatch's klp_write_module_reloc(), we reuse
> apply_relocate_add() to write relocations. The hope is that this will make
> livepatch more easily portable to other architectures and greatly reduce
> the amount of arch-specific code required to port livepatch to a particular
> architecture.
> 
> Jessica Yu (6):
>   Elf: add livepatch-specific Elf constants
>   module: s390: keep mod_arch_specific for livepatch modules
>   samples: livepatch: mark as livepatch module
>   Documentation: livepatch: outline Elf format and requirements for
>     patch modules

For the four above patches:

Reviewed-by: Petr Mladek <pmladek@suse.com>


>   module: preserve Elf information for livepatch modules
>   livepatch: reuse module loader code to write relocations

These two still need some tweaking.

I think that we are getting close. I like the way we go.
The documentation is excellent.

Thanks a lot for working on it.

Best Regards,
Petr
