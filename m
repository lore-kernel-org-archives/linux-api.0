From: Darren Hart <dvhart@infradead.org>
Subject: Re: [PATCH v2] samsung-laptop: enable better lid handling
Date: Wed, 28 Jan 2015 21:20:22 -0800
Message-ID: <20150129052021.GA115032@vmdeb7>
References: <1418332715-10547-1-git-send-email-julijonas.kikutis@gmail.com>
 <1422365168-2428-1-git-send-email-julijonas.kikutis@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <platform-driver-x86-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1422365168-2428-1-git-send-email-julijonas.kikutis@gmail.com>
Sender: platform-driver-x86-owner@vger.kernel.org
To: Julijonas Kikutis <julijonas.kikutis@gmail.com>
Cc: Corentin Chary <corentin.chary@gmail.com>, "open list:ABI/API" <linux-api@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, "open list:SAMSUNG LAPTOP DR..." <platform-driver-x86@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, Jan 27, 2015 at 01:26:06PM +0000, Julijonas Kikutis wrote:
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
> Signed-off-by: Julijonas Kikutis <julijonas.kikutis@gmail.com>
> ---
>  .../ABI/testing/sysfs-driver-samsung-laptop        |   8 ++
>  drivers/platform/x86/samsung-laptop.c              | 120 ++++++++++++++++++++-
>  2 files changed, 127 insertions(+), 1 deletion(-)
> 

Patch is generally fine, thanks for addressing my comments. Prior to merging I
always run checkpatch.pl just in case I missed anything obvious:

$ scripts/checkpatch.pl ~/samsung/01-lid-handling.patch 
WARNING: Prefer kstrto<type> to single variable sscanf
#219: FILE: drivers/platform/x86/samsung-laptop.c:900:
+       if (!count || sscanf(buf, "%i", &value) != 1)
+               return -EINVAL;

total: 0 errors, 1 warnings, 219 lines checked

Please always run checkpatch.pl. It isn't sufficient and doesn't catch
everything, but it is a minimum bar kind of thing.

Thanks,

-- 
Darren Hart
Intel Open Source Technology Center
