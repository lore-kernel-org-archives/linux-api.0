From: Josh Poimboeuf <jpoimboe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH v4 0/6] (mostly) Arch-independent livepatch
Date: Mon, 8 Feb 2016 14:28:29 -0600
Message-ID: <20160208202829.GE23106@treble.redhat.com>
References: <1454548271-24923-1-git-send-email-jeyu@redhat.com>
 <alpine.LNX.2.00.1602081548070.12964@pobox.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1602081548070.12964-ztGlSCb7Y1iN3ZZ/Hiejyg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Miroslav Benes <mbenes-AlSwsSmVLrQ@public.gmane.org>
Cc: Jessica Yu <jeyu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, Seth Jennings <sjenning-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jiri Kosina <jikos-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vojtech Pavlik <vojtech-IBi9RG/b67k@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, live-patching-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, Feb 08, 2016 at 03:54:22PM +0100, Miroslav Benes wrote:
> On Wed, 3 Feb 2016, Jessica Yu wrote:
> 
> > Jessica Yu (6):
> >   Elf: add livepatch-specific Elf constants
> >   module: preserve Elf information for livepatch modules
> >   module: s390: keep mod_arch_specific for livepatch modules
> >   livepatch: reuse module loader code to write relocations
> >   samples: livepatch: mark as livepatch module
> >   Documentation: livepatch: outline Elf format and requirements for
> >     patch modules
> 
> Hi,
> 
> I walked through the code and it looks good except for several minor 
> things in the fourth patch (livepatch: reuse module loader code to write 
> relocations). I'd propose to send the next version as a regular PATCH set 
> and not RFC. We can start collecting Reviews and Acks. Hopefully it won't 
> take more than one or two iterations. Would that be ok with everyone?

Sounds good to me...

-- 
Josh
