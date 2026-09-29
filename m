Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CFF03B05B4;
	Tue, 29 Sep 2026 14:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790693143; cv=none; b=jfhQZUP+XhdnG5JzCMkX9qoFOiez3zks4esCSL0KVky88ZhYmbepdqy+2r7Mukrp1VjSLz1dN7BZUfcr1QVrI55lnIGq9vU5DXnH0Vz1nLCJGIxexznXnv6+SC0gRKJsxdMS+3mkyowkqFhYdIw7F+QJ8oLI5ijt3g95MTp2BCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790693143; c=relaxed/simple;
	bh=hci6lu3ry5oSWkDqTguFYXX0AmMPzg8FJ8HLHkVK9a4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fJ9ojMAE7yz2hO001jBhxBm/OBagqrl+Z3Cf9DEGxfl0cnS7N7fxBgpdgj1m+i5j6XquLDc0HalmfIi7LfhlEIOEL4IR3s79pI7ZxISh8vdQbWgPBbPRj1oJhx0T4jsuUqv+cwIlZdWrA/bNSDK1lt848daR21gUb2RduI+Ypvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UlVLxR5D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UlVLxR5D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DE4E1F00893;
	Tue, 29 Sep 2026 14:45:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790693130;
	bh=pWfsk/8/SJx3ywuuZnvRLOc2yKkgKBWslmtu/pHN+8A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UlVLxR5DKJi69D9ly6275oAua2Bp9io6CvI9qu1aeR/IjYSNnZzIeGt2504vq8nt/
	 4RUMkI59x5b7N3wttc26arnkQn33+hnSRwh1NlGZx6hBdl3LIBy+91vkEoxAlvbEf+
	 qn4Pz/Iw/77BtrqraikdLWiThAEmWL8oAK3l9R1WwTbLWx/Va7zLqqZpaYMR6f6/Eu
	 LK9eFM3oUlGMGvaIX5nPUO9Uw1OiHyZzigRNKGTqjdM2TafayE4IqdjzzvRuGR6rcc
	 bOwIMK6sndiuk7JnXUjl70luquU0pr+kv/PllvDl9PNFHlFWJQpIVWcYKJXW4WgD4v
	 h+KC/eW1f/gQA==
Date: Tue, 29 Sep 2026 16:45:24 +0200
From: Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>
To: Josef Schlehofer <pepe.schlehofer@gmail.com>
Cc: Lee Jones <lee@kernel.org>, Pavel Machek <pavel@kernel.org>, 
	Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
	Conor Dooley <conor+dt@kernel.org>, Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>, 
	Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>, Andy Shevchenko <andy@kernel.org>, Rong Zhang <i@rong.moe>, 
	linux-leds@vger.kernel.org, devicetree@vger.kernel.org, linux-api@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/2] leds: Add support for Turris 1.x LEDs
Message-ID: <arvNDgAVO4V_drW7@solitude>
References: <20260928111907.72592-1-pepe.schlehofer@gmail.com>
 <20260928111907.72592-3-pepe.schlehofer@gmail.com>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260928111907.72592-3-pepe.schlehofer@gmail.com>

On Mon, Sep 28, 2026 at 01:19:07PM +0200, Josef Schlehofer wrote:

> The five LAN LEDs share one set of colour
> registers, so the colour and brightness set last on any of them apply
> to all five.

...

> +static int turris1x_led_register(struct device *dev, struct turris1x_leds *ddata,
> +				 struct fwnode_handle *fwnode, u8 val_sw_override,

...

> +	cdev->max_brightness = 255;
> +	cdev->brightness_set = turris1x_led_brightness_set;

As described in the commit message, LAN LEDs form a group for which
the colors of individual LEDs cannot be changed.

Setting color for LAN3 LED to green will change colors for all
LAN1..5 LEDs to green.

This proposal does not reflect that in sysfs in any way.

My proposal is to register the first LAN LED as a true multicolor LED,
and the rest of LAN LEDs as simple LEDs, and then create sysfs
symlinks for the multi_intensity and multi_index attribute files:

  rgb:lan-1
    multi_intensity   (true attribute file)
    multi_index       (true attribute file)
  rgb:lan-2
    multi_intensity   (symlink to ../rgb:lan-1/multi_intensity)
    multi_index       (symlink to ../rgb:lan-1/multi_index)
  ...

This way the sysfs will somehow reflect this topology.

Also, the max_brigthness will need to be set to 1 instead of 255,
since we can set each LAN LED on/off state individually, but color
globally.

Marek
