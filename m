From: Miroslav Benes <mbenes@suse.cz>
Subject: Re: [PATCH v5 3/6] module: s390: keep mod_arch_specific for livepatch
 modules
Date: Mon, 21 Mar 2016 14:49:11 +0100 (CET)
Message-ID: <alpine.LNX.2.00.1603211449030.12175@pobox.suse.cz>
References: <1458157628-8264-1-git-send-email-jeyu@redhat.com> <1458157628-8264-4-git-send-email-jeyu@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <1458157628-8264-4-git-send-email-jeyu@redhat.com>
Sender: linux-doc-owner@vger.kernel.org
To: Jessica Yu <jeyu@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Josh Poimboeuf <jpoimboe@redhat.com>, Petr Mladek <pmladek@suse.com>, Jiri Kosina <jikos@kernel.org>, Jonathan Corbet <corbet@lwn.net>, linux-api@vger.kernel.org, live-patching@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org, linux-doc@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, 16 Mar 2016, Jessica Yu wrote:

> Livepatch needs to utilize the symbol information contained in the
> mod_arch_specific struct in order to be able to call the s390
> apply_relocate_add() function to apply relocations. Keep a reference to
> syminfo if the module is a livepatch module. Remove the redundant vfree()
> in module_finalize() since module_arch_freeing_init() (which also frees
> those structures) is called in do_init_module(). If the module isn't a
> livepatch module, we free the structures in module_arch_freeing_init() as
> usual.
> 
> Signed-off-by: Jessica Yu <jeyu@redhat.com>

Reviewed-by: Miroslav Benes <mbenes@suse.cz>
