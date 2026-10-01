Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F4BE51C058
	for <linux-api@vger.kernel.org>; Thu,  1 Oct 2026 15:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790867458; cv=none; b=dFj71Qqa/UcGudAqQ/37pMd/gIXg1HJ8G3BJpSF+t2TC2HH3UAcCINIyY0HiuW4TobTuH/FUp8+7lAMgJWEaholvVUqyfR9ROXnf0U/I0LPcUgoOfwHzEeKK5JjObtdzivDsT44lM787v+nVhfVvpjKQiOiIOJEs3BMvImWLJJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790867458; c=relaxed/simple;
	bh=v/g5V0DvX7DbXaWcxFQ+1tPtcUqZhm9i5DBwg6+5XvQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=i1oHffcUlf1VJDqXhCcucVGwDzSCUYTt6jkSTMBzARbvRD4ObNi13d/MPDuvU6LKoHGxcK/wSZ4shH+j2rE/EPapbgCsxAXDYrCr/ng1MOoVxaKamjCyKYnM9+en4UJQIWGS5plMs3FsH969isJhD7fooy0whvdefYnzExMCCHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=AiP95NAI; arc=none smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="AiP95NAI"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-4a006bb267eso25609635e9.0
        for <linux-api@vger.kernel.org>; Thu, 01 Oct 2026 08:10:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1790867454; x=1791472254; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uEqFwwmiLgxzbUfdtxr/SjfsZs2IKekOzMd4LW1gk/0=;
        b=AiP95NAIGlVILCdx2fiDa96u9dnETu0eV6g2YlJVBoBtvumBMglaWOXWFSV84t6/kz
         BqOsphx4VuiYuLRPu99byiKeo8RE2xooIDYIHfbh86TZkkv/5UeVSnstEr8348Rz46hZ
         fve2SenUs/pMePKaFO4+N1wd1ixb8hEaZN5poOv/ul25F2BJ8HpDB1gllxiD829mumCo
         KwMqRHG1dPu5KZz2QJQ8Nw84T5h2jVBTdjFjfgHVSIpynmep6z56Mo6OL//CvuK2cJIR
         lzjG/fg06VwwJIAAujnM6PMf0N+p3DPRGdZnLrjVb5AzeoHbOF6WDB6PB/4aecr4uK+l
         Ck5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790867454; x=1791472254;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uEqFwwmiLgxzbUfdtxr/SjfsZs2IKekOzMd4LW1gk/0=;
        b=ujBlBQeW1N7Dz5nfy2eThuFCQ50Ult+yDZTRAAc6ArV1zZmjCQWoB5fZSzaTYGUShL
         qcrCpsRww7lYU9Kt33hsVgMewOxus/J98OGovgnJt8EsgNyBK6ZsMoAJ3OCe/GaPG4xW
         Pef13y6hRpDsTxM6wcKhy3bQwyxSzebJAiGlfyYRh73KrU8upntkEGFhHk3RAdfxgUSi
         7FiOUAEQQorDXE1URzeAtJtK1yN0G4ClYgSQl78Uy0an1Pc1AlNNdwDk2oG5cjZX7IbY
         YkMVGceePBDAGz29EmPNQ2tBHj1ar6Bd2lVQyvZah5jdrulrjmcNl5CqefarB5bM8e5b
         H1nw==
X-Forwarded-Encrypted: i=1; AKwUvBw9HxNhRBNw0cVgYGZSICdGhTQ8/o1n3GRiW1XxWUkJNI/A5p+vOcWKhHFkAsrmNm2E7D4xVThhR68=@vger.kernel.org
X-Gm-Message-State: AFuF++n6TgNAlQmwc9btId9ST4OivWMlrrMt9JfXtjUT3V1nFN88bFCL
	HPmTCbtXeI+jbmjM6nMUcfTjrUe6CaWluqK0qOQmgDxtw2kD+yL6nkkmflXIPjCeNEM=
X-Gm-Gg: AYBFou1yaLQPxvBmpx2FNpJozyxYfkcLREO9X6mwL/AOFNSA+4Ho1JvbDWn6B8Hl1M2
	8/pqiKpTRXlhrRK3aX7eSgiAB3MkK3aQRm+H0b1F4AhQUWKyOXNI4gtsJr9I7PFX7rCtFZzT4SE
	+S63sb3IedaDcGCK1vAX8QltyHUZpvWE4rqN0i5xC059w3Yg+ZTbB33nV8zXkRDI5Lwj+sm3zT+
	7JUofaATw32Y1f647HP8tKjujFep/pPk0p13bmQCr0a8adnUVRDZAU7RkjthkBtL2QmGg/j9STs
	gXyMXl/UUluKSpjV7vhLHt6BgLJi30uqq33s94xiHuKt7KTQUW6lQDLkoSbHuE7ZJRWyv7oKEd3
	Rz3Qi0yvgtQVPzt6BpyZ4+9SpNGLVUBHEHoZBGwMbpNiO87d4zYBVowmIthNvBKG7gB6RKZ8/6C
	yPZPPAH7ZPWy4SBTVZ0jdbzCI35dTBXcq0pBXXKOIN0MjFCuNwiLiesRuoYTv4bJtke8Y+R21lK
	JEm82lZUOalzSVcc+ml3AtFUKb5Goi05fU=
X-Received: by 2002:a05:600d:8499:20b0:4a0:1e68:d27d with SMTP id 5b1f17b1804b1-4a01e68d354mr47259215e9.9.1790867454233;
        Thu, 01 Oct 2026 08:10:54 -0700 (PDT)
Received: from ?IPV6:2a07:de40:8100:0:89a9:fd0e:583d:4a53? ([2001:af0:8000:1409:193:86:92:181])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48b06a2fc98sm6247090f8f.35.2026.10.01.08.10.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Oct 2026 08:10:51 -0700 (PDT)
Message-ID: <ca910292-5d3d-47b5-ae40-7ca1688f3c06@suse.com>
Date: Thu, 1 Oct 2026 17:10:50 +0200
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/6] Remove the error-injection.h include from
 linux/module.h
To: petr.pavlu@suse.com
Cc: Jens Axboe <axboe@kernel.dk>, Jakub Kicinski <kuba@kernel.org>,
 Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Paolo Abeni <pabeni@redhat.com>, Jani Nikula <jani.nikula@linux.intel.com>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>,
 Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
 Tvrtko Ursulin <tursulin@ursulin.net>,
 Matthew Brost <matthew.brost@intel.com>,
 =?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
 Simon Horman <horms@kernel.org>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Francois Dugast
 <francois.dugast@intel.com>, Luis Chamberlain <mcgrof@kernel.org>,
 Daniel Gomez <da.gomez@kernel.org>, Sami Tolvanen <samitolvanen@google.com>,
 Aaron Tomlin <atomlin@atomlin.com>, linux-block@vger.kernel.org,
 netdev@vger.kernel.org, linux-api@vger.kernel.org,
 intel-gfx@lists.freedesktop.org, intel-xe@lists.freedesktop.org,
 dri-devel@lists.freedesktop.org, linux-modules@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260911-module-include-error_injection-v1-0-5da895d8c84d@suse.com>
Content-Language: en-US
From: Petr Pavlu <petr.pavlu@suse.com>
In-Reply-To: <20260911-module-include-error_injection-v1-0-5da895d8c84d@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/11/26 5:04 PM, Petr Pavlu wrote:
> linux/module.h appears in roughly 15k #include directives across the
> kernel. This makes it a "hot" header, so it should avoid pulling in
> unnecessary definitions.
> 
> The header currently includes linux/error-injection.h to obtain the
> definition of `struct error_injection_entry`. However, this is unnecessary
> because the type is only referenced in the file as a pointer, for which an
> incomplete type is sufficient.
> 
> Add explicit includes of linux/error-injection.h to files that use the
> ALLOW_ERROR_INJECTION() macro and currently rely on it being provided
> indirectly via linux/module.h. Then remove the linux/error-injection.h
> include from linux/module.h.
> 
> The first five patches can go through their respective trees if preferred.
> The final patch depends on the preceding cleanups.

I've queued the series on modules-next for 7.4-rc1.

-- 
Thanks,
Petr
