From: Josh Poimboeuf <jpoimboe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] livepatch: old_name.number scheme in livepatch sysfs
 directory
Date: Tue, 3 Nov 2015 14:06:08 -0600
Message-ID: <20151103200608.GQ27488@treble.redhat.com>
References: <20151102203241.GF27488@treble.redhat.com>
 <1446505187-28970-1-git-send-email-chris.j.arges@canonical.com>
 <alpine.LNX.2.00.1511031146070.6257@pobox.suse.cz>
 <20151103124440.GK2599@pathway.suse.cz>
 <alpine.LNX.2.00.1511032055570.22567@pobox.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1511032055570.22567-ztGlSCb7Y1iN3ZZ/Hiejyg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jiri Kosina <jikos-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, Miroslav Benes <mbenes-AlSwsSmVLrQ@public.gmane.org>, Chris J Arges <chris.j.arges-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, live-patching-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jeyu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Seth Jennings <sjenning-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vojtech Pavlik <vojtech-IBi9RG/b67k@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, Nov 03, 2015 at 08:57:24PM +0100, Jiri Kosina wrote:
> On Tue, 3 Nov 2015, Petr Mladek wrote:
> 
> > Also I would omit the suffix at all when it is the first occurrence. It 
> > will cause that unique symbols will not be numbered.
> 
> That'd mean that the names (including suffixes) are not stable, because a 
> particular name that has originally been unique can later be made 
> non-unique when module brings in a conflicting name.

The numbering (and uniqueness) is per-object, so the same symbol name
from another module would live in a separate namespace and wouldn't
create a conflict.

-- 
Josh
