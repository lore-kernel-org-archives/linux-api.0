From: Jessica Yu <jeyu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: livepatch: old_name@old_addr scheme in livepatch sysfs directory
Date: Mon, 2 Nov 2015 04:08:32 -0500
Message-ID: <20151102090832.GB24801@packer-debian-8-amd64.digitalocean.com>
References: <1446263060-22175-1-git-send-email-chris.j.arges@canonical.com>
 <20151101015258.GA8199@packer-debian-8-amd64.digitalocean.com>
 <56358EA4.10900@canonical.com>
 <alpine.LNX.2.00.1511010958430.17538@pobox.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1511010958430.17538-ztGlSCb7Y1iN3ZZ/Hiejyg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jiri Kosina <jikos-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Chris J Arges <chris.j.arges-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, live-patching-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Josh Poimboeuf <jpoimboe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Seth Jennings <sjenning-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vojtech Pavlik <vojtech-IBi9RG/b67k@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

+++ Jiri Kosina [01/11/15 10:07 +0100]:
>On Sat, 31 Oct 2015, Chris J Arges wrote:
>
>> Makes sense to me. Is there a reason why the sysfs entries are visible
>> to non-root users?
>
>Well, kptr_restrict applies only to values printed using '%pK'. So if the
>sysfs handler is using other printk() format string to print the pointer,
>it'll be leaked out (and should eventually be fixed).

Hm, I think the func.n solution might be a good temporary fix for now.
Even if we do go with func@addr and use the '%pK' format specifier we
will run into the same problem at kptr_restrict == 2.

Jessica
