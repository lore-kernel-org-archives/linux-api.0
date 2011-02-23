From: Tony Luck <tony.luck@intel.com>
Subject: Re: [PATCH v2 2/5] firmware: Basic dmi-sysfs support
Date: Wed, 23 Feb 2011 11:43:42 -0800
Message-ID: <AANLkTinjhY3oiFTq2xq4fwQ-mtLZ8ph435+nc5irM7wZ@mail.gmail.com>
References: <20110223015307.13068.14063.stgit@mike.mtv.corp.google.com>
	<20110223015320.13068.77428.stgit@mike.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110223015320.13068.77428.stgit@mike.mtv.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Waychison <mikew@google.com>
Cc: Greg KH <greg@kroah.com>, Olof Johansson <olofj@chromium.org>, Andi Kleen <andi@firstfloor.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>, Robert Lippert <rlippert@google.com>, Jon Mayer <jonmayer@google.com>, Duncan Laurie <dlaurie@google.com>, Aaron Durbin <adurbin@google.com>, linux-kernel@vger.kernel.org, Tim Hockin <thockin@google.com>, David Hendrix <dhendrix@chromium.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Tue, Feb 22, 2011 at 5:53 PM, Mike Waychison <mikew@google.com> wrot=
e:
> +static void __init dmi_sysfs_register_handle(const struct dmi_header=
 *dh,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0void *_ret)
> +{

I'm seeing some unaligned references from this function
on ia64.  Code is loading a 2-byte value from an odd
address. We are dereferencing "dh", so looking at the
dmi_header definition, I'd have thought that we must
be touching dh->handle:

struct dmi_header {
        u8 type;
        u8 length;
        u16 handle;
};

I don't see any code in this function that does this,
so I assume there is some inlining or macro stuff
happening.

-Tony
