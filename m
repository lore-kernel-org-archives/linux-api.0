Received: from mail-dl1-f52.google.com (mail-dl1-f52.google.com [74.125.82.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12A8E4A64F6
	for <linux-api@vger.kernel.org>; Sun, 18 Oct 2026 16:06:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792339617; cv=none; b=AzxsE+3192Cq+6Y6SpS8BZSvRlekAAwNmCxc+MBQKvJaWS6BE8gN71w6EH+gcKWheR4eyb2wpBH4SKRqV76V7QIGabyS25eksqQkWFTjxRFaQs1cBmib1EAyDEtNo1vNIp/8SHguFipriZvwZCwPUAL0QhlPmkBQwUXyk23nrb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792339617; c=relaxed/simple;
	bh=KpS1mvfrzPVq+RJ1AUg0YioB5wJtbGxvYJVW8/sEbLQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U2rbZ6NzLoM9fBTACwRjP/Pay3JzmiWWSbOTAizr2+QiRa990j7/rATEOiL/fMr+fCW/pFyYHKiF/byPMidpYo2WpmQvKt6gZiY+/9fb3nDKABF3wYRNIeYchv3HAcgMoI9260JrefRT8ZtLYaENekIatGW+XXttI8hfwjzVRUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cfJWBeDg; arc=none smtp.client-ip=74.125.82.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cfJWBeDg"
Received: by mail-dl1-f52.google.com with SMTP id a92af1059eb24-17bc533fda3so1501397c88.1
        for <linux-api@vger.kernel.org>; Sun, 18 Oct 2026 09:06:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792339613; x=1792944413; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:sender:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=B3VIzdAotImucJ/CUyeIQ/bHJawLqtZx+sVJj8zJnmQ=;
        b=cfJWBeDgkw3BS0eoZk6Isbg6AtT8CYAIS2CrCwKAEbWZ5JdW8Cb7KhEYeav1bceNk/
         YzNUwS52+sWOT9gwl7IOKQP7OxzvLNYDjxR/lYEXl43b5kB/fM3FjhgbM1piAqWZLqFp
         nwVG8XYY5YozKi221qgBE5EDYvHgzsdng3rUVQZsia2taxh7+MCE1L27U0PHsJcEDTE3
         pf9RICJf7Y4OvFdfFFZRcfowfufOLrJvCmM6Qy2BRjWhWAcBUC+B/ZAw6T9Uv8HgbEMW
         sjhj1FRC7F/ojZMgcaCwkM2wuHYuzdsc3OLEufoXbPPTEhgFidVJj8vKXuMMvaEsc88V
         EtkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792339613; x=1792944413;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=B3VIzdAotImucJ/CUyeIQ/bHJawLqtZx+sVJj8zJnmQ=;
        b=EHu1Q50BmR4Euswk2mMvXfWXI9jrGE8FQkvXhwFTHM+8QsQrX9sLmmRnFlVccozEhQ
         H6iY7fO6G4QuwrdcYOCDaouqjaa8vddHcp/5JHMMDBWOFbLJx25wVV6lPkoSiW4/L3wW
         Vda1QMkDRoIVO02tKAVtN6aUreDKEf986gSJaf8APpZ3uj/giBTV06rRAmogvM36n1dI
         bjFQZI7SEvIojkCZXARFCyWLqn0IW9pCI59zbfDX8ThSKnD8/zGtsI4pGIe+RVdBxYyD
         kYdzmqXGPx2+Wmx88iNxUFu0knLri/KQ82ruS/g+RMR5oigzm4iCK3Ak3qL3K43RaDpO
         42nw==
X-Forwarded-Encrypted: i=1; AKwUvBwDPs6/yAtzljfjhVykDY8rm7ThbBLd/oLGMWbzO6DY4RnMlC78vn4vTkYWmh67CceEpKJ41XcK7K0=@vger.kernel.org
X-Gm-Message-State: AFq9FYJkXcqFSMTI3TtfnugSLlQEczLlgq5tej0qky/WKZlQIVs+PRv8
	tGhKbhe4p+ytj7BQnSCMFnGjzGxyc7r4Ht7Kc/2Qc7mbCxbS909CcrhK
X-Gm-Gg: AYBFou2m4Ub+VhKa63LVjN3NasUAwlOds7ljsqgK1kG1rCAYuWEWMA6F8G566HnzMR6
	2woBVS1qL1AjPhp4YBoWDOoqqKUBhthaG/zvlpjlt7XYgDUY+wlZQJJ4vl3svRT7UgXUolPGI3U
	Lid9G5uzZQw6ijuF7kFDuIc3I1WXNvIf5mKDqwfUq18zL8hhD0mV5eb+OUPGezsNYrRSY1owOsY
	PrOX2zYch7WjDDJWiY57BpFsRQUxaS1t0ZJTmOA7sdNU5ZOgJGyLWLsOhIOS6swb3+K5uVCUgtp
	aCGqq7DTWfZFr5EACXWUUDOWCuQZC4Och9GiMbTyLqbs/Z6El/l9CnA8Cm3TtY83VrHEvxddlER
	j7EvHfI6QYomH66zle6/hTBRKeQGv0x4aK56m1rtVIcA7AHyJ1o5NuEB+O/sLFg847I7WaBMD0o
	tBb159iCqDlO4yZDofM3MZmRZrSxcu7Isfw7XnIMYqV7vpuQgYdygnPWxvMiX3jM1BiSDJcGKac
	pMJ3kN0huwP
X-Received: by 2002:a05:693c:6311:b0:361:308f:55eb with SMTP id 5a478bee46e88-361a264b569mr7771322eec.30.1792339612707;
        Sun, 18 Oct 2026 09:06:52 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:da43:aeff:fecc:bfd5])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36083283478sm23948470eec.29.2026.10.18.09.06.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Oct 2026 09:06:52 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Sun, 18 Oct 2026 09:06:51 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Jihong Min <hurryman2212@gmail.com>
Cc: linux-hwmon@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>, linux-api@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] docs: hwmon: Document the uhwmon userspace interface
Message-ID: <e77719ee-c813-400e-b49a-9f8a3b0e2e91@roeck-us.net>
References: <cover.1791531025.git.hurryman2212@gmail.com>
 <c02aeee5b7e7a5d159d4df5baabe925e16814e94.1791559095.git.hurryman2212@gmail.com>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c02aeee5b7e7a5d159d4df5baabe925e16814e94.1791559095.git.hurryman2212@gmail.com>

On Sat, Oct 10, 2026 at 12:38:44AM +0900, Jihong Min wrote:
> Document the uhwmon UAPI for developers implementing userspace hwmon
> drivers. Cover device registration, request handling, notifications
> and device lifetime.
> 
> Assisted-by: Codex:gpt-6-astra
> Signed-off-by: Jihong Min <hurryman2212@gmail.com>

I am not going to review, much less apply, this series.
Exposing subsystem internals to userspace is a bad idea and would limit
future improvements of the hardware monitoring subsystem. User space file
systems are bad enough and cause all kinds of trouble. I don't want to have
to deal with the same kind of issues in the hardware monitoring subsystem.

Interested parties should implement kernel hardware monitoring
drivers instead.

Guenter
