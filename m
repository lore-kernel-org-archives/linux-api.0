From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH 02/14] twl4030_charger: use devres for
 power_supply_register and kzalloc.
Date: Mon, 23 Mar 2015 22:25:36 +0100
Message-ID: <20150323212535.GC14779@amd>
References: <20150322231635.23789.70149.stgit@notabene.brown>
 <20150322232028.23789.38570.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-omap-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150322232028.23789.38570.stgit@notabene.brown>
Sender: linux-omap-owner@vger.kernel.org
To: NeilBrown <neil@brown.name>
Cc: Sebastian Reichel <sre@kernel.org>, NeilBrown <neilb@suse.de>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, GTA04 owners <gta04-owner@goldelico.com>, inux-pm@vger.kernel.org, linux-omap@vger.kernel.org, Lee Jones <lee.jones@linaro.org>
List-Id: linux-api@vger.kernel.org

On Mon 2015-03-23 10:20:28, NeilBrown wrote:
> From: NeilBrown <neilb@suse.de>
> 
> Final allocations/registrations are now managed by devres.
> 
> Signed-off-by: NeilBrown <neilb@suse.de>

Patches 1,2: Acked-by: Pavel Machek <pavel@ucw.cz>

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
