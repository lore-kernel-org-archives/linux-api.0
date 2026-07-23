Received: from fhigh-b1-smtp.messagingengine.com (fhigh-b1-smtp.messagingengine.com [202.12.124.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92E2C3749E8;
	Thu, 23 Jul 2026 20:08:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784837290; cv=none; b=ujG8Bpip1mzJQ8+BWz6mGmnEX6o8l/VJR/KXJPRyYHUnr2TRjATRpLfAR7bhw07uDvlRPLDNg2v4m8RsWobptD45yq+QkrA0jUOJ7vO1T19IxKwY7O3nBuYKIDkYLO4QxMrvexUtz2ig+JB4h8GvZoH0Ozp8eiBdNcB0WTJeY38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784837290; c=relaxed/simple;
	bh=fBHSlKihB7uqNCvVP8QfQmvnw2yxyQSDkZAa4uWIkcE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oocAoP1zSmN5nNmmdMH5kUp73AU2VDzUF1dxRxT2baw1CZs/I5OgAueNWhgGpNvvPPkxEwTUnEXFcKEHWXqriieytbYPZPl2XYxsALzZcma8gRV0HIeJXtQVZgGxb8tVfUfFITAPzgKqzdpybzvnnwY900NKXZGBFreDqNdOevo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=codeweavers.com; spf=pass smtp.mailfrom=codeweavers.com; dkim=pass (2048-bit key) header.d=codeweavers.com header.i=@codeweavers.com header.b=XD1VXPm+; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=jMIIRThN; arc=none smtp.client-ip=202.12.124.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=codeweavers.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=codeweavers.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=codeweavers.com header.i=@codeweavers.com header.b="XD1VXPm+";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="jMIIRThN"
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 7025B7A0025;
	Thu, 23 Jul 2026 16:08:02 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Thu, 23 Jul 2026 16:08:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codeweavers.com;
	 h=cc:cc:content-transfer-encoding:content-type:content-type
	:date:date:from:from:in-reply-to:in-reply-to:message-id
	:mime-version:references:reply-to:subject:subject:to:to; s=fm1;
	 t=1784837282; x=1784923682; bh=zvCiZOUeqSGbV5T85kBu0y2rxPDlRejo
	7kTCDEygPPI=; b=XD1VXPm+ZOpB1a2CysvNlk4iNWrstAJ9d0ORIWWYO1aapx4I
	I5qo7DsBRjm+KohICjX438kv6tPR6IXbx+3hXpzk9nWA68UfeLbiA7Wf8h6WF5Ec
	AyKOTHYX9MmP84RTF3sUOYl30WxTGF7Gx75WJkLD2EruKKW1Fsfr8JXg0MYgC3NZ
	1BwPIgh5UtOHvcY6/pUjBy8U9b2rYeJ1I9EVSXlkRtVWGXzSY2lMEGpxzc2ifh1R
	WP+AvEggUSjEFo0ZXhym4bzyOyWMLzT3eNIVcHmE/wnfStAfm0KJxheoK3ZQD54r
	htgD3d2izcxUzu2ifaMyuoVc8ocP96DzUAo+ig==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1784837282; x=
	1784923682; bh=zvCiZOUeqSGbV5T85kBu0y2rxPDlRejo7kTCDEygPPI=; b=j
	MIIRThN//YqQ+xJgFNJcFmvgQ2QgHY5n3D95iMpqJK4ZW1DN5kbHiyocOtwdPYQ7
	Y4pDqtETGIfwYycUAKXCOl+jd3zBfCg35PrZVdik3YV014LebM+KZfUAwPYYEjtZ
	3MSRjHKVCV4kUctVgzjD7lRSZ/jD7XwcPAqOhVv8IvRVAVBjrx4A2sdzBHe8Ia3g
	mmR/4nrzJXgzEVZdTUScV8DkEC5eeHuQH8KwgKiRHaYy0e91rIFIppBggQb5RsPV
	h1BF7zfK9pT0MIluoxiuXGfdwT7p63cSRMaFLRkiLY496W6SQRLQyhLm37Moff5U
	NJ9DbEAguQpXO6h38MYSw==
X-ME-Sender: <xms:onRiahBPlTnk9py_zvWNFcHKfFhLwQCijqUJ8H40wigiXJ8NFEFVFw>
    <xme:onRiav-__H2us64tClBz9vqGgGzX0NEPUMmcL8gjL_0VVmKskUI3h8Bm8eWHgGRaa
    0UOgNYgDJql_42hoLSATr9UD4cExn9nmtYjjT6JvZ3vqVqvbQ2wwQ>
X-ME-Received: <xmr:onRiatTVN6OfeYO-1Zm3BYMyVeL5criM0LNGZKV_EkvEHxDSJLRf73luL0cfT0YmwHUwHjEy9bB8A4Ko6DE>
X-ME-Proxy-Cause: dmFkZTEymeXF3iGxG+scIyVi9qVVOKytgnKAA8H1b0iB7tfqr3n0dYZOrSDuJCh0jcljor
    NWRsrQHq9coCfsWkKKJbdEkf9Mbn2/HWFPLm3ANV7ayKe/NaFQNXIwW0YuOLnYo+JRSFJE
    FKHSWwdPboTGXsk1LWpSycXARRFqd668VadQlNUWueqKDSUaFUQStOaV1TjeBRRl+V0pmE
    JeTVlV+gPRpOT8PauGE+iq5N4pzE9Mv/OenpWp3w9mj6dPX8a9TZ6eRVjJjet3jysZMxBd
    /d8EU0nqZ7oAZPbex4PcZIVRqDTRAgevSAWQGC6gU9eIIhPqSnhcd9bmRoZXZK+ffoPiTe
    2i0I/K2PsGGmHyvht3mADBTyJly27qLoXpzq3GjzQUkDK8BwfH4Hj3NsJOV1u58OT+O1Hf
    ogw4uIL6fNrbVDvf480GVR0qYL/SscxP8NyfMMUs+KUJExZQym26RqK9eS5RldKB7nx4fm
    zRL625SCydfVJlniJVENfXXwdmo8TreN+3nkM4B36/hSoAwLfjmJBxvIZ2VzttkNUU4Nwk
    ud5/DceXu6gWMr65Cd1K9LwoRiYw/AZ+Gci9rhOUIpD1oCXakUA2+Fj9E8GtktW3gVRyQ/
    /VXgy+ZJ3WPKwRKy06aT/zImnT4dnV3sE9ya1aptKEdsYRAUm+RCwZU0Javg
X-ME-Proxy: <xmx:onRiajVqHhgJmUSgP6ErBwKIqEEFr3odCGx5N8kqSYO_tvOAMngXpw>
    <xmx:onRianQP4erPZ1fAuy1N0ReS6QjtVGs6IOS9IWL-tq46fLGwBq9Qdw>
    <xmx:onRiar3NGj3sLC82NMDHIBhp0Yg4anWdBDkobfUmjpgXL_pjZoCW_w>
    <xmx:onRianc_mwUeM8eQQj_L_DX2qSNUIWWqrQKTTOyjQhLIoNfxLe5WQA>
    <xmx:onRianp-PRp0AhmhN37Bso8fwTEgCsM75Mg-ozeFiAr3tMo2bKZ7K9sE>
Feedback-ID: i01ae4b70:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 23 Jul 2026 16:08:01 -0400 (EDT)
From: Elizabeth Figura <zfigura@codeweavers.com>
To: Arnd Bergmann <arnd@arndb.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, wine-devel@list.winehq.org
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
 wine-devel@list.winehq.org, linux-kselftest@vger.kernel.org,
 Elizabeth Figura via Wine-Devel <wine-devel@list.winehq.org>
Subject: Re: [PATCH 0/4] ntsync miscellaneous patches
Date: Thu, 23 Jul 2026 15:08:01 -0500
Message-ID: <77603773.Cp5WYEEl3R@camazotz>
In-Reply-To: <20260720171740.447035-1-zfigura@codeweavers.com>
References: <20260720171740.447035-1-zfigura@codeweavers.com>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"

On Monday, 20 July 2026 12:17:36 CDT Elizabeth Figura via Wine-Devel wrote:
> This is a resend of a series originally submitted as [1], now sent to char-misc.
> The following is the original cover letter sent with that series.
> 
> [1] https://lore.kernel.org/all/20260628024239.152852-1-ivanrwcm25@gmail.com/

I've received new patches including an update of one of these; I will resend with those patches included. Sorry for the noise.


