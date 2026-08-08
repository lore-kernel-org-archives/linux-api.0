Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6668347BDB;
	Sat,  8 Aug 2026 13:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786196245; cv=none; b=KHwffd3dTwjHVzL1tvRgEPAzKdRFWL7E+2rY0finJW1efH06hOHzsTFn2bH895Ou+L9E/zHdEcssxP4rj9UuKajM6gGw+FjQtuMfAdhn9uOCssy0mm2bQmWQ60D3s0O5WXpsvX+F+3HORRIvNDdba4WKg2OXVCV/gryi8zDA2gw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786196245; c=relaxed/simple;
	bh=tpHJYZNxf2nYrtj7FDtPjnf+Jx1PWTLozsVVZ+lcDkk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sRidIQRE0/5HwpEuV2A+0WWSSy9FwBkWKaoJVQpAbW5Qbyl1UFNhxBgZ96XTBxL9CrxVMcSsxMajj7B4gMjO+yZVwDCumSfvDTGpcMNutsqLODUF23IowAJlFQZLT7khZULFzuj8DaKFsuMuUxPVA/AdeoYkmvHnQ/C5RJtbhYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FUjnV6vG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FUjnV6vG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDA231F000E9;
	Sat,  8 Aug 2026 13:37:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786196244;
	bh=kK6ttjBVpFTnDiEcxRQNzQgAOeQ3lyUy8TS5HJIHKGc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=FUjnV6vGRgB1RsW1v/7L9bM6zLztqFy9wFzHM2wBcHZzoqeNLyQs6uFwUTnS0Puc7
	 FYhtmEqyRaxJdgiu4aBgAUlJ0p3lJG5SDc74W5VBm652s6OSsQsTwDmE/DOmvXkAla
	 9XIDPit8vqjEDmXkTY715O0YM/ZzngcIbCDE/GXAlOxQpO63heT5gVWdzAsDu0AxT3
	 eUmR62IfKIbk7toyLyQfDQhzFhH6n1K8+0na/+3+BtrXMjTmCIn2W+WAUY5ky+dEg8
	 v/+qMJT4qOfZgwGaOLSx7me+0Pu3xgkN0pKl0GatFhk9Lqo24ACkC1e1IjmMrmc0Ot
	 PXzpPTRpcMmEw==
Message-ID: <011bb1d7-51af-4ec7-a11a-c268d86c00e9@kernel.org>
Date: Sat, 8 Aug 2026 15:37:20 +0200
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
Cc: "Pierre-Loup A . Griffais" <pgriffais@valvesoftware.com>,
 linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-api@vger.kernel.org
References: <20260803210720.23844-1-derekjohn.clark@gmail.com>
From: Hans de Goede <hansg@kernel.org>
Content-Language: en-US, nl
In-Reply-To: <20260803210720.23844-1-derekjohn.clark@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Derek,

On 3-Aug-26 23:07, Derek J. Clark wrote:
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

Thank you for updating the docs, patch looks good to me:

Reviewed-by: Hans de Goede <johannes.goede@oss.qualcomm.com>

Regards,

Hans


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

