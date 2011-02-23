From: "Luck, Tony" <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v1 2/5] firmware: Basic dmi-sysfs support
Date: Tue, 22 Feb 2011 16:07:32 -0800
Message-ID: <987664A83D2D224EAE907B061CE93D53019D6606DB@orsmsx505.amr.corp.intel.com>
References: <20110217212754.3967.98648.stgit@mike.mtv.corp.google.com>
 <20110217212805.3967.47547.stgit@mike.mtv.corp.google.com>
 <20110217215608.GA2451@kroah.com> <4D644736.9050109@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4D644736.9050109-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Waychison <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Cc: Olof Johansson <olofj-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Robert Lippert <rlippert-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jon Mayer <jonmayer-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Duncan Laurie <dlaurie-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Aaron Durbin <adurbin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tim Hockin <thockin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Hendrix <dhendrix-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

>Looks to be supported on ia64 as well, though I don't have any hardware 
>to test this code on for that arch.  Tony: I think this DMI exporting 
>code should just work on ia64 as all it is using is dmi_walk() and 
>parsing the entries as returned as dmi_headers in the callback.  Does 
>this sound sane to you?

Yes we have dmi on ia64 too.

-Tony
