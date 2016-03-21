From: Miroslav Benes <mbenes@suse.cz>
Subject: Re: [PATCH v5 2/6] module: preserve Elf information for livepatch
 modules
Date: Mon, 21 Mar 2016 14:48:56 +0100 (CET)
Message-ID: <alpine.LNX.2.00.1603211447430.12175@pobox.suse.cz>
References: <1458157628-8264-1-git-send-email-jeyu@redhat.com> <1458157628-8264-3-git-send-email-jeyu@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <1458157628-8264-3-git-send-email-jeyu@redhat.com>
Sender: linux-doc-owner@vger.kernel.org
To: Jessica Yu <jeyu@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Josh Poimboeuf <jpoimboe@redhat.com>, Petr Mladek <pmladek@suse.com>, Jiri Kosina <jikos@kernel.org>, Jonathan Corbet <corbet@lwn.net>, linux-api@vger.kernel.org, live-patching@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org, linux-doc@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, 16 Mar 2016, Jessica Yu wrote:

> For livepatch modules, copy Elf section, symbol, and string information
> from the load_info struct in the module loader. Persist copies of the
> original symbol table and string table.
> 
> Livepatch manages its own relocation sections in order to reuse module
> loader code to write relocations. Livepatch modules must preserve Elf
> information such as section indices in order to apply livepatch relocation
> sections using the module loader's apply_relocate_add() function.
> 
> In order to apply livepatch relocation sections, livepatch modules must
> keep a complete copy of their original symbol table in memory. Normally, a
> stripped down copy of a module's symbol table (containing only "core"
> symbols) is made available through module->core_symtab. But for livepatch
> modules, the symbol table copied into memory on module load must be exactly
> the same as the symbol table produced when the patch module was compiled.
> This is because the relocations in each livepatch relocation section refer
> to their respective symbols with their symbol indices, and the original
> symbol indices (and thus the symtab ordering) must be preserved in order
> for apply_relocate_add() to find the right symbol.
> 
> Signed-off-by: Jessica Yu <jeyu@redhat.com>

With a fix for a bug reported by kbuild test robot

Reviewed-by: Miroslav Benes <mbenes@suse.cz>
