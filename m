From: Jessica Yu <jeyu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: livepatch: old_name@old_addr scheme in livepatch sysfs directory
Date: Sat, 31 Oct 2015 21:53:01 -0400
Message-ID: <20151101015258.GA8199@packer-debian-8-amd64.digitalocean.com>
References: <1446263060-22175-1-git-send-email-chris.j.arges@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1446263060-22175-1-git-send-email-chris.j.arges-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chris J Arges <chris.j.arges-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Cc: live-patching-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Josh Poimboeuf <jpoimboe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Seth Jennings <sjenning-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jiri Kosina <jikos-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vojtech Pavlik <vojtech-IBi9RG/b67k@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

+++ Chris J Arges [30/10/15 22:44 -0500]:
>The following directory structure will allow for cases when the same
>function name exists in a single object.
>	/sys/kernel/livepatch/<patch>/<object>/<function@address>

Hi Chris, thanks for the patch.

I think the last time this issue was discussed, the conclusion was
that concatenating the address to the function name constitutes as an
information leak (as the sysfs entry is visible to non-root users).

One option suggested by Josh in that thread would be to do something
like "func.n", where n is just the nth occurrence of the symbol name. 

Another option might be to keep the func@addr format but not make these
entries visible to non-root users.

Jessica
