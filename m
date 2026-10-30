Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=209.85.219.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1793322163;
	b=Nhv/VSaXf5cUzLSr3RdZn3ZNfomiEgm0zC6VBd6BJdSCzQ7fYc1BeFlW46zmOeK7bulh
	 M5nd+JX+QNMS/4qW9uZvk2gvBOec+suUgJpJUAptAhpKVf9a5h9iv8DfF5gwB532JwFEH
	 wkiI1Ci/ebxmnH6DJe047sMGe74j7aBJCOaUGfgxgEYO6aRYK0JhVT64/4zOLci2n5Q2v
	 lOmubCAKlk1WJ5mtemaFSDO9psUlEqQSsb3RsrRaQJmO+7Hum4jw0g4fwJ+W5305Hiw+i
	 MC3HlRoMvIy2sdO9tE2QgSMgIwzRXb0vg9je28pS5AEmf2XWVbrena8URf84CNQR//w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793322163;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type;
	bh=SZvmD0cJyfgbDaWm1GDvW29zuwyZyXicGYmT+t5443A=;
	b=Kmw2VqinJRGihPyy1nXKuKpfZLC47WMmrYPCNEujKq0gqty7HjW4CT0CnZRm6GO66A6A
	 X1gL7KgqVYUxvq/jEaAJ457RO/LNG/aheHiLb2gosVr5iU3+ikIXEq/6EKtd3KPpKivM5
	 wBdRoN0GoeFL3wwJDwpZ6Zwl9kUUhTYiS2QyP70TxdIV8oH0bWkmVPhu4+W0KSMd423d2
	 yjV9jeor4ND8+oxUhHb0pYgWyMyw+OIkgQvWKT8GPSUjc0EGMSn3P3EyA2HXVk8VSPB2l
	 ZZJNHcJJGa1TtZlr3Ysf4e6yu4WuGkF7qocLjmRiKOVw28yJ4JsUuxVUnlxlpmgXApA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="C3vT/wK1";
	arc=fail smtp.remote-ip=209.85.219.42
Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17CDD606A31D
	for <linux-api@vger.kernel.org>; Fri, 30 Oct 2026 01:02:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 17CDD606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=C3vT/wK1
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-91c60e30054so2127176d6.1
        for <linux-api@vger.kernel.org>; Thu, 29 Oct 2026 18:02:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793322162; cv=none;
        d=google.com; s=arc-20260327;
        b=qZGbf4ps0fKtD6Hl0LF4uKD/xg4tQk8cjgEL2jSnICOw9ei3/lcUOC0dzqtMwB46G3
         bhjf8gtsJGMRt4SlEnnUPyC8pqII03NBjRzZZA61xIEF7S76EZbsjFw+UMVyyp95jS30
         xDA46gJBf4jugpzq5MfE99MuD0sdhrSs5ZQx1E+UMYxijygLh/F1erhZVi86cQn1HkIa
         5x5PaRTZtSUs9zLGpCMvWNvUbqUvGxIt9zYo/TAwrgpd/pqt3IBexq7n/MNuIHE+LiR2
         27radCO8/iY2GWIxkkL61pA/0HIFJ4URCcBjWcAmnRWjzBZbQA5+p81sATOvbCfSXtuw
         UKZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=SZvmD0cJyfgbDaWm1GDvW29zuwyZyXicGYmT+t5443A=;
        fh=uxU/JoE5cyPfWEUJronn8g9pS0wFgYlzjAcziWd5y0Y=;
        b=JaARu8dB/T9MB26lNjadQJDyCCkLuRWuIRfSxF5Uv0R/gT2rmUdSU0tyyqJGmRlAEI
         ZwctUElrKD+G+btm9krHFsQO5V8QFQx7Wglrn5Ruuo0cLoUcTqhadZfRp0NkF4X+zj/Z
         D/uA0Lzd1SVu1w5ljkx6PBRwN7vKACUcsxXWABDd7xeH/75SIEdOBKigNk4KayKndaXT
         3WJKd4cP21+AZNKQq6bf+LER1g/CajVGG3p/qL9Fnx9lSGQ1GN4nUDQxQiMnCOeXtylF
         sVIOslexJV/uGuUv2UN2gMsy0kPAq+TK3/hlz7jzh636IsxByv7v3cQyi1GRld2GCH9z
         h6ug==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793322162; x=1793926962; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=SZvmD0cJyfgbDaWm1GDvW29zuwyZyXicGYmT+t5443A=;
        b=C3vT/wK1BPu8PPcF5kTaY8t1PR5lITtEja12EZpSrMn4ii201Xn6Jsa6rG9tyaCco2
         S7VuTWBhvzRWPltnhSWolorueUAWljvs33BbqB5IC2kWaIV4ym07QNLaTuQG2NuoNcHu
         bqi2ZEnXcOIMhbq6jnKVcFq7K42AqzOJ7Zrz9txJiZDx1Cdit1OYTsWopNkYDfUEidFB
         Ox3mMErQ1xXS0xpvtLhPnz2qOfapwCUawautzoLQnfypMUHbxi24n9mwJhx9Y/Eb+zlA
         mYlLGalbLrIdYQ8y/msECJ4wfX4Esb2djfWbqBFo9g8eeiq3sbD4EIyqpx5ReRilnIDd
         Cosw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793322162; x=1793926962;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=SZvmD0cJyfgbDaWm1GDvW29zuwyZyXicGYmT+t5443A=;
        b=yh/78mylCWI0XAN2wNPWiuvafbyL72/Ix9bMUgUd3tdbfZqAO2Qmd+QKpytwJ3HjMy
         nXVQQLbzNiHEa635m/FmKzslzO7ewBbZKst3mGj3Zr7fYLVm6Lp/nVIVsBL1Tlws3hBu
         OCpK1hfe6Vh3MbIw+/tsuRvV2FQderCLW9JWYXedvWfbHG+401Hh36Ha1mR2/llj1YG6
         0UN0Y8r47GZ0ejhqgGycjObmFK5bNx/m6yBWVc7CJqt+DOoQZly48X10XM1BbMeQhUJR
         R5rZod1tpg/jVo8s+thM1tPZzB3JG+uVErdEtVYgwOAuveNWd77e1tEsfGolPo0q23m9
         z9cA==
X-Forwarded-Encrypted: i=1; AKwUvByvJHQ3WT+bTtNYdqYF80uTkKocOojY2vPIYkVcdqkUVjbKnA3aMe7fbgWP1U8M7oFHjeWo/x3hMv4=@vger.kernel.org
X-Gm-Message-State: AFq9FYLdnyxcDXYNYA3CTlJaKwBgSrSYV7uQ+ugWufd2Oar+lGjXEBZK
	eDCeybOVE/1JgFGZMvymxlVQ6h6eAiTutWhM74aFB/mjFbk9I1yKjGJ/GQKpnZQuJ9AbrdN2l/b
	J4xwErMY8r1bGS9tQJc/Feaur7LGz0VE=
X-Gm-Gg: AYBFou0ClYLhTb6x+IDZBWejw6osvek7s6QpCdoshl4TRcyLMDqF/7vCW4UgrR/uFXb
	bJaMwA4oM37lfyNDsbOLEvn/x9U0t/f4dLIkj91wk3JWB1RXvc2iSOnKgj7mGW8VhIfhBE0EA5N
	7Ok2gBilwQWk01X7I7JaeddHQfPxvc8daSs40pPXTEW947tpIGClEPqbFqCYutvz68xoQKmabS/
	lRmkw7lOneW+XEjsB7Ej1mJy1gNUNpyPyBTEDAs/iOtkaFQmpAPiSK5Yat8P/51rnRs+p+heyzy
	hbcy48mZxcETGjMWo/KFhrzx8/AcLG6XknhEgazIMsqUyPC254v5W5VQ1WZCxFDkDaAru3lZ1MR
	5O4p1pQMyIP1lIf1yMjigHP8s8CeIBImnv766Hn+9o4zIqIfOUZ76HDnQel23QWqT8GLQ+Xb7vx
	8eRgunK9WK+S/TvyHjCMdrRpSC1wEObGULe81IHZ89yHksbgoD+h743L2NvAdxEbkzP7Df7nMas
	Y58lFiz23COAZVCkA5fg7BHWZ6Dqcztqdg3BPfjAtqqTC6Z
X-Received: by 2002:ad4:5ca6:0:b0:915:e5c8:5663 with SMTP id
 6a1803df08f44-91ca4a0cfa7mr11886956d6.4.1793322161725; Thu, 29 Oct 2026
 18:02:41 -0700 (PDT)
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
From: Daniel Pereira <danielmaraboo@gmail.com>
Date: Thu, 29 Oct 2026 22:02:29 -0300
X-Gm-Features: AclHuK9pTotqg-4NXfN0QGNmi4zl63SrTrsIxEaA1R26_yNKaDtcg8Q4fwZl0Kw
Message-ID: <CAMAsx6d68k49rTNqzJwvZxq-+JZnVKGo7oovnhk_49R3JeP_tg@mail.gmail.com>
Subject: Re: [PATCH v4 2/2] Documentation/ABI: asus-wmi: document TUF keyboard
 RGB attributes
To: bartualev@gmail.com
Cc: corentin.chary@gmail.com, luke@ljones.dev, denis.benato@linux.dev, 
	hansg@kernel.org, ilpo.jarvinen@linux.intel.com, 
	platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-api@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 29 Oct 2026 02:48:52 +0300, Bartu Alev wrote:

> The kbd_rgb_mode and kbd_rgb_state attributes predate their
> documentation: they were introduced as write-only interfaces and never
> received ABI entries. The readback support now being added makes the
> omission visible, since the read format is part of the interface.
>

Reviewed, no errors as far as I can tell.

Reviewed-by: Daniel Pereira <danielmaraboo@gmail.com>

Thanks,
Daniel
