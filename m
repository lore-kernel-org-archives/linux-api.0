Received: from mail-pj2-f41.google.com (mail-pj2-f41.google.com [74.125.227.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6911147D93E
	for <linux-api@vger.kernel.org>; Fri, 25 Sep 2026 09:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.227.169
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790327704; cv=pass; b=WZHu9fMfr9rlC6zvbpqfnjmi80ZaFcewRBaFFCSKKD2oUcTr/vVtm9N2dtIWI7qCRdzXM+TiZUG2nSu1r3DIFt6FUWi05deGsz14zs0hraoEu0XG6Ka8MPgoq9Zo3jbohZCMJOSXDaVu1nKbTg3fQkDgP3zEUjtcYk7Us41Gsos=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790327704; c=relaxed/simple;
	bh=p9nwhpNShwsCELITN+2tBnZ+go6kbcsWckBkl8WHBog=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=g0zlaNoHrH58dk8WxpOvfJNKRq4hU/tOd9I9stkNr//qCQ7MLK7E4n6/W+Y4sfDN7aP+lmYxNu9PVsGzMb42anw+JPc2lnKSs5KayZQsKPKiH1+WcWOAdvunCZJsv1OcFRneE0iMzDkcpqvIXyY6ztyS45o6lJTUVGwxc2BycOo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=V+B9NSQt; arc=pass smtp.client-ip=74.125.227.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="V+B9NSQt"
Received: by mail-pj2-f41.google.com with SMTP id d9443c01a7336-2df958a8272so1705445ad.3
        for <linux-api@vger.kernel.org>; Fri, 25 Sep 2026 02:15:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790327703; cv=none;
        d=google.com; s=arc-20260327;
        b=HclFSX/9m/AoLsO7jE1bUGhYPqI+x6iCY/kDHwUMOiVeKEOVLKWqRYD7UXSFdw4cdZ
         YZ0tgxZfFsDvFyZT0Zn5yYeZXxyegiYesriHvo81E1YDKULYoMBXchlTPJon0oTgtY4S
         6Nml7nvDjseDwAh8b7zOEWFQaiSGs6Ej5RaszgWvE/CoF/a2AnkHcTtCDnhB3O9vATos
         ll4lJmM/FDYPnBcQ0vxiCccBoA6jwmdQvn+NRN0nqB2AE6tInogkUtyG/R6AH2O0iPC+
         KhItcOiJ540JaXnavPhRwNpicSCilmAkNpv7Uv/Gv/IYI2cw9ndm37b6rHxJ4MeUF1KS
         IrOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=p9nwhpNShwsCELITN+2tBnZ+go6kbcsWckBkl8WHBog=;
        fh=G1JSHDV/ktx280/GaH8FX16EmG5/AFTIDRxfnDlK/3s=;
        b=IVenJH+3cbdYxvWyS4QHt6aUREzThZDjN2hP76mP8Px5m1jO+FOv5BQ/faSOY2dYSP
         nTSfMg+hxglQbkBFZ98T01LlMJGPFrsX46+zFptEldBmlfW/r14zy9LnZIz/i2Gj0iwW
         j0a05AkK7175ygGU9rywP/kK/yqdNIVp0UlRoir+A9htTA8JK5ihvRuBm5fpLBZgHHnX
         zg8f/6C4lAuv/z6uoxTyfezEIvtzpu72ncnpPQVQnf9ohFbM+mW1yxTV6QvLmPpvKt0U
         gkLUftPJqqQINjbB+Yg6tD4/vh3aB198s6nIA1mgCR4J8EnJf+sFkahlMA0IW+b4xZmT
         48Yg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790327703; x=1790932503; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=p9nwhpNShwsCELITN+2tBnZ+go6kbcsWckBkl8WHBog=;
        b=V+B9NSQtCML/QWFyIgYUTJooTNaBUy75und26GfpBKEljRnZ1pJFMS65J4GeSRi9GV
         yfHv1ZnwVV0KrmtkOQvUI56qcf1x4H3vqWAI06vd2XUXlXSy46dSMIupkqGHu42gtdCl
         7jNhTmP56ejhvCd2BFOOgTK6LqFgYMIvUyme920D4c3dMUnaOKwq2GBkUcEe1dBQbgYb
         Hd5GXcAEULg5qhrjMDIw6giKOP+ShKkAXDBiAAkh7SgagMCklWn6/R8r8d7qFAUyxajl
         HhtQPeclf/FVPoCPAn1rAOZFr84OQN6jLUNQmMX2ldg469CBbDu2FM0mwHh8GD4ac7tQ
         DPuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790327703; x=1790932503;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=p9nwhpNShwsCELITN+2tBnZ+go6kbcsWckBkl8WHBog=;
        b=22zrUxvWYggwu2D6P21kQbURa348noQZZ0J/fEi0EY7nkKMtBWp00kYaLo/nkEG8xS
         wAQ/xXxNNO8R9T1ePXtKBV3Czdq5sRtaLwctwr5YFKABuXKoS6oWR4x8eB4+4d5co2jp
         1tHakU86yibuG7HLQ3BxX6WDFZzpyWch8u5fu5sstP9dD9ZmxSkA+mPsaS8v0WL9jqa6
         6CAnQvOAtrj17/TalxWHQWO0dY5Fq2IOOo3+701fUPkd6/1pIk2/bGtZ4dPXVDZ5i3P5
         /OEPm6xH0kjCB0+xmOp/yo0VAL1wXXAmvVKsLuofX0SHaRq3GEmk67cWL4xR2GPay1ST
         Jf0w==
X-Gm-Message-State: AFuF++mLPxKybVWAIVchbrpu8HklamGHcJmXba52OgpFr9tq2WkRTzY6
	yKI7rOkvas1z9hF/Gpva83ErDXnamCgTzAyveBjzXAjzM9V/IMhfFA6IpFPxghymeyfU4y0fTjd
	fyACHNgDKcM82iRkwGvP9OErC28At3DU=
X-Gm-Gg: AYBFou1DtCtnhkZYAjW/DTFa6tuCjEhBJYaY7bMErl9B4ooDyBrubOSlN+Slz8IOJS5
	+Z06eSPtoIemsNsbSiMor+ZaVpk5iUXLZjAA06XsoI1pXYxtWFqNaRLNDaZuXhtmIhH1o9/j1xy
	Q+Ek8g5KYKMktxu2WuaDXNdC0HTNL4SI58TsetlHOs/pWOwDq4A/OWa8m6mhPRkv93BepauMhTB
	wjDQMtRwa01qK4VxAanMgxTmzucDpbkDhytYrnd4McslgTv9WryDhLaLMbOivlAdx4ZwzjjgxVm
	tgNcZqnCQfroUTOii1ZQLOYxefRhMS54bsUH3DslXFfwIk+7QnSRVA==
X-Received: by 2002:a17:903:324c:b0:2dd:c100:80b5 with SMTP id
 d9443c01a7336-2df7e6644a0mr38012105ad.48.1790327697988; Fri, 25 Sep 2026
 02:14:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: =?UTF-8?B?5rSb56We6JG1?= <chengjna@gmail.com>
Date: Fri, 25 Sep 2026 17:14:46 +0800
X-Gm-Features: AclHuK93wbhjjM2-7srtIZwrbaXXOw3HXafZeMMpj52e39XQN_y1Uupp1neqqdg
Message-ID: <CAHDTbUFX=8aAQnwv32hqmwHKkeJR0UA5XfZtMZRD1H+kV7uCzA@mail.gmail.com>
Subject: [RFC] Proposal for a standard Competitive / Protected Session API in Linux
To: linux-security-module@vger.kernel.org
Cc: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello,

I would like to propose an idea for a Linux API intended for
competitive games, online games, and potentially other applications
that require a high-integrity execution environment.

Linux already provides a number of relevant security mechanisms,
including ptrace restrictions, process memory access controls, LSM,
Secure Boot, kernel lockdown, and kernel module signing.

However, these mechanisms are currently exposed separately. A game
that wants to establish a trusted competitive environment may need to
detect and combine several different mechanisms on its own.

I would like to ask whether it would make sense to provide a unified
Protected Session / Competitive Session API.

The basic model could be relatively simple.

When a game starts, it requests a protected session, for example:

competitive_session_create(...)

The kernel checks whether the current environment satisfies the
requested protection level and returns something similar to:

ALLOWED: the environment satisfies the requested requirements;

DENIED: the environment does not satisfy them, together with a
standardized reason.

While the protected session is active, Linux would protect processes
belonging to that session from unauthorized interference.

For example, depending on the selected protection level, this could
restrict other processes from:

debugging or attaching to the protected process through ptrace;

reading or modifying its process memory;

obtaining sensitive information through /proc;

using other kernel interfaces to observe or interfere with the
protected process.

The exact interfaces covered by such a mechanism would of course need
further discussion.

The game may explicitly terminate the protected session:

competitive_session_close(...)

Normal system behavior would then be restored.

If the game crashes, is terminated, or the protected process exits,
the session should automatically be destroyed by the kernel.

This would ensure that the system cannot accidentally remain in a
competitive/protected state if the application fails to shut down
cleanly.

A major advantage of this model is that game developers would not need
broad permission to scan the user's system, inspect unrelated files,
or monitor every other application.

Instead, Linux itself would establish and enforce the protected environment.

The game would only need to know:

"Does the current system satisfy the requirements for this protected session?"

In other words, the API would provide a trusted execution environment
for the application rather than granting the application broader
system-monitoring privileges.

A simplified lifecycle would look like this:

Game starts
|
v
Request Protected Session
|
v
Linux checks the environment
|
v
ALLOWED / DENIED
|
v
Game enters competitive mode
|
v
Game exits or explicitly closes the session
|
v
Protected Session is automatically destroyed

My main questions are:

Does Linux already provide a unified interface with similar semantics?

If not, would a Protected Session abstraction like this be worth
discussing as a generic userspace API?

Competitive gaming is the most obvious use case, but such a mechanism
could potentially also be useful for other applications that need
stronger protection of their process integrity or confidentiality, so
I do not think it necessarily needs to be designed as a game-specific
API.

Thank you.
