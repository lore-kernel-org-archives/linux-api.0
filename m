Received: from mail.hallyn.com (mail.hallyn.com [178.63.66.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A590B471402;
	Fri, 25 Sep 2026 13:06:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.63.66.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790341596; cv=none; b=GXSioNaDm8l/9zjydLPDdJsQpejLc3UAVCu2ipgJK4OUTouWwaezOEhmwqd/JNpUyFZuJNdJFWM+sQ8iuMCtW8S6Ve1vJxdUUs7ymOGMIl8ENe7xN/PJABADEOLWSWJx+Elgj7PhIDCZabOvg79jos4032qIKbRBQSQoGLfockE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790341596; c=relaxed/simple;
	bh=78O9kZWyXHmb3QRI0o3vBS4521JbbQIxKlPpbFqwmyc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iXx2AapK3rERkor4ZFnyf18rBxYUFuQhKVekraRv59zbkwUNyPs7XB2Vpy30Oo9SkG+n59/UaHfBOz6qsaYv53rCK1p1mp7ybKyqQN/2qZS5rx/rYaIc+0LYhUjy8GBw+gmt2QWJpKj/lYYxVrUE8FJA9NQxrzbB7GqjDXAklMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=hallyn.com; spf=unknown smtp.mailfrom=hallyn.com; dkim=pass (2048-bit key) header.d=hallyn.com header.i=@hallyn.com header.b=ZT02gRL4; arc=none smtp.client-ip=178.63.66.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=hallyn.com
Authentication-Results: smtp.subspace.kernel.org; spf=tempfail smtp.mailfrom=hallyn.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hallyn.com header.i=@hallyn.com header.b="ZT02gRL4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=hallyn.com; s=mail;
	t=1790341583; bh=78O9kZWyXHmb3QRI0o3vBS4521JbbQIxKlPpbFqwmyc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZT02gRL4AiFFpPHfcQKgeFCbRmRbcJXdUcJ6QxYGpEcxCPRzvvRXL+tPEq9WkdRJ1
	 w2GBM/E9lSQSuxP8LzcsSWoRJ/iEelqk5YhTzKTrJ9tSW2lMkVeTsOrhIW+wGjOYmY
	 QRad6lFtLh/vnua+fPezbqyH+xzaMqVhsQeJX20Z0FzEv3wBtNrvyouxgCmjjopYyB
	 9Vg+saqgBKmaajMK7H5Iz0vamYk/hIxBx5PEUCQPbBEnLUoojiIRaP+VarCtWij2IG
	 XZE3XCE+O9oVUUcnkHLvAM/A2y4iad2dQ0z1CGMMSSvOLMs03exnDZ8g3y4Rnj47RH
	 9DXg71wAq7+Cg==
Received: by mail.hallyn.com (Postfix, from userid 1001)
	id A470D4CD; Fri, 25 Sep 2026 08:06:23 -0500 (CDT)
Date: Fri, 25 Sep 2026 08:06:23 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: =?utf-8?B?5rSb56We6JG1?= <chengjna@gmail.com>
Cc: linux-security-module@vger.kernel.org, linux-api@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC] Proposal for a standard Competitive / Protected Session
 API in Linux
Message-ID: <arZxz8rz6H6L99l4@hallyn.com>
References: <CAHDTbUFX=8aAQnwv32hqmwHKkeJR0UA5XfZtMZRD1H+kV7uCzA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHDTbUFX=8aAQnwv32hqmwHKkeJR0UA5XfZtMZRD1H+kV7uCzA@mail.gmail.com>

On Fri, Sep 25, 2026 at 05:14:46PM +0800, 洛神葵 wrote:
> Hello,
> 
> I would like to propose an idea for a Linux API intended for
> competitive games, online games, and potentially other applications
> that require a high-integrity execution environment.
> 
> Linux already provides a number of relevant security mechanisms,
> including ptrace restrictions, process memory access controls, LSM,
> Secure Boot, kernel lockdown, and kernel module signing.
> 
> However, these mechanisms are currently exposed separately. A game
> that wants to establish a trusted competitive environment may need to
> detect and combine several different mechanisms on its own.
> 
> I would like to ask whether it would make sense to provide a unified
> Protected Session / Competitive Session API.
> 
> The basic model could be relatively simple.
> 
> When a game starts, it requests a protected session, for example:
> 
> competitive_session_create(...)
> 
> The kernel checks whether the current environment satisfies the
> requested protection level and returns something similar to:
> 
> ALLOWED: the environment satisfies the requested requirements;
> 
> DENIED: the environment does not satisfy them, together with a
> standardized reason.
> 
> While the protected session is active, Linux would protect processes
> belonging to that session from unauthorized interference.
> 
> For example, depending on the selected protection level, this could
> restrict other processes from:
> 
> debugging or attaching to the protected process through ptrace;
> 
> reading or modifying its process memory;
> 
> obtaining sensitive information through /proc;
> 
> using other kernel interfaces to observe or interfere with the
> protected process.
> 
> The exact interfaces covered by such a mechanism would of course need
> further discussion.
> 
> The game may explicitly terminate the protected session:
> 
> competitive_session_close(...)
> 
> Normal system behavior would then be restored.
> 
> If the game crashes, is terminated, or the protected process exits,
> the session should automatically be destroyed by the kernel.
> 
> This would ensure that the system cannot accidentally remain in a
> competitive/protected state if the application fails to shut down
> cleanly.
> 
> A major advantage of this model is that game developers would not need
> broad permission to scan the user's system, inspect unrelated files,
> or monitor every other application.

Why would they need to do that anyway?  What are you protecting them
from exactly?  Cheating?  Secret stealing?  Playing without a license?

This sounds like us going out of our way to enable proprietary software
to lock us down to protect their "rights" - DRM.

I guess what you're promising us is that "this way you won't be forced
to run crowdstrike and tenable and intune to be able to play these games".
But 1. I still prefer to say "then nobody *needs* to play these particular
games", and 2. I could just compile my own kernel with
competitive_session_create() being a noop, so you'd still be digging
around to make sure I didn't do that, right?

> Instead, Linux itself would establish and enforce the protected environment.
> 
> The game would only need to know:
> 
> "Does the current system satisfy the requirements for this protected session?"
> 
> In other words, the API would provide a trusted execution environment
> for the application rather than granting the application broader
> system-monitoring privileges.
> 
> A simplified lifecycle would look like this:
> 
> Game starts
> |
> v
> Request Protected Session
> |
> v
> Linux checks the environment
> |
> v
> ALLOWED / DENIED
> |
> v
> Game enters competitive mode
> |
> v
> Game exits or explicitly closes the session
> |
> v
> Protected Session is automatically destroyed
> 
> My main questions are:
> 
> Does Linux already provide a unified interface with similar semantics?

I think the closest you could come today is to run it in a
confidential computing VM like SEV-SNP/TDX.

> If not, would a Protected Session abstraction like this be worth
> discussing as a generic userspace API?

Possibly, but the first objection you'd have to overcome is that
you are asking us to reduce our rights on the hardware and software
that we own.  E.g. not being able to strace to figure out what is
missing when the software isn't working - yuck.

> Competitive gaming is the most obvious use case, but such a mechanism
> could potentially also be useful for other applications that need
> stronger protection of their process integrity or confidentiality, so
> I do not think it necessarily needs to be designed as a game-specific
> API.
> 
> Thank you.
