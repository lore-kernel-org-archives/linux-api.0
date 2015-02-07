From: Darren Hart <dvhart-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v3] samsung-laptop: enable better lid handling
Date: Fri, 6 Feb 2015 18:38:09 -0800
Message-ID: <20150207023809.GA36295@fury.dvhart.com>
References: <1418332715-10547-1-git-send-email-julijonas.kikutis@gmail.com>
 <1422536696-1718-1-git-send-email-julijonas.kikutis@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1422536696-1718-1-git-send-email-julijonas.kikutis-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Julijonas Kikutis <julijonas.kikutis-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Corentin Chary <corentin.chary-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "open list:ABI/API" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:SAMSUNG LAPTOP DR..." <platform-driver-x86-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Jan 29, 2015 at 01:04:37PM +0000, Julijonas Kikutis wrote:
> Some Samsung laptops with SABI3 delay the sleep for 10 seconds after
> the lid is closed and do not wake up from sleep after the lid is opened.
> A SABI command is needed to enable the better behavior.
> 
> Command = 0x6e, d0 = 0x81 enables this behavior. Returns d0 = 0x01.
> Command = 0x6e, d0 = 0x80 disables this behavior. Returns d0 = 0x00.
> 
> Command = 0x6d and any d0 queries the state. This returns:
> d0 = 0x00000*01, d1 = 0x00, d2 = 0x00, d3 = 0x0* when it is enabled.
> d0 = 0x00000*00, d1 = 0x00, d2 = 0x00, d3 = 0x0* when it is disabled.
> Where * is 0 - laptop has never slept or hibernated after switch on,
>            1 - laptop has hibernated just before,
>            2 - laptop has slept just before.
> 
> Patch addresses bug https://bugzilla.kernel.org/show_bug.cgi?id=75901 .
> It adds a sysfs attribute lid_handling with a description and also an
> addition to the quirks structure to enable the mode by default.
> 
> A user with another laptop in the bug report says that "power button has
> to be pressed twice to wake the machine" when he or she enabled the mode
> manually using the SABI command. Therefore, it is enabled by default
> only for the single laptop that I have tested.
> 
> Signed-off-by: Julijonas Kikutis <julijonas.kikutis-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Queued up, thanks Jujijonas.

-- 
Darren Hart
Intel Open Source Technology Center
