From: Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: Re: uhid: broken interface: 32/64-bit compatibility
Date: Fri, 15 Feb 2013 18:40:27 +0200
Message-ID: <CAHp75VdC7JnoYwnKRsyr7v3or167OdX8mrv00VK-0YuPhpSFaw@mail.gmail.com>
References: <20130215112911.68A98E0085@blue.fi.intel.com>
	<CANq1E4T1QzOUOwWPpV6_55hVTXzXF4baShxpYaM0HNAgF0ffAg@mail.gmail.com>
	<20130215120022.GA23694@x220>
	<20130215135141.1EFCEE0085@blue.fi.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-input-owner@vger.kernel.org>
In-Reply-To: <20130215135141.1EFCEE0085@blue.fi.intel.com>
Sender: linux-input-owner@vger.kernel.org
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Johan Hedberg <johan.hedberg@gmail.com>, David Herrmann <dh.herrmann@googlemail.com>, linux-api@vger.kernel.org, linux-input@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>, RavindranathX Doddi <ravindranathx.doddi@intel.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, Marcel Holtmann <marcel@holtmann.org>
List-Id: linux-api@vger.kernel.org

> Any comments?

Generic comments.  Could you use *_compat instead of  *_old_*?
Another idea is do not touch current interface, just append new
function and associated structure to make a smooth transition of the
userspace stuff.

What about documentation (Documentation/hid/uhid.txt)? Could you
update it acordingly?

> Subject: [PATCH] uhid: introduce new create event to fix 32/64-bit
>  compatibility issue
>
> Current create event has pointer in payload. It causes problem with
> 32/64-bit compatibility. In particular it's not possible to use 32-bit
> userspace driver with 64-bit kernel.


> This patch deprecates old create event and introduce a new one. The new
> create event has padding for pointer on 32-bit system to extend pointer
> correctly.
>
> Old userspace driver binaries will use old create event. It requires
> simple recompile to switch to new one.

That's what I afraid of. Better to try to avoid any excessive
requirement to the existing userspace.

-- 
With Best Regards,
Andy Shevchenko
