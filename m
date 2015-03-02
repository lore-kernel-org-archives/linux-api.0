From: Aaro Koskinen <aaro.koskinen@iki.fi>
Subject: Re: [PATCH 1/9] HSI: cmt_speech: Add cmt-speech driver
Date: Mon, 2 Mar 2015 22:56:04 +0200
Message-ID: <20150302205604.GA7438@fuloong-minipc.musicnaut.iki.fi>
References: <1425271139-24715-1-git-send-email-sre@kernel.org>
 <1425271139-24715-2-git-send-email-sre@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1425271139-24715-2-git-send-email-sre@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Sebastian Reichel <sre@kernel.org>
Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>, Kai Vehmanen <kvcontact@nosignal.fi>, Pavel Machek <pavel@ucw.cz>, Pali Rohar <pali.rohar@gmail.com>, Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>, linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Kai Vehmanen <kai.vehmanen@nokia.com>, Carlos Chinea <carlos.chinea@nokia.com>, Joni Lapilainen <joni.lapilainen@gmail.com>
List-Id: linux-api@vger.kernel.org

Hi,

On Mon, Mar 02, 2015 at 05:38:51AM +0100, Sebastian Reichel wrote:
> From: Kai Vehmanen <kai.vehmanen@nokia.com>
> 
> Introduces the cmt-speech driver, which implements
> a character device interface for transferring speech
> data frames over HSI/SSI.
> 
> The driver is used to exchange voice/speech data between
> the Nokia N900/N950/N9's modem and its cpu.
> 
> Signed-off-by: Kai Vehmanen <kai.vehmanen@nokia.com>
> Signed-off-by: Carlos Chinea <carlos.chinea@nokia.com>
> Signed-off-by: Joni Lapilainen <joni.lapilainen@gmail.com>
> Signed-off-by: Sebastian Reichel <sre@kernel.org>

I think the initial mainline kernel submission for this driver should be
a single patch, so just squash all the cleanups and fixes into this one.
You can document the changes you have made by describing the changes
before your own Signed-off-by line.

A.
