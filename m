From: Josh Poimboeuf <jpoimboe@redhat.com>
Subject: Re: livepatch: reuse module loader code to write relocations
Date: Mon, 21 Mar 2016 14:24:03 -0500
Message-ID: <20160321192403.4km5dfxtsybixlpe@treble.redhat.com>
References: <1458157628-8264-1-git-send-email-jeyu@redhat.com>
 <1458157628-8264-5-git-send-email-jeyu@redhat.com>
 <alpine.LNX.2.00.1603211449240.12175@pobox.suse.cz>
 <20160321191832.GC12357@packer-debian-8-amd64.digitalocean.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160321191832.GC12357@packer-debian-8-amd64.digitalocean.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jessica Yu <jeyu@redhat.com>
Cc: Miroslav Benes <mbenes@suse.cz>, Rusty Russell <rusty@rustcorp.com.au>, Petr Mladek <pmladek@suse.com>, Jiri Kosina <jikos@kernel.org>, Jonathan Corbet <corbet@lwn.net>, linux-api@vger.kernel.org, live-patching@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org, linux-doc@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon, Mar 21, 2016 at 03:18:32PM -0400, Jessica Yu wrote:
> +++ Miroslav Benes [21/03/16 14:55 +0100]:
> >On Wed, 16 Mar 2016, Jessica Yu wrote:
> >
> >[...]
> >
> >>+struct klp_buf {
> >>+	char symname[KSYM_SYMBOL_LEN];
> >
> >I think it is better to make this KSYM_NAME_LEN. KSYM_SYMBOL_LEN looks
> >like something different and KSYM_NAME_LEN is 128 which you reference
> >below.
> >
> 
> Ack, I did mean to use KSYM_NAME_LEN, thanks.
> 
> >>+	char objname[MODULE_NAME_LEN];
> >>+};
> >
> >[...]
> >
> >>+static int klp_resolve_symbols(Elf_Shdr *relasec, struct module *pmod)
> >>+{
> >>+	int i, cnt, vmlinux, ret;
> >>+	struct klp_buf bufs = {0};
> >>+	Elf_Rela *relas;
> >>+	Elf_Sym *sym;
> >>+	char *symname;
> >>+	unsigned long sympos;
> >>+
> >>+	relas = (Elf_Rela *) relasec->sh_addr;
> >>+	/* For each rela in this klp relocation section */
> >>+	for (i = 0; i < relasec->sh_size / sizeof(Elf_Rela); i++) {
> >>+		sym = pmod->core_kallsyms.symtab + ELF_R_SYM(relas[i].r_info);
> >>+		if (sym->st_shndx != SHN_LIVEPATCH)
> >>+			return -EINVAL;
> >>+
> >>+		klp_clear_buf(&bufs);
> >>+
> >>+		/* Format: .klp.sym.objname.symbol_name,sympos */
> >>+		symname = pmod->core_kallsyms.strtab + sym->st_name;
> >>+		cnt = sscanf(symname, ".klp.sym.%64[^.].%128[^,],%lu",
> >>+			     bufs.objname, bufs.symname, &sympos);
> >
> >It would be really nice to change actual values for their macro
> >definitions, but this would be a mess which is not worth it. Anyway
> >shouldn't those width modifiers be %63 and %127 to make a room for \0?
> >
> 
> Yes, this is a concern and I'm not sure what the best way to fix it
> is. If both MODULE_NAME_LEN and KSYM_NAME_LEN were straight up
> constants, then I think Josh's stringify approach would have worked
> perfectly. However since MODULE_NAME_LEN translates to an expression
> (64 - sizeof(unsigned long)), which the preprocessor cannot evaluate,
> we will need another approach. Building the format strings at run time
> might be messier than we'd like. Alternatively we could just go the
> simple route and simply be a bit more aggressive on the upper bound
> for the format width; though the size of long varies on different
> architectures, afaik the max size it could ever be on any arch is 8
> bytes, so perhaps 64 - 8 = 56 (then - 1 to make room for \0) might be
> an appropriate field width. This would deserve a comment as well.

I think something like that would be good, along with:

  BUILD_BUG_ON(MODULE_NAME_LEN < 56);

and a comment explaining why.

-- 
Josh
