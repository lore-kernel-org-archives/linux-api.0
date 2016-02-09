From: Jiri Kosina <jikos@kernel.org>
Subject: Re: [RFC PATCH v4 2/6] module: preserve Elf information for livepatch
 modules
Date: Tue, 9 Feb 2016 11:33:07 +0100 (CET)
Message-ID: <alpine.LNX.2.00.1602091131510.22727@cbobk.fhfr.pm>
References: <1454548271-24923-1-git-send-email-jeyu@redhat.com> <1454548271-24923-3-git-send-email-jeyu@redhat.com> <20160209084443.GA12548@pathway.suse.cz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160209084443.GA12548@pathway.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Petr Mladek <pmladek@suse.com>
Cc: Jessica Yu <jeyu@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>, Josh Poimboeuf <jpoimboe@redhat.com>, Seth Jennings <sjenning@redhat.com>, Vojtech Pavlik <vojtech@suse.com>, Jonathan Corbet <corbet@lwn.net>, Miroslav Benes <mbenes@suse.cz>, linux-api@vger.kernel.org, live-patching@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org, linux-doc@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Tue, 9 Feb 2016, Petr Mladek wrote:

> > +#ifdef CONFIG_KALLSYMS
> > +	/* Make symtab and strtab available prior to module init call */
> > +	mod->num_symtab = mod->core_num_syms;
> > +	mod->symtab = mod->core_symtab;
> > +	mod->strtab = mod->core_strtab;
> > +#endif
> 
> This should be done with module_mutex. Otherwise, it looks racy at least 
> against module_kallsyms_on_each_symbol().

Hmm, if this is the case, the comment describing the locking rules for 
module_mutex should be updated.

> BTW: I wonder why even the original code is not racy for example against 
> module_get_kallsym. It is called without the mutex. This code sets the 
> number of entries before the pointer to the entries.
> 
> Note that the module is in the list even in the UNFORMED state.

module_kallsyms_on_each_symbol() gives up in such case though.

-- 
Jiri Kosina
SUSE Labs
