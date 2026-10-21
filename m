Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792599929;
	b=b2GSM3otSUgG1F9z/WZMQIZ6ZMbKAkL1GbAY4vhhhUmfn5L57AhvxYlWwJPqSWO39FxA
	 aLKTC9EHylrYyQNphCCbS9Gimtiy0qxyoDfyj2YVoI2tSDj82Nx64pn1vfoNNlakEROxx
	 KMIh6mjJG/3D8NlbsUi7iJndtt22ILwkf+TAuEdOvKuTfCRNN19ejWZCFjnbls7WzV8J2
	 bez8wsn9/8XisRwl36Xl17YH73LoJzmD5tvw1LWLHdxK2f97/YZ1cpt8JsLX9vpbTZ/dC
	 yNI7Hb/KhYLg4M1K85yXuwxsClV6V30y9L54Dd/9gBtiXNqfU+Gtcj/N+ZlxkUQXEzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792599929;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=wTPDb7LIMtyEiz+mqYTBrrnJbHRN01tnFVsBBXNS8TY=;
	b=zu/IuO2o+irIaQ5gLUg/VZL/t+0/P2JKm90HA/CGD26X8wbALGc8QpV2SRjJ4xezv3Jm
	 mj1W7e77rWZ0I/tk2EC59odbox/qKzuZYBuP2r36KfsKGSpj440xVBjo7XG9JBsl9684m
	 y1sMntfr+4bVDHHPH6bdEJsozACSEd5VypV5tWN3J7VK1G4DhWStIqUYQivP7DYSTVu49
	 mxcxpKXJZ7kNrAiNZe5F44ozwxLuYVUFj0gkwr+V5pPhBPqrMeLVjJzQtcwK61YABmoyh
	 DGeSZCEEbRuIT/aDG72oNH8Nm601ZxG+4D7jM3U0bEZWDJFI4sa+i09lEclIflstusg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=resnulli.us;
	spf=pass smtp.mailfrom=resnulli.us;
	dkim=pass header.d=resnulli.us header.i=@resnulli.us header.a=rsa-sha256 header.s=google header.b=nLldAXVT;
	arc=none smtp.remote-ip=209.85.218.50
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5372C606A31B
	for <linux-api@vger.kernel.org>; Wed, 21 Oct 2026 16:25:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5372C606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=resnulli.us
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=resnulli.us header.i=@resnulli.us header.a=rsa-sha256 header.s=google header.b=nLldAXVT
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-c445c95d553so121140066b.1
        for <linux-api@vger.kernel.org>; Wed, 21 Oct 2026 09:25:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli.us; s=google; t=1792599927; x=1793204727; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=wTPDb7LIMtyEiz+mqYTBrrnJbHRN01tnFVsBBXNS8TY=;
        b=nLldAXVTDBPyUo5rQiH6wJRPeyGlMCQokaHib9EKVjff54+owMFh/Qp6vjiMk7Qk9j
         Qw+uzHSbcliTiERA0MKT3aFKpoekS12Hvsh9Eu61qJtAeSbh076VpqH6PzpIANmxvzvR
         IIwu8ZpXtSEz2iLmnRTJ3wC8qnPTWFM9COcSV9n46v+qVVAMc8C5NPsKz4iZiJl1gqxV
         d/kjXe0ZI1uEOwAcqMf+EadGjSx7dDpqLNGDKteo8my9cQRM/F9j+a6JqhC+sRPFku1G
         AyWSyMLmA3aLlvzRGRLhsZOdo/O5HostYUr1lniO+arQMkLuMwMSMkVgsTPBAI9MfX2y
         6stg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792599927; x=1793204727;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wTPDb7LIMtyEiz+mqYTBrrnJbHRN01tnFVsBBXNS8TY=;
        b=yOpJNHm4reaTJ3sRTzr2uOoOO6LJliGAg3knLXa6D26DOKnw47csp4UbeY4EM2bXB9
         IQ9rPAOSVJ1vIt0RhjOVr4BkJXbws8nQ9IWxLUGeT/gQUzW8JdhRGLeP+2vk93PWlq4b
         GwTdsUV/Sq0TpLNo9rGQ7lLO0BIN6vl4kLnKozF48kq26nhOMXEHhLFo9crpOCjyxv7L
         0dxrrzN2qUzVBMadBwb4B6RvJ4QsirVePv45JHC4Jn5xShsRiRN/cau7fT89VCCSDlcB
         LPnfrS+bpt7Q3ZAIQYD9PGxGmZWgQvy+qWs0AU9SLeIiRJXR4d9hByt7L3ZF6JRYPliO
         HmKA==
X-Forwarded-Encrypted: i=1; AKwUvBxLQSlWzzvykJItrhkPUw97aMYTlX7ucl4t+1Zf2TDDP1C8bGrgLylfbpHR5Gx3zt0VVry8xAq/C58=@vger.kernel.org
X-Gm-Message-State: AFq9FYIbBSZxZZ9+vxciKxvRODI9MOZKRPcsWzrGbRH/FR99HlVv6mg8
	0FqKEHY3Rjp87Riw8USCy/0m0ZpN1FJ1q07kMJb4mIGnGUOkfB54IOCerZYhcgYwlOU=
X-Gm-Gg: AYBFou24f4CaBcn2nVmEEhtFnN7PwWk5kDkhbgieKxorshrCRXWEHcb1dF48OaaWxEL
	PvPUrIOd565aHUdP6MnG4zFny3HIT0uOF/iRVfbCyOhZe+YzuBN5u139moxaeKBXUG6W4zd+7wq
	XVyL4PH8KaeeZ5SB5xTxKJXqxLTkhtOHzJO9UaOJdm5g4kj+a8/3k44vM1qLdzH/5NkGwPKzaqS
	7A1Jl1LLtM/qS51Non5b5FonvfhkYKBHlK2sCMTd+LaAGa7E2GRDxL531PpXGXxdddPRszX8qRQ
	vJMiyO75eGNEPpUAxy5jkj6EJoxCw9aa4/xVjdrVNr3FmvjoVWCdKbjHimgbupJig5U8BMGM+9X
	MMjpy7EiwCML2eDvjZ9g4mYDCAVmH9DTjRKdQmraxv5kJODhmvY3N5cCfwqVXJl469amrFdndYh
	80jFU9iQueqWsjNL8LC5g3UaBei71OryOQRwd5+BnHLxeISmTptx7Q0kfUDyQd1SaXMRHtPBy8v
	YmUV0Wn3YlV4pxDq91Zs37ua7Jcfakqbe1tQI1zPPKoxKhM5Y5a4XjX04+Ga21m+ThQ
X-Received: by 2002:a17:906:dc91:b0:c27:420b:7c79 with SMTP id a640c23a62f3a-c4679a40b62mr221295166b.48.1792599927374;
        Wed, 21 Oct 2026 09:25:27 -0700 (PDT)
Received: from localhost ([140.209.217.212])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c468a6182e8sm17768966b.81.2026.10.21.09.25.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 09:25:26 -0700 (PDT)
Date: Wed, 21 Oct 2026 18:25:23 +0200
From: Jiri Pirko <jiri@resnulli.us>
To: Jonathan Cameron <jic23@kernel.org>
Cc: linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org, 
	linux-api@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	jgg@ziepe.ca, david.quigley@intel.com, lukas@wunner.de, ksinyuk@kernel.org, 
	rodrigo.vivi@intel.com, cedric.xing@intel.com, sameo@meta.com, drdeeglaze@gmail.com, 
	James.Bottomley@hansenpartnership.com, aik@amd.com, jpiotrowski@nvidia.com, qinkun@google.com, 
	pgonda@google.com, alistair.francis@wdc.com, ankita@nvidia.com, 
	suzuki.poulose@arm.com, kas@kernel.org, rick.p.edgecombe@intel.com, 
	elena.reshetova@intel.com, dave.hansen@linux.intel.com, 
	sathyanarayanan.kuppuswamy@linux.intel.com, peter.fang@intel.com
Subject: Re: [PATCH RFC 03/20] ctlv: Add the root family specification and
 generated files
Message-ID: <atjnZ9oVYZN1VnwG@FV6GYCPJ69>
References: <20261015145053.3664509-1-jiri@resnulli.us>
 <20261015145053.3664509-4-jiri@resnulli.us>
 <20261021003056.354a40ad@jic23-hlaptop>
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261021003056.354a40ad@jic23-hlaptop>

Wed, Oct 21, 2026 at 01:30:56AM +0200, jic23@kernel.org wrote:
>
>> diff --git a/Documentation/ctlv/abi/ctlv.yaml b/Documentation/ctlv/abi/ctlv.yaml
>> new file mode 100644
>> index 000000000000..fa11bce98f46
>> --- /dev/null
>> +++ b/Documentation/ctlv/abi/ctlv.yaml
>> @@ -0,0 +1,186 @@
>> +# SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause)
>> +%YAML 1.2
>> +---
>> +# Checked-in ABI snapshot of the ctlv family, written by
>> +# "make -C tools/ctlv abi-update".
>> +#
>> +# The checker compares this family's declarations and inherited stub fills
>> +# against this file. Updating it is how a UAPI change gets reviewed; an update
>
>Slightly confusing text: 'it' is unclear, checker or this file?

The file. Will reword.


>
>> +# that removes or renumbers anything, narrows a bound, or makes a placement
>> +# required is an ABI break, whatever this file says afterwards.
>
>
