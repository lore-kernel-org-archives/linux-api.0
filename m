Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 299F82C11EE
	for <linux-api@vger.kernel.org>; Sun, 18 Oct 2026 17:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792344644; cv=none; b=Y+zHS7IbOVZ78Jsa1hzzDoZltsjyZfWKPD/FURntVVC5yWguae5wKJoDSWfz+SjQOydho4WJmR5DuOH22Qw2lrk13MVpt+ugcx9qOoH584LurfZEjvLeQlxvZrTNYzdtt9qB2pmSPVVrOOwt06bASXYebmNUkjE3oRWWW3VPs5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792344644; c=relaxed/simple;
	bh=74zW7bX+zhXYnzIJmFSSuGPDBD3IIhvKVExVvMEfcu0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nN7J3P67uGGIHGWH/Ll0edFHsBSdsOpILeJiX+OxDBPdg7puTFnsMIe3d8YbfOa7c4AKHlLD4al9do14wuKvlBq5It+j1qjJvF55EaQhyTAhj+hjU2eR7JjbaIMLwbawS8N/gg8L/IudbhYJPIP/yg0FSWAATS/xybQSnbtUzbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mzen8RkI; arc=none smtp.client-ip=209.85.215.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mzen8RkI"
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-cc147d86bebso827740a12.0
        for <linux-api@vger.kernel.org>; Sun, 18 Oct 2026 10:30:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792344642; x=1792949442; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3ixHYsvcVa+4o7T8DatH23CM41eHYBblIhIu3k33z0A=;
        b=mzen8RkIKqMI7TjU1lIdnHbzS7VzH+7+3587M2lrbdmQbKevP+rQ6AnGB41fZrMe7H
         1L12pFORyigwSzHMcv2PE80bQmuGJ8CXRC4/4pe8rQHzq9wUU4AYn6xhZp8J32UCTSsc
         3LnuDlph8caZC9YJdYoPVg/B+NC3l1mURD5MZOSV9aJKlLs5joZyl2PWh1wM8t5ibB8q
         tTYZQ+aKW4D1ZtAjQizYm5t63YwJ8lk6/ez9t4kz9MbpWgjAA2yaxzKBB422iL+5DJ5I
         n7mI+UF/yJPCgK/FEzHTvIwrawJ/d4yGcO+v1YGlca/rn05AmwHZIPDHZX2qknYMwdfa
         bgRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792344642; x=1792949442;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3ixHYsvcVa+4o7T8DatH23CM41eHYBblIhIu3k33z0A=;
        b=p6p00bxb90A17rGJ15zX4PDHg6MDbi37OFXkte9gdKSznPamjWbWrLT/Tqmez5SEWO
         szYG8A64y+zRtlZROQ+jX9uTxE7DlHeY5saRzyL4Uodl7G545WBbPLiH0rxxzlnrSdLE
         jK2eMrTNmPsIpBenqIKk2IlbwIEOPkY5GGDK/e3sC97mcp92e7452snCFyE690nA9idF
         AY+hk71OzZDmO6kiNPUWYPE+/Sc9U3sLMMIyPTeAiL7kZMUspewXcC533Pi3ECJre2pk
         pIlZMpH4HYxmP8jqIlEYVxbqoNwg5QT3nFQJ3XDr15Anb2Q4VyD15b6DBe0AjnqVJRMx
         1vZg==
X-Forwarded-Encrypted: i=1; AKwUvBxYJZt1yYJ5LVTeBBEOfch9XmRTEbhwdA2e9TV6Y1/hsL6GClT5hY7uCeul1s5W8HhtIR25X3Vr6Co=@vger.kernel.org
X-Gm-Message-State: AFq9FYKsvdNIxSSL+7ZW7Pz6Wqljqr9f0IAwFZT5h7x+T+1192ZWDmsf
	//Pe2jVsweQ9HUvqZX9gUfPDmIDNTei4g5k3cgGpN3CXvPIrXitseAtfED8wxg==
X-Gm-Gg: AYBFou3PGTCxvAJ6HCU1GP0UgRcoyr2YLmnKhgNQeEPIl/7LjLOz2RM1beVYopjfdCP
	1NE8qPqt7T1kNYQe9lIiKwBIywu5raELLlLOJQkJoYesz/9rr9UKvxBtopnoGYWD2l0gqYn5+dN
	3Y1LtkoaZJhBCQZ9TopZF3AGZN9sqzRk9cxYi3rpz45xcocRtqaYPmboUTqeuS4/MqsBCuDWnA/
	PQJoyflABwL2E6Z2Rj+OQJOUwq2AnCsmWp6GewrPIuzzKt9C1bfnbOGqpEU/7iD9UvQqRVsfruw
	sPzzqoMQWEIO1fqWNwVF3gn31rlFjf09sxU6upakkvSrYCnTVBSYfzsf/lmWNI5V15bUIAYqykf
	7othTGWC/qnAuUAI72uKGnTbrxMsN+4EacpnNhVz6rJWCoSrY2iHYE381lr9t1lcQ4tmLrrorBy
	XOIltt/XSHvOoqMm+5FGcELZkBxy+q23/b0Yw3OFjCqa5bRXU61NU7UPhHKHrUo3Yt9rtUOFHTr
	eskNQ==
X-Received: by 2002:a17:90a:da87:b0:3a7:9ec3:ea0e with SMTP id 98e67ed59e1d1-3acef144e3emr3623867a91.22.1792344642433;
        Sun, 18 Oct 2026 10:30:42 -0700 (PDT)
Received: from [192.168.89.2] ([14.67.155.18])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3acddc37958sm10649439a91.14.2026.10.18.10.30.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 18 Oct 2026 10:30:41 -0700 (PDT)
Message-ID: <fe746c04-391e-4b7e-a5c9-7dfd3cd07913@gmail.com>
Date: Mon, 19 Oct 2026 02:30:39 +0900
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/5] docs: hwmon: Document the uhwmon userspace interface
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-hwmon@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap
 <rdunlap@infradead.org>, linux-api@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <cover.1791531025.git.hurryman2212@gmail.com>
 <c02aeee5b7e7a5d159d4df5baabe925e16814e94.1791559095.git.hurryman2212@gmail.com>
 <e77719ee-c813-400e-b49a-9f8a3b0e2e91@roeck-us.net>
Content-Language: en-US
From: Jihong Min <hurryman2212@gmail.com>
In-Reply-To: <e77719ee-c813-400e-b49a-9f8a3b0e2e91@roeck-us.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Ok. Then I will withdraw these patch series.

But then let me ask you the initial question that brought this patch
series: Do you think it is at least OK to add kernel drivers for
network-based sensors? Or do you think those are also to be subjected to
be rejected (or remained in DKMS projects)?


Sincerely,
Jihong Min

On 10/19/26 01:06, Guenter Roeck wrote:
> On Sat, Oct 10, 2026 at 12:38:44AM +0900, Jihong Min wrote:
>> Document the uhwmon UAPI for developers implementing userspace hwmon
>> drivers. Cover device registration, request handling, notifications
>> and device lifetime.
>>
>> Assisted-by: Codex:gpt-6-astra
>> Signed-off-by: Jihong Min <hurryman2212@gmail.com>
> 
> I am not going to review, much less apply, this series.
> Exposing subsystem internals to userspace is a bad idea and would limit
> future improvements of the hardware monitoring subsystem. User space file
> systems are bad enough and cause all kinds of trouble. I don't want to have
> to deal with the same kind of issues in the hardware monitoring subsystem.
> 
> Interested parties should implement kernel hardware monitoring
> drivers instead.
> 
> Guenter

