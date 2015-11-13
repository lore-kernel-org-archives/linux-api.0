From: Miroslav Benes <mbenes-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: module: save load_info for livepatch modules
Date: Fri, 13 Nov 2015 13:46:34 +0100 (CET)
Message-ID: <alpine.LNX.2.00.1511131338510.15073@pobox.suse.cz>
References: <1447130755-17383-1-git-send-email-jeyu@redhat.com> <1447130755-17383-3-git-send-email-jeyu@redhat.com> <alpine.LNX.2.00.1511111505300.12467@pobox.suse.cz> <20151112053228.GD30025@packer-debian-8-amd64.digitalocean.com> <20151112102404.GL4431@pathway.suse.cz>
 <alpine.LNX.2.00.1511121400290.9440@pobox.suse.cz> <20151112150345.GT2599@pathway.suse.cz> <20151112170501.GD4038@treble.hsd1.ky.comcast.net> <20151112221750.GA13513@packer-debian-8-amd64.digitalocean.com>
 <alpine.LNX.2.00.1511131304280.15073@pobox.suse.cz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.LNX.2.00.1511131304280.15073-ztGlSCb7Y1iN3ZZ/Hiejyg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jessica Yu <jeyu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Josh Poimboeuf <jpoimboe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, Seth Jennings <sjenning-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jiri Kosina <jikos-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vojtech Pavlik <vojtech-IBi9RG/b67k@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, live-patching-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Fri, 13 Nov 2015, Miroslav Benes wrote:

> As for load_info, I don't have a strong opinion whether to keep it for all 
> modules or for livepatch modules only.

I have. We cannot keep it, even for livepatch modules...

In info->hdr there is a temporary copy of the whole module (see 
init_module syscall and the first parts of load_module). In load_module 
a final struct module * is created with parts of info->hdr copied (I'll 
get to that later). So if we saved info->hdr for later purposes we would 
just have two copies of the same module in the memory. The original one 
with !SHF_ALLOC sections and everything in vmalloc area, and the new
final copy with SHF_ALLOC sections only. This is not good.

If this is correct (and I think it is after some staring into the code) we 
need to do something different. We should build the info we need for 
delayed relocations from the final copy (or refactor the existing 
module code).

The second problem... dynrela sections need to be marked with SHF_ALLOC 
flag, right? Perhaps it would be better not to do it and copy also 
SHF_RELA_LIVEPATCH sections. It is equivalent but not hidden somewhere 
else (in userspace "kpatch-build" tool).

Miroslav
