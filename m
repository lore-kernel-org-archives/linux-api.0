From: Jiri Kosina <jikos-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: livepatch: old_name@old_addr scheme in livepatch sysfs
 directory
Date: Sun, 1 Nov 2015 10:07:14 +0100 (CET)
Message-ID: <alpine.LNX.2.00.1511010958430.17538@pobox.suse.cz>
References: <1446263060-22175-1-git-send-email-chris.j.arges@canonical.com> <20151101015258.GA8199@packer-debian-8-amd64.digitalocean.com> <56358EA4.10900@canonical.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56358EA4.10900-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chris J Arges <chris.j.arges-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Cc: Jessica Yu <jeyu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, live-patching-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Josh Poimboeuf <jpoimboe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Seth Jennings <sjenning-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vojtech Pavlik <vojtech-IBi9RG/b67k@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Sat, 31 Oct 2015, Chris J Arges wrote:

> Makes sense to me. Is there a reason why the sysfs entries are visible
> to non-root users?

Well, kptr_restrict applies only to values printed using '%pK'. So if the 
sysfs handler is using other printk() format string to print the pointer, 
it'll be leaked out (and should eventually be fixed).

Thanks,

-- 
Jiri Kosina
SUSE Labs
