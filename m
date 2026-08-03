Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2183233438F;
	Mon,  3 Aug 2026 23:10:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785798649; cv=none; b=gKhvfwrAIx1sgDKJyefY6tHzP9wYGhnzuDQ+ncvs/jXYeC90nxNkGmRJEFknd8AKCHOqMTQrX+uZVN/YWfU3JSXrtkjGk2LtOGz632YdSKba9MlpKKwhfPSi9gnrzw+K/gYnRYyyj/kryj4QwYd+a5elgFCSfDJAZMlKLH7i5Hk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785798649; c=relaxed/simple;
	bh=kcWR37WHm9NVWvIBUCzFh8nuWT3mfRj4ODNfC3d+a0c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lI+481o6l3AD5ACNAU9Dyf+sp57pdIRF9ZW0NxdgHsK6znng/B7/bWxOsUqebTDDLBY9SwHy2f+4kXBEk5oWDNyKzlQe6Hw7u+CKhXynXY98688paz+jyZfWXFTOVWZToGSokRgP8HBQIljkaXz1m5ruyeXa48ufMP6ZSlz66eM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=pass smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=eVgXmazl; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="eVgXmazl"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=1fQasks1koEbaOHY+SF92A17sBEYdogE4ymIU+3tgPM=; b=eVgXmazlahllG3GSV5gswSq6PS
	XQQMytv+gYvRpNj35jA+bPw5hucoxdX1H0yy19HPqLOVvNNlGJrMMIonkqIDV8oi0MXATVwU9OJCS
	4sY0O6GLxHNW3KoZp5jXKEoLSC4hbEFpDEh1GMmlq8xxoMjB+Ov/7L0au9OczuTTFnLZwkP+uy2pf
	dQPGb4/uvdhchYRlrHOg7yck96yjOpt6IzeuUrDOAWC1fFH+IaZzCc0LpXJMGOh6/7pudGBw+RlJd
	1Igr+ps0QMfIqVlvKkA7pmnzSApNDsjTMqF5K1nOP5o11meWUctQJ7gCpPGKztpp6q9Ccv3Sw1i7Z
	fs4GKHrQ==;
Received: from [50.53.43.113] (helo=[192.168.254.34])
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wr1ny-00000000ei4-3en8;
	Mon, 03 Aug 2026 23:10:46 +0000
Message-ID: <c847bfce-59cb-48d7-9ddf-92431da74d53@infradead.org>
Date: Mon, 3 Aug 2026 16:10:45 -0700
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] Documentation: sysfs-class-power: Update Long_Life
 description
To: "Derek J. Clark" <derekjohn.clark@gmail.com>,
 Sebastian Reichel <sre@kernel.org>
Cc: Hans de Goede <hansg@kernel.org>,
 "Pierre-Loup A . Griffais" <pgriffais@valvesoftware.com>,
 linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-api@vger.kernel.org
References: <20260803210720.23844-1-derekjohn.clark@gmail.com>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20260803210720.23844-1-derekjohn.clark@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 8/3/26 2:07 PM, Derek J. Clark wrote:
> While adding charge limiting support to the Lenovo WMI drivers, there
> was some back and forth about whether charge_types or
> charge_control_end_threshold was the appropriate attribute to expose a
> battery charge limiting toggle that is fixed in the BIOS. The confusion
> arose because the charge_control_end_threshold description closely
> matches the functional change the hardware is making, while the
> charge_types functionality better suits the actual an on/off toggle that
> occurs in the BIOS. This specific scenario is not explicitly enumerated
> in the documentation, though it is fairly common.
> 
> Given that the original intention was to use it this way[1],[2], and that
> the samsung-laptop[3], ideapad-laptop[4], and lenovo-wmi-other[5] drivers
> all use the convention of charge_types with an exposed Long_Life and
> Standard value for this, codify it in the Documentation to avoid confusion
> in the future.
> 
> [1] https://lore.kernel.org/linux-pm/49993a42-aa91-46bf-acef-4a089db4c2db@redhat.com/
> [2] https://lore.kernel.org/platform-driver-x86/20241209204051.8786-1-hdegoede@redhat.com/
> [3] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=de2884c6cdd3d133704ce37393590dd1c761500c
> [4] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=da8f2708f9b69707f4efeb432a18395e46b4666f
> [5] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=9ca8fc065b88b327acbfdc33454efea391639716
> 
> Suggested-by: Hans de Goede <hansg@kernel.org>
> Signed-off-by: Derek J. Clark  <derekjohn.clark@gmail.com>
> ---
>  Documentation/ABI/testing/sysfs-class-power | 14 +++++++++-----
>  1 file changed, 9 insertions(+), 5 deletions(-)
> 
> diff --git a/Documentation/ABI/testing/sysfs-class-power b/Documentation/ABI/testing/sysfs-class-power
> index 5641f1fd5fd6..98b389845d1e 100644
> --- a/Documentation/ABI/testing/sysfs-class-power
> +++ b/Documentation/ABI/testing/sysfs-class-power
> @@ -365,9 +365,12 @@ Contact:	linux-pm@vger.kernel.org
>  Description:
>  		Represents a battery percentage level, above which charging will
>  		stop. Not all hardware is capable of setting this to an arbitrary
> -		percentage. Drivers will round written values to the nearest
> -		supported value. Reading back the value will show the actual
> -		threshold set by the driver.
> +		value, instead providing different minimum, maximum, or step
> +		values. Drivers will round written values to the nearest supported
> +		value. Reading back the value will show the actual threshold set
> +		by the driver. For hardware that only supports a single fixed
> +		value, use charge_types with a value of "Long Life" (vs "Standard")
> +		instead'

maybe		instead.
?
>  
>  		Access: Read, Write
>  
> @@ -398,8 +401,9 @@ Description:
>  			when to start and stop charging. Advanced users
>  			can use this to drastically extend battery life.
>  		Long Life:
> -			The charger reduces its charging rate in order to
> -			prolong the battery health.
> +			The charger firmware reduces its charging rate and/or
> +			maximum charging percentage to a hardware specified
> +			fixed limit in order to prolong the battery health.
>  		Bypass:
>  			The charger bypasses the charging path around the
>  			integrated converter allowing for a "smart" wall

-- 
~Randy

